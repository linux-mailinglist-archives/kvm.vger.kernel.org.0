Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640B82D2739
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 10:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728732AbgLHJMp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 04:12:45 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64190 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726418AbgLHJMp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Dec 2020 04:12:45 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B892j9O106833
        for <kvm@vger.kernel.org>; Tue, 8 Dec 2020 04:12:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=3dE+1osCOrGF6GufbVXamYuQI9+/ZoOq0+2Hu43PU/I=;
 b=cFFjlhYttLN8RujzpXL9r3bN6P7lPO9nyo8wcH94jPs/+tG+I3H/zjwhiA7Da74GZwI0
 UdUU4wbNc74nTIMXH/oYjcpFezt1C0xZW12COvAYd3CN0zr7gXwHSTuFulF5CZG8i+E+
 y0Z2H+XEYIppXGosV0TTyb7lobzDmeXwyMjPc+dyWH+lpI4vanmkZoXstZXEtnyZX1NX
 Jswta0+4ibMo45z1QsiHtM7fkMfWlDDzFEZKUFEF2CXI4KSHC1QVZ15aRuK4yGrkIBEm
 hZKTrfLIzJXNdleXkA44g4bwAQHCDXMUE+o/GzHQ413u//CvwPCzzBmZ9l3PjiNehixV Kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 359wwk5591-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 04:12:03 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B893EJK109147
        for <kvm@vger.kernel.org>; Tue, 8 Dec 2020 04:12:03 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 359wwk558f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 04:12:03 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B898Uug008910;
        Tue, 8 Dec 2020 09:12:01 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3583svk9wk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 09:12:01 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B89BxvH9044624
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Dec 2020 09:11:59 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E23552052;
        Tue,  8 Dec 2020 09:11:59 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.11.93])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9530F5204E;
        Tue,  8 Dec 2020 09:11:58 +0000 (GMT)
Date:   Tue, 8 Dec 2020 10:11:55 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     KVM <kvm@vger.kernel.org>, pbonzini@redhat.com,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, lvivier@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 4/7] lib/alloc_page: complete rewrite
 of the page allocator
Message-ID: <20201208101155.0e2de3c9@ibm-vm>
In-Reply-To: <C812A718-DCD6-4485-BB5A-B24DE73A0FD3@gmail.com>
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
        <20201002154420.292134-5-imbrenda@linux.ibm.com>
        <C812A718-DCD6-4485-BB5A-B24DE73A0FD3@gmail.com>
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

On Mon, 7 Dec 2020 16:41:18 -0800
Nadav Amit <nadav.amit@gmail.com> wrote:

> > On Oct 2, 2020, at 8:44 AM, Claudio Imbrenda
> > <imbrenda@linux.ibm.com> wrote:
> > 
> > This is a complete rewrite of the page allocator.  
> 
> This patch causes me crashes:
> 
>   lib/alloc_page.c:433: assert failed: !(areas_mask & BIT(n))
> 
> It appears that two areas are registered on AREA_LOW_NUMBER, as
> setup_vm() can call (and calls on my system) page_alloc_init_area()
> twice.

which system is that? page_alloc_init_area should not be called twice
on the same area!

> setup_vm() uses AREA_ANY_NUMBER as the area number argument but
> eventually this means, according to the code, that
> __page_alloc_init_area() would use AREA_LOW_NUMBER.
> 
> I do not understand the rationale behind these areas well enough to
> fix it.

I'll see what I can fix


Claudio
