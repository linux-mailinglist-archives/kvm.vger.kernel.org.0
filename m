Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2AF4B539A
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 19:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730740AbfIQRFZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 13:05:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43508 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728507AbfIQRFW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 13:05:22 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 82A124E83C
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 17:05:21 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id t11so1325108wro.10
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 10:05:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t6xejXDOMQ6KuyMfFm1U1GgbUuSpZUSZNER6+lLzGmc=;
        b=pf5it6DeggbuPCjEQcrmWu4RdbLcLv8o6FN8oEeknf75gC1BGf0msEJvsWMjVEmcQJ
         IrogAYjNJaFX7bjzVYcYUemHzJ0hiXl2+7An6uxa+a9Yu2ZgFYFteAKYW9vsIT8VP4gy
         T93Me0UnXaWMPj31M/UNbzhctWZkQ5STEJs6F70ASR4t7U3jJw9jGRh+ADC6XqyNlrHM
         DbdiJCM0Qd0oVBlCFzrQWUim/S5Kpr7ronlKSm+1CZg5HMzkGhknzNaF6GjgvlvyeH9K
         RGUsUI5Cy0CXbiWfpAtweHn2AxeZlRJgu7bnovmXBqtTbR67+SXc97+2AhOYSxTzB830
         c2uQ==
X-Gm-Message-State: APjAAAV7gorMZlzUtlhScHMAL0fbLL69FSUO/rhgp4hCIU+BB8XQUdWx
        6Q4Kv67ElSZpnxg7Hgoao0KODVkoeSClgKWqBs18X6J1zNXkTXUEgq40fVrPk+CgyZixpl+qmNC
        t1/E6AD/tu8Br
X-Received: by 2002:a5d:4d8c:: with SMTP id b12mr3653225wru.198.1568739920067;
        Tue, 17 Sep 2019 10:05:20 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxJ0DbeEHzBFaKEv6qVKXKe/VqIgn8HZlgAzW1WduAOnlbb2RWLukrZ6EHzIuJagKt0d7rRtA==
X-Received: by 2002:a5d:4d8c:: with SMTP id b12mr3653188wru.198.1568739919677;
        Tue, 17 Sep 2019 10:05:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c46c:2acb:d8d2:21d8? ([2001:b07:6468:f312:c46c:2acb:d8d2:21d8])
        by smtp.gmail.com with ESMTPSA id c6sm4140610wrb.60.2019.09.17.10.05.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Sep 2019 10:05:19 -0700 (PDT)
Subject: Re: [PATCH v8 0/3] KVM: x86: Enable user wait instructions
To:     Tao Xu <tao3.xu@intel.com>, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jingqi.liu@intel.com
References: <20190716065551.27264-1-tao3.xu@intel.com>
 <d01e6b8b-279c-84da-1f08-7b01baf9fdbf@intel.com>
 <ad687740-1525-f9c2-b441-63613b7dd93e@redhat.com>
 <ca969df2-a42a-3e7c-f49c-6b59d097b3de@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <a4bbc34c-9a0a-1bfb-2d56-c71a8d9a52c9@redhat.com>
Date:   Tue, 17 Sep 2019 19:05:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <ca969df2-a42a-3e7c-f49c-6b59d097b3de@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/09/19 03:28, Tao Xu wrote:
> On 7/20/2019 1:18 AM, Paolo Bonzini wrote:
>> On 19/07/19 08:31, Tao Xu wrote:
>>> Ping for comments :)
>>
>> Hi, I'll look at it for 5.4, right after the merge window.
>>
>> Paolo
>>
> Hi paolo,
> 
> Linux 5.3 has released, could you review these patches. Thank you very
> much!
> 
> Tao
>>> On 7/16/2019 2:55 PM, Tao Xu wrote:
>>>> UMONITOR, UMWAIT and TPAUSE are a set of user wait instructions.
>>>>
>>>> UMONITOR arms address monitoring hardware using an address. A store
>>>> to an address within the specified address range triggers the
>>>> monitoring hardware to wake up the processor waiting in umwait.
>>>>
>>>> UMWAIT instructs the processor to enter an implementation-dependent
>>>> optimized state while monitoring a range of addresses. The optimized
>>>> state may be either a light-weight power/performance optimized state
>>>> (c0.1 state) or an improved power/performance optimized state
>>>> (c0.2 state).
>>>>
>>>> TPAUSE instructs the processor to enter an implementation-dependent
>>>> optimized state c0.1 or c0.2 state and wake up when time-stamp counter
>>>> reaches specified timeout.
>>>>
>>>> Availability of the user wait instructions is indicated by the presence
>>>> of the CPUID feature flag WAITPKG CPUID.0x07.0x0:ECX[5].
>>>>
>>>> The patches enable the umonitor, umwait and tpause features in KVM.
>>>> Because umwait and tpause can put a (psysical) CPU into a power saving
>>>> state, by default we dont't expose it to kvm and enable it only when
>>>> guest CPUID has it. If the instruction causes a delay, the amount
>>>> of time delayed is called here the physical delay. The physical
>>>> delay is
>>>> first computed by determining the virtual delay (the time to delay
>>>> relative to the VM’s timestamp counter).
>>>>
>>>> The release document ref below link:
>>>> Intel 64 and IA-32 Architectures Software Developer's Manual,
>>>> https://software.intel.com/sites/default/files/\
>>>> managed/39/c5/325462-sdm-vol-1-2abcd-3abcd.pdf
>>>>
>>>> Changelog:
>>>> v8:
>>>>      Add vmx_waitpkg_supported() helper (Sean)
>>>>      Add an accessor to expose umwait_control_cached (Sean)
>>>>      Set msr_ia32_umwait_control in vcpu_vmx u32 and raise #GP when
>>>>      [63:32] is set when rdmsr. (Sean)
>>>>      Introduce a common exit helper handle_unexpected_vmexit (Sean)
>>>> v7:
>>>>      Add nested support for user wait instructions (Paolo)
>>>>      Use the test on vmx->secondary_exec_control to replace
>>>>      guest_cpuid_has (Paolo)
>>>> v6:
>>>>      add check msr_info->host_initiated in get/set msr(Xiaoyao)
>>>>      restore the atomic_switch_umwait_control_msr()(Xiaoyao)
>>>>
>>>> Tao Xu (3):
>>>>     KVM: x86: Add support for user wait instructions
>>>>     KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL
>>>>     KVM: vmx: Introduce handle_unexpected_vmexit and handle WAITPKG
>>>> vmexit
>>>>
>>>>    arch/x86/include/asm/vmx.h      |  1 +
>>>>    arch/x86/include/uapi/asm/vmx.h |  6 ++-
>>>>    arch/x86/kernel/cpu/umwait.c    |  6 +++
>>>>    arch/x86/kvm/cpuid.c            |  2 +-
>>>>    arch/x86/kvm/vmx/capabilities.h |  6 +++
>>>>    arch/x86/kvm/vmx/nested.c       |  5 ++
>>>>    arch/x86/kvm/vmx/vmx.c          | 83
>>>> ++++++++++++++++++++++++++-------
>>>>    arch/x86/kvm/vmx/vmx.h          |  9 ++++
>>>>    arch/x86/kvm/x86.c              |  1 +
>>>>    9 files changed, 101 insertions(+), 18 deletions(-)
>>>>
>>>
>>
> 

Queued, thanks.

Paolo
