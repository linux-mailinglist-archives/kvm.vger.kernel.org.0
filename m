Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDED393180
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 16:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236670AbhE0Oy3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 10:54:29 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14942 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236591AbhE0Oy1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 May 2021 10:54:27 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14REXokM184667;
        Thu, 27 May 2021 10:52:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=hxvqyqvdlWIM/Db4OrXkPU/m5sLtBmf/gwut7j6plm0=;
 b=dUEWUvww4M16jYnz/9d0f5n88rrR8gpZMI2ATdfwLgFdDoRJCI6c+8doxZsNnVf4QoZS
 dhHgRb7lEDLA2K0FbMpYlscFsMwGgYIvKkYurUe69977tVIHDVOTsOhTERNhs8+DDkJV
 VzVFB3DwP9XLAr03LV2YRH8tn8nEx6GeNUXonf8RnRMyaU3ISbHePZQYV2RcFX3RFOBw
 KyKmjuaJVBU7OlINQI7yXNM8EMyNbnV42g50j7/rB7SjYfgmXA7IBN9NrXRgYiMku/dN
 jiW+2KB3M4uYtO0mthGntRve6Qmf64o6JjA32xk/qUHkiRnMlmn8onG84e9Oobo7jdcx 2w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38tc4r39bh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 10:52:54 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14REZ7YA194063;
        Thu, 27 May 2021 10:52:53 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38tc4r39aq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 10:52:53 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14REm72s014158;
        Thu, 27 May 2021 14:52:51 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 38s1r498wq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 14:52:51 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14REqnAm32309690
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 May 2021 14:52:49 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4260911C050;
        Thu, 27 May 2021 14:52:49 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DEF9D11C04A;
        Thu, 27 May 2021 14:52:48 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.86.253])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 May 2021 14:52:48 +0000 (GMT)
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com
References: <20210526134245.138906-1-imbrenda@linux.ibm.com>
 <20210526134245.138906-6-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v4 5/7] s390x: lib: add teid union and
 clear teid from lowcore
Message-ID: <3afb626a-35d0-a1af-c99f-92e4d4ae5cba@linux.ibm.com>
Date:   Thu, 27 May 2021 16:52:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210526134245.138906-6-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: W71gWNKp6pFZ6BEuor_QZt_dBXnRTT6g
X-Proofpoint-GUID: ooaNjCpSq3jJzl_UJpYrUX9yTUNsRDsc
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-27_07:2021-05-26,2021-05-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 phishscore=0 spamscore=0 priorityscore=1501 clxscore=1015 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105270095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/26/21 3:42 PM, Claudio Imbrenda wrote:
> Add a union to represent Translation-Exception Identification (TEID).
> 
> Clear the TEID in expect_pgm_int clear_pgm_int.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>  lib/s390x/asm/interrupt.h | 22 ++++++++++++++++++++++
>  lib/s390x/interrupt.c     |  2 ++
>  2 files changed, 24 insertions(+)
> 
> diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
> index bf0eb40d..b40def65 100644
> --- a/lib/s390x/asm/interrupt.h
> +++ b/lib/s390x/asm/interrupt.h
> @@ -13,6 +13,28 @@
>  #define EXT_IRQ_EXTERNAL_CALL	0x1202
>  #define EXT_IRQ_SERVICE_SIG	0x2401
>  
> +#define TEID_ASCE_PRIMARY	0
> +#define TEID_ASCE_AR		1
> +#define TEID_ASCE_SECONDARY	2
> +#define TEID_ASCE_HOME		3
> +
> +union teid {
> +	unsigned long val;
> +	struct {
> +		unsigned long addr:52;
> +		unsigned long fetch:1;
> +		unsigned long store:1;
> +		unsigned long reserved:6;
> +		unsigned long acc_list_prot:1;
> +		/* depending on the exception and the installed facilities,
> +		 * the m field can indicate severel different things,

several

> +		 * including whether the exception was triggered by a MVPG
> +		 * instruction, or whether the addr field is meaningful */

Could you please convert the comment style to this?

/*
 * Text
 */

> +		unsigned long m:1;
> +		unsigned long asce_id:2;
> +	};
> +};
> +
>  void register_pgm_cleanup_func(void (*f)(void));
>  void handle_pgm_int(struct stack_frame_int *stack);
>  void handle_ext_int(struct stack_frame_int *stack);
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index ce0003de..b627942f 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -22,6 +22,7 @@ void expect_pgm_int(void)
>  {
>  	pgm_int_expected = true;
>  	lc->pgm_int_code = 0;
> +	lc->trans_exc_id = 0;
>  	mb();
>  }
>  
> @@ -39,6 +40,7 @@ uint16_t clear_pgm_int(void)
>  	mb();
>  	code = lc->pgm_int_code;
>  	lc->pgm_int_code = 0;
> +	lc->trans_exc_id = 0;
>  	pgm_int_expected = false;
>  	return code;
>  }
> 

