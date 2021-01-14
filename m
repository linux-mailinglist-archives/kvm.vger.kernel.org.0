Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023192F635F
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 15:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbhANOqY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 09:46:24 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28068 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726244AbhANOqY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 09:46:24 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10EEXVCh041264;
        Thu, 14 Jan 2021 09:45:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=dlbhnJ1ipQ+U96JP0EEQQSS1xoHbUmUcZ1V+In/deEM=;
 b=nYcBkyQWPIa0J1D3+6Vud7LJMxhp1PQwnkF4aSw7wpPcjccLyKv133RP9MJYT9Y60aMz
 vrB6BCP6FBvwq89Dgj4Ks2cRxxkRbUK4x+aI0tuC6Cm04DQSCYpOe5Y71sr/Z7YrOmOm
 6bGjLTNrZfqYsDoT1xv9J4WPsU04dD3nuKn+88j+tiBD0Z5nz8OM1gMaL8SelTmCzq85
 +htqlAbxMFmA0AxnZdH9XEm25xkhA4CIiPaxCKNWPN9OA3ffuROdfCioXZIAJ87jY8u0
 YfJZ49fup2KKgl+DFjYXTCcA2T4FiU71jAiq4LctqwOK/RTJMuUD0PBd1Wu6AoIZZZ5q dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 362qa51fvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 09:45:43 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10EEYlCq045718;
        Thu, 14 Jan 2021 09:45:42 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 362qa51fus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 09:45:42 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10EENu2R024477;
        Thu, 14 Jan 2021 14:45:40 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3604h9ane6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 14:45:40 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10EEjb0I45220340
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 14:45:37 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29A04AE04D;
        Thu, 14 Jan 2021 14:45:37 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6CA8AE051;
        Thu, 14 Jan 2021 14:45:36 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.11.88])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Jan 2021 14:45:36 +0000 (GMT)
Date:   Thu, 14 Jan 2021 15:45:25 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v4 9/9] s390x: sclp: Add CPU entry offset
 comment
Message-ID: <20210114154525.2dcdb1d6@ibm-vm>
In-Reply-To: <20210112132054.49756-10-frankja@linux.ibm.com>
References: <20210112132054.49756-1-frankja@linux.ibm.com>
        <20210112132054.49756-10-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-14_05:2021-01-14,2021-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 phishscore=0 adultscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101140085
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 12 Jan 2021 08:20:54 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> Let's make it clear that there is something at the end of the
> struct. The exact offset is reported by the cpu_offset member.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/sclp.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
> index dccbaa8..395895f 100644
> --- a/lib/s390x/sclp.h
> +++ b/lib/s390x/sclp.h
> @@ -134,7 +134,10 @@ typedef struct ReadInfo {
>  	uint8_t reserved7[134 - 128];
>  	uint8_t byte_134_diag318 : 1;
>  	uint8_t : 7;
> -	struct CPUEntry entries[0];
> +	/*
> +	 * The cpu entries follow, they start at the offset specified
> +	 * in offset_cpu.
> +	 */
>  } __attribute__((packed)) ReadInfo;
>  
>  typedef struct ReadCpuInfo {

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
