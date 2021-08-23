Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D763F4E91
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 18:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbhHWQki (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 12:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbhHWQkh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Aug 2021 12:40:37 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BF1C061575
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 09:39:54 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id v19so13910558lfo.7
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 09:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=brGHoNpdCUb5OkpXeOFtkqgH+kK+FFH2HRovhOV+FB4=;
        b=jaJNjlvCfShSYgXTrX6Rzpt+bqS9I720OMgA662M8TTBYJFw6hVesMlSpWNCo84vTy
         7VJ1sZXHqoQsVfkD1hg1rCO4/mo8n6tcdANZvOiBYnvIJocS2KdhWSQ0Ni55bIXHBwBI
         B6XmfuRZhLWdC6dM3VXgbndxawkVXuBGCLKIi2CdvojX8WuuJWlBRThgEMuoKQFlDpQh
         vxeydpYd47UiNkhIJ/gLBbyVtd7EeCwPVvaxh7LRpDlQz4Gbb59Eq6K6SCty8wusMOQq
         pobSmeetkAE2fnSu0qZZPe3xqWD0G0hRVt2F+PKPlNVwZzwyy+6FXJfqDn0wSNAmk5SZ
         qNKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=brGHoNpdCUb5OkpXeOFtkqgH+kK+FFH2HRovhOV+FB4=;
        b=Sg0auMr2BEA4fvj+eYmMlkdKTLUQnA5X7pY7wnqSJCBPWL5rUC1kAyi2CZP2xupB8p
         PoGbgEO1yvQnqCfzDra3SjkGGWwduCVg7s66PvA676I8l9hsLbRjvkFKljODY3vhAGr0
         dR2u2XCWwxW9bkdr/wolvKxoaX4E+tcON61Ame0a4MvcofB/FHyF/89Xfr74jOqPlZfk
         N5BNY4bsNh8XigAx1THfjThZDvlr5vy0G7FVNxtgGMvP+3u7SH5EXeWci5/mxQfqp7zp
         HL55eDoPCe6iZwizGVeCOjSEMkRn83h+EV1y8UQm+ji1KPE/nlac7oRNwiBJJQCgZBm7
         WAKA==
X-Gm-Message-State: AOAM532RCjLdippRjPAKVVFlRFvxceCn1physrkk+uz0wXawCVKYohdu
        7xBOAX+AZvtMAcNCs/MnylmwGX5Q3hypWldzdrlFLg==
X-Google-Smtp-Source: ABdhPJwwZuFTzvjKZKKWDdOHQstHqeNmlDQrfJAqmjKuKv0ua/aO51h4EG//r2k2b/xSsKVSJHpPOGMhrxtFXE+RSeI=
X-Received: by 2002:a19:dc47:: with SMTP id f7mr25190527lfj.71.1629736792244;
 Mon, 23 Aug 2021 09:39:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210819154910.1064090-1-pgonda@google.com> <20210819154910.1064090-2-pgonda@google.com>
 <CAA03e5Gh0kJYHP1R3F7uh6x83LBFPp=af2xt7q3epgg+8XW53g@mail.gmail.com>
 <CAMkAt6oJcW3MHP3fod9RnRHCEYp-whdEtBTyfuqgFgATKa=3Hg@mail.gmail.com>
 <YR7iD6kdTUpWwwRn@google.com> <CAA03e5F62WEcs3PN6M9qGzW+wuufp+BjwDHcTt18yaB42RDYkA@mail.gmail.com>
In-Reply-To: <CAA03e5F62WEcs3PN6M9qGzW+wuufp+BjwDHcTt18yaB42RDYkA@mail.gmail.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Mon, 23 Aug 2021 10:39:40 -0600
Message-ID: <CAMkAt6rJTTojQ7Ymbywmdns-8AWNBVEde4D6cZkceL=czMaEig@mail.gmail.com>
Subject: Re: [PATCH 1/2 V4] KVM, SEV: Add support for SEV intra host migration
To:     Marc Orr <marcorr@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 20, 2021 at 2:53 PM Marc Orr <marcorr@google.com> wrote:
>
> On Thu, Aug 19, 2021 at 3:58 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Thu, Aug 19, 2021, Peter Gonda wrote:
> > > > >
> > > > > +static int svm_sev_lock_for_migration(struct kvm *kvm)
> > > > > +{
> > > > > +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > > > > +       int ret;
> > > > > +
> > > > > +       /*
> > > > > +        * Bail if this VM is already involved in a migration to avoid deadlock
> > > > > +        * between two VMs trying to migrate to/from each other.
> > > > > +        */
> > > > > +       spin_lock(&sev->migration_lock);
> > > > > +       if (sev->migration_in_progress)
> > > > > +               ret = -EBUSY;
> > > > > +       else {
> > > > > +               /*
> > > > > +                * Otherwise indicate VM is migrating and take the KVM lock.
> > > > > +                */
> > > > > +               sev->migration_in_progress = true;
> > > > > +               mutex_lock(&kvm->lock);
> >
> > Deadlock aside, mutex_lock() can sleep, which is not allowed while holding a
> > spinlock, i.e. this patch does not work.  That's my suggestion did the crazy
> > dance of "acquiring" a flag.

Ah, makes sense.

> >
> > What I don't know is why on earth I suggested a global spinlock, a simple atomic
> > should work, e.g.
> >
> >                 if (atomic_cmpxchg_acquire(&sev->migration_in_progress, 0, 1))
> >                         return -EBUSY;
> >
> >                 mutex_lock(&kvm->lock);
> >
> > and on the backend...
> >
> >                 mutex_unlock(&kvm->lock);
> >
> >                 atomic_set_release(&sev->migration_in_progress, 0);
>
> +1 to replacing the spin lock with an atomic flag. Correctness issues
> aside, I think it's also cleaner. Also, I'd suggest adding a comment
> to source code to explain that the `migration_in_progress` flag is to
> prevent deadlock due to the "double migration" discussed previously.

Thanks! I've updated these locks to use the atomic. It looks much cleaner now.
