Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A05E275ED84
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 10:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbjGXI1l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 04:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbjGXI1e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 04:27:34 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35508E46;
        Mon, 24 Jul 2023 01:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690187240; x=1721723240;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=5qZ9nZmo4CkM9SPVo/JI6kxqmQd1k6n0+M8WOtBfvQ0=;
  b=jn6SulXYJodfMYcrkyDB3p4VEI8jY6vAYYteugCN/jvdGpIlUEYkV809
   3f0MkAbJwH4ZK+ilLIjT5B3xyHitwI17gC6EQyvaoPj6kM+yFlXK+VJb7
   PRv5LLEDnHvD640EfAcL97iFOjU1tm6oDJVYs20my1QE14Jcb7y9LWA+6
   IREq98PAFhdVP3vDXGCasf6PbUBdd5ve3K/eeZp1ERWMsjBWfY5x8oLYg
   FuipqY0RQa/PylUbAWo8lgA/PKW8joKBvzcOkkAuW9Nr3Z4Jti0lghgsK
   o7RQcnL+sJ1Ht//LitBTRa87cTHbkE5Zjd7q6Cwnt3divWENa0dRJQzCT
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10780"; a="453759073"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="453759073"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2023 01:27:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10780"; a="719581987"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="719581987"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 24 Jul 2023 01:27:19 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 24 Jul 2023 01:27:19 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 24 Jul 2023 01:27:19 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 24 Jul 2023 01:27:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XFarcYLGxJOpjn5l9IXEcBYwzJ51RNUOd6V8bcYmnUyOrSkYsmy76OEuwWTMpCjb/suosH+vi+g3D9ubxkjKXK6Zuz8AqpH8gSqs1cAumETHqJHA6hB4on5PxfSLsAB+EeUAcybdhxwH/ERbbMUobj8FmqFE+iCjYNEQ5eioEiF1HCpoAPVd8U18YWHUvJOhR7HWVz7rHYaFWbLEkuR2TWPtjSKCL1ttcHqEaR80fZLdOSicrySKX1741UgVuVWH4snKEoYjbdchAYnRCd42lKbUIx+sVPt/uPOlAZV5AfgbtwtzIqQrtSmT1nmRhZfwtQduL8tryVBIwuWWBsQHvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EEEoToREZUH4RqKa32jZmib4eci9ikYMt/i6+tDFyrA=;
 b=OIjIiA7psDcGiYYtrhGnEsdeh7gB6Mg6oEU2jNrN9BkjJtkajMB3ttFq3FsjGQRuhFvRpUGJkJcIKN5De/rPa2PpjzUJfvwTEM1RyvuaS2dHl3DrNkIsQh32P1J+aIrFPK/UhyTKFfiOLwP+gvrtF0LR47PPfdcVpVW5ePr7W2n1bTtjrMB8IGXiPYTbuotPtUtuTngX96RM2gbdZlmlrzYpaIgVckE5YCyb/bwtDvcEeCi83TFnIaeemb1gpACea1OPT2J5xK7EhpLJ9afGrJCc3HFWwU/d5OG7U+9Y106YHrivRQlwIndnQrCG8sNPyoNPGO3F1ouMg40MX2wK8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by IA0PR11MB7379.namprd11.prod.outlook.com (2603:10b6:208:431::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.31; Mon, 24 Jul
 2023 08:27:10 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::2803:94a7:314c:3254]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::2803:94a7:314c:3254%7]) with mapi id 15.20.6609.031; Mon, 24 Jul 2023
 08:27:10 +0000
Date:   Mon, 24 Jul 2023 16:26:59 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v4 10/20] KVM:x86: Make guest supervisor states as
 non-XSAVE managed
Message-ID: <ZL410xRbInlQMc5y@chao-email>
References: <20230721030352.72414-1-weijiang.yang@intel.com>
 <20230721030352.72414-11-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230721030352.72414-11-weijiang.yang@intel.com>
X-ClientProxiedBy: SI2PR01CA0036.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::22) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|IA0PR11MB7379:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f954858-dd9a-4f97-f0cd-08db8c1fc614
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cWklWIwyGACMC9c/RykzohCzjeA3hME9Hhizyp9DWdRzxmtkog2QMLvpIOQHmQxFrhVJJnCZ4GmQcwT58P6Af82v4XzmO+++8pswBCS7NtbdWnKQYeH/jy5687MrJMlVmzTUttVaAWZmqmxpwAuq2I+U0OkTy1Z4Thr63gGdtXDGdj/oSwwyMqXohuTuYqK0v6JKBhftQNT4ZLohu/fZN1PJIl86ybSZCRe9ZooDGmcu5N4T+CMXvGNomjXsebiJtuaBRoMBd54dfwagGyC6mwqm/dhUCnB1tJlgDah0VNcS0cjyu8TSvOy2/knEnqTkw870PNCIkO+UFey34QWWNGRUJ5p81BiX085EOphNl1MN6CPNnC4Hgpl5O5auUKv3gq+eWXrzo0Ku2d7lJNW456IFuzvYqH1uYLMBgy43Qu+3vRVwRnQiUyMtv3+bz1sRA4bUkFKal9LM8u2Cg97PZIAW85Xmx8xL34lzZcElbqkFOmkru2E2Dyjb5+m76mEAdbtKhYaMAIzxd8siiEAr/BcViPaAp5W0xfqM5nSzUOMOHsyR6EY2wAqVGMusaLiA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(366004)(136003)(39860400002)(376002)(346002)(396003)(451199021)(33716001)(86362001)(82960400001)(38100700002)(66556008)(4326008)(66476007)(6636002)(66946007)(478600001)(6862004)(41300700001)(316002)(8936002)(5660300002)(44832011)(8676002)(6486002)(6512007)(9686003)(6666004)(2906002)(186003)(6506007)(26005)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d+34aD8b6fPYKNxQ5M/dc38bcwYzsPT44n7/8CU3nyT3pAHo30uj7Woe8lA3?=
 =?us-ascii?Q?g2hsoDbWN/994LZ1G7+eUObuxYWagFYIcBtTfUpYq017VVuPAKsLnreuMdyx?=
 =?us-ascii?Q?+vw3naYOyP5ipp6oC9D/IWsQocrwgXllR30adrLczw0hHv9xy1Ih3NqsxWBr?=
 =?us-ascii?Q?+LKKtQmduqiq+TfYrxoBuJvhTs/UJqIy0OQxxN557gP9+1V/V2QHCJ4E3JlT?=
 =?us-ascii?Q?O4Q8rS/LktBLp6QJuq91wGh/bJBpEvY6Fnf40lOfmGgbZIccEZt2I5RoBJ5A?=
 =?us-ascii?Q?aOlmDFJ84cLWJI1kHkrMH1eUK2pbCtLUnL6ECC3iKyXSGg8j7EYPkwj8WNpt?=
 =?us-ascii?Q?fPkPewLKS/DL9pipXK8k9iK7mjCpZ8RUnPLDhHP8b7Lzk909FkzptxQcBKwe?=
 =?us-ascii?Q?rSxxYzUNXaREyvkIi7NqxqG7htrwPTd/mDa0Fg+KizI92VwUjVGC3Q4hThB7?=
 =?us-ascii?Q?j8yuSd/dSRjMF/324LLCG9kRD0fFYmVGdLWE2pIADsRNvAm+v1TY11199a7C?=
 =?us-ascii?Q?xG1/i4ZiCyLTW+g73486z2wKZgeiddf+zA70Zyuq8f8PWuQ8QXy+WZWlW6Da?=
 =?us-ascii?Q?TZEv6cGm8XdNIwd/OX7v+8vKyql83+azXipHG6DjOMRkpDDcC1vnneYUl5xf?=
 =?us-ascii?Q?LSgpIpBf6yN4hs/zKn7qdUo1/xcH2ZGB+NdOK0QyT60qioVSRx+m396gyOIE?=
 =?us-ascii?Q?SqsAhHIz8KcVhISsVrhXyFTOGO35VrmfHKTV/vOjFVXU/HmLYyi0NcgPj3k+?=
 =?us-ascii?Q?LmbblBAPE3GoYFUmYPMGaUYT2JFiZF2GRaaz8Yo6nKIHyv/WMGHA2urKvUD4?=
 =?us-ascii?Q?LP+z3wbCB3wZHol/YNYoi88qEby02D5tnHnXWfkUF2Zy5sjFXWRhbmjScXcU?=
 =?us-ascii?Q?M5gfs9F3tiu2TL4b11n2K5dxoprIjFeg12/VTqvKklpo24b3xjqjEK2IaC7V?=
 =?us-ascii?Q?GV6o6eRGOveLxxiL4EGRtAfazOTfuQ9Kiorldyb5e86xznccSrZ2wj2PdedN?=
 =?us-ascii?Q?NEWr3VDYDpWb5Ndu1lu8bW+LrMZic4SC4c92gx8940wxPQYkdMK5VXight9+?=
 =?us-ascii?Q?e7NYbRjh5xzcfESK0iTPUF+s1i8wagYwofzK9F02ReW8YmrQh7/xOvjnSs3E?=
 =?us-ascii?Q?QAUHzbrSok69tBMbavO80yx34UYCipJ+cJnclba1s8sMD/hzkoP9TX1ZAPnd?=
 =?us-ascii?Q?oxLB0mfBeFxtmDoMw3LpJ1WdTMCfbGE7NrnOHNCFoEt+8b2eLmtpZL31+/xG?=
 =?us-ascii?Q?BKIukVJ6C0ta7CRzoRf+qN12E6FbH1Mm5d44OKSWq9PlUzLFm6/z+1ScuJLz?=
 =?us-ascii?Q?XsHzQ1QCsOPOpmOHUa9hF8xDLq44/2iauTJojqZih9ahAseQhZu9DVI19k/w?=
 =?us-ascii?Q?vI2H4DH3yMrw8uDI4z+0cDmJhwwZ3vQZvSL4YGYeDqtj07w/Jm22NF6U+eAo?=
 =?us-ascii?Q?KkCkFoeOI487kHvy/qFxgy9k8qaPd+sFDhC4H8VjEYOkvEXUMeS5WdXpQMWi?=
 =?us-ascii?Q?R2ZypjbTm0WQiD6RLK8pc+RZXiEOrnjsm+g6x+cRBPsTv99lXD18tq4wPybd?=
 =?us-ascii?Q?QPJmOya2JjP5UQG/Qfe/myap0QbXJ0cENelvMcLx?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f954858-dd9a-4f97-f0cd-08db8c1fc614
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2023 08:27:10.0969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yLCKnZfEMJULRktgKWj66RbcIhq2u59IxqxIpUptMpu8ITVcUGoh/vbFeKFzGyD2VQrY1bqm3iL5i0p67W0i3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7379
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 20, 2023 at 11:03:42PM -0400, Yang Weijiang wrote:
>+static void kvm_save_cet_supervisor_ssp(struct kvm_vcpu *vcpu)
>+{
>+	preempt_disable();

what's the purpose of disabling preemption?

>+	if (unlikely(guest_can_use(vcpu, X86_FEATURE_SHSTK))) {
>+		rdmsrl(MSR_IA32_PL0_SSP, vcpu->arch.cet_s_ssp[0]);
>+		rdmsrl(MSR_IA32_PL1_SSP, vcpu->arch.cet_s_ssp[1]);
>+		rdmsrl(MSR_IA32_PL2_SSP, vcpu->arch.cet_s_ssp[2]);
>+		/*
>+		 * Omit reset to host PL{1,2}_SSP because Linux will never use
>+		 * these MSRs.
>+		 */
>+		wrmsrl(MSR_IA32_PL0_SSP, 0);

You don't need to reset the MSR because current host doesn't enable SSS
and leaving guest value in the MSR won't affect host behavior.

>+	}
>+	preempt_enable();
>+}
>+
>+static void kvm_reload_cet_supervisor_ssp(struct kvm_vcpu *vcpu)
>+{
>+	preempt_disable();
>+	if (unlikely(guest_can_use(vcpu, X86_FEATURE_SHSTK))) {
>+		wrmsrl(MSR_IA32_PL0_SSP, vcpu->arch.cet_s_ssp[0]);
>+		wrmsrl(MSR_IA32_PL1_SSP, vcpu->arch.cet_s_ssp[1]);
>+		wrmsrl(MSR_IA32_PL2_SSP, vcpu->arch.cet_s_ssp[2]);
>+	}
>+	preempt_enable();
>+}

save/load PLx_SSP in kvm_sched_in/out() and in VCPU_RUN ioctl is sub-optimal.

How about:
1. expose kvm_save/reload_cet_supervisor_ssp()
2. reload guest PLx_SSP in {vmx,svm}_prepare_switch_to_guest()
3. save guest PLx_SSP in vmx_prepare_switch_to_host() and
   svm_prepare_host_switch()?

this way existing svm/vmx->guest_state_loaded can help to reduce a lot of
unnecessary PLx_SSP MSR accesses.

>+
> int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> {
> 	struct kvm_queued_exception *ex = &vcpu->arch.exception;
>@@ -11222,6 +11249,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> 	kvm_sigset_activate(vcpu);
> 	kvm_run->flags = 0;
> 	kvm_load_guest_fpu(vcpu);
>+	kvm_reload_cet_supervisor_ssp(vcpu);
> 
> 	kvm_vcpu_srcu_read_lock(vcpu);
> 	if (unlikely(vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)) {
>@@ -11310,6 +11338,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> 	r = vcpu_run(vcpu);
> 
> out:
>+	kvm_save_cet_supervisor_ssp(vcpu);
> 	kvm_put_guest_fpu(vcpu);
> 	if (kvm_run->kvm_valid_regs)
> 		store_regs(vcpu);
>@@ -12398,9 +12427,17 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
> 		pmu->need_cleanup = true;
> 		kvm_make_request(KVM_REQ_PMU, vcpu);
> 	}
>+
>+	kvm_reload_cet_supervisor_ssp(vcpu);
>+
> 	static_call(kvm_x86_sched_in)(vcpu, cpu);
> }
> 
>+void kvm_arch_sched_out(struct kvm_vcpu *vcpu, int cpu)
>+{

@cpu its meaning isn't clear and isn't used and ...

>+	kvm_save_cet_supervisor_ssp(vcpu);
>+}
>+
> void kvm_arch_free_vm(struct kvm *kvm)
> {
> 	kfree(to_kvm_hv(kvm)->hv_pa_pg);
>diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>index d90331f16db1..b3032a5f0641 100644
>--- a/include/linux/kvm_host.h
>+++ b/include/linux/kvm_host.h
>@@ -1423,6 +1423,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
> int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu);
> 
> void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu);
>+void kvm_arch_sched_out(struct kvm_vcpu *vcpu, int cpu);
> 
> void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
> void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu);
>diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>index 66c1447d3c7f..42f28e8905e1 100644
>--- a/virt/kvm/kvm_main.c
>+++ b/virt/kvm/kvm_main.c
>@@ -5885,6 +5885,7 @@ static void kvm_sched_out(struct preempt_notifier *pn,
> {
> 	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
> 
>+	kvm_arch_sched_out(vcpu, 0);

passing 0 always looks problematic.

> 	if (current->on_rq) {
> 		WRITE_ONCE(vcpu->preempted, true);
> 		WRITE_ONCE(vcpu->ready, true);
>-- 
>2.27.0
>
