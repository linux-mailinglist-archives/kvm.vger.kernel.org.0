Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 822E537F44A
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 10:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbhEMImB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 May 2021 04:42:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59129 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232079AbhEMIlw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 May 2021 04:41:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620895239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WZsK+qKPcQAiO/A47ll3bdeekl4RbwmCeAxKKWVvfaY=;
        b=gdcqT+2NHvaEj5zg2QsyKRy2+zgYG9n3fSwvhdAM8v54y15Qg86cJYqIZO4DzeAnRNdhB6
        fq/Zso4ZYYo8YX//a/7x/oUK2PO99Tx+b0l6bETd2FHIzRiGXovPoGlWJDk7l+ZM5aZ3Ca
        2xj1Rp20XvZ9V0gyB+3rz0b+46hSYU4=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-532-6O3RN5jjN0-2BMq_v6k6UQ-1; Thu, 13 May 2021 04:40:36 -0400
X-MC-Unique: 6O3RN5jjN0-2BMq_v6k6UQ-1
Received: by mail-ej1-f70.google.com with SMTP id nd10-20020a170907628ab02903a324b229bfso8150738ejc.7
        for <kvm@vger.kernel.org>; Thu, 13 May 2021 01:40:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WZsK+qKPcQAiO/A47ll3bdeekl4RbwmCeAxKKWVvfaY=;
        b=bgeUQ4QsP0El46mlieZT2ivULWhQhosjG88JpCsxtEM0mhD40j8Q51++aamCHcPqxc
         rGF+jAdmdtgpHeA9tGsYahwmQr/l32w4ys4enxCW1iMd+rAh+AzyJ/a0YR8UGlQ9W3te
         Y2sqEqx888DL6JKDIjg24Pyp+jU92xf8rJNw73r9h8Vxw8LyvkJEqaQhQvsN/6fnT9hD
         sZT7svBqr/pA4kp0C8erf3yz819pJtp34myM23CPjhXrwEF9hZSxgeyLnpJTqB5hht19
         9FyQxYiyqVZ0U+SjDE/jqMNUX4OiM/FD4Sj5g9iIUeDR3sZc9ilp4QrfS6bOU5iFbdF5
         HKcA==
X-Gm-Message-State: AOAM530svIskBDxP4l4cPYO7Vp5SWrMUxl35BXF8ZiIeGYt28UP2Vt4k
        5Cu3etjA60unjtd3Wji8YrXRCD8WL1upyN7pXPZKDQ7dzfwkC+yFqATL2AkyYoPMPgZp2Fg8XKs
        izShfIB59C49T
X-Received: by 2002:a17:906:4a13:: with SMTP id w19mr42273025eju.533.1620895233803;
        Thu, 13 May 2021 01:40:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6K8vRNFb6y0DUdI19tOndJ3HXkTDSq+gxvKQqLTXVgseAChfSlfCt4n0s+HUsgRlmlJj0BA==
X-Received: by 2002:a17:906:4a13:: with SMTP id w19mr42273010eju.533.1620895233577;
        Thu, 13 May 2021 01:40:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r25sm1858457edv.78.2021.05.13.01.40.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 May 2021 01:40:32 -0700 (PDT)
To:     Ashish Kalra <ashish.kalra@amd.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Borislav Petkov <bp@alien8.de>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, joro@8bytes.org,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
References: <cover.1619193043.git.ashish.kalra@amd.com>
 <ff68a73e0cdaf89e56add5c8b6e110df881fede1.1619193043.git.ashish.kalra@amd.com>
 <YJvU+RAvetAPT2XY@zn.tnic> <YJv5bjd0xThIahaa@google.com>
 <20210513065703.GA8173@ashkalra_ubuntu_server>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 2/4] mm: x86: Invoke hypercall when page encryption
 status is changed
Message-ID: <237d83a1-914a-95ea-9339-bd3d09b676c5@redhat.com>
Date:   Thu, 13 May 2021 10:40:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210513065703.GA8173@ashkalra_ubuntu_server>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/05/21 08:57, Ashish Kalra wrote:
>>      8. KVM_HC_MAP_GPA_RANGE
>>      -----------------------
>>      :Architecture: x86
>>      :Status: active
>>      :Purpose: Request KVM to map a GPA range with the specified attributes.
>>
>>      a0: the guest physical address of the start page
>>      a1: the number of (4kb) pages (must be contiguous in GPA space)
>>      a2: attributes
>>
>>    where 'attributes' could be something like:
>>
>>      bits  3:0 - preferred page size encoding 0 = 4kb, 1 = 2mb, 2 = 1gb, etc...
>>      bit     4 - plaintext = 0, encrypted = 1
>>      bits 63:5 - reserved (must be zero)
>>
> 
> Ok. Will modify page encryption status hypercall to be compatible with
> the above defined interface.

Great, this is the current state of the host-side patch (untested):

 From df571861e1d47d81a578b4950c704d01a0ed915e Mon Sep 17 00:00:00 2001
From: Ashish Kalra <ashish.kalra@amd.com>
Date: Thu, 15 Apr 2021 15:57:02 +0000
Subject: [PATCH] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall

This hypercall is used by the SEV guest to notify a change in the page
encryption status to the hypervisor. The hypercall should be invoked
only when the encryption attribute is changed from encrypted -> decrypted
and vice versa. By default all guest pages are considered encrypted.

The hypercall exits to userspace to manage the guest shared regions and
integrate with the userspace VMM's migration code.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Steve Rutherford <srutherford@google.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 7fcb2fd38f42..0d2abcad0565 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6891,3 +6891,22 @@ This capability is always enabled.
  This capability indicates that the KVM virtual PTP service is
  supported in the host. A VMM can check whether the service is
  available to the guest on migration.
+
+8.33 KVM_CAP_EXIT_HYPERCALL
+---------------------------
+
+:Capability: KVM_CAP_EXIT_HYPERCALL
+:Architectures: x86
+:Type: vm
+
+This capability, if enabled, will cause KVM to exit to userspace
+with KVM_EXIT_HYPERCALL exit reason to process some hypercalls.
+
+Calling KVM_CHECK_EXTENSION for this capability will return a bitmask
+of hypercalls that can be configured to exit to userspace.
+Right now, the only such hypercall is KVM_HC_PAGE_ENC_STATUS.
+
+The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
+of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
+the hypercalls whose corresponding bit is in the argument, and return
+ENOSYS for the others.
diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
index cf62162d4be2..1e0013d3c972 100644
--- a/Documentation/virt/kvm/cpuid.rst
+++ b/Documentation/virt/kvm/cpuid.rst
@@ -96,6 +96,14 @@ KVM_FEATURE_MSI_EXT_DEST_ID        15          guest checks this feature bit
                                                 before using extended destination
                                                 ID bits in MSI address bits 11-5.
  
+KVM_FEATURE_HC_PAGE_ENC_STATUS     16          guest checks this feature bit before
+                                               using the page encryption state
+                                               hypercall to notify the page state
+                                               change
+
+KVM_FEATURE_MIGRATION_CONTROL      17          guest checks this feature bit before
+                                               using MSR_KVM_MIGRATION_CONTROL
+
  KVM_FEATURE_CLOCKSOURCE_STABLE_BIT 24          host will warn if no guest-side
                                                 per-cpu warps are expected in
                                                 kvmclock
diff --git a/Documentation/virt/kvm/hypercalls.rst b/Documentation/virt/kvm/hypercalls.rst
index ed4fddd364ea..117ff3b27d3c 100644
--- a/Documentation/virt/kvm/hypercalls.rst
+++ b/Documentation/virt/kvm/hypercalls.rst
@@ -169,3 +169,24 @@ a0: destination APIC ID
  
  :Usage example: When sending a call-function IPI-many to vCPUs, yield if
  	        any of the IPI target vCPUs was preempted.
+
+
+8. KVM_HC_PAGE_ENC_STATUS
+-------------------------
+:Architecture: x86
+:Status: active
+:Purpose: Notify the encryption status changes in guest page table (SEV guest)
+
+a0: the guest physical address of the start page
+a1: the number of pages
+a2: page encryption status
+
+   Where:
+	* 1: Page is encrypted
+	* 0: Page is decrypted
+
+**Implementation note**: this hypercall is implemented in userspace via
+the KVM_CAP_EXIT_HYPERCALL capability.  Userspace must enable that capability
+before advertising KVM_FEATURE_HC_PAGE_ENC_STATUS in the guest CPUID.  In
+addition, if the guest supports KVM_FEATURE_MIGRATION_CONTROL, userspace
+must also set up an MSR filter to process writes to MSR_KVM_MIGRATION_CONTROL.
diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
index e37a14c323d2..977936176f36 100644
--- a/Documentation/virt/kvm/msr.rst
+++ b/Documentation/virt/kvm/msr.rst
@@ -376,3 +376,16 @@ data:
  	write '1' to bit 0 of the MSR, this causes the host to re-scan its queue
  	and check if there are more notifications pending. The MSR is available
  	if KVM_FEATURE_ASYNC_PF_INT is present in CPUID.
+
+MSR_KVM_MIGRATION_CONTROL:
+        0x4b564d08
+
+data:
+        This MSR is available if KVM_FEATURE_MIGRATION_CONTROL is present in
+        CPUID.  Bit 0 represents whether live migration of the guest is allowed.
+
+        When a guest is started, bit 0 will be 0 if the guest has encrypted
+        memory and 1 if the guest does not have encrypted memory.  If the
+        guest is communicating page encryption status to the host using the
+        ``KVM_HC_PAGE_ENC_STATUS`` hypercall, it can set bit 0 in this MSR to
+        allow live migration of the guest.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 55efbacfc244..5b9bc8b3db20 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1067,6 +1067,8 @@ struct kvm_arch {
  	u32 user_space_msr_mask;
  	struct kvm_x86_msr_filter __rcu *msr_filter;
  
+	u32 hypercall_exit_enabled;
+
  	/* Guest can access the SGX PROVISIONKEY. */
  	bool sgx_provisioning_allowed;
  
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 950afebfba88..cff18b8b6dec 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -33,6 +33,8 @@
  #define KVM_FEATURE_PV_SCHED_YIELD	13
  #define KVM_FEATURE_ASYNC_PF_INT	14
  #define KVM_FEATURE_MSI_EXT_DEST_ID	15
+#define KVM_FEATURE_HC_PAGE_ENC_STATUS	16
+#define KVM_FEATURE_MIGRATION_CONTROL	17
  
  #define KVM_HINTS_REALTIME      0
  
@@ -54,6 +56,7 @@
  #define MSR_KVM_POLL_CONTROL	0x4b564d05
  #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
  #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
+#define MSR_KVM_MIGRATION_CONTROL	0x4b564d08
  
  struct kvm_steal_time {
  	__u64 steal;
@@ -90,6 +93,8 @@ struct kvm_clock_pairing {
  /* MSR_KVM_ASYNC_PF_INT */
  #define KVM_ASYNC_PF_VEC_MASK			GENMASK(7, 0)
  
+/* MSR_KVM_MIGRATION_CONTROL */
+#define KVM_MIGRATION_READY		(1 << 0)
  
  /* Operations for KVM_HC_MMU_OP */
  #define KVM_MMU_OP_WRITE_PTE            1
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5bd550eaf683..eab7d50eb4e2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -102,6 +102,8 @@ static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
  
  static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
  
+#define KVM_EXIT_HYPERCALL_VALID_MASK (1 << KVM_HC_PAGE_ENC_STATUS)
+
  #define KVM_X2APIC_API_VALID_FLAGS (KVM_X2APIC_API_USE_32BIT_IDS | \
                                      KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK)
  
@@ -3894,6 +3896,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
  	case KVM_CAP_VM_COPY_ENC_CONTEXT_FROM:
  		r = 1;
  		break;
+	case KVM_CAP_EXIT_HYPERCALL:
+		r = KVM_EXIT_HYPERCALL_VALID_MASK;
+		break;
  	case KVM_CAP_SET_GUEST_DEBUG2:
  		return KVM_GUESTDBG_VALID_MASK;
  #ifdef CONFIG_KVM_XEN
@@ -5494,6 +5499,14 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
  		break;
  	}
  #endif
+	case KVM_CAP_EXIT_HYPERCALL:
+		if (cap->args[0] & ~KVM_EXIT_HYPERCALL_VALID_MASK) {
+			r = -EINVAL;
+			break;
+		}
+		kvm->arch.hypercall_exit_enabled = cap->args[0];
+		r = 0;
+		break;
  	case KVM_CAP_VM_COPY_ENC_CONTEXT_FROM:
  		r = -EINVAL;
  		if (kvm_x86_ops.vm_copy_enc_context_from)
@@ -8384,6 +8397,16 @@ static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
  	return;
  }
  
+static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
+{
+	u64 ret = vcpu->run->hypercall.ret;
+	if (!is_64_bit_mode(vcpu))
+		ret = (u32)ret;
+	kvm_rax_write(vcpu, ret);
+	++vcpu->stat.hypercalls;
+	return kvm_skip_emulated_instruction(vcpu);
+}
+
  int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
  {
  	unsigned long nr, a0, a1, a2, a3, ret;
@@ -8449,6 +8472,28 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
  		kvm_sched_yield(vcpu, a0);
  		ret = 0;
  		break;
+	case KVM_HC_PAGE_ENC_STATUS: {
+		u64 gpa = a0, npages = a1, enc = a2;
+
+		ret = -KVM_ENOSYS;
+		if (!(vcpu->kvm->arch.hypercall_exit_enabled & (1 << KVM_HC_PAGE_ENC_STATUS)))
+			break;
+
+		if (!PAGE_ALIGNED(gpa) || !npages ||
+		    gpa_to_gfn(gpa) + npages <= gpa_to_gfn(gpa)) {
+			ret = -KVM_EINVAL;
+			break;
+		}
+
+		vcpu->run->exit_reason        = KVM_EXIT_HYPERCALL;
+		vcpu->run->hypercall.nr       = KVM_HC_PAGE_ENC_STATUS;
+		vcpu->run->hypercall.args[0]  = gpa;
+		vcpu->run->hypercall.args[1]  = npages;
+		vcpu->run->hypercall.args[2]  = enc;
+		vcpu->run->hypercall.longmode = op_64_bit;
+		vcpu->arch.complete_userspace_io = complete_hypercall_exit;
+		return 0;
+	}
  	default:
  		ret = -KVM_ENOSYS;
  		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 3fd9a7e9d90c..1fb4fd863324 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1082,6 +1082,7 @@ struct kvm_ppc_resize_hpt {
  #define KVM_CAP_SGX_ATTRIBUTE 196
  #define KVM_CAP_VM_COPY_ENC_CONTEXT_FROM 197
  #define KVM_CAP_PTP_KVM 198
+#define KVM_CAP_EXIT_HYPERCALL 199
  
  #ifdef KVM_CAP_IRQ_ROUTING
  
diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
index 8b86609849b9..847b83b75dc8 100644
--- a/include/uapi/linux/kvm_para.h
+++ b/include/uapi/linux/kvm_para.h
@@ -29,6 +29,7 @@
  #define KVM_HC_CLOCK_PAIRING		9
  #define KVM_HC_SEND_IPI		10
  #define KVM_HC_SCHED_YIELD		11
+#define KVM_HC_PAGE_ENC_STATUS		12
  
  /*
   * hypercalls use architecture specific

