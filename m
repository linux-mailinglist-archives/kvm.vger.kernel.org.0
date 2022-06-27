Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4521955C623
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237519AbiF0Oc3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 10:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235525AbiF0Oc2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 10:32:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18672FC2;
        Mon, 27 Jun 2022 07:32:28 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25RDfnph017001;
        Mon, 27 Jun 2022 14:32:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=cNpka3XyxVZJwBSSjgtvDjM1yCmeeGaF1A25JBDFjSc=;
 b=pEoF+ouh3niMqisHbRUzRYGJoHNGG5ZqjXmRCUEp5XATVsJho+l5lK1FOB59PDwNlBSs
 ENPQTHnWlAWNxnIBUifDKsUCNFdJGXF99yQTswADo7OfE6HjDhxwLd44iF16S+UKTwfh
 wdgKSpO1QYJslSlTJtq4X1p/I3cNLxfRe0XVXdlBAjAlqqN/cT8P1poBk9163cJ32Pyb
 AIVFt/pF/K2xr8AJHF31Pa+vL5YJXVGOjw+z+sph8D67MOrfHuoBAqQ8r78Nb+C5gudR
 K+9HZscwTg7vaxdcSViQznsJ2jpEo9F/8+i7m301qB7gyPElqsrIeb8R0X6iMJLJH8ZV /Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gydnjsnve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 14:32:26 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25RDjOqX005928;
        Mon, 27 Jun 2022 14:32:26 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gydnjsntj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 14:32:26 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25REKo8K015802;
        Mon, 27 Jun 2022 14:32:23 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3gwt08tc17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 14:32:23 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25REVN0821102938
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jun 2022 14:31:23 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 626D411C04C;
        Mon, 27 Jun 2022 14:32:20 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4FDA11C04A;
        Mon, 27 Jun 2022 14:32:19 +0000 (GMT)
Received: from [9.171.84.214] (unknown [9.171.84.214])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Jun 2022 14:32:19 +0000 (GMT)
Message-ID: <cac6d852-5f0c-adca-1db7-1775d7814217@linux.ibm.com>
Date:   Mon, 27 Jun 2022 16:36:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v10 2/3] KVM: s390: guest support for topology function
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, wintera@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220620125437.37122-1-pmorel@linux.ibm.com>
 <20220620125437.37122-3-pmorel@linux.ibm.com>
 <258450b3-e8e0-9868-4b38-1c39421cef05@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <258450b3-e8e0-9868-4b38-1c39421cef05@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6JD0Jyd9m0d1vu9uUnD74XOusL4hqrba
X-Proofpoint-GUID: FqWq4lWNu2KbHNwZM7CljJKCvBsBpP24
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-27_06,2022-06-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 clxscore=1015 mlxscore=0 malwarescore=0 impostorscore=0 priorityscore=1501
 suspectscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206270064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/24/22 17:09, Janis Schoetterl-Glausch wrote:
> On 6/20/22 14:54, Pierre Morel wrote:
>> We report a topology change to the guest for any CPU hotplug.
>>
>> The reporting to the guest is done using the Multiprocessor
>> Topology-Change-Report (MTCR) bit of the utility entry in the guest's
>> SCA which will be cleared during the interpretation of PTF.
>>
>> On every vCPU creation we set the MCTR bit to let the guest know the
>> next time he uses the PTF with command 2 instruction that the
>> topology changed and that he should use the STSI(15.1.x) instruction
>> to get the topology details.
>>
>> STSI(15.1.x) gives information on the CPU configuration topology.
>> Let's accept the interception of STSI with the function code 15 and
>> let the userland part of the hypervisor handle it when userland
>> support the CPU Topology facility.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/kvm_host.h | 11 ++++++++---
>>   arch/s390/kvm/kvm-s390.c         | 27 ++++++++++++++++++++++++++-
>>   arch/s390/kvm/priv.c             | 15 +++++++++++----
>>   arch/s390/kvm/vsie.c             |  3 +++
>>   4 files changed, 48 insertions(+), 8 deletions(-)
>>
> [...]
> 
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 8fcb56141689..95b96019ca8e 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -1691,6 +1691,25 @@ static int kvm_s390_get_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
>>   	return ret;
>>   }
>>
>> +/**
>> + * kvm_s390_sca_set_mtcr
>> + * @kvm: guest KVM description
>> + *
>> + * Is only relevant if the topology facility is present,
>> + * the caller should check KVM facility 11
>> + *
>> + * Updates the Multiprocessor Topology-Change-Report to signal
>> + * the guest with a topology change.
>> + */
>> +static void kvm_s390_sca_set_mtcr(struct kvm *kvm)
>> +{
>> +	struct bsca_block *sca = kvm->arch.sca; /* SCA version doesn't matter */
>> +
>> +	ipte_lock(kvm);
> 
> Why do we need to take the ipte lock here and in patch 3?

That is a good question.
I fear I was tired as I understood that from the documentation, after 
re-reading, we need an interlocked-update not an ipte lock update.
... I have to change that


> 
>> +	sca->utility |= SCA_UTILITY_MTCR;
>> +	ipte_unlock(kvm);
>> +}
> 
> [...]
> 

-- 
Pierre Morel
IBM Lab Boeblingen
