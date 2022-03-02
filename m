Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 073E94CA1F7
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 11:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240944AbiCBKQO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 05:16:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbiCBKQN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 05:16:13 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC0D06004A;
        Wed,  2 Mar 2022 02:15:30 -0800 (PST)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2229n7sR004798;
        Wed, 2 Mar 2022 10:15:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Ae8AEdg8mPohiJAzc7/4KhBywCdg6nyh2bn5vfGTY08=;
 b=MyIOgvgp2AXDecrBdNSkKjxzjrdmR4IYpNkfXCkillv4dp2CBVwr/dDP9X4KsvYwo9Ny
 Us9z+/d5Ufv9l0khY6anLHVGFUa66hnV7RwDaBh+DsV4PpDHaLlfCtR1Cb//ZWv1RnC9
 qCNdyXHH5kBbMccRDnr8bAPh8GcJB5ZFz8vujTPJpreitGDrRFCKVuNAbE7wv8HK7cwx
 NxR4g4Q6QEIthhp5Qq37SWlw15Hbv9nriCXYWU9Xnms9jMt9yoWoNcpqIElc/1ZJQNJx
 WexwiLkeb3TwU38yhLeGlfA1I9BAuK4CkmNaD19I2VuQYdw9jRqMK87n6CCzb6DdwiTP nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ej69g8ghy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 10:15:29 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 222A5lmw005941;
        Wed, 2 Mar 2022 10:15:29 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ej69g8ghe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 10:15:29 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 222A8aVL023311;
        Wed, 2 Mar 2022 10:15:27 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3efbfjpb38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 10:15:27 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 222AFOqO45351412
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Mar 2022 10:15:24 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F10F5204E;
        Wed,  2 Mar 2022 10:15:24 +0000 (GMT)
Received: from [9.171.87.51] (unknown [9.171.87.51])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 19B8D52052;
        Wed,  2 Mar 2022 10:15:24 +0000 (GMT)
Message-ID: <d4c185b3-a788-8416-2f1b-4d7394d157e3@linux.ibm.com>
Date:   Wed, 2 Mar 2022 11:15:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v1 1/1] KVM: s390x: fix SCK locking
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        thuth@redhat.com, borntraeger@de.ibm.com, mimu@linux.ibm.com
References: <20220301143340.111129-1-imbrenda@linux.ibm.com>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <20220301143340.111129-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sIaGCk2vM-fvglB8XdGvHMhpAiFvHG-Y
X-Proofpoint-ORIG-GUID: 4vhofLyOyoRjdRYc74pTYEQKrFqfJbHC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-02_01,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 suspectscore=0 phishscore=0 adultscore=0 priorityscore=1501 spamscore=0
 malwarescore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203020039
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/1/22 15:33, Claudio Imbrenda wrote:
> When handling the SCK instruction, the kvm lock is taken, even though
> the vcpu lock is already being held. The normal locking order is kvm
> lock first and then vcpu lock. This is can (and in some circumstances
> does) lead to deadlocks.
> 
> The function kvm_s390_set_tod_clock is called both by the SCK handler
> and by some IOCTLs to set the clock. The IOCTLs will not hold the vcpu
> lock, so they can safely take the kvm lock. The SCK handler holds the
> vcpu lock, but will also somehow need to acquire the kvm lock without
> relinquishing the vcpu lock.
> 
> The solution is to factor out the code to set the clock, and provide
> two wrappers. One is called like the original function and does the
> locking, the other is called kvm_s390_try_set_tod_clock and uses
> trylock to try to acquire the kvm lock. This new wrapper is then used
> in the SCK handler. If locking fails, -EAGAIN is returned, which is
> eventually propagated to userspace, thus also freeing the vcpu lock and
> allowing for forward progress.
> 
> This is not the most efficient or elegant way to solve this issue, but
> the SCK instruction is deprecated and its performance is not critical.
> 
> The goal of this patch is just to provide a simple but correct way to
> fix the bug.
> 
> Fixes: 6a3f95a6b04c ("KVM: s390: Intercept SCK instruction")
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 19 ++++++++++++++++---
>  arch/s390/kvm/kvm-s390.h |  4 ++--
>  arch/s390/kvm/priv.c     | 14 +++++++++++++-
>  3 files changed, 31 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 2296b1ff1e02..4e3db4004bfd 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -3869,14 +3869,12 @@ static int kvm_s390_handle_requests(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
> 
> -void kvm_s390_set_tod_clock(struct kvm *kvm,
> -			    const struct kvm_s390_vm_tod_clock *gtod)
> +static void __kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod)
>  {
>  	struct kvm_vcpu *vcpu;
>  	union tod_clock clk;
>  	unsigned long i;
> 
> -	mutex_lock(&kvm->lock);
>  	preempt_disable();
> 
>  	store_tod_clock_ext(&clk);
> @@ -3897,7 +3895,22 @@ void kvm_s390_set_tod_clock(struct kvm *kvm,
> 
>  	kvm_s390_vcpu_unblock_all(kvm);
>  	preempt_enable();
> +}
> +
> +void kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod)
> +{
> +	mutex_lock(&kvm->lock);
> +	__kvm_s390_set_tod_clock(kvm, gtod);
> +	mutex_unlock(&kvm->lock);
> +}
> +
> +int kvm_s390_try_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod)

Why int instead of bool?

> +{
> +	if (!mutex_trylock(&kvm->lock))
> +		return 0;
> +	__kvm_s390_set_tod_clock(kvm, gtod);
>  	mutex_unlock(&kvm->lock);
> +	return 1;
>  }
> 
[...]
