Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14BB0572EEF
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 09:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234697AbiGMHR3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 03:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234682AbiGMHR2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 03:17:28 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC8B6D57C
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 00:17:27 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id n185so5963478wmn.4
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 00:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k5kXHTDFVYMTb/KL6d64TfSYQCRtszFFm4Qkgo8IFPA=;
        b=iG+Kn4OTzlr03gdOLCLpqpkfea+kNa7p6xYpZ4zgWe9fvBAOuxydUSO2PcKfXhXYKs
         zfjHkJRgPW6w6YHjaNiJzD8uLQP7wt4v9nkrWCMm1EIzv83N+gBr1oOLkH79CzgVLcKW
         ZO5AYiydzTAKTQ3Xe1qXKatG0VPafTarY370XoBwFaOwLJCEI9TPZfE8nvCwlLGjzhAJ
         SC+0fwmU/ShGcMHnah/LCLL33d7zd2isB8ksB6a8iHJ4/pa47WR1twLicaznfXeGEyKL
         B9gdEi+Qm49XUeD1W36tJJY3dLYo9zQHd/HLexg+yHACdb7gCDqq9ezxnVlIMZ6ACvXk
         A/jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k5kXHTDFVYMTb/KL6d64TfSYQCRtszFFm4Qkgo8IFPA=;
        b=WugPXBkjZvJ6UfaO5jD1xMxw2KUFoYu+BvP5fFKu47tH6khcQORb6heVA8PFmTz5Xw
         BmNN+Miyu07perlXgs7MEhNvabwfMlFvFplSOLK4OE7WwlLrYPt4I6uO3mj2jMf9S9II
         SfTe0s6QXy1bUDwN/cspjLHtuXTstIOp8ttIEKPhZOWIvbmk3ffAtBn8aVnrTot52oS6
         tTs54tp9tsrj1s1BKsXay3sV6UprOKRQAWCIGPRV96wXDmUMfMDH/upIC31uY2Zh41rT
         cSVyCEIq+bAe9Zvd6YC0BgPt3H6AIwqgxw4fbln8IsrjNMw8pWSbbt3vmqOX3FjnRN4u
         ReYA==
X-Gm-Message-State: AJIora+sho3oAf8BI5RrC0eiZq2s+owPYbMQOhRRLtSw4pMbhwCyY3+R
        XRPOhc1l8RGlNCDyVAPjC4BdKUWBCxvStYKHP/mQkCTsEfMm5CRn
X-Google-Smtp-Source: AGRyM1sLwfh1MtLyuU3g6EG1RA2AjYloTJaZd5DKoJkcEqB2mUlYxiEVCUjUHjE30edeaLciJpQVCTeFPojxDs+AHX0=
X-Received: by 2002:a1c:6a0a:0:b0:3a2:e61e:e3ee with SMTP id
 f10-20020a1c6a0a000000b003a2e61ee3eemr7906065wmc.108.1657696645588; Wed, 13
 Jul 2022 00:17:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAAhSdy1CAtr=mAVFtduTcED_Sjp2=4duQwgL5syxZ-sYM6SoWQ@mail.gmail.com>
 <01ec025d-fbde-5e58-2221-a368d4e1bb3a@redhat.com>
In-Reply-To: <01ec025d-fbde-5e58-2221-a368d4e1bb3a@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Wed, 13 Jul 2022 12:47:13 +0530
Message-ID: <CAAhSdy2gR3dtBHO0Q7+1xgMCytYkJgmuT6xiQ+WQiorQPMRUXA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv fixes for 5.19, take #2
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 13, 2022 at 11:30 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 7/13/22 07:47, Anup Patel wrote:
> > Hi Paolo,
> >
> > We have two more fixes for 5.19 which were discovered recently:
> > 1) Fix missing PAGE_PFN_MASK
> > 2) Fix SRCU deadlock caused by kvm_riscv_check_vcpu_requests()
>
> Pulled, thanks.
>
> For the latter, my suggestion is to remove KVM_REQ_SLEEP completely and
> key the waiting on kvm_arch_vcpu_runnable using kvm_vcpu_halt or
> kvm_vcpu_block.

We are using KVM_REQ_SLEEP for VCPU hotplug. The secondary
VCPUs will block until woken-up by using an SBI call from other VCPU.
This is different from blocking on WFI where VCPU will wake-up upon
any interrupt.

I agree with your suggestion, we should definitely use kvm_vcpu_block()
here.

>
> Also, I only had a quick look but it seems like vcpu->arch.pause is
> never written?

Yes, the vcpu->arch.pause is redundant. I will remove it.

>
> Paolo
>

Thanks,
Anup
