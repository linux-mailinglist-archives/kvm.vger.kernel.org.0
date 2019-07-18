Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 563706D640
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 23:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbfGRVJX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 17:09:23 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:37193 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727687AbfGRVJW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 17:09:22 -0400
Received: by mail-qt1-f194.google.com with SMTP id y26so28761525qto.4;
        Thu, 18 Jul 2019 14:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dyup3V+7x6vR5f0mEdgXHm4ad/gxVODy2UYvXjZtm38=;
        b=g/A6ZSXFBVZwZkYYxAc6/240ZOw/nl+fyU7BjnEptzhSBtU1aTXriTXck/+BG1DVOY
         EV7nAttQx1wz7J9GFiiRlu0+0fpCDFuK708Veu0VrtQUKch3fKT7QXOYuBgA8ioW/L8g
         2yZ0VeWPfE0VAB52AKfusR8k1B+mH6sY1xsE/zS6Lw2e7m1ItUaud6iua3qpHdSKDx8W
         +J+F5QDBMqMYtZmLIUaPCxV6mlxG/HcVbe7ITBXceI3phQoSF7h/u01JzOVR0mj3Kh2y
         H9GcUErP1w0nbrRy6K7wnuPkIyOSttzXPL1P2OKYyjOOPeZvocpNWmgMp6FzpqRmFiHN
         SOfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dyup3V+7x6vR5f0mEdgXHm4ad/gxVODy2UYvXjZtm38=;
        b=NGHzAZu8riSRlZtN2VE8iL/AYp3oMgBD6wMr6OoatI8aSeApYuCcgM3+6nSTy0Fcv9
         cbda8P5jLWwDHNhwpdIkf21ybWnd/tYiFwMohmSiM3GgPvU+hFVhgF1+2dUzqBwAIfVi
         ktjOXLGEmEFADG7rQfkm3bLaKUXvKDbG/rJetveAak67x7itc7amn97Es0wX1S7xfd6z
         N30791N4g/k8lCPR1cw/8NTnVgmxw/mWf72tJ4J87Zx5uSzA2yz67COuoDQZjOJ1jCpT
         dBW+jmcMUixl7jMiv9lwEFR8iM695XToDDUXUhdDMHwzcB7/wm8d4ftIf2wUskJPyvlV
         Lpaw==
X-Gm-Message-State: APjAAAXcvfMFP7FTvP0p/taVZ/zfO9hX1oL7SbHteVz/pvKlKf0PIhw/
        aSLWHFTFsSO7zIcFI1EfKJw5dTA48wo0IWoX9Mc=
X-Google-Smtp-Source: APXvYqx/Xj+iAj6ZhkMjTX1Z+74RGCpbHhz221hQ/4tFr/eSNb0ZRWjxjhZdyPpTxY3WuORbyCrdGEBMm+KsiHIPG48=
X-Received: by 2002:a0c:b095:: with SMTP id o21mr35480609qvc.73.1563484161439;
 Thu, 18 Jul 2019 14:09:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190716115535-mutt-send-email-mst@kernel.org>
 <CAKgT0Ud47-cWu9VnAAD_Q2Fjia5gaWCz_L9HUF6PBhbugv6tCQ@mail.gmail.com>
 <20190716125845-mutt-send-email-mst@kernel.org> <CAKgT0UfgPdU1H5ZZ7GL7E=_oZNTzTwZN60Q-+2keBxDgQYODfg@mail.gmail.com>
 <20190717055804-mutt-send-email-mst@kernel.org> <CAKgT0Uf4iJxEx+3q_Vo9L1QPuv9PhZUv1=M9UCsn6_qs7rG4aw@mail.gmail.com>
 <20190718003211-mutt-send-email-mst@kernel.org> <CAKgT0UfQ3dtfjjm8wnNxX1+Azav6ws9zemH6KYc7RuyvyFo3fQ@mail.gmail.com>
 <20190718162040-mutt-send-email-mst@kernel.org> <CAKgT0UcKTzSYZnYsMQoG6pXhpDS7uLbDd31dqfojCSXQWSsX_A@mail.gmail.com>
 <20190718164656-mutt-send-email-mst@kernel.org>
In-Reply-To: <20190718164656-mutt-send-email-mst@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 18 Jul 2019 14:09:10 -0700
Message-ID: <CAKgT0UchVPRuM1pNnsuxcJrTg1-tWQWzW1+q=_v7VuEDS3pL5g@mail.gmail.com>
Subject: Re: [PATCH v1 6/6] virtio-balloon: Add support for aerating memory
 via hinting
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yang Zhang <yang.zhang.wz@gmail.com>, pagupta@redhat.com,
        Rik van Riel <riel@surriel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        lcapitulino@redhat.com, wei.w.wang@intel.com,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, dan.j.williams@intel.com,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 18, 2019 at 1:49 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Thu, Jul 18, 2019 at 01:34:03PM -0700, Alexander Duyck wrote:
> > On Thu, Jul 18, 2019 at 1:24 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Thu, Jul 18, 2019 at 08:34:37AM -0700, Alexander Duyck wrote:
> > > > > > > For example we allocate pages until shrinker kicks in.
> > > > > > > Fair enough but in fact many it would be better to
> > > > > > > do the reverse: trigger shrinker and then send as many
> > > > > > > free pages as we can to host.
> > > > > >
> > > > > > I'm not sure I understand this last part.
> > > > >
> > > > > Oh basically what I am saying is this: one of the reasons to use page
> > > > > hinting is when host is short on memory.  In that case, why don't we use
> > > > > shrinker to ask kernel drivers to free up memory? Any memory freed could
> > > > > then be reported to host.
> > > >
> > > > Didn't the balloon driver already have a feature like that where it
> > > > could start shrinking memory if the host was under memory pressure? If
> > > > so how would adding another one add much value.
> > >
> > > Well fundamentally the basic balloon inflate kind of does this, yes :)
> > >
> > > The difference with what I am suggesting is that balloon inflate tries
> > > to aggressively achieve a specific goal of freed memory. We could have a
> > > weaker "free as much as you can" that is still stronger than free page
> > > hint which as you point out below does not try to free at all, just
> > > hints what is already free.
> >
> > Yes, but why wait until the host is low on memory?
>
> It can come about for a variety of reasons, such as
> other VMs being aggressive, or ours aggressively caching
> stuff in memory.
>
> > With my
> > implementation we can perform the hints in the background for a low
> > cost already. So why should we wait to free up memory when we could do
> > it immediately. Why let things get to the state where the host is
> > under memory pressure when the guests can be proactively freeing up
> > the pages and improving performance as a result be reducing swap
> > usage?
>
> You are talking about sending free memory to host.
> Fair enough but if you have drivers that aggressively
> allocate memory then there won't be that much free guest
> memory without invoking a shrinker.

So then what we really need is a way for the host to trigger the
shrinker via a call to drop_slab() on the guest don't we? Then we
could automatically hint the free pages to the host.
