import { TerraformModule, TerraformModuleUserConfig } from 'cdktf';
import { Construct } from 'constructs';
export interface ServerlessApiStageConfig extends TerraformModuleUserConfig {
    /**
    * Allow Objects in the bucket with a Public ACL
    */
    readonly bucketAllowPublicAccess?: boolean;
    /**
    * Set the bucket name, default: var.repository_name
    */
    readonly bucketName?: string;
    /**
    * Create an S3 Bucket for the Service
    * true
    */
    readonly createBucket?: boolean;
    /**
    * Create SNS Topics for the service
    * true
    */
    readonly createTopic?: boolean;
    /**
    * The domain for the Serverless API
    */
    readonly domain?: string;
    /**
    * The name of the Serverless API
    */
    readonly path?: string;
    /**
    * If true, create a regional Serverless API
    */
    readonly regional?: boolean;
    /**
    * The GitHub Repository Name
    */
    readonly repositoryName: string;
    /**
    * The root prinicipal. In most cases leave this as 'root'
    * root
    */
    readonly rootPrincipal?: string;
    /**
    * Output of trust from saml-to/iam/aws module
    */
    readonly samlTrust?: any;
    /**
    * The stage (e.g. live, nonlive)
    */
    readonly stage: string;
    /**
    * The KMS Key ID for the stage (optional)
    */
    readonly stageKmsKeyId?: string;
    /**
    * (Optional) Enable a websocket for this stage
    */
    readonly websocket?: boolean;
    /**
    * (Optional) The custom domain for the websocket (if using a custom domain)
    */
    readonly websocketDomain?: string;
}
/**
* Defines an ServerlessApiStage based on a Terraform module
*
* Docs at Terraform Registry: {@link https://registry.terraform.io/modules/scaffoldly/serverless-api-stage/aws/1.0.41 scaffoldly/serverless-api-stage/aws}
*/
export declare class ServerlessApiStage extends TerraformModule {
    private readonly inputs;
    constructor(scope: Construct, id: string, config: ServerlessApiStageConfig);
    get bucketAllowPublicAccess(): boolean | undefined;
    set bucketAllowPublicAccess(value: boolean | undefined);
    get bucketName(): string | undefined;
    set bucketName(value: string | undefined);
    get createBucket(): boolean | undefined;
    set createBucket(value: boolean | undefined);
    get createTopic(): boolean | undefined;
    set createTopic(value: boolean | undefined);
    get domain(): string | undefined;
    set domain(value: string | undefined);
    get path(): string | undefined;
    set path(value: string | undefined);
    get regional(): boolean | undefined;
    set regional(value: boolean | undefined);
    get repositoryName(): string;
    set repositoryName(value: string);
    get rootPrincipal(): string | undefined;
    set rootPrincipal(value: string | undefined);
    get samlTrust(): any | undefined;
    set samlTrust(value: any | undefined);
    get stage(): string;
    set stage(value: string);
    get stageKmsKeyId(): string | undefined;
    set stageKmsKeyId(value: string | undefined);
    get websocket(): boolean | undefined;
    set websocket(value: boolean | undefined);
    get websocketDomain(): string | undefined;
    set websocketDomain(value: string | undefined);
    get apiIdOutput(): string;
    get basePathOutput(): string;
    get bucketNameOutput(): string;
    get domainOutput(): string;
    get nameOutput(): string;
    get repositoryNameOutput(): string;
    get restUrlOutput(): string;
    get roleArnOutput(): string;
    get rootResourceIdOutput(): string;
    get s3TopicArnOutput(): string;
    get stageOutput(): string;
    get topicArnOutput(): string;
    get urlOutput(): string;
    get websocketApiIdOutput(): string;
    get websocketUrlOutput(): string;
    protected synthesizeAttributes(): {
        [name: string]: any;
    };
}
//# sourceMappingURL=serverless-api-stage.d.ts.map