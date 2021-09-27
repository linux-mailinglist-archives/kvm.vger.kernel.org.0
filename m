Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E09419051
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 10:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbhI0IDk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 04:03:40 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36382 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233242AbhI0IC6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Sep 2021 04:02:58 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18R6kTx8022991
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 04:00:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=PNd9OQoBTBfkGF/txWrF3Y/PS5qizVyuGjkEaYuf13E=;
 b=r+ZXD8gbozMIhE/nI5qnfzaaxY5vAu5FKojmRKKP49XQNvfALnA2LMDqQqpFsQXU0Uz/
 /rhTVLplcNAtaqFtHsUxzdlGWRxBF8kftPtRRslmwUvZ0Pf92yKeu3CqhHbUmC43tUr6
 eAlfiKXni0oYY8jA5eo3V9PSHwAyTWijWhx3atDXsZ5pOax3MV3k9thUY43F1VJ5ECcV
 LpIrSTdcsl3ztTxelcr4Cd7o/cHv+pgoVdA8BHKu59XllKUymQEnuB2huCNinc11p+qi
 mBnonDoSd4qOEGzD1rbkrCSzpdRrjRktNJJ/pnRFeGUhokyma6Alwn2eFShnEvmpHJcZ Cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3baguanrft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 04:00:57 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18R5jCJk008170
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 04:00:57 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3baguanrbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 04:00:57 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18R7vC5Q024093;
        Mon, 27 Sep 2021 08:00:47 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3b9u1j26kb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 08:00:47 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18R7tfr227459972
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Sep 2021 07:55:42 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A46B1AE074;
        Mon, 27 Sep 2021 08:00:42 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D5F7AE053;
        Mon, 27 Sep 2021 08:00:42 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.159.107])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Sep 2021 08:00:42 +0000 (GMT)
Subject: Re: [PATCH kvm-unit-tests] MAINTAINERS: add S lines
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>
References: <20210923114814.229844-1-pbonzini@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <ea922e07-bacd-350b-4a8e-898444f25ee8@linux.ibm.com>
Date:   Mon, 27 Sep 2021 10:00:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210923114814.229844-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dt4Hw1NdqDvzOrppHHNB7c2-BtDppSY4
X-Proofpoint-GUID: PxxHpEz2bVhRxXN7PMo0QOoVH1Jemf1y
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-27_02,2021-09-24_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2109270055
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/23/21 1:48 PM, Paolo Bonzini wrote:
> Mark PPC as maintained since it is a bit more stagnant than the rest.
> 
> Everything else is supported---strange but true.
> 
> Cc: Laurent Vivier <lvivier@redhat.com>
> Cc: Thomas Huth <thuth@redhat.com>
> Cc: Janosch Frank <frankja@linux.ibm.com>
> Cc: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Acked-by: Janosch Frank <frankja@linux.ibm.com>

Is there a reason why we suddenly want to add this i.e. is that
indication used by anyone right now?

> ---
>  MAINTAINERS | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 89b21c2..4fc01a5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -56,6 +56,7 @@ Maintainers
>  M: Paolo Bonzini <pbonzini@redhat.com>
>  M: Thomas Huth <thuth@redhat.com>
>  M: Andrew Jones <drjones@redhat.com>
> +S: Supported
>  L: kvm@vger.kernel.org
>  T: https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git
>  
> @@ -64,6 +65,7 @@ Architecture Specific Code:
>  
>  ARM
>  M: Andrew Jones <drjones@redhat.com>
> +S: Supported
>  L: kvm@vger.kernel.org
>  L: kvmarm@lists.cs.columbia.edu
>  F: arm/*
> @@ -74,6 +76,7 @@ T: https://gitlab.com/rhdrjones/kvm-unit-tests.git
>  POWERPC
>  M: Laurent Vivier <lvivier@redhat.com>
>  M: Thomas Huth <thuth@redhat.com>
> +S: Maintained
>  L: kvm@vger.kernel.org
>  L: kvm-ppc@vger.kernel.org
>  F: powerpc/*
> @@ -83,6 +86,7 @@ F: lib/ppc64/*
>  S390X
>  M: Thomas Huth <thuth@redhat.com>
>  M: Janosch Frank <frankja@linux.ibm.com>
> +S: Supported
>  R: Cornelia Huck <cohuck@redhat.com>
>  R: Claudio Imbrenda <imbrenda@linux.ibm.com>
>  R: David Hildenbrand <david@redhat.com>
> @@ -93,6 +97,7 @@ F: lib/s390x/*
>  
>  X86
>  M: Paolo Bonzini <pbonzini@redhat.com>
> +S: Supported
>  L: kvm@vger.kernel.org
>  F: x86/*
>  F: lib/x86/*
> 

