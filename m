Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3986C4C2B71
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 13:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbiBXMLO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 07:11:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232374AbiBXMLN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 07:11:13 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C6D15F35B;
        Thu, 24 Feb 2022 04:10:43 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OB4RTP018868;
        Thu, 24 Feb 2022 12:10:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=lfNtwr7eb2JuNBAmnns9BNmMkIRRwqI6ayiqTSjdMTE=;
 b=c0cefLeUz3Rhhvm3nDBECapKk0Sr5lvwfeR/jctMMGk6tQhEgU3zn+4D//33jjaARAu7
 DBAv37hI2xIAvJMXlIKl9P/BfqJKXP+QYWbmms/Yc3BGenxBoFztPuzyIVxjAkm/lYGA
 n/XjqCBZSd3egAFB5K7V+TkYF4f0kQpxv8iHSYn0wbRwk8mG9BT7AKOUwOF+5qKXFp89
 CXBWcm0IOBh9P94c8XSJzT2AS0p6VlDM0vuSkmbQpYKI38wfnGsOvJaQXYiEQiNWP81Q
 gi1k6W8Kv5wOdwwFvml0EAFLLfYCVYDmgGw7a+n8Iv1yntM+VtGbs3TsAYYmCIM+lXfH ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edh6xgqa9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 12:10:42 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21OBwW9Q020413;
        Thu, 24 Feb 2022 12:10:42 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edh6xgq9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 12:10:42 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21OC2uQN017049;
        Thu, 24 Feb 2022 12:10:40 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3eaqtjy9y0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 12:10:39 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21OCAZQh44499282
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 12:10:35 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E13642047;
        Thu, 24 Feb 2022 12:10:35 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E223942042;
        Thu, 24 Feb 2022 12:10:34 +0000 (GMT)
Received: from [9.145.90.75] (unknown [9.145.90.75])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 24 Feb 2022 12:10:34 +0000 (GMT)
Message-ID: <3640a910-60fe-0935-4dfc-55bb65a75ce5@linux.ibm.com>
Date:   Thu, 24 Feb 2022 13:10:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v1 1/1] KVM: s390: Don't cast parameter in bit operations
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
References: <20220223164420.45344-1-andriy.shevchenko@linux.intel.com>
 <20220224123620.57fd6c8b@p-imbrenda>
From:   Michael Mueller <mimu@linux.ibm.com>
In-Reply-To: <20220224123620.57fd6c8b@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qZ7sDXfe6HZhKQSr02k2dl-TvwntKCTj
X-Proofpoint-ORIG-GUID: Gx9qIV04xEish0q8S5keb9iWX4WXSEMy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-24_02,2022-02-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 clxscore=1011 bulkscore=0 adultscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202240072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 24.02.22 12:36, Claudio Imbrenda wrote:
> On Wed, 23 Feb 2022 18:44:20 +0200
> Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> 
>> While in this particular case it would not be a (critical) issue,
>> the pattern itself is bad and error prone in case somebody blindly
>> copies to their code.
>>
>> Don't cast parameter to unsigned long pointer in the bit operations.
>> Instead copy to a local variable on stack of a proper type and use.
>>
>> Fixes: d77e64141e32 ("KVM: s390: implement GISA IPM related primitives")
>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> ---
>>   arch/s390/include/asm/kvm_host.h | 5 ++++-
>>   arch/s390/kvm/interrupt.c        | 6 +++---
>>   2 files changed, 7 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
>> index a22c9266ea05..f1c4a1b9b360 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -867,7 +867,10 @@ struct kvm_s390_gisa {
>>   			u8  reserved03[11];
>>   			u32 airq_count;
>>   		} g1;
>> -		struct {
>> +		struct { /* as a 256-bit bitmap */
>> +			DECLARE_BITMAP(b, 256);
>> +		} bitmap;
>> +		struct { /* as a set of 64-bit words */
>>   			u64 word[4];
>>   		} u64;
>>   	};
>> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
>> index db933c252dbc..04e055cbd080 100644
>> --- a/arch/s390/kvm/interrupt.c
>> +++ b/arch/s390/kvm/interrupt.c
>> @@ -304,7 +304,7 @@ static inline int gisa_in_alert_list(struct kvm_s390_gisa *gisa)
>>   
>>   static inline void gisa_set_ipm_gisc(struct kvm_s390_gisa *gisa, u32 gisc)
>>   {
>> -	set_bit_inv(IPM_BIT_OFFSET + gisc, (unsigned long *) gisa);
>> +	set_bit_inv(IPM_BIT_OFFSET + gisc, gisa->bitmap.b);
> 
> wouldn't it be enough to pass gisa->u64.word here?
> then no cast would be necessary


we do that at several places

arch/s390/kernel/processor.c:	for_each_set_bit_inv(bit, (long 
*)&stfle_fac_list, MAX_FACILITY_BIT)
arch/s390/kvm/interrupt.c:	set_bit_inv(IPM_BIT_OFFSET + gisc, (unsigned 
long *) gisa);
arch/s390/kvm/kvm-s390.c:		set_bit_inv(vcpu->vcpu_id, (unsigned long *) 
sca->mcn);
arch/s390/kvm/kvm-s390.c:		set_bit_inv(vcpu->vcpu_id, (unsigned long *) 
&sca->mcn);

> 
>>   }
>>   
>>   static inline u8 gisa_get_ipm(struct kvm_s390_gisa *gisa)
>> @@ -314,12 +314,12 @@ static inline u8 gisa_get_ipm(struct kvm_s390_gisa *gisa)
>>   
>>   static inline void gisa_clear_ipm_gisc(struct kvm_s390_gisa *gisa, u32 gisc)
>>   {
>> -	clear_bit_inv(IPM_BIT_OFFSET + gisc, (unsigned long *) gisa);
>> +	clear_bit_inv(IPM_BIT_OFFSET + gisc, gisa->bitmap.b);
>>   }
>>   
>>   static inline int gisa_tac_ipm_gisc(struct kvm_s390_gisa *gisa, u32 gisc)
>>   {
>> -	return test_and_clear_bit_inv(IPM_BIT_OFFSET + gisc, (unsigned long *) gisa);
>> +	return test_and_clear_bit_inv(IPM_BIT_OFFSET + gisc, gisa->bitmap.b);
>>   }
>>   
>>   static inline unsigned long pending_irqs_no_gisa(struct kvm_vcpu *vcpu)
> 
