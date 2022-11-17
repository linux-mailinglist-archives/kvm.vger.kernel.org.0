Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9319462E014
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 16:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239737AbiKQPjD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 10:39:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239734AbiKQPif (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 10:38:35 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E010D6D
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 07:38:30 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AHDiNjE003452;
        Thu, 17 Nov 2022 15:38:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=dcBMfT02/fhemNoSV9+WXoatCkSif082BaKQDc7l+Sg=;
 b=Dvt2g0sdtTJ0//LpuMZcK4c5c8b5MGC08eVmD1X3IVUM4pnPbCEpDUPBHnbqaHPt2GzH
 /WhTGc5obGq0J+BaNBDw2BgqAuyVPERuJacVvk0mGQrcLfYPnys62prMQX6Ti8p8ubct
 i3xqfPGQnnpeun9smdZ6MqDPkQV43nBSbXRnMBBLjVcp4JTH+g6coRQGWUDkvoFA8Spq
 oYfIb2p0Egsu0xkfwV0/7Wy11T6g/zkHwawWk7NsWOeHUnuAf6Ze1wmEQ+GQV+v0RopM
 iC/nHubHQLNddUeXeFs+YgSiwZlbZ6xYQ42brYtdM8vCcxMEUBtFcE65GwNCzzAcDm+q Aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kwmjtp08w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Nov 2022 15:38:22 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AHE3s1T023968;
        Thu, 17 Nov 2022 15:38:22 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kwmjtp08a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Nov 2022 15:38:22 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AHFadNk032721;
        Thu, 17 Nov 2022 15:38:20 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3kt2rjfr3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Nov 2022 15:38:20 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AHFcH3f65405332
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Nov 2022 15:38:18 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E122EAE04D;
        Thu, 17 Nov 2022 15:38:17 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 907A3AE045;
        Thu, 17 Nov 2022 15:38:17 +0000 (GMT)
Received: from [9.171.13.174] (unknown [9.171.13.174])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Nov 2022 15:38:17 +0000 (GMT)
Message-ID: <92123fcd-32c3-4e68-a7a6-234588f6a661@de.ibm.com>
Date:   Thu, 17 Nov 2022 16:38:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [RFC PATCH 1/3] KVM: Cap vcpu->halt_poll_ns before halting rather
 than after
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jon Cargille <jcargill@google.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Yanan Wang <wangyanan55@huawei.com>
References: <20221117001657.1067231-1-dmatlack@google.com>
 <20221117001657.1067231-2-dmatlack@google.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <20221117001657.1067231-2-dmatlack@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dzmcwKc9IHN0YfUHtRJbhevWGWfk7m3S
X-Proofpoint-ORIG-GUID: e74_DRMraw3t7A7zA6-u2N1UQ_5i8okz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_06,2022-11-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 adultscore=0 phishscore=0 malwarescore=0 spamscore=0
 mlxscore=0 mlxlogscore=624 bulkscore=0 clxscore=1011 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211170116
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 17.11.22 um 01:16 schrieb David Matlack:
> Cap vcpu->halt_poll_ns based on the max halt polling time just before
> halting, rather than after the last halt. This arguably provides better
> accuracy if an admin disables halt polling in between halts, although
> the improvement is nominal.
> 
> A side-effect of this change is that grow_halt_poll_ns() no longer needs
> to access vcpu->kvm->max_halt_poll_ns, which will be useful in a future
> commit where the max halt polling time can come from the module parameter
> halt_poll_ns instead.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

Looks sane

Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>


> ---
>   virt/kvm/kvm_main.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 43bbe4fde078..4b868f33c45d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3385,9 +3385,6 @@ static void grow_halt_poll_ns(struct kvm_vcpu *vcpu)
>   	if (val < grow_start)
>   		val = grow_start;
>   
> -	if (val > vcpu->kvm->max_halt_poll_ns)
> -		val = vcpu->kvm->max_halt_poll_ns;
> -
>   	vcpu->halt_poll_ns = val;
>   out:
>   	trace_kvm_halt_poll_ns_grow(vcpu->vcpu_id, val, old);
> @@ -3500,11 +3497,16 @@ static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
>   void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
>   {
>   	bool halt_poll_allowed = !kvm_arch_no_poll(vcpu);
> -	bool do_halt_poll = halt_poll_allowed && vcpu->halt_poll_ns;
>   	ktime_t start, cur, poll_end;
>   	bool waited = false;
> +	bool do_halt_poll;
>   	u64 halt_ns;
>   
> +	if (vcpu->halt_poll_ns > vcpu->kvm->max_halt_poll_ns)
> +		vcpu->halt_poll_ns = vcpu->kvm->max_halt_poll_ns;
> +
> +	do_halt_poll = halt_poll_allowed && vcpu->halt_poll_ns;
> +
>   	start = cur = poll_end = ktime_get();
>   	if (do_halt_poll) {
>   		ktime_t stop = ktime_add_ns(start, vcpu->halt_poll_ns);
