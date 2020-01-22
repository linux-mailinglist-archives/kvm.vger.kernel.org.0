Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF5C145969
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 17:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729058AbgAVQIc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 11:08:32 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22474 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728655AbgAVQIN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jan 2020 11:08:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579709291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P+KDRGIU4sIqYrTCFGRumDg7Ht4/WtmtQGbhXNlfXQ0=;
        b=Wqn01jhUXTl24hBQZ1iIpfETXJz2LdTJKNodIpaT6vI3Vi+Swha1jKCh1SGX1AkUVKJGHl
        auLXlz07yzIFaLdZg9PuXJ2dWVDoHFTBIiSE14wo45hg0O3a2N9HMbs7ne9wJS2L88VdWV
        +ZdOfw4Bu7yuasIwvFUvhTjCD0In4pA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-JxM0FDyyPyyBLCihAE47iQ-1; Wed, 22 Jan 2020 11:08:08 -0500
X-MC-Unique: JxM0FDyyPyyBLCihAE47iQ-1
Received: by mail-wr1-f70.google.com with SMTP id w6so3300267wrm.16
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2020 08:08:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P+KDRGIU4sIqYrTCFGRumDg7Ht4/WtmtQGbhXNlfXQ0=;
        b=TS+QCsdIFSGQeVsixVmbLwG+oGEL/1Dl4lKgcpY+//ybE2648h3hrairlMNAxfzz2R
         HLJMgA9brzYDyE589qQkZtnnTuypgKaUiEMrYTqz1wicFGol+kfT72eOeuxdqnkfluUR
         GQ5VXAUBvjQ/pVUj62pbe33n5aSeJwrgaAdGpepUFk015C6wTt0Y64I2NLQslGDu4DDD
         CBVaGxz6ye4yPbwo1ZBOY4UZrhFAqwaF8YCLQWOZiudh85qDTbaHqi4DM3RafrVNLc+n
         NpQXfKo1dIIcoab6m7xB3xOP4XE7irP2bERnQ2QZTOw6gl/Aw14kI3w2MansXebrNRhr
         v9Qg==
X-Gm-Message-State: APjAAAWAF5oFInETPIYNHtz9AoFc/+OzWlXRpT/DFd43aS147PxDanfB
        zT/I0yHMTza2jwWvzzrGxbuSqT24TQJ+2ZYle8tDnL0RLIutKd9g0jQUQMiWDZU2FZaBrYNiwvd
        DaTnVabQzhvpF
X-Received: by 2002:a5d:4847:: with SMTP id n7mr11892307wrs.30.1579709287247;
        Wed, 22 Jan 2020 08:08:07 -0800 (PST)
X-Google-Smtp-Source: APXvYqx1jrFrBWzdZZ+bxB+IeNrbAk/kSCOdz3k+GgU9ykZ+OKOTuhLTPyedfuGR5bYJvxBe4XTTAQ==
X-Received: by 2002:a5d:4847:: with SMTP id n7mr11892272wrs.30.1579709286789;
        Wed, 22 Jan 2020 08:08:06 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b8fe:679e:87eb:c059? ([2001:b07:6468:f312:b8fe:679e:87eb:c059])
        by smtp.gmail.com with ESMTPSA id i11sm59447911wrs.10.2020.01.22.08.08.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2020 08:08:06 -0800 (PST)
Subject: Re: [PATCH v5 00/18] kvm: x86: Support AMD SVM AVIC w/ in-kernel
 irqchip mode
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, joro@8bytes.org, vkuznets@redhat.com,
        rkagan@virtuozzo.com, graf@amazon.com, jschoenh@amazon.de,
        karahmed@amazon.de, rimasluk@amazon.com, jon.grimm@amd.com
References: <1573762520-80328-1-git-send-email-suravee.suthikulpanit@amd.com>
 <9e3e9692-d786-844e-c625-62b69505d2c9@amd.com>
 <b4fa2422-f479-e1e4-11c6-5a4dfda53b74@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <aeed73a9-5ef0-4c11-48cd-c36837536e51@redhat.com>
Date:   Wed, 22 Jan 2020 17:08:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <b4fa2422-f479-e1e4-11c6-5a4dfda53b74@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/01/20 07:16, Suravee Suthikulpanit wrote:
> Ping
> 
> Thanks
> Suravee

Queued it, finally.  Sorry for the wait.

Paolo

> On 1/2/20 5:17 PM, Suravee Suthikulpanit wrote:
>> Paolo,
>>
>> Ping. Would you please let me know your feedback when you get a chance
>> to review this series
>>
>> Thanks,
>> Suravee
>>
>> On 11/15/19 3:15 AM, Suravee Suthikulpanit wrote:
>>> The 'commit 67034bb9dd5e ("KVM: SVM: Add irqchip_split() checks before
>>> enabling AVIC")' was introduced to fix miscellaneous boot-hang issues
>>> when enable AVIC. This is mainly due to AVIC hardware doest not #vmexit
>>> on write to LAPIC EOI register resulting in-kernel PIC and IOAPIC to
>>> wait and do not inject new interrupts (e.g. PIT, RTC).
>>>
>>> This limits AVIC to only work with kernel_irqchip=split mode, which is
>>> not currently enabled by default, and also required user-space to
>>> support split irqchip model, which might not be the case.
>>>
>>> The goal of this series is to enable AVIC to work in both irqchip modes,
>>> by allowing AVIC to be deactivated temporarily during runtime, and
>>> fallback
>>> to legacy interrupt injection mode (w/ vINTR and interrupt windows)
>>> when needed, and then re-enabled subsequently (a.k.a Dynamic APICv).
>>>
>>> Similar approach is also used to handle Hyper-V SynIC in the
>>> 'commit 5c919412fe61 ("kvm/x86: Hyper-V synthetic interrupt
>>> controller")',
>>> where APICv is permanently disabled at runtime (currently broken for
>>> AVIC, and fixed by this series).
>>>
>>> This series contains several parts:
>>>    * Part 1: patch 1,2
>>>      Code clean up, refactor, and introduce helper functions
>>>
>>>    * Part 2: patch 3
>>>      Introduce APICv deactivate bits to keep track of APICv state
>>>      for each vm.
>>>    * Part 3: patch 4-10
>>>      Add support for activate/deactivate APICv at runtime
>>>
>>>    * Part 4: patch 11-14:
>>>      Add support for various cases where APICv needs to
>>>      be deactivated
>>>
>>>    * Part 5: patch 15-17:
>>>      Introduce in-kernel IOAPIC workaround for AVIC EOI
>>>
>>>    * Part 6: path 18
>>>      Allow enable AVIC w/ kernel_irqchip=on
>>>
>>> Pre-requisite Patch:
>>>    * commit b9c6ff94e43a ("iommu/amd: Re-factor guest virtual APIC
>>> (de-)activation code")
>>>     
>>> (https://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git/commit/
>>>       ?h=next&id=b9c6ff94e43a0ee053e0c1d983fba1ac4953b762)
>>>
>>> This series has been tested against v5.3 as following:
>>>    * Booting Linux, FreeBSD, and Windows Server 2019 VMs upto 240 vcpus
>>>      w/ qemu option "kernel-irqchip=on" and "-no-hpet".
>>>    * Pass-through Intel 10GbE NIC and run netperf in the VM.
>>>
>>> Changes from V4: (https://lkml.org/lkml/2019/11/1/764)
>>>    * Rename APICV_DEACT_BIT_xxx to APICV_INHIBIT_REASON_xxxx
>>>    * Introduce kvm_x86_ops.check_apicv_inhibit_reasons hook
>>>      to allow vendors to specify which APICv inhibit reason bits
>>>      to support (patch 08/18).
>>>    * Update comment on kvm_request_apicv_update() no-lock requirement.
>>>      (patch 04/18)
>>>
>>> Suravee Suthikulpanit (18):
>>>    kvm: x86: Modify kvm_x86_ops.get_enable_apicv() to use struct kvm
>>>      parameter
>>>    kvm: lapic: Introduce APICv update helper function
>>>    kvm: x86: Introduce APICv inhibit reason bits
>>>    kvm: x86: Add support for dynamic APICv
>>>    kvm: x86: Add APICv (de)activate request trace points
>>>    kvm: x86: svm: Add support to (de)activate posted interrupts
>>>    svm: Add support for setup/destroy virutal APIC backing page for AVIC
>>>    kvm: x86: Introduce APICv x86 ops for checking APIC inhibit reasons
>>>    kvm: x86: Introduce x86 ops hook for pre-update APICv
>>>    svm: Add support for dynamic APICv
>>>    kvm: x86: hyperv: Use APICv update request interface
>>>    svm: Deactivate AVIC when launching guest with nested SVM support
>>>    svm: Temporary deactivate AVIC during ExtINT handling
>>>    kvm: i8254: Deactivate APICv when using in-kernel PIT re-injection
>>>      mode.
>>>    kvm: lapic: Clean up APIC predefined macros
>>>    kvm: ioapic: Refactor kvm_ioapic_update_eoi()
>>>    kvm: ioapic: Lazy update IOAPIC EOI
>>>    svm: Allow AVIC with in-kernel irqchip mode
>>>
>>>   arch/x86/include/asm/kvm_host.h |  19 ++++-
>>>   arch/x86/kvm/hyperv.c           |   5 +-
>>>   arch/x86/kvm/i8254.c            |  12 +++
>>>   arch/x86/kvm/ioapic.c           | 149
>>> +++++++++++++++++++++++-------------
>>>   arch/x86/kvm/lapic.c            |  35 +++++----
>>>   arch/x86/kvm/lapic.h            |   2 +
>>>   arch/x86/kvm/svm.c              | 164
>>> +++++++++++++++++++++++++++++++++++-----
>>>   arch/x86/kvm/trace.h            |  19 +++++
>>>   arch/x86/kvm/vmx/vmx.c          |  12 ++-
>>>   arch/x86/kvm/x86.c              |  71 ++++++++++++++---
>>>   10 files changed, 385 insertions(+), 103 deletions(-)
>>>
> 

