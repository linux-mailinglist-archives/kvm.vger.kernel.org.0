Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F090A8CA5
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 21:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732554AbfIDQPk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 12:15:40 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:14034 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731878AbfIDQPj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 12:15:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567613738; x=1599149738;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HE4NIa5q81+n2zefgcHY2UWHjfp2IahUMYDi9BSrlmI=;
  b=i0tOk5WC2vzeITHAz/ZJNOQYwJx4ZDYheD+et4nKFqJQyO/egDG1bwwV
   c8Bx1JKxPPBN9d9KaMCBfjwA4Fg4+uzZglSRnniXK04nqA6YlVd0eNign
   kDh/p1lbwdAa/Xx2adsK7ivvRBRO2VFVTpCBOB8vm9K+gzpVUt2Ekvtqx
   imExAVrvq2MTX7ah0Pv+o7C1Y+XMySiPaXJq/leODMfTqZyVKypWmpscA
   mfEgJmHGrxAQYzxYRRRDtnW3JBqA3JH4x8PUdmJFRl2aLzd+osXSbMuN7
   4/hhzh4Rf8xp6s+hgPUQuTWhdjCafF+Hy9EQXqa5t3DfbgugGUats0opk
   Q==;
IronPort-SDR: RvYdIAIsSbxO+IpcscO+85d/rb8tmqU8YZs68HLqIqWqfjWUjp5YqK3w4pSwXwEZpPr5dgBjlc
 JkwCq+gqtaCTPyNwUwVpTuOEyN8ajbuR30GsINB3sS6gmM7k4PS8OXtbWCvLfwrLcUBiqX0vuE
 Qr4TwxHGzP+cR5C+bKt1USAnM5nSZC3FgPaoZCK7mIy2suLIM3pwzYxAYECHXbiK5Wt9Pl2IMQ
 fyPXmHH4Wc+ekXL2koRKHBsIUBgaKuIPP4Ow18aACDjJpOGikMCG+9BrPDLgLQKx3G3ZXPtbfa
 LyA=
X-IronPort-AV: E=Sophos;i="5.64,467,1559491200"; 
   d="scan'208";a="224155191"
Received: from mail-sn1nam01lp2056.outbound.protection.outlook.com (HELO NAM01-SN1-obe.outbound.protection.outlook.com) ([104.47.32.56])
  by ob1.hgst.iphmx.com with ESMTP; 05 Sep 2019 00:15:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=agmu+GxOfitnRBuIc/E0kpEJv1wE5zdM8XfQERiKPQ5mjz8FebS2l9UpvqG2SXI9mgaEWnCQYITtR4O4NZLpPUlduyNpgVskWl8I/wRn0wxKKGi1TDyWfdgedKM/XdAI6xtKDiID6nGbPeQUUDB2yFAl4QOr8vBQib+RIVjN7zo/yLagLCT29WpdpEWwAcd4WiVJvko5aitCiynyFMPEd913cSi/OA3BsRZHcYjuni7FNOsxi3BgCrYkhW/N7HKxeaDVWLtEKjSDn7TgOQOIJUkVLOuUWjUi4F3ZnhKjpySI+2xGhvnX5+63TUQsHyXw6LSOVanJ7nmLtRXqwfgkwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yi7H1KDkC7nwVfxez9pOkvoFQd2sNUXT8iiiRUKorqQ=;
 b=GJ2MH0L+G60nfP47kYHJb8pg2gLcv7SIASRP0HxEcu+mJAxIe8vDLVbHGhbUYWjloUTdDvqzlHaARnqMNG44FmdIkFyUlA+jsQtSyjyCKhMmHIcAVBFiS4Q5xUaW7EDv+IDhwj7gzecGFOed/SnU763cPhZgyBGg9Fx1g086tPZ1NdVz0Vm2swOXgA6qc+7iCgeRBnqPQleFiM8XIXVRlamVVuVhAc3fejBZDeBTsm2TadAl5crsVedpsVt4kB8yZ4Cg8x513T+9TS1niRiD02fZbeaS6w3u+u4B4A5KBBvzM49weKVMo0KCcIJuRA08oDPshV8Tt7atW9kY8j8Urw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yi7H1KDkC7nwVfxez9pOkvoFQd2sNUXT8iiiRUKorqQ=;
 b=qC9PhSYu1vLJmYv8R9sd2vzIqYdAnPNIE3XkSYwE6jlOLcbMWzkjh3aPeXW5A4CjsLMdanbX03rIa0GItNT5OgL471xZ0EtvsMPwJMC1FdgCNknRSmHDQQvqCLGyE13yaOAprM7m+acdTVvbp72+g9gmXxC0/5CNOOvoK8ooz40=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB5504.namprd04.prod.outlook.com (20.178.247.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Wed, 4 Sep 2019 16:15:35 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::e1a5:8de2:c3b1:3fb0]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::e1a5:8de2:c3b1:3fb0%7]) with mapi id 15.20.2220.022; Wed, 4 Sep 2019
 16:15:35 +0000
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
Subject: [PATCH v7 14/21] RISC-V: KVM: Implement MMU notifiers
Thread-Topic: [PATCH v7 14/21] RISC-V: KVM: Implement MMU notifiers
Thread-Index: AQHVYzv7wtTrPNTnskuAtY4fmsl7tg==
Date:   Wed, 4 Sep 2019 16:15:35 +0000
Message-ID: <20190904161245.111924-16-anup.patel@wdc.com>
References: <20190904161245.111924-1-anup.patel@wdc.com>
In-Reply-To: <20190904161245.111924-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0084.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::24)
 To MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [49.207.53.222]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9467c15f-4bd7-4fcc-45ae-08d731531e25
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB5504;
x-ms-traffictypediagnostic: MN2PR04MB5504:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB5504C12350F371BBB2F5ADE48DB80@MN2PR04MB5504.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:785;
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(136003)(396003)(346002)(366004)(39860400002)(199004)(189003)(66556008)(66446008)(7416002)(7736002)(8676002)(478600001)(25786009)(386003)(66946007)(99286004)(256004)(14444005)(50226002)(14454004)(66476007)(64756008)(6506007)(6512007)(102836004)(6436002)(8936002)(54906003)(6116002)(3846002)(486006)(26005)(55236004)(86362001)(1076003)(53936002)(476003)(316002)(71200400001)(71190400001)(81156014)(76176011)(52116002)(305945005)(5660300002)(6486002)(36756003)(186003)(11346002)(2616005)(66066001)(44832011)(4326008)(2906002)(446003)(81166006)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5504;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MCu9wdr3GiZOB2A1bCo2ikze4ZJGAZcwHf1YHCoX/ey/OKpOJVNkURbGZkzuafphrQvzlS25dUqmvT7yb/XrGSqS1zlEOTaO2xEEhaQtxSw+rLrG56UKSYFIUUH1HzsLBG/Fdv/18f02GBgiZYomzh0CgpwZbXiwXXVvi+suGoLBrOPTIynRwoIvwjXRiI11QfKRDPCzq4jt+sw73qSOmayyspdFPOsFddTdjjE0mTLgmgLyPPXc2w4FDYN+5a0wIBX7JgFWMmhua/nKlIsesB/1mnBSl6H/nCCSCw3f0DnBVXM9wGmjf9QoH+OML/xW8RvLZ2Ag5kJFVi44gu7/o1VOLxMxs8u06MriIujiKB+YvdlPaTZa439nYl6bcpKOmgIBDJ4nyKbGeQjqFxQ3NXFB2KUZpRS8W0RQldSBTno=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9467c15f-4bd7-4fcc-45ae-08d731531e25
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2019 16:15:35.5439
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5FMFwxQqjVkHBwwGnhorHLm9t7BoyPlve3XYOA4f6D6xmaRjtGAIBO1EzN24t/FgN2yIKsRld9isY7lIhScBUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5504
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch implements MMU notifiers for KVM RISC-V so that Guest
physical address space is in-sync with Host physical address space.

This will allow swapping, page migration, etc to work transparently
with KVM RISC-V.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 arch/riscv/include/asm/kvm_host.h |   7 ++
 arch/riscv/kvm/Kconfig            |   1 +
 arch/riscv/kvm/mmu.c              | 200 +++++++++++++++++++++++++++++-
 arch/riscv/kvm/vm.c               |   1 +
 4 files changed, 208 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm=
_host.h
index bc27f664b443..79ceb2aa8ae6 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -193,6 +193,13 @@ static inline void kvm_arch_vcpu_block_finish(struct k=
vm_vcpu *vcpu) {}
 int kvm_riscv_setup_vsip(void);
 void kvm_riscv_cleanup_vsip(void);
=20
+#define KVM_ARCH_WANT_MMU_NOTIFIER
+int kvm_unmap_hva_range(struct kvm *kvm,
+			unsigned long start, unsigned long end);
+int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
+int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
+int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
+
 void __kvm_riscv_hfence_gvma_vmid_gpa(unsigned long vmid,
 				      unsigned long gpa);
 void __kvm_riscv_hfence_gvma_vmid(unsigned long vmid);
diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
index 35fd30d0e432..002e14ee37f6 100644
--- a/arch/riscv/kvm/Kconfig
+++ b/arch/riscv/kvm/Kconfig
@@ -20,6 +20,7 @@ if VIRTUALIZATION
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
 	depends on OF
+	select MMU_NOTIFIER
 	select PREEMPT_NOTIFIERS
 	select ANON_INODES
 	select KVM_MMIO
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 590669290139..d8a692d3e640 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -67,6 +67,66 @@ static void *stage2_cache_alloc(struct kvm_mmu_page_cach=
e *pcache)
 	return p;
 }
=20
+static int stage2_pgdp_test_and_clear_young(pgd_t *pgd)
+{
+	return ptep_test_and_clear_young(NULL, 0, (pte_t *)pgd);
+}
+
+static int stage2_pmdp_test_and_clear_young(pmd_t *pmd)
+{
+	return ptep_test_and_clear_young(NULL, 0, (pte_t *)pmd);
+}
+
+static int stage2_ptep_test_and_clear_young(pte_t *pte)
+{
+	return ptep_test_and_clear_young(NULL, 0, pte);
+}
+
+static bool stage2_get_leaf_entry(struct kvm *kvm, gpa_t addr,
+				  pgd_t **pgdpp, pmd_t **pmdpp, pte_t **ptepp)
+{
+	pgd_t *pgdp;
+	pmd_t *pmdp;
+	pte_t *ptep;
+
+	*pgdpp =3D NULL;
+	*pmdpp =3D NULL;
+	*ptepp =3D NULL;
+
+	pgdp =3D &kvm->arch.pgd[pgd_index(addr)];
+	if (!pgd_val(*pgdp))
+		return false;
+	if (pgd_val(*pgdp) & _PAGE_LEAF) {
+		*pgdpp =3D pgdp;
+		return true;
+	}
+
+	if (stage2_have_pmd) {
+		pmdp =3D (void *)pgd_page_vaddr(*pgdp);
+		pmdp =3D &pmdp[pmd_index(addr)];
+		if (!pmd_present(*pmdp))
+			return false;
+		if (pmd_val(*pmdp) & _PAGE_LEAF) {
+			*pmdpp =3D pmdp;
+			return true;
+		}
+
+		ptep =3D (void *)pmd_page_vaddr(*pmdp);
+	} else {
+		ptep =3D (void *)pgd_page_vaddr(*pgdp);
+	}
+
+	ptep =3D &ptep[pte_index(addr)];
+	if (!pte_present(*ptep))
+		return false;
+	if (pte_val(*ptep) & _PAGE_LEAF) {
+		*ptepp =3D ptep;
+		return true;
+	}
+
+	return false;
+}
+
 struct local_guest_tlb_info {
 	struct kvm_vmid *vmid;
 	gpa_t addr;
@@ -450,6 +510,38 @@ int stage2_ioremap(struct kvm *kvm, gpa_t gpa, phys_ad=
dr_t hpa,
=20
 }
=20
+static int handle_hva_to_gpa(struct kvm *kvm,
+			     unsigned long start,
+			     unsigned long end,
+			     int (*handler)(struct kvm *kvm,
+					    gpa_t gpa, u64 size,
+					    void *data),
+			     void *data)
+{
+	struct kvm_memslots *slots;
+	struct kvm_memory_slot *memslot;
+	int ret =3D 0;
+
+	slots =3D kvm_memslots(kvm);
+
+	/* we only care about the pages that the guest sees */
+	kvm_for_each_memslot(memslot, slots) {
+		unsigned long hva_start, hva_end;
+		gfn_t gpa;
+
+		hva_start =3D max(start, memslot->userspace_addr);
+		hva_end =3D min(end, memslot->userspace_addr +
+					(memslot->npages << PAGE_SHIFT));
+		if (hva_start >=3D hva_end)
+			continue;
+
+		gpa =3D hva_to_gfn_memslot(hva_start, memslot) << PAGE_SHIFT;
+		ret |=3D handler(kvm, gpa, (u64)(hva_end - hva_start), data);
+	}
+
+	return ret;
+}
+
 void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
 			   struct kvm_memory_slot *dont)
 {
@@ -582,6 +674,106 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	return ret;
 }
=20
+static int kvm_unmap_hva_handler(struct kvm *kvm,
+				 gpa_t gpa, u64 size, void *data)
+{
+	stage2_unmap_range(kvm, gpa, size);
+	return 0;
+}
+
+int kvm_unmap_hva_range(struct kvm *kvm,
+			unsigned long start, unsigned long end)
+{
+	if (!kvm->arch.pgd)
+		return 0;
+
+	handle_hva_to_gpa(kvm, start, end,
+			  &kvm_unmap_hva_handler, NULL);
+	return 0;
+}
+
+static int kvm_set_spte_handler(struct kvm *kvm,
+				gpa_t gpa, u64 size, void *data)
+{
+	pte_t *pte =3D (pte_t *)data;
+
+	WARN_ON(size !=3D PAGE_SIZE);
+	stage2_set_pte(kvm, NULL, gpa, pte);
+
+	return 0;
+}
+
+int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
+{
+	unsigned long end =3D hva + PAGE_SIZE;
+	kvm_pfn_t pfn =3D pte_pfn(pte);
+	pte_t stage2_pte;
+
+	if (!kvm->arch.pgd)
+		return 0;
+
+	stage2_pte =3D pfn_pte(pfn, PAGE_WRITE_EXEC);
+	handle_hva_to_gpa(kvm, hva, end,
+			  &kvm_set_spte_handler, &stage2_pte);
+
+	return 0;
+}
+
+static int kvm_age_hva_handler(struct kvm *kvm,
+				gpa_t gpa, u64 size, void *data)
+{
+	pgd_t *pgd;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	WARN_ON(size !=3D PAGE_SIZE && size !=3D PMD_SIZE && size !=3D PGDIR_SIZE=
);
+	if (!stage2_get_leaf_entry(kvm, gpa, &pgd, &pmd, &pte))
+		return 0;
+
+	if (pgd)
+		return stage2_pgdp_test_and_clear_young(pgd);
+	else if (pmd)
+		return stage2_pmdp_test_and_clear_young(pmd);
+	else
+		return stage2_ptep_test_and_clear_young(pte);
+}
+
+int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
+{
+	if (!kvm->arch.pgd)
+		return 0;
+
+	return handle_hva_to_gpa(kvm, start, end, kvm_age_hva_handler, NULL);
+}
+
+static int kvm_test_age_hva_handler(struct kvm *kvm,
+				    gpa_t gpa, u64 size, void *data)
+{
+	pgd_t *pgd;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	WARN_ON(size !=3D PAGE_SIZE && size !=3D PMD_SIZE);
+	if (!stage2_get_leaf_entry(kvm, gpa, &pgd, &pmd, &pte))
+		return 0;
+
+	if (pgd)
+		return pte_young(*((pte_t *)pgd));
+	else if (pmd)
+		return pte_young(*((pte_t *)pmd));
+	else
+		return pte_young(*pte);
+}
+
+int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
+{
+	if (!kvm->arch.pgd)
+		return 0;
+
+	return handle_hva_to_gpa(kvm, hva, hva,
+				 kvm_test_age_hva_handler, NULL);
+}
+
 int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long h=
va,
 			 bool is_write)
 {
@@ -593,7 +785,7 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu, gpa_t g=
pa, unsigned long hva,
 	struct vm_area_struct *vma;
 	struct kvm *kvm =3D vcpu->kvm;
 	struct kvm_mmu_page_cache *pcache =3D &vcpu->arch.mmu_page_cache;
-	unsigned long vma_pagesize;
+	unsigned long vma_pagesize, mmu_seq;
=20
 	down_read(&current->mm->mmap_sem);
=20
@@ -623,6 +815,8 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu, gpa_t g=
pa, unsigned long hva,
 		return ret;
 	}
=20
+	mmu_seq =3D kvm->mmu_notifier_seq;
+
 	hfn =3D gfn_to_pfn_prot(kvm, gfn, is_write, &writeable);
 	if (hfn =3D=3D KVM_PFN_ERR_HWPOISON) {
 		if (is_vm_hugetlb_page(vma))
@@ -641,6 +835,9 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu, gpa_t g=
pa, unsigned long hva,
=20
 	spin_lock(&kvm->mmu_lock);
=20
+	if (mmu_notifier_retry(kvm, mmu_seq))
+		goto out_unlock;
+
 	if (writeable) {
 		kvm_set_pfn_dirty(hfn);
 		ret =3D stage2_map_page(kvm, pcache, gpa, hfn << PAGE_SHIFT,
@@ -653,6 +850,7 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu, gpa_t g=
pa, unsigned long hva,
 	if (ret)
 		kvm_err("Failed to map in stage2\n");
=20
+out_unlock:
 	spin_unlock(&kvm->mmu_lock);
 	kvm_set_pfn_accessed(hfn);
 	kvm_release_pfn_clean(hfn);
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index c5aab5478c38..fd84b4d914dc 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -54,6 +54,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ex=
t)
 	switch (ext) {
 	case KVM_CAP_DEVICE_CTRL:
 	case KVM_CAP_USER_MEMORY:
+	case KVM_CAP_SYNC_MMU:
 	case KVM_CAP_DESTROY_MEMORY_REGION_WORKS:
 	case KVM_CAP_ONE_REG:
 	case KVM_CAP_READONLY_MEM:
--=20
2.17.1

