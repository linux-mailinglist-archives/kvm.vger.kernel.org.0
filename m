Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C295A647E52
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 08:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbiLIHMD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 02:12:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiLIHLz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 02:11:55 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1E730F67
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 23:11:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670569913; x=1702105913;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lwxuzBiIG5piWPCbPZfnGY6ywg9sP8GmipuPVaVg0BI=;
  b=f1MSb+QJ9RTqdQB7FBYuxRvlfhm0bPx5vPWwIQVKABfruONDNcgUSGsw
   anLE+mDyVzfKoat1EZjStGi+OFC6DxAOZmTAojOPb0Rpqi9nr6kXGhsWa
   Em0Cju67rO6WOvCUNX7MQVxN5DpGNKfBvY8/zOwcJgy8TysKZ6nkVI6L4
   vSdVPUQ35M2AL+wfWpyByvTToJi/ZNFq2AsqbMa8dNtUTuW6v0R4yd4ef
   yE8F6QFJl1KRTytZDz4tGOR3fhvRduW5qmuI5lUo2ClDHJljlIfs9rxTt
   S8su5R2do8fYRBfIc7429PDiJHv4xzWo99Lg0uDblqya0AvyAEQKOwkpP
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="381705323"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="381705323"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 23:11:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="679841716"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="679841716"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 08 Dec 2022 23:11:53 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 23:11:52 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 8 Dec 2022 23:11:52 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 8 Dec 2022 23:11:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k5/gYi4I67c2fEbK3uLw65PHHL8XdHTJVDYVocgHlS8BnikFlvQWchfOHnuQOP3EmGdVlDkylaAOCp2HNYgSYhnf3mZdv6aYOJXi0iRjN46pB/E8URwKc4eR6kU/hDXx/yc0OhcatqmY2z2eipenzYrlClqAiKtzfYN1Tm+ylzJy2ufEKiN2guXGC7yY+6AFG/Jo8R2toE+WM8iaTWXpj/HzQG/YkfCDPimcUNdRiR7torOJXCXblbgBKWoXxID6CupAlX2wHGFlEC5UkRXv9sNI4bURNNYsd8D8UwxEI0mgC/5t4CrDsygygY/dwbwQlSTyppl6IooLA5+tQehJvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mBtLTJjU7sWxB4US05eaGDu8yaB1QZxwKt2lTCQ4tfY=;
 b=H+3cuD9VK5RqPodOxYXlFTUkOeZXrHLlvLGVTP1jNOarmw9oFr/4EllmTJ34B+3D4ravlSO1Icjsqu7gL37plyynfC/cBSgsxDlf59h+SwmaROTUGFQRyg86ug6PRMWKF4CVakqCjk/Gp28p2O/S8EnAkrRVqWfib8xkGKwpRLPEMF4Eg1AP5ptzk9EvF9q7WAmperQK3JhlyUPnULIIk+AEfHnJuPK15BT4VBhBwzi5InlL1CFr4/qfj0JE4rf1XoPlod+J1CXdT9PWcf8h+PzsGcUi9aBSJmxdDGjDiMRBWZM6FImICwFBBRn+0JllZv5+8YUrAIfG9FW7DcgAlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA2PR11MB5052.namprd11.prod.outlook.com (2603:10b6:806:fa::15)
 by CO1PR11MB4882.namprd11.prod.outlook.com (2603:10b6:303:97::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.16; Fri, 9 Dec
 2022 07:11:50 +0000
Received: from SA2PR11MB5052.namprd11.prod.outlook.com
 ([fe80::d95b:a6f1:ed4d:5327]) by SA2PR11MB5052.namprd11.prod.outlook.com
 ([fe80::d95b:a6f1:ed4d:5327%9]) with mapi id 15.20.5880.016; Fri, 9 Dec 2022
 07:11:50 +0000
Message-ID: <5e53b4fc-ec28-7213-d0d6-a3164300f375@intel.com>
Date:   Fri, 9 Dec 2022 15:11:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.1
Subject: Re: [PATCH v3 7/8] target/i386/intel-pt: Define specific PT feature
 set for IceLake-server and Snowridge
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
CC:     <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
References: <20221208062513.2589476-1-xiaoyao.li@intel.com>
 <20221208062513.2589476-8-xiaoyao.li@intel.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <20221208062513.2589476-8-xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0164.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::20) To SA2PR11MB5052.namprd11.prod.outlook.com
 (2603:10b6:806:fa::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR11MB5052:EE_|CO1PR11MB4882:EE_
X-MS-Office365-Filtering-Correlation-Id: b5411f7a-4bce-4ff7-6d5b-08dad9b4a3c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hDiWCgYkW+AsLeDUTtduB8dGS3Dj+2KTf97Mt6lPMBtDVMkiiCYfBzf7vJx3BYvB2MLnT8mHMkbzgTIKsD+TfVnw/Fwgw+SGusDcjzCwYlhhDvoepRqwqhL2H8TtYgSlxxQ6FVhO946HUVXNY380J+EGc9YYNIFapmp2t6LfrXOyKegYxiwLjKONnUOQRRqYzg+nKOzFEOQRu7Zlhz7wRU4xZ+U9gk6QFBzp9RUXItcpn375bgv1f0alTMvsDLBD4kTCG/XjxjEFPM7yYKc6Io1uv4SsLj3j+EzKJtChIDY+zVTMIYe2eq/BkJC8QYS2pBT34FTWf8GJEqS0WXqskhK/71hKb3FT/yLLNDdhWPkBXwyJA7o80v0OA1feKbfpJnCVru8imbNZJPEckMZcOOzafrm5/u1DJTQRoaLSAxbMETFUym25tENoQSsFS0I3qcRAnLqBSVcjKPuw/EbuiUNbPSXFbvXi0wQ9Nt572ZT9v9E8gv6x19PL58e8oVlUgWI3/LlCVD8zRfnV+/6nvOwrD6Csb5qouMDCGXd2F4fzOf3RH8hL5ehsXivtrxadgdDlCPDf/2WvJ1HEaoVCopjdSKkn2PdvN/APjv6Nf/cZjV8+HZKyWqQmGtNee3P4NBpOVP61+Orw4E4DDBg7d6bvyPX8uIv9cmUYvsgnheM8iZS2BHj1sjyk8F48bJvqo0W0o/ImZCnPZOsjSASAdZCWvIYY2SSsWd0PqWvek6Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5052.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199015)(8936002)(36756003)(86362001)(31696002)(8676002)(6486002)(2616005)(110136005)(6666004)(186003)(6506007)(6512007)(26005)(478600001)(53546011)(82960400001)(38100700002)(44832011)(41300700001)(4326008)(5660300002)(316002)(66946007)(66556008)(66476007)(31686004)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MW1vczJFYlJzTFVyelJxT1Z1UVlEeFRuNmUzR25XNmtqUWZtcmlReE1hYlpL?=
 =?utf-8?B?Mi9lN2lZN3ZUcS9LQTNBclhKdFkzVkJNcE1ESUxwVENSTkVLazdOeS9QZFcx?=
 =?utf-8?B?Q0JaVURjZHg3QUx0OGNDMlJsRktnNjNpSVZpMzBFWTQ0ckJhcXBtdXhIUTRD?=
 =?utf-8?B?NU1KZDEreEEyUkxaQlQ5TEtaSjJpKy8xaStsTXFvV0hidmN0enlFcHl3Z3Zo?=
 =?utf-8?B?S1Y3ZUltb1YvL1A0RDJ4aVl1Z0pFa0crZHpTcWUyZnowQWEydE41bEFWeDFP?=
 =?utf-8?B?NEJ6NUpMd2x3YnJEZUN3Z3Z0T1FQOTl5MDMrVXI4aER0dHNsbDBFQmdMdHA5?=
 =?utf-8?B?NS9Qc0tCQWJQOWdxSk5Ib25lV25EYU90TjJ3QnRRV1dHYUJSOHQyMTRSMDZ3?=
 =?utf-8?B?Qk1BSW1QSFRGeUxaQkR2eEg5Q0ZqR0g1U2xXbmpBRytuR1c3M2hqd3hoMm1P?=
 =?utf-8?B?SHc2YW5nQ2hFb09wOE1XTFVycm9OZ3l3MklVMTBVT0hZR0pNNENTL1RidkFr?=
 =?utf-8?B?cUNIMS9wU2RSRmdsM3dHS3F2TW9CdXp2WkdSTFFiSzhJSU9vRmNmc0xkNmFQ?=
 =?utf-8?B?a0g5cmNISlBPd1JpVHl5NWhER1NlSDIzWHF6Y3JZa0gwMUJOZDZPKzN4aGp4?=
 =?utf-8?B?TUFPZ1o0THh2S2g2TFJnZDVjVVo2WEs4ZmpDMXVEd3NUUjJkRldnS25yNmN2?=
 =?utf-8?B?K1NEdWxCUEdxQVcvbGZ1ME16L3phT1F1STF1Zm1XaUF4djBETzcvSExRRUlP?=
 =?utf-8?B?aFZYVDgxZzBheEFyNkRxK1JNU2t3LzQ5REs0akgxTlBUazFDby9wQ0UzQy8y?=
 =?utf-8?B?azRISExCMkdVd1duMTRrUVh1dkhURmxwT2lwR09idkFNZUZJWXcxN0hUTHNl?=
 =?utf-8?B?ZEdZd0FVV0FGY0pVSEkyUVBDRjZsK1F6TGtzUjFrUHlPb0tWa2dQK1NWWjdV?=
 =?utf-8?B?L3pZdTd5dmMwUEZoWFdxNndLREQ1RE5OTE1qSk9EL2tVMHoxZi8rdk1yQTNF?=
 =?utf-8?B?VDJZMDlOaHgxaERzNEcrN3A1VnVLcU5zRkhZN0pGK0RJakFvREJVREVsOHlz?=
 =?utf-8?B?dUNLSW5Ed3duVGtCRTVKU0xNZ1NBRHhzYUZaeEQ4LzRDZVZsMXBvbnpkdlVy?=
 =?utf-8?B?MjFHN3pUNXFOSE8zbVZEekM2OWJjNWVEL0Uyckk4bXF1cW5JK0x3N0s4YkVR?=
 =?utf-8?B?UytWdElKK0VCOVdCRS9HMEhCTERQMmQvdG0vcjFJcFg5elNlTERkdFVZZk5y?=
 =?utf-8?B?RlJ4Y2JMWnVlY3ljS0ZnOTFTdFhvNkd5djJIVmtudmIyRU9CUUE2TUY4OVFr?=
 =?utf-8?B?S3NUUmxiVFhKZHpzOFQzSlE2dE5BRU1ldThya0xqb0xSMDQ0OGxZOWN4OUFZ?=
 =?utf-8?B?OElJUWtrYlMyTTl2dXBqN3pDdis4bS9rUkRmRFRjbDRRZHZpSEUzZVk1V214?=
 =?utf-8?B?cWJpT1A2elFmYTFwUU50S1VvQnJGbVluanVQd3RrK29uZE9lNlI3cDlwRm5u?=
 =?utf-8?B?d1FTTDYydEhPM1hFNU5MYVJ4SXFSc1FPQU5WWkhVK3lxVTdZbHEwQzBXZkVT?=
 =?utf-8?B?cWkyaXZCNHNuVU1ORUlycFNsVVc0V3RSWm5JOG9udnQydW9qUnBIUnkzd1RB?=
 =?utf-8?B?Ylk1Nkt6MEFDZnc2T3MzSGp1dStxUGhPN01nbWF0aDMyK3d6aG1SbjhERFRY?=
 =?utf-8?B?a1pMaDByMHRxQTdCV2VZSmVBeVQvVXhaVll2c1Byemc4aExYWjJtazhyYS9F?=
 =?utf-8?B?cWNiRTRDUTI5d094NnBqWUlubVhsVWZBSjljQ2lqZVgyVlMzUk1wVCt4M1g2?=
 =?utf-8?B?WjhXOWRzTUh6YzNIbDhNUDBrR2pqM0JyWHJyM211TWxEVTdSVmZ0UkNNVGhx?=
 =?utf-8?B?ZWhJVjRTS0Z5WFc5RFcvb01sb2JHTWphUEJWRTVxOFlUcDVHeitxcE1PZVlI?=
 =?utf-8?B?NExqaWZVVmdxTStjb2xHd2dDMWV2dTVHZWNQYThRMGVyYUZTb2Jwa3pPNyt5?=
 =?utf-8?B?RnljQ1AxY2JONUVrMUNPamdXUUg4UlJMZm4xZFJPa3Q1NmFsWFJRM2tvZUJQ?=
 =?utf-8?B?eXlwNUZoaVJLTTlIekhPZ200YnorZ3ErV1duUUpwMXNISFVxbzlWYU5aU0F2?=
 =?utf-8?B?RUN2dTdGOHU3Q0ZYcVF2Zjhya1VicFFuOGwwM2dXb0xpM2Vzd1dTKzVoS1A5?=
 =?utf-8?B?Wmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b5411f7a-4bce-4ff7-6d5b-08dad9b4a3c0
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5052.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 07:11:49.4601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8e9sJrk0oZ6cWIKw2htN58hSCR0q7apEZLROmNu39ch0z7op3hs6KQ+MfQ15BOEqCpJofSgs+1xrMtydsM8Lng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4882
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/8/2022 2:25 PM, Xiaoyao Li wrote:
> For IceLake-server, it's just the same as using the default PT
> feature set since the default one is exact taken from ICX.
> 
> For Snowridge, define it according to real SNR silicon capabilities.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  target/i386/cpu.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 24f3c7b06698..ef574c819671 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -3458,6 +3458,14 @@ static const X86CPUDefinition builtin_x86_defs[] = {
>          .features[FEAT_6_EAX] =
>              CPUID_6_EAX_ARAT,
>          /* Missing: Mode-based execute control (XS/XU), processor tracing, TSC scaling */
> +        .features[FEAT_14_0_EBX] =
> +            CPUID_14_0_EBX_CR3_FILTER | CPUID_14_0_EBX_PSB |
> +            CPUID_14_0_EBX_IP_FILTER | CPUID_14_0_EBX_MTC,
> +        .features[FEAT_14_0_ECX] =
> +            CPUID_14_0_ECX_TOPA | CPUID_14_0_ECX_MULTI_ENTRIES |
> +            CPUID_14_0_ECX_SINGLE_RANGE,
> +        .features[FEAT_14_1_EAX] = 0x249 << 16 | 0x2,
> +        .features[FEAT_14_1_EBX] = 0x003f << 16 | 0x1fff,
>          .features[FEAT_VMX_BASIC] = MSR_VMX_BASIC_INS_OUTS |
>               MSR_VMX_BASIC_TRUE_CTLS,
>          .features[FEAT_VMX_ENTRY_CTLS] = VMX_VM_ENTRY_IA32E_MODE |
> @@ -3735,6 +3743,16 @@ static const X86CPUDefinition builtin_x86_defs[] = {
>              CPUID_XSAVE_XGETBV1,
>          .features[FEAT_6_EAX] =
>              CPUID_6_EAX_ARAT,
> +        .features[FEAT_14_0_EBX] =
> +            CPUID_14_0_EBX_CR3_FILTER | CPUID_14_0_EBX_PSB |
> +            CPUID_14_0_EBX_IP_FILTER | CPUID_14_0_EBX_MTC |
> +            CPUID_14_0_EBX_PTWRITE | CPUID_14_0_EBX_POWER_EVENT |
> +            CPUID_14_0_EBX_PSB_PMI_PRESERVATION,
> +        .features[FEAT_14_0_ECX] =
> +            CPUID_14_0_ECX_TOPA | CPUID_14_0_ECX_MULTI_ENTRIES |
> +            CPUID_14_0_ECX_SINGLE_RANGE | CPUID_14_0_ECX_LIP,
> +        .features[FEAT_14_1_EAX] = 0x249 << 16 | 0x2,
> +        .features[FEAT_14_1_EBX] = 0x003f << 16 | 0xffff,
>          .features[FEAT_VMX_BASIC] = MSR_VMX_BASIC_INS_OUTS |
>               MSR_VMX_BASIC_TRUE_CTLS,
>          .features[FEAT_VMX_ENTRY_CTLS] = VMX_VM_ENTRY_IA32E_MODE |

Is it acceptable to add the whole FEATURE_WORDS in the default version
of CPU model, or need to put in the versioned one (e.g. Snowridge-v5)?

