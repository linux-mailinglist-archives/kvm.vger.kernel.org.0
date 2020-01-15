Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57FD013CBAB
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 19:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729186AbgAOSH4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 13:07:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24206 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729112AbgAOSHz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 13:07:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579111674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7fID6vInRHrxtlo5QRMU7VPDyUEFXJHaww3fjUHk7ZA=;
        b=WlyYWetZ0IwXHVLEwnqwOiPLIFytcnB5KJOzfEaQncJKAKCoJ1wAkKh5kcXsKknkH/ASgc
        UR8vuFcjS/RyLshqWph+tja8UfBMj9klyUirZYSWvusAM7r1fQcodSUYL0vRlcWhawtLsz
        skRNS8X0GHz9SJPOewTFU6lVqjGLUsQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-cRmehn54P4KHsIYMMBtIgw-1; Wed, 15 Jan 2020 13:07:53 -0500
X-MC-Unique: cRmehn54P4KHsIYMMBtIgw-1
Received: by mail-wm1-f71.google.com with SMTP id t16so240816wmt.4
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2020 10:07:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7fID6vInRHrxtlo5QRMU7VPDyUEFXJHaww3fjUHk7ZA=;
        b=JD4XnEts+5AXQz+FE48CLK4QwsTHEEsyO/tgTUQoIyEIKqsTntQbYNmO9hqgdDPZQP
         KEb24MY8Fb4+Q+xlZTCA68tCjam+wxgy5LPeXCnXTVi6LpBj0p2c2Ef3o7Dj9NHiTLm0
         JZcli9YRxS/HCG6WcF5pQ9cKz3faFqgxIOcokL2b7ANaGG47BIBCxq/lUhDeFzgQCozG
         HzyHfKn6QRYUYYbJUu8CsTbJGcWfOW8Jp/w374CgROOTPgl/neXtIGRr3bbUBwQs2TAj
         W7XVwd2ss2FFGm8CcCfwao4GEuGuaTBLaDnJK4bo/UM2EN52IKJQ9rMiZba5WDJ4SZ/T
         oSUQ==
X-Gm-Message-State: APjAAAWZ8w0x/LNLr+J0vD2uIO1x4QdT+/rdkWYdNQlBOlC2Z5Yup9+x
        q/GDe58hw/Cc/eQNsi0470/n5QrPA4ayDWbgm4uP7f/GPewNtErPQjP6Mm9WGd3ibNOuyO8UqGR
        J6dBjUqN8K9KP
X-Received: by 2002:a05:600c:1003:: with SMTP id c3mr1208974wmc.120.1579111671876;
        Wed, 15 Jan 2020 10:07:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqys82Zum91O5UUcdGXuiZO+7mBL0scxKfEu+8BKC4UyeYAh+0xj3070ENwDj1Okibs0XoRj2A==
X-Received: by 2002:a05:600c:1003:: with SMTP id c3mr1208948wmc.120.1579111671658;
        Wed, 15 Jan 2020 10:07:51 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:436:e17d:1fd9:d92a? ([2001:b07:6468:f312:436:e17d:1fd9:d92a])
        by smtp.gmail.com with ESMTPSA id s65sm773973wmf.48.2020.01.15.10.07.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2020 10:07:47 -0800 (PST)
Subject: Re: [PATCH v2 0/5] KVM: x86: X86_FEATURE bit() cleanup
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191217213242.11712-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d53bd488-b871-47c4-c65c-4c231eff3cf9@redhat.com>
Date:   Wed, 15 Jan 2020 19:07:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191217213242.11712-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/12/19 22:32, Sean Christopherson wrote:
> Small series to add build-time protections on reverse CPUID lookup (and
> other usages of bit()), and to rename the misleading-generic bit() helper
> to something that better conveys its purpose.
> 
> I don't love emulator changes in patch 1 as adding one-off helpers is a
> bit silly, but IMO it's the lesser of two evils, e.g. adding dedicated
> helpers is arguably less error prone than manually encoding a CPUID
> lookup, and the helpers approach avoids having to include cpuid.h in the
> emulator code.
> 
> v2:
>   - Rework the assertions to use the reverse_cpuid table instead of
>     using the last cpufeatures word (which was not at all intuitive).
> 
> Sean Christopherson (5):
>   KVM: x86: Add dedicated emulator helpers for querying CPUID features
>   KVM: x86: Move bit() helper to cpuid.h
>   KVM: x86: Add CPUID_7_1_EAX to the reverse CPUID table
>   KVM: x86: Expand build-time assertion on reverse CPUID usage
>   KVM: x86: Refactor and rename bit() to feature_bit() macro
> 
>  arch/x86/include/asm/kvm_emulate.h |  4 +++
>  arch/x86/kvm/cpuid.c               |  5 ++--
>  arch/x86/kvm/cpuid.h               | 41 +++++++++++++++++++++++++----
>  arch/x86/kvm/emulate.c             | 21 +++------------
>  arch/x86/kvm/svm.c                 |  4 +--
>  arch/x86/kvm/vmx/vmx.c             | 42 +++++++++++++++---------------
>  arch/x86/kvm/x86.c                 | 18 +++++++++++++
>  arch/x86/kvm/x86.h                 |  5 ----
>  8 files changed, 87 insertions(+), 53 deletions(-)
> 

Queued, thanks.

Paolo

