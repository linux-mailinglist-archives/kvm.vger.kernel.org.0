Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53230148DED
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2020 19:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391444AbgAXSmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jan 2020 13:42:07 -0500
Received: from mail-vs1-f66.google.com ([209.85.217.66]:46222 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388064AbgAXSmH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jan 2020 13:42:07 -0500
Received: by mail-vs1-f66.google.com with SMTP id t12so1850475vso.13
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2020 10:42:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=48FEuH9EzQeY2PBZotAukaxCb1+PqqfajszpsDI4a/I=;
        b=h2DAYTb9VsQ+QjqncuR5l68KeBwSCp968ZGMuifSCzx2SFdsigmou1urYD8Qli/yIB
         ULZ0o/3CoryFzCD4BFqX954rkrHj470+rHobBAglYt1Vxiwm7khjQG/kjmroNTFrCvsi
         I329X/GLMuSBuWI8KCtdY5NBsyORT8NbXyDuQgmFnxmUlvz9Cf0PXPHXJxKHo+kVRo4l
         P2UKLmHy2GX9TupKjVOdg155kOC+XwGwiV0oRLpjIhPR6FxlVtifpDh+VhCIufozcHMv
         bQPfhLDNAoc3eo20FQRCH+xZ+YybjoqD37GFmGIFPQB8tVNwpEwxt82eDzxc7tDL+Lym
         ilhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=48FEuH9EzQeY2PBZotAukaxCb1+PqqfajszpsDI4a/I=;
        b=dNkSokvvRFXpaa0iP++EmR0xX/9ThEvsauQr+2uL8UPmMx+YRnxzaO74BYDOxjhHIs
         fHKCICJQjSWQEgFQK1beSHM0BHHVI8DiFvTWo+U1TiSiyRxTMVN9ubtszIW2HvpZeHRb
         C4YqCc+3K0593Yz4v2FZ67r0TIbNRwsnjNPGL0nfjTx6O3qr0AqUHFn7EKq/Way4d0D8
         ZUUetq3OUsHMzy7YVGzG9dhORGbYOdv6r797lCfnV5ZiO2ibd5Sqlp8p4DhR2yo937MH
         6d0T+GoMq/NRwrrUoS0YV08k/sg/h6/h/ySsdIC8esYP16ml7VlAaCsCf8nfNZmqIzI0
         EGRw==
X-Gm-Message-State: APjAAAWzkuiigCwE474FjWgHKp+il6ORR1U/6JcJirHpCGMX1bIM4h7n
        WNWC6QbOdTcOco0JCK8lqtc6KPLk4CwPSh3yaiZaZQ==
X-Google-Smtp-Source: APXvYqwBMegd+R+iEIyOxrLLSSG25ZR0bNGvDF2TyU33C6lJzgeFsPuzLdUFCxmatMXomV9oKoh27bIVvPlErYJbBqs=
X-Received: by 2002:a67:df96:: with SMTP id x22mr953575vsk.235.1579891326150;
 Fri, 24 Jan 2020 10:42:06 -0800 (PST)
MIME-Version: 1.0
References: <20200123180436.99487-1-bgardon@google.com> <20200123180436.99487-10-bgardon@google.com>
 <92042648-e43a-d996-dc38-aded106b976b@redhat.com>
In-Reply-To: <92042648-e43a-d996-dc38-aded106b976b@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Fri, 24 Jan 2020 10:41:55 -0800
Message-ID: <CANgfPd8jpUykwrOnToXx+zhJOJvnWvxhZPSKhAwST=wwYdtA3A@mail.gmail.com>
Subject: Re: [PATCH v4 09/10] KVM: selftests: Stop memslot creation in KVM
 internal memslot region
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 24, 2020 at 12:58 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 23/01/20 19:04, Ben Gardon wrote:
> > KVM creates internal memslots covering the region between 3G and 4G in
> > the guest physical address space, when the first vCPU is created.
> > Mapping this region before creation of the first vCPU causes vCPU
> > creation to fail. Prohibit tests from creating such a memslot and fail
> > with a helpful warning when they try to.
> >
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
>
> The internal memslots are much higher than this (0xfffbc000 and
> 0xfee00000).  I'm changing the patch to block 0xfe0000000 and above,
> otherwise it breaks vmx_dirty_log_test.

Perhaps we're working in different units, but I believe paddrs
0xfffbc000 and 0xfee00000 are between 3GiB and 4GiB.
"Proof by Python":
>>> B=1
>>> KB=1024*B
>>> MB=1024*KB
>>> GB=1024*MB
>>> hex(3*GB)
'0xc0000000'
>>> hex(4*GB)
'0x100000000'
>>> 3*GB == 3<<30
True
>>> 0xfffbc000 > 3*GB
True
>>> 0xfffbc000 < 4*GB
True
>>> 0xfee00000 > 3*GB
True
>>> 0xfee00000 < 4*GB
True

Am I missing something?

I don't think blocking 0xfe0000000 and above is useful, as there's
nothing mapped in that region and AFAIK it's perfectly valid to create
memslots there.


>
> Paolo
>
