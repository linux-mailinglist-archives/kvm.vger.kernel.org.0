Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22CF5699FE0
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 23:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjBPWur (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 17:50:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBPWuq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 17:50:46 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3C932CDE
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 14:50:44 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id bp15so4625919lfb.13
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 14:50:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ClwnzccO8BUmmOp/VxOG0pbBm89yQbz/BP7ZVIUzFp0=;
        b=lTDHazNCt6CpvoWDFLaTNphbBZzT7kt1EubGrgRAvV3c145eYBBy5f5+CtT3pQ4EEw
         vq+DzxuqBCnY5UksycggzU5GJHZeuLU5IAxGmNBR6217pQas78tP+CrhDfMRE2vTRbZY
         x2uj2Xr2/rM4KCxCV5QeHTMyUgAk5EL2IrMd9k39U07Dr2a/OZ3bKfQVHqipOfZrFeRI
         RJPVNhKvC8V8aj9IFWyr+ppBaTAl8wYPH9tamMJbkTkopjTplqlSzb0xI18EjtwpIvmi
         OanxYg1+kfSqY8Q5OJ3ILiQvzqovMQYuBrPtY6+iinR11dgsTsxUiFCd1VsXhahGTsyA
         p00g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ClwnzccO8BUmmOp/VxOG0pbBm89yQbz/BP7ZVIUzFp0=;
        b=J2h9R9MvVT2HSCpawdQ6hUK7G6fZ/IjtAByNZHD+PD7SGaWXaVU15Nbk8ipjspdmx4
         s9FXzG6TA2ylYrF62xpR6Xi/zTIFFLWUFGkMBLDAhFSrUPXzYAxZERSP0JYRxBZL7jQL
         Fj0AorDp2d7s2DEfNggLaizYa8/zSta+fUH2YbXXQgGel3Ug2O/+wc2+j3utVssw0afd
         QUCeprCogYK59QiRlwfdWdlqwi6+JMxDOmgOhHTnRC4yJei81ZTaY2blzubHR2XmkGqb
         T99PugMDkLPWVjxxjeMre/6Qix7pgW2s/nLZHQomgyU84Uz+0ytcQm7ec4PTFfOiA+gM
         aUPQ==
X-Gm-Message-State: AO0yUKVNbUoR3BmLRjtMNDoprMYQDSUV6Plr4BjDcZgQQ3GtRJ9XK5oy
        8U2+UErbzYGXwvwEKo11v6xr+J+/7zmB8FZmrrQkIQ==
X-Google-Smtp-Source: AK7set+XwTphH4d36OqZHqgckvXgUFJc0W3zjAIyA4f6EK3O2FPS2MJJ3q+nMfhSXUB+1Vn3wOShwlqp/ZSFNKFp9fY=
X-Received: by 2002:a19:c215:0:b0:4d8:1c0e:bfc7 with SMTP id
 l21-20020a19c215000000b004d81c0ebfc7mr2140062lfc.13.1676587842656; Thu, 16
 Feb 2023 14:50:42 -0800 (PST)
MIME-Version: 1.0
References: <CAAhR5DE4rYey42thw_4toKx0tEn5ZY3mRq8AJT=YQqemqvt7pw@mail.gmail.com>
 <CAMkAt6pTNZ2_+0RNZcPFHhG-9o2q0ew0Wgd=m_T6KfLSYJyB4g@mail.gmail.com>
 <Y+5zaeJxKr6hzp4w@google.com> <c34b8753-d70b-3d0f-f3b1-c89264642291@redhat.com>
 <Y+59PX7V9qEzpuJh@google.com> <CAAhR5DEhqv_FsdGbeOQ9vvKEcVCOnkDBxCJRs_XC2zN_8fKB5Q@mail.gmail.com>
In-Reply-To: <CAAhR5DEhqv_FsdGbeOQ9vvKEcVCOnkDBxCJRs_XC2zN_8fKB5Q@mail.gmail.com>
From:   Sagi Shahar <sagis@google.com>
Date:   Thu, 16 Feb 2023 14:50:31 -0800
Message-ID: <CAAhR5DG5Q=0Yadj9mhw7K-dAzzcSN8T3oM68BhWCUZfT19f4Xg@mail.gmail.com>
Subject: Re: Issue with "KVM: SEV: Add support for SEV intra host migration"
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org,
        Erdem Aktas <erdemaktas@google.com>,
        Ryan Afranji <afranji@google.com>,
        Michael Sterritt <sterritt@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 16, 2023 at 2:47 PM Sagi Shahar <sagis@google.com> wrote:
>
> On Thu, Feb 16, 2023 at 11:00 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Thu, Feb 16, 2023, Paolo Bonzini wrote:
> > > On 2/16/23 19:18, Sean Christopherson wrote:
> > > > Depending on why the source VM needs to be cleaned up, one thought would be add
> > > > a dedicated ioctl(), e.g. KVM_DISMANTLE_VM, and make that the _only_ ioctl() that's
> > > > allowed to operate on a dead VM.  The ioctl() would be defined as a best-effort
> > > > mechanism to teardown/free internal state, e.g. destroy KVM_PIO_BUS, KVM_MMIO_BUS,
> > > > and memslots, zap all SPTEs, etc...
> > >
> > > If we have to write the code we might as well do it directly at context-move
> > > time, couldn't we?  I like the idea of minimizing the memory cost of the
> > > zombie VM.
> >
> > I thought about that too, but I assume the teardown latency would be non-trivial,
> > especially if KVM aggressively purges state.  The VMM can't resume the VM until
> > it knows the migration has completed, so immediately doing the cleanup would impact
> > the VM's blackout time.
> >
> > My other thought was to automatically do the cleanup, but to do so asynchronously.
> > I actually don't know why I discarded that idea.  I think I got distracted and
> > forgot to circle back.  That might be something we could do for any and all
> > bugged/dead VMs.
>
> As my second experiment where I always return success on ioctls after
> the vm is marked dead, my guess is that VMM doesn't HAVE to clean the
> state using the ioctls.
> Our VMM currently cleans everything automatically during the shutdown
> process of the vm. Changing this behavior might be a bit tricky if if
> it's safer than allowing cleanup ioctls in KVM we can see if we can
> change that behavior.
>
> I like Paul's suggestion on ignoring ioctl errors if the vm got

Sorry Paolo, not Paul.

> migrated in VMM. This might be enough for us to clean up the source VM
> state enough that we can safely release it.
