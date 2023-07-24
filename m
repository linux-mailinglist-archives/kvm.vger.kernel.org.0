Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAF0175EECF
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 11:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbjGXJNy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 05:13:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232152AbjGXJNw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 05:13:52 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B3D1A7;
        Mon, 24 Jul 2023 02:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690190031; x=1721726031;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=rkylls1JddwEk9Vz5toU70rBFLKdK4B9xacfNLTrg9w=;
  b=Eubwo99olR1oQ608Ni44oHJlmExkSkDAtnBNtMLNwH5UDBubZCCORPZy
   ldcm04iWwSTwOZjo1aRqZby12m002sarqbbdRqBhHia9HtwI9EaKeiDrD
   Z7Nj4LB5aeIr63p601JbMGfRUkeFprW1t0K3AaE/14Uz+b2yvNisRJt0T
   nluepIgHgXFVb2WwCL5ls0hTQLDiOCCfXGD4LqG6IRnPnu848ghLdA0qA
   voMBogRoBJ5CsEG/vvQvBNGWy2TTSBSDFaCx04RhPN8OOElg9iLEMinc2
   G4yXSfMOUUwibfWzA1Ha9Kmp9NmBJ3itleJXytHuCwB3qVOxHaXEYJPY7
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10780"; a="364852966"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="364852966"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2023 02:13:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10780"; a="1056355141"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="1056355141"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 24 Jul 2023 02:13:50 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 24 Jul 2023 02:13:49 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 24 Jul 2023 02:13:49 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 24 Jul 2023 02:13:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DVGYr96l76Un43jBmm+roj187np0gunl/ekTD7ut8ZA4YuoD27n6EmvkUB9fjHPtJLzUIpv2ilbQ2adP5cLWKV0h0kjeTo6Gl68yBOTA7rewvo7kBB/mEQnsaia05JnvR9DZycvRPJqDtZTn7olNe0FgmbHG/vzl0GLaNwHdeYDVLC8I1Ru1+Wi5ms6rSlntIGkl2bmo9dOzO9RpVA1YLO433z4QusF4rZ3q29kCf27qZWT0qEAL4AC10UprJqnoSzw57AwK0QdyJFC2tVSfx9EHb4NCgvT/f760SQ/WNGpmKtQIjy9+fQ5r45Ad3K3aQ5pwV6gVrrHmjeGGfzZ/Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M10dyoPRMZ56sJeoPF8GQCj8K8cL6zJe6ScijDmrvkg=;
 b=TXKLJB3QkqsOc/ZckOPthe4gZPkDzTgOFuHt4zmRqEM6IhIlAW8YFAsg4XeE1NEZjuDQW45tBQJxe2RYd8sHzhQV7MmwraQljACiBzFSETSy6T//l0fHwyealtB1BwuS1YEcYXWK9+oawqEpCBpdsF+moP3UQ4Rc1FtJ9ecGn7Ns1KuaZkSHUV7BlehdC+V2wRqJ0WBtIjFmZqMoFGAkHl0ycf7HdOydTgrhzywIjgvoIKRg9dmlAvbKOwCl28dt1nmJr/QwZn+ilN8K3+OfjNDswSrsZfdoGUvxwk9df3jvY6JyDtw6RbdxWdq3wcpvMdOsq7eXaCP3/PUmzUAcgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by MW3PR11MB4634.namprd11.prod.outlook.com (2603:10b6:303:54::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Mon, 24 Jul
 2023 09:13:47 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::2803:94a7:314c:3254]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::2803:94a7:314c:3254%7]) with mapi id 15.20.6609.031; Mon, 24 Jul 2023
 09:13:46 +0000
Date:   Mon, 24 Jul 2023 17:13:36 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v4 11/20] KVM:x86: Save and reload GUEST_SSP to/from SMRAM
Message-ID: <ZL5AwOBYN1JV7I4W@chao-email>
References: <20230721030352.72414-1-weijiang.yang@intel.com>
 <20230721030352.72414-12-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230721030352.72414-12-weijiang.yang@intel.com>
X-ClientProxiedBy: SG2P153CA0022.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::9)
 To PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|MW3PR11MB4634:EE_
X-MS-Office365-Filtering-Correlation-Id: 1dc3c05d-25d0-41ca-7c0f-08db8c26488f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q1tUqbQJQ5hhfnrrKmxf5t8qaDZ2aHMeub0ez2BFFFW//sd86fuFHpKS0BzGEiqb7dAYjP2AlCVh8r1b3WEsMFY4T0TGUpcfTWlvD+cIIVagU5Zmy2rB2d+bK7BXJxdPKIzRQhR/BznvuyILecCsonCnAKrMRLRYN5j36alzpDwaObEtNs+W3S5ul1JACZEaF6wTVNHLitj0Tb5U747fKVMnp3SZEhx493yMSLMhZqDiq/1oWDbAaM0mTmH367GyInV/8fW6qYrFuKHRpFBhG19rSsdcAae6MC9/qaShy2Z5YmNOv40tCroBmiGrHoPoZ0cAE2z9Wo6G0sYaTZ6Kto8DnO8BIGQpq7eU18B7mK5BboBw09CWNw7NfsfT1T1/lzCBbK/FXfv3HxIlk2jIy2SvZ4wyuBPUh1ahn+7/BdUAqo7wd0DJuKbhu0BG7Xmc6ehHduZmVNgpu9WZcrh+72vkoGgF+DTavXZ2IoxRSGDC3iXqSyZ6yAeQzhZDUI777dK0WJF89IAwWLIjEj1hrfFvbx5DYEw4iD2Dmzw3ZbTERX/LGQhUuoZdH68+XK1G
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(366004)(346002)(39860400002)(376002)(396003)(136003)(451199021)(2906002)(66946007)(66476007)(66556008)(4326008)(6486002)(6666004)(478600001)(86362001)(6512007)(9686003)(83380400001)(186003)(82960400001)(26005)(6506007)(38100700002)(6636002)(33716001)(44832011)(5660300002)(6862004)(8936002)(8676002)(41300700001)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fCE+3fPZofiOvMRKXva/0sVZze0h5NDBGy7WO/yzY4BEYdNIKRfrb930+X5X?=
 =?us-ascii?Q?a+XrW7apK729dIdtmco6n6G7z2zU7dZPNQu0eGHyU3zRYhgtSehYRoNUv3l9?=
 =?us-ascii?Q?om97KtfJ6aqj3xyD+FhQuBbEZCe/FnHeQVWqhpB8AVsxloa6rg/WRGZGrqJ2?=
 =?us-ascii?Q?P8BWa+JQRfX2hYPHwLvWRHVgxSFo8BzUJugCeLIvnMhAUu1MzAchRYI+V++M?=
 =?us-ascii?Q?4UxVrArVp2kxHpZPRsyCaMJDBrYZZuO2/bQvlB7HwYVLNoSs2OpNuiTcrrVN?=
 =?us-ascii?Q?DalcDg+Z2NlywYrX0f+NQ77D8Z85FQMmfy+/38GGHi8BOYbCJyXkf+sKJF8Z?=
 =?us-ascii?Q?HYMoVbmI+fDMw/lPFsFbK2aNuqJkWpfZEuDp5lYx2fh7uZqBvSDLENkKPSw2?=
 =?us-ascii?Q?UzzB+gtiBI5WY1akH4cQDl1FFhT2vomkl4dnValjeQlXDZkqZQtHyUA5KiSo?=
 =?us-ascii?Q?8ICS0+dqQKiXsLZSSkQp3QjyZClvcE9tLMqSGO4L621ZGjC7/hi/s1yxHNq/?=
 =?us-ascii?Q?K82VxSwjmfCCB2fLNjjdHXjekVRZJBh6ClQij4OXei8IrTLoo/RCaBGr/iY1?=
 =?us-ascii?Q?YCw95Z9eh6FqenkiyRGebm7KoH6vjvwDuoRVhecVJLj05p5JdRrZaL4wmsf/?=
 =?us-ascii?Q?gHckWEKfYTqqnd38Zz+NR0miCREUsDOgP+6KMH7Ik8+5rGW1SwkVaxM7iNM9?=
 =?us-ascii?Q?JDMGvkqmCzwgN1TI6LJuprXKDzz8qAeRBDV2KaQEWT2QnDYDRjROM/FenLB+?=
 =?us-ascii?Q?SX08Cp3R312ZNMroHyXcID63KZJtjD76J4A632GYS3sXaGsAzJkQlWt95Xcm?=
 =?us-ascii?Q?wpVoU4VUYgd46vCWPQcm0czpoDc/XGRh8fqdsLwb///5ombZ2lvWPS0iCtxd?=
 =?us-ascii?Q?OB/XqnjenKtQvL5nfr5Ki7sh5w7zrM9q1BiZU+QDzJFAJ7HKiaGhg87IPVYh?=
 =?us-ascii?Q?zSoNKK+7zkzRRX4olDHUSEqT9neZGGWRV2yTgbLKr77B30CtugWuMVHgKc7F?=
 =?us-ascii?Q?5rtyVYAtj2tGCmR1dxjvmmo0rQ+PvIQ9gX+WhpX4bgKxrKhr+NdPj7Wrqxya?=
 =?us-ascii?Q?kEv+Znu4e4mtUIAgzPeSBSfjh7j+sIbyqY8ohuf1BIhWdUMNIBe7y4s18fyz?=
 =?us-ascii?Q?SuLoljT2ePQOW1FI5axqBc7/j6Tti6Gh/4kjhStSKCA7bQhFGlgoYScAudd0?=
 =?us-ascii?Q?DO2jPsAw2rUY9nm+u4UcE/Yv07J3iwqPQpKlvNkUjWhGSwg0hf3Fniqj5AQa?=
 =?us-ascii?Q?JxXkPijfxFE5Tyd1D2IiRTYgWWSublimCKG/IngeLaMbJAsZCcYUMZfUcA7W?=
 =?us-ascii?Q?dJpaippHWtnOvMmVrouXQoPdxxifHcdDouPPreoDHYpxtBCAW6HqBGe7co86?=
 =?us-ascii?Q?fZ3M3EAIXfSsLwl+bxpAO8DOTCox84AWd7sMmxIYB+XUQGkX5N6/K/X8vhjN?=
 =?us-ascii?Q?CKE6xk7YsA/olLXxyu89JAWGCotUWyMC/+vrjvfexQcBc1DX4BWvk10ZKP+R?=
 =?us-ascii?Q?FWT1bSkOZJtVpio/OZJs+aPBgBAB6keJXdvks1Y49E0CH18Vz8g1qUBZZcGX?=
 =?us-ascii?Q?qwzNTBRQoJZlOa1NS+hKihQz0YZr6lEr4rvOs8fE?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dc3c05d-25d0-41ca-7c0f-08db8c26488f
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2023 09:13:46.0609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dO6rawIZ7rQwQud9CUORIZGPI1Q9ok02dlNwWjsnFXkKK1YKtBF3aAZHr508Y49HzV2DS8YtOZsxHwJbLMoRpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4634
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

On Thu, Jul 20, 2023 at 11:03:43PM -0400, Yang Weijiang wrote:
>Save GUEST_SSP to SMRAM on SMI and reload it on RSM.
>KVM emulates architectural behavior when guest enters/leaves SMM
>mode, i.e., save registers to SMRAM at the entry of SMM and reload
>them at the exit of SMM. Per SDM, GUEST_SSP is defined as one of

To me, GUEST_SSP is confusing here. From QEMU's perspective, it reads/writes
the SSP register. People may confuse it with the GUEST_SSP in nVMCS field.
I prefer to rename it to MSR_KVM_SSP.

>the fields in SMRAM for 64-bit mode, so handle the state accordingly.
>
>Check HF_SMM_MASK to determine whether kvm_cet_is_msr_accessible()
>is called in SMM mode so that kvm_{set,get}_msr() works in SMM mode.
>
>Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>---
> arch/x86/kvm/smm.c | 17 +++++++++++++++++
> arch/x86/kvm/smm.h |  2 +-
> arch/x86/kvm/x86.c | 12 +++++++++++-
> 3 files changed, 29 insertions(+), 2 deletions(-)
>
>diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
>index b42111a24cc2..a4e19d72224f 100644
>--- a/arch/x86/kvm/smm.c
>+++ b/arch/x86/kvm/smm.c
>@@ -309,6 +309,15 @@ void enter_smm(struct kvm_vcpu *vcpu)
> 
> 	kvm_smm_changed(vcpu, true);
> 
>+#ifdef CONFIG_X86_64
>+	if (guest_can_use(vcpu, X86_FEATURE_SHSTK)) {
>+		u64 data;
>+
>+		if (!kvm_get_msr(vcpu, MSR_KVM_GUEST_SSP, &data))
>+			smram.smram64.ssp = data;

I don't think it is correct to continue if kvm fails to read the MSR.

how about:
		if (kvm_get_msr(vcpu, MSR_KVM_GUEST_SSP, &smram.smram64.ssp))
			goto error;
>+	}
>+#endif
>+
> 	if (kvm_vcpu_write_guest(vcpu, vcpu->arch.smbase + 0xfe00, &smram, sizeof(smram)))
> 		goto error;
> 
>@@ -586,6 +595,14 @@ int emulator_leave_smm(struct x86_emulate_ctxt *ctxt)
> 	if ((vcpu->arch.hflags & HF_SMM_INSIDE_NMI_MASK) == 0)
> 		static_call(kvm_x86_set_nmi_mask)(vcpu, false);
> 
>+#ifdef CONFIG_X86_64
>+	if (guest_can_use(vcpu, X86_FEATURE_SHSTK)) {
>+		u64 data = smram.smram64.ssp;
>+

>+		if (is_noncanonical_address(data, vcpu) && IS_ALIGNED(data, 4))

shouldn't the checks be already done inside kvm_set_msr()?

>+			kvm_set_msr(vcpu, MSR_KVM_GUEST_SSP, data);

please handle the failure case. Probably just return X86EMUL_UNHANDLEABLE like other
failure paths in this function.

>+	}
>+#endif
> 	kvm_smm_changed(vcpu, false);
> 
> 	/*
>diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
>index a1cf2ac5bd78..b3efef7cb1dc 100644
>--- a/arch/x86/kvm/smm.h
>+++ b/arch/x86/kvm/smm.h
>@@ -116,7 +116,7 @@ struct kvm_smram_state_64 {
> 	u32 smbase;
> 	u32 reserved4[5];
> 
>-	/* ssp and svm_* fields below are not implemented by KVM */
>+	/* svm_* fields below are not implemented by KVM */

move this comment one line downward

> 	u64 ssp;
> 	u64 svm_guest_pat;
> 	u64 svm_host_efer;
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index f7558f0f6fc0..70d7c80889d6 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -3653,8 +3653,18 @@ static bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu,
> 		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK))
> 			return false;
> 
>-		if (msr->index == MSR_KVM_GUEST_SSP)
>+		/*
>+		 * This MSR is synthesized mainly for userspace access during
>+		 * Live Migration, it also can be accessed in SMM mode by VMM.
>+		 * Guest is not allowed to access this MSR.
>+		 */
>+		if (msr->index == MSR_KVM_GUEST_SSP) {
>+			if (IS_ENABLED(CONFIG_X86_64) &&
>+			    !!(vcpu->arch.hflags & HF_SMM_MASK))

use is_smm() instead.

>+				return true;
>+
> 			return msr->host_initiated;
>+		}
> 
> 		return msr->host_initiated ||
> 			guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
>-- 
>2.27.0
>
