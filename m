Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D859251A23
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 15:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgHYNuB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Aug 2020 09:50:01 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61728 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725468AbgHYNt6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Aug 2020 09:49:58 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07PDmevj088820
        for <kvm@vger.kernel.org>; Tue, 25 Aug 2020 09:49:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : subject :
 in-reply-to : references : date : message-id : mime-version : content-type
 : content-transfer-encoding; s=pp1;
 bh=rZBxm4arik41Jn6rbz9n+pzQIvJH4NgowPQ1JhrO4Jk=;
 b=Qbj0/UVyJyc2lGE5I/r72O/zfet9D0CuCJKDxrIryVB0B7rGUFmwhNGEGlbm5mRLyeH4
 0voxzWT36gFJH2zHDUKZUFiaqh6KO+RiT9F5GGiXDgQUtp2ozfJaI27qqIdXF2POvFMH
 +fjYt54l5doxITDMHYpzX1GUOqMy+P95H2Jn5pSNkFA0MLb/QHcXqOgRgtDRomZFpdaH
 Zr8qzL6Sf2H3fiL3qIr8hg1XgjmH0d4z/oDplLsjCD5ZIKZpBDuGw6LLtA1lUVGkTp61
 /ZxivZC3VW10mPkFb+iY3iLAWwKGG8adbqq+9oAGh8QtbnzsO1UNt+zZT70CLzGw1bGZ 7g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3353uvr0qu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 25 Aug 2020 09:49:57 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07PDmmFP089628
        for <kvm@vger.kernel.org>; Tue, 25 Aug 2020 09:49:57 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3353uvr0qd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Aug 2020 09:49:57 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07PDfvOS015377;
        Tue, 25 Aug 2020 13:49:55 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 332ujkugfp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Aug 2020 13:49:54 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07PDnqxN25559538
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Aug 2020 13:49:52 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E9CF5A405B;
        Tue, 25 Aug 2020 13:49:51 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B03D4A4054;
        Tue, 25 Aug 2020 13:49:51 +0000 (GMT)
Received: from marcibm (unknown [9.145.56.167])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 25 Aug 2020 13:49:51 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 2/2] Use same test names in the
 default and the TAP13 output format
In-Reply-To: <561a201b-3796-8c99-77e5-43756b2556e3@redhat.com>
References: <20200825102036.17232-1-mhartmay@linux.ibm.com>
 <20200825102036.17232-3-mhartmay@linux.ibm.com>
 <561a201b-3796-8c99-77e5-43756b2556e3@redhat.com>
Date:   Tue, 25 Aug 2020 15:49:51 +0200
Message-ID: <87364akf7k.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-25_04:2020-08-25,2020-08-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=2
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008250102
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 25, 2020 at 03:32 PM +0200, Thomas Huth <thuth@redhat.com> wrot=
e:
> On 25/08/2020 12.20, Marc Hartmayer wrote:
>> Use the same test names in the TAP13 output as in the default output
>> format. This makes the output more consistent. To achieve this, we
>> need to pass the test name as an argument to the function
>> `process_test_output`.
>>=20
>> Before this change:
>> $ ./run_tests.sh
>> PASS selftest-setup (14 tests)
>> ...
>>=20
>> vs.
>>=20
>> $ ./run_tests.sh -t
>> TAP version 13
>> ok 1 - selftest: true
>> ok 2 - selftest: argc =3D=3D 3
>> ...
>>=20
>> After this change:
>> $ ./run_tests.sh
>> PASS selftest-setup (14 tests)
>> ...
>>=20
>> vs.
>>=20
>> $ ./run_tests.sh -t
>> TAP version 13
>> ok 1 - selftest-setup: selftest: true
>> ok 2 - selftest-setup: selftest: argc =3D=3D 3
>> ...
>>=20
>> While at it, introduce a local variable `kernel` in
>> `RUNTIME_log_stdout` since this makes the function easier to read.
>>=20
>> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>> ---
>>  run_tests.sh         | 15 +++++++++------
>>  scripts/runtime.bash |  6 +++---
>>  2 files changed, 12 insertions(+), 9 deletions(-)
>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
>

Thanks!

--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen=20
Gesch=C3=A4ftsf=C3=BChrung: Dirk Wittkopp
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
