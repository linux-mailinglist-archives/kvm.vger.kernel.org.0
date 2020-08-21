Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30C1824D6E4
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 16:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgHUOFU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 10:05:20 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64614 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725897AbgHUOFS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Aug 2020 10:05:18 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07LE3BB0165062
        for <kvm@vger.kernel.org>; Fri, 21 Aug 2020 10:05:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type; s=pp1; bh=Cncje07MCgBkisOKhpZ3HJp22tYNjOwGhifqRFa5u2c=;
 b=byR37CewqezMwVAyCj+w3C17d0mXzZn7pg1RyPiZgTuR+6L/hbVgMlolzFtamBGsBeWL
 pwSQ89oxD7E01skSubALy2GMBPmhAh+sC7hozczU1q/rGlV01CBHlL/CqOUna3i0l2j6
 HOa88kC+KIQbKfU6D3zBnVU+flyFIR2IL+6yYzfOIN0IMuboTC6w/QCsktp96BuBvjfA
 sALJq5MSevb7I8Czfyxbq5OLMYXOzYIT4t523GAF8aJaAi+dGlfdgn9WeJ2SsZ04QtV2
 JunWYFfu2OCTB97TXlR9KEPC6DD7u4jYifCZ5hFFCCunxMrqSFkcE3VCE9tiA04ZFjHD Pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 332dw6kft2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 21 Aug 2020 10:05:15 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07LE3ji2168022
        for <kvm@vger.kernel.org>; Fri, 21 Aug 2020 10:05:14 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 332dw6kfrx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 10:05:14 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07LE5C3S015694;
        Fri, 21 Aug 2020 14:05:12 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3304ujtq0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 14:05:12 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07LE3eBb65798612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Aug 2020 14:03:41 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62CE2AE05A;
        Fri, 21 Aug 2020 14:05:10 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECB44AE058;
        Fri, 21 Aug 2020 14:05:09 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.31.248])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 21 Aug 2020 14:05:09 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 2/2] Use same test names in the default and
 the TAP13 output format
To:     Marc Hartmayer <mhartmay@linux.ibm.com>, kvm@vger.kernel.org
Cc:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20200821123744.33173-1-mhartmay@linux.ibm.com>
 <20200821123744.33173-3-mhartmay@linux.ibm.com>
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
Message-ID: <86d94ab0-9554-3af8-96c5-825c373615ef@linux.ibm.com>
Date:   Fri, 21 Aug 2020 16:05:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200821123744.33173-3-mhartmay@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="zbmPAxhqMrgqLT0TEgpFu6D4sBwxbBBAh"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_08:2020-08-21,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 suspectscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 mlxscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008210130
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--zbmPAxhqMrgqLT0TEgpFu6D4sBwxbBBAh
Content-Type: multipart/mixed; boundary="Wy49vxBs57CCcJFXyiCdNHheQM1Q0Jt5j"

--Wy49vxBs57CCcJFXyiCdNHheQM1Q0Jt5j
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/21/20 2:37 PM, Marc Hartmayer wrote:
> Use the same test names in the TAP13 output as in the default output
> format. This makes the output more consistent. To achieve this, we
> need to pass the test name as an argument to the function
> `process_test_output`.
>=20
> Before this change:
> $ ./run_tests.sh
> PASS selftest-setup (14 tests)
> ...
>=20
> vs.
>=20
> $ ./run_tests.sh -t
> TAP version 13
> ok 1 - selftest: true
> ok 2 - selftest: argc =3D=3D 3
> ...
>=20
> After this change:
> $ ./run_tests.sh
> PASS selftest-setup (14 tests)
> ...
>=20
> vs.
>=20
> $ ./run_tests.sh -t
> TAP version 13
> ok 1 - selftest-setup: true
> ok 2 - selftest-setup: argc =3D=3D 3

This doesn't work for me, we can't just drop prefixes.

I.e. it needs to be "testname: prefix1: prefix2: prefixn: Test text"
selftest-setup: selftest: true


> ...
>=20
> While at it, introduce a local variable `kernel` in
> `RUNTIME_log_stdout` since this makes the function easier to read.
>=20
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> ---
>  run_tests.sh         | 15 +++++++++------
>  scripts/runtime.bash |  6 +++---
>  2 files changed, 12 insertions(+), 9 deletions(-)
>=20
> diff --git a/run_tests.sh b/run_tests.sh
> index 01e36dcfa06e..b5812336866f 100755
> --- a/run_tests.sh
> +++ b/run_tests.sh
> @@ -81,18 +81,19 @@ if [[ $tap_output =3D=3D "no" ]]; then
>      postprocess_suite_output() { cat; }
>  else
>      process_test_output() {
> +        local testname=3D"$1"
>          CR=3D$'\r'
>          while read -r line; do
>              line=3D"${line%$CR}"
>              case "${line:0:4}" in
>                  PASS)
> -                    echo "ok TEST_NUMBER - ${line#??????}" >&3
> +                    echo "ok TEST_NUMBER - ${testname}:${line#*:*:}" >=
&3
>                      ;;
>                  FAIL)
> -                    echo "not ok TEST_NUMBER - ${line#??????}" >&3
> +                    echo "not ok TEST_NUMBER - ${testname}:${line#*:*:=
}" >&3
>                      ;;
>                  SKIP)
> -                    echo "ok TEST_NUMBER - ${line#??????} # skip" >&3
> +                    echo "ok TEST_NUMBER - ${testname}:${line#*:*:} # =
skip" >&3
>                      ;;
>                  *)
>                      ;;
> @@ -114,12 +115,14 @@ else
>      }
>  fi
> =20
> -RUNTIME_log_stderr () { process_test_output; }
> +RUNTIME_log_stderr () { process_test_output "$1"; }
>  RUNTIME_log_stdout () {
> +    local testname=3D"$1"
>      if [ "$PRETTY_PRINT_STACKS" =3D "yes" ]; then
> -        ./scripts/pretty_print_stacks.py $1 | process_test_output
> +        local kernel=3D"$2"
> +        ./scripts/pretty_print_stacks.py "$kernel" | process_test_outp=
ut "$testname"
>      else
> -        process_test_output
> +        process_test_output "$testname"
>      fi
>  }
> =20
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index caa4c5ba18cc..294e6b15a5e2 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -140,10 +140,10 @@ function run()
>      # extra_params in the config file may contain backticks that need =
to be
>      # expanded, so use eval to start qemu.  Use "> >(foo)" instead of =
a pipe to
>      # preserve the exit status.
> -    summary=3D$(eval $cmdline 2> >(RUNTIME_log_stderr) \
> -                             > >(tee >(RUNTIME_log_stdout $kernel) | e=
xtract_summary))
> +    summary=3D$(eval $cmdline 2> >(RUNTIME_log_stderr $testname) \
> +                             > >(tee >(RUNTIME_log_stdout $testname $k=
ernel) | extract_summary))
>      ret=3D$?
> -    [ "$STANDALONE" !=3D "yes" ] && echo > >(RUNTIME_log_stdout $kerne=
l)
> +    [ "$STANDALONE" !=3D "yes" ] && echo > >(RUNTIME_log_stdout $testn=
ame $kernel)
> =20
>      if [ $ret -eq 0 ]; then
>          print_result "PASS" $testname "$summary"
>=20



--Wy49vxBs57CCcJFXyiCdNHheQM1Q0Jt5j--

--zbmPAxhqMrgqLT0TEgpFu6D4sBwxbBBAh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl8/1JUACgkQ41TmuOI4
ufg/HxAAqFnMvzR2EEUlKjx34oD1Mqhe8fjSleEht5Ngi3jsjz9WLlOeehwlMgSR
XywjvlooAGKgHLOx/sGTkRaJW54M9WbUMg2hbQyowMahT9oB4l4+4saWSF7RyBc9
SaCLqgYBrEa6yb9kFejnPvWsGK7ZoYO7DC+k7BNswRcXCap2I6fovVeOhra53tQZ
OehNmYJIu5gwmzu5cEOVlwfKU3tVuMqimK7AeCgglgf2n4+Q7IgjQOn1OmRMSAVC
8gmMAg2Rq51mhsSZ8avdUVDmX4mf18yS5EoF81VbpLwoVmcowSax841Nxs2Kvzx8
82flJqn+40Im7NOX/OWWWUaTySWMA+ivRf3t/emwujQ/vAA5TY7NUe9Mf/7mSaxa
2+q6+do9A/XshobWbaIFp4XvRt6tICIsKM0oxuLyOU+LXO/W/7PcOjF5e+AbE5Ud
7evkq2293LI04NaN2aAUxuE0xFwDm9GybZIisl5YXbPA5o3+pJo/Zkq1cbMvRdGF
MlURKMgNO8AQstF2nHLLe8bkaBs3e3qaoYfI5lAOR9ko2Yas8p/Wis3bDxMAy9yK
RSJ6RubR9GG56A+s3zWc2l75DzjuWftlrpBFwelaiES7YWYlgB541cMAxO/TueoM
oYN0PwpPgSND9Uuz5zIbGXiJWtap+ircIkagMOAmpAB3iQHXrrM=
=utQD
-----END PGP SIGNATURE-----

--zbmPAxhqMrgqLT0TEgpFu6D4sBwxbBBAh--

