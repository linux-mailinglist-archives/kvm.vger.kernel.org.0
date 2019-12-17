Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7C4122B11
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 13:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727627AbfLQMQg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 07:16:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59142 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726191AbfLQMQf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 07:16:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576584995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eA9cywrEHDbWRbwjH2I9YMr5mKq56yt7dElxC/Ko4cE=;
        b=ZhrwXrymHlSjsJfi1hFOK97Uom8cJytNBNxvxtIpL63NQpoh3i6IzqFxG27S/S2J7rtnRf
        1oEFWw0P240xFb/vBCG9wORaj8wcYt/YwhmIg+RfGSA7pGiWlb0XISszPVZ9or5UZh9Ycb
        e+U6Km8CEcbrRbam2FwPl48qTOziYxM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-ak69Bks7MvyIZhZX1OGteg-1; Tue, 17 Dec 2019 07:16:33 -0500
X-MC-Unique: ak69Bks7MvyIZhZX1OGteg-1
Received: by mail-wm1-f69.google.com with SMTP id o24so521011wmh.0
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2019 04:16:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=eA9cywrEHDbWRbwjH2I9YMr5mKq56yt7dElxC/Ko4cE=;
        b=Bpqa7t/82K/d0+62PSzHGPbVGHDw0vsMY+jCfmu8C9Nty3eV5Lnipd2YI48lVyM4R4
         kReBVDeTMFqiqJ7bVS5+7E9Rd+uFNRth/h3rzr5I5WawJnE+nXoUAxBmYt6bCLjNmBPW
         FRMtklYYpQw/k3mEUY6XP7vprugqXLTrUEbKpdtXkId8tePb5iEgLH6kzafw83BzJGC3
         dZP0KEx5aAgV/2UIUd44dK0PnXEKI2umDE/CNf3ezbvRb8S5rz0HSZBHVJP9niuloOWj
         LPZkG22TKcouHXz7mDSthXxJs+SrsVtgD2K52/i3DzcnG6XvQqfkR/8/PO4+AGTBZnHg
         0Q7w==
X-Gm-Message-State: APjAAAUZMdwmg9KNS1dtEIrLHQGEjqHiQLkw4Q+vDgTUET034e0dq4vR
        r0Bx3YThYXD37t24jDWzQ2oWfeK5ygMaiW/6JJjCbSa9bsUCK2s/Cgy9N8be+pMBQmc7J2cmF6t
        9V4TcHaLN5lO5
X-Received: by 2002:adf:f5cf:: with SMTP id k15mr37639348wrp.182.1576584992755;
        Tue, 17 Dec 2019 04:16:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqxxWL8dD6dQVsaIoKdm9DusWguRhjNW6D90fK9ygyz/qJ0RxmKHJAr+6737sYsXEYzYZkoekw==
X-Received: by 2002:adf:f5cf:: with SMTP id k15mr37639314wrp.182.1576584992501;
        Tue, 17 Dec 2019 04:16:32 -0800 (PST)
Received: from ?IPv6:2a01:e0a:466:71c0:1c42:ed63:2256:4add? ([2a01:e0a:466:71c0:1c42:ed63:2256:4add])
        by smtp.gmail.com with ESMTPSA id z83sm2863437wmg.2.2019.12.17.04.16.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Dec 2019 04:16:31 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.40.2.2.4\))
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
From:   Christophe de Dinechin <dinechin@redhat.com>
In-Reply-To: <bc15650b-df59-f508-1090-21dafc6e8ad1@redhat.com>
Date:   Tue, 17 Dec 2019 13:16:31 +0100
Cc:     Peter Xu <peterx@redhat.com>,
        Christophe de Dinechin <christophe.de.dinechin@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E167A793-B42A-422D-8D46-B992CB6EBE69@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com> <m1lfrihj2n.fsf@dinechin.org>
 <20191213202324.GI16429@xz-x1>
 <bc15650b-df59-f508-1090-21dafc6e8ad1@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3608.40.2.2.4)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 14 Dec 2019, at 08:57, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> On 13/12/19 21:23, Peter Xu wrote:
>>> What is the benefit of using u16 for that? That means with 4K pages, =
you
>>> can share at most 256M of dirty memory each time? That seems low to =
me,
>>> especially since it's sufficient to touch one byte in a page to =
dirty it.
>>>=20
>>> Actually, this is not consistent with the definition in the code ;-)
>>> So I'll assume it's actually u32.
>> Yes it's u32 now.  Actually I believe at least Paolo would prefer u16
>> more. :)
>=20
> It has to be u16, because it overlaps the padding of the first entry.

Wow, now that=E2=80=99s subtle.

That definitely needs a union with the padding to make this explicit.

(My guess is you do that to page-align the whole thing and avoid adding =
a
page just for the counters)

>=20
> Paolo
>=20
>> I think even u16 would be mostly enough (if you see, the maximum
>> allowed value currently is 64K entries only, not a big one).  Again,
>> the thing is that the userspace should be collecting the dirty bits,
>> so the ring shouldn't reach full easily.  Even if it does, we should
>> probably let it stop for a while as explained above.  It'll be
>> inefficient only if we set it to a too-small value, imho.
>>=20
>=20

