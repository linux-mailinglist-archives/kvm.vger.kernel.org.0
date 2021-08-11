Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D25F3E931F
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 15:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbhHKN7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 09:59:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45893 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231563AbhHKN7C (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Aug 2021 09:59:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628690319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qLAu7Xt9giB1JEJeaXVcKTr3zxBkgolhQiE77Rr3piU=;
        b=acEaex1KXVGphWfBIAAXAGtZr4o4P7cVcPE7YVssrgHaGwB2WWZ+e1rXVrX6mLKK33Cqwr
        ry5nYEcDqysybYoedhdMM6WOi52ULSPGuwunBbQgTAsrKHwCATFRdGqrUK0S2xZwfzyfS+
        pgZ9cKUxlzhJRXFk6q8PAoQn/hIdf1s=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-_dYqfDMMNGW1im_LZ4Vycg-1; Wed, 11 Aug 2021 09:58:37 -0400
X-MC-Unique: _dYqfDMMNGW1im_LZ4Vycg-1
Received: by mail-lj1-f199.google.com with SMTP id m4-20020a2ea8840000b029018ba0baeb6eso819684ljq.5
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 06:58:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qLAu7Xt9giB1JEJeaXVcKTr3zxBkgolhQiE77Rr3piU=;
        b=f4oUOpFO5VQl7v5g1ShphVf16IayQiUysCnV0XEfV00uTHGMvJF1R38J969Fm2SbVV
         ZFEJEsh5vZNAvY9DgSHSeFycXKpdLam3b84zDgi70E4FJld8Zuvbu2czvWUOVm40ExnF
         a6we9yrOSbqjRnFRl+fVgc6BdAFMcOFroJGx1KAt/f+hK3LmrSrp6oNKkqp4wBrga/3O
         TtXsNeg5rZtIp2JG7LBn6MRCPyQYbNVXNzlAgBCVg3sQKgHLQ8FDCJC+TNPXOitDdWpE
         LOn/+Rz+b+lcUNWIuqILyFTfibayyi9l0/yd8VMaF3WRLie2kyied5SMQEmFxLM+nyGx
         fzbw==
X-Gm-Message-State: AOAM533HBJrFgoJfTkmEpjNyaiHyAVNUbH9POnIjkZze6Jbqi2eiS2Zt
        3ExJa3MixyHOWkEq1PjM9pYP9/2nG4FTE2Hq+1ULNmVge8o29gdyhGqcreFDxbpe2kbKCVXqO6g
        G1QiRtLIbgo6ZFFJq47TWkmLXrDvb
X-Received: by 2002:a2e:9355:: with SMTP id m21mr22807152ljh.445.1628690316033;
        Wed, 11 Aug 2021 06:58:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxl12Co/rSK8sREdXG2ZIEVYWevhIt1h4k4YDs8TUY0b/cRFg4Pp78qZxQ4i6zJCMIbWVczSn9w+TKkmrFLlto=
X-Received: by 2002:a2e:9355:: with SMTP id m21mr22807128ljh.445.1628690315807;
 Wed, 11 Aug 2021 06:58:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210728125402.2496-1-valeriy.vdovin@virtuozzo.com>
 <87eeb59vwt.fsf@dusky.pond.sub.org> <20210810185644.iyqt3iao2qdqd5jk@habkost.net>
 <2191952f-6989-771a-1f0a-ece58262d141@redhat.com> <CAOpTY_qbsqh9Tf8LB3EOOi_gkREotdpUyuF3-d_sBFsof3-9KQ@mail.gmail.com>
 <97ce9800-ff69-46cd-b6ab-c7645ee10d2c@redhat.com>
In-Reply-To: <97ce9800-ff69-46cd-b6ab-c7645ee10d2c@redhat.com>
From:   Eduardo Habkost <ehabkost@redhat.com>
Date:   Wed, 11 Aug 2021 09:58:19 -0400
Message-ID: <CAOpTY_rv4nZib1Eymm9ZVcLf=v=-QjpUm24U7FtS-1pUqS_6VQ@mail.gmail.com>
Subject: Re: [PATCH v12] qapi: introduce 'query-x86-cpuid' QMP command.
To:     Thomas Huth <thuth@redhat.com>
Cc:     Markus Armbruster <armbru@redhat.com>,
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

On Wed, Aug 11, 2021 at 9:44 AM Thomas Huth <thuth@redhat.com> wrote:
>
> On 11/08/2021 15.40, Eduardo Habkost wrote:
> > On Wed, Aug 11, 2021 at 2:10 AM Thomas Huth <thuth@redhat.com> wrote:
> >>
> >> On 10/08/2021 20.56, Eduardo Habkost wrote:
> >>> On Sat, Aug 07, 2021 at 04:22:42PM +0200, Markus Armbruster wrote:
> >>>> Is this intended to be a stable interface?  Interfaces intended just=
 for
> >>>> debugging usually aren't.
> >>>
> >>> I don't think we need to make it a stable interface, but I won't
> >>> mind if we declare it stable.
> >>
> >> If we don't feel 100% certain yet, it's maybe better to introduce this=
 with
> >> a "x-" prefix first, isn't it? I.e. "x-query-x86-cpuid" ... then it's =
clear
> >> that this is only experimental/debugging/not-stable yet. Just my 0.02 =
=E2=82=AC.
> >
> > That would be my expectation. Is this a documented policy?
> >
>
> According to docs/interop/qmp-spec.txt :
>
>   Any command or member name beginning with "x-" is deemed
>   experimental, and may be withdrawn or changed in an incompatible
>   manner in a future release.

Thanks! I had looked at other QMP docs, but not qmp-spec.txt.

In my reply above, please read "make it a stable interface" as
"declare it as supported by not using the 'x-' prefix".

I don't think we have to make it stable, but I won't argue against it
if the current proposal is deemed acceptable by other maintainers.

Personally, I'm still frustrated by the complexity of the current
proposal, but I don't want to block it just because of my frustration.

--=20
Eduardo

