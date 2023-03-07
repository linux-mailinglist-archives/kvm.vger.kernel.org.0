Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A60A16AF65F
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 21:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbjCGUGZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 15:06:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbjCGUGU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 15:06:20 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF5999C23;
        Tue,  7 Mar 2023 12:06:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vr6IVfczNKxp8/PlL9m9XAz9/j3EZ7PDd5CWMRcf+Q7+FyaUXKuSLqVZcVMO08y19T/3U7kU7uNBPK42I9azIMELIVHYzDN7Jc/U0LfoZq/XQBh7CVFCXU+Kz99JlLGlGhDlIId6P7LHhrC0hOTB60EE/y+zptuJ9tDoQsXTsGPC6SIxHt1FzWR+4DTcBtlZrYA+tmgh3O+4E8TMFHnUxBzAzr57sKeaIKpKYkYn0LjjNDZumNdPpNCFzfKYQHvxYqm6sprz50ZYz9Pc7AdO3wRHJBfX+O5vydnpbkOC/wOVRCkjzfefT3rpUyo/frpbVuhO6oVIt9wgd95zDiHvJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=73pqUAqB2BdgoKvG8plwap0dsqCYEosLzzfE/DDzbL4=;
 b=EADObelriuzFJqQYXsKoiEDPbUOkM2/6vLLVho/12VSkbBX/0s5RD50MEGrCeLutCzRUrtmBTwV0okhZctdgjWM9dL/Vni2U0ytFvbdV0Ci9P1fZRtoUSxAX2zSVzvpGr6wOzfPWf5Uy+MHSfJksgIGetHnmNlfg/BycLTNjgu+g4BMzbnD6Em7g1KZ6WUd8FNIBoFE8fOxDxQfBfEa2t169t/IIGCFaUuZHTRBDnFcEpYU7pzJju0TgNGLnjhFchV2stLmRURIk25B8dE+35J1L45hs3su6UQ44+4mlGRBPaBUW67O/R4FGx9Mc7Ck/qOlqPPSsbrOZKMZmY/cm4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=73pqUAqB2BdgoKvG8plwap0dsqCYEosLzzfE/DDzbL4=;
 b=juEZPZyhHeSXxaUngcfsEwYGIBSGcnoGD9H263V+jhInD5YA+Yg9gSIM3oXlvYUFU8cjEoWQW1uROWuCCgRDslieMC+/8LAB0F+9dAR0rcEs4ajWWPA7CZoo94hhWoMFw8CrcpZqOa27OOuBpqvD85MG3Hou9H1pahPXDicy/IY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by SJ2PR12MB7868.namprd12.prod.outlook.com (2603:10b6:a03:4cd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Tue, 7 Mar
 2023 20:06:09 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::6cc0:9c7a:bd00:441c]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::6cc0:9c7a:bd00:441c%5]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 20:06:09 +0000
Message-ID: <0c56683a-c258-46f6-056e-e85da8a557db@amd.com>
Date:   Tue, 7 Mar 2023 14:06:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v13 00/11] Parallel CPU bringup for x86_64
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Usama Arif <usama.arif@bytedance.com>, tglx@linutronix.de,
        kim.phillips@amd.com, brgerst@gmail.com,
        "Rapan, Sabin" <sabrapan@amazon.com>
Cc:     piotrgorski@cachyos.org, oleksandr@natalenko.name,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        seanjc@google.com, pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com
References: <20230302111227.2102545-1-usama.arif@bytedance.com>
 <faa0eb3bb8ba0326d501516a057ab46eaf1f3c05.camel@infradead.org>
 <effbb6e2-c5a1-af7f-830d-8d7088f57477@amd.com>
 <269ed38b5eed9c3a259c183d59d4f1eb5128f132.camel@infradead.org>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <269ed38b5eed9c3a259c183d59d4f1eb5128f132.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0173.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::28) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|SJ2PR12MB7868:EE_
X-MS-Office365-Filtering-Correlation-Id: afee8b40-26db-48f1-66f6-08db1f476422
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J34i9noEfvBcmabOh3WR6QKCdEVO8Qsfz70OeBPBRAv8h/Mp6Np7cm60/pX+dBdFQFk1YN/H1FxQfC880DUV3IW08tRCK7fk5i5wKdqGy5BJZd25USEeN6mTi0KIsgRRa8GjLcnaAIObRu7RLB2AFvQNI2EmpuylhM9QtfXpQKOa8Z2m8EpUyJWB1/YnScGOUIU5GJL1q5jH2bVqXQvwmgaaF2MWLQQa44p8ho4j45B7is/7n1Z36j/8yRK5GKBt171DccbwsTdUB5f2izBJmyda8BUKYZrxEG64OqCEfiS9CtgGT64ndHe6RyabBX4mAiC36FJvKxekSeLjowdn5Koq+D+hWBm182PoH+0mtAuD1Q0lEVoiSLupLCxSKYrD4O171CgHsM9DftuZqcRMqsoHmU303DlxIct9a4zj4qtGCycpd8NJ+mGNpCjTuiUVTDugIbQRfcIHLo7x5nasArdbogFU5/lsYJyGsGQVX1Rw0m4AzuToxwJKfOQpr4JRcjZBJAb+LQ/qkv4HgDJZC6ApoNNUbl8Ls6dDq6SZFXse/TR3pxtC/nisUuN1BTHlqZtOhCOTr+qH7BQj+OgcJlxHOVyPzebefBXyBpDM2r3YWPlQLU/0YG8u/lvjWcI38NbYPzUYPriSOd5Zs+LTshu0CH+lE14RwKWyJRIjp3nWomrE1Y3wockz5PnsQCgtJGX89NFZJxNhhLdzzCQrBZ9oGD0xfJklzyI/NloeBLB89A2zk2KpHEQ5tw0F9aZ2DQxocn85AQx1JF1DFoVgnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(366004)(376002)(346002)(396003)(451199018)(86362001)(38100700002)(31696002)(66476007)(36756003)(2906002)(66946007)(5660300002)(7416002)(41300700001)(4326008)(8676002)(66556008)(8936002)(2616005)(186003)(53546011)(26005)(6512007)(6506007)(83380400001)(110136005)(478600001)(6666004)(966005)(6486002)(316002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aDFGYnVWeEtJbEQ5THVQU2ZXTjIvT0NGcE5yakNRaGJBNC9BZ2pQZTc0UkZL?=
 =?utf-8?B?OWVmcVlQTU5lYk5nUkVtY2lrcHNPMkFwT3RQSUtuQW1wb2Qva2ZGY1RvN1E4?=
 =?utf-8?B?dEFpUDZiN2tENlhCdHZUeERCeWhJcXI5cmNwNVBiTXNWREtJczhVZlBqVjgw?=
 =?utf-8?B?V0JLcHN2UldpYXlwWTY4Tzh0QzBvK0VqWE1HdWhaQ0YxZXBlV0xZUXFQYjYr?=
 =?utf-8?B?SlFiRTBzaXd4WkMrZXFrb2V2NklxUUdaMGNaU3R3TzJ0WXZCT1NIVWh2Mzls?=
 =?utf-8?B?a1docEpLNVV4UlRwQzkyWmxBN3NFSm5XMGFDNkxWV2tUOWFJYzV6YTMzNEFO?=
 =?utf-8?B?R1RIM1J6UkdXNkhrcGtpcDl6MjF5SkJ5U3NjNTNVUkd5MWk1Y213anovMzFS?=
 =?utf-8?B?SEFBaC9hWHl0eERnSklGSjlYQ3FXZjFPL1IrckU1UmVkeVlWUmtxKzdsS2hM?=
 =?utf-8?B?SGZGWFViMlFLbk4xN01RR1NFM0R5NjJKcE5mMzVtYUtLY0Y2dDZkdXpSNXBy?=
 =?utf-8?B?MnpPek8rK3ppZ1VpS2JHRSs5WkhqUys5dlE4RDFnYm5qWUJBVDJXbTlIMzlj?=
 =?utf-8?B?cFZtWU5URTVGMmkrcXZORGEzSmpxejhlaktXajJRSDZNZ2hKaWxEK29KM1Ns?=
 =?utf-8?B?MXBPQ3dxUG16b3BWMVI0dW1SY3BIVThpQkc4TGFUNVNhWXYyNDNTSERXWEZU?=
 =?utf-8?B?QzJUTXFaUFVxQnVrRktMVWo1RWpyNHRYRW9WQzNtWm1NcjI3ejFNTVF4UjBB?=
 =?utf-8?B?UFlId25iRmIwRVplV2wwUUxtbGh5VEladFROOXJsV0dvOCtVOUN0dWd5bHJT?=
 =?utf-8?B?YlByZCtxd3ZkZ3kwOGxWTlhrYkU3N1BaQ2ttdmpqR3FsejA3SzlDTDduNlc3?=
 =?utf-8?B?T25GTURPbSttMTZ0alhUS0dQWmI0WnlQNEZQSkNQWlZCcExSS2FRaVhTckZ6?=
 =?utf-8?B?cW5jZUVoc1BIaTFBeFZybW5KSHZRQ0VMV0pCL1kxRjRGZTgyaVU2RHd2eXI2?=
 =?utf-8?B?WFdjRzZHS2QwdlMvSi9sK1FNNDc4V0pzUjE1SjJQZWRkUTRBTkphUUhPY2g0?=
 =?utf-8?B?YjM5cG9KNDhLbEhGNTVPYklyTWVlVnJTeDY0Nk1NaTVqNXdveUhoRG0wWlNK?=
 =?utf-8?B?NlNCQlUzSy9UQjE0RExaR2N4QXV0SlEyZzZNUnJHWmlINGw5MnJUbnhhNktT?=
 =?utf-8?B?eXJWTmtrVXo0Z3EwclhlOE1BNFFlM1pkV0ZiWmFFaFZQa1podGZwY1d5L3dU?=
 =?utf-8?B?TWx1OExYYkdhTlVlaWpRV28vRDBZckpEZzBFSGk5TTFuUytKV2ZGbDVUWXVj?=
 =?utf-8?B?SlVmUUY5ZWF4ZW81dzgxdVpWb2ZVdFBrdGVrTjJELzZKQ1pUZGwxeFNmbW1T?=
 =?utf-8?B?NEk4cVJFTXdESE5XRXMvMGc0TDRmWWNwK3UrUjcxL01pR3UycWNwNzV1cFN5?=
 =?utf-8?B?VDhGQk5vODJhMWxwNDBMTk4xSUdaK2JuaGdRdXVwU3VTMloycmlxT2lGSmhO?=
 =?utf-8?B?RVlXNjU5bXBUajh1YU1aUElxOEU2WnpFdXRqRzdlOFFSYnpuU0pibWUvcWJS?=
 =?utf-8?B?MlJKc00vL0lGdTh0RlQ4MjlRc25HVWNXMmVHQ1ZhQ0ZLMlJXalU3bTg3UVZW?=
 =?utf-8?B?L01VTVZHMS9kNzhUT2RUTVd3MkFpTVhaNXl2bUliY1dPeStEZmtxWTlsR0Vk?=
 =?utf-8?B?NmZPQkxxcnB5Q0xIVThFOWF1WG5xcDRTYkVNL1FRdnVobUxKSHJBNWJEb3JV?=
 =?utf-8?B?OExTb1U2VWtWT1JRZ0tyVW5WVGtCZFgrc3hBMkVtbCtidlJrNTNrdHJhOGZZ?=
 =?utf-8?B?ZVpYdlo1RWF2MkNiN0pNRjJEbGFXN3h4NG50VnZJUmVFRUxHQ0xHQlIvd3hr?=
 =?utf-8?B?T2huSzZHa1FRbHZTSnZ4c2hmV0I4WFVFR1p2MTYvamNkSXlnVUc5bVk0RktC?=
 =?utf-8?B?eG1WanlWWEgvZ3psSDR2b3FnTFliNmI0bWFyd1FwUDVlZ25hT1FuKytmSVJT?=
 =?utf-8?B?Q201MS9mVlFJMEhPU0drK3VGNkhyL1ZoZG1CTTJYS0N2OGM1Y3Y1cGhNazdm?=
 =?utf-8?B?eVRxL0I2QzBhVDBBRm5HWkhjbUhxM0tuaTZoNnlBa3Jsa3o1TnUwOCtkODdY?=
 =?utf-8?Q?SBNwBZE0glRn6zNts15C5RWJJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afee8b40-26db-48f1-66f6-08db1f476422
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 20:06:08.8984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j6y0qy1ISxnuEoZVwmLCpVgQe5iaYDeAnOZ1wyhX1WcxYz4KQFAomFNsehFZ6AFSVFvPDRLJG+v7ggtuCHZ8GA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7868
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/7/23 13:18, David Woodhouse wrote:
> On Tue, 2023-03-07 at 10:45 -0600, Tom Lendacky wrote:
>> On 3/7/23 08:42, David Woodhouse wrote:
>>> On Thu, 2023-03-02 at 11:12 +0000, Usama Arif wrote:
>>>> The main code change over v12 is to fix the build error when
>>>> CONFIG_FORCE_NR_CPUS is present.
>>>>
>>>> The commit message for removing initial stack has also been improved, typos
>>>> have been fixed and extra comments have been added to make code clearer.
>>>
>>> Might something like this make it work in parallel with SEV-SNP? If so,
>>> I can clean it up and adjust the C code to actually invoke it...
>>
>> This should be ok for both SEV-ES and SEV-SNP.
> 
> Thanks. So... something like this then?
> 
> Is static_branch_unlikely(&sev_es_enable_key) the right thing to use,
> and does that cover SNP too?

Yes, that will cover SNP, too.

> 
> Pushed to
> https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/parallel-6.2-rc8-v12bis
> 
>  From d03aed91e5cfe840f4b18820fe6aed1765687321 Mon Sep 17 00:00:00 2001
> From: David Woodhouse <dwmw@amazon.co.uk>
> Date: Tue, 7 Mar 2023 19:06:50 +0000
> Subject: [PATCH] x86/smpboot: Allow parallel bringup for SEV-ES
> 
> Enable parallel bringup for SEV-ES guests. The APs can't actually
> execute the CPUID instruction directly during early startup, but they
> can make the GHCB call directly instead, just as the VC trap handler
> would do.
> 
> Factor out a prepare_parallel_bringup() function to help reduce the level
> of complexity by allowing a simple 'return false' in the bail-out cases/
> 
> Thanks to Sabin for talking me through the way this works.
> 
> Suggested-by: Sabin Rapan <sabrapan@amazon.com>
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   arch/x86/include/asm/sev-common.h |   3 +
>   arch/x86/include/asm/smp.h        |   3 +-
>   arch/x86/kernel/head_64.S         |  27 ++++++-
>   arch/x86/kernel/smpboot.c         | 112 ++++++++++++++++++------------
>   4 files changed, 98 insertions(+), 47 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> index b8357d6ecd47..f25df4bd318e 100644
> --- a/arch/x86/include/asm/sev-common.h
> +++ b/arch/x86/include/asm/sev-common.h
> @@ -70,6 +70,7 @@
>   	/* GHCBData[63:12] */				\
>   	(((u64)(v) & GENMASK_ULL(63, 12)) >> 12)
>   
> +#ifndef __ASSEMBLY__
>   /*
>    * SNP Page State Change Operation
>    *
> @@ -160,6 +161,8 @@ struct snp_psc_desc {
>   
>   #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
>   
> +#endif /* __ASSEMBLY__ */
> +
>   /*
>    * Error codes related to GHCB input that can be communicated back to the guest
>    * by setting the lower 32-bits of the GHCB SW_EXITINFO1 field to 2.
> diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
> index defe76ee9e64..b3f67a764bfa 100644
> --- a/arch/x86/include/asm/smp.h
> +++ b/arch/x86/include/asm/smp.h
> @@ -204,7 +204,8 @@ extern unsigned int smpboot_control;
>   /* Control bits for startup_64 */
>   #define STARTUP_APICID_CPUID_0B	0x80000000
>   #define STARTUP_APICID_CPUID_01	0x40000000
> +#define STARTUP_APICID_SEV_ES	0x20000000
>   
> -#define STARTUP_PARALLEL_MASK (STARTUP_APICID_CPUID_01 | STARTUP_APICID_CPUID_0B)
> +#define STARTUP_PARALLEL_MASK (STARTUP_APICID_CPUID_01 | STARTUP_APICID_CPUID_0B | STARTUP_APICID_SEV_ES)
>   
>   #endif /* _ASM_X86_SMP_H */
> diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
> index c35f7c173832..3f5904eab678 100644
> --- a/arch/x86/kernel/head_64.S
> +++ b/arch/x86/kernel/head_64.S
> @@ -26,7 +26,7 @@
>   #include <asm/nospec-branch.h>
>   #include <asm/fixmap.h>
>   #include <asm/smp.h>
> -
> +#include <asm/sev-common.h>
>   /*
>    * We are not able to switch in one step to the final KERNEL ADDRESS SPACE
>    * because we need identity-mapped pages.
> @@ -242,6 +242,7 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
>   	 *
>   	 * Bit 31	STARTUP_APICID_CPUID_0B flag (use CPUID 0x0b)
>   	 * Bit 30	STARTUP_APICID_CPUID_01 flag (use CPUID 0x01)
> +	 * Bit 29	STARTUP_APICID_SEV_ES flag (CPUID 0x0b via GHCB MSR)
>   	 * Bit 0-24	CPU# if STARTUP_APICID_CPUID_xx flags are not set
>   	 */
>   	movl	smpboot_control(%rip), %ecx
> @@ -249,6 +250,8 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
>   	jnz	.Luse_cpuid_0b
>   	testl	$STARTUP_APICID_CPUID_01, %ecx
>   	jnz	.Luse_cpuid_01
> +	testl	$STARTUP_APICID_SEV_ES, %ecx
> +	jnz	.Luse_sev_cpuid_0b
>   	andl	$0x0FFFFFFF, %ecx
>   	jmp	.Lsetup_cpu
>   
> @@ -259,6 +262,28 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
>   	shr	$24, %edx
>   	jmp	.Lsetup_AP
>   
> +.Luse_sev_cpuid_0b:
> +	/* Set the GHCB MSR to request CPUID 0xB_EDX */
> +	movl	$MSR_AMD64_SEV_ES_GHCB, %ecx
> +	movl	$(GHCB_CPUID_REQ_EDX << 30) | GHCB_MSR_CPUID_REQ, %eax
> +	movl	$0x0B, %edx
> +	wrmsr
> +
> +	/* Perform GHCB MSR protocol */
> +	vmgexit
> +
> +	/*
> +	 * Get the result. After the RDMSR:
> +	 *   EAX should be 0xc0000005
> +	 *   EDX should have the CPUID register value and since EDX
> +	 *   is the target register, no need to move the result.
> +	 */
> +	rdmsr
> +	andl	$GHCB_MSR_INFO_MASK, %eax
> +	cmpl	$GHCB_MSR_CPUID_RESP, %eax
> +	jne	1f
> +	jmp	.Lsetup_AP
> +
>   .Luse_cpuid_0b:
>   	mov	$0x0B, %eax
>   	xorl	%ecx, %ecx
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 9d956571ecc1..d194c4ffeef8 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1510,6 +1510,71 @@ void __init smp_prepare_cpus_common(void)
>   	set_cpu_sibling_map(0);
>   }
>   
> +
> +/*
> + * We can do 64-bit AP bringup in parallel if the CPU reports its APIC
> + * ID in CPUID (either leaf 0x0B if we need the full APIC ID in X2APIC
> + * mode, or leaf 0x01 if 8 bits are sufficient). Otherwise it's too
> + * hard. And not for SEV-ES guests because they can't use CPUID that
> + * early.
> + */
> +static bool __init prepare_parallel_bringup(void)
> +{
> +	if (IS_ENABLED(CONFIG_X86_32) || boot_cpu_data.cpuid_level < 1)
> +		return false;
> +
> +	if (x2apic_mode) {
> +		unsigned int eax, ebx, ecx, edx;
> +
> +		if (boot_cpu_data.cpuid_level < 0xb)
> +			return false;
> +
> +		/*
> +		 * To support parallel bringup in x2apic mode, the AP will need
> +		 * to obtain its APIC ID from CPUID 0x0B, since CPUID 0x01 has
> +		 * only 8 bits. Check that it is present and seems correct.
> +		 */
> +		cpuid_count(0xb, 0, &eax, &ebx, &ecx, &edx);
> +
> +		/*
> +		 * AMD says that if executed with an umimplemented level in
> +		 * ECX, then it will return all zeroes in EAX. Intel says it
> +		 * will return zeroes in both EAX and EBX. Checking only EAX
> +		 * should be sufficient.
> +		 */
> +		if (!eax) {
> +			pr_info("Disabling parallel bringup because CPUID 0xb looks untrustworthy\n");
> +			return false;
> +		}
> +
> +		if (IS_ENABLED(AMD_MEM_ENCRYPT) && static_branch_unlikely(&sev_es_enable_key)) {

This should be IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT)

Let me take this patch and run some tests to confirm that everything works 
as expected.

Thanks!
Tom

> +			pr_debug("Using SEV-ES CPUID 0xb for parallel CPU startup\n");
> +			smpboot_control = STARTUP_APICID_SEV_ES;
> +		} else if (cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT)) {
> +			/*
> +			 * Other forms of memory encryption need to implement a way of
> +			 * finding the APs' APIC IDs that early.
> +			 */
> +			return false;
> +		} else {
> +			pr_debug("Using CPUID 0xb for parallel CPU startup\n");
> +			smpboot_control = STARTUP_APICID_CPUID_0B;
> +		}
> +	} else {
> +		if (cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT))
> +			return false;
> +
> +		/* Without X2APIC, what's in CPUID 0x01 should suffice. */
> +		pr_debug("Using CPUID 0x1 for parallel CPU startup\n");
> +		smpboot_control = STARTUP_APICID_CPUID_01;
> +	}
> +
> +	cpuhp_setup_state_nocalls(CPUHP_BP_PARALLEL_DYN, "x86/cpu:kick",
> +				  native_cpu_kick, NULL);
> +
> +	return true;
> +}
> +
>   /*
>    * Prepare for SMP bootup.
>    * @max_cpus: configured maximum number of CPUs, It is a legacy parameter
> @@ -1550,51 +1615,8 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
>   
>   	speculative_store_bypass_ht_init();
>   
> -	/*
> -	 * We can do 64-bit AP bringup in parallel if the CPU reports
> -	 * its APIC ID in CPUID (either leaf 0x0B if we need the full
> -	 * APIC ID in X2APIC mode, or leaf 0x01 if 8 bits are
> -	 * sufficient). Otherwise it's too hard. And not for SEV-ES
> -	 * guests because they can't use CPUID that early.
> -	 */
> -	if (IS_ENABLED(CONFIG_X86_32) || boot_cpu_data.cpuid_level < 1 ||
> -	    (x2apic_mode && boot_cpu_data.cpuid_level < 0xb) ||
> -	    cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT))
> -		do_parallel_bringup = false;
> -
> -	if (do_parallel_bringup && x2apic_mode) {
> -		unsigned int eax, ebx, ecx, edx;
> -
> -		/*
> -		 * To support parallel bringup in x2apic mode, the AP will need
> -		 * to obtain its APIC ID from CPUID 0x0B, since CPUID 0x01 has
> -		 * only 8 bits. Check that it is present and seems correct.
> -		 */
> -		cpuid_count(0xb, 0, &eax, &ebx, &ecx, &edx);
> -
> -		/*
> -		 * AMD says that if executed with an umimplemented level in
> -		 * ECX, then it will return all zeroes in EAX. Intel says it
> -		 * will return zeroes in both EAX and EBX. Checking only EAX
> -		 * should be sufficient.
> -		 */
> -		if (eax) {
> -			pr_debug("Using CPUID 0xb for parallel CPU startup\n");
> -			smpboot_control = STARTUP_APICID_CPUID_0B;
> -		} else {
> -			pr_info("Disabling parallel bringup because CPUID 0xb looks untrustworthy\n");
> -			do_parallel_bringup = false;
> -		}
> -	} else if (do_parallel_bringup) {
> -		/* Without X2APIC, what's in CPUID 0x01 should suffice. */
> -		pr_debug("Using CPUID 0x1 for parallel CPU startup\n");
> -		smpboot_control = STARTUP_APICID_CPUID_01;
> -	}
> -
> -	if (do_parallel_bringup) {
> -		cpuhp_setup_state_nocalls(CPUHP_BP_PARALLEL_DYN, "x86/cpu:kick",
> -					  native_cpu_kick, NULL);
> -	}
> +	if (do_parallel_bringup)
> +		do_parallel_bringup = prepare_parallel_bringup();
>   
>   	snp_set_wakeup_secondary_cpu();
>   }
