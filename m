Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA606283899
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 16:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbgJEO70 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 10:59:26 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64050 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726562AbgJEO7Z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Oct 2020 10:59:25 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 095EiLNv014920
        for <kvm@vger.kernel.org>; Mon, 5 Oct 2020 10:59:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=GWNYiu6I8+987D9u5X+0YZsTIL/furQ2zcuiM+7A6fA=;
 b=Go9oDtnRvxcoBLn8R8g99IJmOO2e/Q3O1dLK/CJ3PFckFwTnWYmbhfMcphnZyQI0m43d
 2aFPXjYmsQcPj0jpachF5qLdm37UvP/JaWYYUvgusDa1zzB+ut9zdpsOTILiyPFfAV40
 SN9ywD0djfxhNy2J7E4h0V1MJf33wFaDPBds8P0rvQylcuRu+Vc75FsKEtWuumZOldzZ
 pIPHx39/qlHpjx+bz1oM3E34xIRLqddZGxBDkX+tBdXowLBmRa6YGa7/bqgV9IiSWtHD
 guChQ791bIX1VLS6QaylC+y4QsJaQscdLk7c2fdg9JPrzDCmdcDCpOZ5nXqOjUdVqCUT nQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3405gw0fdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 05 Oct 2020 10:59:24 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 095EiR2V015438
        for <kvm@vger.kernel.org>; Mon, 5 Oct 2020 10:59:24 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3405gw0fcx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Oct 2020 10:59:24 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 095ExEvC014588;
        Mon, 5 Oct 2020 14:59:21 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 33xgjh29mf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Oct 2020 14:59:21 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 095ExIFW26804600
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Oct 2020 14:59:19 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF61D5205F;
        Mon,  5 Oct 2020 14:59:18 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.2.175])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 342E452050;
        Mon,  5 Oct 2020 14:59:18 +0000 (GMT)
Date:   Mon, 5 Oct 2020 16:59:16 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        lvivier@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 0/7] Rewrite the allocators
Message-ID: <20201005165916.56849a13@ibm-vm>
In-Reply-To: <ceff99e4-e79c-2d92-fb02-f5a020da3ff1@linux.ibm.com>
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
        <aec4a269-efba-83c0-cbbb-c78b132b1fa9@linux.ibm.com>
        <20201005143503.669922f5@ibm-vm>
        <ceff99e4-e79c-2d92-fb02-f5a020da3ff1@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-05_10:2020-10-05,2020-10-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 clxscore=1015 malwarescore=0 phishscore=0 mlxscore=0
 impostorscore=0 suspectscore=0 mlxlogscore=316 lowpriorityscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010050110
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 5 Oct 2020 14:57:15 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 2020-10-05 14:35, Claudio Imbrenda wrote:
> > On Mon, 5 Oct 2020 13:54:42 +0200
> > Pierre Morel <pmorel@linux.ibm.com> wrote:
> > 
> > [...]
> >   
> >> While doing a page allocator, the topology is not the only
> >> characteristic we may need to specify.
> >> Specific page characteristics like rights, access flags, cache
> >> behavior may be useful when testing I/O for some architectures.
> >> This obviously will need some connection to the MMU handling.
> >>
> >> Wouldn't it be interesting to use a bitmap flag as argument to
> >> page_alloc() to define separate regions, even if the connection
> >> with the MMU is done in a future series?  
> > 
> > the physical allocator is only concerned with the physical pages. if
> > you need special MMU flags to be set, then you should enable the MMU
> > and fiddle with the flags and settings yourself.
> >   
> 
> AFAIU the page_allocator() works on virtual addresses if the MMU has 
> been initialized.

no, it still works on physical addresses, which happen to be identity
mapped by the MMU. don't forget that the page tables are
themselves allocated with the page allocator. 

> Considering that more and more tests will enable the MMU by default, 
> eventually with a simple logical mapping, it seems to me that having
> the possibility to give the page allocator more information about the
> page access configuration could be interesting.

I disagree.

I think we should not violate the layering here.

> I find that using two different interfaces, both related to memory 
> handling, to have a proper memory configuration for an I/O page may
> be complicated without some way to link page allocator and MMU tables
> together.

If you want to allocate an identity mapped page and also change its
properties at the same time, you can always write a wrapper.

keep the page allocator working only on physical addresses, add a
function to change the properties of the mapping, and add a wrapper
for the two.



