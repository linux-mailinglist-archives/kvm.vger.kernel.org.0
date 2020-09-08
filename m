Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5DB261D68
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 21:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731845AbgIHTgp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 15:36:45 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25422 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730783AbgIHP5M (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Sep 2020 11:57:12 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 088D39Lx080685;
        Tue, 8 Sep 2020 09:09:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type; s=pp1; bh=AkdEVXJq3U1+aMJ1TdA7MezmsZDz8cyA56tkjS+6IO8=;
 b=EAzHlWydm2gB0KkDOMob/A7qvGyWAL42WS9UX2huVvSKV7DhGPemLeT9Yq9Z2OW4uAVn
 7LbLZi0tkbVJ23K7vKpjpg4HmSum/LXG76VrzLmmEHn8j51vszpBZRp8qFQUpPcU51Ew
 VikJv6KZPYkv1cZnuULBqwqJgI8AWEFad6Tk5dAjkiY0V3nN8lLfFEQltiR7SnmCR61N
 Fk4/w9YKeAKHRdBxg2XsAiZVvsCmcgnPTecxEZ3MSCndmvl7Dw2LBeAqDNKrduRvdX1D
 zJXympPbfrok8CqZzBmU1kMGLY3l265D32GJwZbWPZTgUGsnCaaNzO3GaiHKCfnzIWi5 Kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33e9a333xq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 09:09:29 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 088D3Mba081513;
        Tue, 8 Sep 2020 09:09:29 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33e9a333wu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 09:09:29 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 088D70dV010285;
        Tue, 8 Sep 2020 13:09:27 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 33c2a824fx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 13:09:27 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 088D9OHS33751336
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Sep 2020 13:09:24 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AFBF3A405D;
        Tue,  8 Sep 2020 13:09:24 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C887A4053;
        Tue,  8 Sep 2020 13:09:24 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.36.147])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Sep 2020 13:09:24 +0000 (GMT)
Subject: Re: [PATCH v3] s390x: Add 3f program exception handler
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        gor@linux.ibm.com, imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        david@redhat.com, cohuck@redhat.com, thuth@redhat.com
References: <20200908075337.GA9170@osiris>
 <20200908130504.24641-1-frankja@linux.ibm.com>
 <20200908130655.GF14136@osiris>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <6551fde1-e19c-3b97-7a53-5a4dcb97f7bc@linux.ibm.com>
Date:   Tue, 8 Sep 2020 15:09:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200908130655.GF14136@osiris>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2lqS40GK3SRE5oMpi6hZDXIojnrMFwXIo"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_06:2020-09-08,2020-09-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 bulkscore=0 mlxscore=0 malwarescore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009080118
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2lqS40GK3SRE5oMpi6hZDXIojnrMFwXIo
Content-Type: multipart/mixed; boundary="sBopP0Ojt78REKHyuYgq7QGiWQqZqEZQY"

--sBopP0Ojt78REKHyuYgq7QGiWQqZqEZQY
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 9/8/20 3:06 PM, Heiko Carstens wrote:
> On Tue, Sep 08, 2020 at 09:05:04AM -0400, Janosch Frank wrote:
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
>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> ---
>>  arch/s390/kernel/entry.h     |  1 +
>>  arch/s390/kernel/pgm_check.S |  2 +-
>>  arch/s390/mm/fault.c         | 20 ++++++++++++++++++++
>>  3 files changed, 22 insertions(+), 1 deletion(-)
>=20
> I guess this should go upstream via the s390 tree?

Christian asked the exact same question.
I think we picked the secure/non-secure exception handlers via the s390
tree so bringing these in via s390 would be in line with that.

> Should I pick this up?

That would be nice


--sBopP0Ojt78REKHyuYgq7QGiWQqZqEZQY--

--2lqS40GK3SRE5oMpi6hZDXIojnrMFwXIo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl9XgoMACgkQ41TmuOI4
ufjLEg//QaXlmq2b+cwVWGYcuZonyMlyfKMSfdzv+f60wjq2J9j6/UdWtq6QG0DV
bJoyAnnEFX8OSZpx2/87RiNJa6fWoZ2QOyX1DJnHudeI8LNvoVCuvxDaboFMMVg4
2jUMTsfbHXVywi0POxz3NmzYNDWSfVAMAzNz3V02vJxQaPvukM/Ye2qR+V7gStQq
DguEQejBKZbQKm/Bi6/uKHG/ODT72L0i0e2ZykYLIT7GerY+aGTqq4opXK68Vgi/
0mz48D8XMTes/B8qcFJRC7xqRyifdoh3ZzE7cI9NoS0OOyht4noOjCURittL/9ky
a17J6c7vQK8lxQ6VWS1bETSQIGhNxbf8p/ccUgr9HfCymCTdBzYdfwF2jSSUfusN
jYwtlcTqDHUtPwf+9TAY5Sj572fEUH1pnPYeE/myEl7KzIprVXOWfW2BqbQI2dGa
Ahbol6Y8pmOQLPMpAXXBHxj1IwgwqXQeVBy4IpE1kcz1OQaUAFmx4XvOTIidtV2m
xVsjpF+58irASInatosQuLWtcygx87vrnWI16V+J/ESiB344HLmxhkEwOhbOv62W
1rSZGjM1ugfHuv9b0j+33/BTNOXKmehts7afRcfdsYaKzwQ+PMuSnWRYpk7/yFJm
HZ3RFPawJBN9yY6lgwkNYUNRDYqy63xrF4v+/Iqjo0lFBqBqodg=
=ZzRB
-----END PGP SIGNATURE-----

--2lqS40GK3SRE5oMpi6hZDXIojnrMFwXIo--

