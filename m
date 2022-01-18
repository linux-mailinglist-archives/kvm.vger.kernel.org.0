Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85D0492B4E
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 17:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243676AbiARQeQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 11:34:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35033 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232580AbiARQeQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 11:34:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642523655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NDRBcK1YMu+yeTrzNGtn5hFI5coY1/6IuTgKRbLDusA=;
        b=RB5Ou/RGPAFl9LLky2IArTvCobg/eTHWLbPZ5soC2wVq8x6VclhcMLk2MUo67YzG1+munT
        RExO0R/6SMt23PpIFsqvXwCEcV+B1h4a8kwVfiuhJCCp+Y5hZdn3VULvWY5eLHebipDuyA
        a1yvYNqi4VEXqPMVXRAKXH8ZG1FsJbg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-624-LV5yYxRqMmOq7pN4ibDbWw-1; Tue, 18 Jan 2022 11:34:13 -0500
X-MC-Unique: LV5yYxRqMmOq7pN4ibDbWw-1
Received: by mail-wm1-f71.google.com with SMTP id bg16-20020a05600c3c9000b0034bea12c043so2205047wmb.7
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 08:34:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=NDRBcK1YMu+yeTrzNGtn5hFI5coY1/6IuTgKRbLDusA=;
        b=PbXwEQBfcDVfwi1QGh2BF35FL+84CxAe2uAVUZC3/GzPljzMlNWGNP5Gwv0l8JAXyM
         k//Yw0zMYlE5VdGENwJSDXeQhbuDa3CtelRyBD7+GBIHnheS/0TDGqyNMPnhbukZQbIB
         MxPERewqV0UzzSkOvxQCE7f56oPh4xkBOF9+2nQ9jxcxFRLyKCxhidxrPTakgn+zbhYI
         h2f3P6zA/IE9tT9g475UKe1MO94r93whU5ykRqNEBFGzw1KV9Nkj+eBQd9ICIKcHpIdZ
         NXEmtQJLc4walb9zjUOau4QzHRKfMBZcsXkXa5WSW4DAr5E+rNZRqym7pIOlA+CdJPSc
         VTXA==
X-Gm-Message-State: AOAM531zKD9g2EiCxasMm+d0LKZEqiVFkyhyiiStUlPICvoHeRJEouOX
        zhe8QBKfIS5t0H+2aA6+YO+vzO3AwTEwBWtbjBdoa8/acnr4ehdIjrGMgf2zgXyoS0v/zvQwYlW
        rOMsFF8Jaakh+
X-Received: by 2002:adf:fc90:: with SMTP id g16mr25634956wrr.699.1642523651225;
        Tue, 18 Jan 2022 08:34:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxakAAHpFv9j8JH43Ek867/dZJS9LmnS10c9F0qAH99L9AYcFIRgVmADvv/nkkqfUuJfrraNg==
X-Received: by 2002:adf:fc90:: with SMTP id g16mr25634925wrr.699.1642523650947;
        Tue, 18 Jan 2022 08:34:10 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id o5sm2743792wmc.39.2022.01.18.08.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 08:34:10 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Igor Mammedov <imammedo@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] KVM: x86: Partially allow KVM_SET_CPUID{,2}
 after KVM_RUN for CPU hotplug
In-Reply-To: <20220118153531.11e73048@redhat.com>
References: <20220117150542.2176196-1-vkuznets@redhat.com>
 <20220118153531.11e73048@redhat.com>
Date:   Tue, 18 Jan 2022 17:34:09 +0100
Message-ID: <87ee55knpa.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Igor Mammedov <imammedo@redhat.com> writes:

> On Mon, 17 Jan 2022 16:05:38 +0100
> Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
>> Changes since v1:
>> - Drop the allowlist of items which were allowed to change and just allow
>> the exact same CPUID data [Sean, Paolo]. Adjust selftest accordingly.
>> - Drop PATCH1 as the exact same change got merged upstream.
>> 
>> Recently, KVM made it illegal to change CPUID after KVM_RUN but
>> unfortunately this change is not fully compatible with existing VMMs.
>> In particular, QEMU reuses vCPU fds for CPU hotplug after unplug and it
>> calls KVM_SET_CPUID2. Relax the requirement by implementing an allowing
>> KVM_SET_CPUID{,2} with the exact same data.
>
>
> Can you check following scenario:
>  * on host that has IA32_TSX_CTRL and TSX enabled (RTM/HLE cpuid bits present)
>  * boot 2 vcpus VM with TSX enabled on VMM side but with tsx=off on kernel CLI
>
>      that should cause kernel to set MSR_IA32_TSX_CTRL to 3H from initial 0H
>      and clear RTM+HLE bits in CPUID, check that RTM/HLE cpuid it
>      cleared

Forgive me my ignorance around (not only) TSX :-) I took a "Intel(R)
Xeon(R) CPU E3-1270 v5 @ 3.60GHz" host which seems to have rtm/hle and
booted a guest with 'cpu=host' and with (and without) 'tsx=off' on the
kernel command line. I decided to check what's is MSR_IA32_TSX_CTRL but
I see the following:

# rdmsr 0x122
rdmsr: CPU 0 cannot read MSR 0x00000122

I tried adding 'tsx_ctrl' to my QEMU command line but it complains with
qemu-system-x86_64: warning: host doesn't support requested feature: MSR(10AH).tsx-ctrl [bit 7]

so I think my host is not good enough :-(

Also, I've looked at tsx_clear_cpuid() but it actually writes to
MSR_TSX_FORCE_ABORT MSR (0x10F), not MSR_IA32_TSX_CTRL so I'm confused.

>
>  * hotunplug a VCPU and then replug it again
>     if IA32_TSX_CTRL is reset to initial state, that should re-enable
>     RTM/HLE cpuid bits and KVM_SET_CPUID2 might fail due to difference

Could you please teach me this kung-fu, I mean hot to unplug a
cold-plugged CPU with QMP? Previoulsy, I only did un-plugging for what
I've hotplugged, something like:

(QEMU) device_add driver=host-x86_64-cpu socket-id=0 core-id=2 thread-id=0 id=cpu2
{"return": {}}
(QEMU) device_del id=cpu2
{"return": {}}

What's the ids of the cold-plugged CPUs?

>
> and as Sean pointed out there might be other non constant leafs,
> where exact match check could leave userspace broken.

Indeed, while testing your suggestion I've stumbled upon
CPUID.(EAX=0x12, ECX=1) (SGX) where we mangle ECX from
kvm_vcpu_after_set_cpuid():

        best = kvm_find_cpuid_entry(vcpu, 0x12, 0x1);
	if (best) {
                best->ecx &= vcpu->arch.guest_supported_xcr0 & 0xffffffff;
		best->edx &= vcpu->arch.guest_supported_xcr0 >> 32;
                best->ecx |= XFEATURE_MASK_FPSSE;
        }

In theory, we should just move this to __kvm_update_cpuid_runtime()...
I'll take a look tomorrow.

-- 
Vitaly

