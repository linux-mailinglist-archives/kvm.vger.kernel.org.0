Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2252DE3E6
	for <lists+kvm@lfdr.de>; Fri, 18 Dec 2020 15:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgLROU1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Dec 2020 09:20:27 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48908 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727830AbgLROU0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Dec 2020 09:20:26 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BIE2pYI040283
        for <kvm@vger.kernel.org>; Fri, 18 Dec 2020 09:19:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=QUeRdHWHzZcRrr1qrA/8U0sbWTBi1I2zJpm5JOInSpM=;
 b=kYcayr1h/DM4w4JU2vYMKy1GMjrD6vNn6XbHWmiF8Xvb6D1LFaoAwEUmrTpKDd3rB0gc
 u0SkOoDXDlJHkGlDVRT7ckA3S/o6tl3ZzdubB48iEDOW+NdJIAnMI9vmorNjhSQqVzpx
 d5MdsO/UWyb1f1a8lZO7iNWYvf198sVx+c3E8+o116aUMXudNuHhY2BXMASIRosSBhtq
 h0Rt74nFjdB3DRL+rr97kpQoPfMH0UpuftXtvcnE2b2z6/QvVWna+gK906JaU30BkFWb
 MkWnX/dlTnzLDD1iIo+OKDL4HR/dweUm4HifE25f/QWJRgtsadd5tC9pmTjqUVHHq4XP JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35gvpttk0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 18 Dec 2020 09:19:45 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BIE3CV1042706
        for <kvm@vger.kernel.org>; Fri, 18 Dec 2020 09:19:44 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35gvpttjyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Dec 2020 09:19:44 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BIEJ3Qh032273;
        Fri, 18 Dec 2020 14:19:42 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 35cng8hg6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Dec 2020 14:19:42 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BIEJePE16056792
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Dec 2020 14:19:40 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 920BA11C04C;
        Fri, 18 Dec 2020 14:19:40 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34D2611C04A;
        Fri, 18 Dec 2020 14:19:40 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.12.102])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 18 Dec 2020 14:19:40 +0000 (GMT)
Date:   Fri, 18 Dec 2020 15:19:37 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, cohuck@redhat.com,
        lvivier@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 00/12] Fix and improve the page
 allocator
Message-ID: <20201218151937.715bf26f@ibm-vm>
In-Reply-To: <8A03C81A-BE59-4C1F-8056-94364C79933B@gmail.com>
References: <20201216201200.255172-1-imbrenda@linux.ibm.com>
        <8A03C81A-BE59-4C1F-8056-94364C79933B@gmail.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-18_09:2020-12-18,2020-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 mlxscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012180095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 17 Dec 2020 11:41:05 -0800
Nadav Amit <nadav.amit@gmail.com> wrote:

> > On Dec 16, 2020, at 12:11 PM, Claudio Imbrenda
> > <imbrenda@linux.ibm.com> wrote:
> >=20
> > My previous patchseries was rushed and not polished enough.
> > Furthermore it introduced some regressions.
> >=20
> > This patchseries fixes hopefully all the issues reported, and
> > introduces some new features.
> >=20
> > It also simplifies the code and hopefully makes it more readable.
> >=20
> > Fixed:
> > * allocated memory is now zeroed by default =20
>=20
> Thanks for doing that. Before I test it, did you also fix the issue
> of x86=E2=80=99s setup_vm() [1]?
>=20
> [1] https://www.spinics.net/lists/kvm/msg230470.html

unfortunately no, because I could not reproduce it.

In theory setup_vm should just work, since it is called twice, but on
different address ranges.

The only issue I can think of is if the second call overlaps multiple
areas.

can you send me the memory map of that machine you're running the tests
on? (/proc/iomem)


Claudio
