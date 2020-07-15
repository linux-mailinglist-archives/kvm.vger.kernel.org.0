Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E700220F62
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 16:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728794AbgGOObY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 10:31:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29496 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728682AbgGOObY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Jul 2020 10:31:24 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06FE2Hel186163;
        Wed, 15 Jul 2020 10:31:23 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 329cukh75u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jul 2020 10:31:23 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06FE2XEJ187822;
        Wed, 15 Jul 2020 10:31:22 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 329cukh750-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jul 2020 10:31:22 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06FEPZdb015675;
        Wed, 15 Jul 2020 14:31:20 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 327527vms2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jul 2020 14:31:19 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06FEVHKl66126046
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 14:31:17 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D5BA5204F;
        Wed, 15 Jul 2020 14:31:17 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.7.230])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 3E64E52050;
        Wed, 15 Jul 2020 14:31:17 +0000 (GMT)
Date:   Wed, 15 Jul 2020 16:31:16 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] cstart: Fix typo in i386's cstart
 assembly
Message-ID: <20200715163116.3215cb45@ibm-vm>
In-Reply-To: <20200714041905.12848-1-sean.j.christopherson@intel.com>
References: <20200714041905.12848-1-sean.j.christopherson@intel.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-15_11:2020-07-15,2020-07-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 adultscore=0 spamscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007150111
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 13 Jul 2020 21:19:05 -0700
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> Replace a '%' with a '$' to encode a literal in when initializing CR4.
> This fixes the build on i386 as gcc complains about a non-existent
> register.
> 
>   x86/cstart.S: Assembler messages:
>   x86/cstart.S:128: Error: bad register name `%(1<<4)'
>   Makefile:101: recipe for target 'x86/cstart.o' failed
> 
> Fixes: d86ef58519645 ("cstart: do not assume CR4 starts as zero")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

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

