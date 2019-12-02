Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55F6010F1A5
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 21:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725801AbfLBUnu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 15:43:50 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36546 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725763AbfLBUnt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Dec 2019 15:43:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575319428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+4Ittu/hSmdCI2AmJTvWeXqR6mPDprHDT/ECsEOFBW8=;
        b=fHlS8ojAj4A0naSLObKKR4UVtORnBg8tBor0RZDhHCfvhQKM5Kq1B8cItooUYWyMuN4Png
        Q3apaNq7VrKBmw1RoxIhMvHyDmlpInO+2QoxBDVOniCMD9y722v0/gGGSxT802C6ZH4Aav
        Xpt+RjzuvLX7XWtb1oUAILpGFbKhCXw=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-Z67bMOksPDGTLO8u73XV8Q-1; Mon, 02 Dec 2019 15:43:47 -0500
Received: by mail-qk1-f197.google.com with SMTP id r2so576037qkb.2
        for <kvm@vger.kernel.org>; Mon, 02 Dec 2019 12:43:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=USlZJP//e42ZzE68GTx4OckfDz65LYntsCtyMUYxiWU=;
        b=KKHjJmb+gRKFbGRk/3/6O3lEBqYMnJ+u08qPbI+NpmRZ6v5XTWZT1h3i2kyfu58DOQ
         22ThjnLNylwlC5YllO9earz3wqSqSi8uYGmQ0lLDt5/bvQ9B3S0zQmgOC94O1jtIOwLE
         BVQDVbva5tNN+mEZn62+BYo6k5i0aQ1wiBSgxivx7ywekQVaaij9bQgYFSpzkS9MBXv9
         HdyvNOD75Hn0MmIAz93lKvPROUWAwy2jqGcDX4nETyMiM59K67Q2loiJxIu4BcH2XipE
         UqcLtGFUJy/MbdCuvPLVL1QBZXXFSxU9W/qYmJl66QmZCPdCVOXnXtSorAVHY8B6QdPP
         NoDQ==
X-Gm-Message-State: APjAAAVY0pHjKHWs9YNkfEKczATukobIPoULqkFgh+mQBHVwZhRSZqou
        pNVr9ytylnahTUE9HevO3IhoifgKIJ1NfqiPn1f2GWIk5x/D5mtx2l2DXYrXdjWpE76NXMupI7g
        l3Yb0H15kyHzw
X-Received: by 2002:a37:8185:: with SMTP id c127mr984215qkd.43.1575319426231;
        Mon, 02 Dec 2019 12:43:46 -0800 (PST)
X-Google-Smtp-Source: APXvYqyXLMQ+eAjfkBW0QjP715vnDdPiiQiUKGC+SVAkoNMre5VxloNR3M7CcaO1XLRCCzkF2ZFHpA==
X-Received: by 2002:a37:8185:: with SMTP id c127mr984192qkd.43.1575319425943;
        Mon, 02 Dec 2019 12:43:45 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id l7sm395150qtf.84.2019.12.02.12.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 12:43:45 -0800 (PST)
Date:   Mon, 2 Dec 2019 15:43:44 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 00/15] KVM: Dirty ring interface
Message-ID: <20191202204344.GB31681@xz-x1>
References: <20191129213505.18472-1-peterx@redhat.com>
 <b8f28d8c-2486-2d66-04fd-a2674b598cfd@redhat.com>
 <20191202202119.GK4063@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <20191202202119.GK4063@linux.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-MC-Unique: Z67bMOksPDGTLO8u73XV8Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 02, 2019 at 12:21:19PM -0800, Sean Christopherson wrote:
> On Sat, Nov 30, 2019 at 09:29:42AM +0100, Paolo Bonzini wrote:
> > Hi Peter,
> >=20
> > thanks for the RFC!  Just a couple comments before I look at the series
> > (for which I don't expect many surprises).
> >=20
> > On 29/11/19 22:34, Peter Xu wrote:
> > > I marked this series as RFC because I'm at least uncertain on this
> > > change of vcpu_enter_guest():
> > >=20
> > >         if (kvm_check_request(KVM_REQ_DIRTY_RING_FULL, vcpu)) {
> > >                 vcpu->run->exit_reason =3D KVM_EXIT_DIRTY_RING_FULL;
> > >                 /*
> > >                         * If this is requested, it means that we've
> > >                         * marked the dirty bit in the dirty ring BUT
> > >                         * we've not written the date.  Do it now.
> > >                         */
> > >                 r =3D kvm_emulate_instruction(vcpu, 0);
> > >                 r =3D r >=3D 0 ? 0 : r;
> > >                 goto out;
> > >         }
> >=20
> > This is not needed, it will just be a false negative (dirty page that
> > actually isn't dirty).  The dirty bit will be cleared when userspace
> > resets the ring buffer; then the instruction will be executed again and
> > mark the page dirty again.  Since ring full is not a common condition,
> > it's not a big deal.
>=20
> Side topic, KVM_REQ_DIRTY_RING_FULL is misnamed, it's set when a ring goe=
s
> above its soft limit, not when the ring is actually full.  It took quite =
a
> bit of digging to figure out whether or not PML was broken...

Yeah it's indeed a bit confusing.

Do you like KVM_REQ_DIRTY_RING_COLLECT?  Pair with
KVM_EXIT_DIRTY_RING_COLLECT.  Or, suggestions?

--=20
Peter Xu

