Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346A838E6C9
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 14:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbhEXMpb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 08:45:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46375 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232389AbhEXMpa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 08:45:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621860241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UbivfGwbAhsgULM6quDs35DJY7OTXofKsxhLnAK0xUE=;
        b=TV1kg9QDHI7r2eZVLFXeBOqWgFzbR+HFcQDyeJnxnozHbZ6XRDAhwBVSLQ1UlJDglassTv
        iNbI577zU5MaxkCsftX7/lUwNiF8bsl8+nXTT+HPWEwnU76QZ6Cx3Cjck/gPDacGX88xrN
        NiUow8beMIP0Q3Sdaui/2V/Tvd45vUE=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-4RRzAad-PCCtzyxJFPXavg-1; Mon, 24 May 2021 08:43:59 -0400
X-MC-Unique: 4RRzAad-PCCtzyxJFPXavg-1
Received: by mail-ej1-f69.google.com with SMTP id gf21-20020a170906e215b02903dfa2e85ff7so670074ejb.15
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 05:43:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UbivfGwbAhsgULM6quDs35DJY7OTXofKsxhLnAK0xUE=;
        b=WXzCP9gQ5UTdFohR2vLwGmwegXNtj/BQWe825qTQR7J8mvREYnJyaWSn2xiF3CXFP0
         e2RZyUFM0D0ZLsiO7tiAjNCBuOgPLYuOFC8ED/Ze9xqOAuEi810D5SkbkwVR6Ls1SCd/
         qr0rWL60H4+45TW7Nsbvyh9EKRoM0m+uIBwxvvRUReeicjKij+gpR4K1BOTzf+Q4N6Uq
         JcZLhgbFOIV5KI452+0TNPuwMCx3tHUTiS/Lt3Qr23oRx25j6jGR6w6XjSRELfgzyNba
         ArVW25Lcznq2upiiHwEopAkC7eq7isTE3SGOVONjWQ+OdLCtwCoc6FbOGpQYad/C11Pq
         a3UA==
X-Gm-Message-State: AOAM5318MOleWIY5TUMWrzC2l//g22TDutHVMaRpvc/clpP1hWQ4aMxM
        jbgv85+VErgL8YrCzJJDDyWqT5E5HVeXS5+4bmgiPOLAWeEJxVdczmotQWM2YOFzWJTun39KCDU
        847VSflUndigf
X-Received: by 2002:aa7:ca10:: with SMTP id y16mr24950888eds.280.1621860238475;
        Mon, 24 May 2021 05:43:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxAF2QStbIRjkz0M4bV4sNJWomerCznJQK325bD7BNUHka9iswFnKIWWCqHKgftjQ2j26PeSQ==
X-Received: by 2002:aa7:ca10:: with SMTP id y16mr24950868eds.280.1621860238287;
        Mon, 24 May 2021 05:43:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x16sm7750849eju.30.2021.05.24.05.43.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 05:43:57 -0700 (PDT)
Subject: Re: [PATCH v5 0/7] Lazily allocate memslot rmaps
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>
References: <20210518173414.450044-1-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <85bdd768-d7a3-100c-aade-ef5910b6e729@redhat.com>
Date:   Mon, 24 May 2021 14:43:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210518173414.450044-1-bgardon@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/05/21 19:34, Ben Gardon wrote:
> This series enables KVM to save memory when using the TDP MMU by waiting
> to allocate memslot rmaps until they are needed. To do this, KVM tracks
> whether or not a shadow root has been allocated. In order to get away
> with not allocating the rmaps, KVM must also be sure to skip operations
> which iterate over the rmaps. If the TDP MMU is in use and we have not
> allocated a shadow root, these operations would essentially be op-ops
> anyway. Skipping the rmap operations has a secondary benefit of avoiding
> acquiring the MMU lock in write mode in many cases, substantially
> reducing MMU lock contention.
> 
> This series was tested on an Intel Skylake machine. With the TDP MMU off
> and on, this introduced no new failures on kvm-unit-tests or KVM selftests.
> 
> Changelog:
> v2:
> 	Incorporated feedback from Paolo and Sean
> 	Replaced the memslot_assignment_lock with slots_arch_lock, which
> 	has a larger critical section.
> 
> v3:
> 	Removed shadow_mmu_active as suggested by Sean
> 	Removed everything except adding a return value to
> 	kvm_mmu_init_tdp_mmu from patch 1 of v2
> 	Added RCU protection and better memory ordering for installing the
> 	memslot rmaps as suggested by Paolo
> 	Reordered most of the patches
> 
> v4:
> 	Renamed functions to allocate and free memslots based on feedback
> 	from David.
> 	Eliminated the goto in memslot_rmap_alloc, as David suggested.
> 	Eliminated kvm_memslots_have_rmaps and updated comments on uses of
> 	memslots_have_rmaps. Suggested by Paolo.
> 	Changed the description on patch 7 to one Paolo suggested.
> 	Collected Reviewed-by tags from David.
> 	Dropped the patch to add RCU notations to rmap accesses.
> 
> v5:
> 	Responding to comments from Sean.
> 	Improved comments
> 	Swapped args to kvm_copy_memslots to match memcpy
> 	Fixed some line wrap and declaration style issues
> 	No longer check if memslots have rmaps before operations which
> 	iterate through active_mmu_pages
> 	Re-added the kvm_memslots_have_rmaps helper
> 	Fixed a couple missing unlocks for the slots_arch_lock

Queued (with minor conflicts), thanks!

Paolo

