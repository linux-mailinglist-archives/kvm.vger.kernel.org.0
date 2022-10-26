Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 676F060E6CC
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 19:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234298AbiJZRwb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 13:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234309AbiJZRwZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 13:52:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A5C0108DDD
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 10:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666806735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=geniLJHmWq3kpgcGVKm4jCdheUxhYshUAvvdO1yrzTQ=;
        b=ZpTEV4cgsSVP+VR8YE55RSluSXq6vh4I+E1yE1h4L9pY9cE+TseMiinFgIK12NqSABPq0G
        XVU1D3LjR5JvXI/frmS2ULsFyR0eLMWPSkSW4I64aguFROyPbnrO1v2KcLK6SV6ONX/07X
        vJtzpJGPTY8ygmugu91VBoJDRSWXiJA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-150-gt_ovwijPu2d9n-Xpi_rBg-1; Wed, 26 Oct 2022 13:52:13 -0400
X-MC-Unique: gt_ovwijPu2d9n-Xpi_rBg-1
Received: by mail-wm1-f69.google.com with SMTP id i67-20020a1c3b46000000b003cf4ff1b917so142870wma.2
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 10:52:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=geniLJHmWq3kpgcGVKm4jCdheUxhYshUAvvdO1yrzTQ=;
        b=wuwTJV/NNTDFzNtiIELLxX70UITTjQ9d2pZtUx7/LaGRAzrbk4xwXWVOLDIYdSaH4/
         p0vmdhWaVO4aYWsFOs7JGtss+qPfsGidNqpzAGFaLxc1YMxPwbpGJ5M8F/egjvcpNjk0
         q7fJ2K6H8oHjZqN7f83kg63kCzz9DYIBrJehjIJ4s9a3XHTGbBhYd8x/g0taIEfvlbUn
         Ph/zjuPk3hD/KPGgjprfmT9tqi8GPc813tLctxzaF7aLAQHI+VURm4yNrdD1kFNo50Kv
         FZxhGFbDzX1Hl10bvTWl056pRILht0GbyaJD4iYIw27esR/hSky6O6I+o+dP8xm1dRtr
         d9uA==
X-Gm-Message-State: ACrzQf22htabq/fHIs6whqMxnZblvqdzKa+awU6xGoM8j4EwYmS/0FJ9
        HGKn08SywfqrV2kstQEOFOJ2wo1rpbR47d/D53IyywJ/lQV+v9dP7Y2HZcte6225ppZRaYClcPy
        CCHQ66oeleugq
X-Received: by 2002:a05:6000:1ac7:b0:232:b68c:9e0 with SMTP id i7-20020a0560001ac700b00232b68c09e0mr30940560wry.54.1666806732597;
        Wed, 26 Oct 2022 10:52:12 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5H8nSmRGc8ubFmwlY72dw0Lzn/Wbclbz9oiRnT7h3ncFdTKq7AZYYBKQFrVTm3HA3Rxq8Ucw==
X-Received: by 2002:a05:6000:1ac7:b0:232:b68c:9e0 with SMTP id i7-20020a0560001ac700b00232b68c09e0mr30940544wry.54.1666806732335;
        Wed, 26 Oct 2022 10:52:12 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id g12-20020a05600c310c00b003b4cba4ef71sm2448055wmo.41.2022.10.26.10.52.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Oct 2022 10:52:11 -0700 (PDT)
Message-ID: <d3e2dd2b-9520-32ef-6785-94164a834adf@redhat.com>
Date:   Wed, 26 Oct 2022 19:52:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Hyper-V VTLs, permission bitmaps and userspace exits (was Re: [PATCH
 0/4] KVM: API to block and resume all running vcpus in a vm)
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221022154819.1823133-1-eesposit@redhat.com>
 <a2e16531-5522-a334-40a1-2b0e17663800@linux.ibm.com>
 <2701ce67-bfff-8c0c-4450-7c4a281419de@redhat.com>
 <384b2622-8d7f-ce02-1452-84a86e3a5697@linux.ibm.com>
 <Y1cVfECAAfmp5XqA@google.com>
 <5a26c107-9ab5-60ee-0e9c-a9955dfe313d@redhat.com>
 <Y1gG/W/q/VIydpMu@google.com>
 <02c910bb-3ea0-fa84-7a1c-92fb9e8b03de@redhat.com>
 <Y1hsHjPuZfrREulV@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y1hsHjPuZfrREulV@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/26/22 01:07, Sean Christopherson wrote:
> I don't think it's realistic to make accesses outside of KVM_RUN go away, e.g.
> see the ARM ITS discussion in the dirty ring thread.  kvm_xen_set_evtchn() also
> explicitly depends on writing guest memory without going through KVM_RUN (and
> apparently can be invoked from a kernel thread?!?).

Yeah, those are the pages that must be considered dirty when using the 
dirty ring.

> In theory, I do actually like the idea of restricting memory access to KVM_RUN,
> but in reality I just think that forcing everything into KVM_RUN creates far more
> problems than it solves.  E.g. my complaint with KVM_REQ_GET_NESTED_STATE_PAGES
> is that instead of syncrhonously telling userspace it has a problem, KVM chugs
> along as if everything is fine and only fails at later point in time.  I doubt
> userspace would actually do anything differently, i.e. the VM is likely hosed no
> matter what, but deferring work adds complexity in KVM and makes it more difficult
> to debug problems when they occur.
>
>>>     - to stop anything else in the system that consumes KVM memslots, e.g. KVM GT
>>
>> Is this true if you only look at the KVM_GET_DIRTY_LOG case and consider it
>> a guest bug to access the memory (i.e. ignore the strange read-only changes
>> which only happen at boot, and which I agree are QEMU-specific)?
> 
> Yes?  I don't know exactly what "the KVM_GET_DIRTY_LOG case" is.

It is not possible to atomically read the dirty bitmap and delete a 
memslot.  When you delete a memslot, the bitmap is gone.  In this case 
however memory accesses to the deleted memslot are a guest bug, so 
stopping KVM-GT would not be necessary.

So while I'm being slowly convinced that QEMU should find a way to pause 
its vCPUs around memslot changes, I'm not sure that pausing everything 
is needed in general.

>>> And because of the nature of KVM, to support this API on all architectures, KVM
>>> needs to make change on all architectures, whereas userspace should be able to
>>> implement a generic solution.
>>
>> Yes, I agree that this is essentially just a more efficient kill().
>> Emanuele, perhaps you can put together a patch to x86/vmexit.c in
>> kvm-unit-tests, where CPU0 keeps changing memslots and the other CPUs are in
>> a for(;;) busy wait, to measure the various ways to do it?
> 
> I'm a bit confused.  Is the goal of this to simplify QEMU, dedup VMM code, provide
> a more performant solution, something else entirely?

Well, a bit of all of them and perhaps that's the problem.  And while 
the issues at hand *are* self-inflicted wounds on part of QEMU, it seems 
to me that the underlying issues are general.

For example, Alex Graf and I looked back at your proposal of a userspace 
exit for "bad" accesses to memory, wondering if it could help with 
Hyper-V VTLs too.  To recap, the "higher privileged" code at VTL1 can 
set up VM-wide restrictions on access to some pages through a hypercall 
(HvModifyVtlProtectionMask).  After the hypercall, VTL0 would not be 
able to access those pages.  The hypercall would be handled in userspace 
and would invoke a KVM_SET_MEMORY_REGION_PERM ioctl to restrict the RWX 
permissions, and this ioctl would set up a VM-wide permission bitmap 
that would be used when building page tables.

Using such a bitmap instead of memslots makes it possible to cause 
userspace vmexits on VTL mapping violations with efficient data 
structures.  And it would also be possible to use this mechanism around 
KVM_GET_DIRTY_LOG, to read the KVM dirty bitmap just before removing a 
memslot.

However, external accesses to the regions (ITS, Xen, KVM-GT, non KVM_RUN 
ioctls) would not be blocked, due to the lack of a way to report the 
exit.  The intersection of these features with VTLs should be very small 
(sometimes zero since VTLs are x86 only), but the ioctls would be a 
problem so I'm wondering what your thoughts are on this.

Also, while the exit API could be the same, it is not clear to me that 
the permission bitmap would be a good match for entirely "void" memslots 
used to work around non-atomic memslot changes.  So for now let's leave 
this aside and only consider the KVM_GET_DIRTY_LOG case.

Paolo

