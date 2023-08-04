Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9880476F97D
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 07:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233312AbjHDFRl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 01:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbjHDFQE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 01:16:04 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F4944A1;
        Thu,  3 Aug 2023 22:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691126066; x=1722662066;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=2uV1v8SUihQ21sBVJ6I1syiD6Gv+QRlTURiOcUaX74E=;
  b=SqtNQerKMm68m65K7eInikduTKFfCkeKpE7xuVEV63by6OndcZMW102j
   it2x/yJ/fhbCyxP7AX2AqFz1ry0rov5aK9v4OXWXA+ABy8s6Hu57vyxTl
   usXWYj2htfbVL8riRO3UV+NRln0Ycb/3cU4o3E7k4zVzIMdrVJFlk3WLm
   XJJMvVjhcEr4PlOKI2xZ7BwMYtQ1y9Pux2aDnMydp4Rz1JZU4irAwoW1m
   0eGdVejMUEeAPk5DDfBAnM6WRsonfkySLf0DOVkq3fjVB9chKiFczDszl
   ykZOeCxbGWxuk2tA7TR158Otkhfm41cTVEKLG5fwZTaAh2OJHxNWS53HE
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="355002976"
X-IronPort-AV: E=Sophos;i="6.01,254,1684825200"; 
   d="scan'208";a="355002976"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 22:14:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="729911418"
X-IronPort-AV: E=Sophos;i="6.01,254,1684825200"; 
   d="scan'208";a="729911418"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 03 Aug 2023 22:14:24 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 3 Aug 2023 22:14:24 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 3 Aug 2023 22:14:24 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 3 Aug 2023 22:14:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aQafmso/ALU8/LZlLJNgldj6lg/+0G0uKeCCuiU0DCBKT8wYxgYfl/J2mVH350LLIZX+Tv/SNv5Q1u9G0Wzt01s1UkPDDEkX//L4lzOjExWIPZeTb00xbrj2oJY97XaHIfXEC4EkNEZhdx1c0sKeGSviu+RB2TLiu7xH6Kc/mBgj4cOqhEF+lWW+AtcyV45EPFj9+pLGsU9P0CcMEwaXxRta+jTbuz3410BDTbfnfZR2+I0L4W0ZWvMIHr+xrCQQCelyId6I3jKUU2039pv6t1VbnAIzi6hjUxduTtLhII0ei7jqaNmArBMM3cXCXOLioW0/TYW7GRqHN0qejOsg/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=soysEilY9em2l40aFJ0GJnhhi5pjSH5zAsNMNeJekjI=;
 b=F9o6qlZozcZtrhGMG1Vkr9C2ni83sSfCIUVawW8FYvxp+MbIWVyAAUQvmiJA/ePpjz6l1Pd/tRZm13ei+vC2sjhW7Sn2GpKJZMNFSpXGzRelYkiEc9lnCmsbaT+7NLhxFF93ctBC7E/WoQYJm5Pg2j9J2sYsMyIpclcEVZQdThucvSsZIBv8v6qgH6WDtlcgnY/hU7jwkpHWHc95gkQqE5f1B8gqGVb2E2sDSYs3RKeo+dfQ6WF2zlog6eJG2/cYTZTClEdX8vtape/gXKa8piESTQMfACz6ILp+aKcxJj0FAge8upILl+O69JwijbLDYLfWrmYz7KKDdnZVKItRJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by SA1PR11MB7087.namprd11.prod.outlook.com (2603:10b6:806:2b5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.47; Fri, 4 Aug
 2023 05:14:21 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::146e:30d4:7f1e:7f4b]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::146e:30d4:7f1e:7f4b%3]) with mapi id 15.20.6631.046; Fri, 4 Aug 2023
 05:14:21 +0000
Date:   Fri, 4 Aug 2023 13:14:10 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v5 11/19] KVM:VMX: Emulate read and write to CET MSRs
Message-ID: <ZMyJIq4CgXxudJED@chao-email>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-12-weijiang.yang@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230803042732.88515-12-weijiang.yang@intel.com>
X-ClientProxiedBy: SI1PR02CA0002.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::16) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|SA1PR11MB7087:EE_
X-MS-Office365-Filtering-Correlation-Id: 509c7836-407b-4914-e41e-08db94a9a8f7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 476bCRRzH7CtDyCXsHB0LXegzLFYU9QAC7e5+ZqHGvW1k5WcZOjs8j1OSRyTMm5DpsuvSVRhDA+E9QaBiD7ktxD0fjPyVPd1eQZZpXJVnDZBIXo23tvOv48HQELeZtLiopEnh8SZRICbNZGSXOHrLgZJFSk6vvu9RCxw5hNCRwK8gJGkeWt12jpQSv45vF4/IZs9hqwQ7ptwm0R1hxwfyDCC2xz3MFl+qUSMfnZ1k8l0VY/4Vr3L0D8wkfO4uzwuf3L5tSwLSbxra8+wQm82Oud4+fn5YJui5DrTZUb6GxyB0yXJEr30tInH2EZFbzAGpOy8xrWtRoM/+/OCckYPyASTkrXCS968seLC/jkcaIj+2wEMQ9Vim2N+hMfqfnpIi+yZQ4cWVtt0azt9ljUajzXvp9VNGZQ10MoR2QoRr9NPRan5ArONNr+7a8Njz975+bj2He32BeGmffncr555c+TDIkpcbuxxQ239gW1MSMQ/gIgQRM6whBw4oaY5jKNomflPgXayCf62Q6qUfpYV5Iu6YB2kAFoHdArm88du23Sd7BBtU5YSnZzk7kgBQ+5E
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(346002)(396003)(376002)(136003)(366004)(451199021)(1800799003)(186006)(66476007)(66556008)(66946007)(316002)(4326008)(44832011)(6636002)(5660300002)(6862004)(26005)(41300700001)(6506007)(8676002)(8936002)(33716001)(9686003)(478600001)(6666004)(6486002)(6512007)(38100700002)(82960400001)(2906002)(86362001)(30864003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?Ylj0XYvMvaHQgYLgi2gmo4BnIb8ig//iMQ3c2A4s/LDbdxl/3Y94bLYzis?=
 =?iso-8859-1?Q?fLS2Sv4d+oqF57SWfqvfviNvIcCGVGat+Cs4sgvX5hLuLUoS92kJiJm720?=
 =?iso-8859-1?Q?Dp4R/VJtgjRrOzmIyywWIDP5ion9ZA5u//BONdwvjkHSnHx62UiqssTIqJ?=
 =?iso-8859-1?Q?mit7UHLcWIQo8BX++9vRVkxfauT2My5WSIlYbxKjX4vpyyHfGFH56qKdyx?=
 =?iso-8859-1?Q?oYoHY8ZshayUJCgdBBUNCfDWozIFRYsRC7t8lsQdfIZy9XB2iEPHGSObDp?=
 =?iso-8859-1?Q?xhgfNuIBRTh2d4umpsxgjDUSzNJBQC9YUv5vI6AtUVTGF0m7gdMgXrBl+p?=
 =?iso-8859-1?Q?Zc9j9BOgyrFMjp2PMGam/T1+7JmZbdv2cdG048qEuCCHqSXWT2xP2Qe8Er?=
 =?iso-8859-1?Q?o03A+lDqdZYqEM0Nd+YD033hFOvZdoqjiN8Uu74NqNKZGjN8XkeClTfCOR?=
 =?iso-8859-1?Q?TD24V3IlMwDWW1vAL5OZZ9/QuCgV+w66pnn6w0nhdpp2ST2GkLyAuEXbdD?=
 =?iso-8859-1?Q?HkUDah3EWN2aRDvHfIom82aNUPM3W0EPAK8kasmllPrxJiSTzghODM1myM?=
 =?iso-8859-1?Q?ScxOaSMPdkxd6EY9l4qHUsnSuaa2Pk82wpdSyUvMwKlzJsVBCxpVM8uPEW?=
 =?iso-8859-1?Q?DC5X6KAyYLB66cN8waH2t2j0ly0d2YZm/D69WCR6DQ2lPnywmu1mtlbKhc?=
 =?iso-8859-1?Q?YPhGSTsn8eoYjyh2v2K3Nr11zzoBHKpjGGKGm1oqvEALAM5F1T+E4ODJlT?=
 =?iso-8859-1?Q?t8DHGkvCo+HWb46QGAprMv+FXpYPH4qMJO5rGqWefKYibwUj7DF0GiN82F?=
 =?iso-8859-1?Q?CtwLex20IePa4HfEkeq06hSgVF3sP2JN25wm6hnpcrIFze8tSn6iABp114?=
 =?iso-8859-1?Q?Zq/hNvxLV4ZGege2yN7v1CMnAFkDrz+onYPm1feJihJ7ijtQbp1+7UWWnL?=
 =?iso-8859-1?Q?ZuqgZJGj4Ffp29uIvUdTJYqtstiuPIW/+worGIRNtrN6XPFlTIFeXth9pW?=
 =?iso-8859-1?Q?YOdh940tftliaYg+rxvE3/f7d/CRT7iR9w63HUoE+mX+tnlgvQ+k0YAQlG?=
 =?iso-8859-1?Q?sen5Tg4/IidWUzSpbtmx1/e6KqaXUDnHE+1EJfU3AO0SgEdIOBaOfmOyhH?=
 =?iso-8859-1?Q?Y3x+1stFBXvQ2aSEvYacILUNFZch0iQy8zc3TMU/DpBtnCzv0gT7y0gKDp?=
 =?iso-8859-1?Q?lAA82NYpNw4vCH53cZhRm1ps6opWN+7c4V51vSTAcq75DzNOJehniZiMta?=
 =?iso-8859-1?Q?vzjRtJ67aMTrZF4qnIQiWx+zkAH9MnDBy6lS5o6mKuwNo88dYmiDDijGdU?=
 =?iso-8859-1?Q?CDMD3VCeDoDwJx+zPE2VddVn2GIZ4shW1otUgohBsnaEN85UiYgyXZlLO/?=
 =?iso-8859-1?Q?S30UCmedu/v+/2xdBD3+LkfapF5eWMDlC8t/TwcI+mLb2Wgx8j+/WD+WFP?=
 =?iso-8859-1?Q?70cRgmV/rB7UEyzByxBAEy2zzcj47HBrgwHyxFTPtb88f9onHzu1VzXp0u?=
 =?iso-8859-1?Q?hmnvHxIAsfwswES9ujQj3r5p3QpeCzYHRowXU7f8pK65goQQTbTaKP2fTw?=
 =?iso-8859-1?Q?GegR2b7ALrFkSrjrV+Hqi/qmgF4W5aDr1bvhUKe4zFgi921SxL8cW7YmQO?=
 =?iso-8859-1?Q?b4y0+2y385coCNHgl/jbIzLlWTunGgIeVM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 509c7836-407b-4914-e41e-08db94a9a8f7
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2023 05:14:21.1224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zDEI5BuW+Z6SYfxP/NvIsVMBMkJjfcCsmgvIwum7A9j7mk1QZvF9ajX49r7309PKm7fMh9h0BT0dWukm2lK80A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7087
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 03, 2023 at 12:27:24AM -0400, Yang Weijiang wrote:
>Add emulation interface for CET MSR read and write.
>The emulation code is split into common part and vendor specific
>part, the former resides in x86.c to benefic different x86 CPU
>vendors, the latter for VMX is implemented in this patch.
>
>Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>---
> arch/x86/kvm/vmx/vmx.c |  27 +++++++++++
> arch/x86/kvm/x86.c     | 104 +++++++++++++++++++++++++++++++++++++----
> arch/x86/kvm/x86.h     |  18 +++++++
> 3 files changed, 141 insertions(+), 8 deletions(-)
>
>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index 6aa76124e81e..ccf750e79608 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -2095,6 +2095,18 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> 		else
> 			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
> 		break;
>+	case MSR_IA32_S_CET:
>+	case MSR_KVM_GUEST_SSP:
>+	case MSR_IA32_INT_SSP_TAB:
>+		if (kvm_get_msr_common(vcpu, msr_info))
>+			return 1;
>+		if (msr_info->index == MSR_KVM_GUEST_SSP)
>+			msr_info->data = vmcs_readl(GUEST_SSP);
>+		else if (msr_info->index == MSR_IA32_S_CET)
>+			msr_info->data = vmcs_readl(GUEST_S_CET);
>+		else if (msr_info->index == MSR_IA32_INT_SSP_TAB)
>+			msr_info->data = vmcs_readl(GUEST_INTR_SSP_TABLE);

This if-else-if suggests that they are focibly grouped together to just
share the call of kvm_get_msr_common(). For readability, I think it is better
to handle them separately.

e.g.,
	case MSR_IA32_S_CET:
		if (kvm_get_msr_common(vcpu, msr_info))
			return 1;
		msr_info->data = vmcs_readl(GUEST_S_CET);
		break;

	case MSR_KVM_GUEST_SSP:
		if (kvm_get_msr_common(vcpu, msr_info))
			return 1;
		msr_info->data = vmcs_readl(GUEST_SSP);
		break;

	...


>+		break;
> 	case MSR_IA32_DEBUGCTLMSR:
> 		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
> 		break;
>@@ -2404,6 +2416,18 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> 		else
> 			vmx->pt_desc.guest.addr_a[index / 2] = data;
> 		break;
>+	case MSR_IA32_S_CET:
>+	case MSR_KVM_GUEST_SSP:
>+	case MSR_IA32_INT_SSP_TAB:
>+		if (kvm_set_msr_common(vcpu, msr_info))
>+			return 1;
>+		if (msr_index == MSR_KVM_GUEST_SSP)
>+			vmcs_writel(GUEST_SSP, data);
>+		else if (msr_index == MSR_IA32_S_CET)
>+			vmcs_writel(GUEST_S_CET, data);
>+		else if (msr_index == MSR_IA32_INT_SSP_TAB)
>+			vmcs_writel(GUEST_INTR_SSP_TABLE, data);

ditto

>+		break;
> 	case MSR_IA32_PERF_CAPABILITIES:
> 		if (data && !vcpu_to_pmu(vcpu)->version)
> 			return 1;
>@@ -4864,6 +4888,9 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> 		vmcs_write64(GUEST_BNDCFGS, 0);
> 
> 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);  /* 22.2.1 */
>+	vmcs_writel(GUEST_SSP, 0);
>+	vmcs_writel(GUEST_S_CET, 0);
>+	vmcs_writel(GUEST_INTR_SSP_TABLE, 0);

where are MSR_IA32_PL3_SSP and MSR_IA32_U_CET reset?

I thought that guest FPU would be reset in kvm_vcpu_reset(). But it turns out
only MPX states are reset in KVM while other FPU states are unchanged. This
is aligned with "Table 10.1 IA-32 and Intel® 64 Processor States Following
Power-up, Reset, or INIT"

Could you double confirm the hardware beahavior that CET states are reset to 0
on INIT? If CET states are reset, we need to handle CET_IA32_PL3_SSP and
MSR_IA32_U_CET like MPX.

> 
> 	kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
> 
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index 5b63441fd2d2..98f3ff6078e6 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -3627,6 +3627,39 @@ static bool kvm_is_msr_to_save(u32 msr_index)
> 	return false;
> }
> 
>+static inline bool is_shadow_stack_msr(u32 msr)
>+{
>+	return msr == MSR_IA32_PL0_SSP ||
>+		msr == MSR_IA32_PL1_SSP ||
>+		msr == MSR_IA32_PL2_SSP ||
>+		msr == MSR_IA32_PL3_SSP ||
>+		msr == MSR_IA32_INT_SSP_TAB ||
>+		msr == MSR_KVM_GUEST_SSP;
>+}
>+
>+static bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu,
>+				      struct msr_data *msr)
>+{
>+	if (is_shadow_stack_msr(msr->index)) {
>+		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK))
>+			return false;
>+
>+		if (msr->index == MSR_KVM_GUEST_SSP)
>+			return msr->host_initiated;
>+
>+		return msr->host_initiated ||
>+			guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
>+	}
>+
>+	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
>+	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
>+		return false;
>+
>+	return msr->host_initiated ||
>+		guest_cpuid_has(vcpu, X86_FEATURE_IBT) ||
>+		guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
>+}
>+
> int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> {
> 	u32 msr = msr_info->index;
>@@ -3981,6 +4014,45 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> 		vcpu->arch.guest_fpu.xfd_err = data;
> 		break;
> #endif
>+#define CET_EXCLUSIVE_BITS		(CET_SUPPRESS | CET_WAIT_ENDBR)
>+#define CET_CTRL_RESERVED_BITS		GENMASK(9, 6)
>+#define CET_SHSTK_MASK_BITS		GENMASK(1, 0)
>+#define CET_IBT_MASK_BITS		(GENMASK_ULL(5, 2) | \
>+					 GENMASK_ULL(63, 10))
>+#define CET_LEG_BITMAP_BASE(data)	((data) >> 12)
>+	case MSR_IA32_U_CET:
>+	case MSR_IA32_S_CET:
>+		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
>+			return 1;
>+		if (!!(data & CET_CTRL_RESERVED_BITS))
>+			return 1;
>+		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK) &&
>+		    (data & CET_SHSTK_MASK_BITS))
>+			return 1;
>+		if (!guest_can_use(vcpu, X86_FEATURE_IBT) &&
>+		    (data & CET_IBT_MASK_BITS))
>+			return 1;
>+		if (!IS_ALIGNED(CET_LEG_BITMAP_BASE(data), 4) ||
>+		    (data & CET_EXCLUSIVE_BITS) == CET_EXCLUSIVE_BITS)
>+			return 1;
>+		if (msr == MSR_IA32_U_CET)

can you add a comment before this if() statement like?
		/* MSR_IA32_S_CET is handled by vendor code */

>+	case MSR_KVM_GUEST_SSP:
>+	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
>+		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
>+			return 1;
>+		if (is_noncanonical_address(data, vcpu))
>+			return 1;
>+		if (!IS_ALIGNED(data, 4))
>+			return 1;
>+		if (msr == MSR_IA32_PL0_SSP || msr == MSR_IA32_PL1_SSP ||
>+		    msr == MSR_IA32_PL2_SSP) {
>+			vcpu->arch.cet_s_ssp[msr - MSR_IA32_PL0_SSP] = data;
>+		} else if (msr == MSR_IA32_PL3_SSP) {
>+			kvm_set_xsave_msr(msr_info);
>+		}

brackets are not needed.

also add a comment for MSR_KVM_GUEST_SSP.

>+		break;
> 	default:
> 		if (kvm_pmu_is_valid_msr(vcpu, msr))
> 			return kvm_pmu_set_msr(vcpu, msr_info);
>@@ -4051,7 +4123,9 @@ static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
> 
> int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> {
>-	switch (msr_info->index) {
>+	u32 msr = msr_info->index;
>+
>+	switch (msr) {
> 	case MSR_IA32_PLATFORM_ID:
> 	case MSR_IA32_EBL_CR_POWERON:
> 	case MSR_IA32_LASTBRANCHFROMIP:
>@@ -4086,7 +4160,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> 	case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
> 	case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
> 	case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL1:
>-		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
>+		if (kvm_pmu_is_valid_msr(vcpu, msr))
> 			return kvm_pmu_get_msr(vcpu, msr_info);
> 		msr_info->data = 0;
> 		break;
>@@ -4137,7 +4211,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> 	case MSR_MTRRcap:
> 	case MTRRphysBase_MSR(0) ... MSR_MTRRfix4K_F8000:
> 	case MSR_MTRRdefType:
>-		return kvm_mtrr_get_msr(vcpu, msr_info->index, &msr_info->data);
>+		return kvm_mtrr_get_msr(vcpu, msr, &msr_info->data);
> 	case 0xcd: /* fsb frequency */
> 		msr_info->data = 3;
> 		break;
>@@ -4159,7 +4233,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> 		msr_info->data = kvm_get_apic_base(vcpu);
> 		break;
> 	case APIC_BASE_MSR ... APIC_BASE_MSR + 0xff:
>-		return kvm_x2apic_msr_read(vcpu, msr_info->index, &msr_info->data);
>+		return kvm_x2apic_msr_read(vcpu, msr, &msr_info->data);
> 	case MSR_IA32_TSC_DEADLINE:
> 		msr_info->data = kvm_get_lapic_tscdeadline_msr(vcpu);
> 		break;
>@@ -4253,7 +4327,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> 	case MSR_IA32_MCG_STATUS:
> 	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
> 	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
>-		return get_msr_mce(vcpu, msr_info->index, &msr_info->data,
>+		return get_msr_mce(vcpu, msr, &msr_info->data,
> 				   msr_info->host_initiated);
> 	case MSR_IA32_XSS:
> 		if (!msr_info->host_initiated &&
>@@ -4284,7 +4358,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> 	case HV_X64_MSR_TSC_EMULATION_STATUS:
> 	case HV_X64_MSR_TSC_INVARIANT_CONTROL:
> 		return kvm_hv_get_msr_common(vcpu,
>-					     msr_info->index, &msr_info->data,
>+					     msr, &msr_info->data,
> 					     msr_info->host_initiated);
> 	case MSR_IA32_BBL_CR_CTL3:
> 		/* This legacy MSR exists but isn't fully documented in current
>@@ -4337,8 +4411,22 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> 		msr_info->data = vcpu->arch.guest_fpu.xfd_err;
> 		break;
> #endif
>+	case MSR_IA32_U_CET:
>+	case MSR_IA32_S_CET:
>+	case MSR_KVM_GUEST_SSP:
>+	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
>+		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
>+			return 1;
>+		if (msr == MSR_IA32_PL0_SSP || msr == MSR_IA32_PL1_SSP ||
>+		    msr == MSR_IA32_PL2_SSP) {
>+			msr_info->data =
>+				vcpu->arch.cet_s_ssp[msr - MSR_IA32_PL0_SSP];
>+		} else if (msr == MSR_IA32_U_CET || msr == MSR_IA32_PL3_SSP) {
>+			kvm_get_xsave_msr(msr_info);
>+		}

Again, for readability and clarity, how about:

	case MSR_IA32_U_CET:
	case MSR_IA32_PL3_SSP:
		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
			return 1;
		kvm_get_xsave_msr(msr_info);
		break;
	case MSR_IA32_PL0_SSP ... MSR_IA32_PL2_SSP:
		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
			return 1;
		msr_info->data = vcpu->arch.cet_s_ssp[msr - MSR_IA32_PL0_SSP];
		break;
	case MSR_IA32_S_CET:
	case MSR_KVM_GUEST_SSP:
		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
			return 1;
		/* Further handling in vendor code */
		break;

>+		break;
> 	default:
>-		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
>+		if (kvm_pmu_is_valid_msr(vcpu, msr))
> 			return kvm_pmu_get_msr(vcpu, msr_info);
> 
> 		/*
>@@ -4346,7 +4434,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> 		 * to-be-saved, even if an MSR isn't fully supported.
> 		 */
> 		if (msr_info->host_initiated &&
>-		    kvm_is_msr_to_save(msr_info->index)) {
>+		    kvm_is_msr_to_save(msr)) {
> 			msr_info->data = 0;
> 			break;
> 		}
>diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>index c69fc027f5ec..3b79d6db2f83 100644
>--- a/arch/x86/kvm/x86.h
>+++ b/arch/x86/kvm/x86.h
>@@ -552,4 +552,22 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
> 			 unsigned int port, void *data,  unsigned int count,
> 			 int in);
> 
>+/*
>+ * Guest xstate MSRs have been loaded in __msr_io(), disable preemption before
>+ * access the MSRs to avoid MSR content corruption.
>+ */

I think it is better to describe what the function does prior to jumping into
details like where guest FPU is loaded.

/*
 * Lock and/or reload guest FPU and access xstate MSRs. For accesses initiated
 * by host, guest FPU is loaded in __msr_io(). For accesses initiated by guest,
 * guest FPU should have been loaded already.
 */
>+static inline void kvm_get_xsave_msr(struct msr_data *msr_info)
>+{
>+	kvm_fpu_get();
>+	rdmsrl(msr_info->index, msr_info->data);
>+	kvm_fpu_put();
>+}
>+
>+static inline void kvm_set_xsave_msr(struct msr_data *msr_info)
>+{
>+	kvm_fpu_get();
>+	wrmsrl(msr_info->index, msr_info->data);
>+	kvm_fpu_put();
>+}

Can you rename functions to kvm_get/set_xstate_msr() to align with the comment
and patch 6? And if there is no user outside x86.c, you can just put these two
functions right after the is_xstate_msr() added in patch 6.

>+
> #endif
>-- 
>2.27.0
>
