Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD98129578
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2019 12:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbfLWLg4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Dec 2019 06:36:56 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:31281 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727368AbfLWLg4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Dec 2019 06:36:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1577101015; x=1608637015;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=C6ReUobFrsG9lWKz/UOmJU5yZIR2t0VuzLjKTCDD9E0=;
  b=Wj9y6+qcuSC4f/UyRQq0Yzb8ldsnT28F/WiJK9MV0gyBFWBlqWKGj0NH
   mZdmIEklKEoLu/I/H2G/SJ1y1Q9MZ8coi8vMgK/DEYDpVfx/C3DbPYNQq
   gCQQ934vyEDOBiSn3HMc6XwSs/68YpMcB9ttk2dauQNWQOGxKDDQ6v2OQ
   mEHCuRVOT+7YeAO5Er3MPgSoRV2bnLg/Zl5IzDNk0nbWr7QQ9og+y8qxe
   70R/hK1ry9QdNf3oFS/bBQ9Puh4yDFiwAFm3begAaUEb3r8fy2TRaH+P/
   IrhweqbwgQYpy6Q4djyDkSbtNBIfriCTO2NV+WRk/gbYaE0GhHas4Ma0v
   Q==;
IronPort-SDR: 7Y7pJy8MWIh8dIc4WJH3Eed5nuTfNiEDj7eVmoGFzlN+XbDpOf/RMznWu4ydVmERA6Z9ouNQKm
 cNIPaQ94Xb9GB7hxFbExBsCK3c+HNL2VGLgLdLr0h7CtzyqPIH+Rx9zmif4CrrsDJBGfPXCrmT
 57hWZvvd6JeKzYzLXR4qKyhN43PerDVeIsrdmUdVdvD8YO7nuUao1boOldq/6bjfSymtxGPkTa
 uuTq0zD35s/KSnEKMmun9Z/UZp6DIDkLzkCqZJ6utxT3n4uGKt8NhZCx3FyiI3O6dTLIoX5Z+z
 +wE=
X-IronPort-AV: E=Sophos;i="5.69,347,1571673600"; 
   d="scan'208";a="233619130"
Received: from mail-co1nam11lp2170.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.170])
  by ob1.hgst.iphmx.com with ESMTP; 23 Dec 2019 19:36:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W2CHpInW3wJTG3W7lQHKXmjUz6x63WcELINhxxWgAEUtvYW4rWt99vgSHxQElMj02qMtuqsG9+1rX+iEytrtOOe8MJ9Magob5Lx3F8OrXUeUYH/jZNFXcglwafx6nu6VKMjk3s+25bV6c2sG22plJK7VjV79oDxsh1McaZIMHrimyNxPhYELb+FX8gPN6CADCc1yEUduomFDdEStdRXSE3w12dCLs+zE5fT225710/f517/pi3NGRYgwkFstnZ0O8fMkbYyDxr7YIpeOKMhiAiIBoXy98vpRvEyIEn2nBpSn3jMw10E1aB34VMhkFnGA9hQJMgDFExFpi9qSGP0hZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E5ruaWnZN/tvNRK/7N7XFY8cb5gmYhsR3Az0TeBhA60=;
 b=O0Br27SAI6mkF9W1GexOSGWzxyWGPtl1PXqPZ1ZzEPQb0YFaaDZ+AxXvURVnovR92PYgU1sE/aIv4eWeo3sH1tMy+pyilp9cuuPWLhSv7kRcSGgNaObiOtu1ZPgCprIrO7QHwaa5HiLgCiFZHLeyRjH/aPpwK823FJTGiLQZcCXWplcKO3fpldDeHMYRGJP1eOHkyZP0X+LjjrnKgLAbNAHfL/f+dR/7h9gjHG1qROJq5Rcp1F9AZiEjzqnzNXkzt9i5Vd+zYcUSDYvDjQrZzUsbxEohM4QrnqeYste75VXAVv8D9+sS/GJkswd5vyM6W2MiKXJzhUnsxwGATjh9Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E5ruaWnZN/tvNRK/7N7XFY8cb5gmYhsR3Az0TeBhA60=;
 b=uXwr/jmrJnl6P99ms+cVBXTzuc90OtzHhUz+DcvJlwFpcmWYHxyn50jB60dv7fZmUwOyMa4b/jqA9RugOFZp8SiMMMptQVYqmD1JmZP8PKq1tfXBFYT9bTjkgp0O0WpniEgTCactk4t7DZ+MXbPVDfLjoaSVUEGmivaUbDqWyY8=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB7072.namprd04.prod.outlook.com (10.186.146.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.15; Mon, 23 Dec 2019 11:36:53 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89%7]) with mapi id 15.20.2559.017; Mon, 23 Dec 2019
 11:36:53 +0000
Received: from wdc.com (106.51.20.238) by MA1PR01CA0077.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::17) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Mon, 23 Dec 2019 11:36:47 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>
CC:     Alexander Graf <graf@amazon.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anup Patel <Anup.Patel@wdc.com>
Subject: [PATCH v10 12/19] RISC-V: KVM: Implement stage2 page table
 programming
Thread-Topic: [PATCH v10 12/19] RISC-V: KVM: Implement stage2 page table
 programming
Thread-Index: AQHVuYVFV2tMJmLLtkS1/KKBt2PXLg==
Date:   Mon, 23 Dec 2019 11:36:53 +0000
Message-ID: <20191223113443.68969-13-anup.patel@wdc.com>
References: <20191223113443.68969-1-anup.patel@wdc.com>
In-Reply-To: <20191223113443.68969-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0077.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::17)
 To MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [106.51.20.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 95eeba4a-334a-445c-d4b3-08d7879c67ff
x-ms-traffictypediagnostic: MN2PR04MB7072:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB70726BC2301A64DDF84768158D2E0@MN2PR04MB7072.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0260457E99
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(366004)(376002)(396003)(346002)(39860400002)(199004)(189003)(8886007)(478600001)(52116002)(316002)(16526019)(2906002)(8936002)(1076003)(7696005)(36756003)(66946007)(66476007)(86362001)(66446008)(26005)(64756008)(66556008)(4326008)(5660300002)(8676002)(186003)(7416002)(81156014)(2616005)(956004)(71200400001)(55016002)(44832011)(55236004)(81166006)(1006002)(54906003)(30864003)(110136005)(6666004)(32040200004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB7072;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 753gNHNJijoKBv7s7oulU6VXmN7Vs3vsdybdndBHRf1i1B4Bxz6/8OEl4ss2CEA58EzJ9JGNLYxLBNSYlibt3JuM3TyeZpMJOlQkHsexqwBnvcj4lzRYA8tELGBv9BFnovDIg2kGwHM8iqTVMNzMeilPuyj8raRCMUa2bdTi4MDk9vTmeqI+7x3PY9GAQWDRUAAkfILqWDpYlsqB5NUkI2tILKM8WLQJNvGujVMd0PM/pG07OtUNTSWQJIVV3hxQ703LMNdU4uHcB3N1jt8i0zeBeRpj0HbkCK/18kHrOmAcUOyBV8TiUipoq2D0AtHo0m9aajCPlN2bUl7CunGVsnK0WQJ6tw0gyEbWpMzursY+rx809Dipsrb/EC7IXzfV5FVIv8K38VjvGVs3s7tcZCJCVcguMI9Ax2Fh/RUjXTZZhUINVQIjNY3+pEC9zS6Pj7Az//siIkz6v08FuJT2q7tzYOAHe6dImvvXJA+V902iARGNiTh9EmAgBcwh1hBn
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95eeba4a-334a-445c-d4b3-08d7879c67ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2019 11:36:53.0939
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cm99c6oNV2U85YWgJrUYnaUh7KYycV7HIRzDg6ttgQQ1oIVLQw7dsU3KS/mroPxZ3x8ZdySKra3sLPHtThTpwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7072
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch implements all required functions for programming
the stage2 page table for each Guest/VM.

At high-level, the flow of stage2 related functions is similar
from KVM ARM/ARM64 implementation but the stage2 page table
format is quite different for KVM RISC-V.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/riscv/include/asm/kvm_host.h     |  10 +
 arch/riscv/include/asm/pgtable-bits.h |   1 +
 arch/riscv/kvm/mmu.c                  | 565 +++++++++++++++++++++++++-
 3 files changed, 566 insertions(+), 10 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm=
_host.h
index 35a291493f05..dd1acb011fff 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -73,6 +73,13 @@ struct kvm_mmio_decode {
 	int return_handled;
 };
=20
+#define KVM_MMU_PAGE_CACHE_NR_OBJS	32
+
+struct kvm_mmu_page_cache {
+	int nobjs;
+	void *objects[KVM_MMU_PAGE_CACHE_NR_OBJS];
+};
+
 struct kvm_cpu_context {
 	unsigned long zero;
 	unsigned long ra;
@@ -164,6 +171,9 @@ struct kvm_vcpu_arch {
 	/* MMIO instruction details */
 	struct kvm_mmio_decode mmio_decode;
=20
+	/* Cache pages needed to program page tables with spinlock held */
+	struct kvm_mmu_page_cache mmu_page_cache;
+
 	/* VCPU power-off state */
 	bool power_off;
=20
diff --git a/arch/riscv/include/asm/pgtable-bits.h b/arch/riscv/include/asm=
/pgtable-bits.h
index bbaeb5d35842..be49d62fcc2b 100644
--- a/arch/riscv/include/asm/pgtable-bits.h
+++ b/arch/riscv/include/asm/pgtable-bits.h
@@ -26,6 +26,7 @@
=20
 #define _PAGE_SPECIAL   _PAGE_SOFT
 #define _PAGE_TABLE     _PAGE_PRESENT
+#define _PAGE_LEAF      (_PAGE_READ | _PAGE_WRITE | _PAGE_EXEC)
=20
 /*
  * _PAGE_PROT_NONE is set on not-present pages (and ignored by the hardwar=
e) to
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 2b965f9aac07..f491c6aa4502 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -17,6 +17,357 @@
 #include <linux/sched/signal.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
+#include <asm/sbi.h>
+
+#ifdef CONFIG_64BIT
+#define stage2_have_pmd		true
+#define stage2_gpa_size		((phys_addr_t)(1ULL << 39))
+#define stage2_pgd_levels	3
+#define stage2_index_bits	9
+#else
+#define stage2_have_pmd		false
+#define stage2_gpa_size		((phys_addr_t)(1ULL << 32))
+#define stage2_pgd_levels	2
+#define stage2_index_bits	10
+#endif
+
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
+static int stage2_cache_topup(struct kvm_mmu_page_cache *pcache,
+			      int min, int max)
+{
+	void *page;
+
+	BUG_ON(max > KVM_MMU_PAGE_CACHE_NR_OBJS);
+	if (pcache->nobjs >=3D min)
+		return 0;
+	while (pcache->nobjs < max) {
+		page =3D (void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+		if (!page)
+			return -ENOMEM;
+		pcache->objects[pcache->nobjs++] =3D page;
+	}
+
+	return 0;
+}
+
+static void stage2_cache_flush(struct kvm_mmu_page_cache *pcache)
+{
+	while (pcache && pcache->nobjs)
+		free_page((unsigned long)pcache->objects[--pcache->nobjs]);
+}
+
+static void *stage2_cache_alloc(struct kvm_mmu_page_cache *pcache)
+{
+	void *p;
+
+	if (!pcache)
+		return NULL;
+
+	BUG_ON(!pcache->nobjs);
+	p =3D pcache->objects[--pcache->nobjs];
+
+	return p;
+}
+
+static bool stage2_get_leaf_entry(struct kvm *kvm, gpa_t addr,
+				  pte_t **ptepp, u32 *ptep_level)
+{
+	pte_t *ptep;
+	u32 current_level =3D stage2_pgd_levels - 1;
+
+	*ptep_level =3D current_level;
+	ptep =3D (pte_t *)kvm->arch.pgd;
+	ptep =3D &ptep[stage2_pte_index(addr, current_level)];
+	while (ptep && pte_val(*ptep)) {
+		if (pte_val(*ptep) & _PAGE_LEAF) {
+			*ptep_level =3D current_level;
+			*ptepp =3D ptep;
+			return true;
+		}
+
+		if (current_level) {
+			current_level--;
+			*ptep_level =3D current_level;
+			ptep =3D (pte_t *)stage2_pte_page_vaddr(*ptep);
+			ptep =3D &ptep[stage2_pte_index(addr, current_level)];
+		} else {
+			ptep =3D NULL;
+		}
+	}
+
+	return false;
+}
+
+static void stage2_remote_tlb_flush(struct kvm *kvm, u32 level, gpa_t addr=
)
+{
+	struct cpumask hmask;
+	unsigned long size =3D PAGE_SIZE;
+	struct kvm_vmid *vmid =3D &kvm->arch.vmid;
+
+	if (stage2_level_to_page_size(level, &size))
+		return;
+	addr &=3D ~(size - 1);
+
+	/*
+	 * TODO: Instead of cpu_online_mask, we should only target CPUs
+	 * where the Guest/VM is running.
+	 */
+	preempt_disable();
+	riscv_cpuid_to_hartid_mask(cpu_online_mask, &hmask);
+	sbi_remote_hfence_gvma_vmid(cpumask_bits(&hmask), addr, size,
+				    READ_ONCE(vmid->vmid));
+	preempt_enable();
+}
+
+static int stage2_set_pte(struct kvm *kvm, u32 level,
+			   struct kvm_mmu_page_cache *pcache,
+			   gpa_t addr, const pte_t *new_pte)
+{
+	u32 current_level =3D stage2_pgd_levels - 1;
+	pte_t *next_ptep =3D (pte_t *)kvm->arch.pgd;
+	pte_t *ptep =3D &next_ptep[stage2_pte_index(addr, current_level)];
+
+	if (current_level < level)
+		return -EINVAL;
+
+	while (current_level !=3D level) {
+		if (pte_val(*ptep) & _PAGE_LEAF)
+			return -EEXIST;
+
+		if (!pte_val(*ptep)) {
+			next_ptep =3D stage2_cache_alloc(pcache);
+			if (!next_ptep)
+				return -ENOMEM;
+			*ptep =3D pfn_pte(PFN_DOWN(__pa(next_ptep)),
+					__pgprot(_PAGE_TABLE));
+		} else {
+			if (pte_val(*ptep) & _PAGE_LEAF)
+				return -EEXIST;
+			next_ptep =3D (pte_t *)stage2_pte_page_vaddr(*ptep);
+		}
+
+		current_level--;
+		ptep =3D &next_ptep[stage2_pte_index(addr, current_level)];
+	}
+
+	*ptep =3D *new_pte;
+	if (pte_val(*ptep) & _PAGE_LEAF)
+		stage2_remote_tlb_flush(kvm, current_level, addr);
+
+	return 0;
+}
+
+static int stage2_map_page(struct kvm *kvm,
+			   struct kvm_mmu_page_cache *pcache,
+			   gpa_t gpa, phys_addr_t hpa,
+			   unsigned long page_size, pgprot_t prot)
+{
+	int ret;
+	u32 level =3D 0;
+	pte_t new_pte;
+
+	ret =3D stage2_page_size_to_level(page_size, &level);
+	if (ret)
+		return ret;
+
+	new_pte =3D pfn_pte(PFN_DOWN(hpa), prot);
+	return stage2_set_pte(kvm, level, pcache, gpa, &new_pte);
+}
+
+enum stage2_op {
+	STAGE2_OP_NOP =3D 0,	/* Nothing */
+	STAGE2_OP_CLEAR,	/* Clear/Unmap */
+	STAGE2_OP_WP,		/* Write-protect */
+};
+
+static void stage2_op_pte(struct kvm *kvm, gpa_t addr,
+			  pte_t *ptep, u32 ptep_level, enum stage2_op op)
+{
+	int i, ret;
+	pte_t *next_ptep;
+	u32 next_ptep_level;
+	unsigned long next_page_size, page_size;
+
+	ret =3D stage2_level_to_page_size(ptep_level, &page_size);
+	if (ret)
+		return;
+
+	BUG_ON(addr & (page_size - 1));
+
+	if (!pte_val(*ptep))
+		return;
+
+	if (ptep_level && !(pte_val(*ptep) & _PAGE_LEAF)) {
+		next_ptep =3D (pte_t *)stage2_pte_page_vaddr(*ptep);
+		next_ptep_level =3D ptep_level - 1;
+		ret =3D stage2_level_to_page_size(next_ptep_level,
+						&next_page_size);
+		if (ret)
+			return;
+
+		if (op =3D=3D STAGE2_OP_CLEAR)
+			set_pte(ptep, __pte(0));
+		for (i =3D 0; i < PTRS_PER_PTE; i++)
+			stage2_op_pte(kvm, addr + i * next_page_size,
+					&next_ptep[i], next_ptep_level, op);
+		if (op =3D=3D STAGE2_OP_CLEAR)
+			put_page(virt_to_page(next_ptep));
+	} else {
+		if (op =3D=3D STAGE2_OP_CLEAR)
+			set_pte(ptep, __pte(0));
+		else if (op =3D=3D STAGE2_OP_WP)
+			set_pte(ptep, __pte(pte_val(*ptep) & ~_PAGE_WRITE));
+		stage2_remote_tlb_flush(kvm, ptep_level, addr);
+	}
+}
+
+static void stage2_unmap_range(struct kvm *kvm, gpa_t start, gpa_t size)
+{
+	int ret;
+	pte_t *ptep;
+	u32 ptep_level;
+	bool found_leaf;
+	unsigned long page_size;
+	gpa_t addr =3D start, end =3D start + size;
+
+	while (addr < end) {
+		found_leaf =3D stage2_get_leaf_entry(kvm, addr,
+						   &ptep, &ptep_level);
+		ret =3D stage2_level_to_page_size(ptep_level, &page_size);
+		if (ret)
+			break;
+
+		if (!found_leaf)
+			goto next;
+
+		if (!(addr & (page_size - 1)) && ((end - addr) >=3D page_size))
+			stage2_op_pte(kvm, addr, ptep,
+				      ptep_level, STAGE2_OP_CLEAR);
+
+next:
+		addr +=3D page_size;
+	}
+}
+
+static void stage2_wp_range(struct kvm *kvm, gpa_t start, gpa_t end)
+{
+	int ret;
+	pte_t *ptep;
+	u32 ptep_level;
+	bool found_leaf;
+	gpa_t addr =3D start;
+	unsigned long page_size;
+
+	while (addr < end) {
+		found_leaf =3D stage2_get_leaf_entry(kvm, addr,
+						   &ptep, &ptep_level);
+		ret =3D stage2_level_to_page_size(ptep_level, &page_size);
+		if (ret)
+			break;
+
+		if (!found_leaf)
+			goto next;
+
+		if (!(addr & (page_size - 1)) && ((end - addr) >=3D page_size))
+			stage2_op_pte(kvm, addr, ptep,
+				      ptep_level, STAGE2_OP_WP);
+
+next:
+		addr +=3D page_size;
+	}
+}
+
+void stage2_wp_memory_region(struct kvm *kvm, int slot)
+{
+	struct kvm_memslots *slots =3D kvm_memslots(kvm);
+	struct kvm_memory_slot *memslot =3D id_to_memslot(slots, slot);
+	phys_addr_t start =3D memslot->base_gfn << PAGE_SHIFT;
+	phys_addr_t end =3D (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
+
+	spin_lock(&kvm->mmu_lock);
+	stage2_wp_range(kvm, start, end);
+	spin_unlock(&kvm->mmu_lock);
+	kvm_flush_remote_tlbs(kvm);
+}
+
+int stage2_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
+		   unsigned long size, bool writable)
+{
+	pte_t pte;
+	int ret =3D 0;
+	unsigned long pfn;
+	phys_addr_t addr, end;
+	struct kvm_mmu_page_cache pcache =3D { 0, };
+
+	end =3D (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
+	pfn =3D __phys_to_pfn(hpa);
+
+	for (addr =3D gpa; addr < end; addr +=3D PAGE_SIZE) {
+		pte =3D pfn_pte(pfn, PAGE_KERNEL);
+
+		if (!writable)
+			pte =3D pte_wrprotect(pte);
+
+		ret =3D stage2_cache_topup(&pcache,
+					 stage2_pgd_levels,
+					 KVM_MMU_PAGE_CACHE_NR_OBJS);
+		if (ret)
+			goto out;
+
+		spin_lock(&kvm->mmu_lock);
+		ret =3D stage2_set_pte(kvm, 0, &pcache, addr, &pte);
+		spin_unlock(&kvm->mmu_lock);
+		if (ret)
+			goto out;
+
+		pfn++;
+	}
+
+out:
+	stage2_cache_flush(&pcache);
+	return ret;
+
+}
=20
 void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
 			   struct kvm_memory_slot *dont)
@@ -35,7 +386,7 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
=20
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
-	/* TODO: */
+	kvm_riscv_stage2_free_pgd(kvm);
 }
=20
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
@@ -49,7 +400,13 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
 {
-	/* TODO: */
+	/*
+	 * At this point memslot has been committed and there is an
+	 * allocated dirty_bitmap[], dirty pages will be be tracked while the
+	 * memory slot is write protected.
+	 */
+	if (change !=3D KVM_MR_DELETE && mem->flags & KVM_MEM_LOG_DIRTY_PAGES)
+		stage2_wp_memory_region(kvm, mem->slot);
 }
=20
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
@@ -57,34 +414,222 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				const struct kvm_userspace_memory_region *mem,
 				enum kvm_mr_change change)
 {
-	/* TODO: */
-	return 0;
+	hva_t hva =3D mem->userspace_addr;
+	hva_t reg_end =3D hva + mem->memory_size;
+	bool writable =3D !(mem->flags & KVM_MEM_READONLY);
+	int ret =3D 0;
+
+	if (change !=3D KVM_MR_CREATE && change !=3D KVM_MR_MOVE &&
+			change !=3D KVM_MR_FLAGS_ONLY)
+		return 0;
+
+	/*
+	 * Prevent userspace from creating a memory region outside of the GPA
+	 * space addressable by the KVM guest GPA space.
+	 */
+	if ((memslot->base_gfn + memslot->npages) >=3D
+	    (stage2_gpa_size >> PAGE_SHIFT))
+		return -EFAULT;
+
+	down_read(&current->mm->mmap_sem);
+
+	/*
+	 * A memory region could potentially cover multiple VMAs, and
+	 * any holes between them, so iterate over all of them to find
+	 * out if we can map any of them right now.
+	 *
+	 *     +--------------------------------------------+
+	 * +---------------+----------------+   +----------------+
+	 * |   : VMA 1     |      VMA 2     |   |    VMA 3  :    |
+	 * +---------------+----------------+   +----------------+
+	 *     |               memory region                |
+	 *     +--------------------------------------------+
+	 */
+	do {
+		struct vm_area_struct *vma =3D find_vma(current->mm, hva);
+		hva_t vm_start, vm_end;
+
+		if (!vma || vma->vm_start >=3D reg_end)
+			break;
+
+		/*
+		 * Mapping a read-only VMA is only allowed if the
+		 * memory region is configured as read-only.
+		 */
+		if (writable && !(vma->vm_flags & VM_WRITE)) {
+			ret =3D -EPERM;
+			break;
+		}
+
+		/* Take the intersection of this VMA with the memory region */
+		vm_start =3D max(hva, vma->vm_start);
+		vm_end =3D min(reg_end, vma->vm_end);
+
+		if (vma->vm_flags & VM_PFNMAP) {
+			gpa_t gpa =3D mem->guest_phys_addr +
+				    (vm_start - mem->userspace_addr);
+			phys_addr_t pa;
+
+			pa =3D (phys_addr_t)vma->vm_pgoff << PAGE_SHIFT;
+			pa +=3D vm_start - vma->vm_start;
+
+			/* IO region dirty page logging not allowed */
+			if (memslot->flags & KVM_MEM_LOG_DIRTY_PAGES) {
+				ret =3D -EINVAL;
+				goto out;
+			}
+
+			ret =3D stage2_ioremap(kvm, gpa, pa,
+					     vm_end - vm_start, writable);
+			if (ret)
+				break;
+		}
+		hva =3D vm_end;
+	} while (hva < reg_end);
+
+	if (change =3D=3D KVM_MR_FLAGS_ONLY)
+		goto out;
+
+	spin_lock(&kvm->mmu_lock);
+	if (ret)
+		stage2_unmap_range(kvm, mem->guest_phys_addr,
+				   mem->memory_size);
+	spin_unlock(&kvm->mmu_lock);
+
+out:
+	up_read(&current->mm->mmap_sem);
+	return ret;
 }
=20
 int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long h=
va,
 			 bool is_write)
 {
-	/* TODO: */
-	return 0;
+	int ret;
+	short lsb;
+	kvm_pfn_t hfn;
+	bool writeable;
+	gfn_t gfn =3D gpa >> PAGE_SHIFT;
+	struct vm_area_struct *vma;
+	struct kvm *kvm =3D vcpu->kvm;
+	struct kvm_mmu_page_cache *pcache =3D &vcpu->arch.mmu_page_cache;
+	unsigned long vma_pagesize;
+
+	down_read(&current->mm->mmap_sem);
+
+	vma =3D find_vma_intersection(current->mm, hva, hva + 1);
+	if (unlikely(!vma)) {
+		kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
+		up_read(&current->mm->mmap_sem);
+		return -EFAULT;
+	}
+
+	vma_pagesize =3D vma_kernel_pagesize(vma);
+
+	if (vma_pagesize =3D=3D PMD_SIZE || vma_pagesize =3D=3D PGDIR_SIZE)
+		gfn =3D (gpa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
+
+	up_read(&current->mm->mmap_sem);
+
+	if (vma_pagesize !=3D PGDIR_SIZE &&
+	    vma_pagesize !=3D PMD_SIZE &&
+	    vma_pagesize !=3D PAGE_SIZE) {
+		kvm_err("Invalid VMA page size 0x%lx\n", vma_pagesize);
+		return -EFAULT;
+	}
+
+	/* We need minimum second+third level pages */
+	ret =3D stage2_cache_topup(pcache, stage2_pgd_levels,
+				 KVM_MMU_PAGE_CACHE_NR_OBJS);
+	if (ret) {
+		kvm_err("Failed to topup stage2 cache\n");
+		return ret;
+	}
+
+	hfn =3D gfn_to_pfn_prot(kvm, gfn, is_write, &writeable);
+	if (hfn =3D=3D KVM_PFN_ERR_HWPOISON) {
+		if (is_vm_hugetlb_page(vma))
+			lsb =3D huge_page_shift(hstate_vma(vma));
+		else
+			lsb =3D PAGE_SHIFT;
+
+		send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva,
+				lsb, current);
+		return 0;
+	}
+	if (is_error_noslot_pfn(hfn))
+		return -EFAULT;
+	if (!writeable && is_write)
+		return -EPERM;
+
+	spin_lock(&kvm->mmu_lock);
+
+	if (writeable) {
+		kvm_set_pfn_dirty(hfn);
+		ret =3D stage2_map_page(kvm, pcache, gpa, hfn << PAGE_SHIFT,
+				      vma_pagesize, PAGE_WRITE_EXEC);
+	} else {
+		ret =3D stage2_map_page(kvm, pcache, gpa, hfn << PAGE_SHIFT,
+				      vma_pagesize, PAGE_READ_EXEC);
+	}
+
+	if (ret)
+		kvm_err("Failed to map in stage2\n");
+
+	spin_unlock(&kvm->mmu_lock);
+	kvm_set_pfn_accessed(hfn);
+	kvm_release_pfn_clean(hfn);
+	return ret;
 }
=20
 void kvm_riscv_stage2_flush_cache(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
+	stage2_cache_flush(&vcpu->arch.mmu_page_cache);
 }
=20
 int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm)
 {
-	/* TODO: */
+	if (kvm->arch.pgd !=3D NULL) {
+		kvm_err("kvm_arch already initialized?\n");
+		return -EINVAL;
+	}
+
+	kvm->arch.pgd =3D alloc_pages_exact(PAGE_SIZE, GFP_KERNEL | __GFP_ZERO);
+	if (!kvm->arch.pgd)
+		return -ENOMEM;
+	kvm->arch.pgd_phys =3D virt_to_phys(kvm->arch.pgd);
+
 	return 0;
 }
=20
 void kvm_riscv_stage2_free_pgd(struct kvm *kvm)
 {
-	/* TODO: */
+	void *pgd =3D NULL;
+
+	spin_lock(&kvm->mmu_lock);
+	if (kvm->arch.pgd) {
+		stage2_unmap_range(kvm, 0UL, stage2_gpa_size);
+		pgd =3D READ_ONCE(kvm->arch.pgd);
+		kvm->arch.pgd =3D NULL;
+		kvm->arch.pgd_phys =3D 0;
+	}
+	spin_unlock(&kvm->mmu_lock);
+
+	/* Free the HW pgd, one page at a time */
+	if (pgd)
+		free_pages_exact(pgd, PAGE_SIZE);
 }
=20
 void kvm_riscv_stage2_update_hgatp(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
+	unsigned long hgatp =3D HGATP_MODE;
+	struct kvm_arch *k =3D &vcpu->kvm->arch;
+
+	hgatp |=3D (READ_ONCE(k->vmid.vmid) << HGATP_VMID_SHIFT) &
+		 HGATP_VMID_MASK;
+	hgatp |=3D (k->pgd_phys >> PAGE_SHIFT) & HGATP_PPN;
+
+	csr_write(CSR_HGATP, hgatp);
+
+	if (!kvm_riscv_stage2_vmid_bits())
+		__kvm_riscv_hfence_gvma_all();
 }
--=20
2.17.1

