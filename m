Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C18F93A1AE7
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 18:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233417AbhFIQap (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 12:30:45 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:19456 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232474AbhFIQao (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 12:30:44 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 159G4B9s046522;
        Wed, 9 Jun 2021 12:28:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=WnAx0fQzqs+a/N+N8UuC7PQXx5fIqDRSZaznkAB0PzM=;
 b=S9mJ8mi8dhsF1tXg9hoT3miyLaieTfVe9+sWU1zvQ3i/Z5AUu/kG6uRJM8QNn4fO+v1t
 8WEl1vPJGv2Un/OrpY2OriIxPIe3M/z9eeEAj2cEjpqQdoqJEkJGnp29r35Y5aVoCRSo
 TUdj+SGyInqoT8hjeMeZs779ZOjlxHH1uYF3IQfd1uM57eRDS11PCA/GcUmxvdX4VjxX
 gB8bG8PF3m001lv0XY+I8S/b9Iceh5EpXKUKiPFUK4/0i5uObBqY9vQ3vLFZuCxY6Hn+
 3nvvQzXcVC+0yVvi+DTf4nDrXSkhrzyRaITDB+9F4cWfIFpbSrXT6gM/SGMFi1mo3cKH lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 392y3amqu8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Jun 2021 12:28:17 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 159G4GDk047015;
        Wed, 9 Jun 2021 12:28:16 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 392y3amqt5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Jun 2021 12:28:16 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 159GSEYX027110;
        Wed, 9 Jun 2021 16:28:14 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3900hhta66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Jun 2021 16:28:14 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 159GSBw915335822
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Jun 2021 16:28:11 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E0BFA405F;
        Wed,  9 Jun 2021 16:28:11 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E091EA4067;
        Wed,  9 Jun 2021 16:28:10 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.5.240])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Jun 2021 16:28:10 +0000 (GMT)
Date:   Wed, 9 Jun 2021 18:28:09 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, david@redhat.com,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v2 1/2] mm/vmalloc: export __vmalloc_node_range
Message-ID: <20210609182809.7ae07aad@ibm-vm>
In-Reply-To: <YMDlVdB8m62AhbB7@infradead.org>
References: <20210608180618.477766-1-imbrenda@linux.ibm.com>
        <20210608180618.477766-2-imbrenda@linux.ibm.com>
        <YMDlVdB8m62AhbB7@infradead.org>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4dArTF9SgWQ2jROyRmRWPKChc48Cpmr7
X-Proofpoint-GUID: cxkj1UJfSeHbYCvHTev4n6QkkZuxq53h
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-09_04:2021-06-04,2021-06-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 adultscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106090078
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 9 Jun 2021 16:59:17 +0100
Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Jun 08, 2021 at 08:06:17PM +0200, Claudio Imbrenda wrote:
> > The recent patches to add support for hugepage vmalloc mappings
> > added a flag for __vmalloc_node_range to allow to request small
> > pages. This flag is not accessible when calling vmalloc, the only
> > option is to call directly __vmalloc_node_range, which is not
> > exported.
> > 
> > This means that a module can't vmalloc memory with small pages.
> > 
> > Case in point: KVM on s390x needs to vmalloc a large area, and it
> > needs to be mapped with small pages, because of a hardware
> > limitation.
> > 
> > This patch exports __vmalloc_node_range so it can be used in modules
> > too.  
> 
> No.  I spent a lot of effort to mak sure such a low-level API is
> not exported.

ok, but then how can we vmalloc memory with small pages from KVM?
