Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A566D43487E
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 12:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhJTKFN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 06:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhJTKFM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 06:05:12 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5313C06161C;
        Wed, 20 Oct 2021 03:02:58 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id c29-20020a4ad21d000000b002b6cf3f9aceso1235776oos.13;
        Wed, 20 Oct 2021 03:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qUJTqShsGPwl7ndAoWAVq9Gk5Jbt5mhhVB3uwCyyxmw=;
        b=eor2xuFm2EF0fx2lJXIJmwz3ONgOBeUx6jgOf/00xLEzNXlwLAowEjoHCbRRqDVBWh
         0Y6fJ63JkLsvC5iZTQwCMjPwgX29LgyRMSBuFJDzOdiwDh337xjT7WU87s3rHQ0oQyFS
         +VzPHiUyHA8qqXLKtD67KTq7A1xRyl9z/SXT29NnQkiZFTtwMhyCFm4iXEErRDWL+xdf
         8L5G5M9ZlTTEUrtEqTlcE6kVd0/wN0bTDxswQSx8ZtxvOdkkcevlgXwB8Jj6h6ORC49W
         kJcxy/vLjZGXvvCHsRo15w/dPJvOnIls1BoYCj6Mmq2c6Ng0zPwHlh6Sv5DhKXIfa8Ns
         evJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qUJTqShsGPwl7ndAoWAVq9Gk5Jbt5mhhVB3uwCyyxmw=;
        b=qedEpeDuSRX7v1NbWAZTPso+OaSwZsfd0AKM3uFihckZen1YnP5B5cCKJxkQpV/fxW
         lDeHm7kLFUFqBoYXiCP3YjPXAiFG+jY0TdJtSZMEIbAAjGq5VrGOcZUruDXFznAol4oD
         RDIn2cbmcXVheMBTicNdkhO7EpxQdz7MLpEH2KLLVW4PsVqxWy9TGP+yDgKfShUrqQgz
         qIcTbpS2RzitmuqP9QxmcIB7nN2kn9n56Z2Y86obAkVcz27239UFVs9njKUSX06rtK7m
         1kXMJNgTUjoJ16aMG1KaBvVFHIWUO2XZ7D2ippDpYYrbar8D6uJIFAoesRKZX0V7xpPh
         DiLA==
X-Gm-Message-State: AOAM533k/Dr6uOWvYU7eqJkk0A+//QSr8m3tlBsTVMiwsWl2hLWJ5nNA
        HjeOAvS7t5ze1/CodbXl9Q89laMt0mdBLvrS1MxllR9wczB3Qw==
X-Google-Smtp-Source: ABdhPJy3dHLwXgVZwvKpmHORofRsDU8YQRs5fmYzYeG/Run2arHde25eMDCEFG7IrQN2EXmStWxm0J+CKCpgOcjpjVs=
X-Received: by 2002:a4a:d5c8:: with SMTP id a8mr8912756oot.18.1634724178311;
 Wed, 20 Oct 2021 03:02:58 -0700 (PDT)
MIME-Version: 1.0
References: <1634631160-67276-1-git-send-email-wanpengli@tencent.com>
 <1634631160-67276-3-git-send-email-wanpengli@tencent.com> <24e67e43-c50c-7e0f-305a-c7f6129f8d70@redhat.com>
 <YW8BmRJHVvFscWTo@google.com> <CANRm+CzuWnO8FZPTvvOtpxqc5h786o7THyebOFpVAp3BF1xQiw@mail.gmail.com>
 <45fabf5a-96b5-49dc-0cba-55714ae3a4b5@redhat.com>
In-Reply-To: <45fabf5a-96b5-49dc-0cba-55714ae3a4b5@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 20 Oct 2021 18:02:47 +0800
Message-ID: <CANRm+CyPznw0O2qwnhhc=YEq+zSD3C7dqqG8-8XE6sLdhL7aXQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] KVM: vCPU kick tax cut for running vCPU
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 Oct 2021 at 14:47, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 20/10/21 04:49, Wanpeng Li wrote:
> >> The intent of the extra check was to avoid the locked instruction that comes with
> >> disabling preemption via rcu_read_lock().  But thinking more, the extra op should
> >> be little more than a basic arithmetic operation in the grand scheme on modern x86
> >> since the cache line is going to be locked and written no matter what, either
> >> immediately before or immediately after.
> >
> > I observe the main overhead of rcuwait_wake_up() is from rcu
> > operations, especially rcu_read_lock/unlock().
>
> Do you have CONFIG_PREEMPT_RCU set?  If so, maybe something like this would help:

Yes.

>
> diff --git a/kernel/exit.c b/kernel/exit.c
> index fd1c04193e18..ca1e60a1234d 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -235,8 +235,6 @@ int rcuwait_wake_up(struct rcuwait *w)
>         int ret = 0;
>         struct task_struct *task;
>
> -       rcu_read_lock();
> -
>         /*
>          * Order condition vs @task, such that everything prior to the load
>          * of @task is visible. This is the condition as to why the user called
> @@ -250,6 +248,14 @@ int rcuwait_wake_up(struct rcuwait *w)
>          */
>         smp_mb(); /* (B) */
>
> +#ifdef CONFIG_PREEMPT_RCU
> +       /* The cost of rcu_read_lock() is nontrivial for preemptable RCU.  */
> +       if (!rcuwait_active(w))
> +               return ret;
> +#endif
> +
> +       rcu_read_lock();
> +
>         task = rcu_dereference(w->task);
>         if (task)
>                 ret = wake_up_process(task);
>
> (If you don't, rcu_read_lock is essentially preempt_disable() and it
> should not have a large overhead).  You still need the memory barrier
> though, in order to avoid missed wakeups; shameless plug for my
> article at https://lwn.net/Articles/847481/.

You are right, the cost of rcu_read_lock() for preemptable RCU
introduces too much overhead, do you want to send a separate patch?

    Wanpeng
