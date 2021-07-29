Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2389B3DA638
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 16:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237060AbhG2OXP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 10:23:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58814 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234206AbhG2OXO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 10:23:14 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16TELQAh071549;
        Thu, 29 Jul 2021 10:23:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=1RzJB0KYrwhCpXiVRAtYzkb6GWh3xVpgX/ybi1L/ytk=;
 b=cDAkypE4cVaRdgxSY0JugSSOlbjOMnBGrkZykTxgAzNUSdTJBzaNmL2oLM1tDzJU/YlO
 rg/vCn/WdsvqxR85bRw5KJmnZikI+OU3v9pLlmYwhqHN5oZv9rIVRxmvKSqth5hjGTOG
 5aJfAuiIkUdRkmgNdohgKwh+LFhHElbbtZls1Ok4IqIvdEMZGki7xLjEIA9JPr4iIgHO
 sv0MVwaDBbZhtkcyFITDXwjd+7sKFQ39+rpNM7mR8+jsRiY1B0bNWrkWIYmdLfoJJ+zh
 LH34z1/K50VbYSK0XZFfeLSOM4ZZkVIWt4S1ReTcEe1oJxq+R+6oWuqQHq42eh9GYAWo YQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a3wxtraj6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 10:23:11 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16TELSJt071879;
        Thu, 29 Jul 2021 10:23:11 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a3wxtraeu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 10:23:11 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16TEDGqL031676;
        Thu, 29 Jul 2021 14:23:08 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3a235ks57w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 14:23:08 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16TEN6qI25952572
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 14:23:06 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F44CA405E;
        Thu, 29 Jul 2021 14:23:06 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0038AA405D;
        Thu, 29 Jul 2021 14:23:05 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.151])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 29 Jul 2021 14:23:05 +0000 (GMT)
Date:   Thu, 29 Jul 2021 16:11:53 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH 2/4] s390x: lib: Introduce HPAGE_*
 constants
Message-ID: <20210729161153.353473d8@p-imbrenda>
In-Reply-To: <20210729134803.183358-3-frankja@linux.ibm.com>
References: <20210729134803.183358-1-frankja@linux.ibm.com>
        <20210729134803.183358-3-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ucGsK6RxvZfzztGTK9ApYdsQm65qY4Ue
X-Proofpoint-ORIG-GUID: 6EqOFFVNOj3tgjNHIMIZFCtCvA1AGHyk
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-29_10:2021-07-29,2021-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 clxscore=1015 priorityscore=1501 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290089
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 29 Jul 2021 13:48:01 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> They come in handy when working with 1MB blocks/addresses.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/asm/page.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/lib/s390x/asm/page.h b/lib/s390x/asm/page.h
> index f130f936..2f4afd06 100644
> --- a/lib/s390x/asm/page.h
> +++ b/lib/s390x/asm/page.h
> @@ -35,4 +35,8 @@ typedef struct { pteval_t pte; } pte_t;
>  #define __pmd(x)	((pmd_t) { (x) } )
>  #define __pte(x)	((pte_t) { (x) } )
>  
> +#define HPAGE_SHIFT		20
> +#define HPAGE_SIZE		(_AC(1,UL) << HPAGE_SHIFT)
> +#define HPAGE_MASK		(~(HPAGE_SIZE-1))
> +
>  #endif

