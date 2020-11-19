Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D81482B8A91
	for <lists+kvm@lfdr.de>; Thu, 19 Nov 2020 05:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgKSEAo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Nov 2020 23:00:44 -0500
Received: from mga11.intel.com ([192.55.52.93]:38111 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725964AbgKSEAo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Nov 2020 23:00:44 -0500
IronPort-SDR: Cueo/SgBFKjUzINwkTwazkMnYJc5eL+QjOa4F9qC3FJnG8a0ngQcJP7xPX52eE2Zmb5dLOBzxV
 +jSvb/5E551Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9809"; a="167719536"
X-IronPort-AV: E=Sophos;i="5.77,489,1596524400"; 
   d="gz'50?scan'50,208,50";a="167719536"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2020 20:00:42 -0800
IronPort-SDR: VHInHkZuBYJyKh9OuwaBOF36esnVq2Qqnv/aEg41tQJPzdFgJLcOlFQkHdPuf4cRNwbT3c72gx
 6f7hdIzg5NLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,489,1596524400"; 
   d="gz'50?scan'50,208,50";a="401380201"
Received: from lkp-server01.sh.intel.com (HELO cbf10a1dd0e4) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 18 Nov 2020 20:00:39 -0800
Received: from kbuild by cbf10a1dd0e4 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1kfb7e-00003A-Fo; Thu, 19 Nov 2020 04:00:38 +0000
Date:   Thu, 19 Nov 2020 11:59:51 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
        joro@8bytes.org, maz@kernel.org, robin.murphy@arm.com
Cc:     kbuild-all@lists.01.org
Subject: Re: [PATCH v13 05/15] iommu/smmuv3: Get prepared for nested stage
 support
Message-ID: <202011191103.JVUre092-lkp@intel.com>
References: <20201118112151.25412-6-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
In-Reply-To: <20201118112151.25412-6-eric.auger@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Eric,

I love your patch! Perhaps something to improve:

[auto build test WARNING on iommu/next]
[also build test WARNING on linus/master v5.10-rc4 next-20201118]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Eric-Auger/SMMUv3-Nested-Stage-Setup-IOMMU-part/20201118-192520
base:   https://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git next
config: arm64-randconfig-s031-20201118 (attached as .config)
compiler: aarch64-linux-gcc (GCC) 9.3.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.3-123-g626c4742-dirty
        # https://github.com/0day-ci/linux/commit/7308cdb07384d807c5ef43e6bfe0cd61c35a121e
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Eric-Auger/SMMUv3-Nested-Stage-Setup-IOMMU-part/20201118-192520
        git checkout 7308cdb07384d807c5ef43e6bfe0cd61c35a121e
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' ARCH=arm64 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


"sparse warnings: (new ones prefixed by >>)"
>> drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c:1326:37: sparse: sparse: restricted __le64 degrades to integer
   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c:1326:37: sparse: sparse: cast to restricted __le64
   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c: note: in included file (through arch/arm64/include/asm/atomic.h, include/linux/atomic.h, include/asm-generic/bitops/atomic.h, ...):
   arch/arm64/include/asm/cmpxchg.h:172:1: sparse: sparse: cast truncates bits from constant value (ffffffff80000000 becomes 0)
   arch/arm64/include/asm/cmpxchg.h:172:1: sparse: sparse: cast truncates bits from constant value (ffffffff80000000 becomes 0)

vim +1326 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c

  1175	
  1176	static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
  1177					      __le64 *dst)
  1178	{
  1179		/*
  1180		 * This is hideously complicated, but we only really care about
  1181		 * three cases at the moment:
  1182		 *
  1183		 * 1. Invalid (all zero) -> bypass/fault (init)
  1184		 * 2. Bypass/fault -> single stage translation/bypass (attach)
  1185		 * 3. Single or nested stage Translation/bypass -> bypass/fault (detach)
  1186		 * 4. S2 -> S1 + S2 (attach_pasid_table)
  1187		 * 5. S1 + S2 -> S2 (detach_pasid_table)
  1188		 *
  1189		 * Given that we can't update the STE atomically and the SMMU
  1190		 * doesn't read the thing in a defined order, that leaves us
  1191		 * with the following maintenance requirements:
  1192		 *
  1193		 * 1. Update Config, return (init time STEs aren't live)
  1194		 * 2. Write everything apart from dword 0, sync, write dword 0, sync
  1195		 * 3. Update Config, sync
  1196		 */
  1197		u64 val = le64_to_cpu(dst[0]);
  1198		bool s1_live = false, s2_live = false, ste_live;
  1199		bool abort, nested = false, translate = false;
  1200		struct arm_smmu_device *smmu = NULL;
  1201		struct arm_smmu_s1_cfg *s1_cfg;
  1202		struct arm_smmu_s2_cfg *s2_cfg;
  1203		struct arm_smmu_domain *smmu_domain = NULL;
  1204		struct arm_smmu_cmdq_ent prefetch_cmd = {
  1205			.opcode		= CMDQ_OP_PREFETCH_CFG,
  1206			.prefetch	= {
  1207				.sid	= sid,
  1208			},
  1209		};
  1210	
  1211		if (master) {
  1212			smmu_domain = master->domain;
  1213			smmu = master->smmu;
  1214		}
  1215	
  1216		if (smmu_domain) {
  1217			s1_cfg = &smmu_domain->s1_cfg;
  1218			s2_cfg = &smmu_domain->s2_cfg;
  1219	
  1220			switch (smmu_domain->stage) {
  1221			case ARM_SMMU_DOMAIN_S1:
  1222				s1_cfg->set = true;
  1223				s2_cfg->set = false;
  1224				break;
  1225			case ARM_SMMU_DOMAIN_S2:
  1226				s1_cfg->set = false;
  1227				s2_cfg->set = true;
  1228				break;
  1229			case ARM_SMMU_DOMAIN_NESTED:
  1230				/*
  1231				 * Actual usage of stage 1 depends on nested mode:
  1232				 * legacy (2d stage only) or true nested mode
  1233				 */
  1234				s2_cfg->set = true;
  1235				break;
  1236			default:
  1237				break;
  1238			}
  1239			nested = s1_cfg->set && s2_cfg->set;
  1240			translate = s1_cfg->set || s2_cfg->set;
  1241		}
  1242	
  1243		if (val & STRTAB_STE_0_V) {
  1244			switch (FIELD_GET(STRTAB_STE_0_CFG, val)) {
  1245			case STRTAB_STE_0_CFG_BYPASS:
  1246				break;
  1247			case STRTAB_STE_0_CFG_S1_TRANS:
  1248				s1_live = true;
  1249				break;
  1250			case STRTAB_STE_0_CFG_S2_TRANS:
  1251				s2_live = true;
  1252				break;
  1253			case STRTAB_STE_0_CFG_NESTED:
  1254				s1_live = true;
  1255				s2_live = true;
  1256				break;
  1257			case STRTAB_STE_0_CFG_ABORT:
  1258				break;
  1259			default:
  1260				BUG(); /* STE corruption */
  1261			}
  1262		}
  1263	
  1264		ste_live = s1_live || s2_live;
  1265	
  1266		/* Nuke the existing STE_0 value, as we're going to rewrite it */
  1267		val = STRTAB_STE_0_V;
  1268	
  1269		/* Bypass/fault */
  1270	
  1271		if (!smmu_domain)
  1272			abort = disable_bypass;
  1273		else
  1274			abort = smmu_domain->abort;
  1275	
  1276		if (abort || !translate) {
  1277			if (abort)
  1278				val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT);
  1279			else
  1280				val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_BYPASS);
  1281	
  1282			dst[0] = cpu_to_le64(val);
  1283			dst[1] = cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCFG,
  1284							STRTAB_STE_1_SHCFG_INCOMING));
  1285			dst[2] = 0; /* Nuke the VMID */
  1286			/*
  1287			 * The SMMU can perform negative caching, so we must sync
  1288			 * the STE regardless of whether the old value was live.
  1289			 */
  1290			if (smmu)
  1291				arm_smmu_sync_ste_for_sid(smmu, sid);
  1292			return;
  1293		}
  1294	
  1295		BUG_ON(ste_live && !nested);
  1296	
  1297		if (ste_live) {
  1298			/* First invalidate the live STE */
  1299			dst[0] = cpu_to_le64(STRTAB_STE_0_CFG_ABORT);
  1300			arm_smmu_sync_ste_for_sid(smmu, sid);
  1301		}
  1302	
  1303		if (s1_cfg->set) {
  1304			BUG_ON(s1_live);
  1305			dst[1] = cpu_to_le64(
  1306				 FIELD_PREP(STRTAB_STE_1_S1DSS, STRTAB_STE_1_S1DSS_SSID0) |
  1307				 FIELD_PREP(STRTAB_STE_1_S1CIR, STRTAB_STE_1_S1C_CACHE_WBRA) |
  1308				 FIELD_PREP(STRTAB_STE_1_S1COR, STRTAB_STE_1_S1C_CACHE_WBRA) |
  1309				 FIELD_PREP(STRTAB_STE_1_S1CSH, ARM_SMMU_SH_ISH) |
  1310				 FIELD_PREP(STRTAB_STE_1_STRW, STRTAB_STE_1_STRW_NSEL1));
  1311	
  1312			if (smmu->features & ARM_SMMU_FEAT_STALLS &&
  1313			   !(smmu->features & ARM_SMMU_FEAT_STALL_FORCE))
  1314				dst[1] |= cpu_to_le64(STRTAB_STE_1_S1STALLD);
  1315	
  1316			val |= (s1_cfg->cdcfg.cdtab_dma & STRTAB_STE_0_S1CTXPTR_MASK) |
  1317				FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S1_TRANS) |
  1318				FIELD_PREP(STRTAB_STE_0_S1CDMAX, s1_cfg->s1cdmax) |
  1319				FIELD_PREP(STRTAB_STE_0_S1FMT, s1_cfg->s1fmt);
  1320		}
  1321	
  1322		if (s2_cfg->set) {
  1323			u64 vttbr = s2_cfg->vttbr & STRTAB_STE_3_S2TTB_MASK;
  1324	
  1325			if (s2_live) {
> 1326				u64 s2ttb = le64_to_cpu(dst[3] & STRTAB_STE_3_S2TTB_MASK);
  1327	
  1328				BUG_ON(s2ttb != vttbr);
  1329			}
  1330	
  1331			dst[2] = cpu_to_le64(
  1332				 FIELD_PREP(STRTAB_STE_2_S2VMID, s2_cfg->vmid) |
  1333				 FIELD_PREP(STRTAB_STE_2_VTCR, s2_cfg->vtcr) |
  1334	#ifdef __BIG_ENDIAN
  1335				 STRTAB_STE_2_S2ENDI |
  1336	#endif
  1337				 STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2AA64 |
  1338				 STRTAB_STE_2_S2R);
  1339	
  1340			dst[3] = cpu_to_le64(vttbr);
  1341	
  1342			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S2_TRANS);
  1343		} else {
  1344			dst[2] = 0;
  1345			dst[3] = 0;
  1346		}
  1347	
  1348		if (master->ats_enabled)
  1349			dst[1] |= cpu_to_le64(FIELD_PREP(STRTAB_STE_1_EATS,
  1350							 STRTAB_STE_1_EATS_TRANS));
  1351	
  1352		arm_smmu_sync_ste_for_sid(smmu, sid);
  1353		/* See comment in arm_smmu_write_ctx_desc() */
  1354		WRITE_ONCE(dst[0], cpu_to_le64(val));
  1355		arm_smmu_sync_ste_for_sid(smmu, sid);
  1356	
  1357		/* It's likely that we'll want to use the new STE soon */
  1358		if (!(smmu->options & ARM_SMMU_OPT_SKIP_PREFETCH))
  1359			arm_smmu_cmdq_issue_cmd(smmu, &prefetch_cmd);
  1360	}
  1361	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--jI8keyz6grp/JLjh
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
j66VxBT5H50HaeRvYW+dv5Fn6xzuTkaKJMmcGf4ELb6syEMCOlmW2WpT1m/9HPj3W+UeLqrc
PHeYm08wtEaXPRzLh1zYmOPHt7i4v6rjyh34k9uU1kzrCT46TCs2xbFDH+TbuGlVXuLuu+ec
5Y/AC7I3uxggmKfx2jyXpT+e758eZ9rl3Z7iVjPQCvoHjuzUS+kXpjs7LANDCR/tMQxOGOae
fpi/SIfa1iZ37GmsizO5PWyIsjvWazRqSdCSkvIQDYUaS4rTLzzid8NFetLYheskyyINpI47
LFHr1UAWOOubKY3kayGOwfYH6Yoy14tuy3OGrijweUsxPPDY+VzOpyR0bv5c3a093N2bTdm0
1Be1iGHq/CAyFo0xKzAcahJ5xpa5QYExy0CxgX91YrtWEDx16njUQciKigegCpFb41DferrU
HTp7yyMfuhDDf2t4zy71KRMGCnFkrHwaTpkMEGzxYSHJEao++eU4bC7VQLvMWHDWRSF8xkST
nDDlULgeU9wvISKirsKikHWPyA8O0FgxGVDQYlABHqCpuMWhayxcEoRquaUlfHa1l2JIwkBr
yi5sK/kuZMifCTMW28xb+PJl/mgLhznrlXa10NacGZJDOXXZrb5ZR3I25sPZLu7zRw9v9VjT
xs5ibhd1ZosUigyfJ9oGjCd+sIryQiwyZrp2Kg7WSKVmaFzzkz6sgg7IcqY0Vo29fgw11QXT
ZHr0nNsOMLLY9aQX2OBCR8VkVKTCshMu7eZP13p807JH79ZbDEO+7lff33/9+uFff/3449fv
Hwr9wKM6zXmLoe2lVQVo/ID0KZOk35djKX5IpaTK4V9VN81YyrE/FiDvhyekygygxoi9p6ZW
k7Ano/NCgMwLATmvrWuxVv1Y1uduLjsYbtRXXUvs5Yg3FQaLrED8LYtZfhcAdHQw19Tni1o3
9IK3nKAxrQaob2LFMJawcWigfKOf16BPxDECZAQabA5aBN0GJb4K/H29lSzTalJW1G4IgBzp
Xk7A3IJf9lq6bTH7lCpxaufzYwpCWZkDuulLGoiLFRI5x2ECLkemFRc+Okur2xIFwL5Vx7Cu
NyMJNCXfieUFkpwe4qXS+5f//fbLTz//+8P/fMAO1+KrblMIVbq8yRhbIovuJSJiOjvfho4l
1Y6/TYUXKjfLOyasEIn+2FmGO1mqafezY3ZzhJ2H37Lem7KgMjfdAO9YVuBlPLXJazyycysJ
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

--jI8keyz6grp/JLjh--
