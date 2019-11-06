Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60015F1C95
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 18:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732289AbfKFRiR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 12:38:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44465 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727286AbfKFRiQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 12:38:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573061895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2K0Oz02jNxfjdTmm8k8SnXt42GxVvZTo5vju30J6EFY=;
        b=d+D62oGm7KEmLy0Frk6GZa20+eFL2YqPszqdK7Ll8xXxzAz/jDtDG/zpvAIFV/lE1CZwIX
        n0BF+onDQjKsOeREv0Lt25OA/OocxDqd5/ByATnd7WE5HCcUU5G5Ouz3fQAQ7Rds/P+Py8
        kWxiP1cb0Bher31mrLGWVQKWOlT6qs4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-wQV1i4JHNt6URo7WCkd3tA-1; Wed, 06 Nov 2019 12:38:13 -0500
X-MC-Unique: wQV1i4JHNt6URo7WCkd3tA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55C89107ACC3;
        Wed,  6 Nov 2019 17:38:12 +0000 (UTC)
Received: from gondolin (dhcp-192-218.str.redhat.com [10.33.192.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A91065D9E1;
        Wed,  6 Nov 2019 17:38:06 +0000 (UTC)
Date:   Wed, 6 Nov 2019 18:37:54 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [RFC 30/37] DOCUMENTATION: protvirt: Diag 308 IPL
Message-ID: <20191106183754.68e1be0f.cohuck@redhat.com>
In-Reply-To: <6dd98dfe-63ce-374c-9b04-00cdeceee905@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
        <20191024114059.102802-31-frankja@linux.ibm.com>
        <20191106174855.13a50f42.cohuck@redhat.com>
        <6dd98dfe-63ce-374c-9b04-00cdeceee905@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Mimecast-Spam-Score: 0
Content-Type: multipart/signed; boundary="Sig_/KFFssDcS.y.elHxVLw6NCDc";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/KFFssDcS.y.elHxVLw6NCDc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 6 Nov 2019 18:05:22 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 11/6/19 5:48 PM, Cornelia Huck wrote:
> > On Thu, 24 Oct 2019 07:40:52 -0400
> > Janosch Frank <frankja@linux.ibm.com> wrote:
> >  =20
> >> Description of changes that are necessary to move a KVM VM into
> >> Protected Virtualization mode.
> >>
> >> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> >> ---
> >>  Documentation/virtual/kvm/s390-pv-boot.txt | 62 +++++++++++++++++++++=
+
> >>  1 file changed, 62 insertions(+)
> >>  create mode 100644 Documentation/virtual/kvm/s390-pv-boot.txt

> > So... what do we IPL from? Is there still a need for the bios?
> >=20
> > (Sorry, I'm a bit confused here.)
> >  =20
>=20
> We load a blob via the bios (all methods are supported) and that blob
> moves itself into protected mode. I.e. it has a small unprotected stub,
> the rest is an encrypted kernel.
>=20

Ok. The magic is in the loaded kernel, and we don't need modifications
to the bios?

--Sig_/KFFssDcS.y.elHxVLw6NCDc
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEw9DWbcNiT/aowBjO3s9rk8bwL68FAl3DBPIACgkQ3s9rk8bw
L68O9Q/+PNV0FWP35V+Byn2eX/IP2pwYzdpktSY2sS/oEIJ2PnUHuJbTqazcwyul
JEJx6NWOunSsqLE4kJHUqncbfLzq+LkbuO+/IXVW7SWuf+J3XhMbT8JyHSSksI6e
LVZgI4D40G4kfCmMT4UubszAnpmpwnxZcgIiCy7Ry5qZEx2jPVxAo6HR3zQ9nkW2
yk+xhrjGmjk0uVR5Ec76jmSTeqMlcDNNQ+wjrZI5TV8HlrxOyaAaJd27MJPuaoPL
GvWjYvVzt8MePAa+T8OXTwR4JSI6YMwUx9X4OuOFIunfgg18f8rWwVqJ0Y/DPw8g
c/rhM3wTfWnOOKCl8qFSBbYXv3ps7YSuJHUIMjRdbNIj4JWXEjpEC4oolMJe5gT7
rNf14r6ERv2y5jMgojSKjwCuh7ZO0ocPeJCTuYxOt3GM8bZ9kSJXE2oxnXXrRchS
MaLTVQj/GUmgowh/8yyBBksrXRapzQ9V08iBkATKn5fUN89/xcVFTZnCUe3VkZfI
KQ15yj7LrDKMAMBwJh3G7MHaNoQnO7GlOFpRluWVNaLRmw84jFBHufxKnm7urTHe
YhC+KH4rPuAerO+VtTHWqSFH3UPyP/8w96q1LLj9kCXXutYKQwcyg29m98L/MCFV
qeNEKJfWDyw+PQl5CVtX6hogkMfhpzWQ2eDeTDkLn544d7DeR1E=
=VQrj
-----END PGP SIGNATURE-----

--Sig_/KFFssDcS.y.elHxVLw6NCDc--

