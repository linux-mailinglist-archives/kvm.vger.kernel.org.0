Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6002B77C367
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 00:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbjHNWZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 18:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233042AbjHNWZB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 18:25:01 -0400
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD50E52
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 15:24:59 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1qVfza-00FT1M-3S
        for kvm@vger.kernel.org; Tue, 15 Aug 2023 00:24:54 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From;
        bh=iZ9lKV1GffjqsGNbLBWaGES4/pz7b1nyIfHnqt60RVw=; b=Wnl/f72WJBos2b6fwC1vZs0ZKJ
        uku+uUY4bMnnn9DOKaEJyW1cQQ5ljAJGBzaRE7r/jQSCTLd7moe+QyL8lT9Y+anw1NmfZjkZykLNi
        AMPdpjnWLc52hJYxI4YRF//S33V3tcTqt5Tzo1rQGIXaKNrUzGS4koLBDau5cdrwcN+8zQAYJzRcj
        ZEC3wXHp+bXNv6D1Dm6HsTCd2fDUb1XIa34PDn/9k30Jc0cRsBKwu4MwE/8KeYJscqcPYYODLv7iH
        t3yTDGkZKk0G+NkqtwkWaYBUXrTbCjrWyWSVN5PbzbQOoW5HIkFWgamjC8wEZVDiWElkJWnKgGdWs
        vVL0qaVA==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1qVfzZ-0003wY-PK; Tue, 15 Aug 2023 00:24:53 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1qVfzH-00077S-FE; Tue, 15 Aug 2023 00:24:35 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net
Cc:     kvm@vger.kernel.org, Michal Luczaj <mhal@rbox.co>
Subject: [PATCH 3/3] KVM: Correct kvm_vcpu_event(s) typo in KVM API documentation
Date:   Tue, 15 Aug 2023 00:08:37 +0200
Message-ID: <20230814222358.707877-4-mhal@rbox.co>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230814222358.707877-1-mhal@rbox.co>
References: <20230814222358.707877-1-mhal@rbox.co>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set KVM_GET_VCPU_EVENTS and KVM_SET_VCPU_EVENTS parameter type to
`struct kvm_vcpu_events`. Events, plural.

Opportunistically fix few other typos.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
I understand that typo fixes are not always welcomed, but this
kvm_vcpu_event(s) did actually bit me, causing minor irritation.

 Documentation/virt/kvm/api.rst | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index c0ddd3035462..b7176e4609ee 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -540,7 +540,7 @@ ioctl is useful if the in-kernel PIC is not used.
 PPC:
 ^^^^
 
-Queues an external interrupt to be injected. This ioctl is overleaded
+Queues an external interrupt to be injected. This ioctl is overloaded
 with 3 different irq values:
 
 a) KVM_INTERRUPT_SET
@@ -578,7 +578,7 @@ This is an asynchronous vcpu ioctl and can be invoked from any thread.
 RISC-V:
 ^^^^^^^
 
-Queues an external interrupt to be injected into the virutal CPU. This ioctl
+Queues an external interrupt to be injected into the virtual CPU. This ioctl
 is overloaded with 2 different irq values:
 
 a) KVM_INTERRUPT_SET
@@ -965,7 +965,7 @@ be set in the flags field of this ioctl:
 The KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL flag requests KVM to generate
 the contents of the hypercall page automatically; hypercalls will be
 intercepted and passed to userspace through KVM_EXIT_XEN.  In this
-ase, all of the blob size and address fields must be zero.
+case, all of the blob size and address fields must be zero.
 
 The KVM_XEN_HVM_CONFIG_EVTCHN_SEND flag indicates to KVM that userspace
 will always use the KVM_XEN_HVM_EVTCHN_SEND ioctl to deliver event
@@ -1070,7 +1070,7 @@ Other flags returned by ``KVM_GET_CLOCK`` are accepted but ignored.
 :Extended by: KVM_CAP_INTR_SHADOW
 :Architectures: x86, arm64
 :Type: vcpu ioctl
-:Parameters: struct kvm_vcpu_event (out)
+:Parameters: struct kvm_vcpu_events (out)
 :Returns: 0 on success, -1 on error
 
 X86:
@@ -1193,7 +1193,7 @@ directly to the virtual CPU).
 :Extended by: KVM_CAP_INTR_SHADOW
 :Architectures: x86, arm64
 :Type: vcpu ioctl
-:Parameters: struct kvm_vcpu_event (in)
+:Parameters: struct kvm_vcpu_events (in)
 :Returns: 0 on success, -1 on error
 
 X86:
@@ -2722,7 +2722,7 @@ The isa config register can be read anytime but can only be written before
 a Guest VCPU runs. It will have ISA feature bits matching underlying host
 set by default.
 
-RISC-V core registers represent the general excution state of a Guest VCPU
+RISC-V core registers represent the general execution state of a Guest VCPU
 and it has the following id bit patterns::
 
   0x8020 0000 02 <index into the kvm_riscv_core struct:24> (32bit Host)
@@ -3061,7 +3061,7 @@ as follow::
    };
 
 An entry with a "page_shift" of 0 is unused. Because the array is
-organized in increasing order, a lookup can stop when encoutering
+organized in increasing order, a lookup can stop when encountering
 such an entry.
 
 The "slb_enc" field provides the encoding to use in the SLB for the
@@ -3453,7 +3453,7 @@ Possible features:
 	      - KVM_RUN and KVM_GET_REG_LIST are not available;
 
 	      - KVM_GET_ONE_REG and KVM_SET_ONE_REG cannot be used to access
-	        the scalable archietctural SVE registers
+	        the scalable architectural SVE registers
 	        KVM_REG_ARM64_SVE_ZREG(), KVM_REG_ARM64_SVE_PREG() or
 	        KVM_REG_ARM64_SVE_FFR;
 
@@ -4399,7 +4399,7 @@ This will have undefined effects on the guest if it has not already
 placed itself in a quiescent state where no vcpu will make MMU enabled
 memory accesses.
 
-On succsful completion, the pending HPT will become the guest's active
+On successful completion, the pending HPT will become the guest's active
 HPT and the previous HPT will be discarded.
 
 On failure, the guest will still be operating on its previous HPT.
@@ -5014,7 +5014,7 @@ before the vcpu is fully usable.
 
 Between KVM_ARM_VCPU_INIT and KVM_ARM_VCPU_FINALIZE, the feature may be
 configured by use of ioctls such as KVM_SET_ONE_REG.  The exact configuration
-that should be performaned and how to do it are feature-dependent.
+that should be performed and how to do it are feature-dependent.
 
 Other calls that depend on a particular feature being finalized, such as
 KVM_RUN, KVM_GET_REG_LIST, KVM_GET_ONE_REG and KVM_SET_ONE_REG, will fail with
@@ -5232,7 +5232,7 @@ KVM_PV_DISABLE
   Deregister the VM from the Ultravisor and reclaim the memory that had
   been donated to the Ultravisor, making it usable by the kernel again.
   All registered VCPUs are converted back to non-protected ones. If a
-  previous protected VM had been prepared for asynchonous teardown with
+  previous protected VM had been prepared for asynchronous teardown with
   KVM_PV_ASYNC_CLEANUP_PREPARE and not subsequently torn down with
   KVM_PV_ASYNC_CLEANUP_PERFORM, it will be torn down in this call
   together with the current protected VM.
@@ -5473,7 +5473,7 @@ KVM_XEN_ATTR_TYPE_EVTCHN
   from the guest. A given sending port number may be directed back to
   a specified vCPU (by APIC ID) / port / priority on the guest, or to
   trigger events on an eventfd. The vCPU and priority can be changed
-  by setting KVM_XEN_EVTCHN_UPDATE in a subsequent call, but but other
+  by setting KVM_XEN_EVTCHN_UPDATE in a subsequent call, but other
   fields cannot change for a given sending port. A port mapping is
   removed by using KVM_XEN_EVTCHN_DEASSIGN in the flags field. Passing
   KVM_XEN_EVTCHN_RESET in the flags field removes all interception of
@@ -6263,7 +6263,7 @@ to the byte array.
 
 It is strongly recommended that userspace use ``KVM_EXIT_IO`` (x86) or
 ``KVM_EXIT_MMIO`` (all except s390) to implement functionality that
-requires a guest to interact with host userpace.
+requires a guest to interact with host userspace.
 
 .. note:: KVM_EXIT_IO is significantly faster than KVM_EXIT_MMIO.
 
@@ -7510,7 +7510,7 @@ APIC/MSRs/etc).
           attribute is not supported by KVM.
 
 KVM_CAP_SGX_ATTRIBUTE enables a userspace VMM to grant a VM access to one or
-more priveleged enclave attributes.  args[0] must hold a file handle to a valid
+more privileged enclave attributes.  args[0] must hold a file handle to a valid
 SGX attribute file corresponding to an attribute that is supported/restricted
 by KVM (currently only PROVISIONKEY).
 
@@ -7928,7 +7928,7 @@ writing to the respective MSRs.
 
 This capability indicates that userspace can load HV_X64_MSR_VP_INDEX msr.  Its
 value is used to denote the target vcpu for a SynIC interrupt.  For
-compatibilty, KVM initializes this msr to KVM's internal vcpu index.  When this
+compatibility, KVM initializes this msr to KVM's internal vcpu index.  When this
 capability is absent, userspace can still query this msr's value.
 
 8.13 KVM_CAP_S390_AIS_MIGRATION
@@ -8286,7 +8286,7 @@ the KVM_XEN_ATTR_TYPE_RUNSTATE_UPDATE_FLAG attribute in the KVM_XEN_SET_ATTR
 and KVM_XEN_GET_ATTR ioctls. This controls whether KVM will set the
 XEN_RUNSTATE_UPDATE flag in guest memory mapped vcpu_runstate_info during
 updates of the runstate information. Note that versions of KVM which support
-the RUNSTATE feature above, but not thie RUNSTATE_UPDATE_FLAG feature, will
+the RUNSTATE feature above, but not the RUNSTATE_UPDATE_FLAG feature, will
 always set the XEN_RUNSTATE_UPDATE flag when updating the guest structure,
 which is perhaps counterintuitive. When this flag is advertised, KVM will
 behave more correctly, not using the XEN_RUNSTATE_UPDATE flag until/unless
@@ -8335,7 +8335,7 @@ Architectures: x86
 
 When enabled, KVM will disable emulated Hyper-V features provided to the
 guest according to the bits Hyper-V CPUID feature leaves. Otherwise, all
-currently implmented Hyper-V features are provided unconditionally when
+currently implemented Hyper-V features are provided unconditionally when
 Hyper-V identification is set in the HYPERV_CPUID_INTERFACE (0x40000001)
 leaf.
 
-- 
2.41.0

