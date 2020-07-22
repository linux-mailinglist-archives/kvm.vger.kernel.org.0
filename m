Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12336229051
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 08:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbgGVGED (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 02:04:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36916 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726147AbgGVGED (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jul 2020 02:04:03 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06M636xg055475;
        Wed, 22 Jul 2020 02:03:53 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32e11n00vm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Jul 2020 02:03:53 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06M607tC028395;
        Wed, 22 Jul 2020 06:03:51 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 32brq7vk9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Jul 2020 06:03:51 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06M63njV54132912
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jul 2020 06:03:49 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF5A9A4040;
        Wed, 22 Jul 2020 06:03:48 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E93EA404D;
        Wed, 22 Jul 2020 06:03:46 +0000 (GMT)
Received: from [9.199.61.170] (unknown [9.199.61.170])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Jul 2020 06:03:46 +0000 (GMT)
Subject: Re: [v3 02/15] KVM: PPC: Book3S HV: Cleanup updates for kvm vcpu MMCR
To:     Paul Mackerras <paulus@ozlabs.org>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, maddy@linux.vnet.ibm.com,
        Michael Neuling <mikey@neuling.org>, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, ego@linux.vnet.ibm.com, svaidyan@in.ibm.com,
        acme@kernel.org, jolsa@kernel.org
References: <1594996707-3727-1-git-send-email-atrajeev@linux.vnet.ibm.com>
 <1594996707-3727-3-git-send-email-atrajeev@linux.vnet.ibm.com>
 <20200721035420.GA3819606@thinks.paulus.ozlabs.org>
 <B83C440A-1AC4-4737-8AB1-EB9A6B8A474B@linux.vnet.ibm.com>
 <20200722045448.GC3878639@thinks.paulus.ozlabs.org>
From:   Madhavan Srinivasan <maddy@linux.ibm.com>
Message-ID: <cc45ef85-4442-3377-12dd-d4ca22fd7af5@linux.ibm.com>
Date:   Wed, 22 Jul 2020 11:33:45 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200722045448.GC3878639@thinks.paulus.ozlabs.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_02:2020-07-22,2020-07-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 phishscore=0 bulkscore=0 mlxlogscore=721
 priorityscore=1501 spamscore=0 malwarescore=0 clxscore=1011 mlxscore=0
 adultscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007220045
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/22/20 10:24 AM, Paul Mackerras wrote:
> On Wed, Jul 22, 2020 at 07:39:26AM +0530, Athira Rajeev wrote:
>>
>>> On 21-Jul-2020, at 9:24 AM, Paul Mackerras <paulus@ozlabs.org> wrote:
>>>
>>> On Fri, Jul 17, 2020 at 10:38:14AM -0400, Athira Rajeev wrote:
>>>> Currently `kvm_vcpu_arch` stores all Monitor Mode Control registers
>>>> in a flat array in order: mmcr0, mmcr1, mmcra, mmcr2, mmcrs
>>>> Split this to give mmcra and mmcrs its own entries in vcpu and
>>>> use a flat array for mmcr0 to mmcr2. This patch implements this
>>>> cleanup to make code easier to read.
>>> Changing the way KVM stores these values internally is fine, but
>>> changing the user ABI is not.  This part:
>>>
>>>> diff --git a/arch/powerpc/include/uapi/asm/kvm.h b/arch/powerpc/include/uapi/asm/kvm.h
>>>> index 264e266..e55d847 100644
>>>> --- a/arch/powerpc/include/uapi/asm/kvm.h
>>>> +++ b/arch/powerpc/include/uapi/asm/kvm.h
>>>> @@ -510,8 +510,8 @@ struct kvm_ppc_cpu_char {
>>>>
>>>> #define KVM_REG_PPC_MMCR0	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0x10)
>>>> #define KVM_REG_PPC_MMCR1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0x11)
>>>> -#define KVM_REG_PPC_MMCRA	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0x12)
>>>> -#define KVM_REG_PPC_MMCR2	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0x13)
>>>> +#define KVM_REG_PPC_MMCR2	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0x12)
>>>> +#define KVM_REG_PPC_MMCRA	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0x13)
>>> means that existing userspace programs that used to work would now be
>>> broken.  That is not acceptable (breaking the user ABI is only ever
>>> acceptable with a very compelling reason).  So NAK to this part of the
>>> patch.
>> Hi Paul
>>
>> Thanks for checking the patch. I understood your point on user ABI breakage that this particular change can cause.
>> I will retain original KVM_REG_PPC_MMCRA and KVM_REG_PPC_MMCR2 order in `kvm.h`
>> And with that, additionally I will need below change ( on top of current patch ) for my clean up updates for kvm cpu MMCR to work,
>> Because now mmcra and mmcrs will have its own entries in vcpu and is not part of the mmcr[] array
>> Please suggest if this looks good
> Yes, that looks fine.
>
> By the way, is the new MMCRS register here at all related to the MMCRS
Hi Paul,

We have only split the current array (mmcr[]) and separated it to mmcra 
and mmcrs.
Only new spr that is added is mmcr3 (for Power10).

Maddy

> that there used to be on POWER8, but which wasn't present (as far as I
> know) on POWER9?
>
> Paul.

