Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 020AC132553
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 12:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbgAGLzc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 06:55:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33070 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726690AbgAGLzc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 06:55:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578398129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KKDZj81sAccgrzkhgIj794ifqolNRhLOvA0CIx37wWs=;
        b=WFJcxeTLfbM3CgWgC55v3gvcfSIwpc/qCDiuBzQbAbe0VoBdCJpWs1y88gC1nPs/2zOftu
        8VweNe97R7CRNHuR/Zc33qXPuDDGKBnQ9usdm4TS+dKXobofWav+/FdKrG2aun5fIX0aje
        onRKeSek6TMdtTu07bzLH4JP3qXlfp0=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-R66hIVf4NeSdBgPqkc7T8Q-1; Tue, 07 Jan 2020 06:55:28 -0500
X-MC-Unique: R66hIVf4NeSdBgPqkc7T8Q-1
Received: by mail-qt1-f199.google.com with SMTP id t4so36356480qtd.3
        for <kvm@vger.kernel.org>; Tue, 07 Jan 2020 03:55:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=KKDZj81sAccgrzkhgIj794ifqolNRhLOvA0CIx37wWs=;
        b=SGfz/fNwFx3Zz00vPrsnrzkxIS1OdaFNMZHcKzVjUkeKi4UewxBQofK1QCajtzdj4N
         sWOr1+2uR7w8t1I7gXxiv5X8l92nVGJt9aJMLHWgz3tDBwHMhXGegixbftMnJybBXUz2
         tHcknCeJw1+QXCiGHy8/y+Cq55Wbkp7UoCzXjpI2Xy2Z3dn3i1pXJu2ClbYHR7q+u5In
         qhWjY+R2SNHFT8hKrvfQry6MCP7mtLkFzA2vFOmmnvOJPfrhxse5UJdPrGMXqMXdynbe
         XZ/V9BFGDImLFHqRS+G/nps6S7Q2z7uHywyJAvkJPjxSOt2KBU0tuvT9zCa4zzyszOLe
         rDBA==
X-Gm-Message-State: APjAAAXxRusib8B5rqNeVV8T/oYe5gqS63U9JEGcA4XO5MEdTpGAmyp5
        FOQz9QukJBQR8isane1h/JltSfPK+QVvmMXw+WDD8F/MvOAVVKcvMt8Gg/2pnV59EccOydCsWUF
        pMzEV6Q+rUYnk
X-Received: by 2002:a37:a642:: with SMTP id p63mr80587785qke.85.1578398127873;
        Tue, 07 Jan 2020 03:55:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqyq1n8OiAxkRvySBU4BNoH32+bCXpIgv5dDJl00BVFh2v1+ue0mG4WwIqiHHC8FA0mwU5qoug==
X-Received: by 2002:a37:a642:: with SMTP id p63mr80587764qke.85.1578398127536;
        Tue, 07 Jan 2020 03:55:27 -0800 (PST)
Received: from redhat.com (bzq-79-183-34-164.red.bezeqint.net. [79.183.34.164])
        by smtp.gmail.com with ESMTPSA id d71sm22259619qkg.4.2020.01.07.03.55.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 03:55:26 -0800 (PST)
Date:   Tue, 7 Jan 2020 06:55:22 -0500
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
Message-ID: <20200107065434-mutt-send-email-mst@kernel.org>
References: <c022e1d6-0d57-ae07-5e6b-8e40d3b01f4b@de.ibm.com>
 <20191218100926-mutt-send-email-mst@kernel.org>
 <2ffdbd95-e375-a627-55a1-6990b0a0e37a@de.ibm.com>
 <20200106054041-mutt-send-email-mst@kernel.org>
 <08ae8d28-3d8c-04e8-bdeb-0117d06c6dc7@de.ibm.com>
 <20200107042401-mutt-send-email-mst@kernel.org>
 <c6795e53-d12c-0709-c2e9-e35d9af1f693@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c6795e53-d12c-0709-c2e9-e35d9af1f693@de.ibm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 07, 2020 at 12:34:50PM +0100, Christian Borntraeger wrote:
> 
> 
> On 07.01.20 10:39, Michael S. Tsirkin wrote:
> > On Tue, Jan 07, 2020 at 09:59:16AM +0100, Christian Borntraeger wrote:
> >>
> >>
> >> On 06.01.20 11:50, Michael S. Tsirkin wrote:
> >>> On Wed, Dec 18, 2019 at 04:59:02PM +0100, Christian Borntraeger wrote:
> >>>> On 18.12.19 16:10, Michael S. Tsirkin wrote:
> >>>>> On Wed, Dec 18, 2019 at 03:43:43PM +0100, Christian Borntraeger wrote:
> >>>>>> Michael,
> >>>>>>
> >>>>>> with 
> >>>>>> commit db7286b100b503ef80612884453bed53d74c9a16 (refs/bisect/skip-db7286b100b503ef80612884453bed53d74c9a16)
> >>>>>>     vhost: use batched version by default
> >>>>>> plus
> >>>>>> commit 6bd262d5eafcdf8cdfae491e2e748e4e434dcda6 (HEAD, refs/bisect/bad)
> >>>>>>     Revert "vhost/net: add an option to test new code"
> >>>>>> to make things compile (your next tree is not easily bisectable, can you fix that as well?).
> >>>>>
> >>>>> I'll try.
> >>>>>
> >>>>>>
> >>>>>> I get random crashes in my s390 KVM guests after reboot.
> >>>>>> Reverting both patches together with commit decd9b8 "vhost: use vhost_desc instead of vhost_log" to
> >>>>>> make it compile again) on top of linux-next-1218 makes the problem go away.
> >>>>>>
> >>>>>> Looks like the batched version is not yet ready for prime time. Can you drop these patches until
> >>>>>> we have fixed the issues?
> >>>>>>
> >>>>>> Christian
> >>>>>>
> >>>>>
> >>>>> Will do, thanks for letting me know.
> >>>>
> >>>> I have confirmed with the initial reporter (internal test team) that <driver name='qemu'/> 
> >>>> with a known to be broken linux next kernel also fixes the problem, so it is really the
> >>>> vhost changes.
> >>>
> >>> OK I'm back and trying to make it more bisectable.
> >>>
> >>> I pushed a new tag "batch-v2".
> >>> It's same code but with this bisect should get more information.
> >>
> >> I get the following with this tag
> >>
> >> drivers/vhost/net.c: In function ‘vhost_net_tx_get_vq_desc’:
> >> drivers/vhost/net.c:574:7: error: implicit declaration of function ‘vhost_get_vq_desc_batch’; did you mean ‘vhost_get_vq_desc’? [-Werror=implicit-function-declaration]
> >>   574 |   r = vhost_get_vq_desc_batch(tvq, tvq->iov, ARRAY_SIZE(tvq->iov),
> >>       |       ^~~~~~~~~~~~~~~~~~~~~~~
> >>       |       vhost_get_vq_desc
> >>
> > 
> > Not sure why but I pushed a wrong commit. Sorry. Should be good now.
> > 
> 
> during bisect:
> 
> drivers/vhost/vhost.c: In function ‘vhost_get_vq_desc_batch’:
> drivers/vhost/vhost.c:2634:8: error: ‘id’ undeclared (first use in this function); did you mean ‘i’?
>  2634 |  ret = id;
>       |        ^~
>       |        i
> 
> I changed that to i
> 
> 
> The last step then gave me  (on commit 50297a8480b439efc5f3f23088cb2d90b799acef vhost: use batched version by default)
> net enc1: Unexpected TXQ (0) queue failure: -5
> in the guest.
> 
> bisect log so far:
> [cborntra@m83lp52 linux]$ git bisect log
> git bisect start
> # bad: [3131e79bb9e9892a5a6bd33513de9bc90b20e867] vhost: use vhost_desc instead of vhost_log
> git bisect bad 3131e79bb9e9892a5a6bd33513de9bc90b20e867
> # good: [d1281e3a562ec6a08f944a876481dd043ba739b9] virtio-blk: remove VIRTIO_BLK_F_SCSI support
> git bisect good d1281e3a562ec6a08f944a876481dd043ba739b9
> # good: [5b00aab5b6332a67e32dace1dcd3a198ab94ed56] vhost: option to fetch descriptors through an independent struct
> git bisect good 5b00aab5b6332a67e32dace1dcd3a198ab94ed56
> # good: [5b00aab5b6332a67e32dace1dcd3a198ab94ed56] vhost: option to fetch descriptors through an independent struct
> git bisect good 5b00aab5b6332a67e32dace1dcd3a198ab94ed56
> # bad: [1414d7ee3d10d2ec2bc4ee652d1d90ec91da1c79] vhost: batching fetches
> git bisect bad 1414d7ee3d10d2ec2bc4ee652d1d90ec91da1c79
> 
> 

I pushed batched-v3 - same head but bisect should work now.

-- 
MST

