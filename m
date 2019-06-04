Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A36EB34E96
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 19:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfFDRTe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 13:19:34 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40014 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfFDRTd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 13:19:33 -0400
Received: by mail-wm1-f66.google.com with SMTP id v19so206169wmj.5
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2019 10:19:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/1gqrY2ImTpTIUPPPU1PDfWa7bCSQk/2OUjIHFRsVkk=;
        b=oObOneaxDLFpAb6QeVor8PFSzpbpbYtJY46loZ2jIRcAIxvS8Sxn4fVaEvPJsM12IK
         VeeEFge84rxNanNOZzfq1+dZG3ScbbwEOSXA2cHIhPz5xuu5WenUL0TyynK0RSSrcl/T
         HOqJkUncsEVcNqgR0BjenY8UPiPKD5HJpDNiHIpDOzREBKkj/D982/qYtIaGuQXLyI0O
         TuJ5uJH3O3Z6KdlGRJQGXyNhswb4Y4kH2A2zAUGkcOFeLxTbCXGFCE4QiZ/T0nt7SnIo
         goa+5Z/y3WgpmLQaLbVrwOZVz2QLJkJuUrLboLj4Wk4ILJm+KnerfKy16gQiYV01b7e3
         62hg==
X-Gm-Message-State: APjAAAXP49PDXDjS5PUp7baUrxpJqhGZOWLiIVK/YtMBWjOmzIseGG52
        EJEn3SaddwzfoJqN55wNiIp7nWw17Ht1QA==
X-Google-Smtp-Source: APXvYqzCTmSwqWr7Reg0Gs56V3SrKXWAOK1pOsi8iZhuHvPXpdeLwgLPTMRSYHM34prx2EZwe/cbcA==
X-Received: by 2002:a1c:c583:: with SMTP id v125mr4957627wmf.158.1559668771167;
        Tue, 04 Jun 2019 10:19:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id f10sm31540077wrg.24.2019.06.04.10.19.29
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 10:19:30 -0700 (PDT)
Subject: Re: [PATCH v1 0/9] KVM selftests for s390x
To:     Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20190523164309.13345-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f2daf197-bb5d-15d7-8219-d17cd40c85c9@redhat.com>
Date:   Tue, 4 Jun 2019 19:19:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190523164309.13345-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/05/19 18:43, Thomas Huth wrote:
> This patch series enables the KVM selftests for s390x. As a first
> test, the sync_regs from x86 has been adapted to s390x, and after
> a fix for KVM_CAP_MAX_VCPU_ID on s390x, the kvm_create_max_vcpus
> is now enabled here, too.
> 
> Please note that the ucall() interface is not used yet - since
> s390x neither has PIO nor MMIO, this needs some more work first
> before it becomes usable (we likely should use a DIAG hypercall
> here, which is what the sync_reg test is currently using, too...
> I started working on that topic, but did not finish that work
> yet, so I decided to not include it yet).

Christian, please include this in your tree (rebasing on top of kvm/next
as soon as I push it).  Note that Thomas is away for about a month.

Paolo

> RFC -> v1:
>  - Rebase, needed to add the first patch for vcpu_nested_state_get/set
>  - Added patch to introduce VM_MODE_DEFAULT macro
>  - Improved/cleaned up the code in processor.c
>  - Added patch to fix KVM_CAP_MAX_VCPU_ID on s390x
>  - Added patch to enable the kvm_create_max_vcpus on s390x and aarch64
> 
> Andrew Jones (1):
>   kvm: selftests: aarch64: fix default vm mode
> 
> Thomas Huth (8):
>   KVM: selftests: Wrap vcpu_nested_state_get/set functions with x86
>     guard
>   KVM: selftests: Guard struct kvm_vcpu_events with
>     __KVM_HAVE_VCPU_EVENTS
>   KVM: selftests: Introduce a VM_MODE_DEFAULT macro for the default bits
>   KVM: selftests: Align memory region addresses to 1M on s390x
>   KVM: selftests: Add processor code for s390x
>   KVM: selftests: Add the sync_regs test for s390x
>   KVM: s390: Do not report unusabled IDs via KVM_CAP_MAX_VCPU_ID
>   KVM: selftests: Move kvm_create_max_vcpus test to generic code
> 
>  MAINTAINERS                                   |   2 +
>  arch/mips/kvm/mips.c                          |   3 +
>  arch/powerpc/kvm/powerpc.c                    |   3 +
>  arch/s390/kvm/kvm-s390.c                      |   1 +
>  arch/x86/kvm/x86.c                            |   3 +
>  tools/testing/selftests/kvm/Makefile          |   7 +-
>  .../testing/selftests/kvm/include/kvm_util.h  |  10 +
>  .../selftests/kvm/include/s390x/processor.h   |  22 ++
>  .../kvm/{x86_64 => }/kvm_create_max_vcpus.c   |   3 +-
>  .../selftests/kvm/lib/aarch64/processor.c     |   2 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c    |  25 +-
>  .../selftests/kvm/lib/s390x/processor.c       | 286 ++++++++++++++++++
>  .../selftests/kvm/lib/x86_64/processor.c      |   2 +-
>  .../selftests/kvm/s390x/sync_regs_test.c      | 151 +++++++++
>  virt/kvm/arm/arm.c                            |   3 +
>  virt/kvm/kvm_main.c                           |   2 -
>  16 files changed, 514 insertions(+), 11 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/include/s390x/processor.h
>  rename tools/testing/selftests/kvm/{x86_64 => }/kvm_create_max_vcpus.c (93%)
>  create mode 100644 tools/testing/selftests/kvm/lib/s390x/processor.c
>  create mode 100644 tools/testing/selftests/kvm/s390x/sync_regs_test.c
> 

