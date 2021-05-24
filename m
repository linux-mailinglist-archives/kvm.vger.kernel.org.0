Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF36938E668
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 14:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbhEXMQ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 08:16:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29189 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232494AbhEXMQZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 08:16:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621858497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6VKp1xofZhd/+4tFw02ffWXfwhEtsPe1dVI9fvTfESM=;
        b=JiY7ZDWxMr8dtjKbS5Us40gqWc2IjcgupS8KRIayqY3FiwvefA2l7u2YVERLZSP0ri3sQq
        Yghe/2nu0YRy2WH2H0CfaDBY3qEdy45J8RJkPbhM3GyS8FLsGBeR9BYCI6xYBJjV1sj3/R
        DxUTGiLo1cjBMfqQ8oMfPkhphCOTlw8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-_b527I7SOYWxLFxpLw73tg-1; Mon, 24 May 2021 08:14:55 -0400
X-MC-Unique: _b527I7SOYWxLFxpLw73tg-1
Received: by mail-ed1-f72.google.com with SMTP id d8-20020a0564020008b0290387d38e3ce0so15481374edu.1
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 05:14:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6VKp1xofZhd/+4tFw02ffWXfwhEtsPe1dVI9fvTfESM=;
        b=h7FHkP78JbFJMYlMkqB6DHo+DCJjuRbMoxTQsTxSxCZ4e0Tu7JpnmWIAzq0IhYFlnE
         lGdeRRhpB3Ldetks5pcJOGUZy40/D5CK8ON83sMr2GaB89DBTSZf4cb3yyoAdGWfHi6t
         g+cF4BC8wrlCixAbzwpGnC4aOLqGr2GeQ3xinAblh8RFc7GfV1oZQ9T8XGFm8tc4tFnL
         z+frbEe4pShgQf3fZrIEQ2Idf0JhriUF8VDLA4afmcT83hnLO/fW6MHZIu3z5NARR5/3
         g1qbKs911YBXHHXia4z6u1iIuP9H9WhFLGQ6VNRTr7VgogyriVB3qQAwr8UuPBZCXHIE
         3t6g==
X-Gm-Message-State: AOAM531Hv+7d53ldp0WVMBGTQu5+nSHm/83ph81GK75+XtKu7tkGIymY
        zcqL1NLjhul0dqlqBfiYMSRFK+riDd7FWZzLapDSWc3zd2f/sd7TQin3ZlZjnKGjr7b6nhd9fes
        OsMqSn3NwWlUU
X-Received: by 2002:a17:906:eb10:: with SMTP id mb16mr23517145ejb.209.1621858494163;
        Mon, 24 May 2021 05:14:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxk+0l0weiOvjyF1AGyYnOo0VG6EnvzCZZGMcmr4Lu8V//fg+XmZ0li0ktd4Yb2OtYjlpR1Ug==
X-Received: by 2002:a17:906:eb10:: with SMTP id mb16mr23517131ejb.209.1621858494009;
        Mon, 24 May 2021 05:14:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id v23sm9221937edx.31.2021.05.24.05.14.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 05:14:53 -0700 (PDT)
Subject: Re: [PATCH v2 0/5] KVM: selftests: arm64 exception handling and debug
 test
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, drjones@redhat.com, alexandru.elisei@arm.com,
        eric.auger@redhat.com
References: <20210430232408.2707420-1-ricarkol@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <362e360d-40c3-1e50-18b0-a2f4297d3746@redhat.com>
Date:   Mon, 24 May 2021 14:14:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210430232408.2707420-1-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/05/21 01:24, Ricardo Koller wrote:
> Hi,
> 
> These patches add a debug exception test in aarch64 KVM selftests while
> also adding basic exception handling support.
> 
> The structure of the exception handling is based on its x86 counterpart.
> Tests use the same calls to initialize exception handling and both
> architectures allow tests to override the handler for a particular
> vector, or (vector, ec) for synchronous exceptions in the arm64 case.
> 
> The debug test is similar to x86_64/debug_regs, except that the x86 one
> controls the debugging from outside the VM. This proposed arm64 test
> controls and handles debug exceptions from the inside.
> 
> Thanks,
> Ricardo

Marc, are you going to queue this in your tree?

Thanks,

Paolo

> v1 -> v2:
> 
> Addressed comments from Andrew and Marc (thank you very much):
> - rename vm_handle_exception in all tests.
> - introduce UCALL_UNHANDLED in x86 first.
> - move GUEST_ASSERT_EQ to common utils header.
> - handle sync and other exceptions separately: use two tables (like
>    kvm-unit-tests).
> - add two separate functions for installing sync versus other exceptions
> - changes in handlers.S: use the same layout as user_pt_regs, treat the
>    EL1t vectors as invalid, refactor the vector table creation to not use
>    manual numbering, add comments, remove LR from the stored registers.
> - changes in debug-exceptions.c: remove unused headers, use the common
>    GUEST_ASSERT_EQ, use vcpu_run instead of _vcpu_run.
> - changes in processor.h: write_sysreg with support for xzr, replace EL1
>    with current in macro names, define ESR_EC_MASK as ESR_EC_NUM-1.
> 
> Ricardo Koller (5):
>    KVM: selftests: Rename vm_handle_exception
>    KVM: selftests: Introduce UCALL_UNHANDLED for unhandled vector
>      reporting
>    KVM: selftests: Move GUEST_ASSERT_EQ to utils header
>    KVM: selftests: Add exception handling support for aarch64
>    KVM: selftests: Add aarch64/debug-exceptions test
> 
>   tools/testing/selftests/kvm/.gitignore        |   1 +
>   tools/testing/selftests/kvm/Makefile          |   3 +-
>   .../selftests/kvm/aarch64/debug-exceptions.c  | 244 ++++++++++++++++++
>   .../selftests/kvm/include/aarch64/processor.h |  90 ++++++-
>   .../testing/selftests/kvm/include/kvm_util.h  |  10 +
>   .../selftests/kvm/include/x86_64/processor.h  |   4 +-
>   .../selftests/kvm/lib/aarch64/handlers.S      | 130 ++++++++++
>   .../selftests/kvm/lib/aarch64/processor.c     | 124 +++++++++
>   .../selftests/kvm/lib/x86_64/processor.c      |  19 +-
>   .../selftests/kvm/x86_64/kvm_pv_test.c        |   2 +-
>   .../selftests/kvm/x86_64/tsc_msrs_test.c      |   9 -
>   .../kvm/x86_64/userspace_msr_exit_test.c      |   8 +-
>   .../selftests/kvm/x86_64/xapic_ipi_test.c     |   2 +-
>   13 files changed, 611 insertions(+), 35 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/aarch64/debug-exceptions.c
>   create mode 100644 tools/testing/selftests/kvm/lib/aarch64/handlers.S
> 

