Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 846B1FCAAA
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 17:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfKNQTL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 11:19:11 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6970 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726263AbfKNQTK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 11:19:10 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAEG3QbC030972
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 11:19:09 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w92jm6jjg-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 11:19:07 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 14 Nov 2019 16:18:55 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 14 Nov 2019 16:18:51 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAEGInBe34341060
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 16:18:49 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4AE1A4064;
        Thu, 14 Nov 2019 16:18:49 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D8E1A405C;
        Thu, 14 Nov 2019 16:18:49 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Nov 2019 16:18:49 +0000 (GMT)
Subject: Re: [RFC 17/37] DOCUMENTATION: protvirt: Instruction emulation
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, mihajlov@linux.ibm.com, mimu@linux.ibm.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-18-frankja@linux.ibm.com>
 <20191114161526.1100f4fe.cohuck@redhat.com>
 <20191114162024.13f17aa9@p-imbrenda.boeblingen.de.ibm.com>
 <20191114164136.0be3f058.cohuck@redhat.com>
 <b94125ec-256c-7d7b-929e-fdbabcacb142@linux.ibm.com>
 <20191114170313.3606d554.cohuck@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Thu, 14 Nov 2019 17:18:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191114170313.3606d554.cohuck@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jSzyJHTUhJUIhYKSXHyzpzQKxIQBAjmA7"
X-TM-AS-GCONF: 00
x-cbid: 19111416-0016-0000-0000-000002C3A847
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111416-0017-0000-0000-000033254B37
Message-Id: <fb7bd025-e486-39b1-3ac0-ab1e80a46489@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-14_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=971 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911140147
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jSzyJHTUhJUIhYKSXHyzpzQKxIQBAjmA7
Content-Type: multipart/mixed; boundary="YwqOWWR8alc2c7qxtq0Q0iLwV1d7IXMU3"

--YwqOWWR8alc2c7qxtq0Q0iLwV1d7IXMU3
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/14/19 5:03 PM, Cornelia Huck wrote:
> On Thu, 14 Nov 2019 16:55:46 +0100
> Janosch Frank <frankja@linux.ibm.com> wrote:
>=20
>> On 11/14/19 4:41 PM, Cornelia Huck wrote:
>>> On Thu, 14 Nov 2019 16:20:24 +0100
>>> Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:
>>>  =20
>>>> On Thu, 14 Nov 2019 16:15:26 +0100
>>>> Cornelia Huck <cohuck@redhat.com> wrote:
>>>> =20
>>>>> On Thu, 24 Oct 2019 07:40:39 -0400
>>>>> Janosch Frank <frankja@linux.ibm.com> wrote:
>=20
>>>>>> +The Secure Instruction Data Area contains instruction storage
>>>>>> +data. Data for diag 500 is exempt from that and has to be moved
>>>>>> +through shared buffers to KVM.     =20
>>>>>
>>>>> I find this paragraph a bit confusing. What does that imply for dia=
g
>>>>> 500 interception? Data is still present in gprs 1-4?   =20
>>>>
>>>> no registers are leaked in the registers. registers are always only
>>>> exposed through the state description. =20
>>>
>>> So, what is so special about diag 500, then? =20
>>
>> That's mostly a confusion on my side.
>> The SIDAD is 4k max, so we can only move IO "management" data over it
>> like ORBs and stuff. My intention was to point out, that the data whic=
h
>> is to be transferred (disk contents, etc.) can't go over the SIDAD but=

>> needs to be in a shared page.
>>
>> diag500 was mostly a notification mechanism without a lot of data, rig=
ht?
>=20
> Yes; the main information in there are the schid identifying the
> subchannel, the virtqueue number, and a cookie value, all of which fit
> into the registers.
>=20
> So this goes via the sidad as well?
>=20

Only referenced data goes over the SIDA, register values go into offset
0x380 of the SIE state description.

If an instruction has an address in a register, we will receive a bogus
address and the referenced data in the SIDA.

SCLP has a code and an address as register values.
We will get the code and a bogus address in the register area.
The SCCB will be in the SIDA.


--YwqOWWR8alc2c7qxtq0Q0iLwV1d7IXMU3--

--jSzyJHTUhJUIhYKSXHyzpzQKxIQBAjmA7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl3NfmkACgkQ41TmuOI4
ufi48Q//e0H4EvQzO9zWoLAuCgPrQAya+QuTueDJ222Jovon5WsD+TqnFapFhxLL
hMxTupw9OVFftzRJIhGQKHWU8RlRejJxd7nQ0vI4XMrGPDpw4wVKrzzEyIeU0uvk
szs0Z1HyIgbp70b/k2ZUPCRDDgKw83jAqPhyK1ggSBK8rMg59drCHb7Ahkc2xTJi
uspkJRa5H0g2gvo1OZ6ES6UCPv/eshcTtY5l3baIzUDEjNo5aqD1a4QqJk120TC5
UQM1YjXf2PAPQeVMKtIakMzIPmCvzMUEKplYrDoeBDFyzxW+AzzWAjbpqEKLu0f8
ylUnktsB+6w88MDT+kEPiW5kg9ljoz/gaLnD6zYd0ifSQkC8TvmFCt1itlsQRAx3
FTbZtQsDP4f+wu7MQeimx7q6+YdGXYmb7s0tlc59g1k2RX5KgZGKQeels6B5j/Ub
PYZGEmCbyX/y97UrRGVEIaNSRCBjn8pYKARCz+bYjUYDm7GQRPPLs5rA1iSe3BG0
kp1efOktq4MBGjxHFFLZL0mhdpyxjraErjrKX8JFdu6eE93qWZDmTYwOAccLGEKt
a5BBNlHtzeCvlEvh2pSrEvLeahiQa+OWU81Kpa5Tea+01yVBRlviKGOfislxN2Wv
hWJq4VK9qAX5w+c9PLiu9MxdhVrXMSWrx73gsLrLfFVeJXsFsgk=
=M3Vx
-----END PGP SIGNATURE-----

--jSzyJHTUhJUIhYKSXHyzpzQKxIQBAjmA7--

