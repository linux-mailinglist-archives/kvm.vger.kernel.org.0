Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6317755C641
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239603AbiF0RgH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 13:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236554AbiF0RgG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 13:36:06 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E168B7E8;
        Mon, 27 Jun 2022 10:36:04 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25RHP21I013046;
        Mon, 27 Jun 2022 17:36:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=nRVbFCYhUMHhsowGXbDWnUYPdU6+yLSTiQDDJzrrjrc=;
 b=hK8hLc0dRv2LBAXKuqr6G/ppq2YDKj9aACE1J95z6t4fbtS36KyWlU0G1yRAo6z+b5w/
 D3wbRdzy67ZYO2BR5v85cYAcaOxxui1rEZ+OSkoYBE+9w0K2hQ3UBCeYTTFNFCSYbdMw
 WlfjrJpli+PfJQKme8S4EhIbRtBwjD8XCukog1w+gtMFWlTSROmwwSzSvQTpCjCL/C6t
 anrYzaf/xn8cHpoY/vX5cseU86ELCexrklY0rQzxSWKTb3kNBsCS3ncNJQEozBQcg/xG
 7NmdrP+XSGpzUkRJIjUQ+Mg1l42gasqMrkDMYqICpqVV9c1Ow+Yb5TaAU4Axp/F0kctr 6A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gygxa088c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 17:36:03 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25RHP3Jc013060;
        Mon, 27 Jun 2022 17:36:03 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gygxa087e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 17:36:02 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25RHa1FJ009965;
        Mon, 27 Jun 2022 17:36:01 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3gwt08tgqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 17:36:01 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25RHZvlo14746070
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jun 2022 17:35:58 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB32511C050;
        Mon, 27 Jun 2022 17:35:57 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 266D111C04C;
        Mon, 27 Jun 2022 17:35:57 +0000 (GMT)
Received: from [9.171.84.214] (unknown [9.171.84.214])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Jun 2022 17:35:57 +0000 (GMT)
Message-ID: <b1a9af63-7b05-d5d6-af00-849e8b1c9d73@linux.ibm.com>
Date:   Mon, 27 Jun 2022 19:40:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v10 2/3] KVM: s390: guest support for topology function
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, hca@linux.ibm.com, gor@linux.ibm.com,
        wintera@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220620125437.37122-1-pmorel@linux.ibm.com>
 <20220620125437.37122-3-pmorel@linux.ibm.com>
 <20220624113225.019a9294@p-imbrenda>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220624113225.019a9294@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bafHGAm5NoMRKBxtZH5ZhcESvphLtSqG
X-Proofpoint-GUID: XYKGHWWB9KaOcgUYtZJWU6yNqFg-U9us
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-27_06,2022-06-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 clxscore=1015 mlxscore=0 suspectscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 lowpriorityscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206270071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/24/22 11:32, Claudio Imbrenda wrote:
> On Mon, 20 Jun 2022 14:54:36 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
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
>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
>> index 766028d54a3e..bb54196d4ed6 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -97,15 +97,19 @@ struct bsca_block {
>>   	union ipte_control ipte_control;
>>   	__u64	reserved[5];
>>   	__u64	mcn;
>> -	__u64	reserved2;
>> +#define SCA_UTILITY_MTCR	0x8000
>> +	__u16	utility;
>> +	__u8	reserved2[6];
>>   	struct bsca_entry cpu[KVM_S390_BSCA_CPU_SLOTS];
>>   };
>>   
>>   struct esca_block {
>>   	union ipte_control ipte_control;
>> -	__u64   reserved1[7];
>> +	__u64   reserved1[6];
>> +	__u16	utility;
>> +	__u8	reserved2[6];
>>   	__u64   mcn[4];
>> -	__u64   reserved2[20];
>> +	__u64   reserved3[20];
>>   	struct esca_entry cpu[KVM_S390_ESCA_CPU_SLOTS];
>>   };
>>   
>> @@ -249,6 +253,7 @@ struct kvm_s390_sie_block {
>>   #define ECB_SPECI	0x08
>>   #define ECB_SRSI	0x04
>>   #define ECB_HOSTPROTINT	0x02
>> +#define ECB_PTF		0x01
>>   	__u8	ecb;			/* 0x0061 */
>>   #define ECB2_CMMA	0x80
>>   #define ECB2_IEP	0x20
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
> 
> the format for kdoc is:
> 
> 	function_name - very short description
> 
> please add a very short description. something like:
> 
> 	kvm_s390_sca_set_mtcr - update mtcr to signal topology change


OK, thanks,

Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
