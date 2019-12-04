Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEA2F1135C2
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 20:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbfLDTeH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 14:34:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32576 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727978AbfLDTeG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 14:34:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575488045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mWyIkTXiC0quZtw/5T8TCy0fnE8KCStWjWsKsRxQ59U=;
        b=NbiPNecDxteddm6sVG8Ubksod3l5RUuic4qhgXi6AlqFsGz62ExYl5Wz3//b5JzaLpT1/i
        fFRstvRkidxjW8EwS4y030gLVh+wMSYV5j4HvltzQdcwKilKlL3PXMSrsUrF19AD/YLdB0
        jNtawBVRdC8sd0p6gk4vIhOjxMdwr+o=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-Zj5MD6EWNPC57979012z-g-1; Wed, 04 Dec 2019 14:34:00 -0500
Received: by mail-qv1-f72.google.com with SMTP id d38so533164qvc.5
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2019 11:34:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=yBwzkaZ0MI5ShsGLJd2xa1xlXoUdCs8DIC2/tz4aZcI=;
        b=ZYpUnqmqjLkO26i0n88atIzCeSwEz6LcQQNY1P84Xwt32zL+aZSt1Y5qb6btBb+Ez7
         6nqypFo56nG12ALsHAgOpmu45L76MhjsfDyoLYMG5tHmuwxak8UMLrjEm+QGOneaAL30
         vK6IQRT3ucXaAlaiidSzC9Vw5Ym1TV0AASgi4GlbQffZqceNuhAy/K6oZyC+/MaurLSY
         kXF5n0j1JsU5gifFQEUKXpLzG33V5ueiL/KD8bESSjQ7TmOovoSz0VqtbjgoY8QPLWwa
         pPAo5CfLD0XKgQR+N7Gz94kuKnlSf73xGtRKeuYtlXXz6MZHIhiDeHD+zGyZ8v8ArARW
         4sVw==
X-Gm-Message-State: APjAAAXpIur3qfSsZoMpN5VOD9yexQG4ivdmQF2ajdtPHVM0c5X3/HOi
        MnD+9N3uHsGowLPyFElaVJPR9rSV6kHumOnhg63dK/SPGI+xvCG0A9K+NI4C0lWu1ElAOJXu/E3
        jMLtpZ0Inc5pb
X-Received: by 2002:a05:620a:81a:: with SMTP id s26mr4957202qks.11.1575488040067;
        Wed, 04 Dec 2019 11:34:00 -0800 (PST)
X-Google-Smtp-Source: APXvYqygZwKX2BoznKOdgittBd+P8LNSnZ34AgJjdddJLHHOWG8jz3h7NSkZld0RmBuGAwToiRG0Ww==
X-Received: by 2002:a05:620a:81a:: with SMTP id s26mr4957178qks.11.1575488039773;
        Wed, 04 Dec 2019 11:33:59 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id d25sm4004244qka.39.2019.12.04.11.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 11:33:58 -0800 (PST)
Date:   Wed, 4 Dec 2019 14:33:57 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH RFC 00/15] KVM: Dirty ring interface
Message-ID: <20191204193357.GE19939@xz-x1>
References: <20191129213505.18472-1-peterx@redhat.com>
 <776732ca-06c8-c529-0899-9d2ffacf7789@redhat.com>
MIME-Version: 1.0
In-Reply-To: <776732ca-06c8-c529-0899-9d2ffacf7789@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-MC-Unique: Zj5MD6EWNPC57979012z-g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 04, 2019 at 06:39:48PM +0800, Jason Wang wrote:
>=20
> On 2019/11/30 =E4=B8=8A=E5=8D=885:34, Peter Xu wrote:
> > Branch is here:https://github.com/xzpeter/linux/tree/kvm-dirty-ring
> >=20
> > Overview
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >=20
> > This is a continued work from Lei Cao<lei.cao@stratus.com>  and Paolo
> > on the KVM dirty ring interface.  To make it simple, I'll still start
> > with version 1 as RFC.
> >=20
> > The new dirty ring interface is another way to collect dirty pages for
> > the virtual machine, but it is different from the existing dirty
> > logging interface in a few ways, majorly:
> >=20
> >    - Data format: The dirty data was in a ring format rather than a
> >      bitmap format, so the size of data to sync for dirty logging does
> >      not depend on the size of guest memory any more, but speed of
> >      dirtying.  Also, the dirty ring is per-vcpu (currently plus
> >      another per-vm ring, so total ring number is N+1), while the dirty
> >      bitmap is per-vm.
> >=20
> >    - Data copy: The sync of dirty pages does not need data copy any mor=
e,
> >      but instead the ring is shared between the userspace and kernel by
> >      page sharings (mmap() on either the vm fd or vcpu fd)
> >=20
> >    - Interface: Instead of using the old KVM_GET_DIRTY_LOG,
> >      KVM_CLEAR_DIRTY_LOG interfaces, the new ring uses a new interface
> >      called KVM_RESET_DIRTY_RINGS when we want to reset the collected
> >      dirty pages to protected mode again (works like
> >      KVM_CLEAR_DIRTY_LOG, but ring based)
> >=20
> > And more.
>=20
>=20
> Looks really interesting, I wonder if we can make this as a library then =
we
> can reuse it for vhost.

So iiuc this ring will majorly for (1) data exchange between kernel
and user, and (2) shared memory.  I think from that pov yeh it should
work even for vhost.

It shouldn't be hard to refactor the interfaces to avoid kvm elements,
however I'm not sure how to do that best.  Maybe like irqbypass and
put it into virt/lib/ as a standlone module?  Would it worth it?

Paolo, what's your take?

--=20
Peter Xu

