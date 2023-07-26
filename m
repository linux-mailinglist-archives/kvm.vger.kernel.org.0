Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79D85763015
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 10:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbjGZIll (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 04:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233153AbjGZIlT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 04:41:19 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4509C7A8B;
        Wed, 26 Jul 2023 01:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690360272; x=1721896272;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=nSeIxW6cqcUSPfNiQb6PFpyEIWXFAsYR9pP5lJOxjXk=;
  b=IcbNWr07+sJIP5qXvm3jLYeHWNQ4/E2ACeg9iuGFq+VaayFYgsFJ5cLU
   tbPkSbBzVctGTiKgcq5y7RIfebsuI3RxqVE/8BHSSUj61GLcqzgsjnyj7
   pccZdN8zT9s5tfza7Yycv7U6nv3reWoou87VQmdWMCnWzkYb7iQGqByVl
   wZaJ8JRunCt8MCso4jaazI1rtTMs6bZmzPtvJ7Sggy0Nueyo3DrI+uG4C
   yqfbpWno23E40Lzdm5AfH1SMgCs/vrJv2o7md8B8Ic0SojVbYL7JAGb8p
   Sogk7WlmZr4Q9XP0i/PZjyg+e+Yc1tY3vh3uc1VtvJOEa73zilsKu0juB
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="434214853"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="434214853"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2023 01:31:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="729761852"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="729761852"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 26 Jul 2023 01:31:08 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 26 Jul 2023 01:31:08 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 26 Jul 2023 01:31:08 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 26 Jul 2023 01:31:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nRRQlxXvjbuYzfBiAl0aJ3lAvJFDsO04np7+7M6aajzZeCayIcPad2g6UNphuiwx8ddUp2m5gk+qFoPeQEtVDbXHLs8uskWGoQebQmtMNpaxbkiFzf3deygMksilv8GibY2XOEnti4zLVW3VnkAW2h/+oNF5Fo/ksI57U24tPOUAa93YcTrcZgZ2byiswAKltP5ZYhUqT9uEvV2Hxqbu1SCuCuGPnkwBFoR30zyMB+QjNJiOFh0eKEZnqxHiK8MBhS7Oe87tdcGvY1FJN4kE5Y6cxDNuRrC2Qc0+PsCmxKP0VOdHiKSEsPUCXU7Cs/Xn+1o0Ycd/QPIgQxCdiNB1IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nF4gm9d6ETz/0UDIctOg/25XqdgtfVpD09hsPJ6DYAs=;
 b=BJOnFnkFPjCa1oSOact+XZSa+QmUKsS4r7Q/HbEppDICbEEpXaSugxlScwpgzuO+JeiD8VA5PZJABqVUt1CVKjIvrrzfUobl3TiLuAzv9gocxsYpRUbspo9hhNDQwUgoYWjg/NVjxvkRJbD7YuF7YG9GUWOCG1VZ2StUY9YHquMhy7En9+TTbDxrc7PPNLtDUtMUgqSGFtABG0BNtCN0BXJLe9xGeDtNvKolgWYNLx1rb81CWIg5SjRMHYGaLHFw+kmKrmKitDySfmXAMS2wmON1ErYIGpBze3L6e8R0addCkCvlYwUQ4D9Hc9ylFPOHDw8NaV3FhZsm4cWri2YP1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by MW5PR11MB5908.namprd11.prod.outlook.com (2603:10b6:303:194::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Wed, 26 Jul
 2023 08:31:05 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::2803:94a7:314c:3254]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::2803:94a7:314c:3254%7]) with mapi id 15.20.6609.032; Wed, 26 Jul 2023
 08:31:05 +0000
Date:   Wed, 26 Jul 2023 16:30:53 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v4 14/20] KVM:VMX: Set up interception for CET MSRs
Message-ID: <ZMDZvfJu1yhBigXz@chao-email>
References: <20230721030352.72414-1-weijiang.yang@intel.com>
 <20230721030352.72414-15-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230721030352.72414-15-weijiang.yang@intel.com>
X-ClientProxiedBy: KL1PR02CA0033.apcprd02.prod.outlook.com
 (2603:1096:820:d::20) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|MW5PR11MB5908:EE_
X-MS-Office365-Filtering-Correlation-Id: eff9207d-682c-4ca7-9196-08db8db2a70f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rqu8rAviSsyQgtokfZjCi9mQz2GMfRzIr7rq9OSmXn8nxMeFPmumu+vjhvgOTJP99GCoH/yEwIKKUbASF5Kd+FciHfWLZSBwYWsHhiaQeFIaoCur9cgsuhe3wH4so43owDYNUm8PYT7lWCQU9SLdXIlLKWVQFqHvzmYKHotcFsiJgvlU/v01mnyFwnCONQVbuzEPhPQxmKpPLZIJl/Kd2zo9NBQfJKgjv87mmSfpSUKlz1eVIRCOaIzZesd6+3m6HOTpwjpMOMjB35/aasGxAdnj3+kysjaeujjaVIS2iz3mupjXIB8A5teTC1lMv9VKTdnvM9kjw09mRTgrHvqxMOvPBq/8Pg3ECJ+XxKrzAs2/ic/YVCgsAah9cj3oDjpJNWFc3Er4X3soqawMB0M8i0B/9KyxrSUr9pzU2jaxx1SaV7Kyg3Gde2EF4WJfgMnqSas9Ow/DJ25WEf2NboxF0NsIcsH2DSHgKaHY1QbE0HbVnISzgMxkXbhbT9a9XLfgeXvTDLPOUVgJKbJNX9SoVoUTVTWDdXoxXnkQNJ/iDvQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199021)(6862004)(26005)(33716001)(2906002)(6506007)(186003)(6636002)(38100700002)(83380400001)(66556008)(5660300002)(41300700001)(66946007)(44832011)(66476007)(316002)(8676002)(8936002)(86362001)(82960400001)(966005)(6666004)(478600001)(9686003)(6512007)(6486002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CBPz5KLoORCyXyIjekqHZg494sOy5I2yU3GgfPA0ktlIiBGNE99xtjyZvbuY?=
 =?us-ascii?Q?GeJXKWZWbGD2bYwKKiqQLqSNRaPmE94gdUrpCKSc40Hr4os94RQ1hYV8zJC3?=
 =?us-ascii?Q?AcofOQZPHQkvSUxUvBkN4L9LPyYHfF/yeoTMT2p7b2YeFHjYzeh8LsyfdLPw?=
 =?us-ascii?Q?E7roNI3uw1xdjkRKfPKa/NWjCLjLnzxDFX2jG32i4D+Zm/A2PD39WBdtMVz0?=
 =?us-ascii?Q?Fw7a5bwyOHGp83/gW8rS11sf2l9bOnVAmSvMeth720weSdqTDe/5nrsCzd6D?=
 =?us-ascii?Q?n94TAgBqT4Da80Q25mtqfS4I45rXtiBQPRsPV2xFaT4vPHNRBmQhPdKWRCV5?=
 =?us-ascii?Q?8kw0PH0htAfX4T7ZWl1Q5mGbmQAZfDDnItCLOMEMq7thFRpwiowQJW45pj2P?=
 =?us-ascii?Q?22EjBAlyXQcOcUh8fnTU3qF1aOfImep2t2SdanONwZtqDXodvJ13/IOO9IvU?=
 =?us-ascii?Q?wbgQ1O4tR7pGN54DMQTPxiL+ceg0fLxWNQNDdZlqVkVly1iCf5BIVuOwmy4a?=
 =?us-ascii?Q?AfskdjC6o+8/zThYHnKgbkwZ995XaLs/FAO0/5M+9mjaozttsxUXkiQOWQL3?=
 =?us-ascii?Q?QfTE8Tct0O74jsspHrGFzZ+x0HTTpucm9MzO2wQQiuXM6t6Vc/L16hXco13Y?=
 =?us-ascii?Q?aNc1f6QPAAaTOtBoe07zkdAZEOR/aXUvR7+Z0Z4YeZFaZb0o6XxvytlYjNIq?=
 =?us-ascii?Q?2VezKUA1WS9cS7HIQrynewJNxSpvGSNtS2xurEHMDsZEbXOd27UX5PsCIBiR?=
 =?us-ascii?Q?A2j0FggP2pfOQCMH7QzWgkXwbT3g25IQaTDu9Phs3IBaiteP3Tl181vZMX+4?=
 =?us-ascii?Q?4ryDcul6DiWmkQgGpfJWsAedjcP9IBqApOQsKAOuH1zVRgQvx2HdEdifCmQX?=
 =?us-ascii?Q?+l+R7HzsnSSMUja7V7Jx+RLSvJ3IRXzray2wxQwy7VpbSCtSB4ouo7BJT/yU?=
 =?us-ascii?Q?w+n2CyPpFRaDq4LZJ5+WP36mOy7/BmKHl64n+W66xALHnZGUE6clVUSxhPVD?=
 =?us-ascii?Q?KGJz9dsmPmmBKowJNt8UzX7YSWydUA1+VhvwxY4z1Q1JqMHSXS0dfkqZrJI2?=
 =?us-ascii?Q?y1zk0qGFlXW/lwY2AYUd4N12waFVyEzFshtCZqQakKowpDGjT/Hnugon5Hgo?=
 =?us-ascii?Q?DQwXHQRQmhEubb0XDipDOKgOCHy+SDC8ASaQRTGhlj/CqTQ7ETA3i1yS3sXM?=
 =?us-ascii?Q?8D97/tVC2sVMhymZfKZqCmdKFXeCR9QblXS6Rpk7NzKocHZgLVzMX0P9r+TZ?=
 =?us-ascii?Q?mGiLb0wx5ikuzPRFsW3Hag4jnoVnZbYXR4JcvdVK5yWZLjIEqf/9NDH2biBC?=
 =?us-ascii?Q?2kfz8afo+lB4mr5XXZqJWjAi6ZGRuS8SX2f+lcXhu7bjBU2eXal2gB+8TfqK?=
 =?us-ascii?Q?WU7TNtJaL8V77ihZBNq1jbbAAMLW4X7C2VLW1r6DfTfMQZcILjim58Nm4tJz?=
 =?us-ascii?Q?MA+NMH4Bwj8OW4tKbrNRHCD9Qe3e1n6msulNZ+ihRirw0Y73SUuZ6iUcYgft?=
 =?us-ascii?Q?lYaG3qLVDEVMoGftPPxef5xlp/HhBGcfM/ePi4mKiQDO0o7eq80ogO5TN1Xd?=
 =?us-ascii?Q?sKzK577SoynkWAjNm+J3QTn+uxdNjZ0UJbDfBmX+?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eff9207d-682c-4ca7-9196-08db8db2a70f
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2023 08:31:05.2595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P2lvqMIKEyY894GtzMNzJLPzGar9v6mGzJbmdZhj3/UPxbCk10KF2usX2HroZ6STffcXPksaYuKZK2MSejKxTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5908
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 20, 2023 at 11:03:46PM -0400, Yang Weijiang wrote:
>Pass through CET MSRs when the associated feature is enabled.
>Shadow Stack feature requires all the CET MSRs to make it
>architectural support in guest. IBT feature only depends on
>MSR_IA32_U_CET and MSR_IA32_S_CET to enable both user and
>supervisor IBT.

If a guest supports SHSTK only, KVM has no way to prevent guest from
enabling IBT because the U/S_CET are pass-thru'd. it is a problem.

I am wondering if it is necessary to pass-thru U/S_CET MSRs. Probably
the answer is yes at least for U_CET MSR because the MSR is per-task.

>
>Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>---
> arch/x86/kvm/vmx/vmx.c | 35 +++++++++++++++++++++++++++++++++++
> 1 file changed, 35 insertions(+)
>
>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index b29817ec6f2e..85cb7e748a89 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -709,6 +709,10 @@ static bool is_valid_passthrough_msr(u32 msr)
> 	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
> 		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
> 		return true;
>+	case MSR_IA32_U_CET:
>+	case MSR_IA32_S_CET:
>+	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
>+		return true;
> 	}
> 
> 	r = possible_passthrough_msr_slot(msr) != -ENOENT;
>@@ -7758,6 +7762,34 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
> 		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
> }
> 
>+static void vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
>+{
>+	if (guest_can_use(vcpu, X86_FEATURE_SHSTK)) {
>+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET,
>+					  MSR_TYPE_RW, false);
>+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET,
>+					  MSR_TYPE_RW, false);
>+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP,
>+					  MSR_TYPE_RW, false);
>+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP,
>+					  MSR_TYPE_RW, false);
>+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP,
>+					  MSR_TYPE_RW, false);
>+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP,
>+					  MSR_TYPE_RW, false);
>+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB,
>+					  MSR_TYPE_RW, false);
>+		return;
>+	}
>+
>+	if (guest_can_use(vcpu, X86_FEATURE_IBT)) {
>+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET,
>+					  MSR_TYPE_RW, false);
>+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET,
>+					  MSR_TYPE_RW, false);
>+	}

This is incorrect. see

https://lore.kernel.org/all/ZJYzPn7ipYfO0fLZ@google.com/

>+}
>+
> static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> {
> 	struct vcpu_vmx *vmx = to_vmx(vcpu);
>@@ -7825,6 +7857,9 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> 
> 	/* Refresh #PF interception to account for MAXPHYADDR changes. */
> 	vmx_update_exception_bitmap(vcpu);
>+
>+	if (kvm_is_cet_supported())

Nit: this check is not necessary. here isn't a hot path. and if
kvm_is_cet_supported() is false, guest_can_use(., X86_FEATURE_SHSTK/IBT)
should be false.

>+		vmx_update_intercept_for_cet_msr(vcpu);
> }
> 
> static u64 vmx_get_perf_capabilities(void)
>-- 
>2.27.0
>
