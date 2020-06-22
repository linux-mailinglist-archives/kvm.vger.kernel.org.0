Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34198203A3C
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 17:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbgFVPDT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 11:03:19 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22740 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729321AbgFVPDT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Jun 2020 11:03:19 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MF25JT003085
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 11:03:19 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31shwuvusu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 11:03:18 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05MF2Zvm006590
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 11:03:18 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31shwuvupk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 11:03:18 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05MF1R71016823;
        Mon, 22 Jun 2020 15:03:15 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 31sa37sd62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 15:03:15 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05MF3DwA55705874
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Jun 2020 15:03:13 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32FFA52069;
        Mon, 22 Jun 2020 15:03:13 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.9.197])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id F003652050;
        Mon, 22 Jun 2020 15:03:12 +0000 (GMT)
Date:   Mon, 22 Jun 2020 17:03:10 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] x86: fix build with GCC10
Message-ID: <20200622170310.19207029@ibm-vm>
In-Reply-To: <20200617152124.402765-1-vkuznets@redhat.com>
References: <20200617152124.402765-1-vkuznets@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_08:2020-06-22,2020-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 phishscore=0 adultscore=0 mlxscore=0 clxscore=1011
 spamscore=0 bulkscore=0 lowpriorityscore=0 impostorscore=0
 cotscore=-2147483648 mlxlogscore=999 suspectscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006220111
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 17 Jun 2020 17:21:24 +0200
Vitaly Kuznetsov <vkuznets@redhat.com> wrote:

> kvm-unit-tests fail to build with GCC10:
> 
> /usr/bin/ld: lib/libcflat.a(usermode.o):
>   ./kvm-unit-tests/lib/x86/usermode.c:17:  multiple definition of
> `jmpbuf'; lib/libcflat.a(fault_test.o):
>   ./kvm-unit-tests/lib/x86/fault_test.c:3: first defined here
> 
> It seems that 'jmpbuf' doesn't need to be global in either of these
> files, make it static in both.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

I stumbled upon the same issue, and I had independently tested this
exact solution :)

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Tested-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/x86/fault_test.c | 2 +-
>  lib/x86/usermode.c   | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/x86/fault_test.c b/lib/x86/fault_test.c
> index 078dae3da640..e15a21864562 100644
> --- a/lib/x86/fault_test.c
> +++ b/lib/x86/fault_test.c
> @@ -1,6 +1,6 @@
>  #include "fault_test.h"
>  
> -jmp_buf jmpbuf;
> +static jmp_buf jmpbuf;
>  
>  static void restore_exec_to_jmpbuf(void)
>  {
> diff --git a/lib/x86/usermode.c b/lib/x86/usermode.c
> index f01ad9be1799..f0325236dd05 100644
> --- a/lib/x86/usermode.c
> +++ b/lib/x86/usermode.c
> @@ -14,7 +14,7 @@
>  #define USERMODE_STACK_SIZE	0x2000
>  #define RET_TO_KERNEL_IRQ	0x20
>  
> -jmp_buf jmpbuf;
> +static jmp_buf jmpbuf;
>  
>  static void restore_exec_to_jmpbuf(void)
>  {

