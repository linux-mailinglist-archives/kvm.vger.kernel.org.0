Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2CA3B9523
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 19:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233072AbhGARD0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 13:03:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51841 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233045AbhGARD0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Jul 2021 13:03:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625158855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nOeE3vdzqSBLzhlrVzxDT7fPE/A21Lc3V+ndKNX6TGI=;
        b=ESngaFug1cetY5TjPPYkX0wCJXqr0fsNNqBQFm3H7SCIQbAlTLuMAxoJjUC/vtFRNXPsuW
        beW+87eUb13rZkeV26CfnOredxMh4Cm+mHO6GPUzlJzfLzDvrNin0l9vOFvZ02Rcg5FZzH
        R20po+4nM+avo3OIZALRtxX1yxAHUXw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-ujq5xl5WMqmOzTf33u_E5Q-1; Thu, 01 Jul 2021 13:00:53 -0400
X-MC-Unique: ujq5xl5WMqmOzTf33u_E5Q-1
Received: by mail-wm1-f69.google.com with SMTP id v2-20020a7bcb420000b0290146b609814dso2313026wmj.0
        for <kvm@vger.kernel.org>; Thu, 01 Jul 2021 10:00:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=nOeE3vdzqSBLzhlrVzxDT7fPE/A21Lc3V+ndKNX6TGI=;
        b=uapcEAmwZfDWnMj2THkPPSVOtuT36z/ALR7jJo0WpO+0z8RZBmv7AnWPfbSLYafZcl
         UIuqLd0txtS+Li6RohDnNnYAsaID8/qsk79IgSKU7x9oX4MR5l4Tzw5e753QInySN3YU
         TfAU0hJWb5M4nOkZukxkUkrP1A8cdXyBT5t6l6aUguLq0lDu5Ut84yDBKzEfr/pdiIWC
         T5KvKQzR7E/miJlje1S+d5h3y6fBN8yD6NCHkVqQA25KxpMqDpoisAt/N8rFKIqzPaN9
         asESqnbh8dHyYpCTDiQ55BRZgrZ7kI+MxmFV5Q5gYvsMKsMSX74nJSzKiZjRW/wYmE2q
         RgVg==
X-Gm-Message-State: AOAM531Xw6/ttSK97x1ekFb1MWhRuoATNNQJLcJtr+GXOQIHqU5bIcUS
        EhV0VnpTeQ73A6oXZq5tR5PUAOYMvLFvQrDLExMNAxsRzvI5mFTyF42t2H6+JotGNQtYy/dcZJs
        HdeGyzNpE23OR
X-Received: by 2002:a05:600c:2482:: with SMTP id 2mr705260wms.67.1625158852668;
        Thu, 01 Jul 2021 10:00:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxO+VGWAmQusSv0GRR2Q/FBDYF1JdzCgGA6/ROMi2P7oMzkbRe66HkPQwyoKIntNiAhYicK7A==
X-Received: by 2002:a05:600c:2482:: with SMTP id 2mr705250wms.67.1625158852533;
        Thu, 01 Jul 2021 10:00:52 -0700 (PDT)
Received: from [192.168.3.132] (p4ff23bca.dip0.t-ipconnect.de. [79.242.59.202])
        by smtp.gmail.com with ESMTPSA id u15sm9985009wmq.48.2021.07.01.10.00.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jul 2021 10:00:52 -0700 (PDT)
To:     David Matlack <dmatlack@google.com>, kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Yu Zhao <yuzhao@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20210630214802.1902448-1-dmatlack@google.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v2 0/6] KVM: x86/mmu: Fast page fault support for the TDP
 MMU
Message-ID: <3568552b-f72d-b158-dc49-3721375c18d5@redhat.com>
Date:   Thu, 1 Jul 2021 19:00:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210630214802.1902448-1-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30.06.21 23:47, David Matlack wrote:
> This patch series adds support for the TDP MMU in the fast_page_fault
> path, which enables certain write-protection and access tracking faults
> to be handled without taking the KVM MMU lock. This series brings the
> performance of these faults up to par with the legacy MMU.
> 
> Since there is not currently any KVM test coverage for access tracking
> faults, this series introduces a new KVM selftest,
> access_tracking_perf_test. Note that this test relies on page_idle to
> enable access tracking from userspace (since it is the only available
> usersapce API to do so) and page_idle is being considered for removal
> from Linux
> (https://lore.kernel.org/linux-mm/20210612000714.775825-1-willy@infradead.org/).

Well, at least a new selftest that implicitly tests a part of page_idle 
-- nice :)

Haven't looked into the details, but if you can live with page tables 
starting unpopulated and only monitoring what gets populated on r/w 
access, you might be able to achieve something similar using 
/proc/self/pagemap and softdirty handling.

Unpopulated page (e.g., via MADV_DISCARD) -> trigger read or write 
access -> sense if page populated in pagemap
Populated page-> clear all softdirty bits -> trigger write access -> 
sense if page is softdirty in pagemap

See https://lkml.kernel.org/r/20210419135443.12822-6-david@redhat.com 
for an example.

But I'm actually fairly happy to see page_idel getting used. Maybe you 
could extend that test using pagemap, if it's applicable to your test setup.

-- 
Thanks,

David / dhildenb

