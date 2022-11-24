Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 156146377EE
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 12:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiKXLsh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 06:48:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbiKXLs1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 06:48:27 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DAB24942;
        Thu, 24 Nov 2022 03:48:25 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AOB5SVD031005;
        Thu, 24 Nov 2022 11:48:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=GE+dInWB62dCO4fJN5fiwaVHCERwFhdmXPivlRbPRzU=;
 b=nJEa/3+9tWIU/l8mnCHtBdzX1IfiF/XGclvYWtxy/w4IyI5AzAd0hsNHDdAC9A3E/k6F
 ZeQac/UTTQdls4eCyQ6w4ctM+zOOzgRwdA9BGjObkU12m75/Nf/qH3iiMW8z9fc2bnFF
 ebLPy/Pt0QUJr+pTEZ4xo0MuCygAOPcXWQFSkrnbgCyCqvEY5f+0Pylh5wmNPKe7tOzr
 5LBXxLkjotLTXWQWq5LIe4oPwQ7qIxcom1kCM9l4BnI1XLEG37/GwPFOEo9TcefeLeYO
 r0JhikxpPcID1W0ZmWauUnttx+xrNLopZvySjCEaILlRDCHYSlvlDHQ2Fht9Tq371ki8 9Q== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m1n2w979g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 11:48:25 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AOBbUuS010030;
        Thu, 24 Nov 2022 11:48:22 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3kxps95vbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 11:48:22 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AOBmJch21824070
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Nov 2022 11:48:19 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9001FA405C;
        Thu, 24 Nov 2022 11:48:19 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35C84A4054;
        Thu, 24 Nov 2022 11:48:19 +0000 (GMT)
Received: from [9.152.224.160] (unknown [9.152.224.160])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 24 Nov 2022 11:48:19 +0000 (GMT)
Message-ID: <eb4d17ad-b042-33da-8a2a-bc6b966e570e@linux.ibm.com>
Date:   Thu, 24 Nov 2022 12:48:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH v1] KVM: s390: GISA: sort out physical vs virtual pointers
 usage
To:     Nico Boehr <nrb@linux.ibm.com>, borntraeger@linux.ibm.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        pasic@linux.ibm.com, akrowiak@linux.ibm.com, jjherne@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com
References: <20221107085727.1533792-1-nrb@linux.ibm.com>
From:   Michael Mueller <mimu@linux.ibm.com>
In-Reply-To: <20221107085727.1533792-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: OGgKvPCHRsR33XYRB7znHq-8pcLxiZ99
X-Proofpoint-GUID: OGgKvPCHRsR33XYRB7znHq-8pcLxiZ99
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-24_09,2022-11-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 impostorscore=0
 adultscore=0 suspectscore=0 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211240087
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 07.11.22 um 09:57 schrieb Nico Boehr:
> Fix virtual vs physical address confusion (which currently are the same).
> 
> In chsc_sgib(), do the virtual-physical conversion in the caller since
> the caller needs to make sure it is a 31-bit address and zero has a
> special meaning (disassociating the GIB).
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>


Looks good to me!

Reviewed-by: Michael Mueller <mimu@linux.ibm.com>

> ---
>   arch/s390/kvm/interrupt.c | 11 +++++++----
>   1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index ab569faf0df2..ae018217eac8 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -3104,9 +3104,9 @@ static enum hrtimer_restart gisa_vcpu_kicker(struct hrtimer *timer)
>   static void process_gib_alert_list(void)
>   {
>   	struct kvm_s390_gisa_interrupt *gi;
> +	u32 final, gisa_phys, origin = 0UL;
>   	struct kvm_s390_gisa *gisa;
>   	struct kvm *kvm;
> -	u32 final, origin = 0UL;
>   
>   	do {
>   		/*
> @@ -3132,9 +3132,10 @@ static void process_gib_alert_list(void)
>   		 * interruptions asap.
>   		 */
>   		while (origin & GISA_ADDR_MASK) {
> -			gisa = (struct kvm_s390_gisa *)(u64)origin;
> +			gisa_phys = origin;
> +			gisa = phys_to_virt(gisa_phys);
>   			origin = gisa->next_alert;
> -			gisa->next_alert = (u32)(u64)gisa;
> +			gisa->next_alert = gisa_phys;
>   			kvm = container_of(gisa, struct sie_page2, gisa)->kvm;
>   			gi = &kvm->arch.gisa_int;
>   			if (hrtimer_active(&gi->timer))
> @@ -3418,6 +3419,7 @@ void kvm_s390_gib_destroy(void)
>   
>   int kvm_s390_gib_init(u8 nisc)
>   {
> +	u32 gib_origin;
>   	int rc = 0;
>   
>   	if (!css_general_characteristics.aiv) {
> @@ -3439,7 +3441,8 @@ int kvm_s390_gib_init(u8 nisc)
>   	}
>   
>   	gib->nisc = nisc;
> -	if (chsc_sgib((u32)(u64)gib)) {
> +	gib_origin = virt_to_phys(gib);
> +	if (chsc_sgib(gib_origin)) {
>   		pr_err("Associating the GIB with the AIV facility failed\n");
>   		free_page((unsigned long)gib);
>   		gib = NULL;
