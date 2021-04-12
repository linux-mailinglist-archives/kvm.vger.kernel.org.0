Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175C935C7F0
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 15:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242027AbhDLNtg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 09:49:36 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52668 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237043AbhDLNte (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Apr 2021 09:49:34 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13CDZCtO049495;
        Mon, 12 Apr 2021 09:49:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=2oOcGSPSGoDy5NhJdmam44Bu6upQ3ur1+giSabjybZs=;
 b=Qd7DLYmridpDnHJcyH8QWtByL5h8ub+wpD4IDi8xXkFqfxGNn6vlp42t7kHn79dnvXkO
 vEyxEt4fc38rkSWIj6gH2DmboVdI4AmTXmPiHPExrKAnvP1nxKfwR7ATPz6cbwnWUIYJ
 PYcFaMwytqF1Un16UZkaPUZg7WlxnrlPhaud5Vq2weFoEBj9/wpVz++Wr2VOK/Tzl0f1
 qUKhzdDh3pe7vOvQQGFPW2E4+BBwkgkBw5y6pkGKQw5pj4ZTgkyPViuL1nFT0/C8QfS2
 3u+4VKgxXk1MZRo10YgZDkWyXP2LUbr15CfKHXGpNB3ICB5BgRSD8wLzTh9BuEBsBQff ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37us2v5t7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 09:49:16 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13CDZQb7050634;
        Mon, 12 Apr 2021 09:49:16 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37us2v5t6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 09:49:16 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13CDm2TU006298;
        Mon, 12 Apr 2021 13:49:14 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 37u39hhv75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 13:49:13 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13CDmmK037945700
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 13:48:49 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9B26A4053;
        Mon, 12 Apr 2021 13:49:10 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 42842A404D;
        Mon, 12 Apr 2021 13:49:10 +0000 (GMT)
Received: from [9.145.90.160] (unknown [9.145.90.160])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 12 Apr 2021 13:49:10 +0000 (GMT)
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, pmorel@linux.ibm.com
References: <20210407124209.828540-1-imbrenda@linux.ibm.com>
 <20210407124209.828540-6-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 5/7] s390x: lib: add PGM_TEID_* macros
Message-ID: <641fc1a7-08bb-6052-8686-9ba15f270204@linux.ibm.com>
Date:   Mon, 12 Apr 2021 15:49:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210407124209.828540-6-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Kk_JV_zowvI85jHK17ZHKjxuL7-NfVOM
X-Proofpoint-GUID: LBjuJPLekTvYYdQbiC4yBiWLeDiMfhM9
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-12_10:2021-04-12,2021-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 priorityscore=1501 adultscore=0
 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120091
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/7/21 2:42 PM, Claudio Imbrenda wrote:
> Add PGM_TEID_* macros, to select TEID fields from various types of
> translation and protection exceptions.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  lib/s390x/asm/interrupt.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
> index bf0eb40d..d32aacb2 100644
> --- a/lib/s390x/asm/interrupt.h
> +++ b/lib/s390x/asm/interrupt.h
> @@ -13,6 +13,12 @@
>  #define EXT_IRQ_EXTERNAL_CALL	0x1202
>  #define EXT_IRQ_SERVICE_SIG	0x2401
>  
> +#define PGM_TEID_ADDR		PAGE_MASK
> +#define PGM_TEID_AI		0x003

ASCEID

> +#define PGM_TEID_M		0x004

MVPGI? or MVPGIND

> +#define PGM_TEID_A		0x008

ACCESL?

> +#define PGM_TEID_FS		0xc00

You don't use that one, right?
And even if you did you'd need one for store and fetch each for it to be
useful.


TLDR: Those abbreviations are too short

> +
>  void register_pgm_cleanup_func(void (*f)(void));
>  void handle_pgm_int(struct stack_frame_int *stack);
>  void handle_ext_int(struct stack_frame_int *stack);
> 

