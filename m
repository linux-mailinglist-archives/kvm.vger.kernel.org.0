Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 777EC3EB2E6
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 10:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239794AbhHMIvN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 04:51:13 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38696 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239436AbhHMIvL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 04:51:11 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17D8bdL5158679;
        Fri, 13 Aug 2021 04:50:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=daps2HX7OeqSUTV3IyxELntCzp6KYQnXl+ftLRxcwIo=;
 b=C+Pvs4adhDYDQvByZA295nYqETA3rEcA2W8f8uW16dLbTJx2QhbyL+4a8uHUAS9VmvxH
 kx9wfxO3LjNf73EyKNY8wfrZE+jb4fiY1fI4ejyw7ipH90iBQ9VOC50qW8WhLKYNp3Nh
 MGksDp5QfVBdKS14L99/ZmJsvIayiqzo4W2SLvs+a/cAT8aRgUOp04UKPvv1tvFSN/Dy
 CjHYdWPtiA+cgCJ4OhhNQzx/53XJ0R9dqcFrUIMej9QWao5X0QMs0RnwxqmtQZVx2RJu
 EebFiRlNFhSNa4CdJ9rU+tJizN4j523/i0S8+2Q9RfM6kHrFPYpQU3M8Z/+ptvvzW0Ia 0w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ad3k4kkny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 04:50:44 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17D8cGk0161349;
        Fri, 13 Aug 2021 04:50:44 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ad3k4kkn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 04:50:44 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17D8kUwJ011483;
        Fri, 13 Aug 2021 08:50:42 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3ada8sgp56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 08:50:42 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17D8oecg55247162
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 08:50:40 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2196C52074;
        Fri, 13 Aug 2021 08:50:40 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.9.6])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id E5C895204F;
        Fri, 13 Aug 2021 08:50:39 +0000 (GMT)
Date:   Fri, 13 Aug 2021 10:50:25 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH 8/8] lib: s390x: uv: Add rc 0x100 query
 error handling
Message-ID: <20210813105025.4eeada04@p-imbrenda>
In-Reply-To: <20210813073615.32837-9-frankja@linux.ibm.com>
References: <20210813073615.32837-1-frankja@linux.ibm.com>
        <20210813073615.32837-9-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: W80harrZQzPt7-DXWqyffRiHQEjzUII1
X-Proofpoint-GUID: eM5cFzepz9SR8zyc4D5PKgs2GbUQcTFn
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-13_01:2021-08-12,2021-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 clxscore=1015 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 13 Aug 2021 07:36:15 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Let's not get bitten by an extension of the query struct and handle
> the rc 0x100 error properly which does indicate that the UV has more
> data for us.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/uv.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
> index fd9de944..c5c69c47 100644
> --- a/lib/s390x/uv.c
> +++ b/lib/s390x/uv.c
> @@ -49,6 +49,8 @@ int uv_setup(void)
>  	if (!test_facility(158))
>  		return 0;
>  
> -	assert(!uv_call(0, (u64)&uvcb_qui));
> +	uv_call(0, (u64)&uvcb_qui);
> +
> +	assert(uvcb_qui.header.rc == 1 || uvcb_qui.header.rc ==
> 0x100); return 1;
>  }

