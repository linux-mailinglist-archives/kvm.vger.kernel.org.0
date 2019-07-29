Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB0A278B2B
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2019 13:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387958AbfG2L5n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 07:57:43 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:29803 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387969AbfG2L5l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 07:57:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1564401460; x=1595937460;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2uj9RJOL/IUN81lh4o3H+8jvMRuhXSv/h40mQKac/yo=;
  b=eWq9LjQMz0hiFVeXs013WAfl56Q8Aro/1SEHuVhzOeCGv4zJv5MJ0RXZ
   UdDqaJHGy6LpLVw7xVW9f8TyIZ62E5FwUWyPwhwIIrsKJdTXa1deV6eA8
   Pru30x4LYkd2OaNUDPWhoFTqS5a6ajmrpPKZQuRxq96W6ku5HQ7cZk582
   8e3FhYYKSqPZ4ynRvcvwr17QZAjNCU2CpKo7fmSiaSz8JmSm/zgqSHHOP
   IlW8RoEpdDipbEzRKB7/XDXmNIgrnkZFUP2zg8iZDn7fQ+WMOceGc9jaN
   Bc7MOB2m/8Vk8mvOXyAK0dB/xViJRuMJ/zhBg9Zgb216FAjROHxJIDUZ/
   Q==;
IronPort-SDR: KiZims6sAF7seS/lH5FSpWJeaE1hST4HLfaB+QMn541TinlZT5PsnWlqEXT6xoHcWxigliDNBQ
 Htj5ZtPjk+ZDvxDmlMqpWbollRL4shR7pK0K8eO07dU7l7uCb4hXLlOx8FbpPJHVwV3zf+MeVb
 TnNf57iiFYh9F7de4bbTj0a0F8ry/yeLFKuJ8Jqfdi1ugYgWThGC7OXqjcNzRVeXr7g3y9z0IV
 yHQ84EndvZ0UIShz0SuJslzPQA/tFioYPhlYBfv225FOaPyA5wPhJt+KGV4ec4KUWGV7N/qiFw
 TEk=
X-IronPort-AV: E=Sophos;i="5.64,322,1559491200"; 
   d="scan'208";a="115403245"
Received: from mail-by2nam01lp2057.outbound.protection.outlook.com (HELO NAM01-BY2-obe.outbound.protection.outlook.com) ([104.47.34.57])
  by ob1.hgst.iphmx.com with ESMTP; 29 Jul 2019 19:57:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hW97hUzcYpyWuISnp+FDyIWu1gxo0iCZTnLqaYlqK4Dxr5D9vFAQDxVB0MISIH59RripnVeBnJxDuFzlxeoQqxI11pcEnVz3wk8TBdZke/zbCZTUj/lcdPzjne//Sjq+FQMULj1gJYSvvDGXpb+vtzqW/4fiAISh1k0VnSXvubdniMNwloN4rom+ezp40c0hzRkbFhB2yZlP30qcLwTzGIU9xGA8ChvzZUegCgbhJtXzvzKdm9u+xSd+iUcQj3VDV+AkX2yqIUFh0ojVpKhmIChEcu40ZKp5slzj8ssUDH6vG582V8ewkzslcZubZ+E1wyG84mJmR2Obpey1ADEBhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WSTZ7sOCJRD95mpCZGWNzrYtrX4nMmywkXcQy9lnkng=;
 b=lpsiPe8Dxkb5iWZLNw4vEM9r+qvCZmMpmTslZ8MRpPWUlsnsOeqZZ2JXwpsgkIF76lbPWh7PwEGzt4NcFR48+mgwKqyZH/R7oM+BPNxivPpNbUs2E+fS2YNDQlWM2nJ/TQ+7GLZ/YjM1Mr2ADytl1SAj4C/Ici43F+r08rpTq5GlW0+PDd8Fdfk2ChEurs/pdmmy9qiVomAV9TF4V1lRXIz9m9vkckrgjvZMcO0Tgz7hkpuwUSsvTxEUdyGk34OsVdcEM0WAy7ZVoObSAqNxd9rdaEBuZjVQ809ASSxmbyG7YGe0BBbn0uaNTJIkUSmHOG19QnxZNijSUOrC1ANLUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WSTZ7sOCJRD95mpCZGWNzrYtrX4nMmywkXcQy9lnkng=;
 b=e50BB/6eevZai87IBSSbwNA2b5pwCXVTyC/U1xyF261+cj+pO1MnAkxx5tYsBIfEyv5S+9DiCjzeq8k3YdMrzFNIxWkhHKeV4Nd/Oh/HS7FYK84KA/strZ5tNtzJQ9FNU/KMyIJWayIBFY1NC8E5R6dXLhrmN65mIoRlbnjj2VE=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB5678.namprd04.prod.outlook.com (20.179.21.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Mon, 29 Jul 2019 11:57:36 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 11:57:35 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>
CC:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anup Patel <Anup.Patel@wdc.com>
Subject: [RFC PATCH 12/16] RISC-V: KVM: Implement MMU notifiers
Thread-Topic: [RFC PATCH 12/16] RISC-V: KVM: Implement MMU notifiers
Thread-Index: AQHVRgTPe6HLXwSg9UaPtRtTuoF9hQ==
Date:   Mon, 29 Jul 2019 11:57:35 +0000
Message-ID: <20190729115544.17895-13-anup.patel@wdc.com>
References: <20190729115544.17895-1-anup.patel@wdc.com>
In-Reply-To: <20190729115544.17895-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PN1PR01CA0116.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00::32)
 To MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [106.51.23.101]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 44b6e46f-b9cc-4e8f-79a6-08d7141bf225
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB5678;
x-ms-traffictypediagnostic: MN2PR04MB5678:
x-microsoft-antispam-prvs: <MN2PR04MB5678CD1165E304F019EDD6028DDD0@MN2PR04MB5678.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:785;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(39860400002)(136003)(366004)(396003)(346002)(199004)(189003)(7416002)(52116002)(6436002)(6486002)(7736002)(476003)(2616005)(2906002)(5660300002)(66066001)(4326008)(446003)(68736007)(11346002)(81156014)(81166006)(14454004)(53936002)(26005)(186003)(78486014)(99286004)(36756003)(44832011)(486006)(305945005)(8676002)(54906003)(110136005)(25786009)(8936002)(478600001)(76176011)(102836004)(71200400001)(6512007)(1076003)(66446008)(64756008)(66946007)(256004)(55236004)(316002)(9456002)(86362001)(66476007)(50226002)(66556008)(6506007)(386003)(71190400001)(14444005)(6116002)(3846002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5678;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +/BO+uTT9Y2JSNmJ9XRKbiaQlotzF0aPC+7knAsA2+c/u5/EnDQA0+amR+Fhabjd/nnqOwiR7/uFR/EWKD8Uy2D7vf5bgLlfNU/Ew2PoeWW+JO7uob8Xn7Qj6N+ZRjDmfjFYcpieHpCjnAZhbBIeXZGsg9IDXtJLvKjtXpVK29EjURhD7IuSt52lke2dLJdq0TwjI7QNULM6wJEmE3LB1QIBOz0bT/2PpA8OzHCOsKoZK54Oa9yL643Vur/RxBk+LEF8dkkbzMrLmP/DWdKXVMQnp0QRpk7WvLo/010lna9+Ggu6HvxP87G2WdMeCilzNUQ+9EI2YWtOQxpS5xIfG3OE0mc5MkZgA+derwPnCWpEjKUaxAwgkT0un3TZC3lwZ7CX9FSE5YrXpXvA9a9yqRR4x/hPMxYl/COUBKwnVSI=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44b6e46f-b9cc-4e8f-79a6-08d7141bf225
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 11:57:35.8137
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Anup.Patel@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5678
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch implements MMU notifiers for KVM RISC-V so that Guest
physical address space is in-sync with Host physical address space.

This will allow swapping, page migration, etc to work transparently
with KVM RISC-V.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 arch/riscv/include/asm/kvm_host.h |   7 ++
 arch/riscv/kvm/Kconfig            |   1 +
 arch/riscv/kvm/mmu.c              | 200 +++++++++++++++++++++++++++++-
 3 files changed, 207 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm=
_host.h
index 354d179c43cf..58f61ce28461 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -177,6 +177,13 @@ static inline void kvm_arch_vcpu_uninit(struct kvm_vcp=
u *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
=20
+#define KVM_ARCH_WANT_MMU_NOTIFIER
+int kvm_unmap_hva_range(struct kvm *kvm,
+			unsigned long start, unsigned long end);
+int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
+int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
+int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
+
 extern void __kvm_riscv_hfence_gvma_vmid_gpa(unsigned long vmid,
 					     unsigned long gpa);
 extern void __kvm_riscv_hfence_gvma_vmid(unsigned long vmid);
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
index 9561c5e85f75..5c992d4b4317 100644
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
@@ -444,6 +504,38 @@ int stage2_ioremap(struct kvm *kvm, gpa_t gpa, phys_ad=
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
@@ -576,6 +668,106 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
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
@@ -587,7 +779,7 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu, gpa_t g=
pa, unsigned long hva,
 	struct vm_area_struct *vma;
 	struct kvm *kvm =3D vcpu->kvm;
 	struct kvm_mmu_page_cache *pcache =3D &vcpu->arch.mmu_page_cache;
-	unsigned long vma_pagesize;
+	unsigned long vma_pagesize, mmu_seq;
=20
 	down_read(&current->mm->mmap_sem);
=20
@@ -617,6 +809,8 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu, gpa_t g=
pa, unsigned long hva,
 		return ret;
 	}
=20
+	mmu_seq =3D kvm->mmu_notifier_seq;
+
 	hfn =3D gfn_to_pfn_prot(kvm, gfn, is_write, &writeable);
 	if (hfn =3D=3D KVM_PFN_ERR_HWPOISON) {
 		if (is_vm_hugetlb_page(vma))
@@ -635,6 +829,9 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu, gpa_t g=
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
@@ -647,6 +844,7 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu, gpa_t g=
pa, unsigned long hva,
 	if (ret)
 		kvm_err("Failed to map in stage2\n");
=20
+out_unlock:
 	spin_unlock(&kvm->mmu_lock);
 	kvm_set_pfn_accessed(hfn);
 	kvm_release_pfn_clean(hfn);
--=20
2.17.1

