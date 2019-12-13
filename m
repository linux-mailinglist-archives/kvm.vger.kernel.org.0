Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F204011E114
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 10:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbfLMJoE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 04:44:04 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58981 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725906AbfLMJoE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Dec 2019 04:44:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576230243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gOgJdnJ609aVF577TfLUwbjtrkAenVSxQ2coKhi0JW4=;
        b=JZbVJciGQgA4cUZHrbokTv5qfm1+nKLRK+FLh1+n3K0N07E407EiQqPMXo/IP80/k27gS5
        r6ssU5jxKONc7SSoTFJtLu2puqgoj62UJ6PT5rA0Uqr1Wt94rte+Op/M3ZmOGdOqQPo/fc
        YNRFTQ9hBvNMo6HVDzcjs13MUbklLqM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-Vl9TlJfBN_u9-i2pG6v0LA-1; Fri, 13 Dec 2019 04:44:02 -0500
X-MC-Unique: Vl9TlJfBN_u9-i2pG6v0LA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C433E1883525;
        Fri, 13 Dec 2019 09:44:00 +0000 (UTC)
Received: from gondolin (ovpn-116-226.ams2.redhat.com [10.36.116.226])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B96B45D9C9;
        Fri, 13 Dec 2019 09:43:52 +0000 (UTC)
Date:   Fri, 13 Dec 2019 10:43:50 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 8/9] s390x: css: ssch/tsch with sense
 and interrupt
Message-ID: <20191213104350.6ebe4aa6.cohuck@redhat.com>
In-Reply-To: <96034dbc-489a-7f76-0402-d5c0c42d20b3@linux.ibm.com>
References: <1576079170-7244-1-git-send-email-pmorel@linux.ibm.com>
        <1576079170-7244-9-git-send-email-pmorel@linux.ibm.com>
        <20191212132634.3a16a389.cohuck@redhat.com>
        <1ea58644-9f24-f547-92d5-a99dcb041502@linux.ibm.com>
        <96034dbc-489a-7f76-0402-d5c0c42d20b3@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 Dec 2019 19:20:07 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 2019-12-12 15:10, Pierre Morel wrote:
> >=20
> >=20
> > On 2019-12-12 13:26, Cornelia Huck wrote: =20
> >> On Wed, 11 Dec 2019 16:46:09 +0100
> >> Pierre Morel <pmorel@linux.ibm.com> wrote:

> >>> +
> >>> +=C2=A0=C2=A0=C2=A0 senseid.cu_type =3D buffer[2] | (buffer[1] << 8);=
 =20
> >>
> >> This still looks odd; why not have the ccw fill out the senseid
> >> structure directly? =20
> >=20
> > Oh sorry, you already said and I forgot to modify this.
> > thanks =20
>=20
> hum, sorry, I forgot, the sense structure is not padded so I need this.

Very confused; I see padding in the senseid structure? (And what does
padding have to do with it?)

Also, you only copy the cu type... it would really be much better if
you looked at the whole structure you got back from the hypervisor;
that would also allow you to do some more sanity checks etc. If you
really can't pass in a senseid structure directly, just copy everything
you got?

