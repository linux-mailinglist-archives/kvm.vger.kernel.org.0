Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8A1A2D2744
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 10:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728505AbgLHJP7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 04:15:59 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12260 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725874AbgLHJP7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Dec 2020 04:15:59 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B892k1a106883
        for <kvm@vger.kernel.org>; Tue, 8 Dec 2020 04:15:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=cyvnV95lRsj1iStzuOYCgYRDddmZc3F5HdT5Wr3e8zQ=;
 b=MrmMPQebxQTAaiNbMMvMESBdQeDFrnyT9T6IUGzaB9tgRiTQbXclDGAVAyBkDcvj23s1
 mFwCPTo7xY8ZQRkwLZjs7m24AaOHl5PAobnb+WdLJIqCypwXMQEggSSHtHyfRvXJpThh
 6O9Ee4us/8/+TQ/Epi2i5IJx5otT7TKnuO32hhTOdgPlzNidH0QYm7WCBM0C5QrYzfHe
 SdOfxaOOYaV1OpWY9J7jqg10LVGK0aQlMRPXwVnhrOEId5rTQLTIHdTBvmYgqJjqlGTb
 yqPfchSMocKDW66PDZbLeousfn6qZSoHJEpZr1SCfd0f3VnwG+tC5IoFHWIsGSYUyCn7 4A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 359wwk586f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 04:15:17 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B893EJf109147
        for <kvm@vger.kernel.org>; Tue, 8 Dec 2020 04:15:17 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 359wwk5859-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 04:15:17 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B899T3A009425;
        Tue, 8 Dec 2020 09:15:15 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3583svka0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 09:15:15 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B89FDHD9110154
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Dec 2020 09:15:13 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BC35AE056;
        Tue,  8 Dec 2020 09:15:13 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB176AE053;
        Tue,  8 Dec 2020 09:15:12 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.11.93])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Dec 2020 09:15:12 +0000 (GMT)
Date:   Tue, 8 Dec 2020 10:15:10 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     KVM <kvm@vger.kernel.org>, pbonzini@redhat.com,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, lvivier@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 4/7] lib/alloc_page: complete rewrite
 of the page allocator
Message-ID: <20201208101510.4e3866dc@ibm-vm>
In-Reply-To: <11863F45-D4E5-4192-9541-EC4D26AC3634@gmail.com>
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
        <20201002154420.292134-5-imbrenda@linux.ibm.com>
        <C812A718-DCD6-4485-BB5A-B24DE73A0FD3@gmail.com>
        <11863F45-D4E5-4192-9541-EC4D26AC3634@gmail.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-08_03:2020-12-04,2020-12-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 phishscore=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 mlxlogscore=999 bulkscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012080054
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 7 Dec 2020 17:10:13 -0800
Nadav Amit <nadav.amit@gmail.com> wrote:

> > On Dec 7, 2020, at 4:41 PM, Nadav Amit <nadav.amit@gmail.com> wrote:
> >   
> >> On Oct 2, 2020, at 8:44 AM, Claudio Imbrenda
> >> <imbrenda@linux.ibm.com> wrote:
> >> 
> >> This is a complete rewrite of the page allocator.  
> > 
> > This patch causes me crashes:
> > 
> >  lib/alloc_page.c:433: assert failed: !(areas_mask & BIT(n))
> > 
> > It appears that two areas are registered on AREA_LOW_NUMBER, as
> > setup_vm() can call (and calls on my system) page_alloc_init_area()
> > twice.
> > 
> > setup_vm() uses AREA_ANY_NUMBER as the area number argument but
> > eventually this means, according to the code, that
> > __page_alloc_init_area() would use AREA_LOW_NUMBER.
> > 
> > I do not understand the rationale behind these areas well enough to
> > fix it.  
> 
> One more thing: I changed the previous allocator to zero any
> allocated page. Without it, I get strange failures when I do not run
> the tests on KVM, which are presumably caused by some intentional or
> unintentional hidden assumption of kvm-unit-tests that the memory is
> zeroed.
> 
> Can you restore this behavior? I can also send this one-line fix, but
> I do not want to overstep on your (hopeful) fix for the previous
> problem that I mentioned (AREA_ANY_NUMBER).

no. Some tests depend on the fact that the memory is being touched for
the first time.

if your test depends on memory being zeroed on allocation, maybe you
can zero the memory yourself in the test?

otherwise I can try adding a function to explicitly allocate a zeroed
page.


Claudio
