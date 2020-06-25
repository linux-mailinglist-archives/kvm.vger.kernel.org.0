Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91ACE209FE6
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 15:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405068AbgFYN3N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 09:29:13 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42626 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404829AbgFYN3N (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Jun 2020 09:29:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593091752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dbTwBoD1gpf0C+8LB+fQcdgutOLolzWV3HsBNIH406I=;
        b=DGB4aVOaEMEcUMOROM9UY92IOhvM5681RYsxUlp3qRWeiv7JO1vN9V/TNkViQLps3jADRs
        +caPy9yC3RF1iLBPT4lQ2IK/W6kapNovSdYh0JOS1fvNOqd7xwEk9bjLAs2pgCauMaPW/Z
        Cv9j0XWRwGo11ES1pvIp0uPk4g9Vk2k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-SKqVoDG7OcijFS7TqHmW5g-1; Thu, 25 Jun 2020 09:29:09 -0400
X-MC-Unique: SKqVoDG7OcijFS7TqHmW5g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13CAD1005513;
        Thu, 25 Jun 2020 13:29:07 +0000 (UTC)
Received: from localhost (ovpn-115-49.ams2.redhat.com [10.36.115.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 844DF5C1BB;
        Thu, 25 Jun 2020 13:29:06 +0000 (UTC)
Date:   Thu, 25 Jun 2020 14:29:05 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Cc:     linux-kernel@vger.kernel.org,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, kvm@vger.kernel.org,
        ne-devel-upstream@amazon.com
Subject: Re: [PATCH v4 01/18] nitro_enclaves: Add ioctl interface definition
Message-ID: <20200625132905.GE221479@stefanha-x1.localdomain>
References: <20200622200329.52996-1-andraprs@amazon.com>
 <20200622200329.52996-2-andraprs@amazon.com>
 <20200623085617.GE32718@stefanha-x1.localdomain>
 <60d7d8be-7c8c-964a-a339-8ef7f5bd2fef@amazon.com>
MIME-Version: 1.0
In-Reply-To: <60d7d8be-7c8c-964a-a339-8ef7f5bd2fef@amazon.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wTWi5aaYRw9ix9vO"
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--wTWi5aaYRw9ix9vO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 24, 2020 at 05:02:54PM +0300, Paraschiv, Andra-Irina wrote:
> On 23/06/2020 11:56, Stefan Hajnoczi wrote:
> > On Mon, Jun 22, 2020 at 11:03:12PM +0300, Andra Paraschiv wrote:
> > > +/* User memory region flags */
> > > +
> > > +/* Memory region for enclave general usage. */
> > > +#define NE_DEFAULT_MEMORY_REGION (0x00)
> > > +
> > > +/* Memory region to be set for an enclave (write). */
> > > +struct ne_user_memory_region {
> > > +=09/**
> > > +=09 * Flags to determine the usage for the memory region (write).
> > > +=09 */
> > > +=09__u64 flags;
> > Where is the write flag defined?
> >=20
> > I guess it's supposed to be:
> >=20
> >    #define NE_USER_MEMORY_REGION_FLAG_WRITE (0x01)
>=20
> For now, the flags field is included in the NE ioctl interface for
> extensions, it is not part of the NE PCI device interface yet.
...
> Ah, and just as a note, that "read" / "write" in parentheses means that a
> certain data structure / field is read / written by user space. I updated=
 to
> use "in" / "out" instead of "read" / "write" in v5.

Oops, I got confused. I thought "(write)" was an example of a flag that
can be set on the memory region. Now I realize "write" means this field
is an input to the ioctl. :)

Thanks for updating the docs.

Stefan

--wTWi5aaYRw9ix9vO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl70pqEACgkQnKSrs4Gr
c8gcRQgAmyI2rTGsmEZtaHlxTjz++4tUVP8aA3oeSQfWGC3W37R9QVzDOmezMq2q
m11OujSJ1Cw19EVQbMVRhaf08SsKzh6OkzjPQPJG4zBR1UsIWhRLicFupo/XsXgO
lnVv6L0IK1lRLkjnA0IkdojxQ8dNIDg1PRpO+D1v6sicp7J5yx2lBLTJumFGeSmk
1Sx4NG5bz2Ew2uQv7MecU23IAImlVSpZ6PGt4VnDCZos+IZzx2rECUFWc4HPKwjg
gZHYm48E4Wtqkmx1r3ZAV2l1Mxh8uRFaihKh2XjXV2aoC61KSq/+sRFh5nG7GB0e
DHp7m471tw55PBsPaC2mpvs7h2itbw==
=dth8
-----END PGP SIGNATURE-----

--wTWi5aaYRw9ix9vO--

