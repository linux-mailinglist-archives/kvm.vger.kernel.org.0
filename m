Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4021A49F6C1
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 10:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237726AbiA1J6l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 04:58:41 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41494 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235548AbiA1J6h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Jan 2022 04:58:37 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20S86BbO031426;
        Fri, 28 Jan 2022 09:58:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=yhdL9N2soqv4N1HFgAid2X+6VLCsOstuI+G3kythJ10=;
 b=AEbffWfOBYcqYHFOzRzyyQUlpB6V1xHP6QNVjCkT8NtTZHPsXBz2llo9nkUsBywxWACx
 XG4nDqj0t+TNtdV0SACKblDq2N4ICLWCF8NyrAyPYm44qFHDotZ+MGKQwmSRKuooSH4W
 DBZxu5Oz5gQTGKx1Fe4ku7puPl0C0EzfLzG6XbqKp+fExXfemBW7V1TmGSlpuUXy5y3f
 dncGPW2LT6YKgIc7JXLo9U+Me/SBc+y4T9ieacHFJvf9VIMMTU3GKT7oqMJGfnOIX7ql
 w8SEg4ghMV11AUCsPN/zbRvO9g3keO1iOl/lq0BRhPUpE1JauLWSjzq6NU8t/yf1KhHP cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dv5rb890d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jan 2022 09:58:37 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20S9QLf8003784;
        Fri, 28 Jan 2022 09:58:37 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dv5rb88yx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jan 2022 09:58:37 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20S9vF0N029244;
        Fri, 28 Jan 2022 09:58:34 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3dr9ja5dc5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jan 2022 09:58:34 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20S9wUQE29163914
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jan 2022 09:58:30 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 025C9AE05F;
        Fri, 28 Jan 2022 09:58:30 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C11CAE055;
        Fri, 28 Jan 2022 09:58:29 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.7.17])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 28 Jan 2022 09:58:29 +0000 (GMT)
Date:   Fri, 28 Jan 2022 10:58:26 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Steffen Eiden <seiden@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 1/4] s390x: uv-host: Add attestation test
Message-ID: <20220128105826.731e617e@p-imbrenda>
In-Reply-To: <5ba3d0d1-ca47-2511-9e7d-2d0da26aa179@redhat.com>
References: <20220127141559.35250-1-seiden@linux.ibm.com>
        <20220127141559.35250-2-seiden@linux.ibm.com>
        <a11c343b-16e6-727c-dbec-1edfe5375fcf@linux.ibm.com>
        <5ba3d0d1-ca47-2511-9e7d-2d0da26aa179@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QOO4Kn5v1HwybuEBUA4CennYL7wCZ18M
X-Proofpoint-ORIG-GUID: cGH0ntRsJz1oHrJGV6iOVOvRi7_sgNLH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-28_01,2022-01-27_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201280058
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 28 Jan 2022 10:29:42 +0100
Thomas Huth <thuth@redhat.com> wrote:

> On 28/01/2022 10.00, Janosch Frank wrote:
> > On 1/27/22 15:15, Steffen Eiden wrote: =20
> >> Adds an invalid command test for attestation in the uv-host.
> >>
> >> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com> =20
> >=20
> > Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> >  =20
> >> ---
> >> =C2=A0 lib/s390x/asm/uv.h | 24 +++++++++++++++++++++++-
> >> =C2=A0 s390x/uv-host.c=C2=A0=C2=A0=C2=A0 |=C2=A0 3 ++-
> >> =C2=A0 2 files changed, 25 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
> >> index 97c90e81..38c322bf 100644
> >> --- a/lib/s390x/asm/uv.h
> >> +++ b/lib/s390x/asm/uv.h
> >> @@ -1,10 +1,11 @@
> >> =C2=A0 /*
> >> =C2=A0=C2=A0 * s390x Ultravisor related definitions
> >> =C2=A0=C2=A0 *
> >> - * Copyright (c) 2020 IBM Corp
> >> + * Copyright (c) 2020, 2022 IBM Corp =20
> >=20
> > I'm not sure when we actually need/want to update this. =20
>=20
> IANAL, but IIRC you can add/update the second year in the copyright=20
> statement if there has been a major change to the file in that year, so t=
hat=20
> should be fine. Not sure whether you still need the "(c)" these days, tho=
ugh.
>=20
>   Thomas
>=20

I think the format IBM wants is:

Copyright IBM Corp. 2020, 2022

