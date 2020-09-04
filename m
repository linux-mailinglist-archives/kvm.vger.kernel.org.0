Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D66625D66E
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 12:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730204AbgIDKgY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 06:36:24 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42560 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730115AbgIDKfw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Sep 2020 06:35:52 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 084AWxCI180628;
        Fri, 4 Sep 2020 06:35:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=pAwGDhty35hiyI6MfQb3Aq7jmdJ+1fWdY6e3Iyx1DuU=;
 b=dnEd6CoSJyhRL+J6CWK4+6mavm+AeeG1hxU2U50G0LWdBhk9pTN5rezQ0KmCN+QgoyuP
 CuPwmindKPdPimMwKhAEJOkktC7yBeirJ4t7wOCU/aeAtWRFm6sb0XDTNE4AL0yVcmUx
 wqEWndqBU+L/REjeKvSfUfTvU4ljFw3grU6UeY0J1gBPcqGU58DS8hL4myWxMZ7nuukW
 /H9vHYdmR4pCQDBnAzsvXft08Z/rHllIIbJUaXqUYrFALdk8TCGokmPeekLTuhBvuFVD
 V8iLYDtH/jHGOBG4jTerUGgGRoTnB/6QQUHq5xi0oYZJAdRnsbZi1SFr05qAanHIMQcO wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33beeys4nt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Sep 2020 06:35:50 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 084AY5Z6185100;
        Fri, 4 Sep 2020 06:35:49 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33beeys4n7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Sep 2020 06:35:49 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 084AW7Gd028972;
        Fri, 4 Sep 2020 10:35:48 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 337en86s8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Sep 2020 10:35:47 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 084AZjLi28901684
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Sep 2020 10:35:45 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 06DF0AE05A;
        Fri,  4 Sep 2020 10:35:45 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF538AE04D;
        Fri,  4 Sep 2020 10:35:44 +0000 (GMT)
Received: from osiris (unknown [9.171.25.186])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri,  4 Sep 2020 10:35:44 +0000 (GMT)
Date:   Fri, 4 Sep 2020 12:35:43 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        gor@linux.ibm.com, imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        david@redhat.com
Subject: Re: [PATCH 2/2] s390x: Add 3f program exception handler
Message-ID: <20200904103543.GD6075@osiris>
References: <20200903131435.2535-1-frankja@linux.ibm.com>
 <20200903131435.2535-3-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903131435.2535-3-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-04_05:2020-09-04,2020-09-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 phishscore=0
 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 suspectscore=1 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009040093
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 03, 2020 at 09:14:35AM -0400, Janosch Frank wrote:
> Program exception 3f (secure storage violation) can only be detected
> when the CPU is running in SIE with a format 4 state description,
> e.g. running a protected guest. Because of this and because user
> space partly controls the guest memory mapping and can trigger this
> exception, we want to send a SIGSEGV to the process running the guest
> and not panic the kernel.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> CC: <stable@vger.kernel.org> # 5.7+
> Fixes: 084ea4d611a3 ("s390/mm: add (non)secure page access exceptions handlers")
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/kernel/pgm_check.S |  2 +-
>  arch/s390/mm/fault.c         | 23 +++++++++++++++++++++++
>  2 files changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kernel/pgm_check.S b/arch/s390/kernel/pgm_check.S
> index 2c27907a5ffc..9a92638360ee 100644
> --- a/arch/s390/kernel/pgm_check.S
> +++ b/arch/s390/kernel/pgm_check.S
> @@ -80,7 +80,7 @@ PGM_CHECK(do_dat_exception)		/* 3b */
>  PGM_CHECK_DEFAULT			/* 3c */
>  PGM_CHECK(do_secure_storage_access)	/* 3d */
>  PGM_CHECK(do_non_secure_storage_access)	/* 3e */
> -PGM_CHECK_DEFAULT			/* 3f */
> +PGM_CHECK(do_secure_storage_violation)	/* 3f */
>  PGM_CHECK(monitor_event_exception)	/* 40 */
>  PGM_CHECK_DEFAULT			/* 41 */
>  PGM_CHECK_DEFAULT			/* 42 */
> diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> index 4c8c063bce5b..20abb7c5c540 100644
> --- a/arch/s390/mm/fault.c
> +++ b/arch/s390/mm/fault.c
> @@ -859,6 +859,24 @@ void do_non_secure_storage_access(struct pt_regs *regs)
>  }
>  NOKPROBE_SYMBOL(do_non_secure_storage_access);
>  
> +void do_secure_storage_violation(struct pt_regs *regs)
> +{
> +	char buf[TASK_COMM_LEN];
> +
> +	/*
> +	 * Either KVM messed up the secure guest mapping or the same
> +	 * page is mapped into multiple secure guests.
> +	 *
> +	 * This exception is only triggered when a guest 2 is running
> +	 * and can therefore never occur in kernel context.
> +	 */
> +	printk_ratelimited(KERN_WARNING
> +			   "Secure storage violation in task: %s, pid %d\n",
> +			   get_task_comm(buf, current), task_pid_nr(current));

Why get_task_comm() and task_pid_nr() instead of simply current->comm
and current->pid?
Also: is the dmesg message of any value?

> +	send_sig(SIGSEGV, current, 0);
> +}
> +NOKPROBE_SYMBOL(do_secure_storage_violation);

Why is this NOKPROBE? Can this deadlock?
