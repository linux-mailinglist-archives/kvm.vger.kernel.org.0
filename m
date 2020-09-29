Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E193A27C10A
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 11:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbgI2JZS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 05:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727700AbgI2JZS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 05:25:18 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F73C061755;
        Tue, 29 Sep 2020 02:25:17 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id j19so1175653pjl.4;
        Tue, 29 Sep 2020 02:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zbW0HeVoQwcWNP2ANJpj9racJHJLkStbpDgZaBi6ul8=;
        b=nGTtFOiGZGZEicHch+Scdl+5XHVvTFbsbUDlTVtIabcQ79pEsRHbWNthPU9ahqvGb7
         IVVjBvUg1EiwW1nZ3TjGwUu0HTJsWyEbna11J0MttBfXvplioYELn8Y0H5A0fNzq6ygQ
         OUtHNzeg7Ep5RqBnXj6m/B7yOJ3JnR6o2QhsaXa7s3QajIpkhPB/FQMMELhHkA8HShWj
         LvCkkszlcI7h8qHfzB3BgmTLpiMqTJgej4+aIPK/101aUK+UEMzoDJLYnyXeLD2Y9MW4
         MVMLlKAQy2oCjxN0JZf0hU9Vy+2tmtrZnwUhYJH2pdNAjF+lUUMvyhjvBDbi1LmMUUXT
         WJDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zbW0HeVoQwcWNP2ANJpj9racJHJLkStbpDgZaBi6ul8=;
        b=POyFu8pUUXcOWEOJ+zDQ8Qwa+XPNB8aT84sMptFzfPeFZuD8nM9F+HNEc2hlm+Muh6
         u22AGiP73TDPzPinIGDPOC36qa2e/w2NO/r7cSRzFAWrEjqTzGkvsy3Dv+gm05rY/3Lo
         1jmCQPvFb+yc60TJa3nmv5VFMobPfqNrax+u7BUIDg/wOfpz0yiSd43YX/EVEQqW/kRG
         45NYhQ8mgl9dICPMW+cSOnnFnkKfBOS1oThunV0to3ALdbKqznP7erNYrr4qeOr7MFD9
         8kbyHI4XY7NkV+PgsxtHbCUF0btPfn7yCdWS3LQZkW6XrZ60swwkjctbj7ELg+hCUPwM
         o3fQ==
X-Gm-Message-State: AOAM531k41tj6bp0ISpnUdjOu+U0IJupGAA96qqCw507NwRQgWR28JBw
        ffXOl2t4SI4MG8SzfVqoyA==
X-Google-Smtp-Source: ABdhPJxa6giD4jtY2/Pj3zBWZAPrAKlHFxdIyQKU/FZqPeVGw3I0Sf4xFVxNbhFR3fJa4rMh0AXyJg==
X-Received: by 2002:a17:90b:1b03:: with SMTP id nu3mr3066035pjb.148.1601371517456;
        Tue, 29 Sep 2020 02:25:17 -0700 (PDT)
Received: from [127.0.0.1] ([103.7.29.9])
        by smtp.gmail.com with ESMTPSA id i62sm4719940pfe.140.2020.09.29.02.25.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2020 02:25:16 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: Add tracepoint for dr_write/dr_read
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, Haiwei Li <lihaiwei@tencent.com>
References: <20200929085515.24059-1-lihaiwei.kernel@gmail.com>
 <20200929090133.GI2611@hirez.programming.kicks-ass.net>
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Message-ID: <d28afb27-fc22-e467-0aab-5140e9f3c09a@gmail.com>
Date:   Tue, 29 Sep 2020 17:25:04 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200929090133.GI2611@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 20/9/29 17:01, Peter Zijlstra wrote:
> On Tue, Sep 29, 2020 at 04:55:15PM +0800, lihaiwei.kernel@gmail.com wrote:
>> From: Haiwei Li <lihaiwei@tencent.com>
>>
>> Add tracepoint trace_kvm_dr_write/trace_kvm_dr_read for x86 kvm.
> 
> This is a changelog in the: i++; /* increment i */, style. Totally
> inadequate.

I will improve the changelog and resend. Thanks.

     Haiwei
