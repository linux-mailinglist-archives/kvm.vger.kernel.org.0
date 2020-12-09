Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C297B2D4258
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 13:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731826AbgLIMoD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 07:44:03 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41490 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731770AbgLIMoB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Dec 2020 07:44:01 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B9CffVL025153;
        Wed, 9 Dec 2020 07:43:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TBqu9X2wd1HwUV6NSmhuqToiZ+WkY5yDn4wZENQ6i30=;
 b=ljCF8C82RJk+a/8oIToLasSI+jlBY11zdetslRkAxNtM3K5wVyuX7Ory22lsskW0Osju
 sEdZ+4f4GykoFSGIQTp9iHIY4AKqMFe5SiNtkIY1qNvuGRNnZNbt9Nw0DE+6Xe/caZ/2
 Ydb9/CzN7zRpHYlW9aF4g2bTmnpmDM4ZAOZlaeOMVaosAFHZGtDrXP+wYl1kASqnP37N
 OL/uk781H1I4HBLNeWgWz/h3bjQSuvKntMDZbjvFmpWhZa6JttsXcSLFZNwdEvWp9czT
 gYkQs7SQZDj4BI07mBkERr1FAqVZ2/SH0ngPBm8Yw01gR6E/DjUI/1RMRoIH815EI/3k OQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35axtg00ss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 07:43:19 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B9CgxvI027397;
        Wed, 9 Dec 2020 07:43:18 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35axtg00s4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 07:43:18 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B9CflIh011369;
        Wed, 9 Dec 2020 12:43:16 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3581u84kk3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 12:43:16 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B9ChEuU6750842
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Dec 2020 12:43:14 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35FB042045;
        Wed,  9 Dec 2020 12:43:14 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5F6A42042;
        Wed,  9 Dec 2020 12:43:13 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.56.167])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Dec 2020 12:43:13 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 1/2] s390x: Move to GPL 2 and SPDX license
 identifiers
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
References: <20201208150902.32383-1-frankja@linux.ibm.com>
 <20201208150902.32383-2-frankja@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <414068f0-4bf4-8ccc-a11e-63deb5f01c42@linux.ibm.com>
Date:   Wed, 9 Dec 2020 13:43:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201208150902.32383-2-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-09_09:2020-12-09,2020-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 adultscore=0 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 mlxscore=0 clxscore=1011 spamscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090085
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/8/20 4:09 PM, Janosch Frank wrote:
> In the past we had some issues when developers wanted to use code
> snippets or constants from the kernel in a test or in the library. To
> remedy that the s390x maintainers decided to move all files to GPL
> 2 (if possible).
> 
> At the same time let's move to SPDX identifiers as they are much nicer
> to read.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   s390x/cmm.c       | 4 +---
>   s390x/cpumodel.c  | 4 +---
>   s390x/css.c       | 4 +---
>   s390x/cstart64.S  | 4 +---
>   s390x/diag10.c    | 4 +---
>   s390x/diag288.c   | 4 +---
>   s390x/diag308.c   | 5 +----
>   s390x/emulator.c  | 4 +---
>   s390x/gs.c        | 4 +---
>   s390x/iep.c       | 4 +---
>   s390x/intercept.c | 4 +---
>   s390x/pfmf.c      | 4 +---
>   s390x/sclp.c      | 4 +---
>   s390x/selftest.c  | 4 +---
>   s390x/skey.c      | 4 +---
>   s390x/skrf.c      | 4 +---
>   s390x/smp.c       | 4 +---
>   s390x/sthyi.c     | 4 +---
>   s390x/sthyi.h     | 4 +---
>   s390x/stsi.c      | 4 +---
>   s390x/uv-guest.c  | 4 +---
>   s390x/vector.c    | 4 +---
>   22 files changed, 22 insertions(+), 67 deletions(-)
> 

Acked-by: Pierre Morel <pmorel@linux.ibm.com>


-- 
Pierre Morel
IBM Lab Boeblingen
