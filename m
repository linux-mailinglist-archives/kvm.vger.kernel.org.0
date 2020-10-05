Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDA52830A2
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 09:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbgJEHKf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 03:10:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27780 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725898AbgJEHKf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Oct 2020 03:10:35 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09574mLF013093
        for <kvm@vger.kernel.org>; Mon, 5 Oct 2020 03:10:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=bOfCFyoKcQnuibXblJ27RGw3TI7utJHX2qrt/+v9PXE=;
 b=BoU7yYgmQGCBCi1P2OKklclhDJx2OLhF3ix5xFWqGQpN/jP6gP9MbXFxtqVBJIHKM0pu
 5MS2e9kbD/8Fis+ggN266ejIYkMuFm3UYZ1Eu1zEFQixC5qfq9sn2LVxwCuze3sI0ieK
 jXJnnwlqcrvtvCudoUNKbn/tG+dx5SksPhwom3KQ5Bkk98ArIhXypNXwiTpAwWEr02mq
 1UCqRxn7gwk0i67qUSWwfIPIWGTOGe1ZcDu84eUrlsPCD97d40h2N+EQF0UWq7nqV9jb
 oBMVbb/eDF89Jvyb4tN3ToeS7cGhHYe0liCc14T/w3JaeKY7GgHc1Lsup+af4K7oxfBT 7g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33yx5u14bc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 05 Oct 2020 03:10:35 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09575Lag015262
        for <kvm@vger.kernel.org>; Mon, 5 Oct 2020 03:10:34 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33yx5u14a9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Oct 2020 03:10:34 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09579bGO018644;
        Mon, 5 Oct 2020 07:10:32 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 33xgx7ry0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Oct 2020 07:10:32 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0957ATS219792276
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Oct 2020 07:10:30 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D95BB52063;
        Mon,  5 Oct 2020 07:10:29 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.2.175])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 0633252050;
        Mon,  5 Oct 2020 07:10:28 +0000 (GMT)
Date:   Mon, 5 Oct 2020 09:10:13 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        lvivier@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 3/7] lib/asm: Add definitions of
 memory areas
Message-ID: <20201005091013.2e0b98a9@ibm-vm>
In-Reply-To: <20201003092327.5xl7nzx27o35jqwf@kamzik.brq.redhat.com>
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
        <20201002154420.292134-4-imbrenda@linux.ibm.com>
        <20201003092327.5xl7nzx27o35jqwf@kamzik.brq.redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-05_04:2020-10-02,2020-10-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1011
 suspectscore=0 adultscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010050051
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 3 Oct 2020 11:23:27 +0200
Andrew Jones <drjones@redhat.com> wrote:

[...]

> > diff --git a/lib/asm-generic/memory_areas.h
> > b/lib/asm-generic/memory_areas.h new file mode 100644
> > index 0000000..927baa7
> > --- /dev/null
> > +++ b/lib/asm-generic/memory_areas.h
> > @@ -0,0 +1,11 @@
> > +#ifndef MEMORY_AREAS_H  
> 
> _ASM_GENERIC_MEMORY_AREAS_H_
> 
> > +#define MEMORY_AREAS_H
> > +
> > +#define AREA_NORMAL_PFN 0
> > +#define AREA_NORMAL_NUMBER 0
> > +#define AREA_NORMAL 1
> > +
> > +#define AREA_ANY -1
> > +#define AREA_ANY_NUMBER 0xff  
> 
> Do we really need both a "type number", like AREA_NORMAL, and a
> "number number" (AREA_NORMAL_NUMBER)? Why not just search in the order
> of the type numbers? Or in the reverse order, if that's better? Also,
> would an enum be more appropriate for the type numbers?

you understood the reason later on, but also consider that enums cannot
be extended and they need to be arch dependent, and not always have all
the elements.
 
> > +
> > +#endif
> > diff --git a/lib/arm/asm/memory_areas.h b/lib/arm/asm/memory_areas.h
> > new file mode 100644
> > index 0000000..927baa7
> > --- /dev/null
> > +++ b/lib/arm/asm/memory_areas.h
> > @@ -0,0 +1,11 @@
> > +#ifndef MEMORY_AREAS_H  
> 
> _ASMARM_MEMORY_AREAS_H_
> 
> We certainly don't want the same define as the generic file, as it's
> possible an arch will want to simply extend the generic code, e.g.
> 
>  #ifndef _ASMARM_MEMORY_AREAS_H_
>  #define _ASMARM_MEMORY_AREAS_H_
>  #include #include <asm-generic/memory_areas.h>

I see now, I guess if an arch is fine with the generic version it can
include it instead of redefining it.

I'll fix the defines and the names

>  /* ARM memory area stuff here */
> 
>  #endif
> 
> This comment applies to the rest of memory_areas.h files. Look at
> other lib/$ARCH/asm/*.h files to get the define prefix.
> 
> > +#define MEMORY_AREAS_H
> > +
> > +#define AREA_NORMAL_PFN 0
> > +#define AREA_NORMAL_NUMBER 0
> > +#define AREA_NORMAL 1
> > +
> > +#define AREA_ANY -1
> > +#define AREA_ANY_NUMBER 0xff
> > +
> > +#endif  
> [...]
> > diff --git a/lib/s390x/asm/memory_areas.h
> > b/lib/s390x/asm/memory_areas.h new file mode 100644
> > index 0000000..4856a27
> > --- /dev/null
> > +++ b/lib/s390x/asm/memory_areas.h
> > @@ -0,0 +1,17 @@
> > +#ifndef MEMORY_AREAS_H
> > +#define MEMORY_AREAS_H
> > +
> > +#define AREA_NORMAL_PFN BIT(31-12)  
> 
> BIT(31 - PAGE_SHIFT)
> 
> > +#define AREA_NORMAL_NUMBER 0
> > +#define AREA_NORMAL 1
> > +
> > +#define AREA_LOW_PFN 0
> > +#define AREA_LOW_NUMBER 1
> > +#define AREA_LOW 2
> > +
> > +#define AREA_ANY -1
> > +#define AREA_ANY_NUMBER 0xff
> > +
> > +#define AREA_DMA31 AREA_LOW  
> 
> I don't work on s390x, but I'd rather not add too many aliases. I
> think a single name with the min and max address bits embedded in it
> is probably best. Maybe something like AREA_0_31 and AREA_31_52, or
> whatever.

the aliases are arch-specific and are just to make the life easier, you
could just always use the generic macros.

the generic macros, by the way, need to be generic because they are
used in common code, and there we can't have arch-specific names

> > +
> > +#endif
> > diff --git a/lib/x86/asm/memory_areas.h b/lib/x86/asm/memory_areas.h
> > new file mode 100644
> > index 0000000..d704df3
> > --- /dev/null
> > +++ b/lib/x86/asm/memory_areas.h
> > @@ -0,0 +1,22 @@
> > +#ifndef MEMORY_AREAS_H
> > +#define MEMORY_AREAS_H
> > +
> > +#define AREA_NORMAL_PFN BIT(32-12)
> > +#define AREA_NORMAL_NUMBER 0
> > +#define AREA_NORMAL 1
> > +
> > +#define AREA_LOW_PFN BIT(24-12)
> > +#define AREA_LOW_NUMBER 1
> > +#define AREA_LOW 2
> > +
> > +#define AREA_LOWEST_PFN 0
> > +#define AREA_LOWEST_NUMBER 2
> > +#define AREA_LOWEST 4
> > +
> > +#define AREA_DMA24 AREA_LOWEST
> > +#define AREA_DMA32 (AREA_LOWEST | AREA_LOW)  
> 
> Aha, now I finally see that there's a type number and a number number
> because the type number is a bit, presumably for some flag field
> that's coming in a later patch. I'll have to look at the other

I will fix the patch description to make it clear

> patches to see how that's used, but at the moment I feel like there
> should be another way to represent memory areas without requiring a
> handful of defines and aliases for each one.

I think this is the most straightforward way, even though it might not
necessarily look very clean, but... suggestions welcome :)

> Thanks,
> drew
> 
> > +
> > +#define AREA_ANY -1
> > +#define AREA_ANY_NUMBER 0xff
> > +
> > +#endif
> > -- 
> > 2.26.2
> >   
> 

