Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B262E528681
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 16:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244228AbiEPOJd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 10:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237031AbiEPOJa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 10:09:30 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39373A718;
        Mon, 16 May 2022 07:09:29 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GCUDFX014661;
        Mon, 16 May 2022 14:09:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=rr2Ba8LJtPlfYlw7RZBveweclvfILDewVl1bneXWhYI=;
 b=CT1J2xCmbC28Ni4rxd2zs/b8aZqHVaYerNeTerJAmZZ15mTPm4CpPkqlzgb7OR338BhB
 7UpyLRorgPAmodCJTKVFtGd2TNUiW3IpUMV6+qE3IkkDGLuyNqtpnE4e7i3K7Rhu8obI
 9X6BKPaQzM+6dYikOdD9U5rrlbJawEVMUm99G3gkpR2jNqUFrILPo5GFsZ0urY/0C/1p
 3izE4v9jDPwy+6BpnFRxl1szs/P/K6GrT0pNW5eFIeLCZGUNcu1beFR8eaybDOgRdZ59
 HUODzq7tiwOX2m2VjCTZphOuYxIAv+z8yMScNtwlb7yBFjquGmuHqQn6m64XfcJc87TQ hA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3pp42bx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 14:09:29 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24GCxvsd010569;
        Mon, 16 May 2022 14:09:29 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3pp42bwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 14:09:29 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24GE71HN004651;
        Mon, 16 May 2022 14:09:26 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3g2429262h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 14:09:26 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24GDtZnI53936386
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 13:55:35 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5FA7BA4051;
        Mon, 16 May 2022 14:09:23 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A96C1A404D;
        Mon, 16 May 2022 14:09:22 +0000 (GMT)
Received: from [9.171.15.172] (unknown [9.171.15.172])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 May 2022 14:09:22 +0000 (GMT)
Message-ID: <23b2cb4c-88be-b332-d82f-961e38a069f1@linux.ibm.com>
Date:   Mon, 16 May 2022 16:13:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v9 2/3] s390x: KVM: guest support for topology function
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, wintera@linux.ibm.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com
References: <20220506092403.47406-1-pmorel@linux.ibm.com>
 <20220506092403.47406-3-pmorel@linux.ibm.com>
 <2ffb7b35-5066-3e63-7648-7663a9142e7d@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <2ffb7b35-5066-3e63-7648-7663a9142e7d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ri_A2Be5uN-PQZuvQcdCVY-AF2SEwjkg
X-Proofpoint-ORIG-GUID: nTf1W4EYlEVCEkTUCYhtzflEvAJH4TpY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_13,2022-05-16_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 mlxlogscore=999 impostorscore=0 adultscore=0 lowpriorityscore=0 mlxscore=0
 priorityscore=1501 phishscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205160079
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/12/22 11:24, David Hildenbrand wrote:
> On 06.05.22 11:24, Pierre Morel wrote:
>> We let the userland hypervisor know if the machine support the CPU
>> topology facility using a new KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
>>
>> The PTF instruction will report a topology change if there is any change
>> with a previous STSI_15_1_2 SYSIB.
>> Changes inside a STSI_15_1_2 SYSIB occur if CPU bits are set or clear
>> inside the CPU Topology List Entry CPU mask field, which happens with
>> changes in CPU polarization, dedication, CPU types and adding or
>> removing CPUs in a socket.
>>
>> The reporting to the guest is done using the Multiprocessor
>> Topology-Change-Report (MTCR) bit of the utility entry of the guest's
>> SCA which will be cleared during the interpretation of PTF.
>>
>> To check if the topology has been modified we use a new field of the
>> arch vCPU to save the previous real CPU ID at the end of a schedule
>> and verify on next schedule that the CPU used is in the same socket.
>> We do not report polarization, CPU Type or dedication change.
>>
>> STSI(15.1.x) gives information on the CPU configuration topology.
>> Let's accept the interception of STSI with the function code 15 and
>> let the userland part of the hypervisor handle it when userland
>> support the CPU Topology facility.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> 
> [...]
> 
> 
>> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
>> index 0e8603acc105..d9e16b09c8bf 100644
>> --- a/arch/s390/kvm/priv.c
>> +++ b/arch/s390/kvm/priv.c
>> @@ -874,10 +874,12 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>>   	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
>>   		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
>>   
>> -	if (fc > 3) {
>> -		kvm_s390_set_psw_cc(vcpu, 3);
>> -		return 0;
>> -	}
>> +	if (fc > 3 && fc != 15)
>> +		goto out_no_data;
>> +
>> +	/* fc 15 is provided with PTF/CPU topology support */
>> +	if (fc == 15 && !test_kvm_facility(vcpu->kvm, 11))
>> +		goto out_no_data;
> 
> 
> Maybe shorter as
> 
> if (fc == 15 && !test_kvm_facility(vcpu->kvm, 11))
> 	goto out_no_data;
> else if (fc > 3)
> 	goto out_no_data;
> 

yes.

> 
> Apart from that, LGTM.
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
