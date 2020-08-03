Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B3523A119
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 10:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgHCIdl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Aug 2020 04:33:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30822 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725831AbgHCIdk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Aug 2020 04:33:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596443619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eiODh9iEk5Y1dLmycFGRV8bBkh4XdJ9QBJIGydOQe60=;
        b=RrXygq2okYD0fthYgfbbv99nEXrGj7/rcAYaFR/mJQx1TmAvVSrcph3zzuw495MLYkCsOi
        GTZ4dCRPak1UunfUVPGl6su0LqnXEnOBtpnzOXxnEe80Uryx3pCPcFliF/mCqwrXswchGd
        +104sOWvbbH/fLiFEhC5iDzE6VuttWw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-y6embGqIMTyNY_T3JCLjeA-1; Mon, 03 Aug 2020 04:33:35 -0400
X-MC-Unique: y6embGqIMTyNY_T3JCLjeA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF23180183C;
        Mon,  3 Aug 2020 08:33:32 +0000 (UTC)
Received: from gondolin (ovpn-112-197.ams2.redhat.com [10.36.112.197])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A5AC787E35;
        Mon,  3 Aug 2020 08:33:18 +0000 (UTC)
Date:   Mon, 3 Aug 2020 10:33:07 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     Janosch Frank <frankja@linux.ibm.com>, dgilbert@redhat.com,
        pair@us.ibm.com, qemu-devel@nongnu.org, pbonzini@redhat.com,
        brijesh.singh@amd.com, Thomas Huth <thuth@redhat.com>,
        "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>,
        ehabkost@redhat.com, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        mdroth@linux.vnet.ibm.com, pasic@linux.ibm.com,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-s390x@nongnu.org, qemu-ppc@nongnu.org,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [for-5.2 v4 10/10] s390: Recognize host-trust-limitation option
Message-ID: <20200803103307.3b213a1c.cohuck@redhat.com>
In-Reply-To: <20200803081457.GE7553@yekko.fritz.box>
References: <20200724025744.69644-1-david@gibson.dropbear.id.au>
        <20200724025744.69644-11-david@gibson.dropbear.id.au>
        <8be75973-65bc-6d15-99b0-fbea9fe61c80@linux.ibm.com>
        <20200803075459.GC7553@yekko.fritz.box>
        <d8168c58-7935-99e7-dfe5-d97f22766bf7@linux.ibm.com>
        <20200803081457.GE7553@yekko.fritz.box>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; boundary="Sig_/JpL+alQ2rrMB=FqQpkLBumG";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/JpL+alQ2rrMB=FqQpkLBumG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 3 Aug 2020 18:14:57 +1000
David Gibson <david@gibson.dropbear.id.au> wrote:

> On Mon, Aug 03, 2020 at 10:07:42AM +0200, Janosch Frank wrote:
> > On 8/3/20 9:54 AM, David Gibson wrote: =20
> > > On Mon, Aug 03, 2020 at 09:49:42AM +0200, Janosch Frank wrote: =20
> > >> On 7/24/20 4:57 AM, David Gibson wrote: =20
> > >>> At least some s390 cpu models support "Protected Virtualization" (P=
V),
> > >>> a mechanism to protect guests from eavesdropping by a compromised
> > >>> hypervisor.
> > >>>
> > >>> This is similar in function to other mechanisms like AMD's SEV and
> > >>> POWER's PEF, which are controlled bythe "host-trust-limitation"
> > >>> machine option.  s390 is a slightly special case, because we alread=
y
> > >>> supported PV, simply by using a CPU model with the required feature
> > >>> (S390_FEAT_UNPACK).
> > >>>
> > >>> To integrate this with the option used by other platforms, we
> > >>> implement the following compromise:
> > >>>
> > >>>  - When the host-trust-limitation option is set, s390 will recogniz=
e
> > >>>    it, verify that the CPU can support PV (failing if not) and set
> > >>>    virtio default options necessary for encrypted or protected gues=
ts,
> > >>>    as on other platforms.  i.e. if host-trust-limitation is set, we
> > >>>    will either create a guest capable of entering PV mode, or fail
> > >>>    outright
> > >>>
> > >>>  - If host-trust-limitation is not set, guest's might still be able=
 to
> > >>>    enter PV mode, if the CPU has the right model.  This may be a
> > >>>    little surprising, but shouldn't actually be harmful. =20
> > >>
> > >> As I already explained, they have to continue to work without any ch=
ange
> > >> to the VM's configuration. =20
> > >=20
> > > Yes.. that's what I'm saying will happen.
> > >  =20
> > >> Our users already expect PV to work without HTL. This feature is alr=
eady
> > >> being used and the documentation has been online for a few months. I=
've
> > >> already heard enough complains because users found small errors in o=
ur
> > >> documentation. I'm not looking forward to complains because suddenly=
 we
> > >> need to specify new command line arguments depending on the QEMU ver=
sion.
> > >>
> > >> @Cornelia: QEMU is not my expertise, am I missing something here? =
=20
> > >=20
> > > What I'm saying here is that you don't need a new option.  I'm only
> > > suggesting we make the new option the preferred way for future
> > > upstream releases.  (the new option has the advantage that you *just*
> > > need to specify it, and any necessary virtio or other options to be
> > > compatible should be handled for you).
> > >=20
> > > But existing configurations should work as is (I'm not sure they do
> > > with the current patch, because I'm not familiar with the s390 code
> > > and have no means to test PV, but that can be sorted out before
> > > merge).
> > >  =20
> > OK, should and might are two different things so I was a bit concerned.
> > That's fine then, thanks for the answer. =20
>=20
> Well, the "should" and "might" are covering different things.
> Existing working command lines should continue to work.  But those
> command lines must already have the necessary tweaks to make virtio
> work properly.  If you try to make a new command line for a PV guest
> with a virtio device - or anything else that introduces extra PV
> complications - then just chosing a CPU model with UNPACK might not be
> enough.  By contrast, if you set host-trust-limitation, then it should
> work and be PV capable with an arbitrary set of devices, or else fail
> immediately with a meaningful error.

Yes, that was also my understanding.

Getting the interaction with the cpu model right seems to be the tricky
part, though. The UNPACK feature would only be set automatically
_after_ the htl device has already checked for it...

--Sig_/JpL+alQ2rrMB=FqQpkLBumG
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEw9DWbcNiT/aowBjO3s9rk8bwL68FAl8ny8MACgkQ3s9rk8bw
L68bYhAAgJSdtqjUzbxvCFFHLhDpjwAQY/kiMyI+yqVHl6hMxa/57Xiz76RXAiVL
nM3Uptu8TPHJa9nh1XYN6Zt8kCU/KIg2wZCKqap60EbmfIBFH8f0dfeouPGDmxDu
o6OY5wwnJNnD4iJgUxHv9PYWj8DKGXDc10xP4H4lO1jtIBXGfdcP0Y1JKrmY+ztj
zfZF6XFCgLuFpS3MMzk1eIryiDnxGn3PS4nZEq3fdi8GgRinbWgdiI5Yez4e4B5D
NMnFcv1+vbh8HVSUUFAkw9/heZOPpqZzknF5aEP3b2q6v7lDPChv/v+ttnsLeipY
Ln8L9w56lRKZNRCf5YrA/wsIygjwdSRqjHx0JrzOZJtTXcVPWrqYIj6ZdMucKhO8
v+gzUB2hnOvag9hR507LKmgQXb4fwdng4dhZPUxvBR1EwUZG8It4yj1fxvms5t9k
8TKSG/8i5HTEeUHPJZXZBfriYu2suiqwS2WWTR3ClPMSVA657t6YWPI4VtfX1uVB
dN0seJXgl0MjfjOoPAu4eoITVbx/NzHHqdMlVRTedewVUVeQIbuEdu8qR/q2xknH
4RKvdBy1uzz7Aqu/1VpughHs2E8r8wuPghN4k+MSKkFMrd1rsuWNIC6pANJCkgtX
qraO5PLlimfLqOkO21/C69YVtuetALZ9z9uE9hPjaa/a98+grzo=
=p0E1
-----END PGP SIGNATURE-----

--Sig_/JpL+alQ2rrMB=FqQpkLBumG--

