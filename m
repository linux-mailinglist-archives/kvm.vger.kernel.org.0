Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA7A3F4DD7
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 17:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbhHWP4h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 11:56:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50666 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231622AbhHWP4g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Aug 2021 11:56:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629734153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NCsT/ERhBtPd8RPO+dR7p/UQkj4/U3jUp7ZEXSXSOAM=;
        b=URiMg+TLPjEzTa1ToSE4j90EZb8gXdA8yvZpHH+4KoymDd7BS5e/Zx6JgfO7FZci1TK0Dd
        Jd4XJ20Uv7FTxUOFJzzX7ghYLp1CA+Ap3hdouEbUzJCmsNoSiLm2UuEEE2AkGEalcsHIx+
        7xAjlVNARx2w5dwOuwZrRQAO4gYY2sk=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-jxi-1XJtM021NHOLkcNt8g-1; Mon, 23 Aug 2021 11:55:51 -0400
X-MC-Unique: jxi-1XJtM021NHOLkcNt8g-1
Received: by mail-lj1-f197.google.com with SMTP id 192-20020a2e05c90000b02901b91e6a0ebaso6496553ljf.13
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 08:55:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NCsT/ERhBtPd8RPO+dR7p/UQkj4/U3jUp7ZEXSXSOAM=;
        b=OoZOQzIokcxNgWlpN4Kr44w47fQfZcohGar+BZy87dyQqW/TE7sdlPe0a8glIBNn+1
         sWIpRYR2OQAEu4vF/v33hIfO/+9R6hfgItREKYy+/kXuvBwj6kIk2URBAlibSyzIa+Y6
         OjnFzlBj7zOqW7KkkJ2HB7nKrtqXRg0216szlkqmK9srscGwKaXe4afB2eiqekIIHntn
         8CvL2yautRpqmW+5NF5EoIXzKpoRiRCxBr0lJoi3Zd/VkQJoXfRn52NL42eucZPUWhFh
         xh7n3RZ4A8BCejrEoMt1knW6zdUPyyek0M4dZ0WIPnovFRHqdljrvhV96ibLcRGJzIDG
         KZig==
X-Gm-Message-State: AOAM530HNDrcpnNoqajQFNPXaSCdtlEtpLQaQdmZrht1vHCrp+UZ/apY
        xcsVFP6IS0Rct9WITwJehv3ZWNYbHvsAoso6pecL5Zq15xVHxb8T6fMQbXeVrfQfhxl5txVnByM
        vj5h66f5DXoRzzAeiXvj9Q2Xjlqyd
X-Received: by 2002:ac2:4c2a:: with SMTP id u10mr25748506lfq.631.1629734150257;
        Mon, 23 Aug 2021 08:55:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxaEu2459oQ0qgL3zjgnaCDU+gxi547Y71iNO6fJF/OumgH+wwWeGpFh/SG9NYpSVd2510HRrDf5qcbG1yIYeA=
X-Received: by 2002:ac2:4c2a:: with SMTP id u10mr25748482lfq.631.1629734149909;
 Mon, 23 Aug 2021 08:55:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210728125402.2496-1-valeriy.vdovin@virtuozzo.com>
 <87eeb59vwt.fsf@dusky.pond.sub.org> <20210810185644.iyqt3iao2qdqd5jk@habkost.net>
 <2191952f-6989-771a-1f0a-ece58262d141@redhat.com> <CAOpTY_qbsqh9Tf8LB3EOOi_gkREotdpUyuF3-d_sBFsof3-9KQ@mail.gmail.com>
 <97ce9800-ff69-46cd-b6ab-c7645ee10d2c@redhat.com> <CAOpTY_rv4nZib1Eymm9ZVcLf=v=-QjpUm24U7FtS-1pUqS_6VQ@mail.gmail.com>
 <87lf4scmi5.fsf@dusky.pond.sub.org>
In-Reply-To: <87lf4scmi5.fsf@dusky.pond.sub.org>
From:   Eduardo Habkost <ehabkost@redhat.com>
Date:   Mon, 23 Aug 2021 11:55:34 -0400
Message-ID: <CAOpTY_p3vxv8dM54sLQ1WkEHesJ9w-famusHPw040e=HiZj9pw@mail.gmail.com>
Subject: Re: [PATCH v12] qapi: introduce 'query-x86-cpuid' QMP command.
To:     Markus Armbruster <armbru@redhat.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Denis Lunev <den@openvz.org>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 23, 2021 at 9:35 AM Markus Armbruster <armbru@redhat.com> wrote=
:
>
> Eduardo Habkost <ehabkost@redhat.com> writes:
>
> > On Wed, Aug 11, 2021 at 9:44 AM Thomas Huth <thuth@redhat.com> wrote:
> >>
> >> On 11/08/2021 15.40, Eduardo Habkost wrote:
> >> > On Wed, Aug 11, 2021 at 2:10 AM Thomas Huth <thuth@redhat.com> wrote=
:
> >> >>
> >> >> On 10/08/2021 20.56, Eduardo Habkost wrote:
> >> >>> On Sat, Aug 07, 2021 at 04:22:42PM +0200, Markus Armbruster wrote:
> >> >>>> Is this intended to be a stable interface?  Interfaces intended j=
ust for
> >> >>>> debugging usually aren't.
> >> >>>
> >> >>> I don't think we need to make it a stable interface, but I won't
> >> >>> mind if we declare it stable.
> >> >>
> >> >> If we don't feel 100% certain yet, it's maybe better to introduce t=
his with
> >> >> a "x-" prefix first, isn't it? I.e. "x-query-x86-cpuid" ... then it=
's clear
> >> >> that this is only experimental/debugging/not-stable yet. Just my 0.=
02 =E2=82=AC.
> >> >
> >> > That would be my expectation. Is this a documented policy?
> >> >
> >>
> >> According to docs/interop/qmp-spec.txt :
> >>
> >>   Any command or member name beginning with "x-" is deemed
> >>   experimental, and may be withdrawn or changed in an incompatible
> >>   manner in a future release.
> >
> > Thanks! I had looked at other QMP docs, but not qmp-spec.txt.
> >
> > In my reply above, please read "make it a stable interface" as
> > "declare it as supported by not using the 'x-' prefix".
> >
> > I don't think we have to make it stable, but I won't argue against it
> > if the current proposal is deemed acceptable by other maintainers.
> >
> > Personally, I'm still frustrated by the complexity of the current
> > proposal, but I don't want to block it just because of my frustration.
>
> Is this a case of "there must be a simpler way", or did you actually
> propose a simpler way?  I don't remember...
>

I did propose a simpler way at
https://lore.kernel.org/qemu-devel/20210810195053.6vsjadglrexf6jwy@habkost.=
net/

--
Eduardo

