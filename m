Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99FAE2E9870
	for <lists+kvm@lfdr.de>; Mon,  4 Jan 2021 16:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbhADPZI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jan 2021 10:25:08 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40092 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727225AbhADPZE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Jan 2021 10:25:04 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 104F3IYa143915;
        Mon, 4 Jan 2021 10:24:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=gEHb6A/vGOso8qmb0RuqpTlFlNl4dVy8LYFVBRDNSyI=;
 b=lq+sC8ndCpsWAwK/33wKQqEodjv5O/cKkbBIAuX2zVlPV83/gzNVe/nlbLvXrw0ccJc0
 c9c/lzy2m+8G+W2tSWuoiKykEH0aH3C3t8BRGYctPqp4plVpaBxvCBJXJ2rjYmQZwPT0
 oob+UbIU/duyPyXPDH2G7u/Zui8ntbVkrEHS+Sd+J72NDVJH/5gxluVaUk1h4ZfwpANl
 GxTr7krxuaML+rRhr6d0yCstxCt3Qsaxv8IaHe0jwGnSVlsyYw+QlTDudIsgdW0FuoH6
 ldHEi3TNZS+abHP7ZBbBjeGnxh7HxtiLAbDXoCa+heIvhOpp1nbk7HFZ3LdF+zK43s+Q 0Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35v59krmu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jan 2021 10:24:23 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 104FLm8P047683;
        Mon, 4 Jan 2021 10:24:22 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35v59krmtc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jan 2021 10:24:22 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 104FCGJ1004432;
        Mon, 4 Jan 2021 15:24:21 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 35tgf8a03r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jan 2021 15:24:20 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 104FOIuR40436112
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Jan 2021 15:24:18 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05B73A405B;
        Mon,  4 Jan 2021 15:24:18 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA061A4054;
        Mon,  4 Jan 2021 15:24:17 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.0.177])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  4 Jan 2021 15:24:17 +0000 (GMT)
Date:   Mon, 4 Jan 2021 16:23:57 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 0/4] s390/kvm: fix MVPG when in VSIE
Message-ID: <20210104162357.6b85baf0@ibm-vm>
In-Reply-To: <5947ede7-7f9f-cdaa-b827-75a5715e4f12@redhat.com>
References: <20201218141811.310267-1-imbrenda@linux.ibm.com>
 <5947ede7-7f9f-cdaa-b827-75a5715e4f12@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-04_10:2021-01-04,2021-01-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0 impostorscore=0
 clxscore=1015 mlxlogscore=932 priorityscore=1501 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101040099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 20 Dec 2020 10:40:27 +0100
David Hildenbrand <david@redhat.com> wrote:

> On 18.12.20 15:18, Claudio Imbrenda wrote:
> > The current handling of the MVPG instruction when executed in a
> > nested guest is wrong, and can lead to the nested guest hanging. =20
>=20
> Hi,
>=20
> thanks for spotting and debugging! Is this related to nested guests
> hanging while migrating (mentioned by Janosch at some point)?

no, it was found by running legacy tests in VSIE (I have written
kvm-unit-tests for this now, I'll post them Soon=E2=84=A2)

> Or can this not be reproduced with actual Linux guests?

Linux doesn't use MVPG, and gcc in general seems to avoid it, so we
never really see this in the wild. Moreover Linux does not normally run
with DAT disabled.
=20
> Thanks!
>=20
> >=20
> > This patchset fixes the behaviour to be more architecturally
> > correct, and fixes the hangs observed.
> >=20
> > Claudio Imbrenda (4):
> >   s390/kvm: VSIE: stop leaking host addresses
> >   s390/kvm: extend guest_translate for MVPG interpretation
> >   s390/kvm: add kvm_s390_vsie_mvpg_check needed for VSIE MVPG
> >   s390/kvm: VSIE: correctly handle MVPG when in VSIE
> >=20
> >  arch/s390/kvm/gaccess.c | 88
> > ++++++++++++++++++++++++++++++++++++++--- arch/s390/kvm/gaccess.h |
> >  3 ++ arch/s390/kvm/vsie.c    | 78
> > +++++++++++++++++++++++++++++++++--- 3 files changed, 159
> > insertions(+), 10 deletions(-)=20
>=20
>=20

