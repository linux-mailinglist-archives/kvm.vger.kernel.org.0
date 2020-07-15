Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3238220F3D
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 16:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbgGOO3m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 10:29:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14292 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726935AbgGOO3l (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Jul 2020 10:29:41 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06FE8xTH089918;
        Wed, 15 Jul 2020 10:29:39 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3298wvrb3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jul 2020 10:29:39 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06FE9VHc091647;
        Wed, 15 Jul 2020 10:29:38 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3298wvrb2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jul 2020 10:29:38 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06FEPYqT021052;
        Wed, 15 Jul 2020 14:29:36 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3274pgvd6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jul 2020 14:29:36 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06FETYfm53936284
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 14:29:34 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BB814C046;
        Wed, 15 Jul 2020 14:29:34 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B6D94C044;
        Wed, 15 Jul 2020 14:29:33 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.7.230])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 15 Jul 2020 14:29:33 +0000 (GMT)
Date:   Wed, 15 Jul 2020 16:29:31 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        drjones@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: Re: [kvm-unit-tests PATCH v2 1/2] x86/cstart: Fix compilation issue
 in 32 bit mode
Message-ID: <20200715162931.4bd13f27@ibm-vm>
In-Reply-To: <20200714130030.56037-2-imbrenda@linux.ibm.com>
References: <20200714130030.56037-1-imbrenda@linux.ibm.com>
        <20200714130030.56037-2-imbrenda@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-15_11:2020-07-15,2020-07-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 adultscore=0
 impostorscore=0 spamscore=0 phishscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007150115
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

please disregard this patch, I had not noticed someone else had already
sent this same patch shortly before me

On Tue, 14 Jul 2020 15:00:29 +0200
Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:

> Fix a typo in x86/cstart.S so that 32bit code can be compiled again
> on x86.
> 
> Fixes: d86ef58519645 ("cstart: do not assume CR4 starts as zero")
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  x86/cstart.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/x86/cstart.S b/x86/cstart.S
> index e63e4e2..c0efc5f 100644
> --- a/x86/cstart.S
> +++ b/x86/cstart.S
> @@ -125,7 +125,7 @@ start:
>          jmpl $8, $start32
>  
>  prepare_32:
> -	mov %(1 << 4), %eax // pse
> +	mov $(1 << 4), %eax // pse
>  	mov %eax, %cr4
>  
>  	mov $pt, %eax

