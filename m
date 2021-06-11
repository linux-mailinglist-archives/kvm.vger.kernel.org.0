Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4023A3DF5
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 10:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbhFKI0A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 04:26:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53506 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231180AbhFKIZ6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Jun 2021 04:25:58 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15B83O4M150107;
        Fri, 11 Jun 2021 04:23:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=83Vmmdclr1Jg/D+7BzdpWoc8MKMZeu3kYzCb2+tqcDQ=;
 b=GxDy2KBmMgJgcDbb+O5fNnPSGUON8xCMrDvVf6uoDQ1RlQU3bKGni9edx3dGEb47Y9h6
 Wr8CZlbSRmvuSlRGrHmo83KyssJw0cWTCUVVN2oLVOJUibMuEfyfbQg4i9KceJfg6QIs
 UF5zBC6BJJiyPlo2geWIbzNIr7W21XJDf1/uB2O8cHzY2NsRGwwmnOMnHvic2oPBNFom
 EfWBQVYmrol7ZXutn8CRZFazL3FVGXYq+H3mAI2YG/a7FXLvCfhrg+UfIDDE+kR2JUbl
 Nw8I6l+cGGCk5gJvYLBdScg1ZEHvSfaZRSOjVh1Gk+1TVgyGXnCdzk8EVTlpbfJRnKPd xg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3943ys8ggp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 04:23:42 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15B83jY4151018;
        Fri, 11 Jun 2021 04:23:41 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3943ys8gft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 04:23:41 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15B8FhQL008759;
        Fri, 11 Jun 2021 08:23:39 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 392e798vnk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 08:23:39 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15B8McLC31457698
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 08:22:38 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 112AE5205F;
        Fri, 11 Jun 2021 08:23:33 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.5.240])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5E6E352057;
        Fri, 11 Jun 2021 08:23:32 +0000 (GMT)
Date:   Fri, 11 Jun 2021 10:23:30 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, david@redhat.com,
        linux-mm@kvack.org, Nicholas Piggin <npiggin@gmail.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 1/2] mm/vmalloc: add vmalloc_no_huge
Message-ID: <20210611102330.17701bad@ibm-vm>
In-Reply-To: <20210610140909.781959d063608710e24e70c9@linux-foundation.org>
References: <20210610154220.529122-1-imbrenda@linux.ibm.com>
        <20210610154220.529122-2-imbrenda@linux.ibm.com>
        <20210610140909.781959d063608710e24e70c9@linux-foundation.org>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RlvbrGdC0VlhrvDxDD-SdLs5JOvmRIdv
X-Proofpoint-GUID: W-7tZ1fiYAyc8Fu1j3OYcXEnLXp1kKu0
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-11_01:2021-06-11,2021-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 mlxscore=0 phishscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 suspectscore=0 clxscore=1015 adultscore=0
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106110052
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 10 Jun 2021 14:09:09 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 10 Jun 2021 17:42:19 +0200 Claudio Imbrenda
> <imbrenda@linux.ibm.com> wrote:
> 
> > The recent patches to add support for hugepage vmalloc mappings

I will put the proper commit ID here

> > added a flag for __vmalloc_node_range to allow to request small

and the name of the flag here

> > pages. This flag is not accessible when calling vmalloc, the only

and improve the wording in general ("order-0 pages" instead of "small
pages")

> > option is to call directly __vmalloc_node_range, which is not
> > exported.  
> 
> I can find no patch which adds such a flag to __vmalloc_node_range(). 
> I assume you're referring to "mm/vmalloc: switch to bulk allocator in
> __vmalloc_area_node()"?
> 
> Please be quite specific when identifying patches.  More specific than
> "the recent patches"!

sorry!

I was referring to this one: 
121e6f3258fe393e22c36f61a ("mm/vmalloc: hugepage vmalloc mappings")

which introduces the flag VM_NO_HUGE_VMAP

I will reword the commit to be more specific

> Also, it appears from the discussion at
> https://lkml.kernel.org/r/YKUWKFyLdqTYliwu@infradead.org that we'll be
> seeing a new version of "mm/vmalloc: switch to bulk allocator in
> __vmalloc_area_node()".  Would it be better to build these s390 fixes
> into the next version of that patch series rather than as a separate
> followup thing?
> 

