Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C864AB89C
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 11:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244742AbiBGKSH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 05:18:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352043AbiBGKJR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 05:09:17 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D81C043181;
        Mon,  7 Feb 2022 02:09:16 -0800 (PST)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2177IHdd021769;
        Mon, 7 Feb 2022 10:09:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=tS9RbereTtPx/SOpjQ345ravp54SHFJ2d0zGKpElp0Q=;
 b=JsdX3uD+WiCf75MIyFoqzDcZ/oid1qgju05+Ky+rMflvewuHsFjGaWqrE6w5Uo1Wj4/g
 Q8aYC11BCQSyW8kwAbewuKNdX+ssXZGalU3qbR/Kzg0AQ+neGS6SHtUe4H/GFpPz6kdM
 Nxt9kE3lRGq8J0iKFg8Z6vf3E4UW9/5PWU62+dryWUNPs/i/reDGh4i+dR22DBru3mTY
 yftQWgs0KcrJx6t/yOIu/ZzvcrQWqteoGM1SRDcjIj8Ovm2tHDGtxeprc8F5rgk+bUag
 Hy8y0Ax/z7K5Dhvr7Ri0W1ZPCWnX3WlURBIcyRK8YcgmiOvhsZLKkHZI9aeG1ZQU0lR/ kA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22u2quwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 10:09:16 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 217A0Slj016359;
        Mon, 7 Feb 2022 10:09:15 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22u2quvn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 10:09:15 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 217A7rmQ030871;
        Mon, 7 Feb 2022 10:09:12 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3e1ggjjvge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 10:09:12 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2179x6KX49676784
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Feb 2022 09:59:07 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 259114204B;
        Mon,  7 Feb 2022 10:09:09 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BDD5142042;
        Mon,  7 Feb 2022 10:09:08 +0000 (GMT)
Received: from [9.145.9.42] (unknown [9.145.9.42])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Feb 2022 10:09:08 +0000 (GMT)
Message-ID: <8f277bb3-e604-35d5-ed60-dc8824b223b5@linux.ibm.com>
Date:   Mon, 7 Feb 2022 11:09:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v7 09/17] KVM: s390: pv: clear the state without memset
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com
References: <20220204155349.63238-1-imbrenda@linux.ibm.com>
 <20220204155349.63238-10-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220204155349.63238-10-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7j-6IYFn636BvbRjr9uEYa20FeWGSY39
X-Proofpoint-ORIG-GUID: pTRqlIumz4w7ZI-811p18R5RNVbAFHCS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_03,2022-02-07_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 malwarescore=0 adultscore=0 impostorscore=0 mlxscore=0 priorityscore=1501
 suspectscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202070065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/4/22 16:53, Claudio Imbrenda wrote:
> Do not use memset to clean the whole struct kvm_s390_pv; instead,
> explicitly clear the fields that need to be cleared.
> 
> Upcoming patches will introduce new fields in the struct kvm_s390_pv
> that will not need to be cleared.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   arch/s390/kvm/pv.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index 9e900ce7387d..f1e812a45acb 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -16,6 +16,15 @@
>   #include <linux/sched/mm.h>
>   #include "kvm-s390.h"
>   
> +static void kvm_s390_clear_pv_state(struct kvm *kvm)
> +{
> +	kvm->arch.pv.handle = 0;
> +	kvm->arch.pv.guest_len = 0;
> +	kvm->arch.pv.stor_base = 0;
> +	kvm->arch.pv.stor_var = NULL;
> +	kvm->arch.pv.handle = 0;

You really want to make sure the handle is zero :)

With this fixed:
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> +}
> +
>   int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
>   {
>   	int cc;
> @@ -110,7 +119,7 @@ static void kvm_s390_pv_dealloc_vm(struct kvm *kvm)
>   	vfree(kvm->arch.pv.stor_var);
>   	free_pages(kvm->arch.pv.stor_base,
>   		   get_order(uv_info.guest_base_stor_len));
> -	memset(&kvm->arch.pv, 0, sizeof(kvm->arch.pv));
> +	kvm_s390_clear_pv_state(kvm);
>   }
>   
>   static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
> 

