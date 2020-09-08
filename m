Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40827260C74
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 09:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729572AbgIHHxA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 03:53:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51506 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729533AbgIHHw5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Sep 2020 03:52:57 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0887WXXP002106;
        Tue, 8 Sep 2020 03:52:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type; s=pp1; bh=9bablMp4+lCsWWYKQ0dqQMk+MaRxZJwrvqbEjGQ2nYo=;
 b=ZdsBKpUdxx4J5PfmJFX2avtZVTByxtnF9TJJtS587M1ibciayPChxD6d4EkJilvz9u2i
 42c2FWdH7xgFO7u4sAkwM3gfgjp3D98RYuBkmYboe/9KigRjetcuiMab49JFwkFAVahr
 qpMLmB9tqbziCg1MGi7QOHbreB8j9POUaI9BBcJCi0ZzJwvNkCC7ziu97pxC8Mf8B68a
 NF9t/Orvvsy97EtwiWl5MCEBZHDRoWzimUoUsrjfrKhtRfQdI/oRcUG5xyxO2KH3prl8
 j8PF9MmJT4gLfXUn70QLZ7ta5FGquxVQtpAlm9ZJzCWG9MFhOkQ3mL8Mtx7rsGorAe9r fA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33e484u3aq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 03:52:54 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0887Wh0H002626;
        Tue, 8 Sep 2020 03:52:54 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33e484u3a3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 03:52:54 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0887qOBj008256;
        Tue, 8 Sep 2020 07:52:52 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 33c2a8b6h6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 07:52:52 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0887qn8I15860072
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Sep 2020 07:52:49 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D2F3A4057;
        Tue,  8 Sep 2020 07:52:49 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E6AEA4051;
        Tue,  8 Sep 2020 07:52:49 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.82.159])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Sep 2020 07:52:48 +0000 (GMT)
Subject: Re: [PATCH v2] KVM: s390: Introduce storage key removal facility
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org
References: <b34e559a-8292-873f-8d33-1e7ce819f4d5@de.ibm.com>
 <20200907143352.96618-1-frankja@linux.ibm.com>
 <20200907183030.07333af7.cohuck@redhat.com>
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
Message-ID: <cd3ce2d9-99a5-5bb5-9b13-62d378274265@linux.ibm.com>
Date:   Tue, 8 Sep 2020 09:52:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200907183030.07333af7.cohuck@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bDdIQxSXyo1Qhe3iT1xeRipwEAmCIgqf5"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_03:2020-09-08,2020-09-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 impostorscore=0
 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009080066
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bDdIQxSXyo1Qhe3iT1xeRipwEAmCIgqf5
Content-Type: multipart/mixed; boundary="q72FnDexAOUcsKP33pSlLf16jxBzFhTiz"

--q72FnDexAOUcsKP33pSlLf16jxBzFhTiz
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 9/7/20 6:30 PM, Cornelia Huck wrote:
> On Mon,  7 Sep 2020 10:33:52 -0400
> Janosch Frank <frankja@linux.ibm.com> wrote:
>=20
>> The storage key removal facility makes skey related instructions
>> result in special operation program exceptions. It is based on the
>> Keyless Subset Facility.
>>
>> The usual suspects are iske, sske, rrbe and their respective
>> variants. lpsw(e), pfmf and tprot can also specify a key and essa with=

>> an ORC of 4 will consult the change bit, hence they all result in
>> exceptions.
>>
>> Unfortunately storage keys were so essential to the architecture, that=

>> there is no facility bit that we could deactivate. That's why the
>> removal facility (bit 169) was introduced which makes it necessary,
>> that, if active, the skey related facilities 10, 14, 66, 145 and 149
>> are zero. Managing this requirement and migratability has to be done
>> in userspace, as KVM does not check the facilities it receives to be
>> able to easily implement userspace emulation.
>>
>> Removing storage key support allows us to circumvent complicated
>> emulation code and makes huge page support tremendously easier.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>
>> v2:
>> 	* Removed the likely
>> 	* Updated and re-shuffeled the comments which had the wrong informati=
on
>>
>> ---
>>  arch/s390/kvm/intercept.c | 40 ++++++++++++++++++++++++++++++++++++++=
-
>>  arch/s390/kvm/kvm-s390.c  |  5 +++++
>>  arch/s390/kvm/priv.c      | 26 ++++++++++++++++++++++---
>>  3 files changed, 67 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
>> index e7a7c499a73f..983647ea2abe 100644
>> --- a/arch/s390/kvm/intercept.c
>> +++ b/arch/s390/kvm/intercept.c
>> @@ -33,6 +33,7 @@ u8 kvm_s390_get_ilen(struct kvm_vcpu *vcpu)
>>  	case ICPT_OPEREXC:
>>  	case ICPT_PARTEXEC:
>>  	case ICPT_IOINST:
>> +	case ICPT_KSS:
>>  		/* instruction only stored for these icptcodes */
>>  		ilen =3D insn_length(vcpu->arch.sie_block->ipa >> 8);
>>  		/* Use the length of the EXECUTE instruction if necessary */
>> @@ -565,7 +566,44 @@ int kvm_handle_sie_intercept(struct kvm_vcpu *vcp=
u)
>>  		rc =3D handle_partial_execution(vcpu);
>>  		break;
>>  	case ICPT_KSS:
>> -		rc =3D kvm_s390_skey_check_enable(vcpu);
>> +		if (!test_kvm_facility(vcpu->kvm, 169)) {
>> +			rc =3D kvm_s390_skey_check_enable(vcpu);
>> +		} else {
>=20
> <bikeshed>Introduce a helper function? This is getting a bit hard to
> read.</bikeshed>
>=20
>> +			/*
>> +			 * Storage key removal facility emulation.
>> +			 *
>> +			 * KSS is the same priority as an instruction
>> +			 * interception. Hence we need handling here
>> +			 * and in the instruction emulation code.
>> +			 *
>> +			 * KSS is nullifying (no psw forward), SKRF
>> +			 * issues suppressing SPECIAL OPS, so we need
>> +			 * to forward by hand.
>> +			 */
>> +			switch (vcpu->arch.sie_block->ipa) {
>> +			case 0xb2b2:
>> +				kvm_s390_forward_psw(vcpu, kvm_s390_get_ilen(vcpu));
>> +				rc =3D kvm_s390_handle_b2(vcpu);
>> +				break;
>> +			case 0x8200:
>=20
> Can we have speaking names? I can only guess that this is an lpsw...

You can only guess from the kvm_s390_handle_lpsw() call below? ;-)

I'd be happy to put this into an own function and add some comments to
the cases where we lack them. However, I don't really want to define
constants for speaking names.

>=20
>> +				kvm_s390_forward_psw(vcpu, kvm_s390_get_ilen(vcpu));
>> +				rc =3D kvm_s390_handle_lpsw(vcpu);
>> +				break;
>> +			case 0:
>> +				/*
>> +				 * Interception caused by a key in a
>> +				 * exception new PSW mask. The guest
>> +				 * PSW has already been updated to the
>> +				 * non-valid PSW so we only need to
>> +				 * inject a PGM.
>> +				 */
>> +				rc =3D kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
>> +				break;
>> +			default:
>> +				kvm_s390_forward_psw(vcpu, kvm_s390_get_ilen(vcpu));
>> +				rc =3D kvm_s390_inject_program_int(vcpu, PGM_SPECIAL_OPERATION);
>> +			}
>> +		}
>>  		break;
>>  	case ICPT_MCHKREQ:
>>  	case ICPT_INT_ENABLE:
>=20



--q72FnDexAOUcsKP33pSlLf16jxBzFhTiz--

--bDdIQxSXyo1Qhe3iT1xeRipwEAmCIgqf5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl9XOFAACgkQ41TmuOI4
ufhxRw/8DNiKgSVDvxYcB9zbinpQ9MQ1574ylhF9gPQss5iInm8r/YP80YLJm87K
SkS1pdAUanSy9C0vPMHEEH1eqbPKgxuAmJvsFqoY1Krts7ydU/T+pHKhyZ8jpo03
1gUM5ZZUtwNNZpESrrma4QoRh0Qjy4HWcyOhaFyFedyySHSzGkl2SS/rPt5VmaKD
29Xt0tzbdV3RgONl8KFoiOZ+hgXq+Hqo+mD4t0mgm0ahD5eVOOT3R5cLwoKDRmIU
DZ9qZulJlzr0TtI4r06s1LWHpByxqbdcygl4ZGE9YtVzIROMz4FeIrk/fBSHBDIX
2BWLEDpjG5y9NFA5gJ+l23C6eVU+HoC/U299+4wnvtKyYDTUbL333Hwovzc1we+v
AffAtKXfdzwWC2JOEwMaP31aruluTF4d7zbTZOEYenT7dLzNYzJMisQM9XeyEylD
Go+4wy7ObX51ayfaLwGlA9a7bItdrZbE/kIGbd8GQYzyvq1Ig9fjHFkoBjNWqwwt
VMgN8DqBy2QFvSLlCl4YgBlmgMeUPqexSBAhS/viHS/bjWOQfxLOm/6aPrzvITC+
TQ4BXcSNEaBIlkevHuq4S3AnghI5JkGvcQtH79fc/pnxQU1pd18yvmYC3Er8CdRB
2S7P20HN12eUepl+ELuznsfzIKYrZ6tZo0/iFcKHJYmeLNUl6oc=
=0Nrr
-----END PGP SIGNATURE-----

--bDdIQxSXyo1Qhe3iT1xeRipwEAmCIgqf5--

