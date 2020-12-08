Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6AD22D2C22
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 14:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbgLHNm3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 08:42:29 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54424 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726338AbgLHNm3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Dec 2020 08:42:29 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B8DXOnC136091
        for <kvm@vger.kernel.org>; Tue, 8 Dec 2020 08:41:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=VEtcIKskBOsB1Oij23MEfHdooKj3fTStyn+YkDC+cNQ=;
 b=XJ6Hh2UBeXPGHKk3tVgRd+gCMI2DSP656qxn440GYXyT/fjJ95kmsk6WcpenXz0W058i
 Ykz0vCYpN9v8izOBEssztOWnY4EEyyuEXHY4X6bVOusYzk5lUcLpTDiFjR7KuhgQwcVw
 JU/vbP8j8AwKvXSSa8EWQn+rnx8y8QodBqQdo3MC2/zW0j2f9PSzYKUjVS9uhbuJGr4s
 J46A99fzzN9EYzqrC4yvZVi4tgMgPplkpUYeWgjeER9ulHtDEnneAbatmeHMblyf+5Yt
 DZYuKtwzHo8Ctb/kdZnFcCDhVqQ5ID22XZ7/r2K0nPGvUNRazL327JMsKTyXspOToOdP Jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35a5ufrp5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 08:41:48 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B8DXVdI136583
        for <kvm@vger.kernel.org>; Tue, 8 Dec 2020 08:41:48 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35a5ufrp4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 08:41:48 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B8DbxB1003476;
        Tue, 8 Dec 2020 13:41:46 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3581u8nats-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 13:41:45 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B8DfhT353739838
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Dec 2020 13:41:43 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64BF0AE04D;
        Tue,  8 Dec 2020 13:41:43 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4890AE045;
        Tue,  8 Dec 2020 13:41:42 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.2.78])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Dec 2020 13:41:42 +0000 (GMT)
Date:   Tue, 8 Dec 2020 14:41:39 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     KVM <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>, cohuck@redhat.com,
        lvivier@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 4/7] lib/alloc_page: complete rewrite
 of the page allocator
Message-ID: <20201208144139.1054d411@ibm-vm>
In-Reply-To: <7D823148-A383-470A-9611-E77C2E442524@gmail.com>
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
        <20201002154420.292134-5-imbrenda@linux.ibm.com>
        <C812A718-DCD6-4485-BB5A-B24DE73A0FD3@gmail.com>
        <11863F45-D4E5-4192-9541-EC4D26AC3634@gmail.com>
        <20201208101510.4e3866dc@ibm-vm>
        <A32A8A40-5581-4A3D-9DC8-4591C3A034C7@gmail.com>
        <20201208110010.7d05bd3a@ibm-vm>
        <7D823148-A383-470A-9611-E77C2E442524@gmail.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-08_09:2020-12-08,2020-12-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 impostorscore=0 malwarescore=0 priorityscore=1501
 suspectscore=0 adultscore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012080084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 8 Dec 2020 04:48:09 -0800
Nadav Amit <nadav.amit@gmail.com> wrote:

[...]

> >> And other VM-entry failures, which are not easy to debug,
> >> especially on bare-metal. =20
> >=20
> > so you are running the test on bare metal?
> >=20
> > that is something I had not tested =20
>=20
> Base-metal / VMware.
>=20
> >  =20
> >> Note that the failing test is not new, and unfortunately these
> >> kind of errors (wrong assumption that memory is zeroed) are not
> >> rare, since KVM indeed zeroes the memory (unlike other hypervisors
> >> and bare-metal).
> >>=20
> >> The previous allocator had the behavior of zeroing the memory to =20
> >=20
> > I don't remember such behaviour, but I'll have a look =20
>=20
> See https://www.spinics.net/lists/kvm/msg186474.html

hmmm it seems I had completely missed it, oops

> >  =20
> >> avoid such problems. I would argue that zeroing should be the
> >> default behavior, and if someone wants to have the memory
> >> =E2=80=9Cuntouched=E2=80=9D for a specific test (which one?) he should=
 use an
> >> alternative function for this matter. =20
> >=20
> > probably we need some commandline switches to change the behaviour
> > of the allocator according to the specific needs of each testcase
> >=20
> >=20
> > I'll see what I can do =20
>=20
> I do not think commandline switches are the right way. I think that
> reproducibility requires the memory to always be on a given state

there are some bugs that are only exposed when the memory has never
been touched. zeroing the memory on allocation guarantees that we will
__never__ be able to detect those bugs.

> before the tests begin. There are latent bugs in kvm-unit-tests that

then maybe it's the case to fix those bugs? :)

> are not apparent when the memory is zeroed. I do not think anyone
> wants to waste time on resolving these bugs.

I disagree. if a unit test has a bug, it should be fixed.

some tests apparently need the allocator to clear the memory, while
other tests depend on the memory being untouched. this is clearly
impossible to solve without some kind of switch


I would like to know what the others think about this issue too


Claudio
