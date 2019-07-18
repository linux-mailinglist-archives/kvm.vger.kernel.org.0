Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 485AC6CB20
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 10:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389572AbfGRIni (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 04:43:38 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:42299 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbfGRInh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 04:43:37 -0400
Received: by mail-ot1-f66.google.com with SMTP id l15so28152163otn.9;
        Thu, 18 Jul 2019 01:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d2Q3qNlicAJFSj13hQsbAPBZr2sr3JIHVAU8/U9TgNw=;
        b=NKuW4qeRZrqPwnUXP5Y15D4GRPwypc0idrFTYQ+p1hW4EGtRC1hFQCLVQrW/IaLw3G
         2y1M35J86sAKLEGvwJHL8nNn4z5ploMmTVLoBYRhaMMNlDsah1foDMMtdGAXakBlOZe6
         SghOlESbA2vA1zwz5uGrJN8bNJgA2vJ4J1jhh6w9nxSoTEXWMeGXJ74xwTuIfmXG86GS
         HVmhG2ad/5ic79f5pSCAx85O0ckrkCb/eT68neFVfF9oV8biQNXBhV2ngQ6bPuKXftp/
         rXcj9lDL/ifeVKw9+W17/+TGo6Lrl+3/znt+l9+UrODwg64f00L8M8LwHGbWzfnHucye
         kKLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d2Q3qNlicAJFSj13hQsbAPBZr2sr3JIHVAU8/U9TgNw=;
        b=Z9SFDA4cBL4QOB5afzmwf8BPtLEUhP13/QRp+boeCH41t9M54j2sqgmdxYy1EXuWWY
         EdguwE8A+u5WWDaKbdJDr62FAHY9Y51lwnss/85Rk6TOenXWWN7CwL4U1tFMKkhUK3dc
         wo5O8azIbhS6mBDKFrSTgGxw9LDqBq03brRwj21d2doUiWeOgLOIfP/eO81hiSyBOy3d
         tpnczSyPsYoJS2G0/espkHvuQRlcdXblkpoKPWX2Tz2gS187nMLiRzKwQtbpTg3mP6Xg
         PMWwL12b/EIxNbQP7h3CMwLwdvn5XrK0s/rC81g3nsS65Exi/ugGH01NDqn0aheUvsF7
         lmjg==
X-Gm-Message-State: APjAAAUiNxOiOlk+nSApO1hn4Met4SiUF2YQ6JqJ+SDjpYzvk0kz2iQT
        LEOIRhY+Tkve6KnyM9CdmhHlnuFQ0TASh85XVc0=
X-Google-Smtp-Source: APXvYqy0R2wRkwvHCqhND6qiR8C+r9+t40Iz3gOZu8JnZ2J+eHk5DYXaB9ecsGeIP1uWTKH8nJdjYqoOn1YeQ07lQ2A=
X-Received: by 2002:a9d:2c47:: with SMTP id f65mr34015931otb.185.1563439416885;
 Thu, 18 Jul 2019 01:43:36 -0700 (PDT)
MIME-Version: 1.0
References: <1562915730-9490-1-git-send-email-wanpengli@tencent.com>
 <f95fbf72-090f-fb34-3c20-64508979f251@redhat.com> <db74a3a8-290e-edff-10ad-f861c60fbf8e@de.ibm.com>
 <e31024e4-f437-becd-a9e3-e1ea8cd2e0c7@redhat.com>
In-Reply-To: <e31024e4-f437-becd-a9e3-e1ea8cd2e0c7@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 18 Jul 2019 16:43:28 +0800
Message-ID: <CANRm+Cw43DKqD17U+7-OPX3BmeNBThSe9-uWP2Atob+A0ApzLA@mail.gmail.com>
Subject: Re: [PATCH RESEND] KVM: Boosting vCPUs that are delivering interrupts
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 18 Jul 2019 at 16:34, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 18/07/19 10:15, Christian Borntraeger wrote:
> >
> >
> > On 18.07.19 09:59, Paolo Bonzini wrote:
> >> On 12/07/19 09:15, Wanpeng Li wrote:
> >>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> >>> index b4ab59d..2c46705 100644
> >>> --- a/virt/kvm/kvm_main.c
> >>> +++ b/virt/kvm/kvm_main.c
> >>> @@ -2404,8 +2404,10 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
> >>>     int me;
> >>>     int cpu = vcpu->cpu;
> >>>
> >>> -   if (kvm_vcpu_wake_up(vcpu))
> >>> +   if (kvm_vcpu_wake_up(vcpu)) {
> >>> +           vcpu->preempted = true;
> >>>             return;
> >>> +   }
> >>>
> >>>     me = get_cpu();
> >>>     if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
> >>>
> >>
> >> Who is resetting vcpu->preempted to false in this case?  This also
> >> applies to s390 in fact.
> >
> > Isnt that done by the sched_in handler?
>
> I am a bit confused because, if it is done by the sched_in later, I
> don't understand why the sched_out handler hasn't set vcpu->preempted
> already.
>
> The s390 commit message is not very clear, but it talks about "a former
> sleeping cpu" that "gave up the cpu voluntarily".  Does "voluntarily"
> that mean it is in kvm_vcpu_block?  But then at least for x86 it would

see the prepare_to_swait_exlusive() in kvm_vcpu_block(), the task will
be set in TASK_INTERRUPTIBLE state, kvm_sched_out will set
vcpu->preempted to true iff current->state == TASK_RUNNING.

Regards,
Wanpeng Li
