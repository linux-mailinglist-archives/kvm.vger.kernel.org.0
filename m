Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EAB43C18BF
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 19:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbhGHSAQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 14:00:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59833 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229631AbhGHSAN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Jul 2021 14:00:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625767051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xjKPzQ8ubajcvMakFlYLidaZJUhpZpB7jXpO5LDMoFg=;
        b=Z1wE0AvZKblbxlW/cH0fnmp2ZjjukfQOn0iK+zILIEbMbv7/txz83gIbnYL727Ds2ZA7gU
        UcBiAAyn42DuwrGgrVFqXm3sCjQmQ3T/TMPUMwd9yNqaPo6NBT8znIV+MIDT2SEHcI/XOY
        zkSuD7pm3cUFSrSomiGfR8UY0p6Ts1M=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-vvwESoa2MiSgaLjiEGDCwg-1; Thu, 08 Jul 2021 13:57:28 -0400
X-MC-Unique: vvwESoa2MiSgaLjiEGDCwg-1
Received: by mail-ej1-f69.google.com with SMTP id jx16-20020a1709077610b02904e0a2912b46so2181944ejc.7
        for <kvm@vger.kernel.org>; Thu, 08 Jul 2021 10:57:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xjKPzQ8ubajcvMakFlYLidaZJUhpZpB7jXpO5LDMoFg=;
        b=qzjqHK55pTJjgiexVwHG1T+Wn3IMc/yirB51eANnnQIVjNXIlBxLH0U4EhlC/+wgmA
         60gRxzo12/N3KLPaG5ShiNwYloWQ5Q1YHhDbTKVsqpmhu9vTcu+CEMQQQKqIn4QFm9Hs
         QBXNpor+rLaO1RmiFfkv3h8WsAzZsvlY7fFkDkKuC+CbTM8Mwfj7taFlp3kY+/WGnscg
         DUtEn6OZVMSNz1xl5FCNIPImGCse/pjEDA2A6183uItNzOtVAHL6w0z6Zptwdzs9DTxp
         nryx084h1FiPH1s2Exhhv2We2d/yM8x6IrAGgkYRhPyO2YiFUZkj19C7yHs2PrZWM5jK
         2zQw==
X-Gm-Message-State: AOAM531dMGzUR15PwjAXTCCbzuEzGjScX750BteVSpDWGNoWSnCaJovf
        aB81Y11aZYyuW7Y6GODeF7/3YvkD0crvIjz0q/t7M+Ru7nntDLTx26jV23ZnHmQh4ywUB76L28I
        IzeAOLCP1LPda
X-Received: by 2002:a17:906:4e4f:: with SMTP id g15mr32574572ejw.217.1625767046875;
        Thu, 08 Jul 2021 10:57:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxes3RJnJHPw1XUt3+d5G0lMVrsT7hZfH0IJlalPxgoyMu2G8Ho5BYEGYeT7Cs3ei908+CMwQ==
X-Received: by 2002:a17:906:4e4f:: with SMTP id g15mr32574555ejw.217.1625767046707;
        Thu, 08 Jul 2021 10:57:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id ze15sm1297121ejb.79.2021.07.08.10.57.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 10:57:26 -0700 (PDT)
Subject: Re: [PATCH 0/5] KVM: x86: Use kernel x86 cpuid utilities in KVM
 selftests
To:     Ricardo Koller <ricarkol@google.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
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
        Joerg Roedel <joro@8bytes.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
References: <20210422005626.564163-1-ricarkol@google.com>
 <c4524e4a-55c7-66f9-25d6-d397f11d25a8@redhat.com>
 <YIm7iWxggvoN9riz@google.com>
 <CALMp9eSfpdWF0OROsOqxohxMoFrrY=Gt7FYfB1_31D7no4JYLw@mail.gmail.com>
 <16823e91-5caf-f52e-e0dc-28ebb9a87b47@redhat.com>
 <YOc0BUrL6VMw78nF@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8a4163ee-ac31-60fa-4b8b-f7677ec0fd46@redhat.com>
Date:   Thu, 8 Jul 2021 19:57:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YOc0BUrL6VMw78nF@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/07/21 19:21, Ricardo Koller wrote:
>> I also prefer the kvm-unit-tests implementation, for what it's worth...
>> Let's see what the code looks like?
> I'm not sure I understand the question. You mean: let's see how this
> looks using kvm-unit-tests headers? If that's the case I can work on a
> v3 using kvm-unit-tests.

Yes, exactly.  Thanks!

Paolo

