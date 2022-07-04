Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2BA55657D5
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 15:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234125AbiGDNv4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 09:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234041AbiGDNvy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 09:51:54 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD9C7678;
        Mon,  4 Jul 2022 06:51:53 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 264DpbmC035401;
        Mon, 4 Jul 2022 13:51:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mxaoIx2YhOajfaYEPRFc/+V1Gkvv5/BhUpkx4qUEByM=;
 b=p3QykuEQUUqMhg7aJWtLeHb6osiYFFleJCtoS/q4sPlujSHcxhDaosNoQllxwUXch1Rb
 k0r0NXQkPMB/JhW6T2sGb54nfIVbn02m40+ze2TztNIYraql2OApMyHGGqEIEHU9VBTW
 v4Zm8ByzKERwZYUq1rlFpRHVjSocX/ofYlN7a8pBvuvKt3dE+EDn61EbFH9HSyy8tnZN
 GBOJfgjXsG911e3PmwJOSAcsFQtTw8j27Hd6MJOBBljUODndkekjbI73V/VgQgHYtcJq
 gMnQxzaJnscvGyGIF+WBnGlAnsTusTd4XWd0YB7SHawKpyySDj9IkJKyyWbtmymag6RR Tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h4188rer9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jul 2022 13:51:52 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 264Dpqrk037462;
        Mon, 4 Jul 2022 13:51:52 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h4188rdm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jul 2022 13:51:51 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 264Dh2ba004008;
        Mon, 4 Jul 2022 13:49:41 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3h2d9ht35n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jul 2022 13:49:40 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 264DnbHD23462332
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Jul 2022 13:49:37 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78EC2A4051;
        Mon,  4 Jul 2022 13:49:37 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B33D1A404D;
        Mon,  4 Jul 2022 13:49:36 +0000 (GMT)
Received: from [9.171.11.185] (unknown [9.171.11.185])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  4 Jul 2022 13:49:36 +0000 (GMT)
Message-ID: <cb9f48e6-172b-4498-4595-940c26e36f48@linux.ibm.com>
Date:   Mon, 4 Jul 2022 15:54:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v11 2/3] KVM: s390: guest support for topology function
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, wintera@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220701162559.158313-1-pmorel@linux.ibm.com>
 <20220701162559.158313-3-pmorel@linux.ibm.com>
 <579337ac-d040-197f-3553-7c8ff202623a@linux.ibm.com>
 <038d7c59-0c9a-7667-cf74-83009e186b42@linux.ibm.com>
In-Reply-To: <038d7c59-0c9a-7667-cf74-83009e186b42@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: DDr7WBFJvFCeCKpx_A-baR_nDjzFGhou
X-Proofpoint-GUID: UjrOSCgHkxeoosmIL0xUC44ZUnQocsfF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-04_13,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 priorityscore=1501 malwarescore=0 phishscore=0
 clxscore=1015 mlxlogscore=999 mlxscore=0 adultscore=0 bulkscore=0
 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2207040057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/4/22 13:02, Pierre Morel wrote:
> 
> 
> On 7/4/22 11:08, Janis Schoetterl-Glausch wrote:
>> On 7/1/22 18:25, Pierre Morel wrote:

...

>>> +    if (test_kvm_facility(vcpu->kvm, 11))
>>> +        vcpu->arch.sie_block->ecb |= ECB_PTF;
>>>       if (test_kvm_facility(vcpu->kvm, 73))
>>>           vcpu->arch.sie_block->ecb |= ECB_TE;
>>>       if (!kvm_is_ucontrol(vcpu->kvm))
>>> @@ -3403,6 +3437,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>>>       rc = kvm_s390_vcpu_setup(vcpu);
>>>       if (rc)
>>>           goto out_ucontrol_uninit;
>>> +
>>> +    kvm_s390_update_topology_change_report(vcpu->kvm, 1);
>>>       return 0;
>>>   out_ucontrol_uninit:
>>> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
>>> index 12c464c7cddf..046afee1be94 100644
>>> --- a/arch/s390/kvm/priv.c
>>> +++ b/arch/s390/kvm/priv.c
>>> @@ -873,10 +873,13 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>>>       if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
>>>           return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
>>> -    if (fc > 3) {
>>> -        kvm_s390_set_psw_cc(vcpu, 3);
>>> -        return 0;
>>> -    }
>>> +    /* Bailout forbidden function codes */
>>> +    if (fc > 3 && (fc != 15 || kvm_s390_pv_cpu_is_protected(vcpu)))
>>> +        goto out_no_data;
>>> +
>>> +    /* fc 15 is provided with PTF/CPU topology support */
>>> +    if (fc == 15 && !test_kvm_facility(vcpu->kvm, 11))
>>> +        goto out_no_data;
>>>       if (vcpu->run->s.regs.gprs[0] & 0x0fffff00
>>>           || vcpu->run->s.regs.gprs[1] & 0xffff0000)
>>> @@ -910,6 +913,11 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>>>               goto out_no_data;
>>>           handle_stsi_3_2_2(vcpu, (void *) mem);
>>>           break;
>>> +    case 15: /* fc 15 is fully handled in userspace */
>>> +        if (vcpu->kvm->arch.user_stsi)
>>> +            insert_stsi_usr_data(vcpu, operand2, ar, fc, sel1, sel2);
>>> +        trace_kvm_s390_handle_stsi(vcpu, fc, sel1, sel2, operand2);
>>> +        return -EREMOTE;
>>
>> This doesn't look right to me, you still return -EREMOTE if user_stsi 
>> is false.
>> The way I read the PoP here is that it is ok to set condition code 3 
>> for the else case
> 
> Yes it is what I wanted to do.
> I do not understand what I did here is stupid.

I thought again on this as I explain in another thread, I do not think 
we need to check on user_stsi here.


> 
> 

-- 
Pierre Morel
IBM Lab Boeblingen
