Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48E2F2FECA1
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 15:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729886AbhAUOGP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 09:06:15 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46004 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732475AbhAUNf1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 08:35:27 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10LDVobo013764
        for <kvm@vger.kernel.org>; Thu, 21 Jan 2021 08:34:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=9kmPu2CtBWScVzoI16TmICuoSEldq76KPDy9nzgDmFs=;
 b=DPF9rvGOsQfJkFprr3TWke59sCUDKma8ebFQRKi8DbFGXNDfqjO8MbfqoYSv6zQHzM71
 DK593Nr+/fcKkWwiMZa70+RpBUb++8KU5kyHWELVlAmuzICFPOC7W66cnSqIbScCyIvC
 z5GhVU9bqw3j800/ImHaVukOKhRttw8IdOMBi82U3YU7v+xGzUH7CrSgxviZ/dGZThDs
 O60njL2Q7Jz0Mq3at/08hxeFqT5Bz8+3DbH5cV0P3Jb5aWx2kQleNI3eG7S2j+pyqT89
 DWOsyl5EkDusGY9ItD5xc656pPhsNmzzAWO6OvYZ02R6bz4wgudT6dFsKiMHvlQ8L7GD FQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3679y1958b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 21 Jan 2021 08:34:43 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10LDWNmZ015728
        for <kvm@vger.kernel.org>; Thu, 21 Jan 2021 08:34:12 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3679y194qs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 08:34:12 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10LDVZuA021426;
        Thu, 21 Jan 2021 13:33:37 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3668paspja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 13:33:37 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10LDXSbq34603344
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 13:33:28 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBDAF11C04A;
        Thu, 21 Jan 2021 13:33:34 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9690D11C05B;
        Thu, 21 Jan 2021 13:33:34 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.165.35])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jan 2021 13:33:34 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH] lib/s390x/sclp: Clarify that the CPUEntry
 array could be at a different spot
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>, cohuck@redhat.com
References: <20210121065703.561444-1-thuth@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <7b7a7dd6-c21e-95dd-b251-277316caafd8@linux.ibm.com>
Date:   Thu, 21 Jan 2021 14:33:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210121065703.561444-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_06:2021-01-21,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 suspectscore=0 phishscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 spamscore=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101210070
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/21/21 7:57 AM, Thomas Huth wrote:
> The "struct CPUEntry entries[0]" in the ReadInfo structure is misleading
> since the entries could be add a completely different spot. Replace it
> by a proper comment instead.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Thanks, picked.
I'll fix up Conny's comment.

> ---
>  lib/s390x/sclp.h | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
> index 9f81c0f..8523133 100644
> --- a/lib/s390x/sclp.h
> +++ b/lib/s390x/sclp.h
> @@ -131,10 +131,15 @@ typedef struct ReadInfo {
>  	uint16_t highest_cpu;
>  	uint8_t  _reserved5[124 - 122];     /* 122-123 */
>  	uint32_t hmfai;
> -	uint8_t reserved7[134 - 128];
> +	uint8_t reserved7[134 - 128];       /* 128-133 */
>  	uint8_t byte_134_diag318 : 1;
>  	uint8_t : 7;
> -	struct CPUEntry entries[0];
> +	/*
> +	 * At the end of the ReadInfo, there are also the CPU entries (see
> +	 * struct CPUEntry). When the Extended-Length SCCB (ELS) feature is
> +	 * enabled, the start of the CPU entries array begins at an offset
> +	 * denoted by the offset_cpu field, otherwise it's at offset 128.
> +	 */
>  } __attribute__((packed)) ReadInfo;
>  
>  typedef struct ReadCpuInfo {
> 

