Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263AE34E6EA
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 13:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbhC3LxS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 07:53:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40737 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231913AbhC3LxD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 07:53:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617105182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b2PUmx70NJ0w+dO04OeezeeqBSrGdS5G5MmjbsYXriw=;
        b=D4zJX6fdsLqTX+PGpI6cd9IA1/jhaUUYFrJamgCZJoU9nZjY3ZPegNikIh/zqAP9pZZbGb
        OGtDVWSpgTjh/HC0oQAG8xLEp0szUKjAgSaWuDgaa2OPtCl1LXfVETB3M/UE9LPCeDZusf
        W3xnF9p6wujJ4Igt6a6JE6i+Qusm+bM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-TWOi2yQwM32Z3og6lc4F5Q-1; Tue, 30 Mar 2021 07:53:00 -0400
X-MC-Unique: TWOi2yQwM32Z3og6lc4F5Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74B95107ACCA;
        Tue, 30 Mar 2021 11:52:59 +0000 (UTC)
Received: from gondolin (ovpn-113-155.ams2.redhat.com [10.36.113.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF8D22AF44;
        Tue, 30 Mar 2021 11:52:52 +0000 (UTC)
Date:   Tue, 30 Mar 2021 13:52:50 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 3/8] s390x: css: simplify skipping
 tests on no device
Message-ID: <20210330135250.00372e8e.cohuck@redhat.com>
In-Reply-To: <ce270f66-3d17-92d3-81d2-59fd9e0bd87f@linux.ibm.com>
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
        <1616665147-32084-4-git-send-email-pmorel@linux.ibm.com>
        <5caf129d-08e9-0efa-5110-9330ac856eff@redhat.com>
        <ce270f66-3d17-92d3-81d2-59fd9e0bd87f@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 29 Mar 2021 14:50:22 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 3/29/21 10:19 AM, Thomas Huth wrote:
> > On 25/03/2021 10.39, Pierre Morel wrote: =20
> >> We will lhave to test if a device is present for every tests
> >> in the future.
> >> Let's provide a macro to check if the device is present and
> >> to skip the tests if it is not.
> >>
> >> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> >> ---
> >> =C2=A0 s390x/css.c | 27 +++++++++++----------------
> >> =C2=A0 1 file changed, 11 insertions(+), 16 deletions(-)

> > I wonder whether it would be easier to simply skip all tests in main()=
=20
> > if the test device is not available, instead of checking it again and=20
> > again and again...?
> >=20
> >  =C2=A0Thomas
> >  =20
>=20
> I will silently skip the remaining tests when the enumeration fails or=20
> do you want that we see other information?
> It seems obvious enough that finding no device we do not continue testing.

Logging that the device enumeration failed should be enough info.

