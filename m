Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C81A6357D0
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 10:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238231AbiKWJoU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 04:44:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238104AbiKWJn6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 04:43:58 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F47942F7E;
        Wed, 23 Nov 2022 01:41:57 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AN8kwum029481;
        Wed, 23 Nov 2022 09:41:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=owZfrQSSK0gTRIi7ih5TPmwEmhrUtM9WaUR+nvZLnlE=;
 b=sT/aW9J30P4WVKzoRIayoLH3FJL5p4FB9QYBC/Ckudh1csU/AP5jSaUD3Op0sbR8ez8+
 J0jJRdjL/7cataJexFC03UtYzLLZcOnn4/ySEPJujqW3uFrZaBCc8AjAp3IH+43L5aeF
 xKHlbzd0/k10r+Nnn/cKdesZzc5G8l8myZ7URYKSRbC6DT9HLtr48mfIu+l35ZI60Ub2
 eu35/X/zGphbakopEv9oOOJIM2TH5SAytJQJnH8M+jG90O+/rvfcTr82DPrWJln6P17+
 x1igXU+lVTqDDD1Le9dUz04xpeJ+5UXJx/Fr2s9GwEfmmOIvwYhk2dyWA1CqnDTDYpIk gA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m100srv9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 09:41:56 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AN9B8JI025377;
        Wed, 23 Nov 2022 09:41:55 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m100srv96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 09:41:55 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AN9aBgF003684;
        Wed, 23 Nov 2022 09:41:53 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3kxps8v0bt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 09:41:53 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AN9fo1s1770062
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 09:41:50 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A7BBA404D;
        Wed, 23 Nov 2022 09:41:50 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8FDEA4040;
        Wed, 23 Nov 2022 09:41:49 +0000 (GMT)
Received: from [9.171.16.188] (unknown [9.171.16.188])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Nov 2022 09:41:49 +0000 (GMT)
Message-ID: <e7f84070-aeec-99d6-8ac0-cf90ad61ba88@linux.ibm.com>
Date:   Wed, 23 Nov 2022 10:41:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] KVM: s390: vsie: Fix the initialization of the epoch
 extension (epdx) field
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        "Collin L. Walling" <walling@linux.ibm.com>,
        Jason J Herne <jjherne@linux.ibm.com>
References: <20221123090833.292938-1-thuth@redhat.com>
Content-Language: en-US
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20221123090833.292938-1-thuth@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2teNH9Bhw7jxQaiIpQvUmIqw4T-5L9iW
X-Proofpoint-ORIG-GUID: kp6DHK56rmcE1bxlTBKgGq9cE7C9YGTK
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_04,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 clxscore=1015 bulkscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211230071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 23.11.22 um 10:08 schrieb Thomas Huth:
> We recently experienced some weird huge time jumps in nested guests when
> rebooting them in certain cases. After adding some debug code to the epoch
> handling in vsie.c (thanks to David Hildenbrand for the idea!), it was
> obvious that the "epdx" field (the multi-epoch extension) did not get set
> to 0xff in case the "epoch" field was negative.
> Seems like the code misses to copy the value from the epdx field from
> the guest to the shadow control block. By doing so, the weird time
> jumps are gone in our scenarios.
> 
> Link: https://bugzilla.redhat.com/show_bug.cgi?id=2140899
> Fixes: 8fa1696ea781 ("KVM: s390: Multiple Epoch Facility support")

We might want to add cc stable, just in case.

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>


> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>   arch/s390/kvm/vsie.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index 94138f8f0c1c..ace2541ababd 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -546,8 +546,10 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>   	if (test_kvm_cpu_feat(vcpu->kvm, KVM_S390_VM_CPU_FEAT_CEI))
>   		scb_s->eca |= scb_o->eca & ECA_CEI;
>   	/* Epoch Extension */
> -	if (test_kvm_facility(vcpu->kvm, 139))
> +	if (test_kvm_facility(vcpu->kvm, 139)) {
>   		scb_s->ecd |= scb_o->ecd & ECD_MEF;
> +		scb_s->epdx = scb_o->epdx;
> +	}
>   
>   	/* etoken */
>   	if (test_kvm_facility(vcpu->kvm, 156))
