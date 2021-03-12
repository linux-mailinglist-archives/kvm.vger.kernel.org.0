Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B7D33942D
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 18:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232590AbhCLRCA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 12:02:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30297 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232506AbhCLRBe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Mar 2021 12:01:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615568493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IkgUn10sbtp3wNqsbqhL7dV8zvnw7JNTgJvwYNyqDZo=;
        b=V/z8PdNqoBjtLxq8OEGYYfy8glDVEqqeGT9nigmJH9aHJIT//cL/RKRF3VojmSnmbgflaJ
        AxFUlKLXYK4uu/iqvJKLHL4IQzTlqxQ++doJcd4sYZiPgqnHpaE1uiqykuzc3gzMYURH60
        mhgYybKnP6SHMIWGpJvLCAVYyJqgtDQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-hxCxk-YTOVOPTGngzd9OFg-1; Fri, 12 Mar 2021 12:01:31 -0500
X-MC-Unique: hxCxk-YTOVOPTGngzd9OFg-1
Received: by mail-wr1-f72.google.com with SMTP id i5so11424110wrp.8
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 09:01:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IkgUn10sbtp3wNqsbqhL7dV8zvnw7JNTgJvwYNyqDZo=;
        b=bzpkoZMppXZNexpGOJk0HRmuX9FOUrrMv8n1uctfnvFoB7nWQI4463VDG4wE0OIJY5
         TO1kTTr47LnqYzvSchviOBvB1ox9hSVKBH8IG01vHwAs4rVZpiJ+brNgUED1Wbw0aZOf
         goe+MOn0t7928et9yArdQLvNxtSS0bjWRyUrO3dO5PpXFCfIEafIGEk6PzTfJd5RGvR0
         +T1UHzgQ3tyd+cId78RolQZzXlLgTWdf/Tqjaxf19CeqbC/L0OwJKaLrgI/r6rD8+ild
         HoNLDtYAonfM9Y9ccPEZd+2L6WLDv6/XaF3kX7Ad7NTOUSRL2+ouBRgal57JxYB7Cob6
         /B1A==
X-Gm-Message-State: AOAM531NSOUW2f/OuSWEKLee96PXbEiQDys877zfCLap9n56qo3k65kn
        cjfQ6Ee+6k3g4RvufRBfGJ5DY0BlDn2R1xRLbmjFijM2C4LNz6l892MOmkRlYApNg+/jKTT+AwZ
        hvWKNS9wq4c8Q
X-Received: by 2002:a7b:c316:: with SMTP id k22mr13848280wmj.176.1615568485449;
        Fri, 12 Mar 2021 09:01:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzUIOQSjVsA8vTfnAKSJJr/qxhhRz9IzrgZRjqJban8ek7zeyQmPBYlGP9VxBfl056jN1B55g==
X-Received: by 2002:a7b:c316:: with SMTP id k22mr13847779wmj.176.1615568480067;
        Fri, 12 Mar 2021 09:01:20 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j203sm2950755wmj.40.2021.03.12.09.01.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 09:01:19 -0800 (PST)
Subject: Re: [PATCH 0/4] Fix RCU warnings in TDP MMU
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>
References: <20210311231658.1243953-1-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3c17a13f-d185-cf9c-2124-659a36ef03b4@redhat.com>
Date:   Fri, 12 Mar 2021 18:01:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210311231658.1243953-1-bgardon@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/03/21 00:16, Ben Gardon wrote:
> The Linux Test Robot found a few RCU warnings in the TDP MMU:
> https://www.spinics.net/lists/kernel/msg3845500.html
> https://www.spinics.net/lists/kernel/msg3845521.html
> 
> Fix these warnings and cleanup a hack in tdp_mmu_iter_cond_resched.
> 
> Tested by compiling as suggested in the test robot report and confirmed that
> the warnings go away with this series applied. Also ran kvm-unit-tests on an
> Intel Skylake machine with the TDP MMU enabled and confirmed that the series
> introduced no new failures.
> 
> Ben Gardon (4):
>    KVM: x86/mmu: Fix RCU usage in handle_removed_tdp_mmu_page
>    KVM: x86/mmu: Fix RCU usage for tdp_iter_root_pt
>    KVM: x86/mmu: Fix RCU usage when atomically zapping SPTEs
>    KVM: x86/mmu: Factor out tdp_iter_return_to_root
> 
>   arch/x86/kvm/mmu/tdp_iter.c | 34 +++++++++++++++++++++++++---------
>   arch/x86/kvm/mmu/tdp_iter.h |  3 ++-
>   arch/x86/kvm/mmu/tdp_mmu.c  | 19 +++++++++++--------
>   3 files changed, 38 insertions(+), 18 deletions(-)
> 

Mostly good but Sean's suggestion in patch 2 is indeed better.  There's 
enough changes that I'll wait for a v2 from you.  Thanks!

Paolo

