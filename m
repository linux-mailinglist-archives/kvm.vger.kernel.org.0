Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D34BC2D444F
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 15:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732990AbgLIO1q convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 9 Dec 2020 09:27:46 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:2523 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732405AbgLIO1p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Dec 2020 09:27:45 -0500
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4CrfVx558zzQp1g;
        Wed,  9 Dec 2020 22:26:33 +0800 (CST)
Received: from dggema766-chm.china.huawei.com (10.1.198.208) by
 DGGEMM406-HUB.china.huawei.com (10.3.20.214) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Wed, 9 Dec 2020 22:27:01 +0800
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 dggema766-chm.china.huawei.com (10.1.198.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Wed, 9 Dec 2020 22:27:01 +0800
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2106.002; Wed, 9 Dec 2020 14:26:59 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Eric Auger <eric.auger@redhat.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "will@kernel.org" <will@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
        "zhangfei.gao@gmail.com" <zhangfei.gao@gmail.com>,
        "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
        "tn@semihalf.com" <tn@semihalf.com>,
        "nicoleotsuka@gmail.com" <nicoleotsuka@gmail.com>,
        yuzenghui <yuzenghui@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        qubingbing <qubingbing@hisilicon.com>
Subject: RE: [PATCH v13 05/15] iommu/smmuv3: Get prepared for nested stage
 support
Thread-Topic: [PATCH v13 05/15] iommu/smmuv3: Get prepared for nested stage
 support
Thread-Index: AQHWvZ3YzXx0Iv4/TkmqLZQuADrJXqnu73jQ
Date:   Wed, 9 Dec 2020 14:26:59 +0000
Message-ID: <d31ca662eb124fd3ba0c88936dcc098f@huawei.com>
References: <20201118112151.25412-1-eric.auger@redhat.com>
 <20201118112151.25412-6-eric.auger@redhat.com>
In-Reply-To: <20201118112151.25412-6-eric.auger@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.1.56]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

> -----Original Message-----
> From: Eric Auger [mailto:eric.auger@redhat.com]
> Sent: 18 November 2020 11:22
> To: eric.auger.pro@gmail.com; eric.auger@redhat.com;
> iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org;
> kvm@vger.kernel.org; kvmarm@lists.cs.columbia.edu; will@kernel.org;
> joro@8bytes.org; maz@kernel.org; robin.murphy@arm.com;
> alex.williamson@redhat.com
> Cc: jean-philippe@linaro.org; zhangfei.gao@linaro.org;
> zhangfei.gao@gmail.com; vivek.gautam@arm.com; Shameerali Kolothum
> Thodi <shameerali.kolothum.thodi@huawei.com>;
> jacob.jun.pan@linux.intel.com; yi.l.liu@intel.com; tn@semihalf.com;
> nicoleotsuka@gmail.com; yuzenghui <yuzenghui@huawei.com>
> Subject: [PATCH v13 05/15] iommu/smmuv3: Get prepared for nested stage
> support
> 
> When nested stage translation is setup, both s1_cfg and
> s2_cfg are set.
> 
> We introduce a new smmu domain abort field that will be set
> upon guest stage1 configuration passing.
> 
> arm_smmu_write_strtab_ent() is modified to write both stage
> fields in the STE and deal with the abort field.
> 
> In nested mode, only stage 2 is "finalized" as the host does
> not own/configure the stage 1 context descriptor; guest does.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> v10 -> v11:
> - Fix an issue reported by Shameer when switching from with vSMMU
>   to without vSMMU. Despite the spec does not seem to mention it
>   seems to be needed to reset the 2 high 64b when switching from
>   S1+S2 cfg to S1 only. Especially dst[3] needs to be reset (S2TTB).
>   On some implementations, if the S2TTB is not reset, this causes
>   a C_BAD_STE error
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 64
> +++++++++++++++++----
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  2 +
>  2 files changed, 56 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 18ac5af1b284..412ea1bafa50 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1181,8 +1181,10 @@ static void arm_smmu_write_strtab_ent(struct
> arm_smmu_master *master, u32 sid,
>  	 * three cases at the moment:
>  	 *
>  	 * 1. Invalid (all zero) -> bypass/fault (init)
> -	 * 2. Bypass/fault -> translation/bypass (attach)
> -	 * 3. Translation/bypass -> bypass/fault (detach)
> +	 * 2. Bypass/fault -> single stage translation/bypass (attach)
> +	 * 3. Single or nested stage Translation/bypass -> bypass/fault (detach)
> +	 * 4. S2 -> S1 + S2 (attach_pasid_table)
> +	 * 5. S1 + S2 -> S2 (detach_pasid_table)
>  	 *
>  	 * Given that we can't update the STE atomically and the SMMU
>  	 * doesn't read the thing in a defined order, that leaves us
> @@ -1193,7 +1195,8 @@ static void arm_smmu_write_strtab_ent(struct
> arm_smmu_master *master, u32 sid,
>  	 * 3. Update Config, sync
>  	 */
>  	u64 val = le64_to_cpu(dst[0]);
> -	bool ste_live = false;
> +	bool s1_live = false, s2_live = false, ste_live;
> +	bool abort, nested = false, translate = false;
>  	struct arm_smmu_device *smmu = NULL;
>  	struct arm_smmu_s1_cfg *s1_cfg;
>  	struct arm_smmu_s2_cfg *s2_cfg;
> @@ -1233,6 +1236,8 @@ static void arm_smmu_write_strtab_ent(struct
> arm_smmu_master *master, u32 sid,
>  		default:
>  			break;
>  		}
> +		nested = s1_cfg->set && s2_cfg->set;

This is a problem when the Guest is booted with iommu.passthrough = 1 as we
set s1_cfg.set = false for IOMMU_PASID_CONFIG_BYPASS. 

Results in BUG_ON(ste_live && !nested).

Can we instead have nested = true set a bit above in the code, where we set
s2_cfg->set = true for the ARM_SMMU_DOMAIN_NESTED case?

Please take a look.

Thanks,
Shameer

> +		translate = s1_cfg->set || s2_cfg->set;
>  	}
> 
>  	if (val & STRTAB_STE_0_V) {
> @@ -1240,23 +1245,36 @@ static void arm_smmu_write_strtab_ent(struct
> arm_smmu_master *master, u32 sid,
>  		case STRTAB_STE_0_CFG_BYPASS:
>  			break;
>  		case STRTAB_STE_0_CFG_S1_TRANS:
> +			s1_live = true;
> +			break;
>  		case STRTAB_STE_0_CFG_S2_TRANS:
> -			ste_live = true;
> +			s2_live = true;
> +			break;
> +		case STRTAB_STE_0_CFG_NESTED:
> +			s1_live = true;
> +			s2_live = true;
>  			break;
>  		case STRTAB_STE_0_CFG_ABORT:
> -			BUG_ON(!disable_bypass);
>  			break;
>  		default:
>  			BUG(); /* STE corruption */
>  		}
>  	}
> 
> +	ste_live = s1_live || s2_live;
> +
>  	/* Nuke the existing STE_0 value, as we're going to rewrite it */
>  	val = STRTAB_STE_0_V;
> 
>  	/* Bypass/fault */
> -	if (!smmu_domain || !(s1_cfg->set || s2_cfg->set)) {
> -		if (!smmu_domain && disable_bypass)
> +
> +	if (!smmu_domain)
> +		abort = disable_bypass;
> +	else
> +		abort = smmu_domain->abort;
> +
> +	if (abort || !translate) {
> +		if (abort)
>  			val |= FIELD_PREP(STRTAB_STE_0_CFG,
> STRTAB_STE_0_CFG_ABORT);
>  		else
>  			val |= FIELD_PREP(STRTAB_STE_0_CFG,
> STRTAB_STE_0_CFG_BYPASS);
> @@ -1274,8 +1292,16 @@ static void arm_smmu_write_strtab_ent(struct
> arm_smmu_master *master, u32 sid,
>  		return;
>  	}
> 
> +	BUG_ON(ste_live && !nested);
> +
> +	if (ste_live) {
> +		/* First invalidate the live STE */
> +		dst[0] = cpu_to_le64(STRTAB_STE_0_CFG_ABORT);
> +		arm_smmu_sync_ste_for_sid(smmu, sid);
> +	}
> +
>  	if (s1_cfg->set) {
> -		BUG_ON(ste_live);
> +		BUG_ON(s1_live);
>  		dst[1] = cpu_to_le64(
>  			 FIELD_PREP(STRTAB_STE_1_S1DSS,
> STRTAB_STE_1_S1DSS_SSID0) |
>  			 FIELD_PREP(STRTAB_STE_1_S1CIR,
> STRTAB_STE_1_S1C_CACHE_WBRA) |
> @@ -1294,7 +1320,14 @@ static void arm_smmu_write_strtab_ent(struct
> arm_smmu_master *master, u32 sid,
>  	}
> 
>  	if (s2_cfg->set) {
> -		BUG_ON(ste_live);
> +		u64 vttbr = s2_cfg->vttbr & STRTAB_STE_3_S2TTB_MASK;
> +
> +		if (s2_live) {
> +			u64 s2ttb = le64_to_cpu(dst[3] & STRTAB_STE_3_S2TTB_MASK);
> +
> +			BUG_ON(s2ttb != vttbr);
> +		}
> +
>  		dst[2] = cpu_to_le64(
>  			 FIELD_PREP(STRTAB_STE_2_S2VMID, s2_cfg->vmid) |
>  			 FIELD_PREP(STRTAB_STE_2_VTCR, s2_cfg->vtcr) |
> @@ -1304,9 +1337,12 @@ static void arm_smmu_write_strtab_ent(struct
> arm_smmu_master *master, u32 sid,
>  			 STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2AA64 |
>  			 STRTAB_STE_2_S2R);
> 
> -		dst[3] = cpu_to_le64(s2_cfg->vttbr & STRTAB_STE_3_S2TTB_MASK);
> +		dst[3] = cpu_to_le64(vttbr);
> 
>  		val |= FIELD_PREP(STRTAB_STE_0_CFG,
> STRTAB_STE_0_CFG_S2_TRANS);
> +	} else {
> +		dst[2] = 0;
> +		dst[3] = 0;
>  	}
> 
>  	if (master->ats_enabled)
> @@ -1982,6 +2018,14 @@ static int arm_smmu_domain_finalise(struct
> iommu_domain *domain,
>  		return 0;
>  	}
> 
> +	if (smmu_domain->stage == ARM_SMMU_DOMAIN_NESTED &&
> +	    (!(smmu->features & ARM_SMMU_FEAT_TRANS_S1) ||
> +	     !(smmu->features & ARM_SMMU_FEAT_TRANS_S2))) {
> +		dev_info(smmu_domain->smmu->dev,
> +			 "does not implement two stages\n");
> +		return -EINVAL;
> +	}
> +
>  	/* Restrict the stage to what we can actually support */
>  	if (!(smmu->features & ARM_SMMU_FEAT_TRANS_S1))
>  		smmu_domain->stage = ARM_SMMU_DOMAIN_S2;
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index 07f59252dd21..269779dee8d1 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -206,6 +206,7 @@
>  #define STRTAB_STE_0_CFG_BYPASS		4
>  #define STRTAB_STE_0_CFG_S1_TRANS	5
>  #define STRTAB_STE_0_CFG_S2_TRANS	6
> +#define STRTAB_STE_0_CFG_NESTED		7
> 
>  #define STRTAB_STE_0_S1FMT		GENMASK_ULL(5, 4)
>  #define STRTAB_STE_0_S1FMT_LINEAR	0
> @@ -682,6 +683,7 @@ struct arm_smmu_domain {
>  	enum arm_smmu_domain_stage	stage;
>  	struct arm_smmu_s1_cfg	s1_cfg;
>  	struct arm_smmu_s2_cfg	s2_cfg;
> +	bool				abort;
> 
>  	struct iommu_domain		domain;
> 
> --
> 2.21.3

