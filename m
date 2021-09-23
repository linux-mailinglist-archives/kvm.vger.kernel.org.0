Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67684163AE
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 18:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242198AbhIWQ41 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 12:56:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54199 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242219AbhIWQ4O (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Sep 2021 12:56:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632416081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0ReSgcM8F/l+G5HcK9Mo9o/CQ02oO2R9Ng8Sr4/ITM4=;
        b=K7fGAtL8oz02bSbbn3ywyPyWfGAaUz6pckXxjkVTCEyfjcGI1rxzjItnZByBZpcPKMdViN
        akcz88G+M0Pj4XH9MvfurcelJZxo9RwhG4zoE3Vh22Wikg4c1B39Q7gIaQdEBP8Lj293yj
        scbg7SGADjxzb7VDyLxdplEoqgiBHbQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-7L2W_OsJPTGhPGIxLmV6rw-1; Thu, 23 Sep 2021 12:54:38 -0400
X-MC-Unique: 7L2W_OsJPTGhPGIxLmV6rw-1
Received: by mail-ed1-f72.google.com with SMTP id q17-20020a50c351000000b003d81427d25cso7307989edb.15
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 09:54:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0ReSgcM8F/l+G5HcK9Mo9o/CQ02oO2R9Ng8Sr4/ITM4=;
        b=ZsyuobcWE3wkElSd+fhCMkoNf5KFB42kTM9Y08oEYy1XvXkOZGj9i1Hp+5hg4Z4ScF
         USM30yAQzTcIZt7vB3WfrPCCtVNPFi74l2CTLwE6AMfTIoqFhRMuzzcXv+GYz6bx23TU
         CtMh+AFvk0l5CN0/Xh0WdcMC8M26qaj0lYZCOxDQngQjGOCIojjXr32s34RVHjW8633H
         aAi2hW1R8INmEVak7IcrGlDyzJmh/6rbF/18aAl4zJrC1ZyPgKw75CcnfaI6zWIatCpQ
         UoVqb5btyp0L/Vtu0oamJw2SOoJUprFjhMMO+r5CBvj3b3rTdMAinGC9K+mJKe+RnvcA
         ADJw==
X-Gm-Message-State: AOAM53060XfkYlrmgnDSZJwlYhzC+ZiLVuEFEKLUPmGGG83NAYTw84ET
        lYFW24+tkvnSzobkhEleZdsQmVo5IW/a/3SVPrDf3KFJaGN8uXzLZbbs4yPdayS342c6NiBrhv6
        ScenjGSW96MNG
X-Received: by 2002:a17:906:584:: with SMTP id 4mr6200626ejn.56.1632416077483;
        Thu, 23 Sep 2021 09:54:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy5UQAxIm6jvDAIEJygeGZF/ewJKdpHxU6OT5aGqbBA5SNslschMbR9eHuS7enkJEmOlKUxtw==
X-Received: by 2002:a17:906:584:: with SMTP id 4mr6200592ejn.56.1632416077261;
        Thu, 23 Sep 2021 09:54:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b13sm4046822ede.97.2021.09.23.09.54.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 09:54:36 -0700 (PDT)
Subject: Re: [PATCH 00/14] nSVM fixes and optional features
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Bandan Das <bsd@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Wei Huang <wei.huang2@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>
References: <20210914154825.104886-1-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d04eb3d1-9f0c-3b2c-c78f-0f377caadcfc@redhat.com>
Date:   Thu, 23 Sep 2021 18:54:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210914154825.104886-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/09/21 17:48, Maxim Levitsky wrote:
> Those are few patches I was working on lately, all somewhat related
> to the two CVEs that I found recently.
> 
> First 7 patches fix various minor bugs that relate to these CVEs.
> 
> The rest of the patches implement various optional SVM features,
> some of which the guest could enable anyway due to incorrect
> checking of virt_ext field.
> 
> Last patch is somewhat an RFC, I would like to hear your opinion
> on that.
> 
> I also implemented nested TSC scaling while at it.
> 
> As for other optional SVM features here is my summary of few features
> I took a look at:
> 
> X86_FEATURE_DECODEASSISTS:
>     this feature should make it easier
>     for the L1 to emulate an instruction on MMIO access, by not
>     needing to read the guest memory but rather using the instruction
>     bytes that the CPU already fetched.
> 
>     The challenge of implementing this is that we sometimes inject
>     #PF and #NPT syntenically and in those cases we must be sure
>     we set the correct instruction bytes.
> 
>     Also this feature adds assists for MOV CR/DR, INTn, and INVLPG,
>     which aren't that interesting but must be supported as well to
>     expose this feature to the nested guest.
> 
> X86_FEATURE_VGIF
>     Might allow the L2 to run the L3 a bit faster, but due to crazy complex
>     logic we already have around int_ctl and vgif probably not worth it.
> 
> X86_FEATURE_VMCBCLEAN
>     Should just be enabled, because otherwise L1 doesn't even attempt
>     to set the clean bits. But we need to know if we can take an
>     advantage of these bits first.
> 
> X86_FEATURE_FLUSHBYASID
> X86_FEATURE_AVIC
>     These two features would be very good to enable, but that
>     would require lots of work, and will be done eventually.
> 
> There are few more nested SVM features that I didn't yet had a
> chance to take a look at.
> 
> Best regards,
> 	Maxim Levitsky
> 
> Maxim Levitsky (14):
>    KVM: x86: nSVM: restore int_vector in svm_clear_vintr
>    KVM: x86: selftests: test simultaneous uses of V_IRQ from L1 and L0
>    KVM: x86: nSVM: test eax for 4K alignment for GP errata workaround
>    KVM: x86: nSVM: don't copy pause related settings
>    KVM: x86: nSVM: don't copy virt_ext from vmcb12
>    KVM: x86: SVM: don't set VMLOAD/VMSAVE intercepts on vCPU reset
>    KVM: x86: SVM: add warning for CVE-2021-3656
>    KVM: x86: SVM: add module param to control LBR virtualization
>    KVM: x86: nSVM: correctly virtualize LBR msrs when L2 is running
>    KVM: x86: nSVM: implement nested LBR virtualization
>    KVM: x86: nSVM: implement nested VMLOAD/VMSAVE
>    KVM: x86: SVM: add module param to control TSC scaling
>    KVM: x86: nSVM: implement nested TSC scaling
>    KVM: x86: nSVM: support PAUSE filter threshold and count
> 
>   arch/x86/kvm/svm/nested.c                     | 105 +++++++--
>   arch/x86/kvm/svm/svm.c                        | 218 +++++++++++++++---
>   arch/x86/kvm/svm/svm.h                        |  20 +-
>   arch/x86/kvm/vmx/vmx.c                        |   1 +
>   arch/x86/kvm/x86.c                            |   1 +
>   tools/testing/selftests/kvm/.gitignore        |   1 +
>   tools/testing/selftests/kvm/Makefile          |   1 +
>   .../selftests/kvm/x86_64/svm_int_ctl_test.c   | 128 ++++++++++
>   8 files changed, 427 insertions(+), 48 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/x86_64/svm_int_ctl_test.c
> 

Queued more patches, with 9-10-11-14 left now.

Paolo

