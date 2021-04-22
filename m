Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBC7367A76
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 09:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbhDVHAb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 03:00:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37496 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229962AbhDVHAb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 03:00:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619074796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9HfKt+tj+kVv8EGTHRuWgwnmy43mLVyvrcb4OZJTQGQ=;
        b=V1IQV2ngtraIqQLC9SVwXH1ODujwfjvj+8LLkIG36s90fio6l8VVXmoYQspl7rDN0fom1i
        Hs7qRatfaW4XTqwqxR7gv70r3RNOHasjFgJhsWtTeB0WbqC7bCxxTKecLaPi34AaAoM5BS
        XwYtcVZmMbORjwqhk6k8qeoMObibP/w=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-7bOuMXd9O-Sg6PQvddu-GQ-1; Thu, 22 Apr 2021 02:59:54 -0400
X-MC-Unique: 7bOuMXd9O-Sg6PQvddu-GQ-1
Received: by mail-ej1-f71.google.com with SMTP id o25-20020a1709061d59b029037c94676df5so6857990ejh.7
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 23:59:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9HfKt+tj+kVv8EGTHRuWgwnmy43mLVyvrcb4OZJTQGQ=;
        b=LnEU+G6seyfBOr/QfI0lOCb8P4KJl0lfW5HQMiDdT8h8rRADcPbMZHYzV8OPowHO0+
         2KRV0VyR9HAfHusYEbUfpRVEhHjuEqugl6CoqLurp5Ty+fbEwxybDhqkXWn4En+1vINm
         Hh+hM7cBnnHmIqd0h8MI39ItJSnyUVo3jaBMQO0uc+SO1zOvvpYy2434XlF1qnEnEw9v
         GHZiPXTQz2rTAnXy7EZzZFkCA69+MSjL3FCBD/8RBhqs35UXhNqvngcpSIO+UyttAqdN
         /t5GHKDaFhq/Zc4JVSP0LsMsdFUQMIO5X1qzgWWtAYK3xbawiieWUOIX3YbMV8l1MgQ+
         uJmg==
X-Gm-Message-State: AOAM531T8QLRFbXSI46tSdy9nPQtIlOO0K4ncz3KsGXlA6c/iFm9WLOr
        WfPqLRC1aR8517ZmQCDXSUv5zFMjatu256AUdtT4QekrqHE4JycDNbnduXElpXwe1aPSWe0exU5
        4rX+i2Xwuzc6R
X-Received: by 2002:a17:907:294f:: with SMTP id et15mr1825488ejc.14.1619074793046;
        Wed, 21 Apr 2021 23:59:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy18vOTKev4XwdTSbfQNMYcG3hVv8wE66nlBQZcJc05HPittFlEmKn/E7GPIdzP1VdI5S9Hug==
X-Received: by 2002:a17:907:294f:: with SMTP id et15mr1825473ejc.14.1619074792912;
        Wed, 21 Apr 2021 23:59:52 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j9sm1236249eds.71.2021.04.21.23.59.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 23:59:51 -0700 (PDT)
Subject: Re: [PATCH 3/5] tools headers x86: Copy cpuid helpers from the kernel
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
References: <20210422005626.564163-1-ricarkol@google.com>
 <20210422005626.564163-4-ricarkol@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <404e903a-5752-6ab2-9b46-aa40f7fb0fba@redhat.com>
Date:   Thu, 22 Apr 2021 08:59:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210422005626.564163-4-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/04/21 02:56, Ricardo Koller wrote:
> Copy arch/x86/include/asm/acpufeature.h and arch/x86/kvm/reverse_cpuid.h
> from the kernel so that KVM selftests can use them in the next commits.
> Also update the tools copy of arch/x86/include/asm/acpufeatures.h.

Typo.

> These should be kept in sync, ideally with the help of some script like
> check-headers.sh used by tools/perf/.

Please provide such a script.

Also, without an automated way to keep them in sync I think it's better 
to copy all of them to tools/testing/selftests/kvm, so that we can be 
sure that a maintainer (me) runs the script and keeps them up to date. 
I am fairly sure that the x86 maintainers don't want to have anything to 
do with all of this business!

Paolo

