Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB9444E3A8
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 10:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234742AbhKLJNr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 04:13:47 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5136 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234732AbhKLJNr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Nov 2021 04:13:47 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AC8BlYM031674
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 09:10:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=A5kV0HxRhPm0UDZQ3RZmZQR89FvFC7+pP83oiXZchrk=;
 b=hyHs+dKFhCRPq0DZ+8TgrRgAU9LCzSTz1akVs4uhujBGktv2IyWapxse2Fq9hlbWlzy7
 Td6Q0HPKw+F0pcW8foU2jiFuRXGqEGkyh0hetUZf540Sk7lWVqUQARtdcZn8x/eeFKgo
 9XmAjBLYiA70GQQBZaiKZ/2BZty3UNhFpbFC3oT6ovMNKWQttqIAmBvYQrsoFnxrqKuJ
 mC0J0hRTADjim0xe8ccGp2YdTw9JQ7B3+aJgl3L0rr4PQy6CpXZLxUh5AAopC4JBLW2d
 nBA/zKTWnmdQAkj6+NntWUTSKPYilBCJuxnxIAQpVL/TY0S6adFCUSzR6+cTBHoMlqFG Lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c9kasaa5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 09:10:56 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AC8usN6025446
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 09:10:56 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c9kasaa55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Nov 2021 09:10:56 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AC97Oea011556;
        Fri, 12 Nov 2021 09:10:53 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3c5hbakeg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Nov 2021 09:10:53 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AC9AoaI40894952
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Nov 2021 09:10:50 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8841D11C066;
        Fri, 12 Nov 2021 09:10:50 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30AF211C05E;
        Fri, 12 Nov 2021 09:10:50 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.6.198])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 12 Nov 2021 09:10:50 +0000 (GMT)
Date:   Fri, 12 Nov 2021 10:10:47 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH] s390x: io: declare s390x CPU as big
 endian
Message-ID: <20211112101047.55fbca87@p-imbrenda>
In-Reply-To: <6b28a9e3-6129-0202-fb2c-6398c3363f28@redhat.com>
References: <20211111184835.113648-1-pmorel@linux.ibm.com>
        <6b28a9e3-6129-0202-fb2c-6398c3363f28@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 022ztnap7JCcauGe51QYEMZXHT2j2SkK
X-Proofpoint-GUID: 2m3GG2J3L1ooasa_NXs6gExdYjRpJ4zI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-12_03,2021-11-11_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111120050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 Nov 2021 08:38:38 +0100
Thomas Huth <thuth@redhat.com> wrote:

> On 11/11/2021 19.48, Pierre Morel wrote:
> > To use the swap byte transformations we need to declare
> > the s390x architecture as big endian.
> > 
> > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > ---
> >   lib/s390x/asm/io.h | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git a/lib/s390x/asm/io.h b/lib/s390x/asm/io.h
> > index 1dc6283b..b5e661cf 100644
> > --- a/lib/s390x/asm/io.h
> > +++ b/lib/s390x/asm/io.h
> > @@ -10,6 +10,7 @@
> >   #define _ASMS390X_IO_H_
> >   
> >   #define __iomem
> > +#define __cpu_is_be() (1)
> >   
> >   #include <asm-generic/io.h>
> >   
> >   
> 
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> 
> Alternatively, I think you could also move this sequence from 
> lib/ppc64/asm/io.h into lib/asm-generic/io.h:
> 
> #if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
> #define __cpu_is_be() (0)
> #elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
> #define __cpu_is_be() (1)
> #else
> #error Undefined byte order
> #endif
> 
> (replacing the hardcoded __cpu_is_be() in the generic code).
> 
>   Thomas

I think this looks cleaner

