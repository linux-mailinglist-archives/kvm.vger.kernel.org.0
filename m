Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E95E31230A1
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 16:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbfLQPim (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 10:38:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40513 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727370AbfLQPim (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 10:38:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576597121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oe8wx3LqrRs6+5QV/gvDiaHevjNBAUocaR3nOV3H/ec=;
        b=J4qd/iIHOX2ViDj6HmF5Xhk1QzHMURO+Fv9PWwUpTuZcqvkSZYWGoppYHYzgDbId5dnGp9
        2TTKdv9FPhy5OVzpL0AcVdTwTJRj+HrVje00DVgDq63O6xOXK5n1lJJBAfktKF8/kNGMFc
        bEdfVWFsQ6Q+tvzHJi7baMUFub2qNok=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-cT1jxE3kOUuGT7v0wimzWg-1; Tue, 17 Dec 2019 10:38:40 -0500
X-MC-Unique: cT1jxE3kOUuGT7v0wimzWg-1
Received: by mail-qv1-f71.google.com with SMTP id v5so848166qvn.21
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2019 07:38:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=oe8wx3LqrRs6+5QV/gvDiaHevjNBAUocaR3nOV3H/ec=;
        b=Ns+5pilivIJcm4iqf8X9v2qK3CK8JZEtsWZfYtUT34c2Pwj/yldzVWkFs4UCWi5BOR
         nAQHkmIUJphlC8QsvhxnwaDVwHOjIbrtAitcONV5AlHjnuTWhpBQ75Sxb43Srq7VKsTO
         hCObW9648ZMVuDkUC4x3n5U90icBVhgV6IiRwOLsiWzppTbrKnmFwWdFhLDQER/jEl5B
         ywBEp7uXPj/ekI/dohZ7HCApyqmGwJ3ewSOXjr6sx54mMq8nxwgj5CDpIrg5cHsCPuoL
         XXZClJ0OEg37ns+93u9Oa886FMFrJcPfPyzPVpMyGTxE6ZnQG69xJV81/9l0OUUx+jlX
         gfFQ==
X-Gm-Message-State: APjAAAV1LB9hh+m0KAD1KyNJ4LybuaFGfTROkI+YJlCS66VPbnUDB23w
        Fryz1rBJam4Xly6CD4kpKKBrymQil88tke2YTlzA7hAfmi0rF9DEf22dNav5onyUqDyvgvncL8m
        LKdR4nNCGk94l
X-Received: by 2002:ac8:4151:: with SMTP id e17mr5184991qtm.234.1576597119904;
        Tue, 17 Dec 2019 07:38:39 -0800 (PST)
X-Google-Smtp-Source: APXvYqyOzAD8USssim+OrRbQDGZuuA6bLMYmSzkOFB1tXv7s1A1ojilmiaIx2TMYZyPHAFnmkbw/+w==
X-Received: by 2002:ac8:4151:: with SMTP id e17mr5184971qtm.234.1576597119698;
        Tue, 17 Dec 2019 07:38:39 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id b7sm7172621qkh.106.2019.12.17.07.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 07:38:38 -0800 (PST)
Date:   Tue, 17 Dec 2019 10:38:37 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christophe de Dinechin <dinechin@redhat.com>,
        Christophe de Dinechin <christophe.de.dinechin@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191217153837.GC7258@xz-x1>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <m1lfrihj2n.fsf@dinechin.org>
 <20191213202324.GI16429@xz-x1>
 <bc15650b-df59-f508-1090-21dafc6e8ad1@redhat.com>
 <E167A793-B42A-422D-8D46-B992CB6EBE69@redhat.com>
 <d59ac0eb-e65a-a46f-886e-6df80a2b142f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d59ac0eb-e65a-a46f-886e-6df80a2b142f@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 17, 2019 at 01:19:05PM +0100, Paolo Bonzini wrote:
> On 17/12/19 13:16, Christophe de Dinechin wrote:
> > 
> > 
> >> On 14 Dec 2019, at 08:57, Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>
> >> On 13/12/19 21:23, Peter Xu wrote:
> >>>> What is the benefit of using u16 for that? That means with 4K pages, you
> >>>> can share at most 256M of dirty memory each time? That seems low to me,
> >>>> especially since it's sufficient to touch one byte in a page to dirty it.
> >>>>
> >>>> Actually, this is not consistent with the definition in the code ;-)
> >>>> So I'll assume it's actually u32.
> >>> Yes it's u32 now.  Actually I believe at least Paolo would prefer u16
> >>> more. :)
> >>
> >> It has to be u16, because it overlaps the padding of the first entry.
> > 
> > Wow, now that’s subtle.
> > 
> > That definitely needs a union with the padding to make this explicit.
> > 
> > (My guess is you do that to page-align the whole thing and avoid adding a
> > page just for the counters)

(Just to make sure this is clear... Paolo was talking about the
 previous version.  This version does not have this limitation because
 we don't have that union definition any more)

> 
> Yes, that was the idea but Peter decided to scrap it. :)

There's still time to persuade me to going back to it. :)

(Though, yes I still like current solution... if we can get rid of the
 only kvmgt ugliness, we can even throw away the per-vm ring with its
 "extra" 4k page.  Then I suppose it'll be even harder to persuade me :)

-- 
Peter Xu

