Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1FE3E9424
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 17:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbhHKPAZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 11:00:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55798 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232792AbhHKPAY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Aug 2021 11:00:24 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17BEZ8o6002175;
        Wed, 11 Aug 2021 11:00:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=FrT0iCS+gRfpK35BeZfF9qiK41p33oD1ATbCT8LInn0=;
 b=We/kle1GWeHrl0cPfkQrqADxbvoPwohyIyfwW+fgmhYsoUARNtP3kQ6zUGlMwlhYrVds
 6t/j8/EOyUZ1jZpU5hyxR6mh7ARdYeVj5Xils/kgDFjoNv1h+EoyRGOOHy2qiupEqYee
 HqxAw+fTi9YKLRq41Mx3Sgaxw9zbkg8XEa9YfeuGq6d847HK/1RU6qLaJjAYZYw9He5r
 BWilut5PRE6L94WxJt7JjArrwgVFaLU0perhjYSE2qiQNA8ZD7MaV5GPn97bbb86X+/i
 AdyNxmvV0qALWiLeDHLm+ppsBe65oxM03v70tC15f5TMCzszVV5z7uHUZjS4pclPT05i RA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3abb7q7n9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Aug 2021 11:00:00 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17BEZNfk003668;
        Wed, 11 Aug 2021 10:59:59 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3abb7q7n9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Aug 2021 10:59:59 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17BEvVg1022080;
        Wed, 11 Aug 2021 14:59:57 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3a9ht8qb6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Aug 2021 14:59:57 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17BEugd854460754
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Aug 2021 14:56:42 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0EE1E4C04A;
        Wed, 11 Aug 2021 14:59:54 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB50A4C04E;
        Wed, 11 Aug 2021 14:59:53 +0000 (GMT)
Received: from linux.fritz.box (unknown [9.145.12.48])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 11 Aug 2021 14:59:53 +0000 (GMT)
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     thuth@redhat.com, kvm@vger.kernel.org, cohuck@redhat.com,
        imbrenda@linux.ibm.com, david@redhat.com
References: <1628612544-25130-1-git-send-email-pmorel@linux.ibm.com>
 <1628612544-25130-2-git-send-email-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/4] s390x: lib: Add SCLP toplogy nested
 level
Message-ID: <313172a3-6074-1bc5-f0fc-c48394b6f9bc@linux.ibm.com>
Date:   Wed, 11 Aug 2021 16:59:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1628612544-25130-2-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Xr6zgdKaLklStkW-8TvmCsyCvLO2mM6h
X-Proofpoint-GUID: xKorwRU70yCkYlEXL0SiIfuPh1Oos_qC
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-11_05:2021-08-11,2021-08-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 mlxscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 suspectscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108110098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/10/21 6:22 PM, Pierre Morel wrote:
> The maximum CPU Topology nested level is available with the SCLP
> READ_INFO command inside the byte at offset 15 of the ReadInfo
> structure.
> 
> Let's return this information to check the number of topology nested
> information available with the STSI 15.1.x instruction.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>  lib/s390x/sclp.c | 6 ++++++
>  lib/s390x/sclp.h | 4 +++-
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
> index 9502d161..ee379ddf 100644
> --- a/lib/s390x/sclp.c
> +++ b/lib/s390x/sclp.c
> @@ -123,6 +123,12 @@ int sclp_get_cpu_num(void)
>  	return read_info->entries_cpu;
>  }
>  
> +int sclp_get_stsi_parm(void)
> +{
> +	assert(read_info);
> +	return read_info->stsi_parm;
> +}
> +
>  CPUEntry *sclp_get_cpu_entries(void)
>  {
>  	assert(read_info);
> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
> index 28e526e2..1a365958 100644
> --- a/lib/s390x/sclp.h
> +++ b/lib/s390x/sclp.h
> @@ -146,7 +146,8 @@ typedef struct ReadInfo {
>  	SCCBHeader h;
>  	uint16_t rnmax;
>  	uint8_t rnsize;
> -	uint8_t  _reserved1[16 - 11];       /* 11-15 */
> +	uint8_t  _reserved1[15 - 11];       /* 11-14 */
> +	uint8_t stsi_parm;
>  	uint16_t entries_cpu;               /* 16-17 */
>  	uint16_t offset_cpu;                /* 18-19 */
>  	uint8_t  _reserved2[24 - 20];       /* 20-23 */
> @@ -322,6 +323,7 @@ void sclp_console_setup(void);
>  void sclp_print(const char *str);
>  void sclp_read_info(void);
>  int sclp_get_cpu_num(void);
> +int sclp_get_stsi_parm(void);
>  CPUEntry *sclp_get_cpu_entries(void);
>  void sclp_facilities_setup(void);
>  int sclp_service_call(unsigned int command, void *sccb);
> 

