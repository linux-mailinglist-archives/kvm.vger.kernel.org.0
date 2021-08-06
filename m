Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E853E275E
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 11:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244580AbhHFJfW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 05:35:22 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9040 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244577AbhHFJfR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Aug 2021 05:35:17 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1769YgMP158552;
        Fri, 6 Aug 2021 05:35:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=aUcefrzkrYz0ZcIvnGfbtkRlOzysSOwwJX2QvrLaM/k=;
 b=NwEibv2xkNUkj3PmePECZ3QFmYn0gED4y3b/b+NQFJPIENIxXF53EJdqNcrtJUnsZ9GT
 BeQSNTGxH6//RZyuuuLjLtfYx0qRXF6p+48BmydTpOLJSsU5a1Pg7s3o/Cf/c7YqRV4I
 mXjGg14U+RcYzHC5rzXsD+Wk0JHAR5QJjInKObRgKl3VdrYlGTk2B6vSj8QBLa4b5DBT
 FaB9Dnojt5F2Zqd+xs9WY/pM3KjdBhFPhGs51Rgkj5Vo8+UDkMCTLcCk1tR6Pg8Dok93
 B2Ubgo89GdWj03JQL+eqapTHu2vWXjc9IllPFcy4WSjps/gXMhh169aFVhve5j5YdJwy lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a89fng1nx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Aug 2021 05:35:01 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1769YqrV159113;
        Fri, 6 Aug 2021 05:35:01 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a89fng1n2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Aug 2021 05:35:00 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1769VrnH010504;
        Fri, 6 Aug 2021 09:34:58 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3a4x58umca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Aug 2021 09:34:58 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1769VpBe43319664
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Aug 2021 09:31:51 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33E604204C;
        Fri,  6 Aug 2021 09:34:54 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BCA0B42047;
        Fri,  6 Aug 2021 09:34:53 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.6.208])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 Aug 2021 09:34:53 +0000 (GMT)
Date:   Fri, 6 Aug 2021 11:34:37 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com
Subject: Re: [PATCH v3 01/14] KVM: s390: pv: add macros for UVC CC values
Message-ID: <20210806113437.61e8fbc3@p-imbrenda>
In-Reply-To: <f3fc81a7-ea71-56f6-16e0-e43fc36d646e@redhat.com>
References: <20210804154046.88552-1-imbrenda@linux.ibm.com>
        <20210804154046.88552-2-imbrenda@linux.ibm.com>
        <f3fc81a7-ea71-56f6-16e0-e43fc36d646e@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Dldh5D8FpS_llf3UAUz6GF-1o_3Hzcuz
X-Proofpoint-GUID: XvZaou8h4LY5cwOOVOQVjPWrZpNvXAV5
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-06_02:2021-08-05,2021-08-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 adultscore=0 malwarescore=0
 impostorscore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108060067
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 6 Aug 2021 09:26:11 +0200
David Hildenbrand <david@redhat.com> wrote:

> On 04.08.21 17:40, Claudio Imbrenda wrote:
> > Add macros to describe the 4 possible CC values returned by the UVC
> > instruction.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >   arch/s390/include/asm/uv.h | 5 +++++
> >   1 file changed, 5 insertions(+)
> > 
> > diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> > index 12c5f006c136..b35add51b967 100644
> > --- a/arch/s390/include/asm/uv.h
> > +++ b/arch/s390/include/asm/uv.h
> > @@ -18,6 +18,11 @@
> >   #include <asm/page.h>
> >   #include <asm/gmap.h>
> >   
> > +#define UVC_CC_OK	0
> > +#define UVC_CC_ERROR	1
> > +#define UVC_CC_BUSY 	2
> > +#define UVC_CC_PARTIAL	3
> > +
> >   #define UVC_RC_EXECUTED		0x0001
> >   #define UVC_RC_INV_CMD		0x0002
> >   #define UVC_RC_INV_STATE	0x0003
> >   
> 
> Do we have any users we could directly fix up? AFAIKs, most users
> don't really care about the cc value, only about cc vs !cc.

maybe there will be in the future.

I wanted to split away this generic change from the patch that uses it,
to improve readability

> The only instances I was able to spot quickly:
> 
> 
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index 12c5f006c136..dd72d325f9e8 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -233,7 +233,7 @@ static inline int uv_call(unsigned long r1,
> unsigned long r2)
> 
>          do {
>                  cc = __uv_call(r1, r2);
> -       } while (cc > 1);
> +       } while (cc >= UVC_CC_BUSY);
>          return cc;
>   }
> 
> @@ -245,7 +245,7 @@ static inline int uv_call_sched(unsigned long r1, 
> unsigned long r2)
>          do {
>                  cc = __uv_call(r1, r2);
>                  cond_resched();
> -       } while (cc > 1);
> +       } while (cc >= UVC_CC_BUSY);
>          return cc;
>   }
> 
> 
> Of course, we could replace all checks for cc vs !cc with "cc != 
> UVC_CC_OK" vs "cc == UVC_CC_OK".
> 

