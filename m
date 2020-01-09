Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1143136140
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 20:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731313AbgAIThq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 14:37:46 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23845 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729757AbgAIThp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 14:37:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578598663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PbCIN5cwKivHka0nMOY+vdaUO3w2adhPc+3Yrr27jdo=;
        b=Al59LvQ5StAFsD1yYm+vRSrqwfBePrjnYcEOe41sR5LuYxou0Xnf+83F7AS5iDDZUacvad
        OvG/6S3Evgkvx/67u6vNw9BjPJoo9pN/PAN/b7Bkkkqb2M6UpXOmEBdes5cImHkcej1yrN
        wuFTtMnjEuSE+ew/FMG8fXPE0NluOcI=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-nvUTOU39O8OYuhsp21CqZA-1; Thu, 09 Jan 2020 14:37:41 -0500
X-MC-Unique: nvUTOU39O8OYuhsp21CqZA-1
Received: by mail-qt1-f200.google.com with SMTP id l56so4873224qtk.11
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 11:37:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PbCIN5cwKivHka0nMOY+vdaUO3w2adhPc+3Yrr27jdo=;
        b=c0Q/ZfetMAVSXglcdmgRdfelkD+uksasNcg+tJyMI2iMIzCA7lyffxykn++Co1MU/u
         j8xDrM38jotlmA+ocbuffd/jj1+QR0HDKcE5ORWnp4GK7BF7n+1Ysp7FerISSPd7Qp4T
         B/Y69HhfzCeO6M+eUes+BVwPXWAm7Cumsi9ZV3OVuzKudPY7nVhJx3A/oe07zdZKejVs
         gaJ+Jr5shZiA1qARf+g1OLCSDz6Egdkr+dPEXLA/cbx0NM6uJSt8/2P2sjIOegsAUPji
         TI/BtNDnetMGLdFSmPSQyQYEf2sMychD324VwQ/RDVl+XSka/g6+KnymE9nAr1KbYwMR
         bKKA==
X-Gm-Message-State: APjAAAUyVPiSZ8Dg1lZbhIq0L2B48zGiLHteuKM5DXmnRaP3n4vdymxO
        F3AFbYcPCoNqZPFsXxe/PGTmbGDA3xBfJIFHzl42E70KPhHcY2ezXfGG1q/Pglwe+rrkmQkKq0K
        GANuWJlyhw77F
X-Received: by 2002:a37:9c0f:: with SMTP id f15mr11339153qke.297.1578598661333;
        Thu, 09 Jan 2020 11:37:41 -0800 (PST)
X-Google-Smtp-Source: APXvYqx1OIjnd6/LxXyh8xSqsQa+K54P9fyHHwvQ8E1nUaaWAdPLHr6JtOY55VdBQU35QIiCqFSwyQ==
X-Received: by 2002:a37:9c0f:: with SMTP id f15mr11339138qke.297.1578598661050;
        Thu, 09 Jan 2020 11:37:41 -0800 (PST)
Received: from redhat.com (bzq-79-183-34-164.red.bezeqint.net. [79.183.34.164])
        by smtp.gmail.com with ESMTPSA id c184sm3472280qke.118.2020.01.09.11.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 11:37:40 -0800 (PST)
Date:   Thu, 9 Jan 2020 14:37:34 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christophe de Dinechin <dinechin@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH v3 00/21] KVM: Dirty ring interface
Message-ID: <20200109143716-mutt-send-email-mst@kernel.org>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109094711.00eb96b1@w520.home>
 <20200109175808.GC36997@xz-x1>
 <20200109140948-mutt-send-email-mst@kernel.org>
 <20200109192318.GF36997@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200109192318.GF36997@xz-x1>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 09, 2020 at 02:23:18PM -0500, Peter Xu wrote:
> On Thu, Jan 09, 2020 at 02:13:54PM -0500, Michael S. Tsirkin wrote:
> > On Thu, Jan 09, 2020 at 12:58:08PM -0500, Peter Xu wrote:
> > > On Thu, Jan 09, 2020 at 09:47:11AM -0700, Alex Williamson wrote:
> > > > On Thu,  9 Jan 2020 09:57:08 -0500
> > > > Peter Xu <peterx@redhat.com> wrote:
> > > > 
> > > > > Branch is here: https://github.com/xzpeter/linux/tree/kvm-dirty-ring
> > > > > (based on kvm/queue)
> > > > > 
> > > > > Please refer to either the previous cover letters, or documentation
> > > > > update in patch 12 for the big picture.  Previous posts:
> > > > > 
> > > > > V1: https://lore.kernel.org/kvm/20191129213505.18472-1-peterx@redhat.com
> > > > > V2: https://lore.kernel.org/kvm/20191221014938.58831-1-peterx@redhat.com
> > > > > 
> > > > > The major change in V3 is that we dropped the whole waitqueue and the
> > > > > global lock. With that, we have clean per-vcpu ring and no default
> > > > > ring any more.  The two kvmgt refactoring patches were also included
> > > > > to show the dependency of the works.
> > > > 
> > > > Hi Peter,
> > > 
> > > Hi, Alex,
> > > 
> > > > 
> > > > Would you recommend this style of interface for vfio dirty page
> > > > tracking as well?  This mechanism seems very tuned to sparse page
> > > > dirtying, how well does it handle fully dirty, or even significantly
> > > > dirty regions?
> > > 
> > > That's truely the point why I think the dirty bitmap can still be used
> > > and should be kept.  IIUC the dirty ring starts from COLO where (1)
> > > dirty rate is very low, and (2) sync happens frequently.  That's a
> > > perfect ground for dirty ring.  However it for sure does not mean that
> > > dirty ring can solve all the issues.  As you said, I believe the full
> > > dirty is another extreme in that dirty bitmap could perform better.
> > > 
> > > > We also don't really have "active" dirty page tracking
> > > > in vfio, we simply assume that if a page is pinned or otherwise mapped
> > > > that it's dirty, so I think we'd constantly be trying to re-populate
> > > > the dirty ring with pages that we've seen the user consume, which
> > > > doesn't seem like a good fit versus a bitmap solution.  Thanks,
> > > 
> > > Right, so I confess I don't know whether dirty ring is the ideal
> > > solutioon for vfio either.  Actually if we're tracking by page maps or
> > > pinnings, then IMHO it also means that it could be more suitable to
> > > use an modified version of dirty ring buffer (as you suggested in the
> > > other thread), in that we can track dirty using (addr, len) range
> > > rather than a single page address.  That could be hard for KVM because
> > > in KVM the page will be mostly trapped in 4K granularity in page
> > > faults, and it'll also be hard to merge continuous entries with
> > > previous ones because the userspace could be reading the entries (so
> > > after we publish the previous 4K dirty page, we should not modify the
> > > entry any more).
> > 
> > An easy way would be to keep a couple of entries around, not pushing
> > them into the ring until later.  In fact deferring queue write until
> > there's a bunch of data to be pushed is a very handy optimization.
> 
> I feel like I proposed similar thing in the other thread. :-)
> 
> > 
> > When building UAPI's it makes sense to try and keep them generic
> > rather than tying them to a given implementation.
> > 
> > That's one of the reasons I called for using something
> > resembling vring_packed_desc.
> 
> But again, I just want to make sure I don't over-engineer...


You will now when you start profiling in earnest.

> I'll wait for further feedback from others for this.
> 
> Thanks,
> 
> -- 
> Peter Xu

