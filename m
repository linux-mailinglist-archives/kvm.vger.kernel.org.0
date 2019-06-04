Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEE8345C6
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 13:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727542AbfFDLpg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 07:45:36 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34782 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727398AbfFDLpg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 07:45:36 -0400
Received: by mail-pl1-f195.google.com with SMTP id i2so3907576plt.1
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2019 04:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ROpXrP+r2OC9uJKtrd7VeU5I2GEkuLFi73TKRyEYr3w=;
        b=YbXtk1gZpPouwSYE2Vhs1oY1Y4f37CPgCl4rhCDKDXOACPNCfLr9np6wKfbnqxvNqK
         net1HG8o5wBQb4vNApxrOerpg8MX7Frcm0nkoJCRedOp4gIlsU8B+szPQLnyAp7uDFz6
         18a5z5D1t2cCXPLwVyjN57+1xoFuuaOeWrZS3QYEL6m6NSRbpHdyTtJVRsjz8hDvO7ay
         x4MfN3T0GXyhVOPDl8Cb4swrSICIbrgdMT9k5w6B73MKVGcGVf0T8Ojj0gm6GQdck4bi
         ehe9TCYVm49T6ewlmRPV9pTGt0imE7M4Hg2EyyudgsziWrwS3zmaj416nN50DFpNVxSV
         8gRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ROpXrP+r2OC9uJKtrd7VeU5I2GEkuLFi73TKRyEYr3w=;
        b=ayxb1apHVl6Y1+WFCnbOq/TpzgRT1vM93Zk4SWC6b4bm0Zgs7NZPVsLyeHKHVdnR2D
         RFWpyNcOLY/0FAnMgKWKyBIFMxCHkZEh2wP8AoD3DqU4qIIH+6vHhSsBsjFIh3Ujp6zW
         SlzlE+gD5ZbGtKvLT/N5J/rhRckyon98jCllYBM8+bZqiI7YuhbMZPNaWr3/zGtsf34d
         9evBDXVpsoXNhuFasSscRJuAE/9SMAX9oVWUWWC72QFTE+DLsb1xSi5BrrnIemjc1RlL
         kZKwTFSkmqwehjH4L4wFbWDj+7CsB4HffT0PrvQqEq9qcgQOPC80TNzGnxRhrLQeRvBf
         CGvA==
X-Gm-Message-State: APjAAAUh94puFDC0uG66BcYxQPRU8lQi3G0YfULH/8P5DdqLpRZBYYQ3
        yomZoh2Gv2id3VC2i/zD5Ikc1ej5NpvB7lLajDQZ2A==
X-Google-Smtp-Source: APXvYqw/MEeiL2bhH+9bBygV1lo6Im71uAjcUSVWx84fFkrTwjlzF36BIb4PZCfj0/vMKrfmiVx/F/2QMSAp/3q5QEs=
X-Received: by 2002:a17:902:8609:: with SMTP id f9mr33680584plo.252.1559648735444;
 Tue, 04 Jun 2019 04:45:35 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1559580831.git.andreyknvl@google.com> <097bc300a5c6554ca6fd1886421bb2e0adb03420.1559580831.git.andreyknvl@google.com>
 <8ff5b0ff-849a-1e0b-18da-ccb5be85dd2b@oracle.com> <CAAeHK+xX2538e674Pz25unkdFPCO_SH0pFwFu=8+DS7RzfYnLQ@mail.gmail.com>
 <f6711d31-e52c-473a-d7ad-b2d63131d7a5@oracle.com> <20190603172916.GA5390@infradead.org>
 <7a687a26-fc3e-2caa-1d6a-464f1f7e684c@oracle.com>
In-Reply-To: <7a687a26-fc3e-2caa-1d6a-464f1f7e684c@oracle.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Tue, 4 Jun 2019 13:45:24 +0200
Message-ID: <CAAeHK+wccK1upfOWxNbZBR0BUWT23VFUFEqRTEp3H+8hXN8yzw@mail.gmail.com>
Subject: Re: [PATCH v16 01/16] uaccess: add untagged_addr definition for other arches
To:     Khalid Aziz <khalid.aziz@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, linux-media@vger.kernel.org,
        kvm@vger.kernel.org,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        Christian Koenig <Christian.Koenig@amd.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Dave Martin <Dave.Martin@arm.com>, enh <enh@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        Evgeniy Stepanov <eugenis@google.com>,
        Lee Smith <Lee.Smith@arm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        Jacob Bramley <Jacob.Bramley@arm.com>,
        Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 3, 2019 at 8:17 PM Khalid Aziz <khalid.aziz@oracle.com> wrote:
>
> On 6/3/19 11:29 AM, Christoph Hellwig wrote:
> > On Mon, Jun 03, 2019 at 11:24:35AM -0600, Khalid Aziz wrote:
> >> On 6/3/19 11:06 AM, Andrey Konovalov wrote:
> >>> On Mon, Jun 3, 2019 at 7:04 PM Khalid Aziz <khalid.aziz@oracle.com> wrote:
> >>>> Andrey,
> >>>>
> >>>> This patch has now become part of the other patch series Chris Hellwig
> >>>> has sent out -
> >>>> <https://lore.kernel.org/lkml/20190601074959.14036-1-hch@lst.de/>. Can
> >>>> you coordinate with that patch series?
> >>>
> >>> Hi!
> >>>
> >>> Yes, I've seen it. How should I coordinate? Rebase this series on top
> >>> of that one?
> >>
> >> That would be one way to do it. Better yet, separate this patch from
> >> both patch series, make it standalone and then rebase the two patch
> >> series on top of it.
> >
> > I think easiest would be to just ask Linus if he could make an exception
> > and include this trivial prep patch in 5.2-rc.
> >
>
> Andrey,
>
> Would you mind updating the commit log to make it not arm64 specific and
> sending this patch out by itself. We can then ask Linus if he can
> include just this patch in the next rc.

Sure! Just sent it out.

>
> Thanks,
> Khalid
>
