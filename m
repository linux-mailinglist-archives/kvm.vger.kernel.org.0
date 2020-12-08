Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16C222D28E9
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 11:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbgLHKaH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 05:30:07 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61800 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726138AbgLHKaG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Dec 2020 05:30:06 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B8A3lW5110977;
        Tue, 8 Dec 2020 05:29:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type; s=pp1; bh=/q+AtQG9CkQbyFwRmsw9IzYWCkRqtptX3eCtXxdIT5A=;
 b=nKn2BBxt8W2CAdsn8VxIO7iz3pV2nNwF3Y6f9s91bATmcBDsazQdfaAf/AXzFAiweFc5
 FkeyWnrKeckngg07Gf55DQLx7WX+L180FMqMJz49z5uADJ1Ein+wIfurr1XMmVEhd8M/
 MgZG/pqxaCl+axqbvNYSFcgUUkvc5JBwqA6WIJhuE86ZUfSPsE2XwHk4CiwjzjBf0/eh
 uyk7Zr4HzflYj3sq2H/6apXSgzW95b0wmAE8FuV/QcY/qs+wDVGf738nDel5P2A2JuOb
 tdCa8ZhZx6OorF/mQvE1ANEwd8mT4bx5WU99pJFUTXIYlASJbsIi+D/eZoVnvVPxQNCV cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 359wwde4rv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 05:29:11 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B89Wbvv110964;
        Tue, 8 Dec 2020 05:29:10 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 359wwde4pu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 05:29:09 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B8ASf4M010097;
        Tue, 8 Dec 2020 10:29:02 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3583svkbun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 10:29:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B8ASxaf41419212
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Dec 2020 10:28:59 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 770334C040;
        Tue,  8 Dec 2020 10:28:59 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D0704C044;
        Tue,  8 Dec 2020 10:28:58 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.56.90])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Tue,  8 Dec 2020 10:28:58 +0000 (GMT)
Date:   Tue, 8 Dec 2020 11:28:29 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>, pair@us.ibm.com,
        brijesh.singh@amd.com, frankja@linux.ibm.com, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, david@redhat.com,
        dgilbert@redhat.com, Eduardo Habkost <ehabkost@redhat.com>,
        qemu-devel@nongnu.org, qemu-s390x@nongnu.org, qemu-ppc@nongnu.org,
        berrange@redhat.com, thuth@redhat.com, pbonzini@redhat.com,
        rth@twiddle.net, mdroth@linux.vnet.ibm.com
Subject: Re: [for-6.0 v5 12/13] securable guest memory: Alter virtio default
 properties for protected guests
Message-ID: <20201208112829.0f8fcdf4.pasic@linux.ibm.com>
In-Reply-To: <20201208015403.GB2555@yekko.fritz.box>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
        <20201204054415.579042-13-david@gibson.dropbear.id.au>
        <d739cae2-9197-76a5-1c19-057bfe832187@de.ibm.com>
        <20201204091706.4432dc1e.cohuck@redhat.com>
        <038214d1-580d-6692-cd1e-701cd41b5cf8@de.ibm.com>
        <20201204154310.158b410e.pasic@linux.ibm.com>
        <20201208015403.GB2555@yekko.fritz.box>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/.IV=x5r6L.IjUJN6uZ=6R+3"; protocol="application/pgp-signature"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-08_06:2020-12-08,2020-12-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 malwarescore=0 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 suspectscore=0 impostorscore=0 adultscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012080059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/.IV=x5r6L.IjUJN6uZ=6R+3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 8 Dec 2020 12:54:03 +1100
David Gibson <david@gibson.dropbear.id.au> wrote:

> > > >>> +         * Virtio devices can't count on directly accessing guest
> > > >>> +         * memory, so they need iommu_platform=3Don to use norma=
l DMA
> > > >>> +         * mechanisms.  That requires also disabling legacy virt=
io
> > > >>> +         * support for those virtio pci devices which allow it.
> > > >>> +         */
> > > >>> +        object_register_sugar_prop(TYPE_VIRTIO_PCI, "disable-leg=
acy",
> > > >>> +                                   "on", true);
> > > >>> +        object_register_sugar_prop(TYPE_VIRTIO_DEVICE, "iommu_pl=
atform",
> > > >>> +                                   "on", false);   =20
> > > >>
> > > >> I have not followed all the history (sorry). Should we also set io=
mmu_platform
> > > >> for virtio-ccw? Halil?
> > > >> =20
> > > >=20
> > > > That line should add iommu_platform for all virtio devices, shouldn=
't
> > > > it? =20
> > >=20
> > > Yes, sorry. Was misreading that with the line above.=20
> > >  =20
> >=20
> > I believe this is the best we can get. In a sense it is still a
> > pessimization, =20
>=20
> I'm not really clear on what you're getting at here.

By pessimiziation, I mean that we are going to indicate
_F_PLATFORM_ACCESS even if it isn't necessary, because the guest never
opted in for confidential/memory protection/memory encryption. We have
discussed this before, and I don't see a better solution that works for
everybody.

Regards,
Halil

--Sig_/.IV=x5r6L.IjUJN6uZ=6R+3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJfz1VnAAoJEA0vhuyXGx0A09UP+wX7WpVWpLrQfblOQAcnGs4e
66Zacg4YfrzkEAR+VGlKQt27C7IB3w+7qSrkxqNO/kZeI2aa+Uc9VGZ9CZJKMy6a
1NnVSSqR6VtJ6Q2eLU7CRacm/Mmb2Dw1VHKxWjupXpvCviGzclCs/32XiL8U+3ss
iuZpH7GPI0Che7OEEhGVyXmzPZ+p7NPMlm4CRtwDC6lCbZ8lQjcaBnR8hAPjHFbx
rL0yp+nIKweFnFE88h5OYXFx5cdlmfqzp1Btk38VksTdgMfZ2JOYnX5DEYPE9Dkw
zjGqQdcpfdjXyUSWq4h7dsmU1JGxhSzU3a5lGLBXoreXEL+/K/bRI/J4+uU7/8nt
Y6QifkpHBPUkGgIuu7+ja7Sn20qQNlug33XKzHYpFINN2ehLPQJn6zMkq2NLda4/
LIXrjShVSMwVLtGGDujHWRR17clFyIFPZ2+BCAC7sXQnsYw5otC/e9aj+54kzeE2
gd2Tj4TUwUeAyYEenmHh84buTBtXxAB911t2pddqQDSL2+UeyG283qlgzDlgG1AJ
kxYqJcwadcAwwU4zT4JtUMxCJFOs4nqhU32v2qlarrWDNkG0vRF95fQ1Sm8okYRM
/9voXbA/gbWrVmNT/kC8n8oT7HPKkAatst//Yg91KITZoFJlD5/brV5bQs+o0VGU
1tZYPudJTC2Pg8VBMjoS
=GE8Q
-----END PGP SIGNATURE-----

--Sig_/.IV=x5r6L.IjUJN6uZ=6R+3--

