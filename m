Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E93D450443
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 13:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbhKOMUF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 07:20:05 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11238 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231329AbhKOMUB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Nov 2021 07:20:01 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AFAxUCu022822;
        Mon, 15 Nov 2021 12:16:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=FGzXDLCIzbaoG6sA4ktZGlkzV+djpIiRQi2B3Z+NZpU=;
 b=VkmEBZBwPQVnrCbrtLJb8LuBfFST5QxmvLrYBaM72yIcJNpUAlxoqB+W1Gq1748d2HFm
 2zdB31SnbilqF1+4UBGMFY2+14xwMPfy5oGyW/zIJb9uBGlkXWZ1F3d3c55WYUZYv4d6
 i4r5BTucQ1+7dHZBCnx/FB7zB6oNuzgxiE0ZpB0ClRIXL0vDf85TPvX2I0JEkhWrc0lM
 ub8VOO17c5lsBAandpfVJ07IxsLkWsFcc5nPByXLXcozU2JnYJSc5Lfevpuq8dkEPdaQ
 a3v0oqKymdSBjCInG7CRu/LeRk1s2S6iwQWKhr/JGatmWJ2rbt6kZ5s0x3k605lsK4/U eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cbcw1ce98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 12:16:18 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AFC0I4n005497;
        Mon, 15 Nov 2021 12:16:17 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cbcw1ce8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 12:16:17 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AFCDkOB002455;
        Mon, 15 Nov 2021 12:16:14 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3ca509mh6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 12:16:14 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AFC9Lml64815552
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Nov 2021 12:09:21 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2429F42049;
        Mon, 15 Nov 2021 12:16:12 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E5E442042;
        Mon, 15 Nov 2021 12:16:11 +0000 (GMT)
Received: from [9.171.56.111] (unknown [9.171.56.111])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 15 Nov 2021 12:16:11 +0000 (GMT)
Message-ID: <b581f056-e7ea-befa-8c13-50644105c042@de.ibm.com>
Date:   Mon, 15 Nov 2021 13:16:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 0/5] KVM: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS and
 re-purpose it on x86
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20211111162746.100598-1-vkuznets@redhat.com>
 <4a3c7be7-12fa-6e47-64eb-02e6c5be5dbc@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <4a3c7be7-12fa-6e47-64eb-02e6c5be5dbc@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4GM4n7HdUC8wY57Y8aQbGHZR4IYkcALh
X-Proofpoint-ORIG-GUID: 8BYV8Df_CMNWb7XWAnYRT1TEmZU4UwBJ
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-15_10,2021-11-15_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1011
 priorityscore=1501 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111150067
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 11.11.21 um 17:32 schrieb Paolo Bonzini:
> On 11/11/21 17:27, Vitaly Kuznetsov wrote:
>> This is a comtinuation of "KVM: x86: Drop arbitraty KVM_SOFT_MAX_VCPUS"
>> (https://lore.kernel.org/kvm/20211111134733.86601-1-vkuznets@redhat.com/)
>> work.
>>
>> 1) Enforce KVM_CAP_NR_VCPUS <= KVM_CAP_MAX_VCPUS rule on all
>>   architectures. [Sean Christopherson]
>> 2) Make KVM_CAP_NR_VCPUS return num_online_cpus() and not an arbitrary
>>   value of '710' on x86.
>>
>> Everything but x86 was only 'eyeball tested', the change is trivial
>> but sorry in advance if I screwed up)
> 
> Christian, can you look at this for s390?  Returning a fixed value seems wrong for KVM_CAP_NR_VCPUS.

will do. (Sorry I was OOO the last days).
> 
> Thanks,
> 
> Paolo
> 
>> Vitaly Kuznetsov (5):
>>    KVM: arm64: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
>>    KVM: MIPS: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
>>    KVM: PPC: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
>>    KVM: RISC-V: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
>>    KVM: x86: Drop arbitraty KVM_SOFT_MAX_VCPUS
>>
>>   arch/arm64/kvm/arm.c            | 7 ++++++-
>>   arch/mips/kvm/mips.c            | 2 +-
>>   arch/powerpc/kvm/powerpc.c      | 4 ++--
>>   arch/riscv/kvm/vm.c             | 2 +-
>>   arch/x86/include/asm/kvm_host.h | 1 -
>>   arch/x86/kvm/x86.c              | 2 +-
>>   6 files changed, 11 insertions(+), 7 deletions(-)
>>
> 
