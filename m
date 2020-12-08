Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90CEA2D2859
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 11:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbgLHKB1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 05:01:27 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56562 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726218AbgLHKB0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Dec 2020 05:01:26 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B89WbRD110963
        for <kvm@vger.kernel.org>; Tue, 8 Dec 2020 05:00:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=zQ/ptpL7HeCaFX/nsAtFyhMc7b0T4bkEaGQENorjfks=;
 b=MrUtD/OCQwDH2NNnBMLTsDABIZI4Cz5h8/0PYw2AfpL7gFR5DmizvwbUjJVetVp7UUTS
 /OePW7XBLJTHGxE48vJWli5HI094HMSdQYZD6uPeg7a9lXSbk/DIIQLuU6duCUlfxi9W
 KTiPr/S1/9NZGrnDhBsYjE9IOPMDsn7uJf/473By4e0Jxpo/9xOQjgjL17yKmj1ZhQ9n
 fJmpnlO/olqUo7IBZ1igzxTwNtMZ8Hs5S2jxb/ev6vg9C3h9ndR2+CSwynug5ORkD4Yy
 9tib5MA4Qy0xFfPv3n8IDFx4kIw6gY8nZZ6sonxeWNyfvFkWRuU27MIMrBwVkChtoB8N 7Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 359wwdddqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 05:00:44 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B89X3oe112652
        for <kvm@vger.kernel.org>; Tue, 8 Dec 2020 05:00:38 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 359wwdddcw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 05:00:37 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B8A0LEo003570;
        Tue, 8 Dec 2020 10:00:21 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3581u81reb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 10:00:21 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B8A0JiY14483762
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Dec 2020 10:00:19 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1246A406F;
        Tue,  8 Dec 2020 10:00:16 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3857AA409D;
        Tue,  8 Dec 2020 10:00:16 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.11.93])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Dec 2020 10:00:16 +0000 (GMT)
Date:   Tue, 8 Dec 2020 11:00:10 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     KVM <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>, cohuck@redhat.com,
        lvivier@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 4/7] lib/alloc_page: complete rewrite
 of the page allocator
Message-ID: <20201208110010.7d05bd3a@ibm-vm>
In-Reply-To: <A32A8A40-5581-4A3D-9DC8-4591C3A034C7@gmail.com>
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
        <20201002154420.292134-5-imbrenda@linux.ibm.com>
        <C812A718-DCD6-4485-BB5A-B24DE73A0FD3@gmail.com>
        <11863F45-D4E5-4192-9541-EC4D26AC3634@gmail.com>
        <20201208101510.4e3866dc@ibm-vm>
        <A32A8A40-5581-4A3D-9DC8-4591C3A034C7@gmail.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-08_06:2020-12-08,2020-12-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 malwarescore=0 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 suspectscore=0 impostorscore=0 adultscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012080059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 8 Dec 2020 01:23:59 -0800
Nadav Amit <nadav.amit@gmail.com> wrote:

> > On Dec 8, 2020, at 1:15 AM, Claudio Imbrenda
> > <imbrenda@linux.ibm.com> wrote:
> >=20
> > On Mon, 7 Dec 2020 17:10:13 -0800
> > Nadav Amit <nadav.amit@gmail.com> wrote:
> >  =20
> >>> On Dec 7, 2020, at 4:41 PM, Nadav Amit <nadav.amit@gmail.com>
> >>> wrote:=20
> >>>> On Oct 2, 2020, at 8:44 AM, Claudio Imbrenda
> >>>> <imbrenda@linux.ibm.com> wrote:
> >>>>=20
> >>>> This is a complete rewrite of the page allocator.   =20
> >>>=20
> >>> This patch causes me crashes:
> >>>=20
> >>> lib/alloc_page.c:433: assert failed: !(areas_mask & BIT(n))
> >>>=20
> >>> It appears that two areas are registered on AREA_LOW_NUMBER, as
> >>> setup_vm() can call (and calls on my system)
> >>> page_alloc_init_area() twice.
> >>>=20
> >>> setup_vm() uses AREA_ANY_NUMBER as the area number argument but
> >>> eventually this means, according to the code, that
> >>> __page_alloc_init_area() would use AREA_LOW_NUMBER.
> >>>=20
> >>> I do not understand the rationale behind these areas well enough
> >>> to fix it.   =20
> >>=20
> >> One more thing: I changed the previous allocator to zero any
> >> allocated page. Without it, I get strange failures when I do not
> >> run the tests on KVM, which are presumably caused by some
> >> intentional or unintentional hidden assumption of kvm-unit-tests
> >> that the memory is zeroed.
> >>=20
> >> Can you restore this behavior? I can also send this one-line fix,
> >> but I do not want to overstep on your (hopeful) fix for the
> >> previous problem that I mentioned (AREA_ANY_NUMBER). =20
> >=20
> > no. Some tests depend on the fact that the memory is being touched
> > for the first time.
> >=20
> > if your test depends on memory being zeroed on allocation, maybe you
> > can zero the memory yourself in the test?
> >=20
> > otherwise I can try adding a function to explicitly allocate a
> > zeroed page. =20
>=20
> To be fair, I do not know which non-zeroed memory causes the failure,
> and debugging these kind of failures is hard and sometimes
> non-deterministic. For instance, the failure I got this time was:
>=20
> 	Test suite: vmenter
> 	VM-Fail on vmlaunch: error number is 7. See Intel 30.4.
>=20
> And other VM-entry failures, which are not easy to debug, especially
> on bare-metal.

so you are running the test on bare metal?

that is something I had not tested

> Note that the failing test is not new, and unfortunately these kind of
> errors (wrong assumption that memory is zeroed) are not rare, since
> KVM indeed zeroes the memory (unlike other hypervisors and
> bare-metal).
>=20
> The previous allocator had the behavior of zeroing the memory to

I don't remember such behaviour, but I'll have a look

> avoid such problems. I would argue that zeroing should be the default
> behavior, and if someone wants to have the memory =E2=80=9Cuntouched=E2=
=80=9D for a
> specific test (which one?) he should use an alternative function for
> this matter.

probably we need some commandline switches to change the behaviour of
the allocator according to the specific needs of each testcase


I'll see what I can do


Claudio
