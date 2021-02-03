Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA3730DF88
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 17:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234721AbhBCQSm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 11:18:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54074 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234796AbhBCQSk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 11:18:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612369032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SJspb3GGWGSsQBsKt5EuVGNQtnP6SAVEqYgsopMjVTo=;
        b=H2huwImZbRRHZGYrXkkuSHjLPS1BX8EzBSYqxFGN13ZtqS0GMnUsZU/9HHt6tmN45oc3yv
        rSj9/4xwhDTlivy3ahHoOJO4+qvhL4aMNOJchLsSgSUQCD60w7CZFxCzGRdrd+ExuvMOts
        79DAodP7cl2uRq6y/eBPd2owBfi1n1c=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-zUTfMt58NQ-WnPVJKaYM3w-1; Wed, 03 Feb 2021 11:17:10 -0500
X-MC-Unique: zUTfMt58NQ-WnPVJKaYM3w-1
Received: by mail-ed1-f71.google.com with SMTP id m18so69720edp.13
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 08:17:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SJspb3GGWGSsQBsKt5EuVGNQtnP6SAVEqYgsopMjVTo=;
        b=i09m6088zn8SHGGjLtroJUKSE0bRbGl6YnbRG9MitxgG9gJPNBAKHgVIrJBBgSNJ0d
         erf4Lu4UPeiUTZlWX71/6Udw72n4gSL6s9usXg1Q9OmB+yn68yot3mImn6NDxa7lCYdj
         FocOwP5Xij2WYqJmQnulfe83EofQf4he7C0yy4OJV5KeuWP/izaCt72GVMz3l2trGbMg
         WZKhypmJ0Elz4ppTXnVou8ot0JgIIUCFBHWIlbsDQRvJ7Co0qtLYVy28k/4SJ+oLiLqL
         Ng3oh1WOhccDDeKiggXpBxEUDO7nrRfZLOfht6YsxxvdgxtnQu3Ayskb8XPDbLQ8iCpm
         qunw==
X-Gm-Message-State: AOAM533DoOwaC5hR1OulWURlhdhbFXNXXf/nsvcH6KDYcY8kUId6P5/T
        s0TUahM7Ky0LPeRUWeMOBEAzKC2jHgyxFiFMi6zjQ8EGwgXrJ2QeTx/XtVZAUn+W4EGh6gZTHv6
        Dum0uJG6ZL58a
X-Received: by 2002:a17:907:3f29:: with SMTP id hq41mr3906057ejc.227.1612369029549;
        Wed, 03 Feb 2021 08:17:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxA3zlfree5XyNXIGtIFf7HDk8HrTdq7JHwkk9NbDIkEF3r0aQtPtK0EB/FK86InkQbi3aDtg==
X-Received: by 2002:a17:907:3f29:: with SMTP id hq41mr3905972ejc.227.1612369028583;
        Wed, 03 Feb 2021 08:17:08 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g3sm1153836edk.75.2021.02.03.08.17.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 08:17:07 -0800 (PST)
Subject: Re: [PATCH v6 19/19] KVM: Add documentation for Xen hypercall and
 shared_info updates
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
References: <20210203150114.920335-1-dwmw2@infradead.org>
 <20210203150114.920335-20-dwmw2@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6ac3412b-68cc-c444-eb10-33675fc5e346@redhat.com>
Date:   Wed, 3 Feb 2021 17:17:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210203150114.920335-20-dwmw2@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/21 16:01, David Woodhouse wrote:
> +If the KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL flag is returned from the
> +KVM_CAP_XEN_HVM check, it may be set in the flags field of this ioctl.
> +This requests KVM to generate the contents of the hypercall page
> +automatically, and also to intercept hypercalls with KVM_EXIT_XEN.
> +In this case, all of the blob size and address fields must be zero.
> +
> +No other flags are currently valid in the struct kvm_xen_hvm_config.

Slight rewording:

  If the KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL flag is returned from the
  KVM_CAP_XEN_HVM check, it may be set in the flags field of this ioctl.
  This requests KVM to generate the contents of the hypercall page
-automatically, and also to intercept hypercalls with KVM_EXIT_XEN.
-In this case, all of the blob size and address fields must be zero.
+automatically; hypercalls will be intercepted and passed to userspace
+through KVM_EXIT_XEN.  In this case, all of the blob size and address
+fields must be zero.

  No other flags are currently valid in the struct kvm_xen_hvm_config.


Paolo

>   4.29 KVM_GET_CLOCK
>   ------------------
> @@ -4831,6 +4838,101 @@ into user space.
>   If a vCPU is in running state while this ioctl is invoked, the vCPU may
>   experience inconsistent filtering behavior on MSR accesses.
>   
> +4.127 KVM_XEN_HVM_SET_ATTR
> +--------------------------
> +
> +:Capability: KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO
> +:Architectures: x86
> +:Type: vm ioctl
> +:Parameters: struct kvm_xen_hvm_attr
> +:Returns: 0 on success, < 0 on error
> +
> +::
> +
> +  struct kvm_xen_hvm_attr {
> +	__u16 type;
> +	__u16 pad[3];
> +	union {
> +		__u8 long_mode;
> +		__u8 vector;
> +		struct {
> +			__u64 gfn;
> +		} shared_info;
> +		__u64 pad[4];
> +	} u;
> +  };
> +
> +type values:
> +
> +KVM_XEN_ATTR_TYPE_LONG_MODE
> +  Sets the ABI mode of the VM to 32-bit or 64-bit (long mode). This
> +  determines the layout of the shared info pages exposed to the VM.
> +
> +KVM_XEN_ATTR_TYPE_SHARED_INFO
> +  Sets the guest physical frame number at which the Xen "shared info"
> +  page resides. Note that although Xen places vcpu_info for the first
> +  32 vCPUs in the shared_info page, KVM does not automatically do so
> +  and instead requires that KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO be used
> +  explicitly even when the vcpu_info for a given vCPU resides at the
> +  "default" location in the shared_info page. This is because KVM is
> +  not aware of the Xen CPU id which is used as the index into the
> +  vcpu_info[] array, so cannot know the correct default location.
> +
> +KVM_XEN_ATTR_TYPE_UPCALL_VECTOR
> +  Sets the exception vector used to deliver Xen event channel upcalls.
> +
> +4.128 KVM_XEN_HVM_GET_ATTR
> +--------------------------
> +
> +:Capability: KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO
> +:Architectures: x86
> +:Type: vm ioctl
> +:Parameters: struct kvm_xen_hvm_attr
> +:Returns: 0 on success, < 0 on error
> +
> +Allows Xen VM attributes to be read. For the structure and types,
> +see KVM_XEN_HVM_SET_ATTR above.
> +
> +4.129 KVM_XEN_VCPU_SET_ATTR
> +---------------------------
> +
> +:Capability: KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO
> +:Architectures: x86
> +:Type: vcpu ioctl
> +:Parameters: struct kvm_xen_vcpu_attr
> +:Returns: 0 on success, < 0 on error
> +
> +::
> +
> +  struct kvm_xen_vcpu_attr {
> +	__u16 type;
> +	__u16 pad[3];
> +	union {
> +		__u64 gpa;
> +		__u64 pad[4];
> +	} u;
> +  };
> +
> +type values:
> +
> +KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO
> +  Sets the guest physical address of the vcpu_info for a given vCPU.
> +
> +KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO
> +  Sets the guest physical address of an additional pvclock structure
> +  for a given vCPU. This is typically used for guest vsyscall support.
> +
> +4.130 KVM_XEN_VCPU_GET_ATTR
> +--------------------------
> +
> +:Capability: KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO
> +:Architectures: x86
> +:Type: vcpu ioctl
> +:Parameters: struct kvm_xen_vcpu_attr
> +:Returns: 0 on success, < 0 on error
> +
> +Allows Xen vCPU attributes to be read. For the structure and types,
> +see KVM_XEN_VCPU_SET_ATTR above.
>   
>   5. The kvm_run structure
>   ========================
> @@ -4996,13 +5098,18 @@ to the byte array.
>   
>   .. note::
>   
> -      For KVM_EXIT_IO, KVM_EXIT_MMIO, KVM_EXIT_OSI, KVM_EXIT_PAPR,
> +      For KVM_EXIT_IO, KVM_EXIT_MMIO, KVM_EXIT_OSI, KVM_EXIT_PAPR, KVM_EXIT_XEN,
>         KVM_EXIT_EPR, KVM_EXIT_X86_RDMSR and KVM_EXIT_X86_WRMSR the corresponding
>         operations are complete (and guest state is consistent) only after userspace
>         has re-entered the kernel with KVM_RUN.  The kernel side will first finish
> -      incomplete operations and then check for pending signals.  Userspace
> -      can re-enter the guest with an unmasked signal pending to complete
> -      pending operations.
> +      incomplete operations and then check for pending signals.
> +
> +      The pending state of the operation is not preserved in state which is
> +      visible to userspace, thus userspace should ensure that the operation is
> +      completed before performing a live migration.  Userspace can re-enter the
> +      guest with an unmasked signal pending or with the immediate_exit field set
> +      to complete pending operations without allowing any further instructions
> +      to be executed.
>   
>   ::
>   
> @@ -5327,6 +5434,34 @@ wants to write. Once finished processing the event, user space must continue
>   vCPU execution. If the MSR write was unsuccessful, user space also sets the
>   "error" field to "1".
>   
> +::
> +
> +
> +		struct kvm_xen_exit {
> +  #define KVM_EXIT_XEN_HCALL          1
> +			__u32 type;
> +			union {
> +				struct {
> +					__u32 longmode;
> +					__u32 cpl;
> +					__u64 input;
> +					__u64 result;
> +					__u64 params[6];
> +				} hcall;
> +			} u;
> +		};
> +		/* KVM_EXIT_XEN */
> +                struct kvm_hyperv_exit xen;
> +
> +Indicates that the VCPU exits into userspace to process some tasks
> +related to Xen emulation.
> +
> +Valid values for 'type' are:
> +
> +  - KVM_EXIT_XEN_HCALL -- synchronously notify user-space about Xen hypercall.
> +    Userspace is expected to place the hypercall result into the appropriate
> +    field before invoking KVM_RUN again.
> +
>   ::
>   
>   		/* Fix the size of the union. */
> @@ -6415,7 +6550,6 @@ guest according to the bits in the KVM_CPUID_FEATURES CPUID leaf
>   (0x40000001). Otherwise, a guest may use the paravirtual features
>   regardless of what has actually been exposed through the CPUID leaf.
>   
> -
>   8.29 KVM_CAP_DIRTY_LOG_RING
>   ---------------------------
>   
> @@ -6502,3 +6636,29 @@ KVM_GET_DIRTY_LOG and KVM_CLEAR_DIRTY_LOG.  After enabling
>   KVM_CAP_DIRTY_LOG_RING with an acceptable dirty ring size, the virtual
>   machine will switch to ring-buffer dirty page tracking and further
>   KVM_GET_DIRTY_LOG or KVM_CLEAR_DIRTY_LOG ioctls will fail.
> +
> +8.30 KVM_CAP_XEN_HVM
> +--------------------
> +
> +:Architectures: x86
> +
> +This capability indicates the features that Xen supports for hosting Xen
> +PVHVM guests. Valid flags are::
> +
> +  #define KVM_XEN_HVM_CONFIG_HYPERCALL_MSR	(1 << 0)
> +  #define KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL	(1 << 1)
> +  #define KVM_XEN_HVM_CONFIG_SHARED_INFO	(1 << 2)
> +
> +The KVM_XEN_HVM_CONFIG_HYPERCALL_MSR flag indicates that the KVM_XEN_HVM_CONFIG
> +ioctl is available, for the guest to set its hypercall page.
> +
> +If KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL is also set, the same flag may also be
> +provided in the flags to KVM_XEN_HVM_CONFIG, without providing hypercall page
> +contents, to request that KVM generate hypercall page content automatically
> +and also enable interception of guest hypercalls with KVM_EXIT_XEN.
> +
> +The KVM_XEN_HVM_CONFIG_SHARED_INFO flag indicates the availability of the
> +KVM_XEN_HVM_SET_ATTR, KVM_XEN_HVM_GET_ATTR, KVM_XEN_VCPU_SET_ATTR and
> +KVM_XEN_VCPU_GET_ATTR ioctls, as well as the delivery of exception vectors
> +for event channel upcalls when the evtchn_upcall_pending field of a vcpu's
> +vcpu_info is set.
> 

