Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68DC1631AED
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 09:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiKUIEv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 03:04:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiKUIEt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 03:04:49 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612992408A
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 00:04:48 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AL55liP021826;
        Mon, 21 Nov 2022 08:04:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=j5AF0BO/CxgLN+nqSWUNqdmro5lmg1SJo/subksEKhE=;
 b=BGtW7SaKwMr/BIE3CN8EfcAI74Hr789p8+EGvatmKb75oyPAYSaKegv+ERaM42wqnHbf
 gfZQIFuJp9QpuU/VIacJs4h2L+WuI/w52gvTn0BF5s1LSIeiNB6ABEzc8w/ZjORoeIam
 JKjknA/RJj7XND350JrbP01aHojCvzx3Ho150DkkH914RF7YZDNSOi2ooWN4bDk0rAch
 nzazfsQIDGxa9N5PFmWAwIs4trboSswZSCmeNiG7lhBH/DMJMuUKtv6lml3oukoILS9b
 hux86eqL6p6E3LuvzquB7uL9VAIGLY956RAHapAo5EkCzz5Cj0bzWFckRkRenWb/GpQZ xg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ky9072d7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 08:04:43 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AL6Xvj4003567;
        Mon, 21 Nov 2022 08:04:42 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ky9072d6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 08:04:42 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AL7op5D012541;
        Mon, 21 Nov 2022 08:04:41 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3kxps8t9n8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 08:04:40 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AL84cEQ16580968
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 08:04:38 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA88BAE04D;
        Mon, 21 Nov 2022 08:04:38 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 577C6AE051;
        Mon, 21 Nov 2022 08:04:38 +0000 (GMT)
Received: from [9.171.18.226] (unknown [9.171.18.226])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Nov 2022 08:04:38 +0000 (GMT)
Message-ID: <286a423e-ad5a-0c74-1f1b-21367a461dd0@linux.ibm.com>
Date:   Mon, 21 Nov 2022 09:04:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [RFC PATCH 2/3] KVM: Avoid re-reading kvm->max_halt_poll_ns
 during halt-polling
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jon Cargille <jcargill@google.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Yanan Wang <wangyanan55@huawei.com>
References: <20221117001657.1067231-1-dmatlack@google.com>
 <20221117001657.1067231-3-dmatlack@google.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20221117001657.1067231-3-dmatlack@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FcEgHIeTcEfhew9tMfMyzeFTyiSH9Bv5
X-Proofpoint-ORIG-GUID: rzDeitPlKkYHeTPOZrmT4mlyTcMtaXSl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_05,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 impostorscore=0 priorityscore=1501 malwarescore=0 phishscore=0
 spamscore=0 clxscore=1011 mlxlogscore=755 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211210063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 17.11.22 um 01:16 schrieb David Matlack:
> Avoid re-reading kvm->max_halt_poll_ns multiple times during
> halt-polling except when it is explicitly useful, e.g. to check if the
> max time changed across a halt. kvm->max_halt_poll_ns can be changed at
> any time by userspace via KVM_CAP_HALT_POLL.
> 
> This bug is unlikely to cause any serious side-effects. In the worst
> case one halt polls for shorter or longer than it should, and then is
> fixed up on the next halt. Furthmore, this is still possible since
> kvm->max_halt_poll_ns are not synchronized with halts.
> 
> Fixes: acd05785e48c ("kvm: add capability for halt polling")
> Signed-off-by: David Matlack <dmatlack@google.com>

Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> ---
>   virt/kvm/kvm_main.c | 21 +++++++++++++++------
>   1 file changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 4b868f33c45d..78caf19608eb 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3488,6 +3488,11 @@ static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
>   	}
>   }
>   
> +static unsigned int kvm_vcpu_max_halt_poll_ns(struct kvm_vcpu *vcpu)
> +{
> +	return READ_ONCE(vcpu->kvm->max_halt_poll_ns);
> +}
> +
>   /*
>    * Emulate a vCPU halt condition, e.g. HLT on x86, WFI on arm, etc...  If halt
>    * polling is enabled, busy wait for a short time before blocking to avoid the
> @@ -3496,14 +3501,15 @@ static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
>    */
>   void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
>   {
> +	unsigned int max_halt_poll_ns = kvm_vcpu_max_halt_poll_ns(vcpu);
>   	bool halt_poll_allowed = !kvm_arch_no_poll(vcpu);
>   	ktime_t start, cur, poll_end;
>   	bool waited = false;
>   	bool do_halt_poll;
>   	u64 halt_ns;
>   
> -	if (vcpu->halt_poll_ns > vcpu->kvm->max_halt_poll_ns)
> -		vcpu->halt_poll_ns = vcpu->kvm->max_halt_poll_ns;
> +	if (vcpu->halt_poll_ns > max_halt_poll_ns)
> +		vcpu->halt_poll_ns = max_halt_poll_ns;
>   
>   	do_halt_poll = halt_poll_allowed && vcpu->halt_poll_ns;
>   
> @@ -3545,18 +3551,21 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
>   		update_halt_poll_stats(vcpu, start, poll_end, !waited);
>   
>   	if (halt_poll_allowed) {
> +		/* Recompute the max halt poll time in case it changed. */
> +		max_halt_poll_ns = kvm_vcpu_max_halt_poll_ns(vcpu);
> +
>   		if (!vcpu_valid_wakeup(vcpu)) {
>   			shrink_halt_poll_ns(vcpu);
> -		} else if (vcpu->kvm->max_halt_poll_ns) {
> +		} else if (max_halt_poll_ns) {
>   			if (halt_ns <= vcpu->halt_poll_ns)
>   				;
>   			/* we had a long block, shrink polling */
>   			else if (vcpu->halt_poll_ns &&
> -				 halt_ns > vcpu->kvm->max_halt_poll_ns)
> +				 halt_ns > max_halt_poll_ns)
>   				shrink_halt_poll_ns(vcpu);
>   			/* we had a short halt and our poll time is too small */
> -			else if (vcpu->halt_poll_ns < vcpu->kvm->max_halt_poll_ns &&
> -				 halt_ns < vcpu->kvm->max_halt_poll_ns)
> +			else if (vcpu->halt_poll_ns < max_halt_poll_ns &&
> +				 halt_ns < max_halt_poll_ns)
>   				grow_halt_poll_ns(vcpu);
>   		} else {
>   			vcpu->halt_poll_ns = 0;
