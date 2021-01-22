Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 661F230036A
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 13:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbhAVMoz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 07:44:55 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15498 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726160AbhAVMow (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Jan 2021 07:44:52 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10MCVYr1096248;
        Fri, 22 Jan 2021 07:44:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=MGUZ/Q6TGhb/4D3cxnpsgW7MmqcPwVY/B94R1FuSius=;
 b=MHws/iKja9/aWhqsf9ZE07WYmB9fzO+LBRYqN5VTLJXvpVbSa3AkS6Fnc2p5Hyt9VKbB
 HBvKF7aLzj4AwV0O3q7WqQ74sZs9dfEANr9HYxI/SvmY2f/wNBpVWBm4amWjbB2y+3UH
 qTcT5tAwHI2/rL4k2Dty3ExllEYFIto1Zvnb0ZyC6NtgvriQWJGe8DsjVAwXgOZGpgb6
 vTzf74/3sytUURNCkYvewIpqg/nHCEIkGVgCdP8jIa3xmSiZrqZp7WsXVm/7m4DU2FGw
 uaIdCYH67zelREONH5hbpMf7qCJl9FR+Nsi25j8sqzNhw5jtTDdviIIDV3lWU9OMJutX mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 367w68k86a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 07:44:05 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10MCVkRt097273;
        Fri, 22 Jan 2021 07:44:05 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 367w68k855-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 07:44:04 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10MCXu1Q011637;
        Fri, 22 Jan 2021 12:44:03 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 367k12gjrh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 12:44:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10MChrSV11141566
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 12:43:53 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 100494C04E;
        Fri, 22 Jan 2021 12:44:00 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 882464C044;
        Fri, 22 Jan 2021 12:43:59 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.4.167])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Jan 2021 12:43:59 +0000 (GMT)
Date:   Fri, 22 Jan 2021 13:43:58 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        thuth@redhat.com, david@redhat.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org, gor@linux.ibm.com,
        hca@linux.ibm.com, mihajlov@linux.ibm.com
Subject: Re: [PATCH v2 2/2] s390: mm: Fix secure storage access exception
 handling
Message-ID: <20210122134358.520c076f@ibm-vm>
In-Reply-To: <20210121151436.417240-3-frankja@linux.ibm.com>
References: <20210121151436.417240-1-frankja@linux.ibm.com>
        <20210121151436.417240-3-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-22_09:2021-01-21,2021-01-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 spamscore=0 phishscore=0 adultscore=0 impostorscore=0 priorityscore=1501
 mlxscore=0 bulkscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101220067
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 21 Jan 2021 10:14:35 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> Turns out that the bit 61 in the TEID is not always 1 and if that's
> the case the address space ID and the address are
> unpredictable. Without an address and its address space ID we can't
> export memory and hence we can only send a SIGSEGV to the process or
> panic the kernel depending on who caused the exception.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Fixes: 084ea4d611a3d ("s390/mm: add (non)secure page access
> exceptions handlers") Cc: stable@vger.kernel.org
> ---
>  arch/s390/mm/fault.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> index e30c7c781172..3e8685ad938d 100644
> --- a/arch/s390/mm/fault.c
> +++ b/arch/s390/mm/fault.c
> @@ -791,6 +791,20 @@ void do_secure_storage_access(struct pt_regs
> *regs) struct page *page;
>  	int rc;
>  
> +	/* There are cases where we don't have a TEID. */
> +	if (!(regs->int_parm_long & 0x4)) {
> +		/*
> +		 * When this happens, userspace did something that it
> +		 * was not supposed to do, e.g. branching into secure
> +		 * memory. Trigger a segmentation fault.
> +		 */
> +		if (user_mode(regs)) {
> +			send_sig(SIGSEGV, current, 0);
> +			return;
> +		} else
> +			panic("Unexpected PGM 0x3d with TEID bit
> 61=0");
> +	}
> +
>  	switch (get_fault_type(regs)) {
>  	case USER_FAULT:
>  		mm = current->mm;

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
