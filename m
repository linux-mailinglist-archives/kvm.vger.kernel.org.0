Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A37536B0408
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 11:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbjCHKX5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 05:23:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbjCHKXs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 05:23:48 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4C03430A;
        Wed,  8 Mar 2023 02:23:35 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328ACq5n017276;
        Wed, 8 Mar 2023 10:23:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=O1MlOmWnnErMJ5RQp0akXHPqeMp36GNg1ndYtWkQ1Yw=;
 b=BZHo4PQPmNrhY0P8gGGzyfBqXYiipMhpZQ5X5AFj2Zoyx5ZD99c+3XtJhtdJEVz+J/pc
 mfKvJ/FhqP6AG6Yz2Uo3EtaoeJMUORBqROIQrVJOVI+u/vwEwUGM070z6uCC89h0opqi
 /XPjNugBGbKyou7Mi/9AGebiQg65n1+vEGYJLmyHuh5XmJI2UCyT18gTv/LIdQU5UKaW
 n7UFGlu6+nT10CyHc/PTL+WedVQjzonw93OZWytYjIwlfCwbXU+A38TqpGyAl20RyZMT
 utghP5Do4CYbbSt19EYmWLD8PCePC2i0wVZIVec4fhuz/Mjitur43P7iVLj2dGeYD/VG ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p6rdg06yd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Mar 2023 10:23:35 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 328AFGNS025945;
        Wed, 8 Mar 2023 10:23:34 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p6rdg06xt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Mar 2023 10:23:34 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3280cpuR003385;
        Wed, 8 Mar 2023 10:23:32 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3p6g0jgerg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Mar 2023 10:23:32 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 328ANS2940436028
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Mar 2023 10:23:28 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95F022006E;
        Wed,  8 Mar 2023 10:23:28 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6556E2006C;
        Wed,  8 Mar 2023 10:23:28 +0000 (GMT)
Received: from [9.152.224.232] (unknown [9.152.224.232])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  8 Mar 2023 10:23:28 +0000 (GMT)
Message-ID: <f135ec43-2a7c-fbc7-4aab-8fb7c4b820ed@linux.ibm.com>
Date:   Wed, 8 Mar 2023 11:23:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH v1] KVM: s390: interrupt: fix virtual-physical confusion
 for next alert GISA
To:     Nico Boehr <nrb@linux.ibm.com>, borntraeger@linux.ibm.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, david@redhat.com,
        agordeev@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230223162236.51569-1-nrb@linux.ibm.com>
From:   Michael Mueller <mimu@linux.ibm.com>
In-Reply-To: <20230223162236.51569-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PDlEUwAzEzTqNYMUvCA9_VH991nUkfr8
X-Proofpoint-ORIG-GUID: -rGbvQ0YrW-59MRuvTN78aJCX1Klvcte
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_05,2023-03-08_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 adultscore=0 mlxscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303080088
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 23.02.23 17:22, Nico Boehr wrote:
> We sometimes put a virtual address in next_alert, which should always be
> a physical address, since it is shared with hardware.
> 
> This currently works, because virtual and physical addresses are
> the same.
> 
> Add phys_to_virt() to resolve the virtual-physical confusion.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   arch/s390/kvm/interrupt.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index ab26aa53ee37..20743c5b000a 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -305,7 +305,7 @@ static inline u8 gisa_get_ipm_or_restore_iam(struct kvm_s390_gisa_interrupt *gi)
>   
>   static inline int gisa_in_alert_list(struct kvm_s390_gisa *gisa)
>   {
> -	return READ_ONCE(gisa->next_alert) != (u32)(u64)gisa;
> +	return READ_ONCE(gisa->next_alert) != (u32)virt_to_phys(gisa);
>   }
>   
>   static inline void gisa_set_ipm_gisc(struct kvm_s390_gisa *gisa, u32 gisc)
> @@ -3167,7 +3167,7 @@ void kvm_s390_gisa_init(struct kvm *kvm)
>   	hrtimer_init(&gi->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
>   	gi->timer.function = gisa_vcpu_kicker;
>   	memset(gi->origin, 0, sizeof(struct kvm_s390_gisa));
> -	gi->origin->next_alert = (u32)(u64)gi->origin;
> +	gi->origin->next_alert = (u32)virt_to_phys(gi->origin);
>   	VM_EVENT(kvm, 3, "gisa 0x%pK initialized", gi->origin);
>   }
>   

I ran hades tests as well. Thanks.

Here is my

Reviewed-by: Michael Mueller <mimu@linux.ibm.com>

