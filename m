Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 723D611E71B
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 16:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbfLMPxl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 10:53:41 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:49840 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727927AbfLMPxk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Dec 2019 10:53:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576252419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6mSeLkAJrIQlsEw40+ir2YO83jfRYlQaG97cuRq8JSY=;
        b=GWUe91C9bqBJFTzTHRURmv2t1+QbEvpte+fvDfm3xBj/K4xxUKAazpc2yZU1D9JnrOpBDW
        f4il2wMFeF3VWH+R+6cG3hxMwg/OL4efCE30vuhJao0DGRNilzMsdUCmfqpBwcBmDrPB9Z
        nbT8muz+vybe7sT4XfSryQ2JQ0LegMs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-LOrIJbVbPs65vCuf_qQbHg-1; Fri, 13 Dec 2019 10:53:38 -0500
X-MC-Unique: LOrIJbVbPs65vCuf_qQbHg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A250107ACC4;
        Fri, 13 Dec 2019 15:53:37 +0000 (UTC)
Received: from gondolin (ovpn-116-226.ams2.redhat.com [10.36.116.226])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 58AA75456B;
        Fri, 13 Dec 2019 15:53:33 +0000 (UTC)
Date:   Fri, 13 Dec 2019 16:53:31 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 8/9] s390x: css: ssch/tsch with sense
 and interrupt
Message-ID: <20191213165331.69cb8a34.cohuck@redhat.com>
In-Reply-To: <ea7707f9-bba2-e9f4-77ad-7f2e9fdef21d@linux.ibm.com>
References: <1576079170-7244-1-git-send-email-pmorel@linux.ibm.com>
        <1576079170-7244-9-git-send-email-pmorel@linux.ibm.com>
        <20191212132634.3a16a389.cohuck@redhat.com>
        <1ea58644-9f24-f547-92d5-a99dcb041502@linux.ibm.com>
        <96034dbc-489a-7f76-0402-d5c0c42d20b3@linux.ibm.com>
        <20191213104350.6ebe4aa6.cohuck@redhat.com>
        <ea7707f9-bba2-e9f4-77ad-7f2e9fdef21d@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 13 Dec 2019 16:24:18 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 2019-12-13 10:43, Cornelia Huck wrote:
> > On Thu, 12 Dec 2019 19:20:07 +0100
> > Pierre Morel <pmorel@linux.ibm.com> wrote:
> >  =20
> >> On 2019-12-12 15:10, Pierre Morel wrote: =20
> >>>
> >>>
> >>> On 2019-12-12 13:26, Cornelia Huck wrote: =20
> >>>> On Wed, 11 Dec 2019 16:46:09 +0100
> >>>> Pierre Morel <pmorel@linux.ibm.com> wrote: =20
> >  =20
> >>>>> +
> >>>>> +=C2=A0=C2=A0=C2=A0 senseid.cu_type =3D buffer[2] | (buffer[1] << 8=
); =20
> >>>>
> >>>> This still looks odd; why not have the ccw fill out the senseid
> >>>> structure directly? =20
> >>>
> >>> Oh sorry, you already said and I forgot to modify this.
> >>> thanks =20
> >>
> >> hum, sorry, I forgot, the sense structure is not padded so I need this=
. =20
> >=20
> > Very confused; I see padding in the senseid structure? (And what does
> > padding have to do with it?) =20
>=20
> Sorry my fault:
> I wanted to say packed and... I forgot to pack the senseid structure.
> So I change this.

Ah, good :)

>=20
> >=20
> > Also, you only copy the cu type... it would really be much better if
> > you looked at the whole structure you got back from the hypervisor;
> > that would also allow you to do some more sanity checks etc. If you
> > really can't pass in a senseid structure directly, just copy everything
> > you got?
> >  =20
>=20
> No I can, just need to work properly ;)
>=20
> I will only check on the cu_type but report_info() on all fields.

Sounds good!

