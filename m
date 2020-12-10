Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEC02D5D8D
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 15:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390042AbgLJO05 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 09:26:57 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20474 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730742AbgLJO04 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Dec 2020 09:26:56 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BAE28wt151406;
        Thu, 10 Dec 2020 09:26:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=R6J7B3mgx+W41RaQLW/eiYgywm//wVZlLAVZLDfjaH4=;
 b=RXMdnAJY6xsr82NfqrJ+fH74XxzSNnn96Kw+eRel5mX9jnV2QMNgAXu29MDzuaZEy69U
 pcTioqb/IyFrJWmmGFTY3EGloF5Hfwz48/sgwnccQdTq2xpEE0rTyh0kGDsguZwUkwQR
 g+m5bVzn/A+jead0SMPvOn6waE8eXSN8ZPQPBY0E7CQzbQIbIQRorToCuZFC6xL7wAlB
 f2rhrDcc6tjswRDj3s2bawq6juLkRLCSYCUHKKg4tpfmzIamXBcrvnh7ZuEM16gCNZcr
 OPXGUmrJ1eln2FKIX66/HvsK9SNV0k0REpPGQg1X5tVZGdjWqX1+yqLHY11ffYd/WXuq JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35bjvbwe1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 09:26:07 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BAE2i29157949;
        Thu, 10 Dec 2020 09:26:06 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35bjvbwe0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 09:26:06 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BAEIOPP025187;
        Thu, 10 Dec 2020 14:26:04 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3581u8rnu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 14:26:04 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BAEQ1f122675750
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Dec 2020 14:26:01 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BEE4AE064;
        Thu, 10 Dec 2020 14:26:01 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D8B6AE063;
        Thu, 10 Dec 2020 14:26:01 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 10 Dec 2020 14:26:01 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id DCCEBE0450; Thu, 10 Dec 2020 15:26:00 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Collin Walling <walling@linux.ibm.com>
Subject: [GIT PULL 1/4] KVM: s390: Add memcg accounting to KVM allocations
Date:   Thu, 10 Dec 2020 15:25:56 +0100
Message-Id: <20201210142600.6771-2-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201210142600.6771-1-borntraeger@de.ibm.com>
References: <20201210142600.6771-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-10_05:2020-12-09,2020-12-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=2 malwarescore=0 clxscore=1015 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 priorityscore=1501 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012100084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Almost all kvm allocations in the s390x KVM code can be attributed to
the process that triggers the allocation (in other words, no global
allocation for other guests). This will help the memcg controller to
make the right decisions.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Acked-by: Cornelia Huck <cohuck@redhat.com>
---
 arch/s390/kvm/guestdbg.c  |  8 ++++----
 arch/s390/kvm/intercept.c |  2 +-
 arch/s390/kvm/interrupt.c | 10 +++++-----
 arch/s390/kvm/kvm-s390.c  | 20 ++++++++++----------
 arch/s390/kvm/priv.c      |  4 ++--
 arch/s390/kvm/pv.c        |  6 +++---
 arch/s390/kvm/vsie.c      |  4 ++--
 7 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/arch/s390/kvm/guestdbg.c b/arch/s390/kvm/guestdbg.c
index 394a5f53805b..3765c4223bf9 100644
--- a/arch/s390/kvm/guestdbg.c
+++ b/arch/s390/kvm/guestdbg.c
@@ -184,7 +184,7 @@ static int __import_wp_info(struct kvm_vcpu *vcpu,
 	if (wp_info->len < 0 || wp_info->len > MAX_WP_SIZE)
 		return -EINVAL;
 
-	wp_info->old_data = kmalloc(bp_data->len, GFP_KERNEL);
+	wp_info->old_data = kmalloc(bp_data->len, GFP_KERNEL_ACCOUNT);
 	if (!wp_info->old_data)
 		return -ENOMEM;
 	/* try to backup the original value */
@@ -234,7 +234,7 @@ int kvm_s390_import_bp_data(struct kvm_vcpu *vcpu,
 	if (nr_wp > 0) {
 		wp_info = kmalloc_array(nr_wp,
 					sizeof(*wp_info),
-					GFP_KERNEL);
+					GFP_KERNEL_ACCOUNT);
 		if (!wp_info) {
 			ret = -ENOMEM;
 			goto error;
@@ -243,7 +243,7 @@ int kvm_s390_import_bp_data(struct kvm_vcpu *vcpu,
 	if (nr_bp > 0) {
 		bp_info = kmalloc_array(nr_bp,
 					sizeof(*bp_info),
-					GFP_KERNEL);
+					GFP_KERNEL_ACCOUNT);
 		if (!bp_info) {
 			ret = -ENOMEM;
 			goto error;
@@ -349,7 +349,7 @@ static struct kvm_hw_wp_info_arch *any_wp_changed(struct kvm_vcpu *vcpu)
 		if (!wp_info || !wp_info->old_data || wp_info->len <= 0)
 			continue;
 
-		temp = kmalloc(wp_info->len, GFP_KERNEL);
+		temp = kmalloc(wp_info->len, GFP_KERNEL_ACCOUNT);
 		if (!temp)
 			continue;
 
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index e7a7c499a73f..72b25b7cc6ae 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -398,7 +398,7 @@ int handle_sthyi(struct kvm_vcpu *vcpu)
 	if (!kvm_s390_pv_cpu_is_protected(vcpu) && (addr & ~PAGE_MASK))
 		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
 
-	sctns = (void *)get_zeroed_page(GFP_KERNEL);
+	sctns = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
 	if (!sctns)
 		return -ENOMEM;
 
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 2f177298c663..e3183bd05910 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -1792,7 +1792,7 @@ struct kvm_s390_interrupt_info *kvm_s390_get_io_int(struct kvm *kvm,
 		goto out;
 	}
 gisa_out:
-	tmp_inti = kzalloc(sizeof(*inti), GFP_KERNEL);
+	tmp_inti = kzalloc(sizeof(*inti), GFP_KERNEL_ACCOUNT);
 	if (tmp_inti) {
 		tmp_inti->type = KVM_S390_INT_IO(1, 0, 0, 0);
 		tmp_inti->io.io_int_word = isc_to_int_word(isc);
@@ -2015,7 +2015,7 @@ int kvm_s390_inject_vm(struct kvm *kvm,
 	struct kvm_s390_interrupt_info *inti;
 	int rc;
 
-	inti = kzalloc(sizeof(*inti), GFP_KERNEL);
+	inti = kzalloc(sizeof(*inti), GFP_KERNEL_ACCOUNT);
 	if (!inti)
 		return -ENOMEM;
 
@@ -2414,7 +2414,7 @@ static int enqueue_floating_irq(struct kvm_device *dev,
 		return -EINVAL;
 
 	while (len >= sizeof(struct kvm_s390_irq)) {
-		inti = kzalloc(sizeof(*inti), GFP_KERNEL);
+		inti = kzalloc(sizeof(*inti), GFP_KERNEL_ACCOUNT);
 		if (!inti)
 			return -ENOMEM;
 
@@ -2462,7 +2462,7 @@ static int register_io_adapter(struct kvm_device *dev,
 	if (dev->kvm->arch.adapters[adapter_info.id] != NULL)
 		return -EINVAL;
 
-	adapter = kzalloc(sizeof(*adapter), GFP_KERNEL);
+	adapter = kzalloc(sizeof(*adapter), GFP_KERNEL_ACCOUNT);
 	if (!adapter)
 		return -ENOMEM;
 
@@ -3290,7 +3290,7 @@ int kvm_s390_gib_init(u8 nisc)
 		goto out;
 	}
 
-	gib = (struct kvm_s390_gib *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	gib = (struct kvm_s390_gib *)get_zeroed_page(GFP_KERNEL_ACCOUNT | GFP_DMA);
 	if (!gib) {
 		rc = -ENOMEM;
 		goto out;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 6b74b92c1a58..19804c388d61 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1254,7 +1254,7 @@ static int kvm_s390_set_processor(struct kvm *kvm, struct kvm_device_attr *attr)
 		ret = -EBUSY;
 		goto out;
 	}
-	proc = kzalloc(sizeof(*proc), GFP_KERNEL);
+	proc = kzalloc(sizeof(*proc), GFP_KERNEL_ACCOUNT);
 	if (!proc) {
 		ret = -ENOMEM;
 		goto out;
@@ -1416,7 +1416,7 @@ static int kvm_s390_get_processor(struct kvm *kvm, struct kvm_device_attr *attr)
 	struct kvm_s390_vm_cpu_processor *proc;
 	int ret = 0;
 
-	proc = kzalloc(sizeof(*proc), GFP_KERNEL);
+	proc = kzalloc(sizeof(*proc), GFP_KERNEL_ACCOUNT);
 	if (!proc) {
 		ret = -ENOMEM;
 		goto out;
@@ -1444,7 +1444,7 @@ static int kvm_s390_get_machine(struct kvm *kvm, struct kvm_device_attr *attr)
 	struct kvm_s390_vm_cpu_machine *mach;
 	int ret = 0;
 
-	mach = kzalloc(sizeof(*mach), GFP_KERNEL);
+	mach = kzalloc(sizeof(*mach), GFP_KERNEL_ACCOUNT);
 	if (!mach) {
 		ret = -ENOMEM;
 		goto out;
@@ -1812,7 +1812,7 @@ static long kvm_s390_get_skeys(struct kvm *kvm, struct kvm_s390_skeys *args)
 	if (args->count < 1 || args->count > KVM_S390_SKEYS_MAX)
 		return -EINVAL;
 
-	keys = kvmalloc_array(args->count, sizeof(uint8_t), GFP_KERNEL);
+	keys = kvmalloc_array(args->count, sizeof(uint8_t), GFP_KERNEL_ACCOUNT);
 	if (!keys)
 		return -ENOMEM;
 
@@ -1857,7 +1857,7 @@ static long kvm_s390_set_skeys(struct kvm *kvm, struct kvm_s390_skeys *args)
 	if (args->count < 1 || args->count > KVM_S390_SKEYS_MAX)
 		return -EINVAL;
 
-	keys = kvmalloc_array(args->count, sizeof(uint8_t), GFP_KERNEL);
+	keys = kvmalloc_array(args->count, sizeof(uint8_t), GFP_KERNEL_ACCOUNT);
 	if (!keys)
 		return -ENOMEM;
 
@@ -2625,7 +2625,7 @@ static void sca_dispose(struct kvm *kvm)
 
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
-	gfp_t alloc_flags = GFP_KERNEL;
+	gfp_t alloc_flags = GFP_KERNEL_ACCOUNT;
 	int i, rc;
 	char debug_name[16];
 	static unsigned long sca_offset;
@@ -2670,7 +2670,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	BUILD_BUG_ON(sizeof(struct sie_page2) != 4096);
 	kvm->arch.sie_page2 =
-	     (struct sie_page2 *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	     (struct sie_page2 *) get_zeroed_page(GFP_KERNEL_ACCOUNT | GFP_DMA);
 	if (!kvm->arch.sie_page2)
 		goto out_err;
 
@@ -2900,7 +2900,7 @@ static int sca_switch_to_extended(struct kvm *kvm)
 	if (kvm->arch.use_esca)
 		return 0;
 
-	new_sca = alloc_pages_exact(sizeof(*new_sca), GFP_KERNEL|__GFP_ZERO);
+	new_sca = alloc_pages_exact(sizeof(*new_sca), GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!new_sca)
 		return -ENOMEM;
 
@@ -3133,7 +3133,7 @@ void kvm_s390_vcpu_unsetup_cmma(struct kvm_vcpu *vcpu)
 
 int kvm_s390_vcpu_setup_cmma(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.sie_block->cbrlo = get_zeroed_page(GFP_KERNEL);
+	vcpu->arch.sie_block->cbrlo = get_zeroed_page(GFP_KERNEL_ACCOUNT);
 	if (!vcpu->arch.sie_block->cbrlo)
 		return -ENOMEM;
 	return 0;
@@ -3243,7 +3243,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	int rc;
 
 	BUILD_BUG_ON(sizeof(struct sie_page) != 4096);
-	sie_page = (struct sie_page *) get_zeroed_page(GFP_KERNEL);
+	sie_page = (struct sie_page *) get_zeroed_page(GFP_KERNEL_ACCOUNT);
 	if (!sie_page)
 		return -ENOMEM;
 
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index cd74989ce0b0..9928f785c677 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -879,7 +879,7 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
 	switch (fc) {
 	case 1: /* same handling for 1 and 2 */
 	case 2:
-		mem = get_zeroed_page(GFP_KERNEL);
+		mem = get_zeroed_page(GFP_KERNEL_ACCOUNT);
 		if (!mem)
 			goto out_no_data;
 		if (stsi((void *) mem, fc, sel1, sel2))
@@ -888,7 +888,7 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
 	case 3:
 		if (sel1 != 2 || sel2 != 2)
 			goto out_no_data;
-		mem = get_zeroed_page(GFP_KERNEL);
+		mem = get_zeroed_page(GFP_KERNEL_ACCOUNT);
 		if (!mem)
 			goto out_no_data;
 		handle_stsi_3_2_2(vcpu, (void *) mem);
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index eb99e2f95ebe..373b654c84bd 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -60,7 +60,7 @@ int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
 	if (kvm_s390_pv_cpu_get_handle(vcpu))
 		return -EINVAL;
 
-	vcpu->arch.pv.stor_base = __get_free_pages(GFP_KERNEL,
+	vcpu->arch.pv.stor_base = __get_free_pages(GFP_KERNEL_ACCOUNT,
 						   get_order(uv_info.guest_cpu_stor_len));
 	if (!vcpu->arch.pv.stor_base)
 		return -ENOMEM;
@@ -72,7 +72,7 @@ int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
 	uvcb.stor_origin = (u64)vcpu->arch.pv.stor_base;
 
 	/* Alloc Secure Instruction Data Area Designation */
-	vcpu->arch.sie_block->sidad = __get_free_page(GFP_KERNEL | __GFP_ZERO);
+	vcpu->arch.sie_block->sidad = __get_free_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!vcpu->arch.sie_block->sidad) {
 		free_pages(vcpu->arch.pv.stor_base,
 			   get_order(uv_info.guest_cpu_stor_len));
@@ -120,7 +120,7 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
 	struct kvm_memory_slot *memslot;
 
 	kvm->arch.pv.stor_var = NULL;
-	kvm->arch.pv.stor_base = __get_free_pages(GFP_KERNEL, get_order(base));
+	kvm->arch.pv.stor_base = __get_free_pages(GFP_KERNEL_ACCOUNT, get_order(base));
 	if (!kvm->arch.pv.stor_base)
 		return -ENOMEM;
 
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 4f3cbf6003a9..c5d0a58b2c29 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -1234,7 +1234,7 @@ static struct vsie_page *get_vsie_page(struct kvm *kvm, unsigned long addr)
 
 	mutex_lock(&kvm->arch.vsie.mutex);
 	if (kvm->arch.vsie.page_count < nr_vcpus) {
-		page = alloc_page(GFP_KERNEL | __GFP_ZERO | GFP_DMA);
+		page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO | GFP_DMA);
 		if (!page) {
 			mutex_unlock(&kvm->arch.vsie.mutex);
 			return ERR_PTR(-ENOMEM);
@@ -1336,7 +1336,7 @@ int kvm_s390_handle_vsie(struct kvm_vcpu *vcpu)
 void kvm_s390_vsie_init(struct kvm *kvm)
 {
 	mutex_init(&kvm->arch.vsie.mutex);
-	INIT_RADIX_TREE(&kvm->arch.vsie.addr_to_page, GFP_KERNEL);
+	INIT_RADIX_TREE(&kvm->arch.vsie.addr_to_page, GFP_KERNEL_ACCOUNT);
 }
 
 /* Destroy the vsie data structures. To be called when a vm is destroyed. */
-- 
2.28.0

