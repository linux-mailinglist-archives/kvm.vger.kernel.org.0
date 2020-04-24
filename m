Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC861B6FB7
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 10:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbgDXI1U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 04:27:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46860 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726028AbgDXI1U (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Apr 2020 04:27:20 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03O82B8s030020;
        Fri, 24 Apr 2020 04:27:19 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30gmub8te1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 04:27:19 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03O89PGt067823;
        Fri, 24 Apr 2020 04:27:18 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30gmub8tdb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 04:27:18 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03O8KQ9F014955;
        Fri, 24 Apr 2020 08:27:16 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 30fs65grrt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 08:27:16 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03O8RDcN64160206
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 08:27:13 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1FFBA4051;
        Fri, 24 Apr 2020 08:27:13 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6270CA4055;
        Fri, 24 Apr 2020 08:27:13 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.157.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 24 Apr 2020 08:27:13 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v5 04/10] s390x: interrupt registration
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com
References: <1582200043-21760-1-git-send-email-pmorel@linux.ibm.com>
 <1582200043-21760-5-git-send-email-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 mQINBFubpD4BEADX0uhkRhkj2AVn7kI4IuPY3A8xKat0ihuPDXbynUC77mNox7yvK3X5QBO6
 qLqYr+qrG3buymJJRD9xkp4mqgasHdB5WR9MhXWKH08EvtvAMkEJLnqxgbqf8td3pCQ2cEpv
 15mH49iKSmlTcJ+PvJpGZcq/jE42u9/0YFHhozm8GfQdb9SOI/wBSsOqcXcLTUeAvbdqSBZe
 zuMRBivJQQI1esD9HuADmxdE7c4AeMlap9MvxvUtWk4ZJ/1Z3swMVCGzZb2Xg/9jZpLsyQzb
 lDbbTlEeyBACeED7DYLZI3d0SFKeJZ1SUyMmSOcr9zeSh4S4h4w8xgDDGmeDVygBQZa1HaoL
 Esb8Y4avOYIgYDhgkCh0nol7XQ5i/yKLtnNThubAcxNyryw1xSstnKlxPRoxtqTsxMAiSekk
 0m3WJwvwd1s878HrQNK0orWd8BzzlSswzjNfQYLF466JOjHPWFOok9pzRs+ucrs6MUwDJj0S
 cITWU9Rxb04XyigY4XmZ8dywaxwi2ZVTEg+MD+sPmRrTw+5F+sU83cUstuymF3w1GmyofgsU
 Z+/ldjToHnq21MNa1wx0lCEipCCyE/8K9B9bg9pUwy5lfx7yORP3JuAUfCYb8DVSHWBPHKNj
 HTOLb2g2UT65AjZEQE95U2AY9iYm5usMqaWD39pAHfhC09/7NQARAQABtCVKYW5vc2NoIEZy
 YW5rIDxmcmFua2phQGxpbnV4LmlibS5jb20+iQI3BBMBCAAhBQJbm6Q+AhsjBQsJCAcCBhUI
 CQoLAgQWAgMBAh4BAheAAAoJEONU5rjiOLn4p9gQALjkdj5euJVI2nNT3/IAxAhQSmRhPEt0
 AmnCYnuTcHRWPujNr5kqgtyER9+EMQ0ZkX44JU2q7OWxTdSNSAN/5Z7qmOR9JySvDOf4d3mS
 bMB5zxL9d8SbnSs1uW96H9ZBTlTQnmLfsiM9TetAjSrR8nUmjGhe2YUhJLR1v1LguME+YseT
 eXnLzIzqqpu311/eYiiIGcmaOjPCE+vFjcXL5oLnGUE73qSYiujwhfPCCUK0850o1fUAYq5p
 CNBCoKT4OddZR+0itKc/cT6NwEDwdokeg0+rAhxb4Rv5oFO70lziBplEjOxu3dqgIKbHbjza
 EXTb+mr7VI9O4tTdqrwJo2q9zLqqOfDBi7NDvZFLzaCewhbdEpDYVu6/WxprAY94hY3F4trT
 rQMHJKQENtF6ZTQc9fcT5I3gAmP+OEvDE5hcTALpWm6Z6SzxO7gEYCnF+qGXqp8sJVrweMub
 UscyLqHoqdZC2UG4LQ1OJ97nzDpIRe0g6oJ9ZIYHKmfw5jjwH6rASTld5MFWajWdNsqK15k/
 RZnHAGICKVIBOBsq26m4EsBlfCdt3b/6emuBjUXR1pyjHMz2awWzCq6/6OWs5eANZ0sdosNq
 dq2v0ULYTazJz2rlCXV89qRa7ukkNwdBSZNEwsD4eEMicj1LSrqWDZMAALw50L4jxaMD7lPL
 jJbauQINBFubpD4BEADAcUTRqXF/aY53OSH7IwIK9lFKxIm0IoFkOEh7LMfp7FGzaP7ANrZd
 cIzhZi38xyOkcaFY+npGEWvko7rlIAn0JpBO4x3hfhmhBD/WSY8LQIFQNNjEm3vzrMo7b9Jb
 JAqQxfbURY3Dql3GUzeWTG9uaJ00u+EEPlY8zcVShDltIl5PLih20e8xgTnNzx5c110lQSu0
 iZv2lAE6DM+2bJQTsMSYiwKlwTuv9LI9Chnoo6+tsN55NqyMxYqJgElk3VzlTXSr3+rtSCwf
 tq2cinETbzxc1XuhIX6pu/aCGnNfuEkM34b7G1D6CPzDMqokNFbyoO6DQ1+fW6c5gctXg/lZ
 602iEl4C4rgcr3+EpfoPUWzKeM8JXv5Kpq4YDxhvbitr8Dm8gr38+UKFZKlWLlwhQ56r/zAU
 v6LIsm11GmFs2/cmgD1bqBTNHHcTWwWtRTLgmnqJbVisMJuYJt4KNPqphTWsPY8SEtbufIlY
 HXOJ2lqUzOReTrie2u0qcSvGAbSfec9apTFl2Xko/ddqPcZMpKhBiXmY8tJzSPk3+G4tqur4
 6TYAm5ouitJsgAR61Cu7s+PNuq/pTLDhK+6/Njmc94NGBcRA4qTuysEGE79vYWP2oIAU4Fv6
 gqaWHZ4MEI2XTqH8wiwzPdCQPYsSE0fXWiYu7ObeErT6iLSTZGx4rQARAQABiQIfBBgBCAAJ
 BQJbm6Q+AhsMAAoJEONU5rjiOLn4DDEP/RuyckW65SZcPG4cMfNgWxZF8rVjeVl/9PBfy01K
 8R0hajU40bWtXSMiby7j0/dMjz99jN6L+AJHJvrLz4qYRzn2Ys843W+RfXj62Zde4YNBE5SL
 jJweRCbMWKaJLj6499fctxTyeb9+AMLQS4yRSwHuAZLmAb5AyCW1gBcTWZb8ON5BmWnRqeGm
 IgC1EvCnHy++aBnHTn0m+zV89BhTLTUal35tcjUFwluBY39R2ux/HNlBO1GY3Z+WYXhBvq7q
 katThLjaQSmnOrMhzqYmdShP1leFTVbzXUUIYv/GbynO/YrL2gaQpaP1bEUEi8lUAfXJbEWG
 dnHFkciryi092E8/9j89DJg4mmZqOau7TtUxjRMlBcIliXkzSLUk+QvD4LK1kWievJse4mte
 FBdkWHfP4BH/+8DxapRcG1UAheSnSRQ5LiO50annOB7oXF+vgKIaie2TBfZxQNGAs3RQ+bga
 DchCqFm5adiSP5+OT4NjkKUeGpBe/aRyQSle/RropTgCi85pje/juYEn2P9UAgkfBJrOHvQ9
 Z+2Sva8FRd61NJLkCJ4LFumRn9wQlX2icFbi8UDV3do0hXJRRYTWCxrHscMhkrFWLhYiPF4i
 phX7UNdOWBQ90qpHyAxHmDazdo27gEjfvsgYMdveKknEOTEb5phwxWgg7BcIDoJf9UMC
Message-ID: <c8d1081a-8e94-f28e-66e7-fe98aea31837@linux.ibm.com>
Date:   Fri, 24 Apr 2020 10:27:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1582200043-21760-5-git-send-email-pmorel@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wPx7vhOY84tMe3TtHWKKZgdUZIIxEscDN"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_02:2020-04-23,2020-04-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004240057
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wPx7vhOY84tMe3TtHWKKZgdUZIIxEscDN
Content-Type: multipart/mixed; boundary="PdD8IvfZTe6vLUBVmh1zujAiFl1yOzhLJ"

--PdD8IvfZTe6vLUBVmh1zujAiFl1yOzhLJ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2/20/20 1:00 PM, Pierre Morel wrote:
> Let's make it possible to add and remove a custom io interrupt handler,=

> that can be used instead of the normal one.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/interrupt.c | 22 +++++++++++++++++++++-
>  lib/s390x/interrupt.h |  7 +++++++
>  2 files changed, 28 insertions(+), 1 deletion(-)
>  create mode 100644 lib/s390x/interrupt.h
>=20
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index 3a40cac..f6f0665 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -10,9 +10,9 @@
>   * under the terms of the GNU Library General Public License version 2=
=2E
>   */
>  #include <libcflat.h>
> -#include <asm/interrupt.h>
>  #include <asm/barrier.h>
>  #include <sclp.h>
> +#include <interrupt.h>

Hrm

> =20
>  static bool pgm_int_expected;
>  static bool ext_int_expected;
> @@ -144,12 +144,32 @@ void handle_mcck_int(void)
>  		     stap(), lc->mcck_old_psw.addr);
>  }
> =20
> +static void (*io_int_func)(void);
> +
>  void handle_io_int(void)
>  {
> +	if (*io_int_func)
> +		return (*io_int_func)();
>  	report_abort("Unexpected io interrupt: on cpu %d at %#lx",
>  		     stap(), lc->io_old_psw.addr);
>  }
> =20
> +int register_io_int_func(void (*f)(void))
> +{
> +	if (io_int_func)
> +		return -1;
> +	io_int_func =3D f;
> +	return 0;
> +}
> +
> +int unregister_io_int_func(void (*f)(void))
> +{
> +	if (io_int_func !=3D f)
> +		return -1;
> +	io_int_func =3D NULL;
> +	return 0;
> +}

I'm currently working on something similar for PGMs and I see no
additional value in two functions for this. Unregistering can be done by
doing register_io_int_func(NULL)

This should be enough:

int register_io_int_func(void (*f)(void))
{
	io_int_func =3D f;
}

> +
>  void handle_svc_int(void)
>  {
>  	report_abort("Unexpected supervisor call interrupt: on cpu %d at %#lx=
",
> diff --git a/lib/s390x/interrupt.h b/lib/s390x/interrupt.h
> new file mode 100644
> index 0000000..e945ef7
> --- /dev/null
> +++ b/lib/s390x/interrupt.h
> @@ -0,0 +1,7 @@
> +#ifndef __INTERRUPT_H
> +#include <asm/interrupt.h>
> +
> +int register_io_int_func(void (*f)(void));
> +int unregister_io_int_func(void (*f)(void));
> +
> +#endif
>=20



--PdD8IvfZTe6vLUBVmh1zujAiFl1yOzhLJ--

--wPx7vhOY84tMe3TtHWKKZgdUZIIxEscDN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl6iouAACgkQ41TmuOI4
ufi1yg/+OT/HIYcrKEY965SpT9ZzWtHuQuix0LbuTooJicTSB+3+2HMMDvBjPKWl
/Yw5vdUCbuFC1iltxuI/EpceCUjFFzL7Pq4Nwvg0xH0TGDDaPkOOawJtMVkwpjVt
iW7SbDDKTIN212uqIXgJ/uWX6ve/aANeI/ogSzV2MprwJX/IZelUrgLEu8dtn7Sc
lYtpYSgbtzHHSYxYuvsAfCYcAX2e8X7OxTdogpAXAjE78QJRfAT+rKIuY2I7MvaW
TygTwkvVjNaLEo2ryI3nEc3zt4F2AmVfvfncNjX4qiXUL3CwW8E2QrKPW86uaWoF
LZuzOVV/fbeewr3YPjf8yX10XpN7BoAlI9nXZY3xurO3K63wkyIrJPG3fTZVs6fl
3/h9zAvn3w1xmPMj5itldzRiMUF+GCbFQQweGyFeqXWs8GoDvc9JM7Ek0QQgiMYX
PMjxcx3zg9dzdRy0ZN8VXa/PEUF3/b9g7F23VprJ8I3J7vXqJ/SFRL4U/B/eIcyk
broJDhuu/bnunbYXfr4estfqjadpM2MuTYdmE5cZUdECJMYaYy23BK47LOqMAHWZ
wLq9j6GKVQPw2/I9sBn1ahQIDW+VGLgDyUoGv+mc8xr7Y5nGX8BqeznKpBzR6ywC
ab7/mEoeea1W3zXs3gET4isS8jwN+ZVkDZEeNGrfGymaUtzq7sM=
=mExk
-----END PGP SIGNATURE-----

--wPx7vhOY84tMe3TtHWKKZgdUZIIxEscDN--

