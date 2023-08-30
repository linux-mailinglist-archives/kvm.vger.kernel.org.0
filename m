Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC8E178D956
	for <lists+kvm@lfdr.de>; Wed, 30 Aug 2023 20:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234320AbjH3Scy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Aug 2023 14:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243452AbjH3LDJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Aug 2023 07:03:09 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2070.outbound.protection.outlook.com [40.107.102.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584691BF;
        Wed, 30 Aug 2023 04:03:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LDOiGkLEa8RoiStQy9GPnh8qLNDqAf2O9aQRMi7mmEP6Ddrxry8tu4+KFrKPByV4EFHEJw1SlmArXxug4wgg6lI766dT4HLrQtVAnE6i1NGc5zkn/MNlP3rsbTWeG7g0UN6m7ABGm2XgwVlk23X3FvDHGVB35nGEXJtOwMe7W2wlYyD94CxszYAHJ8WZIPhs5U3JL29bA02vDybT9IY602GNsL/KbqA+cs4aJr9WdK20Coxff4uEPCxxqY8TATo4Bg4hw2EfBjbD8S4aiajUpInhb8NnKeKHU2kzgrCVsPjyzH1WGUnob312Qj6sM1soJ7BsMPQi4rQM8oibsfQbEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9wisDmlwUbXxPiVaS6D3O14Q/d8B8Q5W/mOeeSE6E5c=;
 b=XZtLiim+UV+lxvXQkAeICeTFxHmHFh0/xNwj9wcH6fsKQPdPKMW7OAEgpkL4jDMuGMNn0fpePBpl54pm2qnn5yjY4bK/rZgDtEZt51c7bO9YQUWVz5mhWMs9S8Qrr/pLx6sH6Sep7yrqSJcJwD+oX7/0YRHrLijOle9RI/2FthFbvrfoJlOWWKCZTzZDbGxVluvtYmKrABMjjgaCGGWizLtZMVJRNIeft7IyoPQfAKzeFvYT8Wyxv0M4qKrCqxmuvJFJx3VHhiY6kWep+R9oqqSG0HHUXHS97PXaI/Ndd0nhhPbRBwH+OPJzlukREyN3Fq0J4he/Mx3Enb0EfYkK3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9wisDmlwUbXxPiVaS6D3O14Q/d8B8Q5W/mOeeSE6E5c=;
 b=qVsSdr7Km6XFTGhBmi7IlABEM96PA8IikkbpF7TDaLWWkMRcSMj7ebv+FhkNL+yYWUzI3m4FaK8PD5ip+prOGabnuL9fePCdeOA02lpQfGPSJFcwvoIuNB8qM6fkJHkE7sqGh55jAZRnvkoqyzwVd7rf3LLAmmeLkxWS8a7LBKU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 IA0PR12MB8975.namprd12.prod.outlook.com (2603:10b6:208:48f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.36; Wed, 30 Aug
 2023 11:03:03 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::67ec:80e:c478:df8e]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::67ec:80e:c478:df8e%7]) with mapi id 15.20.6745.020; Wed, 30 Aug 2023
 11:03:03 +0000
Message-ID: <a4fc5fa2-a234-286b-e108-7f54a7c70862@amd.com>
Date:   Wed, 30 Aug 2023 16:32:47 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v4 09/10] iommu: Make iommu_queue_iopf() more generic
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Baolu Lu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230825023026.132919-1-baolu.lu@linux.intel.com>
 <20230825023026.132919-10-baolu.lu@linux.intel.com>
 <BN9PR11MB52762A33BC9F41AB424915688CE3A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <cbfbe969-1a92-52bf-f00c-3fb89feefd66@linux.intel.com>
 <BN9PR11MB52768891BC89107AD291E45C8CE6A@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <BN9PR11MB52768891BC89107AD291E45C8CE6A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0144.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:6::29) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|IA0PR12MB8975:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b52822f-8f57-4f76-3b88-08dba948ae56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 191ZwkL21Trhy0+Ms6XAjO8a0sVAixgr43uLwoYqdM79V7LyNnsOaWWxbr4pqhHfiZZo3MSBW1O8AtuXRbMNAPTZiddUCT70qctLB3ceWbJa7sR5lmeBpQSd6nhjZijPdxKQRvtt2YtkDW4yvD1hCIiCw3alpS1eKi/5yTUccwiLbselGdJKn24adGjUFGoe9zd+yGoOG1FX7wVLjJTKqzAnaKJ6SwohJ2lvWswjMvnFquUKCGyeh02OVTn+0MFAT1nY0p55VYwQ8xIshdW2WZfgUiBcWg40znqWKefyL69ykFk6MD2eyUkNmjG3wP4YeTXAhKaFx2n6rDYYS6ZSaMY5cMHlH+5QHTGegwjJe11/vmpor/d9Et2JEQJ2eGIanvFlFaZxdnx8NW9B0ez1Zoe+Juj54XGrIHlUVloiWlG4qVp+3J0PXOCRIDh7H10D1tvjf54IFZ+qdQmYsN3zSlnBttF+Qj85ntpT+GiWxYqXIlUX3KJQp/eVJcus8y48SGS+mlja+Az3d1nEQ7O6lANishaoUvbUrBhJOADMhPAeAYQyd9END1hHQ9Juav8K6kA6gBz/j0Wj4h6F4cvB9Jr1EJphgTQRPjJtY8leDr/LJ9apM6jNh6lQ+RKX/ksJ3tx5hmIRr3woPsf/VohPDC4BsYxd4GVQT1+7QTxiI48=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(136003)(376002)(366004)(39860400002)(1800799009)(186009)(451199024)(8936002)(6666004)(110136005)(53546011)(478600001)(31686004)(6506007)(66556008)(66946007)(66476007)(966005)(54906003)(6486002)(316002)(38100700002)(41300700001)(6512007)(8676002)(5660300002)(44832011)(36756003)(83380400001)(2906002)(31696002)(2616005)(86362001)(26005)(7416002)(4326008)(41533002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dXgxVTNyZWhFUng4WnJaeXZHSHRVd1lHVVpZT3Y2SlBNUnllejB4d25ZSWND?=
 =?utf-8?B?RUxrS3pnMHF2MlJDVUpVT3hKUUNxc3lPUHdaRC83RjBodEQ0STM3STkwM0M5?=
 =?utf-8?B?TGNJcFFML2FtdkdIUUVvaU9VbUlwNStLR1l4cm51cXV2Tm5HZWowL01QWUZw?=
 =?utf-8?B?NEhmV09PSThDKytGMzJWVk9YNXRGVkxFbWl3WFBrcG9SOENLV0R0bkxHeUhl?=
 =?utf-8?B?NktnaUhPZ3BkeERnUGJSVFE2SU9ZQ2NHOEI1cVIvN0k1cHRFMVE1bmt2bWNr?=
 =?utf-8?B?MHZ6YmoxM0pkSDlmRjZ1MHJEbEFhZW15MStjWFJtV0s5QkxLVXFJSlVCVDJ0?=
 =?utf-8?B?cWkrcHdYeWJ5QTZ6bGxHbzJlazNjd0NaY0RsNHNoTWkydzM2ci8yRnVxRjhh?=
 =?utf-8?B?d1F0T2VBMDVwNzA4RTIvYUNnQ2lRMmZvQktKQ1R3WVVEYW5Dby96TlZla0Rx?=
 =?utf-8?B?NkVWaW9ZR0hyMm9OVkhXK01iMzV0ZjZ1UnE0UlY2anNJcnVxSVRmd1hMWm12?=
 =?utf-8?B?Vi9vcjhOQkVTRTBpNVFRdGNPbEUycDhtUlhvT1A5a0ZVb3IzbmxzN3Q3TGd3?=
 =?utf-8?B?NndHemh1ZmIwKy95cys5SUswMjlwZS96YnNTbGNmZXgzZFlDVXNDcjVQbWtM?=
 =?utf-8?B?NUZmTXN0TnJJZXRtaFJ2cG5vZ1hJRmt2WGJRLzBWbVFhTzNHYzA2anQvN0Nm?=
 =?utf-8?B?Z0pwenZQSTlwSUlGSndzc1JMRVd3cm5vM3hjVWV2MmNqQVhQVlNZT0JWbW9D?=
 =?utf-8?B?QUdFc3RYQ0QvNndIRHNoU1dUZTlzMTRraEVuUitseVpsRHhIcElQNkQ3d05J?=
 =?utf-8?B?UllXZ2h2bmpaTjUzMFVqQm9vTlRySWIzdFR6UlllTG92aVB2VzdYQjB6SnJS?=
 =?utf-8?B?WG9sUDhtYUs3U2ZseXRoNmFIWmtOSkowVks5T2c1T1ZxYmMwRTNMRUI5Ky9S?=
 =?utf-8?B?dXVRL2kvanRpakEzOVBZb242N21aQWgzV2J0Yk1zY0JGTHZIdDJvbWlLQ0Vv?=
 =?utf-8?B?MEVDdnRCbnNHdGpvTEs5N1hnUlBIZVhubXZVaVpydWFoT05Ha00reGNTODhV?=
 =?utf-8?B?Y1AzSUk4Umw4cnB3MkxHSHg1aHl4U2xhdE11QWpFL0g4NGFSeVMrRnh5MHhD?=
 =?utf-8?B?TmNCZlAxa2pnNFlqOWp5VFU1RGl0VEJqVE9xVlB0dzJVRDBRNFpQenpnYWhJ?=
 =?utf-8?B?ellYUFNnN01uRjVoZVVrOHlNWHpybDVlU0dnRVZqVitySmI1ZTNSVnc2c0xH?=
 =?utf-8?B?SU9BcDk4S3cwbFFBYlRVV0NjMFFqM2ZvUU0wWGhLQjlNREtDVVB2by9RRzN5?=
 =?utf-8?B?NjRabCs3eHRQNGJJMEhxenZpMldTRldHa2s5Z3VaaEJWVnVhZDhRVHMvOTZD?=
 =?utf-8?B?REhyeURVbm91TmpGbWF4a0poUlE3VDFsRGdqSzc0bWVYTVdES2VvUTU2Qnd3?=
 =?utf-8?B?V3kwNDVVRVpHOEdLWlBZQmk5L3BEdXp3c3dGRWE1NkhkUGJsNmV3eTJYM2oz?=
 =?utf-8?B?UHB0T05rcEV0VXpadk1ZUUphVldOL2xKYldjRDJDb1liRFdnUkI0d1dnOStX?=
 =?utf-8?B?YzUwT3BkKzdTdzEvMGN0TWtNQUdqSjFkR2JmclhXcFBFTUJxdGk5a0hBZUpS?=
 =?utf-8?B?WmFXNjdrbHZCLzkzRmJzcS84TlcxakpGcFVSZW14bkVaNHdvTXVwTC9VR01m?=
 =?utf-8?B?RGd3WnZXQlk3cjdQZ1NrNW9acHBjclR1dkZQWFdRVU9wT1NTNGZwWE0yb21i?=
 =?utf-8?B?RnpXVTVKNVJ0K1B4ZzZBc1dzOHFIRGpCMTUrQVpIVkxmcXA3NGM2cXNvNis5?=
 =?utf-8?B?UGVLRHlvd2pkdHlLRWttbElLSE5lMlNTcHg1cWxKT1l6WkpRa2RIZko2aGRL?=
 =?utf-8?B?ck1WSTFRMkJ0WGd5L2hhWFdzZTZSNEdFaHIvdHcrWDBVWlB4ZHVnZ25ORVBR?=
 =?utf-8?B?RGJ2TC9DUnVVS3lzbkM1dmZNaFM2RnBESXRPRVV2WWYvK1lXV1YzZUlZVU9z?=
 =?utf-8?B?QktkL2w5eDRZOFZ6N0dkeDFvdVhKOTdGY0ZHc3Jhc3J4QmFjV0pFK05Nby9j?=
 =?utf-8?B?dm1BUTQ1cFdMekg3OEQrSGhTNElvUVJkM3d5dC9hY2NheWprblFxaVNZSjNl?=
 =?utf-8?Q?xiVdujwEfarZ0MMz8/C1pQ/nR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b52822f-8f57-4f76-3b88-08dba948ae56
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2023 11:03:03.4739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PVM8Q6JtQx6UerQ+07kOK05mx5xxfAU9Vdj7wqud3weyVDGVMYpYcyoEFBVgu4zlt30jWaWnsDxrb4G+yf1Xdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8975
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tian, Baolu,

On 8/30/2023 1:13 PM, Tian, Kevin wrote:
>> From: Baolu Lu <baolu.lu@linux.intel.com>
>> Sent: Saturday, August 26, 2023 4:01 PM
>>
>> On 8/25/23 4:17 PM, Tian, Kevin wrote:
>>>> +
>>>>   /**
>>>>    * iopf_queue_flush_dev - Ensure that all queued faults have been
>>>> processed
>>>>    * @dev: the endpoint whose faults need to be flushed.
>>> Presumably we also need a flush callback per domain given now
>>> the use of workqueue is optional then flush_workqueue() might
>>> not be sufficient.
>>>
>>
>> The iopf_queue_flush_dev() function flushes all pending faults from the
>> IOMMU queue for a specific device. It has no means to flush fault queues
>> out of iommu core.
>>
>> The iopf_queue_flush_dev() function is typically called when a domain is
>> detaching from a PASID. Hence it's necessary to flush the pending faults
>> from top to bottom. For example, iommufd should flush pending faults in
>> its fault queues after detaching the domain from the pasid.
>>
> 
> Is there an ordering problem? The last step of intel_svm_drain_prq()
> in the detaching path issues a set of descriptors to drain page requests
> and responses in hardware. It cannot complete if not all software queues
> are drained and it's counter-intuitive to drain a software queue after 
> the hardware draining has already been completed.
> 
> btw just flushing requests is probably insufficient in iommufd case since
> the responses are received asynchronously. It requires an interface to
> drain both requests and responses (presumably with timeouts in case
> of a malicious guest which never responds) in the detach path.
> 
> it's not a problem for sva as responses are synchrounsly delivered after
> handling mm fault. So fine to not touch it in this series but certainly
> this area needs more work when moving to support iommufd. 😊
> 
> btw why is iopf_queue_flush_dev() called only in intel-iommu driver?
> Isn't it a common requirement for all sva-capable drivers?

I had same question when we did SVA implementation for AMD IOMMU [1]. Currently
we call queue_flush from remove_dev_pasid() path. Since PASID can be enabled
without ATS/PRI, I thought its individual drivers responsibility.
But looking this series, does it make sense to handle queue_flush in core layer?

[1]
https://lore.kernel.org/linux-iommu/20230823140415.729050-1-vasant.hegde@amd.com/T/#t

-Vasant

