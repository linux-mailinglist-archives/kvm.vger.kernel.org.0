Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11454D968D
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 18:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405273AbfJPQKX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 12:10:23 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:34111 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389848AbfJPQKW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 12:10:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1571242238; x=1602778238;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=D6b5JI32sBZpZ5AZQCXukZq0u2k31KOsvUfpAaOqYi0=;
  b=TI91cvupCcdegc2PXCrldyqeQzc4b9D26EZkiD9mmO+WFVerdWfUs1Ft
   iplUXlW8NtJzAhh1EVdCaJKdvcRCpRKnddVR6pC0yhsJt8hce6rRIcJm3
   BrQsZkMugnYtNovKeJa4ooyl/mWVcO3JxYxvwtxXbQKSaOc8mhkxKwM/Q
   qw5n7+LlRkT8nUKF1f6S6lDn19a8oE2G3ith0FqBuLGzsZoV2QAO6Yq1e
   duuhFUQpsZYmIFqg3xxMr7xJJxHgTaCQh38kBD/f3JQPO0E57T+pBtRV9
   5+O0WnQYllTdypl7aJl4/rYofzoY0l7KKsP8dPRO41HzTttiPQzjkN8xt
   w==;
IronPort-SDR: dhZfo71OBEegs7bz+JfqwntVuqfiTJUf5H0TyhzKvJdXKTtiQ+m/bMxxgYmFm/1Tlb9fb7uj6x
 Ot9KJKC3FY31UObAUTQyWch+7TaEFxLK2xwmMywqcHEWPFhx0rYpalghmmE078c1HM4kOooB1e
 /4tlvhvmq7dfABYHQfn2gWzEVd5JflmeFjRQVwv4tnqbEZtbNwvcprwqcxn1U/JdwQOXgt6LH0
 /HHGEPabcbTYFWBsMtZx2jXvX0uXkjdFpxIkUkAH794lxTOUZHU6aCAc1OMFcnFKZO9Br2235X
 E28=
X-IronPort-AV: E=Sophos;i="5.67,304,1566835200"; 
   d="scan'208";a="221734747"
Received: from mail-by2nam05lp2056.outbound.protection.outlook.com (HELO NAM05-BY2-obe.outbound.protection.outlook.com) ([104.47.50.56])
  by ob1.hgst.iphmx.com with ESMTP; 17 Oct 2019 00:10:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R7lchR6eullZhVJLJ2TTuLGpH4X1EW1xJWi44e5T2X9VNBw+zS3lYU7TGShxcB//27ja/FNH3UgvsZHWheJ/R71SW/GdLypj9X7YgAlLXS1ae20G94OQ+Jp27TTRINdqRb548/JuAXP6ZQiZlo5ejndQuk3wj5Kn4bWroTYOImnWYjJBZg68/YlK3SOWOBlMnMeSh9A+fBaL9JlbFlWeHgTCcQMl2ISQ5+PD7m4pCHL7GBRt3btrVIF0giYZKQezYx5ufGhTPQaWamFnOYIRAeIh6rSpTmeEYkXF/vBV7MEgwz4xgZxr2DSCGbk63J5FbG/azR7SPS3sp08d1zXECw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qHANetQhtOwmpFjnGSPd1eH40yHBRA5JwIwZvEaWxwU=;
 b=iQb6zQjt29FY0VKk457W0/6r2UgZnXN71qtUyz6uq/QcfWhBEMJzA7QuCYxYxMf2bDsJ0r/b8WPokvjmGAlrY8tr/wlFRMMO1C321LDT9A/PICu1tSVralCe28+IuaBae0+/2pEuZAnc6z7Uu/D56EWRoFB/3kDCrKKFJXQf2IL/UVpIFFejvAXDt60+9sDaFZkVbM9LANVRYhXuhHw5W2BbgxD7+VdIzph0MH5P4BcquJg22Jryrggea3KeJw3gHIHE86Q6uw/RtiHwyOYrE/gCUrAb02/WLZPs7AM2wMwTj/nCjEQUUVerAiHD6SR209iGryH9d0NPTassi8nPuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qHANetQhtOwmpFjnGSPd1eH40yHBRA5JwIwZvEaWxwU=;
 b=PU35E5j9E+yojsSNWAWUDBOozbHBoVbB/tymX00N+odUN9pSlKR31Hd+ZU7xVAoMAoLFendc6fwuhn7U5wczdKUvLtHasa7I0LfudhTfRDp/8fX8ZyBFYzvW6wNg8TbfoguxpQcki4xDLx7yMPJbjZa7NvvUC5WL6V2jsTHY3H4=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB7038.namprd04.prod.outlook.com (10.186.146.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 16 Oct 2019 16:10:19 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a%7]) with mapi id 15.20.2347.023; Wed, 16 Oct 2019
 16:10:19 +0000
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
Subject: [PATCH v9 11/22] RISC-V: KVM: Implement stage2 page table programming
Thread-Topic: [PATCH v9 11/22] RISC-V: KVM: Implement stage2 page table
 programming
Thread-Index: AQHVhDw0f7PlS6If9kmnDZwDd7kA1Q==
Date:   Wed, 16 Oct 2019 16:10:18 +0000
Message-ID: <20191016160649.24622-12-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 41b1bab3-6040-4e26-50c3-08d75253569a
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: MN2PR04MB7038:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB7038BCC537E69F142441C5BC8D920@MN2PR04MB7038.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 0192E812EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(376002)(396003)(136003)(346002)(39860400002)(199004)(189003)(102836004)(44832011)(486006)(2616005)(476003)(386003)(25786009)(446003)(52116002)(99286004)(186003)(76176011)(55236004)(66066001)(26005)(6506007)(5660300002)(36756003)(11346002)(64756008)(6436002)(66946007)(66446008)(66476007)(66556008)(30864003)(86362001)(6486002)(4326008)(6512007)(1076003)(305945005)(14454004)(256004)(7736002)(7416002)(478600001)(6116002)(71190400001)(3846002)(54906003)(110136005)(2906002)(316002)(71200400001)(8936002)(9456002)(50226002)(81156014)(81166006)(8676002)(14444005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB7038;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tDtvH+2T93V/ePNc9mT4XTU4/8tXFFY399o9g4tJViMqxcctMK3IsihGPHu6pK3XjGQnRgdIlG2g7jhV/Ai605MKuIgFynGydfDPbianH9VJZilypSy3b/0n1itOtQAVm2uzRZTDaxv4/yhpXXghQMfn6gEd4xfiJDoZimiuEEuJMgTK9/guQf5BCI+KBS4X1AThJngPbC52HYlFkiFI9WekV8aoREixC9CtOI1idL/orRkjwTm2D5/FGEZXvqJC98cCXvnnqrFYHdZyHA8PbWkePfhIRq2FF6aV/NW3n+sBMI6q2sdPPTIS6J5pTHp+gmBadHKzDSV1sFYIZLlKOYqIHc4cOjBAyni898riF/qTuAzNZ2pD9hUIB2BQUSFxe8hXEKfChUSVGo3hmR25Qo1MmWiikfrWDryiGOtPFnI=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41b1bab3-6040-4e26-50c3-08d75253569a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2019 16:10:18.9289
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2utp/LkpKUVV8OQJYLp3fasYooygkGSIyLKRjR1w6gnDLOfWXki1ctaGyJWriK7HFeDOL4cKaO8TKwYIOSNypw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7038
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
 arch/riscv/kvm/mmu.c                  | 646 +++++++++++++++++++++++++-
 3 files changed, 647 insertions(+), 10 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm=
_host.h
index 9410468678ae..aba3d80d4bea 100644
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
index 2b965f9aac07..61a98d63d103 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -18,6 +18,438 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
=20
+#ifdef CONFIG_64BIT
+#define stage2_have_pmd		true
+#define stage2_gpa_size		((phys_addr_t)(1ULL << 39))
+#define stage2_cache_min_pages	2
+#else
+#define pmd_index(x)		0
+#define pfn_pmd(x, y)		({ pmd_t __x =3D { 0 }; __x; })
+#define stage2_have_pmd		false
+#define stage2_gpa_size		((phys_addr_t)(1ULL << 32))
+#define stage2_cache_min_pages	1
+#endif
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
+struct local_guest_tlb_info {
+	struct kvm_vmid *vmid;
+	gpa_t addr;
+};
+
+static void local_guest_tlb_flush_vmid_gpa(void *info)
+{
+	struct local_guest_tlb_info *infop =3D info;
+
+	__kvm_riscv_hfence_gvma_vmid_gpa(READ_ONCE(infop->vmid->vmid_version),
+					 infop->addr);
+}
+
+static void stage2_remote_tlb_flush(struct kvm *kvm, gpa_t addr)
+{
+	struct local_guest_tlb_info info;
+	struct kvm_vmid *vmid =3D &kvm->arch.vmid;
+
+	/*
+	 * Ideally, we should have a SBI call OR some remote TLB instruction
+	 * but we don't have it so we explicitly flush TLBs using IPIs.
+	 *
+	 * TODO: Instead of cpu_online_mask, we should only target CPUs
+	 * where the Guest/VM is running.
+	 */
+	info.vmid =3D vmid;
+	info.addr =3D addr;
+	preempt_disable();
+	smp_call_function_many(cpu_online_mask,
+			       local_guest_tlb_flush_vmid_gpa, &info, true);
+	preempt_enable();
+}
+
+static int stage2_set_pgd(struct kvm *kvm, gpa_t addr, const pgd_t *new_pg=
d)
+{
+	pgd_t *pgdp =3D &kvm->arch.pgd[pgd_index(addr)];
+
+	*pgdp =3D *new_pgd;
+	if (pgd_val(*pgdp) & _PAGE_LEAF)
+		stage2_remote_tlb_flush(kvm, addr);
+
+	return 0;
+}
+
+static int stage2_set_pmd(struct kvm *kvm, struct kvm_mmu_page_cache *pcac=
he,
+			  gpa_t addr, const pmd_t *new_pmd)
+{
+	int rc;
+	pmd_t *pmdp;
+	pgd_t new_pgd;
+	pgd_t *pgdp =3D &kvm->arch.pgd[pgd_index(addr)];
+
+	if (!pgd_val(*pgdp)) {
+		pmdp =3D stage2_cache_alloc(pcache);
+		if (!pmdp)
+			return -ENOMEM;
+		new_pgd =3D pfn_pgd(PFN_DOWN(__pa(pmdp)), __pgprot(_PAGE_TABLE));
+		rc =3D stage2_set_pgd(kvm, addr, &new_pgd);
+		if (rc)
+			return rc;
+	}
+
+	if (pgd_val(*pgdp) & _PAGE_LEAF)
+		return -EEXIST;
+
+	pmdp =3D (void *)pgd_page_vaddr(*pgdp);
+	pmdp =3D &pmdp[pmd_index(addr)];
+
+	*pmdp =3D *new_pmd;
+	if (pmd_val(*pmdp) & _PAGE_LEAF)
+		stage2_remote_tlb_flush(kvm, addr);
+
+	return 0;
+}
+
+static int stage2_set_pte(struct kvm *kvm,
+			  struct kvm_mmu_page_cache *pcache,
+			  gpa_t addr, const pte_t *new_pte)
+{
+	int rc;
+	pte_t *ptep;
+	pmd_t new_pmd;
+	pmd_t *pmdp;
+	pgd_t new_pgd;
+	pgd_t *pgdp =3D &kvm->arch.pgd[pgd_index(addr)];
+
+	if (!pgd_val(*pgdp)) {
+		pmdp =3D stage2_cache_alloc(pcache);
+		if (!pmdp)
+			return -ENOMEM;
+		new_pgd =3D pfn_pgd(PFN_DOWN(__pa(pmdp)), __pgprot(_PAGE_TABLE));
+		rc =3D stage2_set_pgd(kvm, addr, &new_pgd);
+		if (rc)
+			return rc;
+	}
+
+	if (pgd_val(*pgdp) & _PAGE_LEAF)
+		return -EEXIST;
+
+	if (stage2_have_pmd) {
+		pmdp =3D (void *)pgd_page_vaddr(*pgdp);
+		pmdp =3D &pmdp[pmd_index(addr)];
+		if (!pmd_present(*pmdp)) {
+			ptep =3D stage2_cache_alloc(pcache);
+			if (!ptep)
+				return -ENOMEM;
+			new_pmd =3D pfn_pmd(PFN_DOWN(__pa(ptep)),
+					  __pgprot(_PAGE_TABLE));
+			rc =3D stage2_set_pmd(kvm, pcache, addr, &new_pmd);
+			if (rc)
+				return rc;
+		}
+
+		if (pmd_val(*pmdp) & _PAGE_LEAF)
+			return -EEXIST;
+
+		ptep =3D (void *)pmd_page_vaddr(*pmdp);
+	} else {
+		ptep =3D (void *)pgd_page_vaddr(*pgdp);
+	}
+
+	ptep =3D &ptep[pte_index(addr)];
+
+	*ptep =3D *new_pte;
+	if (pte_val(*ptep) & _PAGE_LEAF)
+		stage2_remote_tlb_flush(kvm, addr);
+
+	return 0;
+}
+
+static int stage2_map_page(struct kvm *kvm,
+			   struct kvm_mmu_page_cache *pcache,
+			   gpa_t gpa, phys_addr_t hpa,
+			   unsigned long page_size, pgprot_t prot)
+{
+	pte_t new_pte;
+	pmd_t new_pmd;
+	pgd_t new_pgd;
+
+	if (page_size =3D=3D PAGE_SIZE) {
+		new_pte =3D pfn_pte(PFN_DOWN(hpa), prot);
+		return stage2_set_pte(kvm, pcache, gpa, &new_pte);
+	}
+
+	if (stage2_have_pmd && page_size =3D=3D PMD_SIZE) {
+		new_pmd =3D pfn_pmd(PFN_DOWN(hpa), prot);
+		return stage2_set_pmd(kvm, pcache, gpa, &new_pmd);
+	}
+
+	if (page_size =3D=3D PGDIR_SIZE) {
+		new_pgd =3D pfn_pgd(PFN_DOWN(hpa), prot);
+		return stage2_set_pgd(kvm, gpa, &new_pgd);
+	}
+
+	return -EINVAL;
+}
+
+enum stage2_op {
+	STAGE2_OP_NOP =3D 0,	/* Nothing */
+	STAGE2_OP_CLEAR,	/* Clear/Unmap */
+	STAGE2_OP_WP,		/* Write-protect */
+};
+
+static void stage2_op_pte(struct kvm *kvm, gpa_t addr, pte_t *ptep,
+			  enum stage2_op op)
+{
+	BUG_ON(addr & (PAGE_SIZE - 1));
+
+	if (!pte_present(*ptep))
+		return;
+
+	if (op =3D=3D STAGE2_OP_CLEAR)
+		set_pte(ptep, __pte(0));
+	else if (op =3D=3D STAGE2_OP_WP)
+		set_pte(ptep, __pte(pte_val(*ptep) & ~_PAGE_WRITE));
+	stage2_remote_tlb_flush(kvm, addr);
+}
+
+static void stage2_op_pmd(struct kvm *kvm, gpa_t addr, pmd_t *pmdp,
+			  enum stage2_op op)
+{
+	int i;
+	pte_t *ptep;
+
+	BUG_ON(addr & (PMD_SIZE - 1));
+
+	if (!pmd_present(*pmdp))
+		return;
+
+	if (pmd_val(*pmdp) & _PAGE_LEAF)
+		ptep =3D NULL;
+	else
+		ptep =3D (pte_t *)pmd_page_vaddr(*pmdp);
+
+	if (op =3D=3D STAGE2_OP_CLEAR)
+		set_pmd(pmdp, __pmd(0));
+
+	if (ptep) {
+		for (i =3D 0; i < PTRS_PER_PTE; i++)
+			stage2_op_pte(kvm, addr + i * PAGE_SIZE, &ptep[i], op);
+		if (op =3D=3D STAGE2_OP_CLEAR)
+			put_page(virt_to_page(ptep));
+	} else {
+		if (op =3D=3D STAGE2_OP_WP)
+			set_pmd(pmdp, __pmd(pmd_val(*pmdp) & ~_PAGE_WRITE));
+		stage2_remote_tlb_flush(kvm, addr);
+	}
+}
+
+static void stage2_op_pgd(struct kvm *kvm, gpa_t addr, pgd_t *pgdp,
+			  enum stage2_op op)
+{
+	int i;
+	pte_t *ptep;
+	pmd_t *pmdp;
+
+	BUG_ON(addr & (PGDIR_SIZE - 1));
+
+	if (!pgd_val(*pgdp))
+		return;
+
+	ptep =3D NULL;
+	pmdp =3D NULL;
+	if (!(pgd_val(*pgdp) & _PAGE_LEAF)) {
+		if (stage2_have_pmd)
+			pmdp =3D (pmd_t *)pgd_page_vaddr(*pgdp);
+		else
+			ptep =3D (pte_t *)pgd_page_vaddr(*pgdp);
+	}
+
+	if (op =3D=3D STAGE2_OP_CLEAR)
+		set_pgd(pgdp, __pgd(0));
+
+	if (pmdp) {
+		for (i =3D 0; i < PTRS_PER_PMD; i++)
+			stage2_op_pmd(kvm, addr + i * PMD_SIZE, &pmdp[i], op);
+		if (op =3D=3D STAGE2_OP_CLEAR)
+			put_page(virt_to_page(pmdp));
+	} else if (ptep) {
+		for (i =3D 0; i < PTRS_PER_PTE; i++)
+			stage2_op_pte(kvm, addr + i * PAGE_SIZE, &ptep[i], op);
+		if (op =3D=3D STAGE2_OP_CLEAR)
+			put_page(virt_to_page(ptep));
+	} else {
+		if (op =3D=3D STAGE2_OP_WP)
+			set_pgd(pgdp, __pgd(pgd_val(*pgdp) & ~_PAGE_WRITE));
+		stage2_remote_tlb_flush(kvm, addr);
+	}
+}
+
+static void stage2_unmap_range(struct kvm *kvm, gpa_t start, gpa_t size)
+{
+	pmd_t *pmdp;
+	pte_t *ptep;
+	pgd_t *pgdp;
+	gpa_t addr =3D start, end =3D start + size;
+
+	while (addr < end) {
+		pgdp =3D &kvm->arch.pgd[pgd_index(addr)];
+		if (!pgd_val(*pgdp)) {
+			addr +=3D PGDIR_SIZE;
+			continue;
+		} else if (!(addr & (PGDIR_SIZE - 1)) &&
+			  ((end - addr) >=3D PGDIR_SIZE)) {
+			stage2_op_pgd(kvm, addr, pgdp, STAGE2_OP_CLEAR);
+			addr +=3D PGDIR_SIZE;
+			continue;
+		}
+
+		if (stage2_have_pmd) {
+			pmdp =3D (pmd_t *)pgd_page_vaddr(*pgdp);
+			if (!pmd_present(*pmdp)) {
+				addr +=3D PMD_SIZE;
+				continue;
+			} else if (!(addr & (PMD_SIZE - 1)) &&
+				   ((end - addr) >=3D PMD_SIZE)) {
+				stage2_op_pmd(kvm, addr, pmdp,
+					      STAGE2_OP_CLEAR);
+				addr +=3D PMD_SIZE;
+				continue;
+			}
+			ptep =3D (pte_t *)pmd_page_vaddr(*pmdp);
+		} else {
+			ptep =3D (pte_t *)pgd_page_vaddr(*pgdp);
+		}
+
+		stage2_op_pte(kvm, addr, ptep, STAGE2_OP_CLEAR);
+		addr +=3D PAGE_SIZE;
+	}
+}
+
+static void stage2_wp_range(struct kvm *kvm, gpa_t start, gpa_t end)
+{
+	pmd_t *pmdp;
+	pte_t *ptep;
+	pgd_t *pgdp;
+	gpa_t addr =3D start;
+
+	while (addr < end) {
+		pgdp =3D &kvm->arch.pgd[pgd_index(addr)];
+		if (!pgd_val(*pgdp)) {
+			addr +=3D PGDIR_SIZE;
+			continue;
+		} else if (!(addr & (PGDIR_SIZE - 1)) &&
+			   ((end - addr) >=3D PGDIR_SIZE)) {
+			stage2_op_pgd(kvm, addr, pgdp, STAGE2_OP_WP);
+			addr +=3D PGDIR_SIZE;
+			continue;
+		}
+
+		if (stage2_have_pmd) {
+			pmdp =3D (pmd_t *)pgd_page_vaddr(*pgdp);
+			if (!pmd_present(*pmdp)) {
+				addr +=3D PMD_SIZE;
+				continue;
+			} else if (!(addr & (PMD_SIZE - 1)) &&
+				   ((end - addr) >=3D PMD_SIZE)) {
+				stage2_op_pmd(kvm, addr, pmdp, STAGE2_OP_WP);
+				addr +=3D PMD_SIZE;
+				continue;
+			}
+			ptep =3D (pte_t *)pmd_page_vaddr(*pmdp);
+		} else {
+			ptep =3D (pte_t *)pgd_page_vaddr(*pgdp);
+		}
+
+		stage2_op_pte(kvm, addr, ptep, STAGE2_OP_WP);
+		addr +=3D PAGE_SIZE;
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
+					 stage2_cache_min_pages,
+					 KVM_MMU_PAGE_CACHE_NR_OBJS);
+		if (ret)
+			goto out;
+
+		spin_lock(&kvm->mmu_lock);
+		ret =3D stage2_set_pte(kvm, &pcache, addr, &pte);
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
+
 void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
 			   struct kvm_memory_slot *dont)
 {
@@ -35,7 +467,7 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
=20
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
-	/* TODO: */
+	kvm_riscv_stage2_free_pgd(kvm);
 }
=20
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
@@ -49,7 +481,13 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
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
@@ -57,34 +495,222 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
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
+	ret =3D stage2_cache_topup(pcache, stage2_cache_min_pages,
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

