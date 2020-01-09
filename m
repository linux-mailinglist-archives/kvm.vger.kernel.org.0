Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D05E135EB1
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 17:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731524AbgAIQug (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 11:50:36 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41116 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728967AbgAIQug (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 11:50:36 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 009GgM6Z049438
        for <kvm@vger.kernel.org>; Thu, 9 Jan 2020 11:50:35 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xe5rxdkm8-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 11:50:35 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Thu, 9 Jan 2020 16:50:33 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 9 Jan 2020 16:50:30 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 009GoTx828836190
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Jan 2020 16:50:29 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F04FA404D;
        Thu,  9 Jan 2020 16:50:29 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C87DFA4053;
        Thu,  9 Jan 2020 16:50:28 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.108])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Jan 2020 16:50:28 +0000 (GMT)
Date:   Thu, 9 Jan 2020 17:50:27 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v6 3/4] s390x: lib: add SPX and STPX
 instruction wrapper
In-Reply-To: <5c6f563e-3d09-5274-b050-a64122097e9b@redhat.com>
References: <20200109161625.154894-1-imbrenda@linux.ibm.com>
        <20200109161625.154894-4-imbrenda@linux.ibm.com>
        <5c6f563e-3d09-5274-b050-a64122097e9b@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20010916-0008-0000-0000-00000347FF39
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20010916-0009-0000-0000-00004A6846B5
Message-Id: <20200109175027.362d8440@p-imbrenda>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-09_03:2020-01-09,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 adultscore=0 phishscore=0 spamscore=0
 suspectscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001090141
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 9 Jan 2020 17:43:55 +0100
Thomas Huth <thuth@redhat.com> wrote:

> On 09/01/2020 17.16, Claudio Imbrenda wrote:
> > Add a wrapper for the SET PREFIX and STORE PREFIX instructions, and
> > use it instead of using inline assembly everywhere.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >  lib/s390x/asm/arch_def.h | 10 ++++++++++
> >  s390x/intercept.c        | 33 +++++++++++++--------------------
> >  2 files changed, 23 insertions(+), 20 deletions(-)
> > 
> > diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> > index 1a5e3c6..465fe0f 100644
> > --- a/lib/s390x/asm/arch_def.h
> > +++ b/lib/s390x/asm/arch_def.h
> > @@ -284,4 +284,14 @@ static inline int servc(uint32_t command,
> > unsigned long sccb) return cc;
> >  }
> >  
> > +static inline void spx(uint32_t *new_prefix)  
> 
> Looking at this a second time ... why is new_prefix a pointer? A
> normal value should be sufficient here, shouldn't it?

no. if you look at the code in the same patch, intercept.c at some
points needs to pass "wrong" pointers to spx and stpx in order to test
them, so this needs to be a pointer

the instructions themselves expect pointers (base register + offset)

> > +{
> > +	asm volatile("spx %0" : : "Q" (*new_prefix) : "memory");
> > +}
> > +
> > +static inline void stpx(uint32_t *current_prefix)
> > +{
> > +	asm volatile("stpx %0" : "=Q" (*current_prefix));
> > +}
> > +  
> 
>  Thomas
> 

