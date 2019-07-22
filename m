Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C92A6FBF3
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2019 11:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728908AbfGVJOk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jul 2019 05:14:40 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36358 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728887AbfGVJOk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jul 2019 05:14:40 -0400
Received: by mail-wm1-f65.google.com with SMTP id g67so30417750wme.1
        for <kvm@vger.kernel.org>; Mon, 22 Jul 2019 02:14:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=buyBwragh/MiAtoP/qWU/+3wC1FPeSO8mS8xKGZe0WM=;
        b=OcxPue8HFN7qOpg6kaZkevUGIpCWZqrtr2HfjKDFsbYVbH/DIq48g0W8Fg+1LOSJBT
         Eq+0Y03//1D5oXdYmzRuYAe/85UNO9++W+G9uTiPlY0i4myjR1JGUuLDtI54v3b83W7l
         9u/LGVJf6COnoMxcSIm/j3hV26R1B8CnnqMnpzRJVsE3Ey168m6MDoubDEupv9TwKwdC
         EZmz/W3EZalz8J+6fbiz2jIl2lk60qpXQq1TOfvNuhDCSoecbe+GkZEDeC9nXzqMS5gL
         yjOSsHGhoAm9KBPmzdamr7MoOa1hKPoopm3cMdUV0qD8bVStyXgpTkIHNPEPBclprx2Z
         0FXg==
X-Gm-Message-State: APjAAAVfM/H06g/DsOiva5cgLZrCFgRigCb01I3NVg6PGqjHq0dwfvET
        kgkAAw9gZJbb7CTjGdzOVOGShw==
X-Google-Smtp-Source: APXvYqxfShD/ei8RpJHH52M/aLQwRYii5G8tfg7PqTI4yQdrNr4boM5EbfQYG922Ax7/DzQZYsBz9A==
X-Received: by 2002:a1c:5f87:: with SMTP id t129mr66150883wmb.150.1563786877819;
        Mon, 22 Jul 2019 02:14:37 -0700 (PDT)
Received: from steredhat (host122-201-dynamic.13-79-r.retail.telecomitalia.it. [79.13.201.122])
        by smtp.gmail.com with ESMTPSA id 18sm35831732wmg.43.2019.07.22.02.14.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 02:14:37 -0700 (PDT)
Date:   Mon, 22 Jul 2019 11:14:34 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v4 0/5] vsock/virtio: optimizations to increase the
 throughput
Message-ID: <20190722091434.tzf7lxw3tvrs5w5v@steredhat>
References: <20190717113030.163499-1-sgarzare@redhat.com>
 <20190722090835.GF24934@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190722090835.GF24934@stefanha-x1.localdomain>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 22, 2019 at 10:08:35AM +0100, Stefan Hajnoczi wrote:
> On Wed, Jul 17, 2019 at 01:30:25PM +0200, Stefano Garzarella wrote:
> > This series tries to increase the throughput of virtio-vsock with slight
> > changes.
> > While I was testing the v2 of this series I discovered an huge use of memory,
> > so I added patch 1 to mitigate this issue. I put it in this series in order
> > to better track the performance trends.
> > 
> > v4:
> > - rebased all patches on current master (conflicts is Patch 4)
> > - Patch 1: added Stefan's R-b
> > - Patch 3: removed lock when buf_alloc is written [David];
> >            moved this patch after "vsock/virtio: reduce credit update messages"
> >            to make it clearer
> > - Patch 4: vhost_exceeds_weight() is recently introduced, so I've solved some
> >            conflicts
> 
> Stefano: Do you want to continue experimenting before we merge this
> patch series?  The code looks functionally correct and the performance
> increases, so I'm happy for it to be merged.

I think we can merge this series.

I'll continue to do other experiments (e.g. removing TX workers, allocating
pages, etc.) but I think these changes are prerequisites for the other patches,
so we can merge them.

Thank you very much for the reviews!
Stefano
