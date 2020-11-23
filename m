Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE992C11B4
	for <lists+kvm@lfdr.de>; Mon, 23 Nov 2020 18:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387978AbgKWRPt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Nov 2020 12:15:49 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39676 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732295AbgKWRPt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Nov 2020 12:15:49 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ANH4LRp014476;
        Mon, 23 Nov 2020 12:15:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=THMpAouGIjleJboEsMLVa9YthvobYJGUhZDsdxouUvk=;
 b=A160ecPJFRFonzQQZm5evAXAIvdHGCZenWKhwhMIbmor2/UIguvjv1Bk7Y23IfcKjkgR
 uKvy1wQnqei7BpQV1O3DB0YSCNiWHDGSHW8WbxB63Wrc31DMPrWA/w/LB7pqmvH4b7Lo
 9Jhz75wF8dbicjfK40wTO0K6GgJZMtx6XIP2bo+0r303IpNINWLSEEfYWyZuMpjhTeyV
 L37j8gfeYS+fm64uv6TMiCJj0hP9JsZN0KE56Q6fRrjy1KXYPRKYE9UHEUr6NIoearZy
 CZCanuegwFeMyf9fgUYpOZjwl2E+vYkYcEbfTk/zBYRrCpUT8lYxabWFnyUUqAoFRGQw HA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34yvnrxbte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Nov 2020 12:15:48 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0ANHEaSR038489;
        Mon, 23 Nov 2020 12:15:48 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34yvnrxbsj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Nov 2020 12:15:48 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ANH82T1010128;
        Mon, 23 Nov 2020 17:15:46 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 34xth8arf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Nov 2020 17:15:46 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ANHFhUM62128554
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Nov 2020 17:15:44 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD4BA11C052;
        Mon, 23 Nov 2020 17:15:43 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64BCF11C054;
        Mon, 23 Nov 2020 17:15:43 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.54.238])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 23 Nov 2020 17:15:43 +0000 (GMT)
Subject: Re: [PATCH 0/2] KVM: s390: memcg awareness
To:     Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>
References: <20201117151023.424575-1-borntraeger@de.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <ef538cd6-b82f-0773-3848-f3b5232e7412@de.ibm.com>
Date:   Mon, 23 Nov 2020 18:15:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201117151023.424575-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_14:2020-11-23,2020-11-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 mlxlogscore=958 spamscore=0 suspectscore=0 priorityscore=1501
 malwarescore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011230114
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 17.11.20 16:10, Christian Borntraeger wrote:
> This got somehow lost.  (so this is kind of a v2)
> KVM does have memcg awareness. Lets implement this also for s390kvm
> and gmap.
> 
> Christian Borntraeger (2):
>   KVM: s390: Add memcg accounting to KVM allocations
>   s390/gmap: make gmap memcg aware

both applied.
> 
>  arch/s390/kvm/guestdbg.c  |  8 ++++----
>  arch/s390/kvm/intercept.c |  2 +-
>  arch/s390/kvm/interrupt.c | 10 +++++-----
>  arch/s390/kvm/kvm-s390.c  | 20 ++++++++++----------
>  arch/s390/kvm/priv.c      |  4 ++--
>  arch/s390/kvm/pv.c        |  6 +++---
>  arch/s390/kvm/vsie.c      |  4 ++--
>  arch/s390/mm/gmap.c       | 30 +++++++++++++++---------------
>  8 files changed, 42 insertions(+), 42 deletions(-)
> 
