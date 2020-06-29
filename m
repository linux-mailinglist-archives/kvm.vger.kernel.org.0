Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A76A920DC9E
	for <lists+kvm@lfdr.de>; Mon, 29 Jun 2020 22:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732739AbgF2URH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jun 2020 16:17:07 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24035 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731844AbgF2TaP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Jun 2020 15:30:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593459013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K0zqM4fozodfs5Zl/LL6zY80CPq4jQW26NEQVOlMlns=;
        b=M4Ogdf60RGlfyJdEWjQuIA8CutmsaF3ptSPFq4n3d9lAjF7daJ3sktL3ILJVzLPN/mWu69
        p1hw2Fe3VlVofDC9vtPxheG7czfUs+9Jr++dko2x1qlLzBiFVPS5YO8pPoWIrACwwLO04q
        qPzj6dlU7NGyCX+cGkwMLNvqo7mWPU4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-poHi0nRjNbW3fjzdWbmcFw-1; Mon, 29 Jun 2020 11:28:46 -0400
X-MC-Unique: poHi0nRjNbW3fjzdWbmcFw-1
Received: by mail-wr1-f69.google.com with SMTP id i12so16616599wrx.11
        for <kvm@vger.kernel.org>; Mon, 29 Jun 2020 08:28:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=K0zqM4fozodfs5Zl/LL6zY80CPq4jQW26NEQVOlMlns=;
        b=sQ8j0QnwnRt90lPT3ROJXs4t289KHasjmY9DvYVR3bsTbhZx2fEITIHHjPxBqZr/QP
         ckTU/k90eD3UEYDHqIWQ1NHIwiCANGd5I+yfrViSxlA8M+wbTm+03D/Zs2GOf+3IxGK4
         lcSCsAwmnaTyI49nUxyZVmXaNmFH8jW3hlEzaPR8m4pPaCdgb6fNAT0EIdITBdqooJjM
         dNr1QtfTK5fe99zmo0+wnutspstKNFsN12OzUUgN4By5leis8hpqnriU5pysggW2Abbm
         M4UP3GuzTmzpi28jz0bBL90NovfcFXAYTEx9LuzRp+qcWJ+C5PM0GNQ6oN3ZfZLbb+xf
         RYqg==
X-Gm-Message-State: AOAM532frcAWa3H3NRQpDWtCDDtHVD5riMNY1RxnXBqZPD5ZNp1vryiU
        c1z3aDRbqEmWMyEZ2CwjroZ2G7PPDhOgeWnzBxzcxcttDqfo3HUSyL79f4OJPvkR8JPMcGTCC1M
        HrnNz2LJohdk4
X-Received: by 2002:a7b:c952:: with SMTP id i18mr18275084wml.65.1593444524742;
        Mon, 29 Jun 2020 08:28:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz7RMK2Tq8coYJFEBNUmuEHP3h5aGlELHq7DlEEAKWPLImLhTJ9vgAoBLyzyynl78hZbHgVSQ==
X-Received: by 2002:a7b:c952:: with SMTP id i18mr18275068wml.65.1593444524502;
        Mon, 29 Jun 2020 08:28:44 -0700 (PDT)
Received: from redhat.com (bzq-79-182-31-92.red.bezeqint.net. [79.182.31.92])
        by smtp.gmail.com with ESMTPSA id r10sm97700wrm.17.2020.06.29.08.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 08:28:43 -0700 (PDT)
Date:   Mon, 29 Jun 2020 11:28:41 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [RFC 0/3] virtio: NUMA-aware memory allocation
Message-ID: <20200629112212-mutt-send-email-mst@kernel.org>
References: <20200625135752.227293-1-stefanha@redhat.com>
 <9cd725b5-4954-efd9-4d1b-3a448a436472@redhat.com>
 <20200629092646.GC31392@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200629092646.GC31392@stefanha-x1.localdomain>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 29, 2020 at 10:26:46AM +0100, Stefan Hajnoczi wrote:
> On Sun, Jun 28, 2020 at 02:34:37PM +0800, Jason Wang wrote:
> > 
> > On 2020/6/25 下午9:57, Stefan Hajnoczi wrote:
> > > These patches are not ready to be merged because I was unable to measure a
> > > performance improvement. I'm publishing them so they are archived in case
> > > someone picks up this work again in the future.
> > > 
> > > The goal of these patches is to allocate virtqueues and driver state from the
> > > device's NUMA node for optimal memory access latency. Only guests with a vNUMA
> > > topology and virtio devices spread across vNUMA nodes benefit from this.  In
> > > other cases the memory placement is fine and we don't need to take NUMA into
> > > account inside the guest.
> > > 
> > > These patches could be extended to virtio_net.ko and other devices in the
> > > future. I only tested virtio_blk.ko.
> > > 
> > > The benchmark configuration was designed to trigger worst-case NUMA placement:
> > >   * Physical NVMe storage controller on host NUMA node 0

It's possible that numa is not such a big deal for NVMe.
And it's possible that bios misconfigures ACPI reporting NUMA placement
incorrectly.
I think that the best thing to try is to use a ramdisk
on a specific numa node.

> > >   * IOThread pinned to host NUMA node 0
> > >   * virtio-blk-pci device in vNUMA node 1
> > >   * vCPU 0 on host NUMA node 1 and vCPU 1 on host NUMA node 0
> > >   * vCPU 0 in vNUMA node 0 and vCPU 1 in vNUMA node 1
> > > 
> > > The intent is to have .probe() code run on vCPU 0 in vNUMA node 0 (host NUMA
> > > node 1) so that memory is in the wrong NUMA node for the virtio-blk-pci devic=
> > > e.
> > > Applying these patches fixes memory placement so that virtqueues and driver
> > > state is allocated in vNUMA node 1 where the virtio-blk-pci device is located.
> > > 
> > > The fio 4KB randread benchmark results do not show a significant improvement:
> > > 
> > > Name                  IOPS   Error
> > > virtio-blk        42373.79 =C2=B1 0.54%
> > > virtio-blk-numa   42517.07 =C2=B1 0.79%
> > 
> > 
> > I remember I did something similar in vhost by using page_to_nid() for
> > descriptor ring. And I get little improvement as shown here.
> > 
> > Michael reminds that it was probably because all data were cached. So I
> > doubt if the test lacks sufficient stress on the cache ...
> 
> Yes, that sounds likely. If there's no real-world performance
> improvement then I'm happy to leave these patches unmerged.
> 
> Stefan


Well that was for vhost though. This is virtio, which is different.
Doesn't some benchmark put pressure on the CPU cache?


I kind of feel there should be a difference, and the fact there isn't
means there's some other bottleneck somewhere. Might be worth
figuring out.

-- 
MST

