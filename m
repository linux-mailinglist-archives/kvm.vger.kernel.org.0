Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7665FA115
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 17:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbiJJPX0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 11:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiJJPXZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 11:23:25 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF7F72FD8
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 08:23:24 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29AEBaXp013280
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 15:23:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=6q1fqQrz8b+2rlpl5bYJQGoSYGe6Ae4Aa6/TCZvBvoY=;
 b=rmM34mTXKPbThbE3C/pu5x4BqP1fP/w2GJZItgMfG0Grcr47Q2lM6Ndu9VcfwucnoybU
 zs4GtQzG06an744+TtAJQS7+4uiJI0kFSn7nxYxxQW0GeUFGRQ834ndMH6IG4WI0qs0g
 I3P7GtVeiTU4TXjjOXctnYNRKfCo7Bt1Cz3k/EVhyxEqIIpEj5Y9Q1rSSKRCaPd4CLo0
 f+DdPaELeyH2Ln54YoxUh4R5bB3CMPKH4D084f+FJabkkVM13PwbjNfSGtGTjFSnaWIp
 P7gpregW7aral87jB3qPWWlzgdtYU18k3xhSW81SD6rdj0HcY3nBcdmOJ6tFDotzouSS Yw== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k3jvm18ty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 15:23:23 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29AFN19v032387
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 15:23:21 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3k30u9b06g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 15:23:21 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29AFNn7742664438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Oct 2022 15:23:49 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2083011C050;
        Mon, 10 Oct 2022 15:23:18 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D515711C04A;
        Mon, 10 Oct 2022 15:23:17 +0000 (GMT)
Received: from [9.171.5.210] (unknown [9.171.5.210])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 10 Oct 2022 15:23:17 +0000 (GMT)
Message-ID: <3baa95fd-4ac4-e853-ad3b-2589265f910e@linux.ibm.com>
Date:   Mon, 10 Oct 2022 17:23:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v3 2/2] KVM: s390: remove now unused function
 kvm_s390_set_tod_clock
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@linux.ibm.com
References: <20221005163258.117232-1-nrb@linux.ibm.com>
 <20221005163258.117232-3-nrb@linux.ibm.com>
 <20221005190127.49f7ab6e@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20221005190127.49f7ab6e@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: e7MJAo4ZNG2DwF7yFesKPN-0oR6Sd1cK
X-Proofpoint-ORIG-GUID: e7MJAo4ZNG2DwF7yFesKPN-0oR6Sd1cK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-10_08,2022-10-10_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 impostorscore=0 mlxscore=0 mlxlogscore=988 adultscore=0
 suspectscore=0 bulkscore=0 clxscore=1015 spamscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210100089
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/5/22 19:01, Claudio Imbrenda wrote:
> On Wed,  5 Oct 2022 18:32:58 +0200
> Nico Boehr <nrb@linux.ibm.com> wrote:
> 
>> The function kvm_s390_set_tod_clock is now unused, hence let's remove
>> it.
>>
>> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> 
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Hrm only the first patch has the fixes tag but leaving an unused 
function around in a stable kernel feels weird to me.
Let's discuss that tomorrow.

> 
>> ---
>>   arch/s390/kvm/kvm-s390.c | 7 -------
>>   arch/s390/kvm/kvm-s390.h | 1 -
>>   2 files changed, 8 deletions(-)
>>
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 0a8019b14c8f..9ec8870832e7 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -4390,13 +4390,6 @@ static void __kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_t
>>   	preempt_enable();
>>   }
>>   
>> -void kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod)
>> -{
>> -	mutex_lock(&kvm->lock);
>> -	__kvm_s390_set_tod_clock(kvm, gtod);
>> -	mutex_unlock(&kvm->lock);
>> -}
>> -
>>   int kvm_s390_try_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod)
>>   {
>>   	if (!mutex_trylock(&kvm->lock))
>> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
>> index f6fd668f887e..4755492dfabc 100644
>> --- a/arch/s390/kvm/kvm-s390.h
>> +++ b/arch/s390/kvm/kvm-s390.h
>> @@ -363,7 +363,6 @@ int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu);
>>   int kvm_s390_handle_sigp_pei(struct kvm_vcpu *vcpu);
>>   
>>   /* implemented in kvm-s390.c */
>> -void kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod);
>>   int kvm_s390_try_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod);
>>   long kvm_arch_fault_in_page(struct kvm_vcpu *vcpu, gpa_t gpa, int writable);
>>   int kvm_s390_store_status_unloaded(struct kvm_vcpu *vcpu, unsigned long addr);
> 

