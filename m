Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 861CCDFAC3
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 04:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387880AbfJVCBK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 22:01:10 -0400
Received: from mga14.intel.com ([192.55.52.115]:61616 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387688AbfJVB77 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 21:59:59 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 18:59:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; 
   d="scan'208";a="196293898"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 21 Oct 2019 18:59:58 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 37/45] KVM: Drop kvm_arch_vcpu_setup()
Date:   Mon, 21 Oct 2019 18:59:17 -0700
Message-Id: <20191022015925.31916-38-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191022015925.31916-1-sean.j.christopherson@intel.com>
References: <20191022015925.31916-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove kvm_arch_vcpu_setup() now that all arch specific implementations
are nops.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/arm/kvm/guest.c      | 5 -----
 arch/arm64/kvm/guest.c    | 5 -----
 arch/mips/kvm/mips.c      | 5 -----
 arch/powerpc/kvm/book3s.c | 5 -----
 arch/powerpc/kvm/booke.c  | 5 -----
 arch/s390/kvm/kvm-s390.c  | 5 -----
 arch/x86/kvm/x86.c        | 5 -----
 include/linux/kvm_host.h  | 1 -
 virt/kvm/kvm_main.c       | 5 -----
 9 files changed, 41 deletions(-)

diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
index 684cf64b4033..39323d686448 100644
--- a/arch/arm/kvm/guest.c
+++ b/arch/arm/kvm/guest.c
@@ -30,11 +30,6 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ NULL }
 };
 
-int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
-{
-	return 0;
-}
-
 static u64 core_reg_offset_from_id(u64 id)
 {
 	return id & ~(KVM_REG_ARCH_MASK | KVM_REG_SIZE_MASK | KVM_REG_ARM_CORE);
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index dfd626447482..483b02425ec8 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -43,11 +43,6 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ NULL }
 };
 
-int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
-{
-	return 0;
-}
-
 static bool core_reg_offset_is_vreg(u64 off)
 {
 	return off >= KVM_REG_ARM_CORE_REG(fp_regs.vregs) &&
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index b3a4435af66b..06366e2415a6 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -1244,11 +1244,6 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
-{
-	return 0;
-}
-
 static void kvm_mips_set_c0_status(void)
 {
 	u32 status = read_c0_status();
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index fd049ede2487..2f0ca8237db0 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -496,11 +496,6 @@ int kvmppc_load_last_inst(struct kvm_vcpu *vcpu,
 }
 EXPORT_SYMBOL_GPL(kvmppc_load_last_inst);
 
-int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
-{
-	return 0;
-}
-
 int kvmppc_subarch_vcpu_init(struct kvm_vcpu *vcpu)
 {
 	return 0;
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index b1b5073a22b1..35b781775d3d 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -1377,11 +1377,6 @@ static void kvmppc_set_tsr(struct kvm_vcpu *vcpu, u32 new_tsr)
 	update_timer_ints(vcpu);
 }
 
-int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
-{
-	return 0;
-}
-
 int kvmppc_subarch_vcpu_init(struct kvm_vcpu *vcpu)
 {
 	/* setup watchdog timer once */
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 3e3d242d6630..c3c855fd909c 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2934,11 +2934,6 @@ static void kvm_s390_vcpu_setup_model(struct kvm_vcpu *vcpu)
 		vcpu->arch.sie_block->fac = (u32)(u64) model->fac_list;
 }
 
-int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
-{
-	return 0;
-}
-
 static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
 {
 	int rc = 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dbb939bd4949..e320e6f21202 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9037,11 +9037,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
-{
-	return 0;
-}
-
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 {
 	struct msr_data msr;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c36379824408..0b8b0f0ab4d7 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -854,7 +854,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id);
 int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu);
-int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4a4d2992d915..1ae98c1f12b0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2678,10 +2678,6 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	if (r)
 		goto vcpu_uninit;
 
-	r = kvm_arch_vcpu_setup(vcpu);
-	if (r)
-		goto vcpu_destroy;
-
 	kvm_create_vcpu_debugfs(vcpu);
 
 	mutex_lock(&kvm->lock);
@@ -2716,7 +2712,6 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 unlock_vcpu_destroy:
 	mutex_unlock(&kvm->lock);
 	debugfs_remove_recursive(vcpu->debugfs_dentry);
-vcpu_destroy:
 	kvm_arch_vcpu_destroy(vcpu);
 vcpu_uninit:
 	kvm_vcpu_uninit(vcpu);
-- 
2.22.0

