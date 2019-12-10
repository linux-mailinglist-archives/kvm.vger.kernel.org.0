Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8192119A71
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 22:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbfLJVx1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 16:53:27 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21314 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726970AbfLJVx0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Dec 2019 16:53:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576014805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yrizCyo7m7hDOCYKIMvuYeQwoBYzTpaglQGy0pm+RW0=;
        b=Y2b7bUXniGrVq3V9sotcyzpfli6n94aUeWEDcm98x6lTb6AfkuI9aJt/PbZ2zUMiIuxgyY
        WskKZ/+DDF9mqROwYRUxZ4GN0Yw1Zip4Ko/SeMNLKvFezRP6JNsg7eqWp86QOWvlYjAFrq
        sjXRinFC4a0yQDvypIdG5RUnuja/Qk4=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-i24G_MBIOFKZKkVmIf7cfQ-1; Tue, 10 Dec 2019 16:53:24 -0500
Received: by mail-qt1-f198.google.com with SMTP id z12so2998095qts.15
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2019 13:53:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=haO+hO7zhLiDWtz4v+nZfgg/Acru74GowOg9k9oKdgQ=;
        b=EpjQRdPFOPcehy33zS8ok/ncskj48W9Ito9EaCpHdXrvvyoctJGpzYZeRrCIRWW2SB
         HC7XLPWUE8AL6qITkVEzuzbGUXOriRZAAUGrmh/IhlJbISlt+iIaw3PKmXqD2eTPFu1f
         F/k+V16q5Hy9d41teHAIwCuw5YKCBBAhAVUbSBlSnZH+ptWqskkG6rkMtawddagD8PCn
         faSdkRNLVgNrp4GedpfkX8zKNvUpOkQZOj7xpdUIuVH3py3aUvf+V+kHjuhwe0AZSyMi
         7A0BoRXfyrDvq5Ug9iLETz4Zv3p00tJOmOzYUbZFDaPGPZRmj4cy9DXGrN6teGzm+IZn
         5G7w==
X-Gm-Message-State: APjAAAWHjqChFox3W3iGPltAa35/cTDUMVhDYCvoDZFlrFm8Hj4TVNMk
        DkQGxud9hO9pmFN/gBX4Dokgolgvfd7C4t632N/j9rIv5/d44LYCxTpTKXAWPz0ATIXD2JVYIdi
        ZjrhpT/sdVnMH
X-Received: by 2002:a37:7bc7:: with SMTP id w190mr34597381qkc.132.1576014803586;
        Tue, 10 Dec 2019 13:53:23 -0800 (PST)
X-Google-Smtp-Source: APXvYqz/l3O2+jkai7Ds7qKKCHV1j/1Q6fIugOHydRaUvmyObOfC1CSUBb8wBoJYsKYM6H1xo9Jc6w==
X-Received: by 2002:a37:7bc7:: with SMTP id w190mr34597363qkc.132.1576014803352;
        Tue, 10 Dec 2019 13:53:23 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id x126sm1349347qkc.87.2019.12.10.13.53.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 13:53:22 -0800 (PST)
Date:   Tue, 10 Dec 2019 16:53:17 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191210164908-mutt-send-email-mst@kernel.org>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <1355422f-ab62-9dc3-2b48-71a6e221786b@redhat.com>
 <a3e83e6b-4bfa-3a6b-4b43-5dd451e03254@redhat.com>
 <20191210081958-mutt-send-email-mst@kernel.org>
 <8843d1c8-1c87-e789-9930-77e052bf72f9@redhat.com>
 <20191210160211.GE3352@xz-x1>
MIME-Version: 1.0
In-Reply-To: <20191210160211.GE3352@xz-x1>
X-MC-Unique: i24G_MBIOFKZKkVmIf7cfQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 10, 2019 at 11:02:11AM -0500, Peter Xu wrote:
> On Tue, Dec 10, 2019 at 02:31:54PM +0100, Paolo Bonzini wrote:
> > On 10/12/19 14:25, Michael S. Tsirkin wrote:
> > >> There is no new infrastructure to track the dirty pages---it's just =
a
> > >> different way to pass them to userspace.
> > > Did you guys consider using one of the virtio ring formats?
> > > Maybe reusing vhost code?
> >=20
> > There are no used/available entries here, it's unidirectional
> > (kernel->user).
>=20
> Agreed.  Vring could be an overkill IMHO (the whole dirty_ring.c is
> 100+ LOC only).


I guess you don't do polling/ event suppression and other tricks that
virtio came up with for speed then? Why won't they be helpful for kvm?
To put it another way, LOC is irrelevant, virtio is already in the
kernel.

Anyway, this is something to be discussed in the cover letter.

> >=20
> > > If you did and it's not a good fit, this is something good to mention
> > > in the commit log.
> > >=20
> > > I also wonder about performance numbers - any data here?
> >=20
> > Yes some numbers would be useful.  Note however that the improvement is
> > asymptotical, O(#dirtied pages) vs O(#total pages) so it may differ
> > depending on the workload.
>=20
> Yes.  I plan to give some numbers when start to work on the QEMU
> series (after this lands).  However as Paolo said, those numbers would
> probably only be with some special case where I know the dirty ring
> could win.  Frankly speaking I don't even know whether we should
> change the default logging mode when the QEMU work is done - I feel
> like the old logging interface is still good in many major cases
> (small vms, or high dirty rates).  It could be that we just offer
> another option when the user could consider to solve specific problems.
>=20
> Thanks,
>=20
> --=20
> Peter Xu

