Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6EDB5377E8
	for <lists+kvm@lfdr.de>; Mon, 30 May 2022 12:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234943AbiE3J4i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 May 2022 05:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232713AbiE3J4f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 May 2022 05:56:35 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F12B7C1;
        Mon, 30 May 2022 02:56:35 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24U9okbe015571;
        Mon, 30 May 2022 09:56:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=AafnsQgDN85ltCyqFl3cECSPPuQql1P8UmH6fDyd5fk=;
 b=N8gOfNJLnPayHIcH3Z6UujTI4UQRt4LnpfGKOcPBZuPVm3Y7RTvrXpowQYVTWZbtfyc1
 T0m7YmVidWBwMtrN2W3yJyRUV65JnwYVHONvSjkjwXVXsQUVA8Udvr7lQKzyWWKHKvX0
 UkGvmbrJ5PP3aPccCx/WsR3SBPXjqZQJmSA8xEThZ+3ognGcvVmnpUxP3dYek4LXmcv8
 cFp+emavb6q2qebgHNhRpk7n8/buWxHAFZc61RuK+ELIooa63Y5G0YNCVUL4CzJycAaG
 OefFgZtSjtoyVuav2PvzQ+vjAkcTtroYKDouUeMi5N3xWi/fpejkzV7zJakmyAhRTScN fA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gcund034f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 09:56:34 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24U9t27b015146;
        Mon, 30 May 2022 09:56:34 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gcund033s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 09:56:34 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24U9nMtt017352;
        Mon, 30 May 2022 09:56:31 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3gbbynjh3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 09:56:31 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24U9g9iP55836954
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 May 2022 09:42:09 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B6F8FA405C;
        Mon, 30 May 2022 09:56:28 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12C7BA405F;
        Mon, 30 May 2022 09:56:28 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.12.149])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 30 May 2022 09:56:27 +0000 (GMT)
Date:   Mon, 30 May 2022 11:56:26 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Subject: Re: [PATCH 1/2] s390/gmap: voluntarily schedule during key setting
Message-ID: <20220530115626.4592d384@p-imbrenda>
In-Reply-To: <20220530092706.11637-2-borntraeger@linux.ibm.com>
References: <20220530092706.11637-1-borntraeger@linux.ibm.com>
        <20220530092706.11637-2-borntraeger@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fYK08OFUTOnJ5nUTLFFZ0DQ97oRjsn5m
X-Proofpoint-GUID: pSaJ_NFOTNORv6mZgnHxxPRl9B6lNbZs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-30_03,2022-05-27_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 adultscore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 impostorscore=0 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205300050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 30 May 2022 11:27:05 +0200
Christian Borntraeger <borntraeger@linux.ibm.com> wrote:

> With large and many guest with storage keys it is possible to create
> large latencies or stalls during initial key setting:
> 
> rcu: INFO: rcu_sched self-detected stall on CPU
> rcu:   18-....: (2099 ticks this GP) idle=54e/1/0x4000000000000002 softirq=35598716/35598716 fqs=998
>        (t=2100 jiffies g=155867385 q=20879)
> Task dump for CPU 18:
> CPU 1/KVM       R  running task        0 1030947 256019 0x06000004
> Call Trace:
> sched_show_task
> rcu_dump_cpu_stacks
> rcu_sched_clock_irq
> update_process_times
> tick_sched_handle
> tick_sched_timer
> __hrtimer_run_queues
> hrtimer_interrupt
> do_IRQ
> ext_int_handler
> ptep_zap_key
> 
> The mmap lock is held during the page walking but since this is a
> semaphore scheduling is still possible. Same for the kvm srcu.
> To minimize overhead do this on every segment table entry or large page.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/mm/gmap.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> index 1ac73917a8d3..b8ae4a4aa2ba 100644
> --- a/arch/s390/mm/gmap.c
> +++ b/arch/s390/mm/gmap.c
> @@ -2608,6 +2608,18 @@ static int __s390_enable_skey_pte(pte_t *pte, unsigned long addr,
>  	return 0;
>  }
>  
> +/*
> + * Give a chance to schedule after setting a key to 256 pages.
> + * We only hold the mm lock, which is a rwsem and the kvm srcu.
> + * Both can sleep.
> + */
> +static int __s390_enable_skey_pmd(pmd_t *pmd, unsigned long addr,
> +				  unsigned long next, struct mm_walk *walk)
> +{
> +	cond_resched();
> +	return 0;
> +}
> +
>  static int __s390_enable_skey_hugetlb(pte_t *pte, unsigned long addr,
>  				      unsigned long hmask, unsigned long next,
>  				      struct mm_walk *walk)
> @@ -2630,12 +2642,14 @@ static int __s390_enable_skey_hugetlb(pte_t *pte, unsigned long addr,
>  	end = start + HPAGE_SIZE - 1;
>  	__storage_key_init_range(start, end);
>  	set_bit(PG_arch_1, &page->flags);
> +	cond_resched();
>  	return 0;
>  }
>  
>  static const struct mm_walk_ops enable_skey_walk_ops = {
>  	.hugetlb_entry		= __s390_enable_skey_hugetlb,
>  	.pte_entry		= __s390_enable_skey_pte,
> +	.pmd_entry		= __s390_enable_skey_pmd,
>  };
>  
>  int s390_enable_skey(void)

