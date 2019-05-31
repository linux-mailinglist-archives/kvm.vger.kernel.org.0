Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 923DD31241
	for <lists+kvm@lfdr.de>; Fri, 31 May 2019 18:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfEaQYU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 May 2019 12:24:20 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46936 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726649AbfEaQYU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 May 2019 12:24:20 -0400
Received: by mail-pf1-f193.google.com with SMTP id y11so6476783pfm.13
        for <kvm@vger.kernel.org>; Fri, 31 May 2019 09:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h/x2RsdaGEeomdfj9zckwm1ZuXHc7ti1LUsxVKWauDI=;
        b=WkbNgEwAtHoOpsgf2n/OOj9tvUzmqxkk0wFQPqMbZDhKXrycKmph8DKGky42GC+koN
         LJDEln958wkwnmRH28ZEap3NrGgf1V1D0g9IZCcP3z1+J4jMqALHLTOUy5KwiFNCWFFp
         J5Vof1T/5pKxOH0N8kkgt3VneNxkghx7TLiVO3NO5Dfw0XE9zLDEnv4oejnEpiTXZOeJ
         tDxDbRBsv0ZCYRogl5V2uwQD8iTi3aUBJXQrVEho7perE1vFrdRi0BvQ0ve9Pq7qowuL
         FRZuY21tQBRvNHvnsPyF6is+8mWCTar820ssvKvNtiwoTjNWK3ZyaVAaR6TMz/HMowZi
         esrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h/x2RsdaGEeomdfj9zckwm1ZuXHc7ti1LUsxVKWauDI=;
        b=YNzv+1ZdFXOOIM/BRqceBONGKuewApK1flhIrQsC9xtBsk/TObT7LUeOroGsXP6u5C
         Molzle74846j8TNPR/aeBfA/6tCvxsaXUXH/VUS+DIaM9GQncC1BSTogTP2TV3K2dEuD
         Slq7ld31VKLv1Ihe2KHjU5EEUGXhixeQ5Do72WeRbOMdFvsemDwU6FJHlDYKLb+tqkyn
         JOheqC9nnvpkCGTQy1vvJ/8gH8JhUHdsJifmvXVRSan3p7IDzAagkwRZUYoyV6f8LYLr
         coAx5JeMj6Sf/XBhBMyfZHgoQvzYOtiVakmL0scQiCgESn1btASjmxe15MYVdMp1FC9U
         nfkQ==
X-Gm-Message-State: APjAAAVil3IYZj0T2HJNudOn1Ca6MGelAmBoTRTj0v8oaMhIVNqIal/5
        uwVR19QNX55M+QjAW7HpUO8EMGlu8Xf+6OPgxwY5gA==
X-Google-Smtp-Source: APXvYqxuY1CYuxd04Kewq/lINHwhx4xTvJLFZIhJ6+qsHKD7HtPQ0W1vOSTfUsi9VyOoypjJcb2qINRGGNrlijbQeNg=
X-Received: by 2002:a62:2c17:: with SMTP id s23mr11223321pfs.51.1559319859023;
 Fri, 31 May 2019 09:24:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190521182932.sm4vxweuwo5ermyd@mbp> <201905211633.6C0BF0C2@keescook>
 <6049844a-65f5-f513-5b58-7141588fef2b@oracle.com> <20190523201105.oifkksus4rzcwqt4@mbp>
 <ffe58af3-7c70-d559-69f6-1f6ebcb0fec6@oracle.com> <20190524101139.36yre4af22bkvatx@mbp>
 <c6dd53d8-142b-3d8d-6a40-d21c5ee9d272@oracle.com> <CAAeHK+yAUsZWhp6xPAbWewX5Nbw+-G3svUyPmhXu5MVeEDKYvA@mail.gmail.com>
 <20190530171540.GD35418@arrakis.emea.arm.com> <CAAeHK+y34+SNz3Vf+_378bOxrPaj_3GaLCeC2Y2rHAczuaSz1A@mail.gmail.com>
 <20190531161954.GA3568@arrakis.emea.arm.com>
In-Reply-To: <20190531161954.GA3568@arrakis.emea.arm.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Fri, 31 May 2019 18:24:06 +0200
Message-ID: <CAAeHK+zRDD7ZPPUA9cpwHOdgTRrJLWAby8Wg9oPgmhqMpHwvFw@mail.gmail.com>
Subject: Re: [PATCH v15 00/17] arm64: untag user pointers passed to the kernel
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Evgenii Stepanov <eugenis@google.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, linux-media@vger.kernel.org,
        kvm@vger.kernel.org,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        Christian Koenig <Christian.Koenig@amd.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        Lee Smith <Lee.Smith@arm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        Jacob Bramley <Jacob.Bramley@arm.com>,
        Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Szabolcs Nagy <Szabolcs.Nagy@arm.com>,
        Elliott Hughes <enh@google.com>,
        Khalid Aziz <khalid.aziz@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 31, 2019 at 6:20 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> On Fri, May 31, 2019 at 04:29:10PM +0200, Andrey Konovalov wrote:
> > On Thu, May 30, 2019 at 7:15 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > On Tue, May 28, 2019 at 04:14:45PM +0200, Andrey Konovalov wrote:
> > > > Thanks for a lot of valuable input! I've read through all the replies
> > > > and got somewhat lost. What are the changes I need to do to this
> > > > series?
> > > >
> > > > 1. Should I move untagging for memory syscalls back to the generic
> > > > code so other arches would make use of it as well, or should I keep
> > > > the arm64 specific memory syscalls wrappers and address the comments
> > > > on that patch?
> > >
> > > Keep them generic again but make sure we get agreement with Khalid on
> > > the actual ABI implications for sparc.
> >
> > OK, will do. I find it hard to understand what the ABI implications
> > are. I'll post the next version without untagging in brk, mmap,
> > munmap, mremap (for new_address), mmap_pgoff, remap_file_pages, shmat
> > and shmdt.
>
> It's more about not relaxing the ABI to accept non-zero top-byte unless
> we have a use-case for it. For mmap() etc., I don't think that's needed
> but if you think otherwise, please raise it.
>
> > > > 2. Should I make untagging opt-in and controlled by a command line argument?
> > >
> > > Opt-in, yes, but per task rather than kernel command line option.
> > > prctl() is a possibility of opting in.
> >
> > OK. Should I store a flag somewhere in task_struct? Should it be
> > inheritable on clone?
>
> A TIF flag would do but I'd say leave it out for now (default opted in)
> until we figure out the best way to do this (can be a patch on top of
> this series).

You mean leave the whole opt-in/prctl part out? So the only change
would be to move untagging for memory syscalls into generic code?

>
> Thanks.
>
> --
> Catalin
