Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA512136102
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 20:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729793AbgAITXY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 14:23:24 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21428 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729753AbgAITXY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 14:23:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578597802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lAyG93/wDPRo61G3IJlDyRKcV1uCp592GYMDO3Bi2fo=;
        b=JBcbekXI0E/PsbD3Eamxgwhe55i/kruMEym8Uc6SJxtnh8rMdKVWbI/qP/J0IBA9lmFJR6
        kRowRKMzoTTYm2GF+onECaSJrA+87wi1LpSsQQ1/Sl26i3ZhmPyF3KbNCGN0mF6lntVBJc
        nD189FjFJMvi8+g88r1G4auB7NLj+70=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-iOAXVpUNMHixeLpWZoGZiA-1; Thu, 09 Jan 2020 14:23:21 -0500
X-MC-Unique: iOAXVpUNMHixeLpWZoGZiA-1
Received: by mail-qk1-f197.google.com with SMTP id u10so4866019qkk.1
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 11:23:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lAyG93/wDPRo61G3IJlDyRKcV1uCp592GYMDO3Bi2fo=;
        b=ftarQEl7ZA7BD9qxb2ObrvXy3bJlqOOusHJDknRCG/IEseLxNpf6BJMVjFn+0YHpTC
         3pdX9dD+r1+d8GDn17uJcLE5WrdqHLY+eAPqDzZ0ShGWx7y8+5MkR3K1vuEKBRMKsLby
         Rr/rCy3gUNFlNUk34t3ecPlzaI49wTGur12CfdPFPuLklzJIpqkNr9bGQY4qRZ8LhyzG
         WuaK7FSxgZRprLhDVLC3MzyAsiQEFXYi9Xx31mJ40NVTRpAWdmMKCRdo+2lME79gXoAm
         XB5sf3R/ocdShfnEo0Vwy533h74jS5101gmlOgl51OUHBX8YqqRnyjCNGTBzsJgGhyat
         At6g==
X-Gm-Message-State: APjAAAWB4LEOD7fmGM9N3wH4jQfWAK/Df2/Cwc7gwRaG7YVGlzX3fHN2
        qK1tIR+QZ/4ep+CLoi8JNk6HwijRAUpRNYpp+ty4pW3o4Q4+Fx0a02ZK8EtsSTEVeBzUeau6Rri
        EHzN3br6GVn+U
X-Received: by 2002:ac8:43d0:: with SMTP id w16mr9585877qtn.43.1578597800728;
        Thu, 09 Jan 2020 11:23:20 -0800 (PST)
X-Google-Smtp-Source: APXvYqy9hERTrat16wk0EtLZVIdLUjS5G34C0KVLv9397Lnq/NGLGR3Zwgtm6nAaVDXMp6iwyJi0xw==
X-Received: by 2002:ac8:43d0:: with SMTP id w16mr9585849qtn.43.1578597800465;
        Thu, 09 Jan 2020 11:23:20 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id b191sm3574155qkg.43.2020.01.09.11.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 11:23:19 -0800 (PST)
Date:   Thu, 9 Jan 2020 14:23:18 -0500
From:   Peter Xu <peterx@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
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
Message-ID: <20200109192318.GF36997@xz-x1>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109094711.00eb96b1@w520.home>
 <20200109175808.GC36997@xz-x1>
 <20200109140948-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200109140948-mutt-send-email-mst@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 09, 2020 at 02:13:54PM -0500, Michael S. Tsirkin wrote:
> On Thu, Jan 09, 2020 at 12:58:08PM -0500, Peter Xu wrote:
> > On Thu, Jan 09, 2020 at 09:47:11AM -0700, Alex Williamson wrote:
> > > On Thu,  9 Jan 2020 09:57:08 -0500
> > > Peter Xu <peterx@redhat.com> wrote:
> > > 
> > > > Branch is here: https://github.com/xzpeter/linux/tree/kvm-dirty-ring
> > > > (based on kvm/queue)
> > > > 
> > > > Please refer to either the previous cover letters, or documentation
> > > > update in patch 12 for the big picture.  Previous posts:
> > > > 
> > > > V1: https://lore.kernel.org/kvm/20191129213505.18472-1-peterx@redhat.com
> > > > V2: https://lore.kernel.org/kvm/20191221014938.58831-1-peterx@redhat.com
> > > > 
> > > > The major change in V3 is that we dropped the whole waitqueue and the
> > > > global lock. With that, we have clean per-vcpu ring and no default
> > > > ring any more.  The two kvmgt refactoring patches were also included
> > > > to show the dependency of the works.
> > > 
> > > Hi Peter,
> > 
> > Hi, Alex,
> > 
> > > 
> > > Would you recommend this style of interface for vfio dirty page
> > > tracking as well?  This mechanism seems very tuned to sparse page
> > > dirtying, how well does it handle fully dirty, or even significantly
> > > dirty regions?
> > 
> > That's truely the point why I think the dirty bitmap can still be used
> > and should be kept.  IIUC the dirty ring starts from COLO where (1)
> > dirty rate is very low, and (2) sync happens frequently.  That's a
> > perfect ground for dirty ring.  However it for sure does not mean that
> > dirty ring can solve all the issues.  As you said, I believe the full
> > dirty is another extreme in that dirty bitmap could perform better.
> > 
> > > We also don't really have "active" dirty page tracking
> > > in vfio, we simply assume that if a page is pinned or otherwise mapped
> > > that it's dirty, so I think we'd constantly be trying to re-populate
> > > the dirty ring with pages that we've seen the user consume, which
> > > doesn't seem like a good fit versus a bitmap solution.  Thanks,
> > 
> > Right, so I confess I don't know whether dirty ring is the ideal
> > solutioon for vfio either.  Actually if we're tracking by page maps or
> > pinnings, then IMHO it also means that it could be more suitable to
> > use an modified version of dirty ring buffer (as you suggested in the
> > other thread), in that we can track dirty using (addr, len) range
> > rather than a single page address.  That could be hard for KVM because
> > in KVM the page will be mostly trapped in 4K granularity in page
> > faults, and it'll also be hard to merge continuous entries with
> > previous ones because the userspace could be reading the entries (so
> > after we publish the previous 4K dirty page, we should not modify the
> > entry any more).
> 
> An easy way would be to keep a couple of entries around, not pushing
> them into the ring until later.  In fact deferring queue write until
> there's a bunch of data to be pushed is a very handy optimization.

I feel like I proposed similar thing in the other thread. :-)

> 
> When building UAPI's it makes sense to try and keep them generic
> rather than tying them to a given implementation.
> 
> That's one of the reasons I called for using something
> resembling vring_packed_desc.

But again, I just want to make sure I don't over-engineer...

I'll wait for further feedback from others for this.

Thanks,

-- 
Peter Xu

