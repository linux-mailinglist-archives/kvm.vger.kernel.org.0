Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03FB922E959
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 11:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgG0Jnf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 05:43:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35625 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726315AbgG0Jnf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jul 2020 05:43:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595843013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uGcI5xsgsbptuVoEY3MeSgaMk9etfElSCP7nQow4UW0=;
        b=XQbvTqimtke4n8yY0Rqzj+ZFDrxtwr1CktDh6K0vquh6wT9smatImDZrCOP8mb1HF+0b5b
        3a/COop75q4qPeJF+8Ua86cypUWMB5d7GMFfW1lib9LOiJ4PObpFbA9kOK40h5vWfzJwa5
        P4SXj/Enz5E6EQZYyHWCuk9y0hZhPHw=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-mA9eNvMwN9W5FrJHH9zNPQ-1; Mon, 27 Jul 2020 05:43:31 -0400
X-MC-Unique: mA9eNvMwN9W5FrJHH9zNPQ-1
Received: by mail-ej1-f69.google.com with SMTP id cf15so5826839ejb.6
        for <kvm@vger.kernel.org>; Mon, 27 Jul 2020 02:43:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=uGcI5xsgsbptuVoEY3MeSgaMk9etfElSCP7nQow4UW0=;
        b=Edrsmw+oLaLOTvUzhgFQWw5d11Hpjwyv5RYKtqHRfxNz62tukGBo/OS1Z36uw53x9T
         MoPPslfZ8qMg1J0rHCeAHfabJM/u8U5Dedw4QtuQwvpE3XVH+SXYxEsxCAcKGIpdGXZ0
         j+KsSn5ehpoDm6ieOiqBD3sQojB/SvCMzj3JJZBCmh0IbaqaBh6+bL8gkyTM3WWTyuYC
         CnZWYXA5Bo/ye9rQwbWVkSaD5buM4JbqnKwwbwyTN/zRpMe3JllFB8E7BSMlYLHosbJk
         3OkUjz4NnzWskKuPvCZvZy+nnerstPDXcBcPfb7wbpN3TxcntSqb6ZT33E1lpLMWxEmB
         C+4Q==
X-Gm-Message-State: AOAM533KiSP3dFNOn5tUx3uohEt7w4YGw1TcTDkuCGvxE6fqG7HVOKcE
        Htc/nUuNwxHlyxKOHedPFsqZSCyPTTGc8zCjzNQhMHk2yn3gnhhLhTYXD+UUmkD9kOhciIEx6b6
        8CfmG0BQML58n
X-Received: by 2002:a17:906:1b0a:: with SMTP id o10mr11678419ejg.463.1595843010595;
        Mon, 27 Jul 2020 02:43:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy9tvKTj/kb1GyOaj3xu24e0KLBqXPQgMQABhmNBEQIj6+g9/iVtSxPNo+nkTWpqwMLGeIGTA==
X-Received: by 2002:a17:906:1b0a:: with SMTP id o10mr11678406ejg.463.1595843010409;
        Mon, 27 Jul 2020 02:43:30 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id b17sm6755564ejc.82.2020.07.27.02.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 02:43:29 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, sean.j.christopherson@intel.com,
        pbonzini@redhat.com
Subject: Re: [PATCH] KVM: x86: Fill in conforming {vmx|svm}_x86_ops and {vmx|svm}_nested_ops via macros
In-Reply-To: <411a1f85-6de8-8167-a861-12edb2bc0e35@oracle.com>
References: <1595543518-72310-1-git-send-email-krish.sadhukhan@oracle.com> <87zh7on6pb.fsf@vitty.brq.redhat.com> <411a1f85-6de8-8167-a861-12edb2bc0e35@oracle.com>
Date:   Mon, 27 Jul 2020 11:43:29 +0200
Message-ID: <87sgddmgxq.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Krish Sadhukhan <krish.sadhukhan@oracle.com> writes:

> On 7/24/20 10:50 AM, Vitaly Kuznetsov wrote:
>> Krish Sadhukhan <krish.sadhukhan@oracle.com> writes:
>>
>>> There is no functional change. Just the names of the implemented functions in
>>> KVM and SVM modules have been made conformant to the kvm_x86_ops and
>>> kvm_x86_nested_ops structures, by using macros. This will help in better
>>> readability and maintenance of the code.
>>>
>>>
>>> [PATCH] KVM: x86: Fill in conforming {vmx|svm}_x86_ops and
>>>
>>> [root@nsvm-sadhukhan linux]# /root/Tools/git-format-patch.sh dcb7fd8
>>>   arch/x86/include/asm/kvm_host.h |  12 +-
>>>   arch/x86/kvm/svm/avic.c         |   4 +-
>>>   arch/x86/kvm/svm/nested.c       |  16 +--
>>>   arch/x86/kvm/svm/sev.c          |   4 +-
>>>   arch/x86/kvm/svm/svm.c          | 218 +++++++++++++++++-----------------
>>>   arch/x86/kvm/svm/svm.h          |   8 +-
>>>   arch/x86/kvm/vmx/nested.c       |  26 +++--
>>>   arch/x86/kvm/vmx/nested.h       |   2 +-
>>>   arch/x86/kvm/vmx/vmx.c          | 238 +++++++++++++++++++-------------------
>>>   arch/x86/kvm/vmx/vmx.h          |   2 +-
>>>   arch/x86/kvm/x86.c              |  20 ++--
>>>   11 files changed, 279 insertions(+), 271 deletions(-)
>>>
>>> Krish Sadhukhan (1):
>>>        KVM: x86: Fill in conforming {vmx|svm}_x86_ops and {vmx|svm}_nested_ops
>>>
>> I like the patch!
>>
>> I would, however, want to suggest to split this:
>>
>> 1) Separate {vmx|svm}_x86_ops change from {vmx|svm}_nested_ops
>> 2) Separate VMX/nVMX from SVM/nSVM
>> 3) Separate other changes (like svm_tlb_flush() -> svm_flush_tlb()
>> rename, set_irq() -> inject_irq() rename, ...) into induvidual patches.
>
> It makes sense. However, I haven't separated #3 that you mentioned 
> because the changes are not that many and hence I just squeezed them 
> into the relevant patches. If you feel strongly about it, I will 
> separate them.
>

No, I don't, v2 looks good. Thanks!

-- 
Vitaly

