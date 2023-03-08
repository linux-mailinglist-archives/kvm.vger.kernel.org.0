Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 433ED6B0378
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 10:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbjCHJyJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 04:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbjCHJyC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 04:54:02 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4C7559E0;
        Wed,  8 Mar 2023 01:53:55 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3288sSOC014904;
        Wed, 8 Mar 2023 09:53:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=xktGZHLuivxWO4gUToZ93cSqWTPNbtuixYz+u3Jm7WU=;
 b=nInet/ny8Xi1iDKzALmxopvrSukSY7WufDOKgysYWkZboMAT/nlqYnhAE0ge5BWLyzI8
 hEZOnJo7UTTVRyWW+fz4A4gZQq6mt5icUUgfn/4BkoBzLbO24Mob2BEzUMITr/xuTssc
 pBnMnmRO7eJrJ7XoM98uEeA6/YyWMnCPT8qrEPYxsxgFVcO1TrKfAr0yqAhOzM1W1j/k
 HcqoTVh8NNXx+0HmBPeNW95JwVn+yTU2jNgmv6uzD+OLJeO5Gcvf+rAQx9wMGorPGXiv
 E298hCrqLyAbcwKZbVLWOyQHPl4d76zgtNxrRl9d8TYXtP3G9g+W0hZkLTWXHFZjQXvl xA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3p6ndu3xuw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Mar 2023 09:53:54 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3289cpcf010930;
        Wed, 8 Mar 2023 09:53:54 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3p6ndu3xu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Mar 2023 09:53:54 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3280r1NF015869;
        Wed, 8 Mar 2023 09:53:52 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3p6g758dkc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Mar 2023 09:53:52 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3289rmlf4653620
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Mar 2023 09:53:49 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7A222004B;
        Wed,  8 Mar 2023 09:53:48 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58B4720043;
        Wed,  8 Mar 2023 09:53:48 +0000 (GMT)
Received: from [9.179.23.199] (unknown [9.179.23.199])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  8 Mar 2023 09:53:48 +0000 (GMT)
Message-ID: <613ce5d8-2ef4-6cf0-223c-98c9ef987551@linux.ibm.com>
Date:   Wed, 8 Mar 2023 10:53:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v1] KVM: s390: interrupt: fix virtual-physical confusion
 for next alert GISA
Content-Language: en-US
To:     Michael Mueller <mimu@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, agordeev@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230223162236.51569-1-nrb@linux.ibm.com>
 <b03e447f-6f49-cdd0-1b8a-b27f63aa6bae@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <b03e447f-6f49-cdd0-1b8a-b27f63aa6bae@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oQKw6Uz8JxlR7LYEP7ufT3QyHBwFVMyD
X-Proofpoint-ORIG-GUID: JEvO2SeFwS0iSm9HJHz9UK0NBDTUYPxt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_04,2023-03-08_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 impostorscore=0
 spamscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303080083
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/7/23 14:53, Michael Mueller wrote:
> 
> 
> On 23.02.23 17:22, Nico Boehr wrote:
>> We sometimes put a virtual address in next_alert, which should always be
>> a physical address, since it is shared with hardware.
>>
>> This currently works, because virtual and physical addresses are
>> the same.
>>
>> Add phys_to_virt() to resolve the virtual-physical confusion.
>>
>> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
>> ---
>>    arch/s390/kvm/interrupt.c | 4 ++--
>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
>> index ab26aa53ee37..20743c5b000a 100644
>> --- a/arch/s390/kvm/interrupt.c
>> +++ b/arch/s390/kvm/interrupt.c
>> @@ -305,7 +305,7 @@ static inline u8 gisa_get_ipm_or_restore_iam(struct kvm_s390_gisa_interrupt *gi)
>>    
>>    static inline int gisa_in_alert_list(struct kvm_s390_gisa *gisa)
>>    {
>> -	return READ_ONCE(gisa->next_alert) != (u32)(u64)gisa;
>> +	return READ_ONCE(gisa->next_alert) != (u32)virt_to_phys(gisa);
>>    }
>>    
>>    static inline void gisa_set_ipm_gisc(struct kvm_s390_gisa *gisa, u32 gisc)
>> @@ -3167,7 +3167,7 @@ void kvm_s390_gisa_init(struct kvm *kvm)
>>    	hrtimer_init(&gi->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
>>    	gi->timer.function = gisa_vcpu_kicker;
>>    	memset(gi->origin, 0, sizeof(struct kvm_s390_gisa));
>> -	gi->origin->next_alert = (u32)(u64)gi->origin;
>> +	gi->origin->next_alert = (u32)virt_to_phys(gi->origin);
>>    	VM_EVENT(kvm, 3, "gisa 0x%pK initialized", gi->origin);
>>    }
>>    
> 
> Here is my
> 
> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>

After a consultation with Michael I'm now a 100% sure this is a rev-by 
and not a s-o-b. I've picked the patch with his rev-by.


