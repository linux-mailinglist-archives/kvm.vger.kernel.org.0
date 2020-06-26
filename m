Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C27320B1B8
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 14:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbgFZMuL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 08:50:11 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55458 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725283AbgFZMuK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Jun 2020 08:50:10 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05QCV6P1128443;
        Fri, 26 Jun 2020 08:49:45 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31vvkydwe2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Jun 2020 08:49:45 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05QClMYr042997;
        Fri, 26 Jun 2020 08:49:44 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31vvkydwd1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Jun 2020 08:49:44 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05QCm6g8004337;
        Fri, 26 Jun 2020 12:49:42 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 31uurusrg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Jun 2020 12:49:41 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05QCndtO11928046
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Jun 2020 12:49:39 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE8B842049;
        Fri, 26 Jun 2020 12:49:38 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4904E42047;
        Fri, 26 Jun 2020 12:49:38 +0000 (GMT)
Received: from linux.fritz.box (unknown [9.145.33.49])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 26 Jun 2020 12:49:38 +0000 (GMT)
Subject: Re: [PATCH v3 0/9] Generalize memory encryption models
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     pair@us.ibm.com, Cornelia Huck <cohuck@redhat.com>,
        brijesh.singh@amd.com, Eduardo Habkost <ehabkost@redhat.com>,
        kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        mst@redhat.com, qemu-devel@nongnu.org, mdroth@linux.vnet.ibm.com,
        pasic@linux.ibm.com,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-s390x@nongnu.org, qemu-ppc@nongnu.org, pbonzini@redhat.com,
        Richard Henderson <rth@twiddle.net>,
        David Gibson <david@gibson.dropbear.id.au>
References: <358d48e5-4c57-808b-50da-275f5e2a352c@redhat.com>
 <20200622140254.0dbe5d8c.cohuck@redhat.com>
 <20200625052518.GD172395@umbus.fritz.box>
 <025fb54b-60b7-a58b-e3d7-1bbaad152c5c@redhat.com>
 <20200626044259.GK172395@umbus.fritz.box>
 <892533f8-cd3c-e282-58c2-4212eb3a84b8@redhat.com>
 <a3c05575-6fb2-8d1b-f6d9-2eabf3f4082d@linux.ibm.com>
 <20200626093257.GC1028934@redhat.com>
 <558e8978-01ba-d8e8-9986-15efbbcbca96@linux.ibm.com>
 <20200626102903.GD3087@work-vm> <20200626105846.GF1028934@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <02a4d0c2-0009-470c-274f-d57bad5e063a@linux.ibm.com>
Date:   Fri, 26 Jun 2020 14:49:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200626105846.GF1028934@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="El6nMAB7q4T6iST8bDHyPTuOEcf3nSFhc"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_06:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 malwarescore=0 adultscore=0 impostorscore=0
 priorityscore=1501 mlxscore=0 phishscore=0 cotscore=-2147483648
 spamscore=0 mlxlogscore=999 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006260085
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--El6nMAB7q4T6iST8bDHyPTuOEcf3nSFhc
Content-Type: multipart/mixed; boundary="UQlmEIlw6m3sirtGuTt534H0NygBcc8Jv"

--UQlmEIlw6m3sirtGuTt534H0NygBcc8Jv
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/26/20 12:58 PM, Daniel P. Berrang=C3=A9 wrote:
> On Fri, Jun 26, 2020 at 11:29:03AM +0100, Dr. David Alan Gilbert wrote:=

>> * Janosch Frank (frankja@linux.ibm.com) wrote:
>>> On 6/26/20 11:32 AM, Daniel P. Berrang=C3=83=C2=A9 wrote:
>>>> On Fri, Jun 26, 2020 at 11:01:58AM +0200, Janosch Frank wrote:
>>>>> On 6/26/20 8:53 AM, David Hildenbrand wrote:
>>>>>>>>>> Does this have any implications when probing with the 'none' m=
achine?
>>>>>>>>>
>>>>>>>>> I'm not sure.  In your case, I guess the cpu bit would still sh=
ow up
>>>>>>>>> as before, so it would tell you base feature availability, but =
not
>>>>>>>>> whether you can use the new configuration option.
>>>>>>>>>
>>>>>>>>> Since the HTL option is generic, you could still set it on the =
"none"
>>>>>>>>> machine, though it wouldn't really have any effect.  That is, i=
f you
>>>>>>>>> could create a suitable object to point it at, which would depe=
nd on
>>>>>>>>> ... details.
>>>>>>>>>
>>>>>>>>
>>>>>>>> The important point is that we never want the (expanded) host cp=
u model
>>>>>>>> look different when either specifying or not specifying the HTL
>>>>>>>> property.
>>>>>>>
>>>>>>> Ah, yes, I see your point.  So my current suggestion will satisfy=

>>>>>>> that, basically it is:
>>>>>>>
>>>>>>> cpu has unpack (inc. by default) && htl specified
>>>>>>> 	=3D> works (allowing secure), as expected
>>>>>>
>>>>>> ack
>>>>>>
>>>>>>>
>>>>>>> !cpu has unpack && htl specified
>>>>>>> 	=3D> bails out with an error
>>>>>>
>>>>>> ack
>>>>>>
>>>>>>>
>>>>>>> !cpu has unpack && !htl specified
>>>>>>> 	=3D> works for a non-secure guest, as expected
>>>>>>> 	=3D> guest will fail if it attempts to go secure
>>>>>>
>>>>>> ack, behavior just like running on older hw without unpack
>>>>>>
>>>>>>>
>>>>>>> cpu has unpack && !htl specified
>>>>>>> 	=3D> works as expected for a non-secure guest (unpack feature is=

>>>>>>> 	   present, but unused)
>>>>>>> 	=3D> secure guest may work "by accident", but only if all virtio=

>>>>>>> 	   properties have the right values, which is the user's
>>>>>>> 	   problem
>>>>>>>
>>>>>>> That last case is kinda ugly, but I think it's tolerable.
>>>>>>
>>>>>> Right, we must not affect non-secure guests, and existing secure s=
etups
>>>>>> (e.g., older qemu machines). Will have to think about this some mo=
re,
>>>>>> but does not sound too crazy.
>>>>>
>>>>> I severely dislike having to specify things to make PV work.
>>>>> The IOMMU is already a thorn in our side and we're working on makin=
g the
>>>>> whole ordeal completely transparent so the only requirement to make=
 this
>>>>> work is the right machine, kernel, qemu and kernel cmd line option
>>>>> "prot_virt=3D1". That's why we do the reboot into PV mode in the fi=
rst place.
>>>>>
>>>>> I.e. the goal is that if customers convert compatible guests into
>>>>> protected ones and start them up on a z15 on a distro with PV suppo=
rt
>>>>> they can just use the guest without having to change XML or command=
 line
>>>>> parameters.
>>>>
>>>> If you're exposing new features to the guest machine, then it is usu=
ally
>>>> to be expected that XML and QEMU command line will change. Some simp=
le
>>>> things might be hidable behind a new QEMU machine type or CPU model,=
 but
>>>> there's a limit to how much should be hidden that way while staying =
sane.
>>>>
>>>> I'd really expect the configuration to change when switching a guest=
 to
>>>> a new hardware platform and wanting major new functionality to be en=
abled.
>>>> The XML / QEMU config is a low level instantiation of a particular f=
eature
>>>> set, optimized for a specific machine, rather than a high level desc=
ription
>>>> of ideal "best" config independent of host machine.
>>>
>>> You still have to set the host command line and make sure that unpack=
 is
>>> available. Currently you also have to specify the IOMMU which we like=
 to
>>> drop as a requirement. Everything else is dependent on runtime
>>> information which tells us if we need to take a PV or non-PV branch.
>>> Having the unpack facility should be enough to use the unpack facilit=
y.
>>>
>>> Keep in mind that we have no real concept of a special protected VM t=
o
>>> begin with. If the VM never boots into a protected kernel it will nev=
er
>>> be protected. On a reboot it drops from protected into unprotected mo=
de
>>> to execute the bios and boot loader and then may or may not move back=

>>> into a protected state.
>>
>> My worry isn't actually how painful adding all the iommu glue is, but
>> what happens when users forget; especially if they forget for one
>> device.
>>
>> I could appreciate having a machine option to cause iommu to then get
>> turned on with all other devices; but I think also we could do with
>> something that failed with a nice error if an iommu flag was missing.
>> For SEV this could be done pretty early, but for power/s390 I guess
>> you'd have to do this when someone tried to enable secure mode, but
>> I'm not sure you can tell.
>=20
> What is the cost / downside of turning on the iommu option for virtio
> devices ? Is it something that is reasonable for a mgmt app todo
> unconditionally, regardless of whether memory encryption is in use,
> or will that have a negative impact on things ?

speed, memory usage and compatibility problems.
There might also be a problem with s390 having to use <=3D2GB iommu areas=

in the guest, I need to check with Halil if this is still true.

Also, if the default or specified IOMMU buffer size isn't big enough for
your IO workload the guest is gonna have a very bad time. I.e. if
somebody has an alternative implementation of bounce buffers we'd be
happy to take it :)

>=20
> Regards,
> Daniel
>=20



--UQlmEIlw6m3sirtGuTt534H0NygBcc8Jv--

--El6nMAB7q4T6iST8bDHyPTuOEcf3nSFhc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl717uEACgkQ41TmuOI4
ufgQXA//XWuIt5fblW4/1uXNOKe0HBY4c+r5+Ld/vQ2ixcnCqvPeOhnM+eefyBR4
HetGZVWSh8ynta2C8QVQvm3yFy9xWONLnKLbMszMgdu6zYhBcwEoymqX3sKo15E6
gEORlYgMj93iNFDPx89yAUETgGqJamxPvsVdQolkkT64ubGLnsOsfBXeTh2pKDvz
phMhKwTQDHHV8b+izlbAC25H6NzbLQJ4/1ju323oNPVm3DlUtgeteZg5Kt8B/plV
CrhXYQRa0I+5XVvLEzo/AKFSUNZN3TIUwejLrEVV/mWiKo2dthqpotwyMC9mBQjx
v4lhNgB6SggJsZ4mJcs++rx8ycPi3ff6J/SqzGMME3uzptdFoK7adMWyVPO0cKhe
L3vKWnc5fMelfGFqXt5qZFfJKdCcxEhZL3yg+cgIggaGrtw1+fsNNa/RG0gJye3+
C1djRSKUc6JFd72Hed5oRfllJ0RFWO2qlDh7Gke44zq5/mAMGi/h2SNXGTnkRv8h
V/PM93c/CwjxENfmrpeL/qbuH4YG59iuRghYuPMeTpQEpnMpSpfHdHGB23jMlqKh
oAhs3ifG0pRhiYFX2YyBXyIjJNNAi5VPdrFq8VacyKH2vuK9eKSVWA1TBMt5OKEH
TeihIzt+2tXvSgr0AEBx9xO1xGSPP8fMTRPRQB+6gwbSpq1kjx8=
=3dSN
-----END PGP SIGNATURE-----

--El6nMAB7q4T6iST8bDHyPTuOEcf3nSFhc--

