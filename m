Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 353F17BCC77
	for <lists+kvm@lfdr.de>; Sun,  8 Oct 2023 07:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344410AbjJHFzR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Oct 2023 01:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344363AbjJHFzQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Oct 2023 01:55:16 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B594AC;
        Sat,  7 Oct 2023 22:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696744514; x=1728280514;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=jPPKWA5EYoNLKdWcumNhjv596gsUgdt5cmlVdLrcL+Q=;
  b=J/Z7vBimvrfapA/yN6DC0Ovk8lJ+1ObauWYkEOp12H377EpzV79oBHQD
   6IZvfh9ZMvqyERZB0tGRL7cu57L1Jv3+ScamgLnc8bgc3u0BkOrmGEUGA
   ERTGwwzGIVn5Ul8q2TOFPgkDfIIka7DFFjLqcRMV3FJCns4cJVPNmZp/K
   2rLvVHQWfDGxUveMZSZOkNyUuqjFGtxnEufYszAil64NGyRXrDvkWtph4
   vk/XBc9Qy6TGqShDQ9Lxfkyee+rozVPwEf1vSHe++xX1uu0WvRj2wznLI
   cDj4R2w0CIxwvhAdaUCCOnG0xTzE++REkukAgOWYa497kSbsk+9gH8hqD
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10856"; a="448169958"
X-IronPort-AV: E=Sophos;i="6.03,207,1694761200"; 
   d="scan'208";a="448169958"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2023 22:55:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10856"; a="782136497"
X-IronPort-AV: E=Sophos;i="6.03,207,1694761200"; 
   d="scan'208";a="782136497"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Oct 2023 22:55:06 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Sat, 7 Oct 2023 22:55:03 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Sat, 7 Oct 2023 22:55:03 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Sat, 7 Oct 2023 22:55:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zi/jMM6xSmpHVmlKzSjPAjmR0M59TH24wntYMJVcw8Nkbv4kaHm+MJ8+L5/8+lt4rviRn00sDikp01EyIkb63RI5AT4obronecYNZPsjkytgyc0jU/fF4H9e9HJ0cQfYU1yr7uPjHbfqkkAduz3Ac3DSuaByAlpWkwVO542+aWy4f7KkjK/jm/eICVt2D23QeERA5BXrLZMkCiyLPD+QkkxN4Uy+LjKLW0QBhcTPY8sezekgGVz/X105k3eqPXqNBbmpAVZZbKQyOZ03X7mcFuSAaSCHDjPtBXm1YHiMVifa0Gof2HKQ7/z6mR/neRFMtAehxADldt3zRo7+FjUvjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3QK4Cc27XJ7lPfoNKYAxcO0fWunDBu5EdAiM5YaMdu0=;
 b=KIkfvlHrnT0CwMGH6AF00rgiajiYOkwL9n0UTSFrYwJOhSYpGOdERZutT9EmhSbsQu3RDhs9bnnzBag7YbqE0CiTxHg6bwP++potqAw+YcWSHBzjG7VXyPxB0PS9sZw5KBXqV9TnvrZh/tiTdPqQUJF9IFYkJOtdviYsvmOHFLuTKz+5Wqnt4WWUuzHP/r68RG6D25q5nNBBJDJLBb9TMfuOQbpx3ZHKEoYXNn1ArcZKp3xlKynwHn5UGHVoisAky36laJYoPhzQAqmT/hgRaxXigcXhsAtRNqFMhKk2LlbTVoDMy213v4QoiDwqoRuJKThcoQUZWkACxai35mL5YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by CH3PR11MB8562.namprd11.prod.outlook.com (2603:10b6:610:1b8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.36; Sun, 8 Oct
 2023 05:55:01 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5d9f:7e54:4218:159f]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5d9f:7e54:4218:159f%7]) with mapi id 15.20.6813.017; Sun, 8 Oct 2023
 05:55:01 +0000
Date:   Sun, 8 Oct 2023 13:54:49 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <dave.hansen@intel.com>,
        <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
        <john.allen@amd.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Subject: Re: [PATCH v6 12/25] KVM: x86: Refresh CPUID on write to guest
 MSR_IA32_XSS
Message-ID: <ZSJEKcNMwBuO6TW3@chao-email>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-13-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230914063325.85503-13-weijiang.yang@intel.com>
X-ClientProxiedBy: SG2PR02CA0124.apcprd02.prod.outlook.com
 (2603:1096:4:188::9) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|CH3PR11MB8562:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c03f903-aa17-49ab-a87f-08dbc7c31bec
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1MFuaKtluQ2S9fXLa42idsLXF3Pu1a07JxXTnJLGB1sJQlngTT482jf+Fz8vHinxfx9kYIvIL/tnPyaVSyyfb/kTpcocgI1iJL2KIN7qFVW/GIavyA9ZqjHD9e3zei+NF8rHAJX4iouNYaAULbNy7rdZInBrLQG7O+YTIeMwN35FLPrGLEVpqWtigdswsc41c8IVNP3y1CCEfJrrvKd7va2+XiVudNj+U6mtHMIdirASKCCM7d83xa5edTd6mlp1Zq+NqIrTpoukViZ1HPV+j8wDf1VIg4xv7kZ9lX5Oy3BArjK6rBmqNM3XmSvV+hybl3STNF9uwZZCxiIz4sxfLDEPXA6haMcAwdesyWeE3T8tmtrrg8p0LI7SuUsy6y6MAG9IbaV/+301xt3TnfCy54pZnhxdGfalvYX8AHVEqF6PNxVTw5tGBSN78F1lp/ZJNM6u7BWQjvcdNvOcLLc4CPjcQlS+EyDKq2Mrp0FN5bz9hj3TQ8wYMTeOtRZ4FMZb66BlBOnMcVzxXRas0/yjIvgGidehBgcDSCxch+CgmBNVtcNIsSbHN1lMcts914w1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(396003)(366004)(136003)(39860400002)(346002)(376002)(230922051799003)(186009)(1800799009)(451199024)(64100799003)(6506007)(478600001)(6512007)(6666004)(6486002)(9686003)(5660300002)(26005)(82960400001)(38100700002)(86362001)(2906002)(6636002)(33716001)(83380400001)(41300700001)(66476007)(66556008)(8676002)(8936002)(6862004)(44832011)(4326008)(316002)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sPMYzw7H/rureMqKBJKVtfF0LXL3gYS892I9b/L5uAfJHg7RhKXCH2VeJsgp?=
 =?us-ascii?Q?/mHmqZqBhiFTpIT3d084AggCEjGs0Cyz6EQcSJ3qY8v5b5ZuLRdSYPxVL5xG?=
 =?us-ascii?Q?N904MKbTYa265bDKyxDBHP3CYT6VGIHGl/mhjKElwz5PtQ6FM0W+Xh2ixDm+?=
 =?us-ascii?Q?Jr0AMKoHdv3YMFQ3JbaTw5e7WI3J5cdcfyOINNDNy1c0JHjLNkGS4N6mgwXp?=
 =?us-ascii?Q?KiodkhArp9Qc1uaw1fr66PIOxCDi7505NXiqnzynGM5mScmzY4QT2vLWVCAT?=
 =?us-ascii?Q?/n9sr3RRwFJapdYHGSXKCQsg7ZxRxOTtdkuwj026HqowlSg7KV9MTHRLCeu9?=
 =?us-ascii?Q?9ttqfw0Bd+vcudVyBJbmzkxZwMbqTnzAiTYkiMpth4EpHqnFlx5MK5e1Jgxf?=
 =?us-ascii?Q?wJoK64hgyyzMxqj4Hf/vASKC1oSEExpNyUaS1WpGvbJ6QWc4LNZmTyo3DOg4?=
 =?us-ascii?Q?SZiPDXqLNdYcA87DDvVJ55EkjSwRby0jhBE54BLeoKXMTlBwSv8LV5zElRF8?=
 =?us-ascii?Q?FWQv6lTgBBbx2Cg4+jhOsN5TZneZe8FdR42bGQYnKQr1j/u72mUEPk6Igz5f?=
 =?us-ascii?Q?lU40eRC/hieh/Jhsn3Q93+Z24ndKo9M9MOLNYpv0caneaIM4qUUuWqkGm3r9?=
 =?us-ascii?Q?2LEJH8fd/U1XX/JyIjyVYUXjusSwNzOCyfkRuXTMAJfdlSjezPfcHtSF40PC?=
 =?us-ascii?Q?9ELTS8pbNWKvwVZvsqoTq81/2+xuB6EMS/Xe7yR3j2XTi19x8jjUfiA94CEF?=
 =?us-ascii?Q?b3+d/1WnkqZiUe1sfwD6Y4i4S1VJY7xkzzxeb9OytkdKr88bA6Sjbji95lS8?=
 =?us-ascii?Q?lPkwv2TIHP5aU+otVLemMC0x3b7Ip+5hhlc0SMg+PxqnRKJbWy24zmIGaZtR?=
 =?us-ascii?Q?+coyyf2jiAzbQlBWIsSci9iwyiN3R9wIGuQpc4Ji3XnORjAGRgJSpTPof1sd?=
 =?us-ascii?Q?9yfebsrh+aNefN4JvzoMWy4M000o/Y0yyDq6h7NHvWlQGDJ86zXUiX2Nhhui?=
 =?us-ascii?Q?3WlpsA5XH5TgcxBdjRwRYiCEyC3Dutnz52MD5TYHasFmT7tMx9wKkNQ3VYjR?=
 =?us-ascii?Q?ZMyYmHXvCfNTRFQWCIdtWEQj3l0nzw8w6d8rgWtOd/riH0kJ1ydnPBeX+p5m?=
 =?us-ascii?Q?H6vvRomyj0Pm0gyA/EiN/Lasl/xEoaJQsMETRqWjY764ReNVYLDJFrtK9r4s?=
 =?us-ascii?Q?QAEzTe2roxrmvzvh9e74St5uGQcgOghdOWYuq9pQkXCGWfQYNyoFpXlIhNjL?=
 =?us-ascii?Q?rWsiMrQ8nBycWKDcGlNvFksPT/Lg0e5plDEI0WxR+Txh2KFc0cDONv1bw6cm?=
 =?us-ascii?Q?RI3SDbHLk0TmlBIO2IDbhCbynG4iJ0PtKjN9KaqwVl8gzaUUP2wrEwYuQGRA?=
 =?us-ascii?Q?bgF0a8OKfMbi3S5wpudgO1RvqLBSaDSQhZTzzjrbj8Jv7wXtdFQxKDuHXEo3?=
 =?us-ascii?Q?Qw054fcYkNJtBcnr0zoxGC31Oz5g0AAB0D1FoXgymaNVaSQxCCKTSxNpluql?=
 =?us-ascii?Q?Yoz0IC9zHnFsWm+/QJsdU1Va8FKVnF981c9SYrdSpAMvMTuYI7GCJ2nvh40Y?=
 =?us-ascii?Q?bB7otyjqlf/TCkQ/l63GcoJ/TT4y8/QLN8OfOO9I?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c03f903-aa17-49ab-a87f-08dbc7c31bec
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2023 05:55:00.7617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5l3ILbIHHwQRsLcHl1riEbO3/kC0pbpRVTtLjiqZ01fMN+Ci86tvD/xeilPyMtu0AX1Ezgz4s8fw5FEavjFxLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8562
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>index 0fc5e6312e93..d77b030e996c 100644
>--- a/arch/x86/include/asm/kvm_host.h
>+++ b/arch/x86/include/asm/kvm_host.h
>@@ -803,6 +803,7 @@ struct kvm_vcpu_arch {
> 
> 	u64 xcr0;
> 	u64 guest_supported_xcr0;
>+	u64 guest_supported_xss;

This structure has the ia32_xss field. how about moving it here for symmetry?

> 
> 	struct kvm_pio_request pio;
> 	void *pio_data;
>diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>index 1f206caec559..4e7a820cba62 100644
>--- a/arch/x86/kvm/cpuid.c
>+++ b/arch/x86/kvm/cpuid.c
>@@ -275,7 +275,8 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
> 	best = cpuid_entry2_find(entries, nent, 0xD, 1);
> 	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
> 		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
>-		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
>+		best->ebx = xstate_required_size(vcpu->arch.xcr0 |
>+						 vcpu->arch.ia32_xss, true);
> 
> 	best = __kvm_find_kvm_cpuid_features(vcpu, entries, nent);
> 	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
>@@ -312,6 +313,17 @@ static u64 vcpu_get_supported_xcr0(struct kvm_vcpu *vcpu)
> 	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
> }
> 
>+static u64 vcpu_get_supported_xss(struct kvm_vcpu *vcpu)
>+{
>+	struct kvm_cpuid_entry2 *best;
>+
>+	best = kvm_find_cpuid_entry_index(vcpu, 0xd, 1);
>+	if (!best)
>+		return 0;
>+
>+	return (best->ecx | ((u64)best->edx << 32)) & kvm_caps.supported_xss;
>+}
>+
> static bool kvm_cpuid_has_hyperv(struct kvm_cpuid_entry2 *entries, int nent)
> {
> 	struct kvm_cpuid_entry2 *entry;
>@@ -358,6 +370,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> 	}
> 
> 	vcpu->arch.guest_supported_xcr0 = vcpu_get_supported_xcr0(vcpu);
>+	vcpu->arch.guest_supported_xss = vcpu_get_supported_xss(vcpu);
> 
> 	/*
> 	 * FP+SSE can always be saved/restored via KVM_{G,S}ET_XSAVE, even if
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index 1258d1d6dd52..9a616d84bd39 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -3795,20 +3795,25 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> 			vcpu->arch.ia32_tsc_adjust_msr += adj;
> 		}
> 		break;
>-	case MSR_IA32_XSS:
>-		if (!msr_info->host_initiated &&
>-		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
>+	case MSR_IA32_XSS: {
>+		bool host_msr_reset = msr_info->host_initiated && data == 0;
>+
>+		if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVES) &&
>+		    (!host_msr_reset || !msr_info->host_initiated))

!msr_info->host_initiated can be dropped here.
