Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3028E69A72
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 20:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729307AbfGOSFN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 14:05:13 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:35338 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730192AbfGOSFN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 14:05:13 -0400
Received: by mail-qt1-f195.google.com with SMTP id d23so16622159qto.2
        for <kvm@vger.kernel.org>; Mon, 15 Jul 2019 11:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oQ4K7j9A7KZ0nbwdC0yOxg3aR/aRtjl8qzNQbwacYqI=;
        b=PwR1EtCrURwrbo7TpqHuOvhX3LIycbjKkBb4iZ6+YCuC60ErzFmtlkMrRo9GfbX0ep
         bOPWg9HzO0UREAz1sjKJFk3TljxpYwzvCkuA0H8lubNfJCvY2ASmYBnxIKBySJaciMh9
         IWCtA6vd68VwBDPGY07TF40sWdRGtt46+KtuhJCf3Dkv+hk0kDlTClc7v0FgkXnm9Td6
         i1yxqpRiKWqC8epriEnPtS7rhozNGFmNJhWNANw7o2ytOh0Tu6qDWMUojtH/q6UpZnph
         8NNcHVz4Emezex9wQTSbQUH4N9LwFgHNyRTzxKvxiscGagPT01BlLq6kMX4xBhj5skGH
         0P7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oQ4K7j9A7KZ0nbwdC0yOxg3aR/aRtjl8qzNQbwacYqI=;
        b=oXfRdJX2zqjoepCnZJi7UPVAmsrj+5dOzI6JF02MjaFTLPR30QmlaG/aMGzLk+JwhE
         BjS8ztF+YiuBtbj+pLeL2lrteZoItOLLOjZWL3MqvLTB4WtCjNrmLnWiMdzqC0EgdYzM
         EbKOMgkf1A4AH7UwxNVigk8fDh8gb+BytkRfJ4fb2VhaiLp54C6YmaNSxOlRuG10aEz6
         f7dyGLfyoe3cDjOHbbKn5lQ7NSuT4hs1jKtKo1qiwkJ759DcB0BMKj6plVjV5cKalwEG
         Tz5ImqLu0LCePBDupzJurnw9M2iSF9H6GzDGRSu05UpD66OD4dpdYVl8khPDvhK1La3B
         EZ7A==
X-Gm-Message-State: APjAAAUqnuXJdlvctbXBQ4Lo6NdDFpYTEV7VfTXhSON8el9yaYw21MFz
        SCCuTDRKlcCDZ9+cUPYr77UE9A==
X-Google-Smtp-Source: APXvYqzV3YFI+MpwRBSBS9L25rk8A7XfyA1gAg9YfhwBzidc1Vfy+exQVLzBpqEA6++D83b7IWLy1g==
X-Received: by 2002:a05:6214:3a5:: with SMTP id m5mr19973542qvy.7.1563213911969;
        Mon, 15 Jul 2019 11:05:11 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id l80sm8277974qke.24.2019.07.15.11.05.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Jul 2019 11:05:11 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hn5La-0001zV-SL; Mon, 15 Jul 2019 15:05:10 -0300
Date:   Mon, 15 Jul 2019 15:05:10 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Andrey Konovalov <andreyknvl@google.com>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
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
        Dave Martin <Dave.Martin@arm.com>,
        Khalid Aziz <khalid.aziz@oracle.com>, enh <enh@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        Evgeniy Stepanov <eugenis@google.com>,
        Lee Smith <Lee.Smith@arm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        Jacob Bramley <Jacob.Bramley@arm.com>,
        Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Szabolcs Nagy <Szabolcs.Nagy@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v18 11/15] IB/mlx4: untag user pointers in
 mlx4_get_umem_mr
Message-ID: <20190715180510.GC4970@ziepe.ca>
References: <cover.1561386715.git.andreyknvl@google.com>
 <ea0ff94ef2b8af12ea6c222c5ebd970e0849b6dd.1561386715.git.andreyknvl@google.com>
 <20190624174015.GL29120@arrakis.emea.arm.com>
 <CAAeHK+y8vE=G_odK6KH=H064nSQcVgkQkNwb2zQD9swXxKSyUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeHK+y8vE=G_odK6KH=H064nSQcVgkQkNwb2zQD9swXxKSyUQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 15, 2019 at 06:01:29PM +0200, Andrey Konovalov wrote:
> On Mon, Jun 24, 2019 at 7:40 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
> >
> > On Mon, Jun 24, 2019 at 04:32:56PM +0200, Andrey Konovalov wrote:
> > > This patch is a part of a series that extends kernel ABI to allow to pass
> > > tagged user pointers (with the top byte set to something else other than
> > > 0x00) as syscall arguments.
> > >
> > > mlx4_get_umem_mr() uses provided user pointers for vma lookups, which can
> > > only by done with untagged pointers.
> > >
> > > Untag user pointers in this function.
> > >
> > > Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> > >  drivers/infiniband/hw/mlx4/mr.c | 7 ++++---
> > >  1 file changed, 4 insertions(+), 3 deletions(-)
> >
> > Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> >
> > This patch also needs an ack from the infiniband maintainers (Jason).
> 
> Hi Jason,
> 
> Could you take a look and give your acked-by?

Oh, I think I did this a long time ago. Still looks OK. You will send
it?

Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>

Jason
