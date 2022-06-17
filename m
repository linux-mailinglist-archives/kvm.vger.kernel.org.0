Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 849C854F975
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 16:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382850AbiFQOpS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 10:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382778AbiFQOpQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 10:45:16 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0859338A4;
        Fri, 17 Jun 2022 07:45:15 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25HEGLmM025161;
        Fri, 17 Jun 2022 14:45:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=SNQOSMRj6adOqCszklIL6pvFPIWsV3z4dOyiPWhjZBw=;
 b=ZtfwMBTBErTrIN2WavHCc3nNpBPvW8hUhnJozAdQdBjrW1cLTANBil6U7cNqpaqxNrs1
 wdKlV4r22+cQpBK9jy5lHNiSTxAjUkaB6HxrL09hQMRkXYUl55w7OIaoVeBxCATcE2vZ
 +do+oPK7DPqMo/Ga5mo5ZlAxMrX4too6uJYL9fLen0cdAIsV6rFMaDuLy0jAfW58M69l
 aGzlKkxAtGhJ51qBnhuB3p3PzaLV6rO5rGk1t3doWzBxO/ni0aqtWnKchvIDMBaAxVOU
 HEEZfS620T6KseW1cRznUMM1PpYO+p4a+kMZ4Uy6RuTMiRqCsvMXeVb45CVCNu24KLDB Nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3grs10vms2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jun 2022 14:45:15 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25HESwVb016331;
        Fri, 17 Jun 2022 14:45:14 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3grs10vmqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jun 2022 14:45:14 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25HEbqiq019423;
        Fri, 17 Jun 2022 14:45:12 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3gmjp8xyus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jun 2022 14:45:12 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25HEjCCp19857858
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jun 2022 14:45:12 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 802DF5204F;
        Fri, 17 Jun 2022 14:45:08 +0000 (GMT)
Received: from [9.171.9.193] (unknown [9.171.9.193])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id DA45252051;
        Fri, 17 Jun 2022 14:45:07 +0000 (GMT)
Message-ID: <769a1889-31a1-c7e1-5c1b-21d30ce518c9@linux.ibm.com>
Date:   Fri, 17 Jun 2022 16:49:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v9 2/3] s390x: KVM: guest support for topology function
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, wintera@linux.ibm.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com
References: <20220506092403.47406-1-pmorel@linux.ibm.com>
 <20220506092403.47406-3-pmorel@linux.ibm.com>
 <2ffb7b35-5066-3e63-7648-7663a9142e7d@redhat.com>
 <23b2cb4c-88be-b332-d82f-961e38a069f1@linux.ibm.com>
In-Reply-To: <23b2cb4c-88be-b332-d82f-961e38a069f1@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9MKFSgSkUAxf1_p_7W41VwiF_lpA1o0F
X-Proofpoint-ORIG-GUID: oSEXw1XK7sesz0YQZN-IBXRMxqMPy8rJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-17_10,2022-06-17_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206170062
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/16/22 16:13, Pierre Morel wrote:
> 
> 
> On 5/12/22 11:24, David Hildenbrand wrote:
>> On 06.05.22 11:24, Pierre Morel wrote:
>>> We let the userland hypervisor know if the machine support the CPU
>>> topology facility using a new KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
>>>
>>> The PTF instruction will report a topology change if there is any change
>>> with a previous STSI_15_1_2 SYSIB.
>>> Changes inside a STSI_15_1_2 SYSIB occur if CPU bits are set or clear
>>> inside the CPU Topology List Entry CPU mask field, which happens with
>>> changes in CPU polarization, dedication, CPU types and adding or
>>> removing CPUs in a socket.
>>>
>>> The reporting to the guest is done using the Multiprocessor
>>> Topology-Change-Report (MTCR) bit of the utility entry of the guest's
>>> SCA which will be cleared during the interpretation of PTF.
>>>
>>> To check if the topology has been modified we use a new field of the
>>> arch vCPU to save the previous real CPU ID at the end of a schedule
>>> and verify on next schedule that the CPU used is in the same socket.
>>> We do not report polarization, CPU Type or dedication change.
>>>
>>> STSI(15.1.x) gives information on the CPU configuration topology.
>>> Let's accept the interception of STSI with the function code 15 and
>>> let the userland part of the hypervisor handle it when userland
>>> support the CPU Topology facility.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>
>> [...]
>>
>>
>>> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
>>> index 0e8603acc105..d9e16b09c8bf 100644
>>> --- a/arch/s390/kvm/priv.c
>>> +++ b/arch/s390/kvm/priv.c
>>> @@ -874,10 +874,12 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>>>       if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
>>>           return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
>>> -    if (fc > 3) {
>>> -        kvm_s390_set_psw_cc(vcpu, 3);
>>> -        return 0;
>>> -    }
>>> +    if (fc > 3 && fc != 15)
>>> +        goto out_no_data;
>>> +
>>> +    /* fc 15 is provided with PTF/CPU topology support */
>>> +    if (fc == 15 && !test_kvm_facility(vcpu->kvm, 11))
>>> +        goto out_no_data;
>>
>>
>> Maybe shorter as
>>
>> if (fc == 15 && !test_kvm_facility(vcpu->kvm, 11))
>>     goto out_no_data;
>> else if (fc > 3)
>>     goto out_no_data;
>>
> 
> yes.

hum, sorry, but no.

when test_kvm_facility(11) is true then !test_kvm_facility(11) is false 
and the first test fails
and the second succeed jumping to out_no_data for fc == 15

I can use what I proposed with a comment to make it better readable.
What about:

         /* Bailout forbidden function codes */
         if (fc > 3 && fc != 15)
                 goto out_no_data;
         /* fc 15 is provided with PTF/CPU topology support */
         if (fc == 15 && !test_kvm_facility(vcpu->kvm, 11))
                 goto out_no_data;


> 
>>
>> Apart from that, LGTM.
>>
> 
> Thanks,
> Pierre
> 

-- 
Pierre Morel
IBM Lab Boeblingen
