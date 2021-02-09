Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E97A31536F
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 17:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbhBIQJp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 11:09:45 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12774 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232588AbhBIQJm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Feb 2021 11:09:42 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 119G2P78126461;
        Tue, 9 Feb 2021 11:08:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=ECRjJvPNLWQhwsTtRrXvf+I1CiHPSjp7NXQygUByW5w=;
 b=dnU6Y1axc9HLRkPQKDTUouW7uCjVXEtsfqdfkPnFrpd/Lwcba0OI+rZFVGU2guJHUQWZ
 +6x2rqsoM3jZIfzpwsbVmVORN+VNtj7/P3WhFSuCpdFk8REbltqvdw4hjS+AoYaW9o/V
 utt+btKKsQf2m/KNU7tUKwWRpHRA3KeXROr7dR3yMtrOVfXdASpErsd+LgVlSg/7Srpk
 No//sYgYzZ0wLkwIvGB3DAZ3UxKMTUWVPUZ2eOgHYkikC+Wzrejyl8IksgNReiuJ6tS4
 XbsS8b2DAzFud4TgrZeZ1C6nouEfmcdx4kXfpHmq6B7izQ4bnkGvqaMk4JqQ9ebOz1xk nQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36kw0ej3t1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 11:08:57 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 119G2lD6128811;
        Tue, 9 Feb 2021 11:08:14 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36kw0ej3eh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 11:08:14 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 119FamUO004943;
        Tue, 9 Feb 2021 16:08:08 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 36j94wjse8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 16:08:08 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 119G86wK48234846
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Feb 2021 16:08:06 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1BE2DA4057;
        Tue,  9 Feb 2021 16:08:06 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BDD56A4051;
        Tue,  9 Feb 2021 16:08:05 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.1.216])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  9 Feb 2021 16:08:05 +0000 (GMT)
Date:   Tue, 9 Feb 2021 17:08:04 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH] s390x: Workaround smp stop and store
 status race
Message-ID: <20210209170804.75d1fc9d@ibm-vm>
In-Reply-To: <20210209141554.22554-1-frankja@linux.ibm.com>
References: <20210209141554.22554-1-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_03:2021-02-09,2021-02-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 phishscore=0
 adultscore=0 impostorscore=0 clxscore=1015 malwarescore=0 spamscore=0
 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  9 Feb 2021 09:15:54 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> KVM and QEMU handle a SIGP stop and store status in two steps:
> 1) Stop the CPU by injecting a stop request
> 2) Store when the CPU has left SIE because of the stop request
> 
> The problem is that the SIGP order is already considered completed by
> KVM/QEMU when step 1 has been performed and not once both have
> completed. In addition we currently don't implement the busy CC so a
> kernel has no way of knowing that the store has finished other than
> checking the location for the store.
> 
> This workaround is based on the fact that for a new SIE entry (via the
> added smp restart) a stop with the store status has to be finished
> first.
> 
> Correct handling of this in KVM/QEMU will need some thought and time.

do I understand correctly that you are here "fixing" the test by not
triggering the KVM bug? Shouldn't we try to trigger as many bugs as
possible instead?

> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/smp.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/s390x/smp.c b/s390x/smp.c
> index b0ece491..32f284a2 100644
> --- a/s390x/smp.c
> +++ b/s390x/smp.c
> @@ -102,12 +102,15 @@ static void test_stop_store_status(void)
>  	lc->grs_sa[15] = 0;
>  	smp_cpu_stop_store_status(1);
>  	mb();
> +	report(smp_cpu_stopped(1), "cpu stopped");
> +	/* For the cpu to be started it should have finished storing
> */
> +	smp_cpu_restart(1);
>  	report(lc->prefix_sa == (uint32_t)(uintptr_t)cpu->lowcore,
> "prefix"); report(lc->grs_sa[15], "stack");
> -	report(smp_cpu_stopped(1), "cpu stopped");
>  	report_prefix_pop();
>  
>  	report_prefix_push("stopped");
> +	smp_cpu_stop(1);
>  	lc->prefix_sa = 0;
>  	lc->grs_sa[15] = 0;
>  	smp_cpu_stop_store_status(1);

