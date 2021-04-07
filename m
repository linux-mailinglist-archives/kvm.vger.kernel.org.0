Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 397ED356D57
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 15:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245054AbhDGNbq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 09:31:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57852 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233670AbhDGNbo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Apr 2021 09:31:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617802294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vJkU8vXKb0BvHUAPz+V+eKFMW3IPbu7jFAYroR0o//I=;
        b=OVw8NT8eMl4rnBBcv48FPWN+G4RZOoZyMMAgU2KwCrt2sLnPF2brirOIvXVOZ746wRozWr
        2hIA3JOEbiOCEw2rccVmpeiRCJfekm/XopjWIvV09GniyK/sR/JYCiUQVENuK6OD28cYbv
        Is9REIsmgyo72h73ugwKbDTersCybN8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-jBECpXWJPBSHmLVPViWpJw-1; Wed, 07 Apr 2021 09:31:33 -0400
X-MC-Unique: jBECpXWJPBSHmLVPViWpJw-1
Received: by mail-wr1-f72.google.com with SMTP id y14so1757543wro.23
        for <kvm@vger.kernel.org>; Wed, 07 Apr 2021 06:31:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=vJkU8vXKb0BvHUAPz+V+eKFMW3IPbu7jFAYroR0o//I=;
        b=Sn4kTDJHMltMVYf2xFsv7U7sAlWB4syNA+lh6Qimj2eb3O+eyYDAzYl/sJLumlDdhF
         4A9TTF7Zaq80p4esDsQnxumC6kCbluZ4xl3mkJLPCbIwfUncG2eoDmCc2PdHSljLWFNR
         812VqyXKu9QE2mnc7E3eBCuRrRxj7klgIAGKFwEeYQp4w2cxBQAw1Axbn0nJMtEmKWiP
         lCj22wcmbqm8T1NtOb29SYf5nqO+eRaYN9ocmw4/7NVZspdJri5sHjExZRcf5NJEDyI4
         2ad+4Vp4C2kLeyRrU3uHw9rz43zkcaGKb6PzWBriD/YIjRq9LKw2AUBsw0jHB5o8ItlS
         EjcQ==
X-Gm-Message-State: AOAM5312HUmiLyVYI2RQ0hHCZN9qiO71eMj2ZWaXP0jWf42akt2Dcbj0
        /G4HMuLoOkCnDOxr1QlNS+TsDSywoDzDiDji714Qy6/7T2prQvMtkqND2K2TFHElZtojxicDBTF
        AC6QcjVQcdhaE
X-Received: by 2002:adf:fd0b:: with SMTP id e11mr550469wrr.347.1617802290841;
        Wed, 07 Apr 2021 06:31:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzwq628wJtz5+hwuBUC2lqHMaUJJqHRIwbBPct9QaQxXpt5xT0WtUpxxEbEiXll2GkmWiz0Pg==
X-Received: by 2002:adf:fd0b:: with SMTP id e11mr550429wrr.347.1617802290484;
        Wed, 07 Apr 2021 06:31:30 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:466:71c0:99e0:ccd6:fcea:5668? ([2a01:e0a:466:71c0:99e0:ccd6:fcea:5668])
        by smtp.gmail.com with ESMTPSA id u17sm7339826wmq.3.2021.04.07.06.31.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Apr 2021 06:31:30 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [RFCv1 7/7] KVM: unmap guest memory using poisoned pages
From:   Christophe de Dinechin <cdupontd@redhat.com>
In-Reply-To: <20210407131647.djajbwhqsmlafsyo@box.shutemov.name>
Date:   Wed, 7 Apr 2021 15:31:28 +0200
Cc:     David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C841A818-7BBE-48B5-8CCB-1F8850CA52AD@redhat.com>
References: <20210402152645.26680-1-kirill.shutemov@linux.intel.com>
 <20210402152645.26680-8-kirill.shutemov@linux.intel.com>
 <c5f2580d-0733-4523-d1e8-c43b487f0aaf@redhat.com>
 <52518f09-7350-ebe9-7ddb-29095cd3a4d9@intel.com>
 <d94d3042-098a-8df7-9ef6-b869851a4134@redhat.com>
 <20210407131647.djajbwhqsmlafsyo@box.shutemov.name>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 7 Apr 2021, at 15:16, Kirill A. Shutemov <kirill@shutemov.name> =
wrote:
>=20
> On Tue, Apr 06, 2021 at 04:57:46PM +0200, David Hildenbrand wrote:
>> On 06.04.21 16:33, Dave Hansen wrote:
>>> On 4/6/21 12:44 AM, David Hildenbrand wrote:
>>>> On 02.04.21 17:26, Kirill A. Shutemov wrote:
>>>>> TDX architecture aims to provide resiliency against =
confidentiality and
>>>>> integrity attacks. Towards this goal, the TDX architecture helps =
enforce
>>>>> the enabling of memory integrity for all TD-private memory.
>>>>>=20
>>>>> The CPU memory controller computes the integrity check value (MAC) =
for
>>>>> the data (cache line) during writes, and it stores the MAC with =
the
>>>>> memory as meta-data. A 28-bit MAC is stored in the ECC bits.
>>>>>=20
>>>>> Checking of memory integrity is performed during memory reads. If
>>>>> integrity check fails, CPU poisones cache line.
>>>>>=20
>>>>> On a subsequent consumption (read) of the poisoned data by =
software,
>>>>> there are two possible scenarios:
>>>>>=20
>>>>>   - Core determines that the execution can continue and it treats
>>>>>     poison with exception semantics signaled as a #MCE
>>>>>=20
>>>>>   - Core determines execution cannot continue,and it does an =
unbreakable
>>>>>     shutdown
>>>>>=20
>>>>> For more details, see Chapter 14 of Intel TDX Module EAS[1]
>>>>>=20
>>>>> As some of integrity check failures may lead to system shutdown =
host
>>>>> kernel must not allow any writes to TD-private memory. This =
requirment
>>>>> clashes with KVM design: KVM expects the guest memory to be mapped =
into
>>>>> host userspace (e.g. QEMU).
>>>>=20
>>>> So what you are saying is that if QEMU would write to such memory, =
it
>>>> could crash the kernel? What a broken design.
>>>=20
>>> IMNHO, the broken design is mapping the memory to userspace in the =
first
>>> place.  Why the heck would you actually expose something with the =
MMU to
>>> a context that can't possibly meaningfully access or safely write to =
it?
>>=20
>> I'd say the broken design is being able to crash the machine via a =
simple
>> memory write, instead of only crashing a single process in case =
you're doing
>> something nasty. =46rom the evaluation of the problem it feels like =
this was a
>> CPU design workaround: instead of properly cleaning up when it gets =
tricky
>> within the core, just crash the machine. And that's a CPU "feature", =
not a
>> kernel "feature". Now we have to fix broken HW in the kernel - once =
again.
>>=20
>> However, you raise a valid point: it does not make too much sense to =
to map
>> this into user space. Not arguing against that; but crashing the =
machine is
>> just plain ugly.
>>=20
>> I wonder: why do we even *want* a VMA/mmap describing that memory? =
Sounds
>> like: for hacking support for that memory type into QEMU/KVM.
>>=20
>> This all feels wrong, but I cannot really tell how it could be =
better. That
>> memory can really only be used (right now?) with hardware =
virtualization
>> from some point on. =46rom that point on (right from the start?), =
there should
>> be no VMA/mmap/page tables for user space anymore.
>>=20
>> Or am I missing something? Is there still valid user space access?
>=20
> There is. For IO (e.g. virtio) the guest mark a range of memory as =
shared
> (or unencrypted for AMD SEV). The range is not pre-defined.
>=20
>>> This started with SEV.  QEMU creates normal memory mappings with the =
SEV
>>> C-bit (encryption) disabled.  The kernel plumbs those into NPT, but =
when
>>> those are instantiated, they have the C-bit set.  So, we have =
mismatched
>>> mappings.  Where does that lead?  The two mappings not only differ =
in
>>> the encryption bit, causing one side to read gibberish if the other
>>> writes: they're not even cache coherent.
>>>=20
>>> That's the situation *TODAY*, even ignoring TDX.
>>>=20
>>> BTW, I'm pretty sure I know the answer to the "why would you expose =
this
>>> to userspace" question: it's what QEMU/KVM did alreadhy for
>>> non-encrypted memory, so this was the quickest way to get SEV =
working.
>>>=20
>>=20
>> Yes, I guess so. It was the fastest way to "hack" it into QEMU.
>>=20
>> Would we ever even want a VMA/mmap/process page tables for that =
memory? How
>> could user space ever do something *not so nasty* with that memory =
(in the
>> current context of VMs)?
>=20
> In the future, the memory should be still managable by host MM: =
migration,
> swapping, etc. But it's long way there. For now, the guest memory
> effectively pinned on the host.

Is there even a theoretical way to restore an encrypted page e.g. from =
(host)
swap without breaking the integrity check? Or will that only be possible =
with
assistance from within the encrypted enclave?


>=20
> --=20
> Kirill A. Shutemov
>=20

