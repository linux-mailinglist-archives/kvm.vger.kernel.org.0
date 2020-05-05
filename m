Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 893431C63F8
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 00:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729328AbgEEWeb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 18:34:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15622 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727089AbgEEWeb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 May 2020 18:34:31 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 045MWIQv187522;
        Tue, 5 May 2020 18:34:30 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30uf8hany8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 18:34:30 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 045MY91c004214;
        Tue, 5 May 2020 18:34:30 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30uf8hanxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 18:34:30 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 045MUP5g007881;
        Tue, 5 May 2020 22:34:29 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma05wdc.us.ibm.com with ESMTP id 30s0g6mbqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 22:34:29 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 045MYR5b56230372
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 May 2020 22:34:27 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA59B6A047;
        Tue,  5 May 2020 22:34:27 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4B226A054;
        Tue,  5 May 2020 22:34:26 +0000 (GMT)
Received: from cpe-172-100-175-116.stny.res.rr.com (unknown [9.85.169.140])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  5 May 2020 22:34:26 +0000 (GMT)
Subject: Re: [PATCH] KVM: s390: Remove false WARN_ON_ONCE for the PQAP
 instruction
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Qian Cai <cailca@icloud.com>,
        Pierre Morel <pmorel@linux.ibm.com>
References: <20200505073525.2287-1-borntraeger@de.ibm.com>
 <20200505095332.528254e5.cohuck@redhat.com>
 <f3512a63-91dc-ab9a-a9ab-3e2a6e24fea3@de.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <889a7e3d-8318-4c85-67c8-a42a665b56f4@linux.ibm.com>
Date:   Tue, 5 May 2020 18:34:26 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <f3512a63-91dc-ab9a-a9ab-3e2a6e24fea3@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_11:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=3 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=999 phishscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050169
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/5/20 3:55 AM, Christian Borntraeger wrote:
>
> On 05.05.20 09:53, Cornelia Huck wrote:
>> On Tue,  5 May 2020 09:35:25 +0200
>> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
>>
>>> In LPAR we will only get an intercept for FC==3 for the PQAP
>>> instruction. Running nested under z/VM can result in other intercepts as
>>> well, for example PQAP(QCI). So the WARN_ON_ONCE is not right. Let
>>> us simply remove it.
>> While I agree with removing the WARN_ON_ONCE, I'm wondering why z/VM
>> gives us intercepts for those fcs... is that just a result of nesting
>> (or the z/VM implementation), or is there anything we might want to do?
> Yes nesting.
> The ECA bit for interpretion is an effective one. So if the ECA bit is off
> in z/VM (no crypto cards) our ECA bit is basically ignored as these bits
> are ANDed.
> I asked Tony to ask the z/VM team if that is the case here.

I apologize, but I was on vacation yesterday and did not have a
chance to look at this until today. I left a slack message for
my z/VM contact, but have not yet gotten a response.

The only AP virtualization support we currently provide with
Linux on Z relies on AP interpretive execution. The ECA.28
bit in the SIE state description determines whether AP
instructions executed on a guest are intercepted (0) or
interpreted (1). The problem here is that ECA.28 is an
effective control meaning that ECA.28 for the guest is
logically ANDed with the host's. If linux is running as a
guest of z/VM and z/VM is sets ECA.28 to zero,
then ECA.28 for the guest will also be zero, in which case
every AP instruction executed on the guest will be intercepted.

The only AP instruction that has an interception handler is
PQAP with function code 0x03 (AP-queue interruption control), so
this warning is being issued for all other AP instructions being
intercepted; so, maybe this is the right thing to do? After all,
running a linux as a guest of z/VM that is setting ECA.28 to zero is not
a supported configuration.

Having said that, the root of the problem is the fact that
a guest is allowed to start without AP interpretive execution
turned on because that is the only currently supported configuration.
If there is a way to determine the effective value of ECA.28 for a
KVM guest, when KVM could respond appropriately when QEMU
queries whether the KVM_S390_VM_CRYPTO_ENABLE_APIE attribute
is available in the CPU model. If it is not, then QEMU does not set the
S390_FEAT_AP (AP instructions installed) feature and a guest started
with cpu model feature ap='on' will fail to start.


>
>>> Cc: Pierre Morel <pmorel@linux.ibm.com>
>>> Cc: Tony Krowiak <akrowiak@linux.ibm.com>
>>> Reported-by: Qian Cai <cailca@icloud.com>
>>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>>> ---
>>>   arch/s390/kvm/priv.c | 4 +++-
>>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
>>> index 69a824f9ef0b..bbe46c6aedbf 100644
>>> --- a/arch/s390/kvm/priv.c
>>> +++ b/arch/s390/kvm/priv.c
>>> @@ -626,10 +626,12 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
>>>   	 * available for the guest are AQIC and TAPQ with the t bit set
>>>   	 * since we do not set IC.3 (FIII) we currently will only intercept
>>>   	 * the AQIC function code.
>>> +	 * Note: running nested under z/VM can result in intercepts, e.g.
>> s/intercepts/intercepts for other function codes/
>>
>>> +	 * for PQAP(QCI). We do not support this and bail out.
>>>   	 */
>>>   	reg0 = vcpu->run->s.regs.gprs[0];
>>>   	fc = (reg0 >> 24) & 0xff;
>>> -	if (WARN_ON_ONCE(fc != 0x03))
>>> +	if (fc != 0x03)
>>>   		return -EOPNOTSUPP;
>>>   
>>>   	/* PQAP instruction is allowed for guest kernel only */

