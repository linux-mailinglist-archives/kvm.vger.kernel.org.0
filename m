Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15117230E2
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 12:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731572AbfETKDM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 06:03:12 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52866 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbfETKDM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 06:03:12 -0400
Received: by mail-wm1-f66.google.com with SMTP id y3so12626264wmm.2
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 03:03:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ntBh3gwN9WoX40GwCBpFxX6GBpRNGTL9y6TfLLH0P8Y=;
        b=cm9mz+eNFNX2D+724awLm2ls/BLU7CZuwpIDi1ZxGvcSnFIql1n3c9k7M70ehIG+eo
         ZPu0eQ2oj+vpRuUvJP1wmZawnGJGNwCu2pznQ6Ptm8wUY8T5N6qOWgZBBRxdWIGEtsoI
         DUiftEhC0H4QbMEX5Jv6hJ3GZDVcGFopX3onydabVKYoqxkcWTj8LeGXvN5vCCnmZ6JP
         EDOBZBI7EQjCPxtEsDgkP+YRvCyG/qXczR6losfqHinfYwbC1qwUszW956+3NXPZWjMy
         CD0GvQ1ja5pYU5ijQeqk67OZbMD3pqC/uCzdh5tbN2Mxo1kFigXfRjE4jucskNKF1oIq
         L6WA==
X-Gm-Message-State: APjAAAUG7B33Y/mcymMfFCDr2Ym9tizY7LxMY4b1QVMqAfKQHK8odVk/
        Nmc+rijILtES72P7oVwptwXjEw==
X-Google-Smtp-Source: APXvYqwCViWNb1nszawZx5mGOC1uWv3OZtGu2OV4T05uHlrHYWk1+jCA3rZNhigRAkrAXmHcizwTeA==
X-Received: by 2002:a1c:cb0e:: with SMTP id b14mr26501343wmg.61.1558346590407;
        Mon, 20 May 2019 03:03:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id g13sm15296462wrw.63.2019.05.20.03.03.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 03:03:09 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: selftests: Compile code with warnings enabled
To:     Thomas Huth <thuth@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        linux-kselftest@vger.kernel.org, kvm@vger.kernel.org
Cc:     Shuah Khan <shuah@kernel.org>, Andrew Jones <drjones@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20190517090445.4502-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f998da41-c75d-0afa-02cd-e2e5d8f0f546@redhat.com>
Date:   Mon, 20 May 2019 12:03:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190517090445.4502-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/05/19 11:04, Thomas Huth wrote:
> So far the KVM selftests are compiled without any compiler warnings
> enabled. That's quite bad, since we miss a lot of possible bugs this
> way. Let's enable at least "-Wall" and some other useful warning flags
> now, and fix at least the trivial problems in the code (like unused
> variables).
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  v2:
>  - Rebased to kvm/queue
>  - Fix warnings in state_test.c and evmcs_test.c, too
> 
>  tools/testing/selftests/kvm/Makefile                       | 4 +++-
>  tools/testing/selftests/kvm/dirty_log_test.c               | 6 +++++-
>  tools/testing/selftests/kvm/lib/kvm_util.c                 | 3 ---
>  tools/testing/selftests/kvm/lib/x86_64/processor.c         | 4 +---
>  tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c   | 1 +
>  tools/testing/selftests/kvm/x86_64/evmcs_test.c            | 7 +------
>  tools/testing/selftests/kvm/x86_64/platform_info_test.c    | 1 -
>  tools/testing/selftests/kvm/x86_64/smm_test.c              | 3 +--
>  tools/testing/selftests/kvm/x86_64/state_test.c            | 7 +------
>  .../selftests/kvm/x86_64/vmx_close_while_nested_test.c     | 5 +----
>  tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c   | 5 ++---
>  11 files changed, 16 insertions(+), 30 deletions(-)

Queued, with a squashed fix to kvm_get_supported_hv_cpuid.

Paolo
