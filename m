Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E102823A0A3
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 10:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbgHCIID (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Aug 2020 04:08:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54328 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725806AbgHCIIC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Aug 2020 04:08:02 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07383H5s168611;
        Mon, 3 Aug 2020 04:07:51 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32pejd0cgd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Aug 2020 04:07:51 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07383u5G173254;
        Mon, 3 Aug 2020 04:07:50 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32pejd0cfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Aug 2020 04:07:49 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07385cF4000345;
        Mon, 3 Aug 2020 08:07:47 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 32n017s5sj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Aug 2020 08:07:47 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07387iP324772948
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Aug 2020 08:07:44 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7108911C054;
        Mon,  3 Aug 2020 08:07:44 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6298511C04A;
        Mon,  3 Aug 2020 08:07:43 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.10.116])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  3 Aug 2020 08:07:43 +0000 (GMT)
Subject: Re: [for-5.2 v4 10/10] s390: Recognize host-trust-limitation option
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     dgilbert@redhat.com, pair@us.ibm.com, qemu-devel@nongnu.org,
        pbonzini@redhat.com, brijesh.singh@amd.com,
        Thomas Huth <thuth@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        ehabkost@redhat.com, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        mdroth@linux.vnet.ibm.com, pasic@linux.ibm.com,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-s390x@nongnu.org, qemu-ppc@nongnu.org,
        Richard Henderson <rth@twiddle.net>
References: <20200724025744.69644-1-david@gibson.dropbear.id.au>
 <20200724025744.69644-11-david@gibson.dropbear.id.au>
 <8be75973-65bc-6d15-99b0-fbea9fe61c80@linux.ibm.com>
 <20200803075459.GC7553@yekko.fritz.box>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <d8168c58-7935-99e7-dfe5-d97f22766bf7@linux.ibm.com>
Date:   Mon, 3 Aug 2020 10:07:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200803075459.GC7553@yekko.fritz.box>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QKkNjYvcXDqfI0uWcoFAxsXJMV1COg3YR"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-03_07:2020-07-31,2020-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 spamscore=0 clxscore=1015
 priorityscore=1501 suspectscore=0 bulkscore=0 mlxscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008030057
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QKkNjYvcXDqfI0uWcoFAxsXJMV1COg3YR
Content-Type: multipart/mixed; boundary="pWdHnZrIVTMls8jZxRmVeMVuot5HtyRQJ"

--pWdHnZrIVTMls8jZxRmVeMVuot5HtyRQJ
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/3/20 9:54 AM, David Gibson wrote:
> On Mon, Aug 03, 2020 at 09:49:42AM +0200, Janosch Frank wrote:
>> On 7/24/20 4:57 AM, David Gibson wrote:
>>> At least some s390 cpu models support "Protected Virtualization" (PV)=
,
>>> a mechanism to protect guests from eavesdropping by a compromised
>>> hypervisor.
>>>
>>> This is similar in function to other mechanisms like AMD's SEV and
>>> POWER's PEF, which are controlled bythe "host-trust-limitation"
>>> machine option.  s390 is a slightly special case, because we already
>>> supported PV, simply by using a CPU model with the required feature
>>> (S390_FEAT_UNPACK).
>>>
>>> To integrate this with the option used by other platforms, we
>>> implement the following compromise:
>>>
>>>  - When the host-trust-limitation option is set, s390 will recognize
>>>    it, verify that the CPU can support PV (failing if not) and set
>>>    virtio default options necessary for encrypted or protected guests=
,
>>>    as on other platforms.  i.e. if host-trust-limitation is set, we
>>>    will either create a guest capable of entering PV mode, or fail
>>>    outright
>>>
>>>  - If host-trust-limitation is not set, guest's might still be able t=
o
>>>    enter PV mode, if the CPU has the right model.  This may be a
>>>    little surprising, but shouldn't actually be harmful.
>>
>> As I already explained, they have to continue to work without any chan=
ge
>> to the VM's configuration.
>=20
> Yes.. that's what I'm saying will happen.
>=20
>> Our users already expect PV to work without HTL. This feature is alrea=
dy
>> being used and the documentation has been online for a few months. I'v=
e
>> already heard enough complains because users found small errors in our=

>> documentation. I'm not looking forward to complains because suddenly w=
e
>> need to specify new command line arguments depending on the QEMU versi=
on.
>>
>> @Cornelia: QEMU is not my expertise, am I missing something here?
>=20
> What I'm saying here is that you don't need a new option.  I'm only
> suggesting we make the new option the preferred way for future
> upstream releases.  (the new option has the advantage that you *just*
> need to specify it, and any necessary virtio or other options to be
> compatible should be handled for you).
>=20
> But existing configurations should work as is (I'm not sure they do
> with the current patch, because I'm not familiar with the s390 code
> and have no means to test PV, but that can be sorted out before
> merge).
>=20
OK, should and might are two different things so I was a bit concerned.
That's fine then, thanks for the answer.


--pWdHnZrIVTMls8jZxRmVeMVuot5HtyRQJ--

--QKkNjYvcXDqfI0uWcoFAxsXJMV1COg3YR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl8nxc4ACgkQ41TmuOI4
ufjDxRAAw0dabUDmmn6G6qBPVQW2IbkjP2SOkX/GbR3o//6I+y8i70fXkCZ2qcD+
Gv31llEv0XKBQw6Uf+eJGOBQti36ub3hJ6cLtwzdL4kWG532WKZYw34xtkG4bHlm
OMtNSGUm6G56//ywLV9fh2j2kSwNr9fm93nEAvU8vpf8v5uXrF4SrraMUMpF+rGp
Af2QYXkqJPyRrYWPx/7tNqO83cgXFDRk4r733TBPZwqE6lQ1xAUyr1mMLk3VflPL
H+Bw9edtzhJgFPlACYSSYNfN5IQyczrTQxSASuI9Ep/f2efeMqyWy2q4Skrppmvy
2LcRxyJdzOuxKqDxmZIar2KiEZlrQvuFhhxsv/CZsE98dgVKFZNQqUMv7AdKC/NI
8ywa/lM7eD6LVovymTSswTtx29rSs7tdM7kf7H39cA7umBIRUfT3kkT1AmhLrK/r
v+IA18HA034unJ4oW/PlywAvcP+L0q1arzn2MlICiFeGhhEHAnDD3p3A7tjbWFDn
GUMH2yLuJe8i/DS+1nog+PPnpjtXLnWb/RxXBc7UstfMGipS91vzH36w0z8/xzdm
4D8EzHGks6K/A02LUkuHDbaN4nADKqtjXaNKH7m/4HqZ6Haz4JTV82rofxR9hP35
BadStshSj7Z6G6wSOvHIyVUJvjg36Fs5TTB2uyFofQu4ln3izME=
=r92x
-----END PGP SIGNATURE-----

--QKkNjYvcXDqfI0uWcoFAxsXJMV1COg3YR--

