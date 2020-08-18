Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50E4A24814E
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 11:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbgHRJDh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 05:03:37 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5530 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726043AbgHRJDh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Aug 2020 05:03:37 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07I8Xj1P088845;
        Tue, 18 Aug 2020 05:03:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=jsd16TsVP1LXEEs6ZppSlgaKKt0JaYPxy1LtKDNq3zc=;
 b=ZY0l4bTNw1RnuRp1s+eBnP7DIOTuJw1Hw6/fYIgU4dkd06hvns0Phd72R0bbHnlK2lu0
 h9tz5vppQCnMT4JoskduvAGr0FrtDi+fqNr5o99HjvBY1069DyvmzF/xNRQiAgcWiQvm
 841+dOCPTr2J4cV40RTtgiJKjy6L3u3OwevECQ2D6kpPYAihje9hVk8QscklLj6cDXhs
 0fmsi282YqyxYQwqtsk+af1FIRNTslSBQFbEsYx3w6FT2g0nPTkxhpSxnqSCwxzjuK6J
 9EQtKhHhpcZc9rprpHYfugKM0nwnQcLLnao7vE243yu7dX+erkucuTAy9Nf2TPvLAI5E fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3304r32k0k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 05:03:36 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07I8kE3a129043;
        Tue, 18 Aug 2020 05:03:36 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3304r32jxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 05:03:36 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07I90l1U012126;
        Tue, 18 Aug 2020 09:03:32 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3304cc0eey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 09:03:32 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07I93U4x57016688
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 09:03:30 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E18D84C05A;
        Tue, 18 Aug 2020 09:03:29 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6615A4C046;
        Tue, 18 Aug 2020 09:03:29 +0000 (GMT)
Received: from marcibm (unknown [9.145.52.109])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 18 Aug 2020 09:03:29 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     Andrew Jones <drjones@redhat.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>
Cc:     kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests RFC v2 3/4] run_tests/mkstandalone: add arch dependent function to `for_each_unittest`
In-Reply-To: <20200814132957.szwmbw6w26fhkroo@kamzik.brq.redhat.com>
References: <20200812092705.17774-1-mhartmay@linux.ibm.com> <20200812092705.17774-4-mhartmay@linux.ibm.com> <20200813083000.e4bscohuhgl3jdv4@kamzik.brq.redhat.com> <87h7t51in7.fsf@linux.ibm.com> <20200814132957.szwmbw6w26fhkroo@kamzik.brq.redhat.com>
Date:   Tue, 18 Aug 2020 11:03:27 +0200
Message-ID: <87ft8k497k.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_06:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=2 priorityscore=1501
 malwarescore=0 impostorscore=0 adultscore=0 clxscore=1015 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180060
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 14, 2020 at 03:29 PM +0200, Andrew Jones <drjones@redhat.com> w=
rote:
> On Fri, Aug 14, 2020 at 03:06:36PM +0200, Marc Hartmayer wrote:
>> On Thu, Aug 13, 2020 at 10:30 AM +0200, Andrew Jones <drjones@redhat.com=
> wrote:
>> > On Wed, Aug 12, 2020 at 11:27:04AM +0200, Marc Hartmayer wrote:
>> >> This allows us, for example, to auto generate a new test case based on
>> >> an existing test case.
>> >>=20
>> >> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>> >> ---
>> >>  run_tests.sh            |  2 +-
>> >>  scripts/common.bash     | 13 +++++++++++++
>> >>  scripts/mkstandalone.sh |  2 +-
>> >>  3 files changed, 15 insertions(+), 2 deletions(-)
>> >>=20
>> >> diff --git a/run_tests.sh b/run_tests.sh
>> >> index 24aba9cc3a98..23658392c488 100755
>> >> --- a/run_tests.sh
>> >> +++ b/run_tests.sh
>> >> @@ -160,7 +160,7 @@ trap "wait; exit 130" SIGINT
>> >>     # preserve stdout so that process_test_output output can write TA=
P to it
>> >>     exec 3>&1
>> >>     test "$tap_output" =3D=3D "yes" && exec > /dev/null
>> >> -   for_each_unittest $config run_task
>> >> +   for_each_unittest $config run_task arch_cmd
>> >
>> > Let's just require that arch cmd hook be specified by the "$arch_cmd"
>> > variable. Then we don't need to pass it to for_each_unittest.
>>=20
>> Where is it then specified?
>
> Just using it that way in the source is enough. We should probably call
> it $ARCH_CMD to indicate that it's a special variable. Also, we could
> return it from a $(arch_cmd) function, which is how $(migration_cmd) and
> $(timeout_cmd) work.

My first approach was different=E2=80=A6

First we source the (common) functions that could be overridden by
architecture dependent code, and then source the architecture dependent
code. But I=E2=80=99m not sure which approach is cleaner - if you prefer yo=
ur
proposed solution with the global variables I can change it.

Thanks for the feedback!

[=E2=80=A6snip]

--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen=20
Gesch=C3=A4ftsf=C3=BChrung: Dirk Wittkopp
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
