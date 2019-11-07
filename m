Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B486F29D8
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 09:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387453AbfKGIxq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Nov 2019 03:53:46 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:46691 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727609AbfKGIxp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Nov 2019 03:53:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573116824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GfR9mtVNwdm5BJ9PpBS3Beg4P93ZCaJfjRi/VlYl1cE=;
        b=cBspsiGVkojyGQtXZGqEKROIquTO3yft/Lp+vKyG5P3q8TisjH2abefu7xYyiYSfNpyy2F
        JbfCUi6+nYI9BJrp2m6WbKGdm03uoefYIdYFc4cTHuSzc/J6U8Yb2+HK6TrjzSnIVxDAJS
        u0MafQZWyI2mTPNzaKHfjIEKC6deyvI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-aaUfKkOsM_ySC3fgMv4P2A-1; Thu, 07 Nov 2019 03:53:40 -0500
X-MC-Unique: aaUfKkOsM_ySC3fgMv4P2A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 961BD1800D6B;
        Thu,  7 Nov 2019 08:53:39 +0000 (UTC)
Received: from gondolin (ovpn-117-222.ams2.redhat.com [10.36.117.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA5381001E75;
        Thu,  7 Nov 2019 08:53:34 +0000 (UTC)
Date:   Thu, 7 Nov 2019 09:53:23 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [RFC 30/37] DOCUMENTATION: protvirt: Diag 308 IPL
Message-ID: <20191107095323.0ede44b5.cohuck@redhat.com>
In-Reply-To: <faacad49-3f91-08f3-d1ee-d31f31ac38bb@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
        <20191024114059.102802-31-frankja@linux.ibm.com>
        <20191106174855.13a50f42.cohuck@redhat.com>
        <6dd98dfe-63ce-374c-9b04-00cdeceee905@linux.ibm.com>
        <20191106183754.68e1be0f.cohuck@redhat.com>
        <faacad49-3f91-08f3-d1ee-d31f31ac38bb@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Mimecast-Spam-Score: 0
Content-Type: multipart/signed; boundary="Sig_/+pqUrJPM52a+7T7phztqDvF";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/+pqUrJPM52a+7T7phztqDvF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 6 Nov 2019 22:02:41 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 11/6/19 6:37 PM, Cornelia Huck wrote:
> > On Wed, 6 Nov 2019 18:05:22 +0100
> > Janosch Frank <frankja@linux.ibm.com> wrote:
> >  =20
> >> On 11/6/19 5:48 PM, Cornelia Huck wrote: =20
> >>> On Thu, 24 Oct 2019 07:40:52 -0400
> >>> Janosch Frank <frankja@linux.ibm.com> wrote:
> >>>    =20
> >>>> Description of changes that are necessary to move a KVM VM into
> >>>> Protected Virtualization mode.
> >>>>
> >>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> >>>> ---
> >>>>  Documentation/virtual/kvm/s390-pv-boot.txt | 62 +++++++++++++++++++=
+++
> >>>>  1 file changed, 62 insertions(+)
> >>>>  create mode 100644 Documentation/virtual/kvm/s390-pv-boot.txt =20
> >  =20
> >>> So... what do we IPL from? Is there still a need for the bios?
> >>>
> >>> (Sorry, I'm a bit confused here.)
> >>>    =20
> >>
> >> We load a blob via the bios (all methods are supported) and that blob
> >> moves itself into protected mode. I.e. it has a small unprotected stub=
,
> >> the rest is an encrypted kernel.
> >> =20
> >=20
> > Ok. The magic is in the loaded kernel, and we don't need modifications
> > to the bios?
> >  =20
>=20
> Yes.
>=20
> The order is:
> * We load a blob via the bios or direct kernel boot.
> * That blob consists of a small stub, a header and an encrypted blob
> glued together
> * The small stub does the diag 308 subcode 8 and 10.
> * Subcode 8 basically passes the header that describes the encrypted
> blob to the Ultravisor (well rather registers it with qemu to pass on lat=
er)
> * Subcode 10 tells QEMU to move the VM into protected mode
> * A lot of APIs in KVM and the Ultravisor are called
> * The protected VM starts
> * A memory mover copies the now unencrypted, but protected kernel to its
> intended place and jumps into the entry function
> * Linux boots and detects, that it is protected and needs to use bounce
> buffers
>=20

Thanks, this explanation makes things much clearer.

--Sig_/+pqUrJPM52a+7T7phztqDvF
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEw9DWbcNiT/aowBjO3s9rk8bwL68FAl3D24MACgkQ3s9rk8bw
L68TdA//a0XhiqGFKJe/PjkQ9y2zl+ZgSrPVyL/j37eYW3DBa5fAyK/o4Yt5CkcW
9DgrfuQ0yZMaQWuh3ZeaKf6bF63bvkLND2ouUEsbteRw9j68GZHm/WXaRpfbztA2
hVGA85DtUwZZ/Gb4OFlEYkEgPvddc+hjnMTwRV4s25K86TIcGvB5/ozb1Oy2Kz+l
JApN0Zwcz1FBIcDpLpPPEk/MhIYnr1n/A1GkLjSm26DmVzxkEVtTC3r9QrXtRUTx
JkGzgn/5uvL0NnK22QRCwRWXrFAvwVt+LVr5x/vjHPxtnJJOQyKRETRHTXkjv+uJ
11dffNfCtO82DyHplnQzDg7+0UfIIWgoEJJPLhaAjEoc3pBhSTtrt3mfe+H/4HBu
VpxZIkZZJnah4vb216hZPr9U0ea2gHKLdlC1o9rZAdJIJM8yuxgYZVQ9lcEXsRNW
9Hsz+FSc/PHl4+2bevvNCal0tRIwQ9enISUyjtSqg6qhJVzaxcbqSfaUDhel0TfY
1WxeopBLE4NPnzdbcCp+qFTGkSkylbpac+GAPNleauxPFW6Z2A27E35Az/qDcXY6
VhGskxkqlMLzcxCCLZX+JdUxj+9RNmGEZMg2pKWDsMZY7MWFSUrrhmsLHZNAmqm9
f4DJF6N0A+OvACM2T8mI/hRLPTvKXtVt1gHOPUh/9OeZ88oS+/0=
=bYAa
-----END PGP SIGNATURE-----

--Sig_/+pqUrJPM52a+7T7phztqDvF--

