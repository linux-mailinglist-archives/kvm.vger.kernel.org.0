Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB4A8231EA0
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 14:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgG2Meh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 08:34:37 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:56556 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726853AbgG2Meg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Jul 2020 08:34:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596026074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=vpjuFUWMrn9WdHgMkjvTUGEbQN0jEb4t1IAuJiFnXjk=;
        b=ZT70JLS/OQTYWiIEJrreNRO3hnxb2H2hvAtupLp0NvsMpIqwHO2ixRfk1CAJ8mtSGDaxrY
        aXKl+nHmy9IVfVFGCsl3mYhn+nlJCX7yefPz5PIzjf7XKTUH9X4YSubJnWme0qLLnyvBMc
        ufbZNGGekvLLWEyGzsWCAS5ILzg0X/M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-h_FhbikHPpedD8tYSaoKKg-1; Wed, 29 Jul 2020 08:34:30 -0400
X-MC-Unique: h_FhbikHPpedD8tYSaoKKg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFF6D193F561;
        Wed, 29 Jul 2020 12:34:28 +0000 (UTC)
Received: from [10.10.115.176] (ovpn-115-176.rdu2.redhat.com [10.10.115.176])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D484271917;
        Wed, 29 Jul 2020 12:34:04 +0000 (UTC)
Subject: Re: WARNING: suspicious RCU usage - while installing a VM on a CPU
 listed under nohz_full
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        "frederic@kernel.org" <frederic@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Juri Lelli <juri.lelli@redhat.com>
References: <ece36eb1-253a-8ec6-c183-309c10bb35d5@redhat.com>
 <CANRm+Cywhi1p5gYLfG=JcyTdYuWK+9bGqF6HD-LiBJM9Q5ykNQ@mail.gmail.com>
 <CANRm+CwrT=gxxgkNdT3wFwzWYYh3FFrUU=aTqH8VT=MraU7jkw@mail.gmail.com>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <57ea501b-bf54-3fc0-4a8f-2820df623b14@redhat.com>
Date:   Wed, 29 Jul 2020 08:34:02 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CANRm+CwrT=gxxgkNdT3wFwzWYYh3FFrUU=aTqH8VT=MraU7jkw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uP5kPhxszyverNECWhXQL2pWCXsNZwIT3"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uP5kPhxszyverNECWhXQL2pWCXsNZwIT3
Content-Type: multipart/mixed; boundary="aewA7KPMFFsjEBrrWzBF8yJT1ydYVsyUm"

--aewA7KPMFFsjEBrrWzBF8yJT1ydYVsyUm
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 7/28/20 10:38 PM, Wanpeng Li wrote:
> Hi Nitesh=EF=BC=8C
> On Wed, 29 Jul 2020 at 09:00, Wanpeng Li <kernellwp@gmail.com> wrote:
>> On Tue, 28 Jul 2020 at 22:40, Nitesh Narayan Lal <nitesh@redhat.com> wro=
te:
>>> Hi,
>>>
>>> I have recently come across an RCU trace with the 5.8-rc7 kernel that h=
as the
>>> debug configs enabled while installing a VM on a CPU that is listed und=
er
>>> nohz_full.
>>>
>>> Based on some of the initial debugging, my impression is that the issue=
 is
>>> triggered because of the fastpath that is meant to optimize the writes =
to x2APIC
>>> ICR that eventually leads to a virtual IPI in fixed delivery mode, is g=
etting
>>> invoked from the quiescent state.
> Could you try latest linux-next tree? I guess maybe some patches are
> pending in linux-next tree, I can't reproduce against linux-next tree.

Sure, I will try this today.

>
--=20
Nitesh


--aewA7KPMFFsjEBrrWzBF8yJT1ydYVsyUm--

--uP5kPhxszyverNECWhXQL2pWCXsNZwIT3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl8hbLoACgkQo4ZA3AYy
ozlZvg/+LT3pvapMn9VLl3twNaZIEHWtQw30VDPKArk34leSbQp03otfi+5eevwB
z8nRH7eRSRX6C1E2b5CQfGArHJOSnIG0rDMoSssjdZ/j1IlgDCkz2opSWRnXmMZW
T4gRo9Yrx/iJ1c/dkGgYPua/mThq4HaayCK/oYyce+7XUhZqbiFOyEi4GtmEv3J9
Pog/da4dPJOJ8X7fSJ3QANiMB1cTTReCKEbLo2tKn5YOLvU/kParAMVLN0di4J0q
pZQF3THHMFa8pmRbfs1Ew6ntPRAy8w84pRGjc4YkVwZVphQyEfbWShl28avXCEpw
7zeVNZGc0QOJONWyajlJH3sWdiYJucAWHWnCCcP4JP9Eu8Q1ELbUuoTLAXZW0m3e
L+Kgr/Wk03QilVLI7ubHQ4jNA2Lzor97jgCv/WMSs+BtvMQb4EycmaLhfXkSdemo
rvedo4ALiBUUTrECeiKWVrWTf0Ov7vy8nklAdGqQpb2wLk7e3AQ1U1XbqPd49E0v
0Eln8yHmIJL6PT3DmAM5aaW4ucB/TllqD8lvam//ToZsw0BZjPl5Z+j1nqk1uavf
gqwwDRK5DI1vZBcpkA005O7aiRrrSRhjHX1vWbJZbNpIm5vmbACVh2h2gyTTfqLP
ylW6auqQeGGScnVzsf9As1+ERR1oF/Op0Iz1ii5ZX8kq7W0PLyM=
=/NZJ
-----END PGP SIGNATURE-----

--uP5kPhxszyverNECWhXQL2pWCXsNZwIT3--

