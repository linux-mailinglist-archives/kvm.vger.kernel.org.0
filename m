Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99C7510F1BB
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 21:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbfLBUtx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 15:49:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39369 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725835AbfLBUtw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 15:49:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575319791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kfI2T/OBDTQMytIjwtIY0Q+iGUUVGvoXu6NKeDy7chI=;
        b=OYq3FpE2+LX2gXDvAp+NChp05IAu465CEM/x3YOnibaKdgeuuXwneUSrgp0iBjj6oobZsY
        ceGD8n/duqnRSYdDKa69lkP4+XvCzDiFP+fmEAqWJRtgtqM61hr9VE5Cw4Q015I9QG7Per
        TnL8EWNExPDyezmPlzHr4F6ELyadfF8=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-EMLJhF2rOB6rvOqxNhheag-1; Mon, 02 Dec 2019 15:49:46 -0500
Received: by mail-qk1-f199.google.com with SMTP id j192so587141qke.3
        for <kvm@vger.kernel.org>; Mon, 02 Dec 2019 12:49:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oKfmJh2VfgBUbtlo/gIgdtusRPYrvR5yv1D+kx4rgqU=;
        b=FfIhCvmVABYGnfzT2cPEITn0wstvkz26XelFdmAGuno0uLoXVzpsWrcgH+C8n2l+7/
         QJUsCc0gOEeaTWlbvRf5DTGpHf2Vz27XPYB2vVaz5wosZJTXDvSkHndmGk16MTx2Djko
         Rb0T78B73CaYaDHSuhrYFdMScRQLP8oADqXxQAo1of8ChhaY3oFbLO+gLSME6XPwA5b7
         +KuHnvbhU0JdUV9xF6DbEJqInQ1eaXARhrHuHs2NJbt65u+byFmCqdDPoeuumWRJbeup
         Yeim0cMSDIGUTj0amIQ6EjjHpxnp2dbjdrWLaY0qe1wwFVSR/elZMmDSlimB0/ibIeca
         Wp5w==
X-Gm-Message-State: APjAAAU9JrF0gxc8aFqnVsT+nESPG+HfWR1DXzZiS2yg/Xhttcy+gY+W
        39r6Rmx9cSMGF9ilrGuRqbyIspxUSkdTUhsFyC9VkpStOuUeo584O0aXFnUBDoQXaSfsqwHb8nx
        pvJNNmHWXLP5R
X-Received: by 2002:a05:6214:1709:: with SMTP id db9mr1263729qvb.68.1575319785941;
        Mon, 02 Dec 2019 12:49:45 -0800 (PST)
X-Google-Smtp-Source: APXvYqzHvfzhOgfr3zCnKSbC9lF3fmLxUBS1vsAQdC++WCkLiU3qHQOwm5+Li7yrZWtEjBlraRaNlw==
X-Received: by 2002:a05:6214:1709:: with SMTP id db9mr1263701qvb.68.1575319785594;
        Mon, 02 Dec 2019 12:49:45 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id j2sm395309qka.88.2019.12.02.12.49.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 12:49:44 -0800 (PST)
Date:   Mon, 2 Dec 2019 15:49:43 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 02/15] KVM: Add kvm/vcpu argument to
 mark_dirty_page_in_slot
Message-ID: <20191202204943.GC31681@xz-x1>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-3-peterx@redhat.com>
 <20191202193222.GI4063@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <20191202193222.GI4063@linux.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-MC-Unique: EMLJhF2rOB6rvOqxNhheag-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 02, 2019 at 11:32:22AM -0800, Sean Christopherson wrote:
> On Fri, Nov 29, 2019 at 04:34:52PM -0500, Peter Xu wrote:
>=20
> Why?

[1]

>=20
> > From: "Cao, Lei" <Lei.Cao@stratus.com>
> >=20
> > Signed-off-by: Cao, Lei <Lei.Cao@stratus.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> >  virt/kvm/kvm_main.c | 26 +++++++++++++++++---------
> >  1 file changed, 17 insertions(+), 9 deletions(-)
> >=20
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index fac0760c870e..8f8940cc4b84 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -145,7 +145,10 @@ static void hardware_disable_all(void);
> > =20
> >  static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
> > =20
> > -static void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot, g=
fn_t gfn);
> > +static void mark_page_dirty_in_slot(struct kvm *kvm,
> > +=09=09=09=09    struct kvm_vcpu *vcpu,
> > +=09=09=09=09    struct kvm_memory_slot *memslot,
> > +=09=09=09=09    gfn_t gfn);
>=20
> Why both?  Passing @vcpu gets you @kvm.

You are right on that I should fill in something at [1]..

Because @vcpu can be NULL (if you continue to read this patch, you'll
see sometimes NULL is passed in), and we at least need a context to
mark the dirty ring.  That's also why we need a per-vm dirty ring to
be the fallback of the cases where we don't have vcpu context.

Thanks,

--=20
Peter Xu

