Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B17E675AEB
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 18:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbjATRQB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 12:16:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbjATRQA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 12:16:00 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2047.outbound.protection.outlook.com [40.107.101.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D726E411;
        Fri, 20 Jan 2023 09:15:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d0yTtEaumMqVN6rfTBeMdOYgzm6uPYVxizeyS9pv71rPiri+twT7deXLP4gRzn45U8rJDj2rnrcjzX4akAPtBo5/d/yqsCSw7Vb1nN2++vl7uqVMxeq9G6EGsAuHYbdfD5RyyB0w5b5L2p9v5g17Bjy06zD0Vpu9yIbWLKyKdutYU1vKVvOoMXG9xCOwk7nVQEQYPR4CGrQn37aPK6iLXgbqtLy8tEzsQrwS/bfH6+SO1F5E+OhQwCfhiWf+O0/HgFLUp13RKd5MF9Pk9g2iwwNuxW1EXO0ruwURtmZNY9hCFp/3a7PfhiFN8Lt1YFE1Zk8C6P4BFX6ojaLHBIUlhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gDQGUover6l5wdOuwh76GjgYxm9N29J582/L1r/j0Eg=;
 b=YTXsM5IGSCIWexsDTXus1CChA/ejftHrTniTU4zcMhyD6IMbPQm/5pRrmznMZYsuj2HmcGS6U2knVjZC4eHyXIDXdBb/xmMafG6B1n7cwWWCNIH3Sot++tpd+K8619BCgEOR6SyWkaAZJ6tfinxIhEtfVQ6JEF6XgMbSuJM1pmrqum0gDZB5JkNWIBEBJKC4oanOwXRe14h8ykh/J3/DzZfpbbXpJC38fTC7gs5MTTS8hHAquwN6WRemrxVg0uop4d/5P7P/xA4l7smJB86ENFCpWPRcvcZpTm3UDamjYPK7cqtlR7hbFAzJqyHVggTNzBc+A7kFZLGsSagbCtK5Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gDQGUover6l5wdOuwh76GjgYxm9N29J582/L1r/j0Eg=;
 b=0C17GLMsBWYTR80IEXDvgMzReeochXLLzJUC4Ts3goDXcEf8a0370X1iVNtoCkgd37CMTr6akKD3lTgfBtjGE5WqHIPCQKarh8rFvwjr1TsoRpkShP2bZdzWVePwqAK0Ou88Ap2y7nAPCVgL2iDBz4O2z1MAx/mmSuED/gsaVmA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by CH0PR12MB5188.namprd12.prod.outlook.com (2603:10b6:610:bb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27; Fri, 20 Jan
 2023 17:15:50 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7%3]) with mapi id 15.20.6002.013; Fri, 20 Jan 2023
 17:15:50 +0000
Message-ID: <61e64ce5-df76-f34a-1dc8-a0f1a856e2e5@amd.com>
Date:   Fri, 20 Jan 2023 11:15:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v3 2/2] kvm: sev: If ccp is busy, report throttled to
 guest
To:     Dionna Glaze <dionnaglaze@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <jroedel@suse.de>,
        Peter Gonda <pgonda@google.com>, Borislav Petkov <bp@alien8.de>
References: <20230119213426.379312-1-dionnaglaze@google.com>
 <20230119213426.379312-3-dionnaglaze@google.com>
Content-Language: en-US
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230119213426.379312-3-dionnaglaze@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0027.namprd05.prod.outlook.com
 (2603:10b6:803:40::40) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|CH0PR12MB5188:EE_
X-MS-Office365-Filtering-Correlation-Id: 965d10a3-a21e-4753-bde1-08dafb09fa85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4qyNArWW3PuKJHUz8Iv+uAK5Fg88DQ1C5zQVSsUsrVpOSRqHurDSXTNBhuLPX49kHxtxc/uufgdU3ZtHGlr6sVi02hwzqFEmW8ZVpXY6oKPQCXqftsK3lYOd81YBWUyFATK8+RyOph8hqD5FT2yKbgcUwGs9dnu4GJlK+Lt91YB17+Ah+nuLARuOYOqP2GXPyPnseyYrYBPX1Bc92p8NE8d2PhPYIAnu94YvxWVrbLAywRhU/6KBaLaqmfi908fH0Cp3mTPk44AEgDqfRHhPRujN6xUZtoMbGMb5eFgddvCqo/c7LzrLAjxDh1dUE7S1NcI/7PwIk8YcvX5m3fEYwbsFIXaCsHmN2Xn17h9JGCq39VYVGiEbblY7mZj5x1VOfZdpAcYCXzHbrzQlJenyzN4/wUW/szQsFr/cewqxNFMfPT7OFzvkuMQJdf+XTjKSgU4a7PTDDlAOKJW1KDEpmZsNZgsSFGG9gp7pkvKVN6tiF7PGX4EEaaKNg1M8NcI9D3HxaQ8PD/IOcMdiFEwsnRFXpI7A5xxQN1FTuPKAkNF+tzEdIFlkn8kQvTX6/ThMXRoFI2sZDwSk8fZEwxkXIxlM2NbhiO8ABph235GehiFrazS6pC3NLlt6p9mIQJj+zCd5AbIBTNlFd4caeSdTEo0QZ+s3TelQoA7T5vBAoB0Ae4D6avMZ1BVhciKq/ophRvOcYtC0o9+yOqb6nGZAZI54BSELlrEA69ldd5BRzCM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(451199015)(6506007)(478600001)(6636002)(54906003)(53546011)(6486002)(31686004)(110136005)(66476007)(66556008)(66946007)(186003)(316002)(26005)(6512007)(4326008)(8936002)(41300700001)(2616005)(36756003)(5660300002)(2906002)(83380400001)(31696002)(86362001)(38100700002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VHArbnU4MmFISUhnSnc0NTF1bXZaN3cyb1hCSGFHWmxHNFUvZDZwczI2d2I3?=
 =?utf-8?B?RCtZaVBRdU1ucDNkaHFKSWJaNUNTSmw0MUZIOGhZaWYrRmk5YnE2SVhzYi9w?=
 =?utf-8?B?Q0MrY09ZVDNDa2V0YmhTNjFzM1dKZGdtTkFxd2l2YXVSVE5RU25zRjM3c29U?=
 =?utf-8?B?eGk1Qm82K2N5anE2aENHZkFzbmx5a1VHZm5sdlNPdng0ZjNjNjlYeVBQaHh5?=
 =?utf-8?B?VktHNVVHb0dzdG84eUY5OXlRRzhNUXU5NEVJTmdGSE1zR0c5ME9qeUUydlBl?=
 =?utf-8?B?cldRLzlDNjFObDFFaytaUlRDWnA0amEvbTlUUTNqQVdOZDAwOSsyWmZuMkl2?=
 =?utf-8?B?QklNdDRsdXRhUGFZNTF2bGlrbXJiTFVDRjNhei9WYktVVFVTTmE2a1hJSnpq?=
 =?utf-8?B?M2JMdVFweHMwMlZnYkE3K2pnN1lBRS9yVTJMUVBVMDN4ZGlvMVAxajhrN1Y2?=
 =?utf-8?B?OWhaNmtHRWtFTTFIK3ptUTVyR0s3T0tEYVpFS011RDZpTXR1RitUWkYrWHB6?=
 =?utf-8?B?bVRIQWtEaXlncEQxTldGdFBKUUsrNVpHUzludmFXTFM4ZmpYNkUxWS8zdlhV?=
 =?utf-8?B?OHl3THRQS0RUTzVhZXpNd1BjdG9MQmJHZis3anN3eDJ0KzVON3pUdVFCTmNP?=
 =?utf-8?B?MmljaXMxL3NGY1I1b2d3U2dsQlhOdlpWSmxQKzA0ZW1Mc0pPcmdXU0VkQzNN?=
 =?utf-8?B?K09tc0UwQXhsUFhzTlJoZXpTL0NIdmVBZXVPL2VnYXpaV2d4VVNqaDgxcWNC?=
 =?utf-8?B?bU4vUTM2bmpldmFaZ1VoWjBPanlwSVJJQjZwa2NWdXFlOHFLbUxOVTZTS0R0?=
 =?utf-8?B?OUNuN2hVeFdqR2dlclp0UitheTd1Y0dXNENkQzVNTkVGUmFpSndRQ3hvaERO?=
 =?utf-8?B?c3JES0grWHE2TXBWanJCaGNKdmV1RmlNaWQ5c0IwWTRhTXhTRXpjYzJrUTNR?=
 =?utf-8?B?K2Rtbzlmd3VpMU5Wd2FOekxBd0RYTXJPajQyZVZnQkhZekhIWjhwRklJNW14?=
 =?utf-8?B?VVZrVGhvNFhqZWxkVUhKNHR3anBuSHRxM3pIZTZLYWUvQnRadmh0SDFmRUFp?=
 =?utf-8?B?YlBIQS9KSk1WcE9WYWZNanUvK0pkYytPQXM2UFcvSW53ZHl2MThDb2JmNUNG?=
 =?utf-8?B?UzJWVGFEcWRLU3lxZlN1WVgzWVZOREUwdmJ4ZmxPYUFraXR3Rnd4Mno5TjY2?=
 =?utf-8?B?NU5IQ0ExekZDUnpkNUVCT2hwUHlsRmhLKzdHczhzblE1amYyMzZ0V1Z4MVVn?=
 =?utf-8?B?L2R0Sm1CWW9LaWxYMmNrbS9Qc09KazRpamFUS2ZjZCtEeXVDcWJranhrWDNW?=
 =?utf-8?B?NzEzbFNQSldPd1JabExYZWhnNFFsdTVGdnU5U1RQTkZGSEVZS1VSdWRPSUhC?=
 =?utf-8?B?SEw3dXM4TVVGWk1sdHR1eitHOWpaUTRyam9kUHRiWEFQZEtTalVURW94a2h3?=
 =?utf-8?B?L3JMUUV3aTU1NzQ5TnY1VDJMdGNSenFpaW5heWc4YVBWc29kc3pOT29jaEVK?=
 =?utf-8?B?dEhGV25ZWEpnNUZxcm1heWFBcG1yQ3QvV1FpaVp0ckFqdlhiWmtyT0Vscm5T?=
 =?utf-8?B?UEVadjFvdE52aGVDRWxCSU96NTZIdlEvWHNmb0g2RGFXSGVFRFhWRWx3YVIr?=
 =?utf-8?B?RnBINDFzUzFuaHcxTVpkTEhOM1l2dndYOXFGQU41RG5ST0xoNnVqRG5KenpM?=
 =?utf-8?B?cE01ZzNGK3Npai9CNEo1MGUrbFp6ZzlzTEVYTHF3aktydFhCUUVDZTFXaUNq?=
 =?utf-8?B?SERNTUhRYnhhNjBMMkN0TUFzT3libGN2MS9uaTVOQzNadVVCakNJSjNENVB6?=
 =?utf-8?B?b0VqMFpZbWUwbjRaeEtHT094bmJSQVpBRTh3TFNqd015dWg2NU9PeXVOTXl4?=
 =?utf-8?B?cy9HcitxeUlwYTVXU2kyMS8vTGdMYkpiR3h6Y0dvZ1dIUTVnWVFCai81eGV4?=
 =?utf-8?B?R3I3RERBSHROTFV2d2tRclJBNkVvNDM4MWlFS0d5Z2pSdkhYOUgrMG5SQ2pS?=
 =?utf-8?B?TzQwMmxoeDVHTytiWkk4OEJ6MG9ySDdJcTZIdEJUR25BZXZaZ2xGWW4rdmd5?=
 =?utf-8?B?VVBNWm1mTXRUTE9sMm15bXZ5QUVQYktSWnFTQ1lCQS9rYlZ2eXZXcWhxcG9r?=
 =?utf-8?Q?MiFn4ORfQQw0L9xJh8YZ3t1m9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 965d10a3-a21e-4753-bde1-08dafb09fa85
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 17:15:50.4879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cN6PufOqXoSzJ4f2U5Q2lHXXT5WQBs/9JDmld8W4fMgj42ImsheygiwXuwWDBDnbqK0iuSuJyXs9B8nKRNTItQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5188
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/19/23 15:34, Dionna Glaze wrote:

Since you're building on SNP hypervisor patches, please keep @Ashish on 
direct copy.

> The ccp driver can be overloaded even with 1 HZ throttling. The return
> value of -EBUSY means that there is no firmware error to report back to
> user space, so the guest VM would see this as exitinfo2 = 0. The false
> success can trick the guest to update its the message sequence number
> when it shouldn't have.
> 
> Instead, when ccp returns -EBUSY, that is reported to userspace as the
> throttling return value.

Except the CCP driver doesn't return -EBUSY because it is overloaded. It 
will simply try to acquire the mutex and continue once it has it.

There are a couple of places that return -EBUSY in the driver for other 
reasons, as well as other -E* values. It looks like these need to be 
handled properly by the SNP hypervisor patches so that a "success" isn't 
reported back.

So this patch isn't necessary, but any -E* return value without having 
actually called the firmware needs to be handled properly. @Ashish, please 
work with Dionna on this.

Thanks,
Tom

> 
> Cc: Thomas Lendacky <Thomas.Lendacky@amd.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Joerg Roedel <jroedel@suse.de>
> Cc: Peter Gonda <pgonda@google.com>
> Cc: Borislav Petkov <bp@alien8.de>
> 
> Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
> ---
>   arch/x86/kvm/svm/sev.c | 18 ++++++++++++++++--
>   1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index cd9372ce6fc2..7da1cc300d7b 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3642,7 +3642,14 @@ static void snp_handle_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t
>   		goto unlock;
>   
>   	rc = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, &err);
> -	if (rc)
> +
> +	/*
> +	 * The ccp driver can return -EBUSY if the PSP is overloaded, so signal
> +	 * the request has been throttled.
> +	 */
> +	if (rc == -EBUSY)
> +		rc = SNP_GUEST_REQ_THROTTLED;
> +	else if (rc)
>   		/* use the firmware error code */
>   		rc = err;
>   
> @@ -3713,7 +3720,14 @@ static void snp_handle_ext_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gp
>   	if (sev->snp_certs_len)
>   		data_npages = sev->snp_certs_len >> PAGE_SHIFT;
>   
> -	if (rc) {
> +	/*
> +	 * The ccp driver can return -EBUSY if the PSP is overloaded, so signal
> +	 * the request has been throttled.
> +	 */
> +	if (rc == -EBUSY) {
> +		rc = SNP_GUEST_REQ_THROTTLED;
> +		goto cleanup;
> +	} else if (rc) {
>   		/*
>   		 * If buffer length is small then return the expected
>   		 * length in rbx.
