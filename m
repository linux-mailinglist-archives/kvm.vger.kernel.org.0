Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0A7C09A0
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 18:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbfI0Qcc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 12:32:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33686 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727079AbfI0Qcb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 12:32:31 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0537164467
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 16:32:31 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id t11so1351723wrq.19
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 09:32:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4WlJQsnJmPowxiwAQgETx3txgUOU2LzAC2VB3pxuUFs=;
        b=MZ3IeIRY0ieUCFRzXlcLIO+qz+yRZCo/vdoUfpH3Jlnj7tVuMCwDlEw1R6a0v7Sjvv
         zRu5nb0Rpv1jHKxNEhuhuJ2bm9YvkK0OBzI89rUbVadyTvUJLdrrMd/DSNNWjDml35gu
         +Bn4fkGVe3DLLDC51ON5k3yUhIPYP4J8nIEzxC+68lDYqIZ7JnnHU8H1+0YSkfRd/TRO
         7++UordpUDTedwFPzvRTVz7eCwJUosXjGvgLhRa5Mzhm33L2k55YlucPlDcJHmY9G7eu
         WEKohDJA7n7952kEWwmqIGPf+9lzcY+hKeO9e3NKQ/KJKLi0+yZiWSBuShKYnH1rDdsc
         INpQ==
X-Gm-Message-State: APjAAAU5TdIa73S2+xWFWQo0rQWXOf1FpwgpZzUq+OKngPxi7gNMQVO8
        2Hr7737pssjAopn5K+ljaitBtxuA0roLBAD7oIhe5YqpstJ99uK0fbQxcDs6Gu9smeh+aBL5Ed/
        uQ82E4UCE8E0o
X-Received: by 2002:a5d:574f:: with SMTP id q15mr3631156wrw.362.1569601949659;
        Fri, 27 Sep 2019 09:32:29 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxYo+UxDEjiUQ9i9EvFTaGaadbqxwAvhQ1WcjJfjHaX0IgVIWNutdoHxQ6zwo3fEHoIqg0SWQ==
X-Received: by 2002:a5d:574f:: with SMTP id q15mr3631141wrw.362.1569601949391;
        Fri, 27 Sep 2019 09:32:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id d9sm5157450wrc.44.2019.09.27.09.32.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Sep 2019 09:32:28 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: Add Intel PMU MSRs to msrs_to_save[]
To:     Jim Mattson <jmattson@google.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        Eric Hankland <ehankland@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
References: <8907173e-9f27-6769-09fc-0b82c22d6352@oracle.com>
 <CALMp9eSkognb2hJSuENK+5PSgE8sYzQP=4ioERge6ZaFg1=PEA@mail.gmail.com>
 <cb7c570c-389c-2e96-ba46-555218ba60ed@oracle.com>
 <CALMp9eQULvr5wKt1Aw3MR+tbeNgvA_4p__6n1YTkWjMHCaEmLw@mail.gmail.com>
 <CALMp9eS1fUVcnVHhty60fUgk3-NuvELMOUFqQmqPLE-Nqy0dFQ@mail.gmail.com>
 <56e7fad0-d577-41db-0b81-363975dc2ca7@redhat.com>
 <87ftkh6e19.fsf@vitty.brq.redhat.com>
 <6e6f46fe-6e11-c5e3-d80c-327f77b91907@redhat.com>
 <87d0fl6bv4.fsf@vitty.brq.redhat.com>
 <19db28c0-375a-7bc0-7151-db566ae85de6@redhat.com>
 <20190927152608.GC25513@linux.intel.com>
 <87a7ap68st.fsf@vitty.brq.redhat.com>
 <59934fa75540d493dabade5a3e66b7ed159c4aae.camel@intel.com>
 <e4a17cfb-8172-9ad8-7010-ee860c4898bf@redhat.com>
 <CALMp9eQcHbm6nLAQ_o8dS4B+2k6B0eHxuGvv6Ls_-HL9PC4mhQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <11f63bd6-50cc-a6ce-7a36-a6e1a4d8c5e9@redhat.com>
Date:   Fri, 27 Sep 2019 18:32:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQcHbm6nLAQ_o8dS4B+2k6B0eHxuGvv6Ls_-HL9PC4mhQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/09/19 18:10, Jim Mattson wrote:
> On Fri, Sep 27, 2019 at 9:06 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 27/09/19 17:58, Xiaoyao Li wrote:
>>> Indeed, "KVM_GET_MSR_INDEX_LIST" returns the guest msrs that KVM supports and
>>> they are free from different guest configuration since they're initialized when
>>> kvm module is loaded.
>>>
>>> Even though some MSRs are not exposed to guest by clear their related cpuid
>>> bits, they are still saved/restored by QEMU in the same fashion.
>>>
>>> I wonder should we change "KVM_GET_MSR_INDEX_LIST" per VM?
>>
>> We can add a per-VM version too, yes.

There is one problem with that: KVM_SET_CPUID2 is a vCPU ioctl, not a VM
ioctl.

> Should the system-wide version continue to list *some* supported MSRs
> and *some* unsupported MSRs, with no rhyme or reason? Or should we
> codify what that list contains?

The optimal thing would be for it to list only MSRs that are
unconditionally supported by all VMs and are part of the runtime state.
 MSRs that are not part of the runtime state, such as the VMX
capabilities, should be returned by KVM_GET_MSR_FEATURE_INDEX_LIST.

This also means that my own commit 95c5c7c77c06 ("KVM: nVMX: list VMX
MSRs in KVM_GET_MSR_INDEX_LIST", 2019-07-02) was incorrect.
Unfortunately, that commit was done because userspace (QEMU) has a
genuine need to detect whether KVM is new enough to support the
IA32_VMX_VMFUNC MSR.

Perhaps we can make all MSRs supported unconditionally if
host_initiated.  For unsupported performance counters it's easy to make
them return 0, and allow setting them to 0, if host_initiated (BTW, how
did you pick 32?  is there any risk of conflicts with other MSRs?).

I'm not sure of the best set of values to allow for VMX caps, especially
with the default0/default1 stuff going on for execution controls.  But
perhaps that would be the simplest thing to do.

One possibility would be to make a KVM_GET_MSR_INDEX_LIST variant that
is a system ioctl and takes a CPUID vector.  I'm worried that it would
be tedious to get right and hardish to keep correct---so I'm not sure
it's a good idea.

Paolo
