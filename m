Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE4DC1322A4
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 10:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbgAGJjL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 04:39:11 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56630 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727559AbgAGJjK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 04:39:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578389949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KTZsZnppU+2QHEms25h87mEXIcd3CR1WH++YNAVYQNY=;
        b=E0E59r7nXc15Ugy5ig041GMuBr51+WGsKOktoetnTalvgh73vgmZCtbDi2k1dEV2t/vvTS
        NF0q5SadBMqzCTIZPwmZ9VMZilS5R1zSnmDnn21PJx49M9PIagCDaVJ+5r1qEZ+5o1red5
        QonH7W3MrxNhEUs6S2GkVesAdu7Ai1w=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-6wP0hYJVM0mZOh79LWPGUw-1; Tue, 07 Jan 2020 04:39:06 -0500
X-MC-Unique: 6wP0hYJVM0mZOh79LWPGUw-1
Received: by mail-qk1-f200.google.com with SMTP id g28so17546784qkl.6
        for <kvm@vger.kernel.org>; Tue, 07 Jan 2020 01:39:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=KTZsZnppU+2QHEms25h87mEXIcd3CR1WH++YNAVYQNY=;
        b=EejCdYcQqFUwxQHHdunOLlybbMdJglmbvahL02SDMrCJGhGYl8N0gDe8z8twGB1B/e
         F9qbdwxHgu7g/ip9kRYdxgwZieBNDPwJ+zlbvbq1MguNev3IhdCtrhn3hsD9rv9oSVaH
         fKgg0bYIuhbqor0pcMrWURGLpjfBIZQDpdFGQaBQrCFmGfapVZay+TWC544aUUq5nQ1/
         /m/kCU1zNrpaqNwiAgm3yy69Cz3pvS8O26yWD0QjfGkkABbzi+MR9DeQUnkioO4VJO4e
         Sx/zRkr5YKrv18IC23VB4wNYe2sS6vcAL+8p0kxfoKDgsS+5jpiB9BMLPYcKKo69w/oR
         YGkw==
X-Gm-Message-State: APjAAAWSd8p2uiSOhvMecpsbb/aa4S+4PV6+9WivOfEpR8UyInv6QkPo
        v/00mM7lHTYmkbni9QrKjliDBBuombRTf75RjeEQ4jID1GpLWgyNh3rxU9yPTHCuv9XUX+gSyEA
        D4YqG3ocAOOyf
X-Received: by 2002:ac8:1bd4:: with SMTP id m20mr80192052qtk.301.1578389946372;
        Tue, 07 Jan 2020 01:39:06 -0800 (PST)
X-Google-Smtp-Source: APXvYqxNBSffjTXlW+OajOtddlXmtV11+UXzECSfu7cNC0iRx6P/v+pltqGMwIX+pamDcwsrKCW75A==
X-Received: by 2002:ac8:1bd4:: with SMTP id m20mr80192040qtk.301.1578389946145;
        Tue, 07 Jan 2020 01:39:06 -0800 (PST)
Received: from redhat.com (bzq-79-183-34-164.red.bezeqint.net. [79.183.34.164])
        by smtp.gmail.com with ESMTPSA id u57sm24900235qth.68.2020.01.07.01.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 01:39:05 -0800 (PST)
Date:   Tue, 7 Jan 2020 04:39:00 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: vhost changes (batched) in linux-next after 12/13 trigger random
 crashes in KVM guests after reboot
Message-ID: <20200107042401-mutt-send-email-mst@kernel.org>
References: <c022e1d6-0d57-ae07-5e6b-8e40d3b01f4b@de.ibm.com>
 <20191218100926-mutt-send-email-mst@kernel.org>
 <2ffdbd95-e375-a627-55a1-6990b0a0e37a@de.ibm.com>
 <20200106054041-mutt-send-email-mst@kernel.org>
 <08ae8d28-3d8c-04e8-bdeb-0117d06c6dc7@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <08ae8d28-3d8c-04e8-bdeb-0117d06c6dc7@de.ibm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 07, 2020 at 09:59:16AM +0100, Christian Borntraeger wrote:
> 
> 
> On 06.01.20 11:50, Michael S. Tsirkin wrote:
> > On Wed, Dec 18, 2019 at 04:59:02PM +0100, Christian Borntraeger wrote:
> >> On 18.12.19 16:10, Michael S. Tsirkin wrote:
> >>> On Wed, Dec 18, 2019 at 03:43:43PM +0100, Christian Borntraeger wrote:
> >>>> Michael,
> >>>>
> >>>> with 
> >>>> commit db7286b100b503ef80612884453bed53d74c9a16 (refs/bisect/skip-db7286b100b503ef80612884453bed53d74c9a16)
> >>>>     vhost: use batched version by default
> >>>> plus
> >>>> commit 6bd262d5eafcdf8cdfae491e2e748e4e434dcda6 (HEAD, refs/bisect/bad)
> >>>>     Revert "vhost/net: add an option to test new code"
> >>>> to make things compile (your next tree is not easily bisectable, can you fix that as well?).
> >>>
> >>> I'll try.
> >>>
> >>>>
> >>>> I get random crashes in my s390 KVM guests after reboot.
> >>>> Reverting both patches together with commit decd9b8 "vhost: use vhost_desc instead of vhost_log" to
> >>>> make it compile again) on top of linux-next-1218 makes the problem go away.
> >>>>
> >>>> Looks like the batched version is not yet ready for prime time. Can you drop these patches until
> >>>> we have fixed the issues?
> >>>>
> >>>> Christian
> >>>>
> >>>
> >>> Will do, thanks for letting me know.
> >>
> >> I have confirmed with the initial reporter (internal test team) that <driver name='qemu'/> 
> >> with a known to be broken linux next kernel also fixes the problem, so it is really the
> >> vhost changes.
> > 
> > OK I'm back and trying to make it more bisectable.
> > 
> > I pushed a new tag "batch-v2".
> > It's same code but with this bisect should get more information.
> 
> I get the following with this tag
> 
> drivers/vhost/net.c: In function ‘vhost_net_tx_get_vq_desc’:
> drivers/vhost/net.c:574:7: error: implicit declaration of function ‘vhost_get_vq_desc_batch’; did you mean ‘vhost_get_vq_desc’? [-Werror=implicit-function-declaration]
>   574 |   r = vhost_get_vq_desc_batch(tvq, tvq->iov, ARRAY_SIZE(tvq->iov),
>       |       ^~~~~~~~~~~~~~~~~~~~~~~
>       |       vhost_get_vq_desc
> 

Not sure why but I pushed a wrong commit. Sorry. Should be good now.

-- 
MST

