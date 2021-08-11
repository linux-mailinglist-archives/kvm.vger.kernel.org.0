Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32D6F3E92DA
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 15:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbhHKNlj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 09:41:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44223 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231459AbhHKNlj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Aug 2021 09:41:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628689275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q20KrUkR7MsbG79i79vAF5MOF6BNiEXRrsZS5BYJL/s=;
        b=Qj1wTagUbrR8KgQF2lWL6ZDSWIhSl+k5DEL+tp4zkMARQk76cZz0aAWKqvXlV9rRqDcEKS
        Ax3bz5rRkHppB0zOO/fGV/YQOq+JqtXenPP/A2M/4aRqwo3NLixpM3QyupuWSLQG80ChC/
        63nwUUYUfhgYYspzeA2p2hY9lkYzQTc=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-BTNDM7i2NL2UfYTlCuqwLA-1; Wed, 11 Aug 2021 09:41:14 -0400
X-MC-Unique: BTNDM7i2NL2UfYTlCuqwLA-1
Received: by mail-lf1-f71.google.com with SMTP id c24-20020a0565123258b02903c025690adcso898208lfr.22
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 06:41:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Q20KrUkR7MsbG79i79vAF5MOF6BNiEXRrsZS5BYJL/s=;
        b=egnnAQrbTJqEKOVThM9L1SWJaDkMvvbirlVubfgB/SaKTTo/rTVUTgUYzOJ93tZc1B
         H5yKLYnSV6RGuhl+LOxgGouCeXqmY8avYTT8/RnfNAtjSuHn0TU16SJgf0tAHnKVkP0G
         uXApvmqhpwGvpl57ymlLK4nWFgShrMfuBrZHxjYiEjIV3/yMNLUyLiOEj07HVdfL5CLX
         9iDK7rAalTxD8quH7KoxTN8v5J2A9xO1n1+HcnmLqZw8ISeeray7KYFt1zIUsnj/KcId
         tQMSjL2QVsQq8GJUH/9VOl3GfL7o0nCY7S+ZOTulYrz5Wh7yB2zfxzXfpaGmiMmDq/sX
         lxSw==
X-Gm-Message-State: AOAM533keBWy25AjSmclA2DIZcM43ElWm3B6R1ZO4RR7Moy8m89GZPmc
        OCo5eHBet0rimck+sEh+Va2y66badurt8It8V+kwdbPLn4ABXlAEEW9lPAaPCYFm71AVi2GMcBX
        M7j9YTmGv3RGTNA1QUOn7sBRWnW8x
X-Received: by 2002:a05:651c:1318:: with SMTP id u24mr23436031lja.200.1628689272166;
        Wed, 11 Aug 2021 06:41:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+6BdoUaBCFxukN4ueUP4CyCqCQCjOrtjSlQ68bQIAme3PFXhQwnvtCXRS1PnGzqfNmqUY8Frv1CWTH7KUc1w=
X-Received: by 2002:a05:651c:1318:: with SMTP id u24mr23436016lja.200.1628689271960;
 Wed, 11 Aug 2021 06:41:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210728125402.2496-1-valeriy.vdovin@virtuozzo.com>
 <87eeb59vwt.fsf@dusky.pond.sub.org> <20210810185644.iyqt3iao2qdqd5jk@habkost.net>
 <2191952f-6989-771a-1f0a-ece58262d141@redhat.com>
In-Reply-To: <2191952f-6989-771a-1f0a-ece58262d141@redhat.com>
From:   Eduardo Habkost <ehabkost@redhat.com>
Date:   Wed, 11 Aug 2021 09:40:56 -0400
Message-ID: <CAOpTY_qbsqh9Tf8LB3EOOi_gkREotdpUyuF3-d_sBFsof3-9KQ@mail.gmail.com>
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

On Wed, Aug 11, 2021 at 2:10 AM Thomas Huth <thuth@redhat.com> wrote:
>
> On 10/08/2021 20.56, Eduardo Habkost wrote:
> > On Sat, Aug 07, 2021 at 04:22:42PM +0200, Markus Armbruster wrote:
> >> Is this intended to be a stable interface?  Interfaces intended just f=
or
> >> debugging usually aren't.
> >
> > I don't think we need to make it a stable interface, but I won't
> > mind if we declare it stable.
>
> If we don't feel 100% certain yet, it's maybe better to introduce this wi=
th
> a "x-" prefix first, isn't it? I.e. "x-query-x86-cpuid" ... then it's cle=
ar
> that this is only experimental/debugging/not-stable yet. Just my 0.02 =E2=
=82=AC.

That would be my expectation. Is this a documented policy?

--=20
Eduardo

