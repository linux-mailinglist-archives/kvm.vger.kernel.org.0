Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1DF6447FD7
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 13:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238580AbhKHMxe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 07:53:34 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31040 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236140AbhKHMxb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 07:53:31 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A8CkXHC017292;
        Mon, 8 Nov 2021 12:50:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=bPPwWaWUC3fXnJE8xGARcCvn+a3fG4q0VXUzbt0ww5o=;
 b=ZJ1eD4kH2Cg7Z0+an3X18Dq6KE0GFKL68VO075/udf+rBelHqBNan2sPlW00mEziId0S
 xBTzxHUZ1fi0zwiQM/ggndCRgvjvxECtHoUmS9zYmyjKjFEfsW2v0Eo+mR0tnJWyQrIJ
 BKSl/3NsY3eZ3LpOTQf+xYumVQIh0fkE/tTT3CAWR+JbBo5HusGXYRL+Xpy+wzPSkuiI
 n+KrkdNusD2FvcPHehh6SE8RaZXRN6yaaFR13xH/DwrouFiLKAza4X3ZoyWBouL5AF1Q
 yDHC/Sw4cmmFVehhl3i4GHQwx0ZAMC/gKNYQOkFXMOaUH4rmgE+YgbyhVRP0I6kObn12 uQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c6b7jsn69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 12:50:46 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A8CkNxw012993;
        Mon, 8 Nov 2021 12:50:46 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c6b7jsn5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 12:50:46 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A8Co7Fc024431;
        Mon, 8 Nov 2021 12:50:44 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3c5hb9x268-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 12:50:44 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A8CofdM6488746
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Nov 2021 12:50:41 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4903311C07F;
        Mon,  8 Nov 2021 12:50:41 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EDC1611C075;
        Mon,  8 Nov 2021 12:50:40 +0000 (GMT)
Received: from [9.171.16.13] (unknown [9.171.16.13])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Nov 2021 12:50:40 +0000 (GMT)
Message-ID: <6c88b81b-85d5-b997-9b69-02f7d05a54c3@de.ibm.com>
Date:   Mon, 8 Nov 2021 13:50:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] KVM: s390x: add debug statement for diag 318 CPNC data
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>,
        Collin Walling <walling@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     david@redhat.com, imbrenda@linux.ibm.com
References: <20211027025451.290124-1-walling@linux.ibm.com>
 <4488b572-11bf-72ff-86c0-395dfc7b3f71@linux.ibm.com>
 <28d90d6f-b481-3588-cd33-39624710b7bd@de.ibm.com>
 <7e785ecc-1ddb-9357-e961-4498d1bf59fd@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <7e785ecc-1ddb-9357-e961-4498d1bf59fd@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -bn8K5R3opCSW2yOV-Dh0NQDmXnq19fw
X-Proofpoint-ORIG-GUID: iY5mu6gQX-TDT2-4Z0IZAv3-y7TrVkmA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-08_04,2021-11-08_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 suspectscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0 spamscore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 mlxscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111080079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 08.11.21 um 13:48 schrieb Janosch Frank:
> On 11/8/21 13:04, Christian Borntraeger wrote:
>>
>>
>> Am 08.11.21 um 12:12 schrieb Janosch Frank:
>>> On 10/27/21 04:54, Collin Walling wrote:
>>>> The diag 318 data contains values that denote information regarding the
>>>> guest's environment. Currently, it is unecessarily difficult to observe
>>>> this value (either manually-inserted debug statements, gdb stepping, mem
>>>> dumping etc). It's useful to observe this information to obtain an
>>>> at-a-glance view of the guest's environment, so lets add a simple VCPU
>>>> event that prints the CPNC to the s390dbf logs.
>>>>
>>>> Signed-off-by: Collin Walling <walling@linux.ibm.com>
>>>> ---
>>>>    arch/s390/kvm/kvm-s390.c | 1 +
>>>>    1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>>> index 6a6dd5e1daf6..da3ff24eabd0 100644
>>>> --- a/arch/s390/kvm/kvm-s390.c
>>>> +++ b/arch/s390/kvm/kvm-s390.c
>>>> @@ -4254,6 +4254,7 @@ static void sync_regs_fmt2(struct kvm_vcpu *vcpu)
>>>>        if (kvm_run->kvm_dirty_regs & KVM_SYNC_DIAG318) {
>>>>            vcpu->arch.diag318_info.val = kvm_run->s.regs.diag318;
>>>>            vcpu->arch.sie_block->cpnc = vcpu->arch.diag318_info.cpnc;
>>>> +        VCPU_EVENT(vcpu, 2, "setting cpnc to %d", vcpu->arch.diag318_info.cpnc);
>>>>        }
>>>>        /*
>>>>         * If userspace sets the riccb (e.g. after migration) to a valid state,
>>>>
>>>
>>> Won't that turn up for every vcpu and spam the log?
>>
>> only if the userspace always sets the dirty bit (which it should not).
>>
> 
> But that's exactly what it does, no?
> We do a loop over all vcpus and call kvm_s390_set_diag318() which sets the info in kvm_run and sets the diag318 bit in the kvm_dirty_regs.

Yes, ONCE per CPU. And this is exactly what I want to see. (and it did show a bug in qemu that we only set it for one cpu to the correct value).

> 
> @Collin: Could you check that please?
