Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97EE73E5A57
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 14:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240812AbhHJMr4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 08:47:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40524 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240806AbhHJMrz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 08:47:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628599653;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A1vbqk+HrMkFDgZmPhDLQJTDofCmdnOiLqBGa7TgNLo=;
        b=SDi3tTsdzmae2br0GzMxV2HIx3KgBiWwWu1V+ZS3ZhHiX94qKnA86i0+ucNNu44hGCif+a
        FUy3GGDXR/M0Ps6H8UZfpNr7ZwtaO896gQ6d2jw0luWkdFAMDAcikacTFSdWVGdhLF23eO
        ygiqiGb/JeE31CZhxt+q7MhxwhMXrmk=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-119-30g0KS7HNfyK2q9LVNtT-A-1; Tue, 10 Aug 2021 08:47:31 -0400
X-MC-Unique: 30g0KS7HNfyK2q9LVNtT-A-1
Received: by mail-ej1-f71.google.com with SMTP id k12-20020a170906680cb02905aeccdbd1efso1894382ejr.9
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 05:47:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A1vbqk+HrMkFDgZmPhDLQJTDofCmdnOiLqBGa7TgNLo=;
        b=Tuwbiz5NqK1ilEczPtyY5ocw3KV1JnvOgz6jmxSmaxyLTr/sM9Bkl5Z/TLPBFaFftH
         0jrGrK4Zv/su3WqBs+0/qOcoauvlL8w8b7Dmwyv0iSzxDcSlSov/ifXVXsPiDoptJ/CA
         HVj+ZI93rpYiF14I/XOdHuQRbC/S9c5lh+dSTe0nJGTbNBLaHzS23NGX+k62pa9NUJ8Z
         cNte0b1xu9V3t3SYhQQr0yIeO0I/MzzfJNr2gyexL60OOGYcCz11MuTdi6GZi0grZjas
         kW5ORcfqBGGn8yJWDpTB4Ek5AdhV01jloHnn+m9/9N4CIa3ppImvbF1Y8UwdTnW+g3GE
         Bu6Q==
X-Gm-Message-State: AOAM530uCy84nrA5be5Hd8cbyh0UvL3JN/tufaRIBNYccpgAc4aAgoLK
        +croOYl3kaq0FneDIXtOaSd8/NKKUm1QcHmgSiYQ9uHJF38j5CKn2H0eaJt7VkON79cIJE8zVc2
        2g8nwvIhCeeiy
X-Received: by 2002:a17:907:1b22:: with SMTP id mp34mr1181771ejc.408.1628599650600;
        Tue, 10 Aug 2021 05:47:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyE8QW/f8zbOv6QQNcq3X7xQP29i0UFEQ6RYzZJQFLRWZLXKX5NRRV05HIud8CMBLdXPoqZnQ==
X-Received: by 2002:a17:907:1b22:: with SMTP id mp34mr1181758ejc.408.1628599650409;
        Tue, 10 Aug 2021 05:47:30 -0700 (PDT)
Received: from [192.168.10.118] ([93.56.169.140])
        by smtp.gmail.com with ESMTPSA id df14sm9536725edb.90.2021.08.10.05.47.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 05:47:29 -0700 (PDT)
Subject: Re: [PATCH v2 1/3] KVM: x86: Allow CPU to force vendor-specific TDP
 level
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com
References: <20210808192658.2923641-1-wei.huang2@amd.com>
 <20210808192658.2923641-2-wei.huang2@amd.com>
 <20210809035806.5cqdqm5vkexvngda@linux.intel.com>
 <c6324362-1439-ef94-789b-5934c0e1cdb8@amd.com>
 <20210809042703.25gfuuvujicc3vj7@linux.intel.com>
 <73bbaac0-701c-42dd-36da-aae1fed7f1a0@amd.com>
 <20210809064224.ctu3zxknn7s56gk3@linux.intel.com>
 <YRFKABg2MOJxcq+y@google.com>
 <20210810074037.mizpggevgyhed6rm@linux.intel.com>
 <0ac41a07-beeb-161e-9e5d-e45477106c01@redhat.com>
 <20210810110031.h7vaqf3nljwm3wym@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <998dca9a-84b6-20ee-2646-3eb58df0b8a0@redhat.com>
Date:   Tue, 10 Aug 2021 14:47:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210810110031.h7vaqf3nljwm3wym@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/08/21 13:00, Yu Zhang wrote:
> I guess it's because, unlike EPT which are with either 4 or 5 levels, NPT's
> level can range from 2 to 5, depending on the host paging mode...

Yes, on Linux that will be one of 3/4/5 based on host paging mode, and 
it will apply to all N_CR3...

> But shadow EPT does not have such annoyance. Is above understanding correct?

... Right, because shadow EPT cannot have less than 4 levels, and it can 
always use 4 levels if that's what L1 uses.

Paolo

