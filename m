Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E3E23DCE9
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 18:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729564AbgHFQ6U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 12:58:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32701 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729795AbgHFQ5E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 12:57:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596733022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JsQQ+Of14Jcox/vjqRSvLqdJ9OO0AZmQ6i3MKzbPweU=;
        b=ECmsgVcMzNpEWxJQ99HTAjC4QylaUFh2OgG6T21CvkiIg9O4Chec9vE5hL+436Bjhrjcao
        aFmRtf6itPkJKu6DKyIettse6Cl7U3R0g4ANecAXu385+UnOMUodg8rhVppxqAkY1NgNL7
        2UNxBwXDMrTvNnQ8Z26CQTt8Wft0NYo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-rrHo_498NTGxH0WE1SZq-A-1; Thu, 06 Aug 2020 08:19:35 -0400
X-MC-Unique: rrHo_498NTGxH0WE1SZq-A-1
Received: by mail-wm1-f71.google.com with SMTP id q15so4040151wmj.6
        for <kvm@vger.kernel.org>; Thu, 06 Aug 2020 05:19:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JsQQ+Of14Jcox/vjqRSvLqdJ9OO0AZmQ6i3MKzbPweU=;
        b=mDoP3+93x3WKF6kpGW4UlV3yd0IWhq9NSDT0dc23oViI0al8W8IZOqFK2kCH8+OJs9
         DZAed7wWri7oOm4bcmk6i7zZLDBp9t3Umrq2ILr3Z5bGYztyMt2270xEgJH2y5VYo9Ve
         T4q3mNlsHvnZeJDm3EWvZvwPdOWRbdOMzGbbj6opqP3VmtKTdAnbNstQnqCaTdNZOjnu
         aL6/g92TW5D7wx3zIjcFLWPm5vaZ6c06vbqV446vamjV4lhLClEc5E2LrnRPc4Q1K445
         rDc8Vpybw95M/raiTsGjDE/jaGAMqSyRM4uRrX/Jli+sZ3OXff/l7SofmwQATecgcTiE
         sjjg==
X-Gm-Message-State: AOAM533vfiNZ13XgEVpjmW7JfrTdVeovbJYklIaGPPiTezVtiY8/5Q0e
        UOmSLKto1RNDGbfDIbzhOG7RJA/q8v4lcWv4Ol/Da7QHLoJM4pF3jN2X+T/+RROk/+xmc+GEwZt
        Mp3xcbNW5k5zd
X-Received: by 2002:a1c:5a41:: with SMTP id o62mr7903995wmb.16.1596716374338;
        Thu, 06 Aug 2020 05:19:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzyIywm4grHWIEGGqRYHwakkz8CRdHAYx5VrR1wcD6mUEyChlrX/txPMAT79yt1vKaH9Ku0ng==
X-Received: by 2002:a1c:5a41:: with SMTP id o62mr7903978wmb.16.1596716374170;
        Thu, 06 Aug 2020 05:19:34 -0700 (PDT)
Received: from redhat.com (bzq-79-180-0-181.red.bezeqint.net. [79.180.0.181])
        by smtp.gmail.com with ESMTPSA id n24sm6536082wmi.36.2020.08.06.05.19.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 05:19:33 -0700 (PDT)
Date:   Thu, 6 Aug 2020 08:19:30 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Andy Lutomirski <luto@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] KVM: x86: KVM_MEM_PCI_HOLE memory
Message-ID: <20200806081800-mutt-send-email-mst@kernel.org>
References: <20200728143741.2718593-1-vkuznets@redhat.com>
 <20200805201851-mutt-send-email-mst@kernel.org>
 <873650p1vo.fsf@vitty.brq.redhat.com>
 <20200806055008-mutt-send-email-mst@kernel.org>
 <87wo2cngv6.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wo2cngv6.fsf@vitty.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 06, 2020 at 01:39:09PM +0200, Vitaly Kuznetsov wrote:
> "Michael S. Tsirkin" <mst@redhat.com> writes:
> 
> > About the feature bit, I am not sure why it's really needed. A single
> > mmio access is cheaper than two io accesses anyway, right? So it makes
> > sense for a kvm guest whether host has this feature or not.
> > We need to be careful and limit to a specific QEMU implementation
> > to avoid tripping up bugs, but it seems more appropriate to
> > check it using pci host IDs.
> 
> Right, it's just that "running on KVM" is too coarse grained, we just
> need a way to somehow distinguish between "known/good" and
> "unknown/buggy" configurations.

Basically it's not KVM, it's QEMU that is known good.  QEMU vendor id in
the pci host seems like a reasonable way to detect that. If someone
reuses QEMU ID - I guess they better behave just like QEMU :)

I also proposed only limiting this to register 0 (device id),
will make it very unlikely this can break accidentally ...

> -- 
> Vitaly

