Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 101A52EAE3B
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 16:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbhAEP11 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 10:27:27 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18164 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727634AbhAEP10 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Jan 2021 10:27:26 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 105FHHM9018915
        for <kvm@vger.kernel.org>; Tue, 5 Jan 2021 10:26:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Wz/xTfzybee5KnMdk6qorTCIZJ18cNK+u9TMC+gIyb4=;
 b=Lpyo90PfiN9m5u2sqTGokF9Cf/pSEmmT493K7f2zBscUv9A16eVxeDX7rSsaxZIK+qR5
 44JaBmpiCJfqRUDJ6Rxg8BqDyykOe48nIArdu/jQFHbc/jlSW9IT1p3AztOW94K31lp7
 KSbiC8VrspxuRz4+vAZg/bqtwJA0UEJz8LLdUZUh9ZS6rhTxhTEKGyqwpfyD8YPqwkus
 TWzZurRP23nTIoCJfdFhHhCed5Qq/k1N3uko1YXMQp7T3vpXAiyZNqtYIcX7piThMm5+
 BexgBa/NhxI+HDtxYs8TATugsv8V2NDHGY1TUNZoCwokkIfITwo0s8hfqPu94KJuwMLZ Nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35vtj38hgv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 05 Jan 2021 10:26:43 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 105FHxWs021771
        for <kvm@vger.kernel.org>; Tue, 5 Jan 2021 10:26:43 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35vtj38hce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jan 2021 10:26:43 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 105F9MX0023494;
        Tue, 5 Jan 2021 15:26:36 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 35va37gcte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jan 2021 15:26:36 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 105FQUND24117614
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Jan 2021 15:26:30 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3ED6F4203F;
        Tue,  5 Jan 2021 15:26:34 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D14D942045;
        Tue,  5 Jan 2021 15:26:33 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.0.177])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Jan 2021 15:26:33 +0000 (GMT)
Date:   Tue, 5 Jan 2021 16:26:31 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, cohuck@redhat.com,
        lvivier@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 00/12] Fix and improve the page
 allocator
Message-ID: <20210105162631.6d78d7b7@ibm-vm>
In-Reply-To: <C13936BE-B930-4822-AC69-8165B8636896@gmail.com>
References: <20201216201200.255172-1-imbrenda@linux.ibm.com>
        <8A03C81A-BE59-4C1F-8056-94364C79933B@gmail.com>
        <20201218151937.715bf26f@ibm-vm>
        <C13936BE-B930-4822-AC69-8165B8636896@gmail.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-05_03:2021-01-05,2021-01-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 mlxscore=0 bulkscore=0
 phishscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101050093
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 27 Dec 2020 22:31:56 -0800
Nadav Amit <nadav.amit@gmail.com> wrote:

[...]

> >> Thanks for doing that. Before I test it, did you also fix the issue
> >> of x86=E2=80=99s setup_vm() [1]?
> >>=20
> >> [1] https://www.spinics.net/lists/kvm/msg230470.html =20
> >=20
> > unfortunately no, because I could not reproduce it.
> >=20
> > In theory setup_vm should just work, since it is called twice, but
> > on different address ranges.
> >=20
> > The only issue I can think of is if the second call overlaps
> > multiple areas.
> >=20
> > can you send me the memory map of that machine you're running the
> > tests on? (/proc/iomem) =20
>=20
> Sorry for the late response.
>=20
> I see two calls to _page_alloc_init_area() with AREA_LOW_NUMBER, one
> with (base_pfn=3D621, top_pfn=3Dbfdd0) and one with (base_pfn=3D100000
> top_pfn=3D240000).

ok, I could reproduce the issue now.

to put it simply, the old code is broken.

I could not reproduce the issue with the new code, so you should be
able to test it.
