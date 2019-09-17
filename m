Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90D16B5179
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 17:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729556AbfIQP2Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 11:28:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51228 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729543AbfIQP2Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 11:28:24 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C08B08667D
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 15:28:23 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id n18so1444372wro.11
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 08:28:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=7mnmRgUCgAlAXrxHwhjTLW45iyiMz5FPUKvdpngF3+I=;
        b=YPMp8NKhSKXIhOXNbY4u9FsHg6DXhXTPd6LqZIZyyKhprHRuboYc0+ij83sMXSC6EL
         vkFBX+EY9FegzMw/i9cmZwFPSlIpGyoh/XFWzEDCWRUaP3yBbYnOEhxKjdEOp+ldRDko
         Q0kqq3AEb84EYjXPEm+QkNL0O3W9Cn/rv8WOGkTUdxxtC0rwWM5wPPFPVStbm3aZgGlC
         1f24e2KExZ3hhI4GYzQa74aVeA1us3t8BaDuAWnm9P+CiB8XZlS72M6qS9o/NVF0JfGI
         OgVX+whG2J0TL3bxA522TPZ0FgqnMkYKIz39bz5lyk5T1Rv9IWabsigS96qCxFvcCNLl
         rJKA==
X-Gm-Message-State: APjAAAX8bUz5eLEamyNpmXuE1qE4LASW9/bf6Po6K79xAaOiwCk5+NI7
        KIa1lMWasjTFB2kTwYS+FIKqrS3sFam655FQNcQU8Z8P3vJ3yOZ+x/rZsygOycyeelfEGtWCzWU
        a2HNW0AH74sGG
X-Received: by 2002:a5d:6a09:: with SMTP id m9mr3378968wru.12.1568734102266;
        Tue, 17 Sep 2019 08:28:22 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy4pW4zgxABH6kbq9g/jw+pZm3IOziyF8pDsnqSMITDPGieP+H8bXoz+/FldIxghopVjWcUqg==
X-Received: by 2002:a5d:6a09:: with SMTP id m9mr3378931wru.12.1568734101878;
        Tue, 17 Sep 2019 08:28:21 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id u68sm3597043wmu.12.2019.09.17.08.28.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Sep 2019 08:28:21 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, lantianyu1986@gmail.com,
        rkrcmar@redhat.com, corbet@lwn.net, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, sashal@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, michael.h.kelley@microsoft.com
Subject: Re: [PATCH V4 0/3] KVM/Hyper-V: Add Hyper-V direct tlb flush support
In-Reply-To: <7ea7fa06-f100-1507-8507-1c701877c8ab@redhat.com>
References: <20190822143021.7518-1-Tianyu.Lan@microsoft.com> <7ea7fa06-f100-1507-8507-1c701877c8ab@redhat.com>
Date:   Tue, 17 Sep 2019 17:28:20 +0200
Message-ID: <874l1baqnf.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 22/08/19 16:30, lantianyu1986@gmail.com wrote:
>> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>> 
>> This patchset is to add Hyper-V direct tlb support in KVM. Hyper-V
>> in L0 can delegate L1 hypervisor to handle tlb flush request from
>> L2 guest when direct tlb flush is enabled in L1.
>> 
>> Patch 2 introduces new cap KVM_CAP_HYPERV_DIRECT_TLBFLUSH to enable
>> feature from user space. User space should enable this feature only
>> when Hyper-V hypervisor capability is exposed to guest and KVM profile
>> is hided. There is a parameter conflict between KVM and Hyper-V hypercall.
>> We hope L2 guest doesn't use KVM hypercall when the feature is
>> enabled. Detail please see comment of new API "KVM_CAP_HYPERV_DIRECT_TLBFLUSH"
>> 
>> Change since v3:
>>        - Update changelog in each patches. 
>> 
>> Change since v2:
>>        - Move hv assist page(hv_pa_pg) from struct kvm  to struct kvm_hv.
>> 
>> Change since v1:
>>        - Fix offset issue in the patch 1.
>>        - Update description of KVM KVM_CAP_HYPERV_DIRECT_TLBFLUSH.
>> 
>> Tianyu Lan (2):
>>   x86/Hyper-V: Fix definition of struct hv_vp_assist_page
>>   KVM/Hyper-V: Add new KVM capability KVM_CAP_HYPERV_DIRECT_TLBFLUSH
>> 
>> Vitaly Kuznetsov (1):
>>   KVM/Hyper-V/VMX: Add direct tlb flush support
>> 
>>  Documentation/virtual/kvm/api.txt  | 13 +++++++++++++
>>  arch/x86/include/asm/hyperv-tlfs.h | 24 ++++++++++++++++++-----
>>  arch/x86/include/asm/kvm_host.h    |  4 ++++
>>  arch/x86/kvm/vmx/evmcs.h           |  2 ++
>>  arch/x86/kvm/vmx/vmx.c             | 39 ++++++++++++++++++++++++++++++++++++++
>>  arch/x86/kvm/x86.c                 |  8 ++++++++
>>  include/uapi/linux/kvm.h           |  1 +
>>  7 files changed, 86 insertions(+), 5 deletions(-)
>> 
>
> Queued, thanks.
>

I had a suggestion how we can get away without the new capability (like
direct tlb flush gets automatically enabled when Hyper-V hypercall page
is activated and we know we can't handle KVM hypercalls any more)
but this can probably be done as a follow-up.

-- 
Vitaly
