Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C75A39872A
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 12:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232341AbhFBK4i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 06:56:38 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31048 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232068AbhFBK4G (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Jun 2021 06:56:06 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 152AX07O015501;
        Wed, 2 Jun 2021 06:54:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=rrQmKGq7zPkkI9h7rd4kiOv62439d9gDRPCcKqHmypo=;
 b=eRzP+BmPfJ7Z/WkjzCKTi2bNLL3SGX8tUxKI9FaLc9x8uEYt6dRp8zAwFS/gngB8Du5y
 Y7cQBmOoh4Qm0at6cAEWCDEcz16mU1S/NcH+16lboFMo+73+xVJ2wDZ8IH+Jp1hJ0im2
 adxMLFREnR79STOkQzgaKq9uyNbMh6XrBSa3EVBKr7mitEOtAQANshQwqbDeVTUTBFVg
 24i2JLNz+ieQHam3wk8SxtMojwDc89q1MNmuhVKDagfvBXaarGIS6xvyYNfreCA6eznv
 wn6fOqXfw6fPVJMoGYFOmRpl/7kMgpj2lH+bwYWc/yyu4z1fMICfmDg73v0HSBAKh/I0 5w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38x5kr58xt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Jun 2021 06:54:23 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 152AXtWT017835;
        Wed, 2 Jun 2021 06:54:23 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38x5kr58x7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Jun 2021 06:54:23 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 152AsIxU030435;
        Wed, 2 Jun 2021 10:54:21 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 38ud88a8yp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Jun 2021 10:54:20 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 152AsI7m14746066
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Jun 2021 10:54:18 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB57A11C04C;
        Wed,  2 Jun 2021 10:54:18 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5FF4211C054;
        Wed,  2 Jun 2021 10:54:18 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.2.225])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  2 Jun 2021 10:54:18 +0000 (GMT)
Date:   Wed, 2 Jun 2021 12:54:16 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, thuth@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH] s390x: sie: Only overwrite r3 if it
 isn't needed anymore
Message-ID: <20210602125416.392d0868@ibm-vm>
In-Reply-To: <539ca61d-eaf8-f47f-c7ce-d5a520273517@redhat.com>
References: <20210602094352.11647-1-frankja@linux.ibm.com>
        <539ca61d-eaf8-f47f-c7ce-d5a520273517@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: h2jlIm8wGyAmHE2ud1SP51YpTM4tijJV
X-Proofpoint-ORIG-GUID: clawCgMDBgmIyN3dO-YE4_1plLi_p1Kd
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-02_06:2021-06-02,2021-06-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 spamscore=0 priorityscore=1501 bulkscore=0 phishscore=0
 mlxscore=0 clxscore=1015 adultscore=0 suspectscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106020067
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2 Jun 2021 11:47:12 +0200
David Hildenbrand <david@redhat.com> wrote:

> On 02.06.21 11:43, Janosch Frank wrote:
> > The lmg overwrites r3 which we later use to reference the fprs and
> > fpc. Let's do the lmg at the end where overwriting is fine.
> > 
> > Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> > ---
> > 
> > Finding this took me longer than I'd like to admit. :)
> > 
> > ---
> >   s390x/cpu.S | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/s390x/cpu.S b/s390x/cpu.S
> > index e2ad56c8..82b5e25d 100644
> > --- a/s390x/cpu.S
> > +++ b/s390x/cpu.S
> > @@ -81,11 +81,11 @@ sie64a:
> >   	stg	%r3,__SF_SIE_SAVEAREA(%r15)	# save
> > guest register save area 
> >   	# Load guest's gprs, fprs and fpc
> > -	lmg	%r0,%r13,SIE_SAVEAREA_GUEST_GRS(%r3)
> >   	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
> >   	ld	\i, \i * 8 + SIE_SAVEAREA_GUEST_FPRS(%r3)
> >   	.endr
> >   	lfpc	SIE_SAVEAREA_GUEST_FPC(%r3)
> > +	lmg	%r0,%r13,SIE_SAVEAREA_GUEST_GRS(%r3)
> >   
> >   	# Move scb ptr into r14 for the sie instruction
> >   	lg	%r14,__SF_SIE_CONTROL(%r15)
> >   
> 
> Oh, that's nasty
> 
> Reviewed-by: David Hildenbrand <david@redhat.com>
> 

