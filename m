Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33808DB6B0
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2019 21:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407089AbfJQTAb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Oct 2019 15:00:31 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43438 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407001AbfJQTAb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Oct 2019 15:00:31 -0400
Received: by mail-pl1-f193.google.com with SMTP id f21so1564317plj.10
        for <kvm@vger.kernel.org>; Thu, 17 Oct 2019 12:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q3uzdM+5fwj2ssWvmknPIGf5MCsyjrRjFVb/p5Fv9Cg=;
        b=g4awaZvVD4hwGTQCfNXc8tOZksSCA7Q5SHEIiKd1alDPmBXdZfwJ8Gao1aUBOB9wjz
         3OLcbF8CQQcGiYSa7Y4qNqmobRSusMxhW6BxZySrFyV2GB4yfXGi8WlWYlhLqPJMaKyK
         CQcTg10wY3KsLf8YvAwQNX5gHm/44K99hWVJo/x3qXshslRQerJcZboK72ImRXrB/fYh
         5t8GXHvwEQ/qBlPdJwsLRXYH6JUtD4TEvPnw+40dSenwqdzhESytVtMbObcX/KxRBoyr
         JA0H7+ikwBGT2+Gb2BoDIV7Edp8fHuI2oc7UVx5qOJMNbTf8jOtZ1RhUlQfBkbYYr/rB
         7nvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q3uzdM+5fwj2ssWvmknPIGf5MCsyjrRjFVb/p5Fv9Cg=;
        b=K53pd3h+aUtvlm6Bemt4aHDONhbv2Inqxuz0MelVGCJ0lzwx6G3XXXNivlm+K/N9LW
         ZmVuAfGJFySVoXHm72fO7gXYmMEs4Q9177KJTBKc0tNIyoSj7MEgQVJZyUIfvC1p/P4l
         /TCQx1zH3pHS1dCkiNPyg647Qj+8NPf3MYAu34zPg3UsSbYsJ8ma+ieuuMGyOBlOyLfw
         FAWpfqxo8StTO2jrg4Zsuoze+IIRlnK2er+B3weBuKn7omiRo23eFlwbn/AUzon4f9nE
         4G8fVA9LhMtjICEM2RwgmhN9AQbesg16CZDOBQvdD45h73llOg3KDAkBXwVfJ0zfap1F
         5xag==
X-Gm-Message-State: APjAAAVlPPxMJ+KqVRqtLg1N3kq03xJwEbRW3TUeRQ4/E8ATtf6SDoUR
        aachRoNyC3ysj3Xy8zgEk6Nyuy+maogGeGE5LLSGF7H8qGU=
X-Google-Smtp-Source: APXvYqyZAMOPGy/5bKOQ3r9XpUjB6Hi5YTAcEExobkm32LgcN246UzZMbhfgmkke7Y3CojIhWHoTHR+Zawj6FZN2rLY=
X-Received: by 2002:a17:902:9002:: with SMTP id a2mr5718144plp.147.1571338829890;
 Thu, 17 Oct 2019 12:00:29 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1571333592.git.andreyknvl@google.com> <af26317c0efd412dd660e81d548a173942f8a0ad.1571333592.git.andreyknvl@google.com>
 <20191017181800.GB1094415@kroah.com>
In-Reply-To: <20191017181800.GB1094415@kroah.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Thu, 17 Oct 2019 21:00:18 +0200
Message-ID: <CAAeHK+yS24KnecLyhnPEHx-dOSk3cvVHhtGHe+9Uf2d96+ZqjQ@mail.gmail.com>
Subject: Re: [PATCH RFC 3/3] vhost, kcov: collect coverage from vhost_worker
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     USB list <linux-usb@vger.kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Windsor <dwindsor@gmail.com>,
        Elena Reshetova <elena.reshetova@intel.com>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 17, 2019 at 8:18 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Oct 17, 2019 at 07:44:15PM +0200, Andrey Konovalov wrote:
> > This patch adds kcov_remote_start/kcov_remote_stop annotations to the
> > vhost_worker function, which is responsible for processing vhost works.
> > Since vhost_worker is spawned when a vhost device instance is created,
> > the common kcov handle is used for kcov_remote_start/stop annotations.
> >
> > Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> > ---
> >  drivers/vhost/vhost.c | 15 +++++++++++++++
> >  drivers/vhost/vhost.h |  3 +++
> >  2 files changed, 18 insertions(+)
> >
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > index 36ca2cf419bf..71a349f6b352 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -357,7 +357,13 @@ static int vhost_worker(void *data)
> >               llist_for_each_entry_safe(work, work_next, node, node) {
> >                       clear_bit(VHOST_WORK_QUEUED, &work->flags);
> >                       __set_current_state(TASK_RUNNING);
> > +#ifdef CONFIG_KCOV
> > +                     kcov_remote_start(dev->kcov_handle);
> > +#endif
>
> Shouldn't you hide these #ifdefs in a .h file?  This is not a "normal"
> kernel coding style at all.

Well, if it's acceptable to add a kcov_handle field into vhost_dev
even when CONFIG_KCOV is not enabled, then we can get rid of those
#ifdefs.

>
> >                       work->fn(work);
> > +#ifdef CONFIG_KCOV
> > +                     kcov_remote_stop();
> > +#endif
> >                       if (need_resched())
> >                               schedule();
> >               }
> > @@ -546,6 +552,9 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
> >
> >       /* No owner, become one */
> >       dev->mm = get_task_mm(current);
> > +#ifdef CONFIG_KCOV
> > +     dev->kcov_handle = current->kcov_handle;
> > +#endif
> >       worker = kthread_create(vhost_worker, dev, "vhost-%d", current->pid);
> >       if (IS_ERR(worker)) {
> >               err = PTR_ERR(worker);
> > @@ -571,6 +580,9 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
> >       if (dev->mm)
> >               mmput(dev->mm);
> >       dev->mm = NULL;
> > +#ifdef CONFIG_KCOV
> > +     dev->kcov_handle = 0;
> > +#endif
> >  err_mm:
> >       return err;
> >  }
> > @@ -682,6 +694,9 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> >       if (dev->worker) {
> >               kthread_stop(dev->worker);
> >               dev->worker = NULL;
> > +#ifdef CONFIG_KCOV
> > +             dev->kcov_handle = 0;
> > +#endif
> >       }
> >       if (dev->mm)
> >               mmput(dev->mm);
> > diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> > index e9ed2722b633..010ca1ebcbd5 100644
> > --- a/drivers/vhost/vhost.h
> > +++ b/drivers/vhost/vhost.h
> > @@ -173,6 +173,9 @@ struct vhost_dev {
> >       int iov_limit;
> >       int weight;
> >       int byte_weight;
> > +#ifdef CONFIG_KCOV
> > +     u64 kcov_handle;
> > +#endif
>
> Why is this a #ifdef at all here?
>
> thanks,
>
> greg k-h
