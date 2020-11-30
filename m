Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB0082C8C6B
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 19:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388012AbgK3SPN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 13:15:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387853AbgK3SPM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 13:15:12 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 356C1C0613D3
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 10:14:32 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id v21so6908485plo.12
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 10:14:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Qxg9fj+0XCIGonLy291dTMO3lLUWRmtT3yL5N2eRulk=;
        b=pxwOMjeOK6XW/T0vsBXN9b4un8VB0QjBPH+3KbpEs7wEDpetbEvfGEBtN+T8eTjB78
         jABD75yAkF33MXZVRACJUvelYVjEbwB5rHV4+ik0GMOlFGO1Yn/Dn1cNoprvwrUjnlKD
         RQ35XzWl96elMe70F0KpoZ4PweCTg9UNfI8Wixfuc7dQvMaikI5qXCE1uLFIomcaUrQ2
         r5lhPZdLjJ8g38g2ScLXWr5KHEpk4ub8yAGlWQ+h7g6X7TNxC3kzsub602ei+2ejxpSA
         OSF3hvLFxE1au2XKip/+jWaiUQeHsRs/FwEkDgp2sVOFXGSoZT1HbcwyX7lUhS9BenYk
         UD2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Qxg9fj+0XCIGonLy291dTMO3lLUWRmtT3yL5N2eRulk=;
        b=qr1gGQb+8n235NhCLDxJUfIQX9eT/IJYhy69y0k1QwV+MyTAQHm2ACN5bhv9AE7Gpj
         cwEwAy+RPSrjAKWTX+GujaahiMnsh+dMwSSnxy6TmTbgN5DI2OuGCBO590R7gMyljViY
         Bb1T70mfTSsL9V1pitZunOaul4mewdvff1gEYogq2ZVg18XAYThO7eGVAUhnA73RVoWt
         WENo1Xn8+XnOSN0IE/n0SSYtGNku6SCZLo22NGauVWMrCqXnKl/qgqDkWiTm/EMmFXd7
         OqFXf+TmEhLQ8BMrtLyrRafOYwBmZHUE7oi+gjNT8SptGEihYK7X1dED4mCcrZ6Fs2bj
         487w==
X-Gm-Message-State: AOAM5317shIxhP4Jwnm8dRNWmDHnRLs6QozbO4z36b1eXOjn+Na0cN9E
        qXHuBYJav/khEaPPW0Ze0B3JhA==
X-Google-Smtp-Source: ABdhPJxsiGez54cXtvJTSfM4mSqrojbwclgxTWEK85ewxR6VjTuZCPGNGA2WawCselj+Ut48pFI8sA==
X-Received: by 2002:a17:90b:19cf:: with SMTP id nm15mr35878pjb.63.1606760071602;
        Mon, 30 Nov 2020 10:14:31 -0800 (PST)
Received: from google.com (242.67.247.35.bc.googleusercontent.com. [35.247.67.242])
        by smtp.gmail.com with ESMTPSA id e1sm17255827pfi.158.2020.11.30.10.14.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 10:14:30 -0800 (PST)
Date:   Mon, 30 Nov 2020 18:14:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [RFC PATCH 00/35] SEV-ES hypervisor support
Message-ID: <X8U2gyj7F2wFU3JI@google.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
 <20200914225951.GM7192@sjchrist-ice>
 <bee6fdda-d548-8af5-f029-25c22165bf84@amd.com>
 <20200916001925.GL8420@sjchrist-ice>
 <60cbddaf-50f3-72ca-f673-ff0b421db3ad@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60cbddaf-50f3-72ca-f673-ff0b421db3ad@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 30, 2020, Paolo Bonzini wrote:
> On 16/09/20 02:19, Sean Christopherson wrote:
> > 
> > TDX also selectively blocks/skips portions of other ioctl()s so that the
> > TDX code itself can yell loudly if e.g. .get_cpl() is invoked.  The event
> > injection restrictions are due to direct injection not being allowed (except
> > for NMIs); all IRQs have to be routed through APICv (posted interrupts) and
> > exception injection is completely disallowed.
> > 
> >    kvm_vcpu_ioctl_x86_get_vcpu_events:
> > 	if (!vcpu->kvm->arch.guest_state_protected)
> >          	events->interrupt.shadow = kvm_x86_ops.get_interrupt_shadow(vcpu);
> 
> Perhaps an alternative implementation can enter the vCPU with immediate exit
> until no events are pending, and then return all zeroes?

This can't work.  If the guest has STI blocking, e.g. it did STI->TDVMCALL with
a valid vIRQ in GUEST_RVI, then events->interrupt.shadow should technically be
non-zero to reflect the STI blocking.  But, the immediate exit (a hardware IRQ
for TDX guests) will cause VM-Exit before the guest can execute any instructions
and thus the guest will never clear STI blocking and never consume the pending
event.  Or there could be a valid vIRQ, but GUEST_RFLAGS.IF=0, in which case KVM
would need to run the guest for an indeterminate amount of time to wait for the
vIRQ to be consumed.

Tangentially related, I haven't looked through the official external TDX docs,
but I suspect that vmcs.GUEST_RVI is listed as inaccessible for production TDs.
This will be changed as the VMM needs access to GUEST_RVI to handle
STI->TDVMCALL(HLT), otherwise the VMM may incorrectly put the vCPU into a
blocked (not runnable) state even though it has a pending wake event.
