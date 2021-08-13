Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A1F3EB2E0
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 10:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239431AbhHMIvH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 04:51:07 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5660 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238757AbhHMIvG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 04:51:06 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17D8ZToZ060089;
        Fri, 13 Aug 2021 04:50:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=4C8NDS/Bje+3AOvlvNtQmeZXhkynBisqzqaQV5zsRYs=;
 b=nvcJsWDpQuAIIJ3h/xrdmh3s1yBZh6TIjOCAM4Mv2N6+mUeh5zdVDPRzL5SL5Awbwi8l
 x7/QbXY3+lL6GUxqT6g7VT59E7O/SP0byEqUmjspVGxvty5aOXofMa04+S9GpJIEhzg0
 myodENPmJqCrwRLPayE80l/m7IaZMLK+XqYPwKfn1ocZ6Ewpdljw/uBJXcugi+/VI7WP
 0vl1AHXxW81INrSdwa276T4aGZwIvNMqWW7PpWODYX+J+8mWrxM4gKEOmoO186Jr/jz1
 dtmxvADmvtlv7EMw2f7zFyt+cI0IRsVwV6VkLriyBwrFDyf7nC3hR7X3tn2OX4Wv2KV4 Ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ad5se09jr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 04:50:39 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17D8aQ39063338;
        Fri, 13 Aug 2021 04:50:38 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ad5se09jf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 04:50:38 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17D8lg2X016140;
        Fri, 13 Aug 2021 08:50:37 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3abujqvmvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 08:50:37 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17D8oYQN54395386
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 08:50:34 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39CA45205A;
        Fri, 13 Aug 2021 08:50:34 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.9.6])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id E9EFA52059;
        Fri, 13 Aug 2021 08:50:33 +0000 (GMT)
Date:   Fri, 13 Aug 2021 10:41:50 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH 4/8] lib: s390x: Start using bitops
 instead of magic constants
Message-ID: <20210813104150.1539264e@p-imbrenda>
In-Reply-To: <20210813073615.32837-5-frankja@linux.ibm.com>
References: <20210813073615.32837-1-frankja@linux.ibm.com>
        <20210813073615.32837-5-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _8zHpME5QKor5rhJXoCT-wYJuNq_MHnt
X-Proofpoint-GUID: cNX1iLA2ASCYf1GWrdJNEoJQBbrLhRqO
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-13_03:2021-08-12,2021-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 mlxscore=0 adultscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108130050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 13 Aug 2021 07:36:11 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> TEID data is specified in the Principles of Operation as bits so it
> makes more sens to test the bits instead of anding the mask.
> 
> We need to set -Wno-address-of-packed-member since for test bit we
> take an address of a struct lowcore member.

and s390x has no alignment requirements

> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/interrupt.c | 5 +++--
>  s390x/Makefile        | 1 +
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index 1248bceb..e05c212e 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -8,6 +8,7 @@
>   *  David Hildenbrand <david@redhat.com>
>   */
>  #include <libcflat.h>
> +#include <bitops.h>
>  #include <asm/barrier.h>
>  #include <sclp.h>
>  #include <interrupt.h>
> @@ -77,8 +78,8 @@ static void fixup_pgm_int(struct stack_frame_int
> *stack) break;
>  	case PGM_INT_CODE_PROTECTION:
>  		/* Handling for iep.c test case. */
> -		if (lc->trans_exc_id & 0x80UL && lc->trans_exc_id &
> 0x04UL &&
> -		    !(lc->trans_exc_id & 0x08UL))
> +		if (test_bit_inv(56, &lc->trans_exc_id) &&
> test_bit_inv(61, &lc->trans_exc_id) &&
> +		    !test_bit_inv(60, &lc->trans_exc_id))
>  			/*
>  			 * We branched to the instruction that caused
>  			 * the exception so we can use the return
> diff --git a/s390x/Makefile b/s390x/Makefile
> index ef8041a6..d260b336 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -45,6 +45,7 @@ CFLAGS += -O2
>  CFLAGS += -march=zEC12
>  CFLAGS += -mbackchain
>  CFLAGS += -fno-delete-null-pointer-checks
> +CFLAGS += -Wno-address-of-packed-member
>  LDFLAGS += -nostdlib -Wl,--build-id=none
>  
>  # We want to keep intermediate files

