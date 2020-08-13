Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 069AE2439E5
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 14:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbgHMMgf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 08:36:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58812 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726131AbgHMMgc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Aug 2020 08:36:32 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07DCXNZK062720;
        Thu, 13 Aug 2020 08:36:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=ua3iDvPKi4RPQ3RfKxT7srJKHgN4QZ7eEO/uGCY23r8=;
 b=jTGpbDWuYmfuMi81YAYmNgKRlKA1Mc+6TZFaRgm46Wnza/TVq+hFWqtDhFUcfmtJdrOU
 AGSPt9L89PHTXPcMNj96h2IOw+/ibUdCG5a4CjUiO3ltSCnNfFVST5OiHKtHOl6bRNwM
 0/cnjyh8UxG8QH0acZu0jyZ7G4i87HinjENHSQDHywf5X78fMMZT8RHuvBnqTMeFfVnj
 W3cNneizpubdtPieLU2l3JetytCCKzd+R6PX3SYA/bPNUqc2Ru/C3LWdd2d8FosqJt/v
 SgqL6Xb43sPWwJad36eyCFIqCQQo7cGhA15Wtnve+ui7iuGZ5RJ6HZCZmjM3iZi1tJ+i Vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32w24gxmwb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 08:36:32 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07DCaWk4072913;
        Thu, 13 Aug 2020 08:36:32 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32w24gxmva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 08:36:31 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07DCPYOg025526;
        Thu, 13 Aug 2020 12:36:29 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 32skp7ue43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 12:36:29 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07DCYweU64160254
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Aug 2020 12:34:58 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ABB7F52063;
        Thu, 13 Aug 2020 12:36:26 +0000 (GMT)
Received: from marcibm (unknown [9.145.178.142])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 8F53F52052;
        Thu, 13 Aug 2020 12:36:25 +0000 (GMT)
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
Subject: Re: [kvm-unit-tests RFC v2 2/4] scripts: add support for architecture dependent functions
In-Reply-To: <20200813120705.7bggleqpq56jqdxm@kamzik.brq.redhat.com>
References: <20200812092705.17774-1-mhartmay@linux.ibm.com> <20200812092705.17774-3-mhartmay@linux.ibm.com> <20200813074940.73xzr6nq4xktjhpu@kamzik.brq.redhat.com> <87lfiihiqd.fsf@linux.ibm.com> <20200813120705.7bggleqpq56jqdxm@kamzik.brq.redhat.com>
Date:   Thu, 13 Aug 2020 14:36:23 +0200
Message-ID: <87h7t6hge0.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-13_10:2020-08-13,2020-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 phishscore=0 lowpriorityscore=0 suspectscore=2 spamscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1015
 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008130094
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 13, 2020 at 02:07 PM +0200, Andrew Jones <drjones@redhat.com> w=
rote:
> On Thu, Aug 13, 2020 at 01:45:46PM +0200, Marc Hartmayer wrote:
>> On Thu, Aug 13, 2020 at 09:49 AM +0200, Andrew Jones <drjones@redhat.com=
> wrote:
>> > On Wed, Aug 12, 2020 at 11:27:03AM +0200, Marc Hartmayer wrote:
>> >> This is necessary to keep architecture dependent code separate from
>> >> common code.
>> >>=20
>> >> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>> >> ---
>> >>  README.md           | 3 ++-
>> >>  scripts/common.bash | 5 +++++
>> >>  2 files changed, 7 insertions(+), 1 deletion(-)
>> >>=20
>> >> diff --git a/README.md b/README.md
>> >> index 48be206c6db1..24d4bdaaee0d 100644
>> >> --- a/README.md
>> >> +++ b/README.md
>> >> @@ -134,7 +134,8 @@ all unit tests.
>> >>  ## Directory structure
>> >>=20=20
>> >>      .:                  configure script, top-level Makefile, and ru=
n_tests.sh
>> >> -    ./scripts:          helper scripts for building and running tests
>> >> +    ./scripts:          general architecture neutral helper scripts =
for building and running tests
>> >> +    ./scripts/<ARCH>:   architecture dependent helper scripts for bu=
ilding and running tests
>> >>      ./lib:              general architecture neutral services for th=
e tests
>> >>      ./lib/<ARCH>:       architecture dependent services for the tests
>> >>      ./<ARCH>:           the sources of the tests and the created obj=
ects/images
>> >> diff --git a/scripts/common.bash b/scripts/common.bash
>> >> index 96655c9ffd1f..f9c15fd304bd 100644
>> >> --- a/scripts/common.bash
>> >> +++ b/scripts/common.bash
>> >> @@ -52,3 +52,8 @@ function for_each_unittest()
>> >>  	fi
>> >>  	exec {fd}<&-
>> >>  }
>> >> +
>> >> +ARCH_FUNC=3Dscripts/${ARCH}/func.bash
>> >
>> > The use of ${ARCH} adds a dependency on config.mak. It works now becau=
se
>> > in the two places we source common.bash we source config.mak first
>>=20
>> Yep, I know.
>>=20
>> > , but
>> > I'd prefer we make that dependency explicit.
>>=20
>> Okay.
>>=20
>> > We could probably just
>> > source it again from this file.
>>=20
>> Another option is to pass ${ARCH} as an argument when we `source
>> scripts/runtime.bash`
>>=20
>> =3D> `source scripts/runtime.bash "${ARCH}"`
>>=20
>> Which one do you prefer?
>
> The first one. There's a chance that the arch helper functions will
> need more than $ARCH from config.mak. Of course that means we have
> a dependency on config.mak from the arch helper file too. We can
> just add a comment in common.bash about the order of sourcing
> though, as common.bash should be the only file sourcing the
> arch helper file.

Will add it. Thanks!

>
> Thanks,
> drew
>
>>=20
>> >
>> > Thanks,
>> > drew
>> >
>> >> +if [ -f "${ARCH_FUNC}" ]; then
>> >> +	source "${ARCH_FUNC}"
>> >> +fi
>> >> --=20
>> >> 2.25.4
>> >>=20
>> >
>> --=20
>> Kind regards / Beste Gr=C3=BC=C3=9Fe
>>    Marc Hartmayer
>>=20
>> IBM Deutschland Research & Development GmbH
>> Vorsitzender des Aufsichtsrats: Gregor Pillen=20
>> Gesch=C3=A4ftsf=C3=BChrung: Dirk Wittkopp
>> Sitz der Gesellschaft: B=C3=B6blingen
>> Registergericht: Amtsgericht Stuttgart, HRB 243294
>>=20
>
--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen=20
Gesch=C3=A4ftsf=C3=BChrung: Dirk Wittkopp
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
