Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCDE33E43D6
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 12:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234455AbhHIKXA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 06:23:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9446 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234574AbhHIKWu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Aug 2021 06:22:50 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 179A8XVA049765;
        Mon, 9 Aug 2021 06:22:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=tCSHd6/ihmX2ePoLKTJJombLx1U8q9HJKWyZVdueGK4=;
 b=VMO5Mh7zqs8k7HhXfBflReK1dj12H2/S65kff+EjLTH7BP0XM2EFHobc6vx3F9QQptO2
 ZFHqkldpHW8u4kHO3Vm0GkqmSsJpgwqRVHVeg1zSDwCGoqpi55U57o+NwxN8b51pyNhn
 8gBJ7CNq4DfvQVyL8C68eqfw6a3OjUOaQLAA20RCzpmjsG689v0ioJ7CIMKtJ0UCdR6L
 ZpETeh/VNacBrUO2OLfki7zVdAjWVXckr51RwCII0dC+zLMGlUxtTuaEdziTRHDGOXBk
 QRPc40KpzXHJkYXWLz0KkmNye/QfaFMiWLWCJOUAD9rDRyQ5aScPQ4Ab/A3cy/+lGZ6f WA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aaa1qs4pp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 06:22:29 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 179A8iEE050784;
        Mon, 9 Aug 2021 06:22:29 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aaa1qs4pc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 06:22:29 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 179AC5ej016897;
        Mon, 9 Aug 2021 10:22:27 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3a9ht8us7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 10:22:27 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 179AMOZK55837118
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Aug 2021 10:22:24 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 070D052057;
        Mon,  9 Aug 2021 10:22:24 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.6.223])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id AB89052059;
        Mon,  9 Aug 2021 10:22:23 +0000 (GMT)
Date:   Mon, 9 Aug 2021 11:53:45 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        thuth@redhat.com, kvm@vger.kernel.org, cohuck@redhat.com,
        david@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 1/4] s390x: lib: Add SCLP toplogy
 nested level
Message-ID: <20210809115345.3f0eb1c4@p-imbrenda>
In-Reply-To: <1628498934-20735-2-git-send-email-pmorel@linux.ibm.com>
References: <1628498934-20735-1-git-send-email-pmorel@linux.ibm.com>
        <1628498934-20735-2-git-send-email-pmorel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Pph1z9Dw4d_e0eiu0p-pgoFvFUhda1yK
X-Proofpoint-ORIG-GUID: 2PMmBiylHZXraNEh6kVzyrBs45Ng8zXi
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-09_03:2021-08-06,2021-08-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 mlxscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 suspectscore=0 malwarescore=0 bulkscore=0 adultscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108090075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  9 Aug 2021 10:48:51 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> The maximum CPU Topology nested level is available with the SCLP
> READ_INFO command inside the byte at offset 15 of the ReadInfo
> structure.
> 
> Let's return this information to check the number of topology nested
> information available with the STSI 15.1.x instruction.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

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

