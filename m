Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27151D96A5
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 18:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405963AbfJPQLw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 12:11:52 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:35059 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391751AbfJPQLv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 12:11:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1571242310; x=1602778310;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AQyGB4hkyParoAaAhtScp3kCAoUcidCfZ+dAMF9QERU=;
  b=j9FWjHRtEXyUatH+j7NP8WESp7vp6S/YdHGTsHLsbnH4ylHYh7saiOqj
   sjhzHFVA3+NVNz7n+fJKARjVQ5YseRHyYqa0a5UHRcb4lPcI6NRTwyB/X
   toD+n5FWEY8sNBGyJlAUNlBL6e7slGx4UGnoICNc46kh7HgkTkv5wFU+5
   CWpGntZs0puyfwn0aZxJkFalWY92E3yLlDcOHf7Q+k8L3E+3754jTJfRt
   CO0YEGXpNZzfzUU/yTS87xob+KSuIC+ZcSVGDd7EMJmgLx07MYmzqtLQU
   jTdyQ6BL73N0ijeh7MLKIXFDrwwYnkt2HkSFTBPullZnrmA5kz7/Xw9mz
   Q==;
IronPort-SDR: vy7gt2v8EHi5QQ5hiixX79f6oLixn1h7quqbWAtURwYNpDeKE75SntF9Xf3roeXgmATrqqX01z
 YSjM3s/d/mIz0hjEZKzyElc02eOzGdOxKfjS0M/FeI0ZO3zhntBqkU1pQTSQ4oMrG7Vn3Vz+bW
 3f04qUVU1w6BsrwaNFRfWSaEv11n1RRCjwp/VgBXxE2vGcoiIrExWWl6LQa/U+0xXT9GVJJKhl
 Uo1YBpcJL7eG/MZjbMQGhW1+GzFj8tLwS01gAW5KZzTVFy9vcj6NCsqQg2JAQevjv8QrR55/rJ
 Wvw=
X-IronPort-AV: E=Sophos;i="5.67,304,1566835200"; 
   d="scan'208";a="122255678"
Received: from mail-by2nam01lp2057.outbound.protection.outlook.com (HELO NAM01-BY2-obe.outbound.protection.outlook.com) ([104.47.34.57])
  by ob1.hgst.iphmx.com with ESMTP; 17 Oct 2019 00:11:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bJrb3rM2SIP2I2eZ8Q+2rOV9ujjme8TzkO8663Xofsds9O7SVOlUAXjIaWFejJOh4/G2cXRJawRsolmZEuEuifYmpK/VM7WbzWS3kt88ChPQ+h5Ve9e2mBtQ5W0BfOvCY03bjAnJmkDz8xR9VyOKY4BvqcagSWFOqx7ki4qREuA+oxRU2vDNh0UzGgsndz+/LnpFQflLLc0tv82VIQk8E97iI1ZhNO7cFno/v9PCUdmGZJZUVmQBbi9pQD0gMgr/xuLV0dhUzrBhQjtFjzgU+9GaVqF+wXmtIyH/QrjDPL96CbjGua1aDiBlx43ryYLQwx8H+fllvCZ7wrGr9L2Rig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gEMOrfSLehq2pEp3GBEQRmyfA0kQ0vuWmoNnNi1z9cQ=;
 b=VkW1J1XG6whMWS1gYw+cPJa1MoeNdQ4L2TjFnroileY8Kn9QnBheP5Uho6hYsUZ8sluAriiGfFXG5JkHKKMIVA5qKy9/Uh6Waap+6uP+RUNBmpSwkS4EDcin5s+vqg08A8UYdVUnStxzQ9L7Ehz/LWFisH9CptBSuoFxtTB74rkl66bmed5hqVaTN8g4iwOwabEtq+n9GpgCTkZBjEjs6tdZDo2Nvo04SPWBW0bTAMzdA2yMUL6a6cWybzF/U6JFrdZlYb9WQjNP02H2tEUlDG7S3qY3UqdPcrfzmq9nz4tV9fZSG/EXpz0XimPwV1Z9eWcevRLJzb7uqbFSuOcF/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gEMOrfSLehq2pEp3GBEQRmyfA0kQ0vuWmoNnNi1z9cQ=;
 b=yxOez/4/Sq3ceXl+PegNOkz198zP+xgPxsyy+BcKEpE2JhlGBKM23+LpuY3P5Hqb1vIrpKozfpE19+H3PkPGhEg7uucEtjmk+Yna7bA9Xsdsx4Zl7EAfGDOPM+WzlrMkXFxC61gK9B87bKSI+QzGLmEjOgBKfy7VuC5HD478NiI=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6397.namprd04.prod.outlook.com (52.132.170.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.17; Wed, 16 Oct 2019 16:11:45 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a%7]) with mapi id 15.20.2347.023; Wed, 16 Oct 2019
 16:11:45 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>
CC:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anup Patel <Anup.Patel@wdc.com>
Subject: [PATCH v9 18/22] RISC-V: KVM: Simplify stage2 page table programming
Thread-Topic: [PATCH v9 18/22] RISC-V: KVM: Simplify stage2 page table
 programming
Thread-Index: AQHVhDxn+cnUvf0DQUOfjFveMbDpBw==
Date:   Wed, 16 Oct 2019 16:11:45 +0000
Message-ID: <20191016160649.24622-19-anup.patel@wdc.com>
References: <20191016160649.24622-1-anup.patel@wdc.com>
In-Reply-To: <20191016160649.24622-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR01CA0098.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:5d::16) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [106.51.27.162]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fd2c1310-a1f4-4068-7709-08d752538a2d
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: MN2PR04MB6397:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB6397DD410B48F33B7C3C18828D920@MN2PR04MB6397.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1332;
x-forefront-prvs: 0192E812EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39860400002)(376002)(396003)(346002)(366004)(189003)(199004)(81166006)(102836004)(316002)(44832011)(486006)(55236004)(110136005)(305945005)(7736002)(8676002)(11346002)(2616005)(446003)(54906003)(476003)(86362001)(6512007)(6436002)(30864003)(386003)(6506007)(81156014)(2906002)(6486002)(1076003)(8936002)(186003)(26005)(50226002)(5660300002)(9456002)(36756003)(66946007)(64756008)(66446008)(66476007)(71200400001)(71190400001)(66556008)(52116002)(7416002)(99286004)(256004)(25786009)(76176011)(14454004)(4326008)(478600001)(3846002)(6116002)(14444005)(66066001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6397;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: teiNzhSXsx4UtDK//yDe60jRDiWDDWdQgOYN/+JPGsayaZjVOCQvIMjdJ1hNzjkAuMIy2MDWevkh0cChf6ecfyt10H9zxlFJqVte2tDvhJZjjcgRktweOv+93t2ThltMYrvTrNgLU6Buhxh9REUOyciP3ASwIIBXgsLg+ykyVSE1TxJGUTH5T1T5VqdZhAdOHYTrlZikvf407EH8559EA2koa73sZ5AOhYfAvf0yfO6MPWld0DKrtrCTAKUEERIeTOZTSv3sSIpnAakFdq8Kz8mcHgJYrOqFhUHevBhLaAWEBUfbMK0w+VGqC1nls8ksEmL1mKydhBz6sssiRHELZgHP2Ny/eQy1GzmC8HhvsJrubQkG0fFWkfJ+saCfOz88Y+BSumrC8gyvQoniiwxbZlBZJSiP2lOhwMBuuhpnwbk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd2c1310-a1f4-4068-7709-08d752538a2d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2019 16:11:45.6309
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bMKAm42uyv5K1fiuEH1BCIzhsga/18wec+Z4FpHhCOmCNZPkRfdTegx5nMiwvLMw4P3NXicU1dDAFvP1YkP91g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6397
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of dealing with PGD, PMD, and PTE differently in stage2
page table progamming, we can simply use iterative and recursive
helper functions to program stage2 page tables of any level.

This patch re-implements stage2_get_leaf_entry(), stage2_set_pte(),
stage2_map_page(), stage2_op_pte(), stage2_unmap_range(), and
stage2_wp_range() helper functions as mentioned above.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 arch/riscv/kvm/mmu.c | 469 +++++++++++++++----------------------------
 1 file changed, 164 insertions(+), 305 deletions(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 5aa5ea5ef8f6..fe86cae4cf42 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -21,15 +21,56 @@
 #ifdef CONFIG_64BIT
 #define stage2_have_pmd		true
 #define stage2_gpa_size		((phys_addr_t)(1ULL << 39))
-#define stage2_cache_min_pages	2
+#define stage2_pgd_levels	3
+#define stage2_index_bits	9
 #else
-#define pmd_index(x)		0
-#define pfn_pmd(x, y)		({ pmd_t __x =3D { 0 }; __x; })
 #define stage2_have_pmd		false
 #define stage2_gpa_size		((phys_addr_t)(1ULL << 32))
-#define stage2_cache_min_pages	1
+#define stage2_pgd_levels	2
+#define stage2_index_bits	10
 #endif
=20
+#define stage2_pte_index(addr, level) \
+(((addr) >> (PAGE_SHIFT + stage2_index_bits * (level))) & (PTRS_PER_PTE - =
1))
+
+static inline unsigned long stage2_pte_page_vaddr(pte_t pte)
+{
+	return (unsigned long)pfn_to_virt(pte_val(pte) >> _PAGE_PFN_SHIFT);
+}
+
+static int stage2_page_size_to_level(unsigned long page_size, u32 *out_lev=
el)
+{
+	if (page_size =3D=3D PAGE_SIZE)
+		*out_level =3D 0;
+	else if (page_size =3D=3D PMD_SIZE)
+		*out_level =3D 1;
+	else if (page_size =3D=3D PGDIR_SIZE)
+		*out_level =3D (stage2_have_pmd) ? 2 : 1;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+
+static int stage2_level_to_page_size(u32 level, unsigned long *out_pgsize)
+{
+	switch (level) {
+	case 0:
+		*out_pgsize =3D PAGE_SIZE;
+		break;
+	case 1:
+		*out_pgsize =3D (stage2_have_pmd) ? PMD_SIZE : PGDIR_SIZE;
+		break;
+	case 2:
+		*out_pgsize =3D PGDIR_SIZE;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int stage2_cache_topup(struct kvm_mmu_page_cache *pcache,
 			      int min, int max)
 {
@@ -67,61 +108,30 @@ static void *stage2_cache_alloc(struct kvm_mmu_page_ca=
che *pcache)
 	return p;
 }
=20
-static int stage2_pgdp_test_and_clear_young(pgd_t *pgd)
-{
-	return ptep_test_and_clear_young(NULL, 0, (pte_t *)pgd);
-}
-
-static int stage2_pmdp_test_and_clear_young(pmd_t *pmd)
-{
-	return ptep_test_and_clear_young(NULL, 0, (pte_t *)pmd);
-}
-
-static int stage2_ptep_test_and_clear_young(pte_t *pte)
-{
-	return ptep_test_and_clear_young(NULL, 0, pte);
-}
-
 static bool stage2_get_leaf_entry(struct kvm *kvm, gpa_t addr,
-				  pgd_t **pgdpp, pmd_t **pmdpp, pte_t **ptepp)
+				  pte_t **ptepp, u32 *ptep_level)
 {
-	pgd_t *pgdp;
-	pmd_t *pmdp;
 	pte_t *ptep;
-
-	*pgdpp =3D NULL;
-	*pmdpp =3D NULL;
-	*ptepp =3D NULL;
-
-	pgdp =3D &kvm->arch.pgd[pgd_index(addr)];
-	if (!pgd_val(*pgdp))
-		return false;
-	if (pgd_val(*pgdp) & _PAGE_LEAF) {
-		*pgdpp =3D pgdp;
-		return true;
-	}
-
-	if (stage2_have_pmd) {
-		pmdp =3D (void *)pgd_page_vaddr(*pgdp);
-		pmdp =3D &pmdp[pmd_index(addr)];
-		if (!pmd_present(*pmdp))
-			return false;
-		if (pmd_val(*pmdp) & _PAGE_LEAF) {
-			*pmdpp =3D pmdp;
+	u32 current_level =3D stage2_pgd_levels - 1;
+
+	*ptep_level =3D current_level;
+	ptep =3D (pte_t *)kvm->arch.pgd;
+	ptep =3D &ptep[stage2_pte_index(addr, current_level)];
+	while (ptep && pte_val(*ptep)) {
+		if (pte_val(*ptep) & _PAGE_LEAF) {
+			*ptep_level =3D current_level;
+			*ptepp =3D ptep;
 			return true;
 		}
=20
-		ptep =3D (void *)pmd_page_vaddr(*pmdp);
-	} else {
-		ptep =3D (void *)pgd_page_vaddr(*pgdp);
-	}
-
-	ptep =3D &ptep[pte_index(addr)];
-	if (!pte_present(*ptep))
-		return false;
-	if (pte_val(*ptep) & _PAGE_LEAF) {
-		*ptepp =3D ptep;
-		return true;
+		if (current_level) {
+			current_level--;
+			*ptep_level =3D current_level;
+			ptep =3D (pte_t *)stage2_pte_page_vaddr(*ptep);
+			ptep =3D &ptep[stage2_pte_index(addr, current_level)];
+		} else {
+			ptep =3D NULL;
+		}
 	}
=20
 	return false;
@@ -160,96 +170,37 @@ static void stage2_remote_tlb_flush(struct kvm *kvm, =
gpa_t addr)
 	preempt_enable();
 }
=20
-static int stage2_set_pgd(struct kvm *kvm, gpa_t addr, const pgd_t *new_pg=
d)
-{
-	pgd_t *pgdp =3D &kvm->arch.pgd[pgd_index(addr)];
-
-	*pgdp =3D *new_pgd;
-	if (pgd_val(*pgdp) & _PAGE_LEAF)
-		stage2_remote_tlb_flush(kvm, addr);
-
-	return 0;
-}
-
-static int stage2_set_pmd(struct kvm *kvm, struct kvm_mmu_page_cache *pcac=
he,
-			  gpa_t addr, const pmd_t *new_pmd)
+static int stage2_set_pte(struct kvm *kvm, u32 level,
+			   struct kvm_mmu_page_cache *pcache,
+			   gpa_t addr, const pte_t *new_pte)
 {
-	int rc;
-	pmd_t *pmdp;
-	pgd_t new_pgd;
-	pgd_t *pgdp =3D &kvm->arch.pgd[pgd_index(addr)];
-
-	if (!pgd_val(*pgdp)) {
-		pmdp =3D stage2_cache_alloc(pcache);
-		if (!pmdp)
-			return -ENOMEM;
-		new_pgd =3D pfn_pgd(PFN_DOWN(__pa(pmdp)), __pgprot(_PAGE_TABLE));
-		rc =3D stage2_set_pgd(kvm, addr, &new_pgd);
-		if (rc)
-			return rc;
-	}
-
-	if (pgd_val(*pgdp) & _PAGE_LEAF)
-		return -EEXIST;
+	u32 current_level =3D stage2_pgd_levels - 1;
+	pte_t *next_ptep =3D (pte_t *)kvm->arch.pgd;
+	pte_t *ptep =3D &next_ptep[stage2_pte_index(addr, current_level)];
=20
-	pmdp =3D (void *)pgd_page_vaddr(*pgdp);
-	pmdp =3D &pmdp[pmd_index(addr)];
-
-	*pmdp =3D *new_pmd;
-	if (pmd_val(*pmdp) & _PAGE_LEAF)
-		stage2_remote_tlb_flush(kvm, addr);
-
-	return 0;
-}
-
-static int stage2_set_pte(struct kvm *kvm,
-			  struct kvm_mmu_page_cache *pcache,
-			  gpa_t addr, const pte_t *new_pte)
-{
-	int rc;
-	pte_t *ptep;
-	pmd_t new_pmd;
-	pmd_t *pmdp;
-	pgd_t new_pgd;
-	pgd_t *pgdp =3D &kvm->arch.pgd[pgd_index(addr)];
-
-	if (!pgd_val(*pgdp)) {
-		pmdp =3D stage2_cache_alloc(pcache);
-		if (!pmdp)
-			return -ENOMEM;
-		new_pgd =3D pfn_pgd(PFN_DOWN(__pa(pmdp)), __pgprot(_PAGE_TABLE));
-		rc =3D stage2_set_pgd(kvm, addr, &new_pgd);
-		if (rc)
-			return rc;
-	}
+	if (current_level < level)
+		return -EINVAL;
=20
-	if (pgd_val(*pgdp) & _PAGE_LEAF)
-		return -EEXIST;
+	while (current_level !=3D level) {
+		if (pte_val(*ptep) & _PAGE_LEAF)
+			return -EEXIST;
=20
-	if (stage2_have_pmd) {
-		pmdp =3D (void *)pgd_page_vaddr(*pgdp);
-		pmdp =3D &pmdp[pmd_index(addr)];
-		if (!pmd_present(*pmdp)) {
-			ptep =3D stage2_cache_alloc(pcache);
-			if (!ptep)
+		if (!pte_val(*ptep)) {
+			next_ptep =3D stage2_cache_alloc(pcache);
+			if (!next_ptep)
 				return -ENOMEM;
-			new_pmd =3D pfn_pmd(PFN_DOWN(__pa(ptep)),
-					  __pgprot(_PAGE_TABLE));
-			rc =3D stage2_set_pmd(kvm, pcache, addr, &new_pmd);
-			if (rc)
-				return rc;
+			*ptep =3D pfn_pte(PFN_DOWN(__pa(next_ptep)),
+					__pgprot(_PAGE_TABLE));
+		} else {
+			if (pte_val(*ptep) & _PAGE_LEAF)
+				return -EEXIST;
+			next_ptep =3D (pte_t *)stage2_pte_page_vaddr(*ptep);
 		}
=20
-		if (pmd_val(*pmdp) & _PAGE_LEAF)
-			return -EEXIST;
-
-		ptep =3D (void *)pmd_page_vaddr(*pmdp);
-	} else {
-		ptep =3D (void *)pgd_page_vaddr(*pgdp);
+		current_level--;
+		ptep =3D &next_ptep[stage2_pte_index(addr, current_level)];
 	}
=20
-	ptep =3D &ptep[pte_index(addr)];
-
 	*ptep =3D *new_pte;
 	if (pte_val(*ptep) & _PAGE_LEAF)
 		stage2_remote_tlb_flush(kvm, addr);
@@ -262,26 +213,16 @@ static int stage2_map_page(struct kvm *kvm,
 			   gpa_t gpa, phys_addr_t hpa,
 			   unsigned long page_size, pgprot_t prot)
 {
+	int ret;
+	u32 level =3D 0;
 	pte_t new_pte;
-	pmd_t new_pmd;
-	pgd_t new_pgd;
-
-	if (page_size =3D=3D PAGE_SIZE) {
-		new_pte =3D pfn_pte(PFN_DOWN(hpa), prot);
-		return stage2_set_pte(kvm, pcache, gpa, &new_pte);
-	}
=20
-	if (stage2_have_pmd && page_size =3D=3D PMD_SIZE) {
-		new_pmd =3D pfn_pmd(PFN_DOWN(hpa), prot);
-		return stage2_set_pmd(kvm, pcache, gpa, &new_pmd);
-	}
-
-	if (page_size =3D=3D PGDIR_SIZE) {
-		new_pgd =3D pfn_pgd(PFN_DOWN(hpa), prot);
-		return stage2_set_pgd(kvm, gpa, &new_pgd);
-	}
+	ret =3D stage2_page_size_to_level(page_size, &level);
+	if (ret)
+		return ret;
=20
-	return -EINVAL;
+	new_pte =3D pfn_pte(PFN_DOWN(hpa), prot);
+	return stage2_set_pte(kvm, level, pcache, gpa, &new_pte);
 }
=20
 enum stage2_op {
@@ -290,171 +231,100 @@ enum stage2_op {
 	STAGE2_OP_WP,		/* Write-protect */
 };
=20
-static void stage2_op_pte(struct kvm *kvm, gpa_t addr, pte_t *ptep,
-			  enum stage2_op op)
-{
-	BUG_ON(addr & (PAGE_SIZE - 1));
-
-	if (!pte_present(*ptep))
-		return;
-
-	if (op =3D=3D STAGE2_OP_CLEAR)
-		set_pte(ptep, __pte(0));
-	else if (op =3D=3D STAGE2_OP_WP)
-		set_pte(ptep, __pte(pte_val(*ptep) & ~_PAGE_WRITE));
-	stage2_remote_tlb_flush(kvm, addr);
-}
-
-static void stage2_op_pmd(struct kvm *kvm, gpa_t addr, pmd_t *pmdp,
-			  enum stage2_op op)
+static void stage2_op_pte(struct kvm *kvm, gpa_t addr,
+			  pte_t *ptep, u32 ptep_level, enum stage2_op op)
 {
-	int i;
-	pte_t *ptep;
+	int i, ret;
+	pte_t *next_ptep;
+	u32 next_ptep_level;
+	unsigned long next_page_size, page_size;
=20
-	BUG_ON(addr & (PMD_SIZE - 1));
-
-	if (!pmd_present(*pmdp))
+	ret =3D stage2_level_to_page_size(ptep_level, &page_size);
+	if (ret)
 		return;
=20
-	if (pmd_val(*pmdp) & _PAGE_LEAF)
-		ptep =3D NULL;
-	else
-		ptep =3D (pte_t *)pmd_page_vaddr(*pmdp);
-
-	if (op =3D=3D STAGE2_OP_CLEAR)
-		set_pmd(pmdp, __pmd(0));
-
-	if (ptep) {
-		for (i =3D 0; i < PTRS_PER_PTE; i++)
-			stage2_op_pte(kvm, addr + i * PAGE_SIZE, &ptep[i], op);
-		if (op =3D=3D STAGE2_OP_CLEAR)
-			put_page(virt_to_page(ptep));
-	} else {
-		if (op =3D=3D STAGE2_OP_WP)
-			set_pmd(pmdp, __pmd(pmd_val(*pmdp) & ~_PAGE_WRITE));
-		stage2_remote_tlb_flush(kvm, addr);
-	}
-}
-
-static void stage2_op_pgd(struct kvm *kvm, gpa_t addr, pgd_t *pgdp,
-			  enum stage2_op op)
-{
-	int i;
-	pte_t *ptep;
-	pmd_t *pmdp;
+	BUG_ON(addr & (page_size - 1));
=20
-	BUG_ON(addr & (PGDIR_SIZE - 1));
-
-	if (!pgd_val(*pgdp))
+	if (!pte_val(*ptep))
 		return;
=20
-	ptep =3D NULL;
-	pmdp =3D NULL;
-	if (!(pgd_val(*pgdp) & _PAGE_LEAF)) {
-		if (stage2_have_pmd)
-			pmdp =3D (pmd_t *)pgd_page_vaddr(*pgdp);
-		else
-			ptep =3D (pte_t *)pgd_page_vaddr(*pgdp);
-	}
-
-	if (op =3D=3D STAGE2_OP_CLEAR)
-		set_pgd(pgdp, __pgd(0));
+	if (ptep_level && !(pte_val(*ptep) & _PAGE_LEAF)) {
+		next_ptep =3D (pte_t *)stage2_pte_page_vaddr(*ptep);
+		next_ptep_level =3D ptep_level - 1;
+		ret =3D stage2_level_to_page_size(next_ptep_level,
+						&next_page_size);
+		if (ret)
+			return;
=20
-	if (pmdp) {
-		for (i =3D 0; i < PTRS_PER_PMD; i++)
-			stage2_op_pmd(kvm, addr + i * PMD_SIZE, &pmdp[i], op);
 		if (op =3D=3D STAGE2_OP_CLEAR)
-			put_page(virt_to_page(pmdp));
-	} else if (ptep) {
+			set_pte(ptep, __pte(0));
 		for (i =3D 0; i < PTRS_PER_PTE; i++)
-			stage2_op_pte(kvm, addr + i * PAGE_SIZE, &ptep[i], op);
+			stage2_op_pte(kvm, addr + i * next_page_size,
+					&next_ptep[i], next_ptep_level, op);
 		if (op =3D=3D STAGE2_OP_CLEAR)
-			put_page(virt_to_page(ptep));
+			put_page(virt_to_page(next_ptep));
 	} else {
-		if (op =3D=3D STAGE2_OP_WP)
-			set_pgd(pgdp, __pgd(pgd_val(*pgdp) & ~_PAGE_WRITE));
+		if (op =3D=3D STAGE2_OP_CLEAR)
+			set_pte(ptep, __pte(0));
+		else if (op =3D=3D STAGE2_OP_WP)
+			set_pte(ptep, __pte(pte_val(*ptep) & ~_PAGE_WRITE));
 		stage2_remote_tlb_flush(kvm, addr);
 	}
 }
=20
 static void stage2_unmap_range(struct kvm *kvm, gpa_t start, gpa_t size)
 {
-	pmd_t *pmdp;
+	int ret;
 	pte_t *ptep;
-	pgd_t *pgdp;
+	u32 ptep_level;
+	bool found_leaf;
+	unsigned long page_size;
 	gpa_t addr =3D start, end =3D start + size;
=20
 	while (addr < end) {
-		pgdp =3D &kvm->arch.pgd[pgd_index(addr)];
-		if (!pgd_val(*pgdp)) {
-			addr +=3D PGDIR_SIZE;
-			continue;
-		} else if (!(addr & (PGDIR_SIZE - 1)) &&
-			  ((end - addr) >=3D PGDIR_SIZE)) {
-			stage2_op_pgd(kvm, addr, pgdp, STAGE2_OP_CLEAR);
-			addr +=3D PGDIR_SIZE;
-			continue;
-		}
+		found_leaf =3D stage2_get_leaf_entry(kvm, addr,
+						   &ptep, &ptep_level);
+		ret =3D stage2_level_to_page_size(ptep_level, &page_size);
+		if (ret)
+			break;
=20
-		if (stage2_have_pmd) {
-			pmdp =3D (pmd_t *)pgd_page_vaddr(*pgdp);
-			if (!pmd_present(*pmdp)) {
-				addr +=3D PMD_SIZE;
-				continue;
-			} else if (!(addr & (PMD_SIZE - 1)) &&
-				   ((end - addr) >=3D PMD_SIZE)) {
-				stage2_op_pmd(kvm, addr, pmdp,
-					      STAGE2_OP_CLEAR);
-				addr +=3D PMD_SIZE;
-				continue;
-			}
-			ptep =3D (pte_t *)pmd_page_vaddr(*pmdp);
-		} else {
-			ptep =3D (pte_t *)pgd_page_vaddr(*pgdp);
-		}
+		if (!found_leaf)
+			goto next;
+
+		if (!(addr & (page_size - 1)) && ((end - addr) >=3D page_size))
+			stage2_op_pte(kvm, addr, ptep,
+				      ptep_level, STAGE2_OP_CLEAR);
=20
-		stage2_op_pte(kvm, addr, ptep, STAGE2_OP_CLEAR);
-		addr +=3D PAGE_SIZE;
+next:
+		addr +=3D page_size;
 	}
 }
=20
 static void stage2_wp_range(struct kvm *kvm, gpa_t start, gpa_t end)
 {
-	pmd_t *pmdp;
+	int ret;
 	pte_t *ptep;
-	pgd_t *pgdp;
+	u32 ptep_level;
+	bool found_leaf;
 	gpa_t addr =3D start;
+	unsigned long page_size;
=20
 	while (addr < end) {
-		pgdp =3D &kvm->arch.pgd[pgd_index(addr)];
-		if (!pgd_val(*pgdp)) {
-			addr +=3D PGDIR_SIZE;
-			continue;
-		} else if (!(addr & (PGDIR_SIZE - 1)) &&
-			   ((end - addr) >=3D PGDIR_SIZE)) {
-			stage2_op_pgd(kvm, addr, pgdp, STAGE2_OP_WP);
-			addr +=3D PGDIR_SIZE;
-			continue;
-		}
+		found_leaf =3D stage2_get_leaf_entry(kvm, addr,
+						   &ptep, &ptep_level);
+		ret =3D stage2_level_to_page_size(ptep_level, &page_size);
+		if (ret)
+			break;
=20
-		if (stage2_have_pmd) {
-			pmdp =3D (pmd_t *)pgd_page_vaddr(*pgdp);
-			if (!pmd_present(*pmdp)) {
-				addr +=3D PMD_SIZE;
-				continue;
-			} else if (!(addr & (PMD_SIZE - 1)) &&
-				   ((end - addr) >=3D PMD_SIZE)) {
-				stage2_op_pmd(kvm, addr, pmdp, STAGE2_OP_WP);
-				addr +=3D PMD_SIZE;
-				continue;
-			}
-			ptep =3D (pte_t *)pmd_page_vaddr(*pmdp);
-		} else {
-			ptep =3D (pte_t *)pgd_page_vaddr(*pgdp);
-		}
+		if (!found_leaf)
+			goto next;
+
+		if (!(addr & (page_size - 1)) && ((end - addr) >=3D page_size))
+			stage2_op_pte(kvm, addr, ptep,
+				      ptep_level, STAGE2_OP_WP);
=20
-		stage2_op_pte(kvm, addr, ptep, STAGE2_OP_WP);
-		addr +=3D PAGE_SIZE;
+next:
+		addr +=3D page_size;
 	}
 }
=20
@@ -490,13 +360,13 @@ int stage2_ioremap(struct kvm *kvm, gpa_t gpa, phys_a=
ddr_t hpa,
 			pte =3D pte_wrprotect(pte);
=20
 		ret =3D stage2_cache_topup(&pcache,
-					 stage2_cache_min_pages,
+					 stage2_pgd_levels,
 					 KVM_MMU_PAGE_CACHE_NR_OBJS);
 		if (ret)
 			goto out;
=20
 		spin_lock(&kvm->mmu_lock);
-		ret =3D stage2_set_pte(kvm, &pcache, addr, &pte);
+		ret =3D stage2_set_pte(kvm, 0, &pcache, addr, &pte);
 		spin_unlock(&kvm->mmu_lock);
 		if (ret)
 			goto out;
@@ -698,7 +568,7 @@ static int kvm_set_spte_handler(struct kvm *kvm,
 	pte_t *pte =3D (pte_t *)data;
=20
 	WARN_ON(size !=3D PAGE_SIZE);
-	stage2_set_pte(kvm, NULL, gpa, pte);
+	stage2_set_pte(kvm, 0, NULL, gpa, pte);
=20
 	return 0;
 }
@@ -722,20 +592,15 @@ int kvm_set_spte_hva(struct kvm *kvm, unsigned long h=
va, pte_t pte)
 static int kvm_age_hva_handler(struct kvm *kvm,
 				gpa_t gpa, u64 size, void *data)
 {
-	pgd_t *pgd;
-	pmd_t *pmd;
-	pte_t *pte;
+	pte_t *ptep;
+	u32 ptep_level =3D 0;
=20
 	WARN_ON(size !=3D PAGE_SIZE && size !=3D PMD_SIZE && size !=3D PGDIR_SIZE=
);
-	if (!stage2_get_leaf_entry(kvm, gpa, &pgd, &pmd, &pte))
+
+	if (!stage2_get_leaf_entry(kvm, gpa, &ptep, &ptep_level))
 		return 0;
=20
-	if (pgd)
-		return stage2_pgdp_test_and_clear_young(pgd);
-	else if (pmd)
-		return stage2_pmdp_test_and_clear_young(pmd);
-	else
-		return stage2_ptep_test_and_clear_young(pte);
+	return ptep_test_and_clear_young(NULL, 0, ptep);
 }
=20
 int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
@@ -749,20 +614,14 @@ int kvm_age_hva(struct kvm *kvm, unsigned long start,=
 unsigned long end)
 static int kvm_test_age_hva_handler(struct kvm *kvm,
 				    gpa_t gpa, u64 size, void *data)
 {
-	pgd_t *pgd;
-	pmd_t *pmd;
-	pte_t *pte;
+	pte_t *ptep;
+	u32 ptep_level =3D 0;
=20
 	WARN_ON(size !=3D PAGE_SIZE && size !=3D PMD_SIZE);
-	if (!stage2_get_leaf_entry(kvm, gpa, &pgd, &pmd, &pte))
+	if (!stage2_get_leaf_entry(kvm, gpa, &ptep, &ptep_level))
 		return 0;
=20
-	if (pgd)
-		return pte_young(*((pte_t *)pgd));
-	else if (pmd)
-		return pte_young(*((pte_t *)pmd));
-	else
-		return pte_young(*pte);
+	return pte_young(*ptep);
 }
=20
 int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
@@ -811,7 +670,7 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu, gpa_t g=
pa, unsigned long hva,
 	}
=20
 	/* We need minimum second+third level pages */
-	ret =3D stage2_cache_topup(pcache, stage2_cache_min_pages,
+	ret =3D stage2_cache_topup(pcache, stage2_pgd_levels,
 				 KVM_MMU_PAGE_CACHE_NR_OBJS);
 	if (ret) {
 		kvm_err("Failed to topup stage2 cache\n");
--=20
2.17.1

