Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A264AB8AC
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 11:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352664AbiBGKSJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 05:18:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354376AbiBGKQB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 05:16:01 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E047C043181;
        Mon,  7 Feb 2022 02:16:01 -0800 (PST)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2178G8Pq026648;
        Mon, 7 Feb 2022 10:16:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=GVmtIGVHCzm2ry3MqZfYnDftYznvSRoRvkFIVQKihNU=;
 b=LGnqJlz2HHAYDij+GW/zRV+lfwSQAh9R/slDu2rPTtVC6LQaWjQz2CG3Q3JSFpqcd3vI
 sT0+8dW9BKHSCFsNVLoDM2V7Qt0c7JxeRNOcxGiyrCrYMU2wuz+1EuYPA2Hr1AwzfON+
 /pcKHlaNUR2lBko5UjQN8wjaD1uIBQdYEhx60Ku8q58LNbxVgkkuD0VcXTAqKnCwrbRP
 SkNRmny7IqiDVqhxF4q4+bgRk8GLu7bj0sZSlzq7D3aQfwcxinqeBKzmz557gnXUomos
 W6S0VBt+TtwENwW3pBVJgZ6rFoPM5cXU3CJVynxbm8dgmNV3x7eU9/XBeH2p0kmki8fG sQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e23anqqrw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 10:16:00 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2179qmB2005532;
        Mon, 7 Feb 2022 10:16:00 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e23anqqr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 10:16:00 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 217ACqt2009976;
        Mon, 7 Feb 2022 10:15:58 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3e1gv9t6ct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 10:15:58 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 217AFrFD42926522
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Feb 2022 10:15:53 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 477F64204D;
        Mon,  7 Feb 2022 10:15:53 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E9A8542064;
        Mon,  7 Feb 2022 10:15:52 +0000 (GMT)
Received: from [9.145.9.42] (unknown [9.145.9.42])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Feb 2022 10:15:52 +0000 (GMT)
Message-ID: <bd2910bb-957f-f095-8650-b192f9d6f10f@linux.ibm.com>
Date:   Mon, 7 Feb 2022 11:15:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v7 08/17] KVM: s390: pv: make kvm_s390_cpus_from_pv global
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com
References: <20220204155349.63238-1-imbrenda@linux.ibm.com>
 <20220204155349.63238-9-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220204155349.63238-9-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: r9PSXkx-F95A0wJQqOLBOsNa5NiiI52z
X-Proofpoint-ORIG-GUID: sdGzUh6pHacxKBbd50pYomS15062ybZZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_03,2022-02-07_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 clxscore=1015
 mlxlogscore=999 adultscore=0 bulkscore=0 suspectscore=0 impostorscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202070065
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
> The functions kvm_s390_cpus_from_pv needs to be called from pv.c, so
> make it global.


KVM: s390: pv: Add kvm_s390_cpus_from_pv to kvm-s390.h and provide 
documentation

Future changes make it necessary to call this function from pv.c.

While we're add it let's properly document kvm_s390_cpus_from_pv() and 
kvm_s390_cpus_to_pv().




Also could you swap patches 8 and 9 so this one is closer to patch #10?

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> 
> Take the opportunity to add documentation.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   arch/s390/kvm/kvm-s390.c | 26 +++++++++++++++++++++++++-
>   arch/s390/kvm/kvm-s390.h |  1 +
>   2 files changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 1a788f45d691..0fc8d1aec396 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2175,7 +2175,20 @@ static int kvm_s390_set_cmma_bits(struct kvm *kvm,
>   	return r;
>   }
>   
> -static int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rcp, u16 *rrcp)
> +/**
> + * kvm_s390_cpus_from_pv - Convert all protected vCPUs in a protected VM to
> + * non protected.
> + * @kvm the VM whose protected vCPUs are to be converted
> + * @rcp return value for the RC field of the UVC (in case of error)
> + * @rrcp return value for the RRC field of the UVC (in case of error)
> + *
> + * Does not stop in case of error, tries to convert as many
> + * CPUs as possible. In case of error, the RC and RRC of the last error are
> + * returned.
> + *
> + * Return: 0 in case of success, otherwise -EIO
> + */
> +int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rcp, u16 *rrcp)
>   {
>   	struct kvm_vcpu *vcpu;
>   	u16 rc, rrc;
> @@ -2202,6 +2215,17 @@ static int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rcp, u16 *rrcp)
>   	return ret;
>   }
>   
> +/**
> + * kvm_s390_cpus_to_pv - Convert all non-protected vCPUs in a protected VM
> + * to protected.
> + * @kvm the VM whose protected vCPUs are to be converted
> + * @rcp return value for the RC field of the UVC (in case of error)
> + * @rrcp return value for the RRC field of the UVC (in case of error)
> + *
> + * Tries to undo the conversion in case of error.
> + *
> + * Return: 0 in case of success, otherwise -EIO
> + */
>   static int kvm_s390_cpus_to_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
>   {
>   	unsigned long i;
> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index 098831e815e6..9276d910631b 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -365,6 +365,7 @@ int kvm_s390_vcpu_setup_cmma(struct kvm_vcpu *vcpu);
>   void kvm_s390_vcpu_unsetup_cmma(struct kvm_vcpu *vcpu);
>   void kvm_s390_set_cpu_timer(struct kvm_vcpu *vcpu, __u64 cputm);
>   __u64 kvm_s390_get_cpu_timer(struct kvm_vcpu *vcpu);
> +int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rcp, u16 *rrcp);
>   
>   /* implemented in diag.c */
>   int kvm_s390_handle_diag(struct kvm_vcpu *vcpu);
> 

