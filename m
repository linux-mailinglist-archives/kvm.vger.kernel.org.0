Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24BD525D773
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 13:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729297AbgIDLd4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 07:33:56 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31040 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730189AbgIDLdj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Sep 2020 07:33:39 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 084BWj5p120794;
        Fri, 4 Sep 2020 07:33:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type; s=pp1; bh=VuVsqKWg8boYjCEZZZ3xj+8Q2qShDb7v9lFKGwvFH/E=;
 b=JjDrNO7LmORGSgFI0os3APbt3jKJReLg2Qc/xlI8n655+U5ImaYAvkO4MzALOqpuG09n
 V7cYkxFB29fqnqBRluf07pZdX9UjgLs9ddr/AN2zO025pdyBwZ55nB8Bl+yh/okJZeuI
 BnIXebtoEPxs/Ycf7kqH2dtp+6bmYJ4uMWzW4NXYslJ3FrU/bv86jDw1qGciMOFzYydA
 9dijsTCJrmMHHPcJVWV6o89YlVdNJvihskQ3YRPoeCPw4dLRaHKCFkx6umVIi8rdHBqJ
 NzpdIUysPT6IbPhxbfxJqg8EdlwFUs6p7y3AV8EOBQcm2rMmMVzjN9V0R8WdogMaImPZ 8g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33bm2ds9kb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Sep 2020 07:33:35 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 084BWnpi120993;
        Fri, 4 Sep 2020 07:33:35 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33bm2ds9jf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Sep 2020 07:33:34 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 084BS5pT029610;
        Fri, 4 Sep 2020 11:33:32 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 33b8s60jdc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Sep 2020 11:33:32 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 084BXTMV30802372
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Sep 2020 11:33:29 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C825042041;
        Fri,  4 Sep 2020 11:33:29 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5703342047;
        Fri,  4 Sep 2020 11:33:29 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.183.173])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  4 Sep 2020 11:33:29 +0000 (GMT)
Subject: Re: [PATCH 2/2] s390x: Add 3f program exception handler
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        gor@linux.ibm.com, imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        david@redhat.com
References: <20200903131435.2535-1-frankja@linux.ibm.com>
 <20200903131435.2535-3-frankja@linux.ibm.com> <20200904103543.GD6075@osiris>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <36e1c11c-c4a2-6ae2-b341-7d582203d031@linux.ibm.com>
Date:   Fri, 4 Sep 2020 13:33:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200904103543.GD6075@osiris>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="R0pLoHIvQxnoeDOKoMKKZHuT4PSxwBQtC"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-04_06:2020-09-04,2020-09-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 phishscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 malwarescore=0
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009040100
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--R0pLoHIvQxnoeDOKoMKKZHuT4PSxwBQtC
Content-Type: multipart/mixed; boundary="gTcbVriBs7lyOx8yYKq2peyJQlKqyu5Tr"

--gTcbVriBs7lyOx8yYKq2peyJQlKqyu5Tr
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 9/4/20 12:35 PM, Heiko Carstens wrote:
> On Thu, Sep 03, 2020 at 09:14:35AM -0400, Janosch Frank wrote:
>> Program exception 3f (secure storage violation) can only be detected
>> when the CPU is running in SIE with a format 4 state description,
>> e.g. running a protected guest. Because of this and because user
>> space partly controls the guest memory mapping and can trigger this
>> exception, we want to send a SIGSEGV to the process running the guest
>> and not panic the kernel.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> CC: <stable@vger.kernel.org> # 5.7+
>> Fixes: 084ea4d611a3 ("s390/mm: add (non)secure page access exceptions =
handlers")
>> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>> ---
>>  arch/s390/kernel/pgm_check.S |  2 +-
>>  arch/s390/mm/fault.c         | 23 +++++++++++++++++++++++
>>  2 files changed, 24 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/s390/kernel/pgm_check.S b/arch/s390/kernel/pgm_check=
=2ES
>> index 2c27907a5ffc..9a92638360ee 100644
>> --- a/arch/s390/kernel/pgm_check.S
>> +++ b/arch/s390/kernel/pgm_check.S
>> @@ -80,7 +80,7 @@ PGM_CHECK(do_dat_exception)		/* 3b */
>>  PGM_CHECK_DEFAULT			/* 3c */
>>  PGM_CHECK(do_secure_storage_access)	/* 3d */
>>  PGM_CHECK(do_non_secure_storage_access)	/* 3e */
>> -PGM_CHECK_DEFAULT			/* 3f */
>> +PGM_CHECK(do_secure_storage_violation)	/* 3f */
>>  PGM_CHECK(monitor_event_exception)	/* 40 */
>>  PGM_CHECK_DEFAULT			/* 41 */
>>  PGM_CHECK_DEFAULT			/* 42 */
>> diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
>> index 4c8c063bce5b..20abb7c5c540 100644
>> --- a/arch/s390/mm/fault.c
>> +++ b/arch/s390/mm/fault.c
>> @@ -859,6 +859,24 @@ void do_non_secure_storage_access(struct pt_regs =
*regs)
>>  }
>>  NOKPROBE_SYMBOL(do_non_secure_storage_access);
>> =20
>> +void do_secure_storage_violation(struct pt_regs *regs)
>> +{
>> +	char buf[TASK_COMM_LEN];
>> +
>> +	/*
>> +	 * Either KVM messed up the secure guest mapping or the same
>> +	 * page is mapped into multiple secure guests.
>> +	 *
>> +	 * This exception is only triggered when a guest 2 is running
>> +	 * and can therefore never occur in kernel context.
>> +	 */
>> +	printk_ratelimited(KERN_WARNING
>> +			   "Secure storage violation in task: %s, pid %d\n",
>> +			   get_task_comm(buf, current), task_pid_nr(current));
>=20
> Why get_task_comm() and task_pid_nr() instead of simply current->comm
> and current->pid?

Normally if there are functions to get data I assume those should be used=
=2E

> Also: is the dmesg message of any value?

Yes, it's import for administrators to know that an exception caused
this segfault and not some memory shenanigans.

As the exception only occurs if a guest runs in unsupported modes like
sharing the memory between two secure guests it's a good first
indication what went wrong.

>=20
>> +	send_sig(SIGSEGV, current, 0);
>> +}
>> +NOKPROBE_SYMBOL(do_secure_storage_violation);>
> Why is this NOKPROBE? Can this deadlock?
Right, we don't need to export this at all, this was copied over from
the export function above.




--gTcbVriBs7lyOx8yYKq2peyJQlKqyu5Tr--

--R0pLoHIvQxnoeDOKoMKKZHuT4PSxwBQtC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl9SJggACgkQ41TmuOI4
ufijEA//ci8Z+hrIydllOPAvpGImC3hQj3IEKWQSA7AEXvSVKbNV5SoBiAFcmCKy
UaK79mI3VbgydHpDx6THvgZ3qNGjHGomCJ2WxKFmi+Y03a8tMP0XWFeSEn7dC1a+
1R7CWVvA9b/ZpwzZ3BxdkHxw06vs5pUZryiUQCMtJLdwhxAnYJe1Mggr13CsC4QD
djjUQ2dKWBfwBLFIivFXQWIKlG6RA545vtMQNvs7YFY/+0PXNNMnc/zpAkOU5muJ
WHI4G38iXVhvlIcmpcB7fEDu4fXWHyHZnEWVWh/e5tsabWPwpd0jHZuYjRWyg9bu
ySBOJeEkirBXkrddHVdcp7553hnezs9VtwSSzZ/FT1lJ17tF4+St6KJcdhsE8UKL
HY0brhmPfNaS0bmSby5X8lp0KvGZLclSLypXO/8XD3UMXVR5UI00J39apo70BKsm
WuwzxFjPOz4Ia2qofKPWbzzih5uQQKDAxlP7QOR3Z45+wyO79zAMrPEK3fSa1aVb
CnXScEtaBe1I9iY5tr6RLcrubKpI763ST9TA1YoOa8S/4JddJANljJ91BmC40Ij7
CksJMQNkGApCTmWzSGVhANVKLM8KH5zc3vCdPoNGKlr02bhVz/BOKg+vmljg+xUS
x7C73Qgy2sSfK20KZZ8heDUMLSmYCWGuqFxneIq8XnR/DShTfZw=
=CCcz
-----END PGP SIGNATURE-----

--R0pLoHIvQxnoeDOKoMKKZHuT4PSxwBQtC--

