Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 712E7E22E5
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 20:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390965AbfJWS4v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Oct 2019 14:56:51 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59486 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389752AbfJWS4v (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Oct 2019 14:56:51 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9NIqq4b099731
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2019 14:56:49 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vtt20drug-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2019 14:56:48 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Wed, 23 Oct 2019 19:56:46 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 23 Oct 2019 19:56:41 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9NIueRo50331650
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Oct 2019 18:56:40 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78C6B42042;
        Wed, 23 Oct 2019 18:56:40 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A1714203F;
        Wed, 23 Oct 2019 18:56:39 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.155.180])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Oct 2019 18:56:39 +0000 (GMT)
Subject: Re: [PATCH v2 00/15] KVM: Dynamically size memslot arrays
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Marc Zyngier <Marc.Zyngier@arm.com>
References: <20191022003537.13013-1-sean.j.christopherson@intel.com>
 <15624ac3-6a43-29c8-8d07-23779454f9e6@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 syiRa+UVlsKmx1hsEg==
Date:   Wed, 23 Oct 2019 20:56:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <15624ac3-6a43-29c8-8d07-23779454f9e6@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19102318-0012-0000-0000-0000035C4D54
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102318-0013-0000-0000-000021977CFF
Message-Id: <814cf967-507b-2070-a4f6-7f0a3474e444@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-23_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910230175
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 22.10.19 15:59, Paolo Bonzini wrote:
> On 22/10/19 02:35, Sean Christopherson wrote:
>> The end goal of this series is to dynamically size the memslot array so
>> that KVM allocates memory based on the number of memslots in use, as
>> opposed to unconditionally allocating memory for the maximum number of
>> memslots.  On x86, each memslot consumes 88 bytes, and so with 2 address
>> spaces of 512 memslots, each VM consumes ~90k bytes for the memslots.
>> E.g. given a VM that uses a total of 30 memslots, dynamic sizing reduces
>> the memory footprint from 90k to ~2.6k bytes.
>>
>> The changes required to support dynamic sizing are relatively small,
>> e.g. are essentially contained in patches 12/13 and 13/13.  Patches 1-11
>> clean up the memslot code, which has gotten quite crusy, especially
>> __kvm_set_memory_region().  The clean up is likely not strictly necessary
>> to switch to dynamic sizing, but I didn't have a remotely reasonable
>> level of confidence in the correctness of the dynamic sizing without first
>> doing the clean up.
>>
>> Testing, especially non-x86 platforms, would be greatly appreciated.  The
>> non-x86 changes are for all intents and purposes untested, e.g. I compile
>> tested pieces of the code by copying them into x86, but that's it.  In
>> theory, the vast majority of the functional changes are arch agnostic, in
>> theory...
>>
>> v2:
>>   - Split "Drop kvm_arch_create_memslot()" into three patches to move
>>     minor functional changes to standalone patches [Janosch].
>>   - Rebase to latest kvm/queue (f0574a1cea5b, "KVM: x86: fix ...")
>>   - Collect an Acked-by and a Reviewed-by
>>
>> Sean Christopherson (15):
>>   KVM: Reinstall old memslots if arch preparation fails
>>   KVM: Don't free new memslot if allocation of said memslot fails
>>   KVM: PPC: Move memslot memory allocation into prepare_memory_region()
>>   KVM: x86: Allocate memslot resources during prepare_memory_region()
>>   KVM: Drop kvm_arch_create_memslot()
>>   KVM: Explicitly free allocated-but-unused dirty bitmap
>>   KVM: Refactor error handling for setting memory region
>>   KVM: Move setting of memslot into helper routine
>>   KVM: Move memslot deletion to helper function
>>   KVM: Simplify kvm_free_memslot() and all its descendents
>>   KVM: Clean up local variable usage in __kvm_set_memory_region()
>>   KVM: Provide common implementation for generic dirty log functions
>>   KVM: Ensure validity of memslot with respect to kvm_get_dirty_log()
>>   KVM: Terminate memslot walks via used_slots
>>   KVM: Dynamically size memslot array based on number of used slots
>>
>>  arch/mips/include/asm/kvm_host.h      |   2 +-
>>  arch/mips/kvm/mips.c                  |  68 +---
>>  arch/powerpc/include/asm/kvm_ppc.h    |  14 +-
>>  arch/powerpc/kvm/book3s.c             |  22 +-
>>  arch/powerpc/kvm/book3s_hv.c          |  36 +-
>>  arch/powerpc/kvm/book3s_pr.c          |  20 +-
>>  arch/powerpc/kvm/booke.c              |  17 +-
>>  arch/powerpc/kvm/powerpc.c            |  13 +-
>>  arch/s390/include/asm/kvm_host.h      |   2 +-
>>  arch/s390/kvm/kvm-s390.c              |  21 +-
>>  arch/x86/include/asm/kvm_page_track.h |   3 +-
>>  arch/x86/kvm/page_track.c             |  15 +-
>>  arch/x86/kvm/x86.c                    | 100 ++---
>>  include/linux/kvm_host.h              |  48 +--
>>  virt/kvm/arm/arm.c                    |  47 +--
>>  virt/kvm/arm/mmu.c                    |  18 +-
>>  virt/kvm/kvm_main.c                   | 546 ++++++++++++++++----------
>>  17 files changed, 467 insertions(+), 525 deletions(-)
>>
> 
> Christian, Marc, Paul, can you help testing patches 1-13?

I see no obvious breakage on s390, but I will do some more testing in the next days.

