Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C4F3FD4C1
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 09:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242830AbhIAHu1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 03:50:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43613 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242780AbhIAHu0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Sep 2021 03:50:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630482569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QVyzY7plwjcHWFuBExDhEE+9lobSCXwllAQa8rm7VKg=;
        b=cMQqSNYWSfMIN0pWDgqb7WYYr9Dm1ifhyJ1/k4Lb01Z6oRyL1EBvVS5Gyi3GBbPYlH2vpD
        k1edxDVk3NfpO0ZmMLBqy6/tnlb5r3XEItMQP25TV9NWpz1kycWmZmkId9YmqgbF5W2C7u
        VxNrxptGjXecn8BsdEQgyaZII/QBhz4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-IXmRUQ4uMBeiw1WhOo_Vlg-1; Wed, 01 Sep 2021 03:49:27 -0400
X-MC-Unique: IXmRUQ4uMBeiw1WhOo_Vlg-1
Received: by mail-wr1-f72.google.com with SMTP id q14-20020a5d574e000000b00157b0978ddeso501534wrw.5
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 00:49:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=QVyzY7plwjcHWFuBExDhEE+9lobSCXwllAQa8rm7VKg=;
        b=V9J+S+nLHe2hzdaQzE4KrgEBjvMH7zwLTHKgHjT+QcrI0jXYLn1e1Vw8vs1Qo8a45Q
         ltdzib2RbUMdGntQmZ6ik2jrlkorSPlpR72qk/GPbm72+JIli16+ZMOkZpTF5VzmvMFS
         Z9redlCwzkQ37XG4I6HL9ZbJoGB47hjm62M2X36UyXhMBG3WSzVMKRyjPMmVdfEqq9Hk
         Fbv9ZFJpXKppbQkXB5jRWxb97rmR9nl8WLxgFts6IYdEMrZjOI7aviWc2e5zLzIIhXy5
         7sGdDsdLIzjt46YDMXVozyz/MlbdRyVOSmHjQnhZmYVI5CYrlWgqPFQ+XQeJCLcGSACE
         3xwA==
X-Gm-Message-State: AOAM531BhMBX7puv+fJzR/Ji7yV6TofVql0+LBTsEIIAsTUTFmuQPq6K
        uhQcr5dq2MSoiwx7xGOE6s0WZ67jwHDFrGLq5aGv/sDcxlClTZD7KmlbSqBjkh8MlRmuIQqkcXJ
        n6iOk5eGh5O4y
X-Received: by 2002:adf:e702:: with SMTP id c2mr35401825wrm.397.1630482566710;
        Wed, 01 Sep 2021 00:49:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwcDFTNqPQv4PA+mv40IOil7uYNBfULQ1hV01psnoZhed1wBFZsx6IbJrJ8es3otfAeEglN1A==
X-Received: by 2002:adf:e702:: with SMTP id c2mr35401803wrm.397.1630482566458;
        Wed, 01 Sep 2021 00:49:26 -0700 (PDT)
Received: from [192.168.3.132] (p4ff23f71.dip0.t-ipconnect.de. [79.242.63.113])
        by smtp.gmail.com with ESMTPSA id e26sm21532884wrc.6.2021.09.01.00.49.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 00:49:26 -0700 (PDT)
Subject: Re: [RFC] KVM: mm: fd-based approach for supporting KVM guest private
 memory
To:     Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>,
        Andi Kleen <ak@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Dario Faggioli <dfaggioli@suse.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-mm@kvack.org, linux-coco@lists.linux.dev,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
References: <20210824005248.200037-1-seanjc@google.com>
 <307d385a-a263-276f-28eb-4bc8dd287e32@redhat.com>
 <YSlkzLblHfiiPyVM@google.com>
 <61ea53ce-2ba7-70cc-950d-ca128bcb29c5@redhat.com>
 <ccff0e92-ee24-48e3-ab1f-85a253bb787c@www.fastmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <db9b12c1-ba10-879c-61fb-9f711eafaf73@redhat.com>
Date:   Wed, 1 Sep 2021 09:49:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <ccff0e92-ee24-48e3-ab1f-85a253bb787c@www.fastmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01.09.21 06:58, Andy Lutomirski wrote:
> On Tue, Aug 31, 2021, at 12:07 PM, David Hildenbrand wrote:
>> On 28.08.21 00:18, Sean Christopherson wrote:
>>> On Thu, Aug 26, 2021, David Hildenbrand wrote:
>>>> You'll end up with a VMA that corresponds to the whole file in a single
>>>> process only, and that cannot vanish, not even in parts.
>>>
>>> How would userspace tell the kernel to free parts of memory that it doesn't want
>>> assigned to the guest, e.g. to free memory that the guest has converted to
>>> not-private?
>>
>> I'd guess one possibility could be fallocate(FALLOC_FL_PUNCH_HOLE).
>>
>> Questions are: when would it actually be allowed to perform such a
>> destructive operation? Do we have to protect from that? How would KVM
>> protect from user space replacing private pages by shared pages in any
>> of the models we discuss?
>>
> 
> What do you mean?  If userspace maliciously replaces a shared page by a private page, then the guest crashes.

Assume we have private pages in a fd and fallocate(FALLOC_FL_PUNCH_HOLE) 
random pages the guest is still using. If we "only" crash the guest, 
everything is fine.

> 
> (The actual meaning here is a bit different on SNP-ES vs TDX.  In SNP-ES, a given GPA can be shared, private, or nonexistent.  A guest accesses it with a special bit set in the guest page tables to indicate whether it expects shared or private, and the CPU will produce an appropriate error if the bit doesn't match the page.

Rings a bell, thanks for reminding me.

  In TDX, there is actually an entirely separate shared vs private 
address space, and, in theory, a given "GPA" can exist as shared and as 
private at once.  The full guest n-bit GPA plus the shared/private bit 
is logically an N+1 bit address, and it's possible to map all of it at 
once, half shared, and half private.  In practice, the defined 
guest->host APIs don't really support that usage.

Thanks, that explains a lot.

-- 
Thanks,

David / dhildenb

