Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E31E43C194C
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 20:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbhGHSlJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 14:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhGHSlH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jul 2021 14:41:07 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E86BC061574
        for <kvm@vger.kernel.org>; Thu,  8 Jul 2021 11:38:24 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id 145so6370144pfv.0
        for <kvm@vger.kernel.org>; Thu, 08 Jul 2021 11:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7IMuMUvHO82Rf0Ss8PXs63y6ANC76fGZyxGH24nk1uY=;
        b=AEJUmU092XhSjinH3RNlcQMS/9jJCUfRHFTvGQOCYGEgAkLDTt91AoUhpV20zqrqaG
         DgxEkyC7dIjMJejx10JKJCCad8mo9r17BDUHgTgdADxDWEmoQX6MI/Ks82PTsEV6wf6b
         wKLuoB0Bw21064KfDHSoi9ggEs0OdmCiFqzx+6A/Qav7JexZHVOP5GV64ONuI1uoMqnJ
         IK8vOt7ia2yi82nY24zzCbuTHHcTJGeeT6wXiPdp0g3awgHWnmetypwl0L8gEXlERsvv
         zaj3cym87YUy76sBrw/rUq8ip5xJy8lswH9QtOrhmAE4wJ4AU/HW2//+e5yWeiPhqfWo
         iJxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7IMuMUvHO82Rf0Ss8PXs63y6ANC76fGZyxGH24nk1uY=;
        b=ba8n4+1qckIS0lIv+nFTrEblfB1n0wdCTYjz0o437Yoiexh87v5ygPPMFQL8MjbYQ9
         QO2bizgGzEs3BXfpqsYPFtS/UOoqrW2SX29BlsC0fQd5Swh+jBgmE5EKB09UEG7/L6FZ
         HS3j/fbmR5Y9fideiv/u09v/i4ymXu5ZxYSGdxOjtl1cq52gsrj+ytI3zvWDCt6YahX7
         5t45vsEt7VA8gWXvUYlHS7xx64FOnAVInqN7aJip/Tr79gAQwwdWnCJ0hJSb0vIiHp0A
         sO58OCnrY+L4cx2uMM+zl8aarJ742EiGcua2y87aVsRfqKN4Pw0vrxwlzk1AuQzwpVMg
         iQAg==
X-Gm-Message-State: AOAM531GXjk/Q4irvN4+QQTgTNIEqLtsVdv9IV3h8+sppGUDccqLalbi
        2LrjilfnlniceIkhm6TqGOTetw==
X-Google-Smtp-Source: ABdhPJwvrGKMIplQ3AYMPHgsfd1ogRE/LvqPPIKpnrjJ1sSar/mUZLFVw9JqUCa95Qns7PZ7PlcqCQ==
X-Received: by 2002:aa7:8d5a:0:b029:302:e2cb:6d79 with SMTP id s26-20020aa78d5a0000b0290302e2cb6d79mr32258922pfe.71.1625769503629;
        Thu, 08 Jul 2021 11:38:23 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id 2sm4277773pgz.26.2021.07.08.11.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 11:38:22 -0700 (PDT)
Date:   Thu, 8 Jul 2021 18:38:18 +0000
From:   David Matlack <dmatlack@google.com>
To:     David Edmondson <dme@dme.org>
Cc:     linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 0/2] kvm: x86: Convey the exit reason to user-space on
 emulation failure
Message-ID: <YOdGGuk2trw0h95x@google.com>
References: <20210706101207.2993686-1-david.edmondson@oracle.com>
 <YOY2pLoXQ8ePXu0W@google.com>
 <m28s2g51q3.fsf@dme.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m28s2g51q3.fsf@dme.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 08, 2021 at 03:17:40PM +0100, David Edmondson wrote:
> Apologies if you see two of these - I had some email problems earlier.

I only got one! :)

> 
> On Wednesday, 2021-07-07 at 23:20:04 UTC, David Matlack wrote:
> 
> > On Tue, Jul 06, 2021 at 11:12:05AM +0100, David Edmondson wrote:
> >> To help when debugging failures in the field, if instruction emulation
> >> fails, report the VM exit reason to userspace in order that it can be
> >> recorded.
> >
> > What is the benefit of seeing the VM-exit reason that led to an
> > emulation failure?
> 
> I can't cite an example of where this has definitively led in a
> direction that helped solve a problem, but we do sometimes see emulation
> failures reported in situations where we are not able to reproduce the
> failures on demand and the existing information provided at the time of
> failure is either insufficient or suspect.
> 
> Given that, I'm left casting about for data that can be made available
> to assist in postmortem analysis of the failures.

Understood, thanks for the context. My only concern would be that
userspace APIs are difficult to change once they exist. If it turns
out knowing the exit reason does not help with debugging emulation
failures we'd still be stuck with exporting it on every emulation
failure.

My intuition is that the instruction bytes (which are now available with
Aaron's patch) and the guest register state (which is queryable through
other ioctls) should be sufficient to set up a reproduction of the
emulation failure in a kvm-unit-test and the exit reason should not
really matter. I'm curious if that's not the case?

I'm really not opposed to exporting the exit reason if it is useful, I'm
just not sure it will help.

> 
> >> I'm unsure whether sgx_handle_emulation_failure() needs to be adapted
> >> to use the emulation_failure part of the exit union in struct kvm_run
> >> - advice welcomed.
> >> 
> >> v2:
> >> - Improve patch comments (dmatlack)
> >> - Intel should provide the full exit reason (dmatlack)
> >> - Pass a boolean rather than flags (dmatlack)
> >> - Use the helper in kvm_task_switch() and kvm_handle_memory_failure()
> >>   (dmatlack)
> >> - Describe the exit_reason field of the emulation_failure structure
> >>   (dmatlack)
> >> 
> >> David Edmondson (2):
> >>   KVM: x86: Add kvm_x86_ops.get_exit_reason
> >>   KVM: x86: On emulation failure, convey the exit reason to userspace
> >> 
> >>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
> >>  arch/x86/include/asm/kvm_host.h    |  3 +++
> >>  arch/x86/kvm/svm/svm.c             |  6 ++++++
> >>  arch/x86/kvm/vmx/vmx.c             | 11 +++++++----
> >>  arch/x86/kvm/x86.c                 | 22 +++++++++++++---------
> >>  include/uapi/linux/kvm.h           |  7 +++++++
> >>  6 files changed, 37 insertions(+), 13 deletions(-)
> >> 
> >> -- 
> >> 2.30.2
> >> 
> 
> dme.
> -- 
> It's gettin', it's gettin', it's gettin' kinda hectic.
