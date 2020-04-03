Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 752C819D104
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 09:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388916AbgDCHQ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 03:16:57 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17466 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732205AbgDCHQ5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Apr 2020 03:16:57 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03374WUQ062261
        for <kvm@vger.kernel.org>; Fri, 3 Apr 2020 03:16:56 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3043ga3pjq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 03 Apr 2020 03:16:55 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Fri, 3 Apr 2020 08:16:45 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 3 Apr 2020 08:16:42 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0337Godv59768980
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Apr 2020 07:16:50 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 766E74C052;
        Fri,  3 Apr 2020 07:16:50 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 280C54C040;
        Fri,  3 Apr 2020 07:16:50 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.45.133])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  3 Apr 2020 07:16:50 +0000 (GMT)
Subject: Re: [kvm-unit-tests v3] s390x/smp: add minimal test for sigp sense
 running status
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
References: <20200402154441.13063-1-borntraeger@de.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Fri, 3 Apr 2020 09:16:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200402154441.13063-1-borntraeger@de.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="iH5I0SO8A39Q1pMrgtbdAHx89p1ImXqJH"
X-TM-AS-GCONF: 00
x-cbid: 20040307-0012-0000-0000-0000039D5FC9
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040307-0013-0000-0000-000021DA7610
Message-Id: <f8323c1e-9dd9-58ab-35d3-4ddc0a43926f@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-03_04:2020-04-02,2020-04-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 malwarescore=0 mlxlogscore=999 impostorscore=0 clxscore=1015
 phishscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004030054
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iH5I0SO8A39Q1pMrgtbdAHx89p1ImXqJH
Content-Type: multipart/mixed; boundary="TDHZDmBDkzJqFaYRNRZKQbep5vr2l9SWt"

--TDHZDmBDkzJqFaYRNRZKQbep5vr2l9SWt
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 4/2/20 5:44 PM, Christian Borntraeger wrote:
> Two minimal tests:
> - our own CPU should be running when we check ourselves
> - a CPU should at least have some times with a not running
> indication. To speed things up we stop CPU1
>=20
> Also rename smp_cpu_running to smp_sense_running_status.

Thanks for fixing this, one nit below.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>


>=20
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  lib/s390x/smp.c |  2 +-
>  lib/s390x/smp.h |  2 +-
>  s390x/smp.c     | 15 +++++++++++++++
>  3 files changed, 17 insertions(+), 2 deletions(-)
>=20
> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
> index 5ed8b7b..492cb05 100644
> --- a/lib/s390x/smp.c
> +++ b/lib/s390x/smp.c
> @@ -58,7 +58,7 @@ bool smp_cpu_stopped(uint16_t addr)
>  	return !!(status & (SIGP_STATUS_CHECK_STOP|SIGP_STATUS_STOPPED));
>  }
> =20
> -bool smp_cpu_running(uint16_t addr)
> +bool smp_sense_running_status(uint16_t addr)
>  {
>  	if (sigp(addr, SIGP_SENSE_RUNNING, 0, NULL) !=3D SIGP_CC_STATUS_STORE=
D)
>  		return true;
> diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
> index a8b98c0..639ec92 100644
> --- a/lib/s390x/smp.h
> +++ b/lib/s390x/smp.h
> @@ -40,7 +40,7 @@ struct cpu_status {
>  int smp_query_num_cpus(void);
>  struct cpu *smp_cpu_from_addr(uint16_t addr);
>  bool smp_cpu_stopped(uint16_t addr);
> -bool smp_cpu_running(uint16_t addr);
> +bool smp_sense_running_status(uint16_t addr);
>  int smp_cpu_restart(uint16_t addr);
>  int smp_cpu_start(uint16_t addr, struct psw psw);
>  int smp_cpu_stop(uint16_t addr);
> diff --git a/s390x/smp.c b/s390x/smp.c
> index 79cdc1f..4450aff 100644
> --- a/s390x/smp.c
> +++ b/s390x/smp.c
> @@ -210,6 +210,20 @@ static void test_emcall(void)
>  	report_prefix_pop();
>  }
> =20
> +static void test_sense_running(void)
> +{
> +	report_prefix_push("sense_running");
> +	/* we are running */
> +	report(smp_sense_running_status(0), "CPU0 sense claims running");
> +	/* make sure CPU is stopped to speed up the not running case */
> +	smp_cpu_stop(1);
> +	/* Make sure to have at least one time with a not running indication =
*/
> +	while(smp_sense_running_status(1));
> +	report(true, "CPU1 sense claims not running");
> +	report_prefix_pop();
> +}
> +
> +

One \n should be enough

>  /* Used to dirty registers of cpu #1 before it is reset */
>  static void test_func_initial(void)
>  {
> @@ -319,6 +333,7 @@ int main(void)
>  	test_store_status();
>  	test_ecall();
>  	test_emcall();
> +	test_sense_running();
>  	test_reset();
>  	test_reset_initial();
>  	smp_cpu_destroy(1);
>=20



--TDHZDmBDkzJqFaYRNRZKQbep5vr2l9SWt--

--iH5I0SO8A39Q1pMrgtbdAHx89p1ImXqJH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl6G4uEACgkQ41TmuOI4
ufgj+Q/+PXZMa5qwKj6koN2U2pCAzEOg1CJwNkSNRAYHAOeTRDCdeqg1AXpcCXU8
8oo4hx90z8rGC+M/7OW8tDkcMrSYJenv1COlpIDeXQPf06RLlLMSbJQxuNRZ00sF
uPv9avI4B5WK/EdpXR3gAA3m24dFb8ejgcYkdFd8d4k+A9tsecrSuxRONc2cH2mm
xInTJX3rQfV3qRx6MNhAXx1mQZHjVqlpJWjE8vV4RHRO3KVKahNliqlxfzXx1xZL
Em57VTWCB2mVg8qDywsqqGBipzzRsrwgEnjrWqIAlVptEyLTjiQsvdKA5SefzL9n
+SzEbNkwT15oa93+RhPtYkDYYdNZpH9mT7GKHGL85uSt9bUVAqVbNxIQrAls+MAB
HlnRSRXCcvwn16oOIYWY478gDI+O0wZ9YXWFAGr91V/RlADSkfkF/WrpcCMT3+Ij
VU+v+dnfV1qbi1UgSf8Ba+YkhzFVEsGbzfEunoCJaVUFL+w4abWG0zQ+A+YbaqEH
L6YSjAFL4D2ZPU9tX1XTxMsaSiDy/uGQG2hUmNASF3mHHKTMyGwbrwGFWFCgMhM9
xSQ2YFaeIY2XJLfydZtPaui/aGRzztKAJYTUuM70ohjgXPVe2yN/w8HPJgnf0gYO
BIJu6T3yq0z+nlj6OIZSJlipVQjmuLjPQRhNrxS8w0KW1F+tE9w=
=U+vp
-----END PGP SIGNATURE-----

--iH5I0SO8A39Q1pMrgtbdAHx89p1ImXqJH--

