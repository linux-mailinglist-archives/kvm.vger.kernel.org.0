Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8DD8A631F
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 09:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbfICHyF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 03:54:05 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44746 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725895AbfICHyF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Sep 2019 03:54:05 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x837rQa1057406
        for <kvm@vger.kernel.org>; Tue, 3 Sep 2019 03:54:04 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2usk2rt8xx-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2019 03:54:03 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Tue, 3 Sep 2019 08:54:02 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 3 Sep 2019 08:53:59 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x837rw9v52297910
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Sep 2019 07:53:59 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CFF0D4C04A;
        Tue,  3 Sep 2019 07:53:58 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A580B4C05A;
        Tue,  3 Sep 2019 07:53:58 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  3 Sep 2019 07:53:58 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 1/6] s390x: Use interrupts in SCLP and add
 locking
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com
References: <20190829121459.1708-1-frankja@linux.ibm.com>
 <20190829121459.1708-2-frankja@linux.ibm.com>
 <74d31bb9-4941-01f3-571b-8a89a05402c8@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Tue, 3 Sep 2019 09:53:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <74d31bb9-4941-01f3-571b-8a89a05402c8@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SpJOkMZbvakFnXVoieMqmFxOlrPb2ujq6"
X-TM-AS-GCONF: 00
x-cbid: 19090307-0028-0000-0000-00000396FB93
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19090307-0029-0000-0000-0000245947B9
Message-Id: <4309b6ea-e479-f25d-276a-6d8260d4f19f@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-03_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1909030086
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SpJOkMZbvakFnXVoieMqmFxOlrPb2ujq6
Content-Type: multipart/mixed; boundary="JKILaMc7ZmIPmvQPdNRMnIiRLccDQuIvz";
 protected-headers="v1"
From: Janosch Frank <frankja@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, thuth@redhat.com
Message-ID: <4309b6ea-e479-f25d-276a-6d8260d4f19f@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 1/6] s390x: Use interrupts in SCLP and add
 locking
References: <20190829121459.1708-1-frankja@linux.ibm.com>
 <20190829121459.1708-2-frankja@linux.ibm.com>
 <74d31bb9-4941-01f3-571b-8a89a05402c8@redhat.com>
In-Reply-To: <74d31bb9-4941-01f3-571b-8a89a05402c8@redhat.com>

--JKILaMc7ZmIPmvQPdNRMnIiRLccDQuIvz
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/30/19 2:21 PM, David Hildenbrand wrote:
> On 29.08.19 14:14, Janosch Frank wrote:
>> We need to properly implement interrupt handling for SCLP, because on
>> z/VM and LPAR SCLP calls are not synchronous!
>>
>> Also with smp CPUs have to compete for sclp. Let's add some locking,
>> so they execute sclp calls in an orderly fashion and don't compete for=

>> the data buffer.

[...]

>> +
>> +void sclp_mark_busy(void)
>> +{
>> +	/*
>> +	 * With multiple CPUs we might need to wait for another CPU's
>> +	 * request before grabbing the busy indication.
>> +	 */
>> +retry_wait:
>> +	sclp_wait_busy();
>> +	spin_lock(&sclp_lock);
>> +	if (sclp_busy) {
>> +		spin_unlock(&sclp_lock);
>> +		goto retry_wait;
>> +	}
>> +	sclp_busy =3D true;
>> +	spin_unlock(&sclp_lock);
>=20
> while (true) {
> 	sclp_wait_busy();
> 	spin_lock(&sclp_lock);
> 	if (!sclp_busy) {
> 		sclp_busy =3D true
> 		spin_unlock(&sclp_lock);
> 		break;
> 	}
> 	spin_unlock(&sclp_lock);
> }
>=20
> Or can we simply switch to an atomic_t for sclp_busy and implement
> cmpxchg using __sync_bool_compare_and_swap/ __sync_val_compare_and_swap=
 ?
>=20
> I guess then we can drop the lock. But maybe I am missing something :)

If you want to add it and it works, I'm open for it :)
Until then I'm taking your suggestion.

>=20
>> +}
[...]
>>  extern char _sccb[];
>> +void sclp_handle_ext(void);
>> +void sclp_wait_busy(void);
>> +void sclp_mark_busy(void);
>=20
> I wonder if we can find better names ...
>=20
> sclp_prepare()
> sclp_finalize()
>=20
> or sth like that.

Hmm, IMHO my names are a bit better, since they clearly state, that we
wait until the other user has finished.



--JKILaMc7ZmIPmvQPdNRMnIiRLccDQuIvz--

--SpJOkMZbvakFnXVoieMqmFxOlrPb2ujq6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl1uHBYACgkQ41TmuOI4
ufixkg//VLcO4Ts4MtRRyMays08mkXBmk+5ppjPOzsbhNeitS1wND83wd6QrZyRe
bi8tznbHvqBHfTa7kr3/b+Uid4bliklER5snDjGQmrT/QjfxFtWBL4cLtvj65ilL
e3fuAwCgPqQb+uRdqJm9mXXnbG/s3iDBcySS424QZzlNjVoKgnT9VmWR6O0quIg8
0vBG+DmqAO1RX9fSP7d8VRwYJgDABpF/ZYa6HxBlSSS9psEn+P1k9nrqDvUYwdKH
Bv0nBFdAaXOtpmAKWuzRc8C7CkoKqsiR2P0MffIphDYmydEVC9U+bAcRFyySkdrd
nqBBXdGbQ02HTxi8HQDZDm4g2hKDoWdpm8KyjvxIH4hEJGO0QFojQ/T2MuPumoCH
Y0vYGcIiDXWZbv3NshfdiB6cSGDNJUBkE2d+Gw1gjdz4rszY94V2IoiyQlKfwRUU
AO0RJpA0EnUi6a4sE/84862N1BOkILOKD03AooWeZkDH+QUVF2eA4kZC+e9JvpoA
+PEvqFwhJHgFnh8AODeyBsl/SzlC/NlIR+5OZIaAf/Ewpa8jDfZOaE2fQKNtiM3h
SXNLIFxMRSFTaB8JSujAkcgq15bPj5WGz1UzcuI+83a+VzcUys6SS78DEccoCOT8
rt6w+O1qhnga/oy3eNZkR6rBJYMgZ93fFQkaduQFYgfSxmfcbsk=
=RhfB
-----END PGP SIGNATURE-----

--SpJOkMZbvakFnXVoieMqmFxOlrPb2ujq6--

