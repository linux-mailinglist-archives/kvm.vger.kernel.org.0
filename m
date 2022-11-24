Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A840663764C
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 11:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiKXKYn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 05:24:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiKXKYl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 05:24:41 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89AF811D;
        Thu, 24 Nov 2022 02:24:40 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AO9nLhM002011;
        Thu, 24 Nov 2022 10:24:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=vfM1wUbauvbiVxYAwqDD2o4RuMM2aASDuQbC4RNVAoQ=;
 b=cK2P0v95Uit2bhcqLPL5S51x6P3kJzs1or11yca6c3pFPw1QGfD2qD5MBAIOFtj7SzxD
 4YIgpNy+kJnIgcukjivjFv5M3vV7/NuV1p6wKyr9Ho8szCNrC5YHRjUUgjRyOKCtm02X
 Exmn0KsBcujZgOZ8DxgNiyFo726zeSb9ULg9itLaXJDbsS0/3TKPizICX2vcOaYmTdO/
 yqarJ18D1iTq7YF4tzfqtM8oR727Ay8Yaa/3Prle41izMzk6lUtULFz905+wOmZYCqhi
 dSnOxfnm9p4Z39wt5RuVNu98lvftYOjPmG+D9572CN/W3o3UIzp6+/Rh/IBfuPW4MlB2 KQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m10w6nmwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 10:24:39 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AOABepJ021262;
        Thu, 24 Nov 2022 10:24:39 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m10w6nmvn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 10:24:38 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AOAL7c3015728;
        Thu, 24 Nov 2022 10:24:37 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3kxps8wsfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 10:24:36 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AOAOXrY53084512
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Nov 2022 10:24:33 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BFCEC5204F;
        Thu, 24 Nov 2022 10:24:33 +0000 (GMT)
Received: from [9.152.224.253] (unknown [9.152.224.253])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 7E14752090;
        Thu, 24 Nov 2022 10:24:33 +0000 (GMT)
Message-ID: <ee3999a2-7ae6-e72c-0a47-0890972bbd23@linux.ibm.com>
Date:   Thu, 24 Nov 2022 11:24:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] KVM: s390: vsie: Fix the initialization of the epoch
 extension (epdx) field
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        "Collin L. Walling" <walling@linux.ibm.com>,
        Jason J Herne <jjherne@linux.ibm.com>
References: <20221123090833.292938-1-thuth@redhat.com>
 <e7f84070-aeec-99d6-8ac0-cf90ad61ba88@linux.ibm.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <e7f84070-aeec-99d6-8ac0-cf90ad61ba88@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: n11ZI6OXbf3wC4oPmQ7kIKS3I6A6vnfy
X-Proofpoint-ORIG-GUID: RwMtsp3JyDl8lBa-K2XKoMb2keUB5ixs
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-24_07,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 bulkscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 spamscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211240079
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/23/22 10:41, Christian Borntraeger wrote:
> 
> 
> Am 23.11.22 um 10:08 schrieb Thomas Huth:
>> We recently experienced some weird huge time jumps in nested guests when
>> rebooting them in certain cases. After adding some debug code to the epoch
>> handling in vsie.c (thanks to David Hildenbrand for the idea!), it was
>> obvious that the "epdx" field (the multi-epoch extension) did not get set
>> to 0xff in case the "epoch" field was negative.
>> Seems like the code misses to copy the value from the epdx field from
>> the guest to the shadow control block. By doing so, the weird time
>> jumps are gone in our scenarios.
>>
>> Link: https://bugzilla.redhat.com/show_bug.cgi?id=2140899
>> Fixes: 8fa1696ea781 ("KVM: s390: Multiple Epoch Facility support")
> 
> We might want to add cc stable, just in case.

I'm pushing this to devel for the CI with the following additions:

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Cc: stable@vger.kernel.org # 4.19+

> 
> Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> 
> 
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>> ---
>>    arch/s390/kvm/vsie.c | 4 +++-
>>    1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
>> index 94138f8f0c1c..ace2541ababd 100644
>> --- a/arch/s390/kvm/vsie.c
>> +++ b/arch/s390/kvm/vsie.c
>> @@ -546,8 +546,10 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>>    	if (test_kvm_cpu_feat(vcpu->kvm, KVM_S390_VM_CPU_FEAT_CEI))
>>    		scb_s->eca |= scb_o->eca & ECA_CEI;
>>    	/* Epoch Extension */
>> -	if (test_kvm_facility(vcpu->kvm, 139))
>> +	if (test_kvm_facility(vcpu->kvm, 139)) {
>>    		scb_s->ecd |= scb_o->ecd & ECD_MEF;
>> +		scb_s->epdx = scb_o->epdx;
>> +	}
>>    
>>    	/* etoken */
>>    	if (test_kvm_facility(vcpu->kvm, 156))

