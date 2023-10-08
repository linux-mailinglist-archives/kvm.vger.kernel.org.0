Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEB87BCC8B
	for <lists+kvm@lfdr.de>; Sun,  8 Oct 2023 08:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344423AbjJHGTw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Oct 2023 02:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344392AbjJHGTv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Oct 2023 02:19:51 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 843ACC5;
        Sat,  7 Oct 2023 23:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696745990; x=1728281990;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Q35okryWKSw19J8EAbtJcqBw5J2PP+6iQwrSTVdTHlM=;
  b=NfSFI6IsFcQ0nnc7gb6EWzEPC8VkosRXPbjR5cs+bj0jdkytxXKNXbZh
   vN2TN33xrrwnjF6+/ZsqNNUxpEE+g+XOdK73ZkBE0d1A4MbwOCV73ssH9
   mfsTk+26NlwmHTzHW39wN5e9d4kllfArOm0+W0SGxth2JGfvIwwk/5vbb
   DtrB3m6ywQt/8InuS2Ppew1p47vEAQv5quQ3e6R3lMPrsSsVKmOOkR0sZ
   M+0AX+i/3beTX4rFquS0flTnmjCQT+LTThOoT40AavJOEoFzozbwmIJpr
   JJsARs+X2tCn3Tk+e/Nem9uXoaV7BL7Dah/sxTKGz+soz1BOcQdPtBadN
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10856"; a="381241309"
X-IronPort-AV: E=Sophos;i="6.03,207,1694761200"; 
   d="scan'208";a="381241309"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2023 23:19:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10856"; a="702526775"
X-IronPort-AV: E=Sophos;i="6.03,207,1694761200"; 
   d="scan'208";a="702526775"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Oct 2023 23:19:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Sat, 7 Oct 2023 23:19:48 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Sat, 7 Oct 2023 23:19:48 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.48) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Sat, 7 Oct 2023 23:19:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sq3/ZkHzxXgoMxTN1LmraF7tT2gcZAh4U0wc+rLoixMPFN5+hUi0Gqag9KORdQVYc3RBVU+QV/Tsi+r58QksddqIsg8UspCk4d08OH9fJmbF2trY9Nu5DNuS8uu6+qGRUjv57W/9jM2wqMPvZy+GNAAAJvXp5/NEiYAKDNwC9X94kg8VxLpyvKohoUTUnWkLhPaW45OT5zst6IX8jGyVjOTVNnY14aXwsIvtFmJNihFIppSIbVQd8Tz/KF1w8Dqdos1uWWWGmFyIpwUTB0q7/55sG7Lj5dl72hzAEtYBbJXgXAnkenbMz3HyMeM9H9vsj82+jVOHWILIE4pR8wEa3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wNv62R/H7xT530G3XyxAVpzEQgWt4SPan8Q1/zb0zHE=;
 b=KFZ3xXHUEHhYmg6ZiSbL6qXhTUy5YDnpPFQSyogbrJLLtTTctsu1W5GyID75Ly6TQHrpDRKi2q25DmehynvSP8bvygpkNVf4B77ByU1fgbGwBExQ8lM+iEPX4XVbBeWvzws9lnOx/fVP8WNRyUV1VfTjTr2QCl1ixsOg+VTV//1LELzJxD6+UKik8GHu9mMJnfyVfemM9B+0IeecZNI1ys7X/CwEn9+DKByuQJf3NybwkW3kEl+24ZiPRDaUYTPddIBdDd0bGZ28iBfa/w1CM6SJrtKilxGP5pmEryhsEMWsJyjU8O8+gWIrDojAZB+KWGdcnu5w/FQmslDqBO/Q+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by SN7PR11MB6557.namprd11.prod.outlook.com (2603:10b6:806:26f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.43; Sun, 8 Oct
 2023 06:19:30 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5d9f:7e54:4218:159f]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5d9f:7e54:4218:159f%7]) with mapi id 15.20.6813.017; Sun, 8 Oct 2023
 06:19:29 +0000
Date:   Sun, 8 Oct 2023 14:19:18 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <dave.hansen@intel.com>,
        <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
        <john.allen@amd.com>
Subject: Re: [PATCH v6 16/25] KVM: x86: Report KVM supported CET MSRs as
 to-be-saved
Message-ID: <ZSJJ5jlNtgrVP+Qw@chao-email>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-17-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230914063325.85503-17-weijiang.yang@intel.com>
X-ClientProxiedBy: SG2PR03CA0099.apcprd03.prod.outlook.com
 (2603:1096:4:7c::27) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|SN7PR11MB6557:EE_
X-MS-Office365-Filtering-Correlation-Id: 063b2226-0c6b-4648-a170-08dbc7c68767
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZESS8eE4iPmt5sdJ09uI2CxORdc1V9zO1jlsYEyEgL2h9ecrhSxBVIsAO5nWbzWWRJfoAKAxIeBlpvBq8ZoC+Kal1xpXqU5UCXuUh81w7NG3wY2T6/atelwO5KRHXS73EdQDQViaJalU/gyB8C6pf+C52+yUe5US+eu+ZZk0qQqlAFRpMvwntXgGOCUw5t7AR+YsXA4cHBqFjAF92XlYtu5nN5qxG1bsD53hXhfSsW52F8/7XduofX7eV54dsJBGt84xa9TytQU11pGZNbz70cjL6NMNgB3tamikxNhW0AP8qu6OcBu4OcZsFQ3QWPxNZ7nxoKmQ6epsjoEGze4FUsCqphbpMDYSoi2hwwTWt4o2W6QktJvplXxNbJzbMVDE7QFZoqZi6cV2qz83FCIpU8ZgDP/nqSxGsHKtE8UPqnTJRq5QEl0v3k9ENx+h6zTpBLOpAFBanJwq+Z7CrYZl2c1M7zIgSyJIRpxFcS6RxVT4bC1c8WfGndNAu3fS2P0cSE6UFYnrz48fIPg3QUdmitP04uea8LlvpSjiqzBmfNK8BWC/gwqk/pnqiK8i14jIT94yXZyNlh7rw43ynEAnCCbFwCpweMFqNc3OwWKKPmE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(136003)(346002)(39860400002)(396003)(376002)(366004)(230922051799003)(186009)(64100799003)(1800799009)(451199024)(6666004)(6486002)(478600001)(66556008)(66946007)(66476007)(6636002)(82960400001)(6512007)(38100700002)(6506007)(26005)(9686003)(33716001)(316002)(5660300002)(41300700001)(44832011)(8936002)(8676002)(2906002)(4326008)(6862004)(86362001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MeSxji5tsyuGo2JhmBJAszDlXI3NLl2+iMooVyty9G/YDrpqarww/WbuviHw?=
 =?us-ascii?Q?lyPkNrwhdm8XAWDWiQDOcafkNJhTej7c57rYjI+Qwook3zZLiQGlIc/cPXcz?=
 =?us-ascii?Q?MOBMQ1su4OZyYtvzpLf+KWBHe5LCg+O75nWQ4lAsr6WpIHTmCPNcKsRlrRU+?=
 =?us-ascii?Q?qJbS3eJ3Xnu+wo/hyEYuINEOiARZl+2pQ17rSRKnGHFPtHqc4UvvVFtEphp/?=
 =?us-ascii?Q?EEoVJlmIN1k02+iTE2TmKGwgjYWOeXTpvTOEaalOpFls/N6nrTteV2/kT7B4?=
 =?us-ascii?Q?q6hqKg1kR2AqZqJXLqplKP0uvb1WTBpielGLNfgIMTpCQHJfxoPLvsRRVsg5?=
 =?us-ascii?Q?RLZikaHcJNBfjmKkaCelpf3oXfj9hB+5tcpV3fTYVFHQrbghgXv2NUggjufk?=
 =?us-ascii?Q?lHd+BHuryxcBHcDVgchROXHkaDlwkaLjsXgM4Ox8fL4J2c9Of909UpNa52Na?=
 =?us-ascii?Q?obre68PmWIttRhFBsNuWmIDHwmqrCGeTznz7rpp1kbUch/JwRPP7JFr5cOw6?=
 =?us-ascii?Q?WMPsYdpveicBeQIgI+UcJJG+7GoVs1ZUpUNlw0J5wvJ7IApXmrKvqsOlA4r7?=
 =?us-ascii?Q?Vvc+AUeCYXvL3jP32PnmeyxvmIoMGvDHvzMA9ii7v12/WgRmIyKI2TH6I+4U?=
 =?us-ascii?Q?fEhLfwcRTpDJqTB+V/ptKbUePQfmz/E+Ti66I87HR+JKsEjEQvaAuQQuvu2u?=
 =?us-ascii?Q?9QuKTr0A3MCUVKjzj/ai8jhjTixsIPufN/u2WhwiZocKIGgyl9kqYOcdjFwe?=
 =?us-ascii?Q?3eWd15soIvsqh7vbWMXC7guSYaU2XgfROJE6yEyFHkWwXPmPwlnItzIZaV9O?=
 =?us-ascii?Q?COVECMlpfxN+ImWh47iExfedb8r2CH+xE90vd1yr+1dKpcdnLn/YURmvk8n6?=
 =?us-ascii?Q?IdmBs8y/daLlSdPOV6EECxdKvSMbfHtb80NMHCVIvNS5blOblQNkdZE238nL?=
 =?us-ascii?Q?Fi6pgV8nNk5AZPm5Ob5N4xQuJQ9sSQQ9afy7Vt1rAdN7DOM6M/gS3r32AuP4?=
 =?us-ascii?Q?eX2ZbfyhBQRW9CUYQdvSBUM9NpfVBJn8AG9hEyiqbXBWFgWTTuOBZAiDeElP?=
 =?us-ascii?Q?LAnaHhCapP+5bLAIKo6NEVkk6T+OPyVf9TMeFCA9UiGDXXXtPymFK9yk4IIa?=
 =?us-ascii?Q?4YmbnnVKje3JafYvyGGJnP1s+TQoEO4znBKajTPh9RTkPnwNPHEgBwwo6YRp?=
 =?us-ascii?Q?fcylfft153n8h+b7ddSixutYWPGjzgA60cMdsBjtQib37hF3zpwbCCCh3H1f?=
 =?us-ascii?Q?v1BXN8RD22ycml/+OYRrruBY1pC8f0bPuAyQYg7M9EMbqG8Vi/qgUdOdUQxp?=
 =?us-ascii?Q?bDV8Ohj08HdWhZyPiieOvQ91WDjunTG0qmBH/zDsdWnrqYWZWfJtFX5Y6bye?=
 =?us-ascii?Q?IZs72anTrb+mb6MZdBl6qtn+owcqgrVc4Aj7XtyB01tpdzOD85FvOzUFP4Si?=
 =?us-ascii?Q?wyOXSm/6f35PXsJfB/uiaHwpAVAv6u77dWCnx+wQ1NsbMQCxvkMtsVujqAyo?=
 =?us-ascii?Q?WazylS69+qkku9m1tAk0zSAWXdSEynF7Ny0MpWNK1Z6+QqY8CtiyFb7DcyUa?=
 =?us-ascii?Q?aQizwx8Fk0HBUuZ+2Ovz8JPfvWy3VkOGguhaUNp1?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 063b2226-0c6b-4648-a170-08dbc7c68767
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2023 06:19:29.5827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kJnsewsPfz1Sh59EYuh63SMsYLl4qyDxBMCndADjp0eIGwN91/xfVNHgcfp0S6Mj4JUkwLr2PH5kA/gxvvrFhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6557
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 14, 2023 at 02:33:16AM -0400, Yang Weijiang wrote:
>Add CET MSRs to the list of MSRs reported to userspace if the feature,
>i.e. IBT or SHSTK, associated with the MSRs is supported by KVM.
>
>SSP can only be read via RDSSP. Writing even requires destructive and
>potentially faulting operations such as SAVEPREVSSP/RSTORSSP or
>SETSSBSY/CLRSSBSY. Let the host use a pseudo-MSR that is just a wrapper
>for the GUEST_SSP field of the VMCS.
>
>Suggested-by: Chao Gao <chao.gao@intel.com>
>Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>---
> arch/x86/include/uapi/asm/kvm_para.h |  1 +
> arch/x86/kvm/vmx/vmx.c               |  2 ++
> arch/x86/kvm/x86.c                   | 18 ++++++++++++++++++
> 3 files changed, 21 insertions(+)
>
>diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
>index 6e64b27b2c1e..9864bbcf2470 100644
>--- a/arch/x86/include/uapi/asm/kvm_para.h
>+++ b/arch/x86/include/uapi/asm/kvm_para.h
>@@ -58,6 +58,7 @@
> #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
> #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
> #define MSR_KVM_MIGRATION_CONTROL	0x4b564d08
>+#define MSR_KVM_SSP	0x4b564d09
> 
> struct kvm_steal_time {
> 	__u64 steal;
>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index 72e3943f3693..9409753f45b0 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -7009,6 +7009,8 @@ static bool vmx_has_emulated_msr(struct kvm *kvm, u32 index)
> 	case MSR_AMD64_TSC_RATIO:
> 		/* This is AMD only.  */
> 		return false;
>+	case MSR_KVM_SSP:
>+		return kvm_cpu_cap_has(X86_FEATURE_SHSTK);

For other MSRs in emulated_msrs_all[], KVM doesn't check the associated
CPUID feature bits. Why bother doing this for MSR_KVM_SSP?
