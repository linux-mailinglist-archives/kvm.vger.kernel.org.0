Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E48F3B67D3
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 19:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234555AbhF1RnZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 13:43:25 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:47081 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232719AbhF1RnY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Jun 2021 13:43:24 -0400
X-Greylist: delayed 539 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jun 2021 13:43:24 EDT
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id B0F1019408F3;
        Mon, 28 Jun 2021 13:32:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 28 Jun 2021 13:32:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=GWKq2EyJGwGZbgi4ujs6lIVnpbb6K31l1aQySTXp12c=; b=hC/hWktO
        AKMbHlUg1ay7CUnrkVH9nFt3Dg3L+QPhHGGNmKdG6a3y1xQ+KBCEZBbcBK68kvpf
        WdM9rn2uhZt3fNnVy0iOHszi+GXQAcHKhItX9PczqhtJE9g4ER2nH4lF2lgjmSwP
        fvgs2UCKohL4878EUKTUU+75qcCvjuC2LsTC7fCukKNAaLg5bkhLccwzubJGXhsP
        bAgueFkxavCy4K+mGHuBx4e+7JKfEd1mCgU9j6N7zLOimIr1JJNuWW+HF1wrnyim
        T94Mqi/zUqH8t3xv62tMDNhUTJkyRNXpdsDzY3Opvxp6dHiLTf6I4xJgeMLQ/ABo
        YwQcGD/njiVgrg==
X-ME-Sender: <xms:kAfaYDECftFZM83hJLYUV4M5iSdTioQ83aB8JfbGsyM8D3hqn37s0Q>
    <xme:kAfaYAURwTPBhlVMjY13A8UtXsrQwNsmDiM-54X_OKHe95rdbke4Wc-KS3rvTEFpo
    9aUSUv31T3blcndexg>
X-ME-Received: <xmr:kAfaYFIVe3wA3Ec1G7mhMgbJYHmekUtroB0FV0QxIyMUYRu79Bu5BsyviPDT0c0Gdlv6A0WC8Vr5S_djah4ceKrv5t2B6RlhZvdvLSqej0c>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeehgedguddufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgrvhhi
    ugcugfgumhhonhgushhonhcuoegurghvihgurdgvughmohhnughsohhnsehorhgrtghlvg
    drtghomheqnecuggftrfgrthhtvghrnhepudefteejgfefhfdtjefhhedtffethfetkeeh
    gfelheffhfeihfeglefgjedtheeknecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomhepuggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrdgt
    ohhm
X-ME-Proxy: <xmx:kAfaYBEsC54ZY4eqI7Fm1K0j5uwogr18yWOXd2Hny7QF5W4cE96lYQ>
    <xmx:kAfaYJXNSO42acLSvmEDNreHuXUHOtXODke6qZqSB93XSjV7D-XWww>
    <xmx:kAfaYMMC9hk1u2m9stR8p4g-z0DcWZYqNBOl1k6nVRxRWvOJ92bHPw>
    <xmx:kwfaYCPvAaotylDdxU-IVKkQRTHp1Zt31zYZc3d3V77kZOhzBsi6UcrLqyo>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Jun 2021 13:31:59 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 9a1db742;
        Mon, 28 Jun 2021 17:31:52 +0000 (UTC)
From:   David Edmondson <david.edmondson@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        David Edmondson <david.edmondson@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH 2/2] KVM: x86: On emulation failure, convey the exit reason to userspace
Date:   Mon, 28 Jun 2021 18:31:52 +0100
Message-Id: <20210628173152.2062988-3-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628173152.2062988-1-david.edmondson@oracle.com>
References: <20210628173152.2062988-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To aid in debugging.

Suggested-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 arch/x86/kvm/x86.c       | 23 +++++++++++++++++------
 include/uapi/linux/kvm.h |  2 ++
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8166ad113fb2..48ef0dc68faf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7455,7 +7455,7 @@ void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip)
 }
 EXPORT_SYMBOL_GPL(kvm_inject_realmode_interrupt);
 
-static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
+static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu, uint64_t flags)
 {
 	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
 	u32 insn_size = ctxt->fetch.end - ctxt->fetch.data;
@@ -7466,7 +7466,8 @@ static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
 	run->emulation_failure.ndata = 0;
 	run->emulation_failure.flags = 0;
 
-	if (insn_size) {
+	if (insn_size &&
+	    (flags & KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES)) {
 		run->emulation_failure.ndata = 3;
 		run->emulation_failure.flags |=
 			KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES;
@@ -7476,6 +7477,14 @@ static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
 		memcpy(run->emulation_failure.insn_bytes,
 		       ctxt->fetch.data, insn_size);
 	}
+
+	if (flags & KVM_INTERNAL_ERROR_EMULATION_FLAG_EXIT_REASON) {
+		run->emulation_failure.ndata = 4;
+		run->emulation_failure.flags |=
+			KVM_INTERNAL_ERROR_EMULATION_FLAG_EXIT_REASON;
+		run->emulation_failure.exit_reason =
+			static_call(kvm_x86_get_exit_reason)(vcpu);
+	}
 }
 
 static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
@@ -7492,16 +7501,18 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 
 	if (kvm->arch.exit_on_emulation_error ||
 	    (emulation_type & EMULTYPE_SKIP)) {
-		prepare_emulation_failure_exit(vcpu);
+		prepare_emulation_failure_exit(
+			vcpu,
+			KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES |
+			KVM_INTERNAL_ERROR_EMULATION_FLAG_EXIT_REASON);
 		return 0;
 	}
 
 	kvm_queue_exception(vcpu, UD_VECTOR);
 
 	if (!is_guest_mode(vcpu) && static_call(kvm_x86_get_cpl)(vcpu) == 0) {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-		vcpu->run->internal.ndata = 0;
+		prepare_emulation_failure_exit(
+			vcpu, KVM_INTERNAL_ERROR_EMULATION_FLAG_EXIT_REASON);
 		return 0;
 	}
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 68c9e6d8bbda..3e4126652a67 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -282,6 +282,7 @@ struct kvm_xen_exit {
 
 /* Flags that describe what fields in emulation_failure hold valid data. */
 #define KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES (1ULL << 0)
+#define KVM_INTERNAL_ERROR_EMULATION_FLAG_EXIT_REASON       (1ULL << 1)
 
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
 struct kvm_run {
@@ -404,6 +405,7 @@ struct kvm_run {
 			__u64 flags;
 			__u8  insn_size;
 			__u8  insn_bytes[15];
+			__u64 exit_reason;
 		} emulation_failure;
 		/* KVM_EXIT_OSI */
 		struct {
-- 
2.30.2

