Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDF6A6426
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 10:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbfICIpA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 04:45:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16302 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725888AbfICIpA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Sep 2019 04:45:00 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x838Sj0l057729
        for <kvm@vger.kernel.org>; Tue, 3 Sep 2019 04:44:59 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2uskbgbfs8-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2019 04:44:58 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Tue, 3 Sep 2019 09:44:57 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 3 Sep 2019 09:44:54 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x838ir0532243826
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Sep 2019 08:44:53 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A96A5A4065;
        Tue,  3 Sep 2019 08:44:53 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 83239A4051;
        Tue,  3 Sep 2019 08:44:53 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  3 Sep 2019 08:44:53 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 6/6] s390x: SMP test
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com
References: <20190829121459.1708-1-frankja@linux.ibm.com>
 <20190829121459.1708-7-frankja@linux.ibm.com>
 <50b70561-f39d-6edc-600a-ccb707fe5b92@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Tue, 3 Sep 2019 10:44:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <50b70561-f39d-6edc-600a-ccb707fe5b92@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3sXhjKLvK0fkEAFQXA1xGpPJMmpB2H03I"
X-TM-AS-GCONF: 00
x-cbid: 19090308-4275-0000-0000-0000036073BB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19090308-4276-0000-0000-00003872B45E
Message-Id: <03b3850b-ad7d-3b2c-957e-f236849d37b3@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-03_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1909030091
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3sXhjKLvK0fkEAFQXA1xGpPJMmpB2H03I
Content-Type: multipart/mixed; boundary="hmNiZHtHLxTng5D3crw3X30FfVuHSnZ2D";
 protected-headers="v1"
From: Janosch Frank <frankja@linux.ibm.com>
To: Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, david@redhat.com
Message-ID: <03b3850b-ad7d-3b2c-957e-f236849d37b3@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 6/6] s390x: SMP test
References: <20190829121459.1708-1-frankja@linux.ibm.com>
 <20190829121459.1708-7-frankja@linux.ibm.com>
 <50b70561-f39d-6edc-600a-ccb707fe5b92@redhat.com>
In-Reply-To: <50b70561-f39d-6edc-600a-ccb707fe5b92@redhat.com>

--hmNiZHtHLxTng5D3crw3X30FfVuHSnZ2D
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 9/2/19 5:40 PM, Thomas Huth wrote:
> On 29/08/2019 14.14, Janosch Frank wrote:
>> Testing SIGP emulation for the following order codes:
>> * start
>> * stop
>> * restart
>> * set prefix
>> * store status
>> * stop and store status
>> * reset
>> * initial reset
>> * external call
>> * emegergency call
>>
>> restart and set prefix are part of the library and needed to start
>> other cpus.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
[...]
>> +static void test_stop(void)
>> +{
>> +	int i =3D 0;
>> +
>> +	smp_cpu_stop(1);
>> +	/*
>> +	 * The smp library waits for the CPU to shut down, but let's
>> +	 * also do it here, so we don't rely on the library
>> +	 * implementation
>> +	 */
>> +	while (!smp_cpu_stopped(1)) {}
>> +	t =3D 0;
>> +	/* Let's leave some time for cpu #2 to change t */
>=20
> CPU #2 ? Where? Why?
>=20
>> +	for (; i < 0x100000; i++) {}
>=20
> I'm pretty sure the compiler optimizes empty loops away.

Yeah, I removed all of that...

>=20
>> +	report("stop", !t);
>> +}
>> +
>> +static void test_stop_store_status(void)
>> +{
>> +	struct cpu *cpu =3D smp_cpu_from_addr(1);
>> +	struct lowcore *lc =3D (void *)0x0;
>=20
> Do you want to erase the values in the save area before calling the
> "store_status"? ... just to be sure that we don't see old values there?=


Well at least resetting the prefix and gr15 to 0

>=20
>> +	smp_cpu_stop_store_status(1);
>> +	mb();
>> +	report("stop store status",
>> +	       lc->prefix_sa =3D=3D (uint32_t)(uintptr_t)cpu->lowcore);
>=20
> That confused me. Why does the prefix_sa of the lowcore of CPU 0 match
> the prefix of CPU 1 ? I'd rather expect cpu->lowcore->prefix_sa to
> contain this value?

Store status saves at absolute 0, i.e. we get the status in cpu0's lowcor=
e.

>=20
> Maybe you could also check that at least the stack pointer GPR is !=3D =
0
> in the save area?

Sure, I also fixed everything below



--hmNiZHtHLxTng5D3crw3X30FfVuHSnZ2D--

--3sXhjKLvK0fkEAFQXA1xGpPJMmpB2H03I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl1uKAUACgkQ41TmuOI4
ufgqdBAAhgFrRewTZNza9spa7KVPIPedhXIZHcgoN1/OeVQkBAlWGUsXZb0DvOe0
Byf0Fn+TCaMLAPke031dYkbZ4n52fiaY16sw8tX8bNO7aQVCnnjVn13jP6ueoJrf
StiHH7rPZnj/t2v5Y1VvYutJg0oNi6WGsyEIYxAuBRcNOR6xHZZdtHDJCt2fnSNP
b469zvhnBXdCY5Pi1fXOV0JrEtMh4rpWNSFoofAhOpyEatzeH11gIcfSJvAEn+jw
/SXHRTGzFL7zFynUkBeYHigGeN15yHLI4nUKcq2tWOytFp7sJ26HZpcn05veZQJA
QeI6O6NEFywOro8FKHVdOKX4uZRuqTNqc8OLX4LYcYNkAqMyuAOLdaHYb2+UZGeM
urCOqD1FQRB4yhxAZuD+I3DkS3wwiTriFMasQQ3Oq1L+gv/z6NHWoi5P62LDHyB6
5xEOnfSdcbDF0Kj6F27cUXFcBxar8MQlDPF/J/tC5O1GfuY7TeZZrwM9DENE5+gH
2OJseSSEmsbw1y6LIkbdOx1pWfuqf+9lDJ9B0A8EN2LUQ49VuXp+BnbF7aE/lD/o
SWmMj/l+wVZeQJDJ41aL/23Sl9eVBLwd32KRz0CKn5eJ6RyMwsD5LXPcAYWjNQFI
6FtgOyD7WD//MvMZnuVkIZiV0uc8vj8qwb+mGRoIeOnZtIbA6WU=
=up/q
-----END PGP SIGNATURE-----

--3sXhjKLvK0fkEAFQXA1xGpPJMmpB2H03I--

