Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A135363C6E
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 09:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237703AbhDSHZb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 03:25:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34504 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233438AbhDSHZa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Apr 2021 03:25:30 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13J740UY168843;
        Mon, 19 Apr 2021 03:25:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Z2lqCQ2nC6ztIFBvex876zxe1MEvnh4yqlyLU90Qljc=;
 b=fPPumg2W5buGHZxuz3ca1Pt/jibSOt9TLyDm0G5TEXACPl/fDpV/pHiIsjukY5LOvZK1
 344Ecz/27kpNFoq72Rv9gj5SYjhbB9EK0o2WFyAboldJQeiAXf12UTkfaRUB7+JlIKGw
 PZ88teoevGfSgHhO2gsVbebDMvYfvRWxWWFMeZAQu7JU9C6LfHHlkdhMl7QZG+SOW45/
 ey5H/VjbCpP5OdX74kv3CZeOUefBB6o+Iw6LMl5IW6QIKXdOrf3QQO1fJJLFJGa9MHuh
 vHfZJUF/gENIK5EM7Z87EgwlKL0z5zAOhUodbKuLQLXcgNJr3N9ZvMa/OIfXVtxpHE+F 8g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 380d6uf2de-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Apr 2021 03:25:01 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13J74HEo169851;
        Mon, 19 Apr 2021 03:25:00 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 380d6uf2cp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Apr 2021 03:25:00 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13J7NcnO008647;
        Mon, 19 Apr 2021 07:24:58 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 37yt2rruh9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Apr 2021 07:24:58 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13J7OucP38273506
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Apr 2021 07:24:56 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E9A6CA4062;
        Mon, 19 Apr 2021 07:24:55 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9CCEEA4060;
        Mon, 19 Apr 2021 07:24:55 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.181.252])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 19 Apr 2021 07:24:55 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 0/6] s390x: uv: Extend guest test and add
 host test
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        imbrenda@linux.ibm.com
References: <20210316091654.1646-1-frankja@linux.ibm.com>
Message-ID: <1902b36d-2a8a-202f-5790-4b41910c254a@linux.ibm.com>
Date:   Mon, 19 Apr 2021 09:24:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210316091654.1646-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Tw79SI1HKGGRm0hVKczet4iqWlUGuH4U
X-Proofpoint-ORIG-GUID: cMmgRUpJ4SQ8a7X26bt1m7aHcasYuqsB
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-19_02:2021-04-16,2021-04-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0
 clxscore=1015 phishscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104190046
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/16/21 10:16 AM, Janosch Frank wrote:
> My stack of patches is starting to lean, so lets try to put some of
> them upstream...
> 
> The first part is just additions to the UV guest test and a library
> that makes checking the installed UV calls easier. Additionally we now
> check for the proper UV share/unshare availability when allocating IO
> memory instead of only relying on stfle 158.
> 
> The second part adds a UV host test with a large number UV of return
> code checks. This is currently a guest 1 test.

Ping

> 
> Janosch Frank (6):
>   s390x: uv-guest: Add invalid share location test
>   s390x: Add more Ultravisor command structure definitions
>   s390x: uv: Add UV lib
>   s390x: Test for share/unshare call support before using them
>   s390x: uv-guest: Test invalid commands
>   s390x: Add UV host test
> 
>  lib/s390x/asm/uv.h    | 152 ++++++++++++-
>  lib/s390x/io.c        |   2 +
>  lib/s390x/malloc_io.c |   5 +-
>  lib/s390x/uv.c        |  48 ++++
>  lib/s390x/uv.h        |  10 +
>  s390x/Makefile        |   2 +
>  s390x/uv-guest.c      |  57 ++++-
>  s390x/uv-host.c       | 513 ++++++++++++++++++++++++++++++++++++++++++
>  8 files changed, 776 insertions(+), 13 deletions(-)
>  create mode 100644 lib/s390x/uv.c
>  create mode 100644 lib/s390x/uv.h
>  create mode 100644 s390x/uv-host.c
> 

