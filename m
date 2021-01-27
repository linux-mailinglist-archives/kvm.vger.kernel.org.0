Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6300B305BAC
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 13:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343587AbhA0Mkt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 07:40:49 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23282 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343624AbhA0Mii (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Jan 2021 07:38:38 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10RCXaSA020755;
        Wed, 27 Jan 2021 07:37:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=DeDCa39cZZm+ACgRqgRQb6hsLIon4qWKk8UK9NduwRU=;
 b=r4JE6/+/p0TON+XOLz2EWHo94VjbIlcO/xaSatrsz9OopshhuEQudsOBcFXUEeZK2qef
 +oJsizeHEeNsIdZe2yMxO+HpP4MWTGwuJWZSNSwd/BGnwwcJZIdeZiddMlZxwIQMnVAu
 6IeVJ2hJuDqzUSLe/gBJLx33SYJptnfuvG4v+NeZcMe9mehUJ9M7LOOnMKcWtZBrNLXa
 8tYf+g5SfXtZg+JxTgFRWKu0bt298ayaG3VJZ/Svg90XN+y5rDuBAM7STtDH8S2J3nIZ
 DZ6HdiOJp+aFiOO4awbY3H+pUAC7BRQmyrlKDhXmrmErAydQSPfiO5bHBQ5Mp7lh8Acp Hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36b1cubgby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jan 2021 07:37:57 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10RCXlcH021641;
        Wed, 27 Jan 2021 07:37:57 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36b1cubgay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jan 2021 07:37:57 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10RCXo6N021924;
        Wed, 27 Jan 2021 12:37:54 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 368be81yd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jan 2021 12:37:54 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10RCbpa739452978
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 12:37:51 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8A6352051;
        Wed, 27 Jan 2021 12:37:51 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.86.87])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 3E17D52054;
        Wed, 27 Jan 2021 12:37:51 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v5 0/3] s390x: css: pv: css test adaptation
 for PV
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com, drjones@redhat.com,
        pbonzini@redhat.com
References: <1611322060-1972-1-git-send-email-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <6c141deb-819a-ef03-f44c-bd61561a2087@linux.ibm.com>
Date:   Wed, 27 Jan 2021 13:37:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1611322060-1972-1-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-27_05:2021-01-27,2021-01-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 spamscore=0 bulkscore=0 clxscore=1015 impostorscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101270067
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/22/21 2:27 PM, Pierre Morel wrote:
> Hi all,
>   
> To adapt the CSS I/O tests to protected virtualisation we need
> utilities to: 
> 
> 1- allocate the I/O buffers in a private page using (patch 2)
>    It must be in a dedicated page to avoid exporting code or
>    guest private data to the host.
>    We accept a size in byte and flags and allocate page integral
>    memory to handle the Protected Virtualization.
>  
> 2- share the I/O buffers with the host (patch 1)
>    This patch uses the page allocator reworked by Claudio.
>  
> The 2 first patches are the implementation of the tools,
> patch 3 is the modification of the css.c test for PV.
> 
> The checkpatch always asked me to modify MAINTAINERS,
> so I added me as reviewer to be in copy for CSS at least.
> May be we could create a finer grain MAINTAINERS in the
> future.
> 
> regards,
> Pierre

Thanks, picked.


> 
> 
> Pierre Morel (3):
>   s390x: pv: implement routine to share/unshare memory
>   s390x: define UV compatible I/O allocation
>   s390x: css: pv: css test adaptation for PV
> 
>  lib/s390x/asm/uv.h    | 39 ++++++++++++++++++++++++
>  lib/s390x/css.h       |  3 +-
>  lib/s390x/css_lib.c   | 28 +++++------------
>  lib/s390x/malloc_io.c | 71 +++++++++++++++++++++++++++++++++++++++++++
>  lib/s390x/malloc_io.h | 45 +++++++++++++++++++++++++++
>  s390x/Makefile        |  1 +
>  s390x/css.c           | 43 ++++++++++++++++++--------
>  7 files changed, 196 insertions(+), 34 deletions(-)
>  create mode 100644 lib/s390x/malloc_io.c
>  create mode 100644 lib/s390x/malloc_io.h
> 

