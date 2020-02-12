Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFA9215A88F
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 13:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbgBLMDD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 07:03:03 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47281 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727778AbgBLMDD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 07:03:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581508982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k5zs83apuRL6HAt6DNxSJuwbz4meI2rzv8ad7JsjUkQ=;
        b=WVvzM/FAtyKRRclBJpUteZTimCShwrfRKPo3uA3rQKNhpUhxkKqaAYeIgvczk8MHBbAgzO
        GimnbaxD6a7KwKz3Ru+nM0xHFLINdKpBB8K9HZThE3pLHg7d8O/EywxCAaptqUFmzkBx50
        m7hs1LBfsigd/LSffFtwWemnHozqUbQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-LYDXHq9yNx2QG6xxt8yiPA-1; Wed, 12 Feb 2020 07:03:01 -0500
X-MC-Unique: LYDXHq9yNx2QG6xxt8yiPA-1
Received: by mail-wr1-f71.google.com with SMTP id u18so716036wrn.11
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 04:03:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k5zs83apuRL6HAt6DNxSJuwbz4meI2rzv8ad7JsjUkQ=;
        b=L+lF5UyKfecUJRVkedhgk6xLPjkGU71ZQaL/5PE7pGYa5yz6Ledu4gqGPc4Qrv0F4B
         LNlocWVPSTw+d99EY07J6iPBipOMpAaf0oQUMFoKxDqFkt/F/CZG2LH2Y7cIWfMv0Cnq
         fm3kXFIl4Zkgus9xZ+4fCaVCje/oIjbtklhWziI1YHbePHrwRYHhDxuBumTZ+aS+rrJs
         TXxlRFQh0PUV9LuNXGFBb00TAiUbxtomvF6Z9Eb8ohAfwZT6oag73PTdXvEk9MfwGU9K
         4GoSQZWunhQjxPvSahdj3jSH/tAkeMH8nidmmHj8Nnz1rOuddS0M0eAcxj10lYY8AFmM
         vi1A==
X-Gm-Message-State: APjAAAUSNPuGU7LniFeSTccFxM/iHalJc1FEckSYyUIQUxJukbpYE3ob
        alR4HJscud/VaaaVJ/nNniFV+odMa5zir73N2BSaGGTd0TKFeNyy3dlPu4Ee11wb4kywswnsYK6
        OdQ0JG7Bacy1i
X-Received: by 2002:a05:600c:2190:: with SMTP id e16mr12474053wme.84.1581508979958;
        Wed, 12 Feb 2020 04:02:59 -0800 (PST)
X-Google-Smtp-Source: APXvYqzkIv46akQrCda26rlO+E5SmKedUSHb3K89g/Qq7NOJVb0l558n0tRXJYn+nI0vQShjUJMrxA==
X-Received: by 2002:a05:600c:2190:: with SMTP id e16mr12474026wme.84.1581508979720;
        Wed, 12 Feb 2020 04:02:59 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:652c:29a6:517b:66d9? ([2001:b07:6468:f312:652c:29a6:517b:66d9])
        by smtp.gmail.com with ESMTPSA id 59sm427906wre.29.2020.02.12.04.02.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 04:02:57 -0800 (PST)
Subject: Re: [PATCH v2 0/7] KVM: x86/mmu: nVMX: 5-level paging fixes and
 enabling
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200207173747.6243-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e3ade6f7-071a-3825-9097-4c0f1a3f4676@redhat.com>
Date:   Wed, 12 Feb 2020 13:03:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200207173747.6243-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/02/20 18:37, Sean Christopherson wrote:
> Two fixes for 5-level paging bugs with a 100% fatality rate, a patch to
> enable 5-level EPT in L1, and additional clean up on top (mostly renames
> of functions/variables that caused me no end of confusion when trying to
> figure out what was broken).
> 
> Tested fixed kernels at L0, L1 and L2, with most combinations of EPT,
> shadow paging, 4-level and 5-level.  EPT kvm-unit-tests runs clean in L0.
> Patches for kvm-unit-tests incoming to play nice with 5-level nested EPT.
> 
> Ideally patches 1 and 2 would get into 5.6, 5-level paging is quite
> broken without them.
> 
> v2:
>   - Increase the nested EPT array sizes to accomodate 5-level paging in
>     the patch that adds support for 5-level nested EPT, not in the bug
>     fix for 5-level shadow paging.
> 
> Sean Christopherson (7):
>   KVM: nVMX: Use correct root level for nested EPT shadow page tables
>   KVM: x86/mmu: Fix struct guest_walker arrays for 5-level paging
>   KVM: nVMX: Allow L1 to use 5-level page walks for nested EPT
>   KVM: nVMX: Rename nested_ept_get_cr3() to nested_ept_get_eptp()
>   KVM: nVMX: Rename EPTP validity helper and associated variables
>   KVM: x86/mmu: Rename kvm_mmu->get_cr3() to ->get_guest_cr3_or_eptp()
>   KVM: nVMX: Drop unnecessary check on ept caps for execute-only
> 
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/include/asm/vmx.h      | 12 +++++++
>  arch/x86/kvm/mmu/mmu.c          | 35 ++++++++++----------
>  arch/x86/kvm/mmu/paging_tmpl.h  |  6 ++--
>  arch/x86/kvm/svm.c              | 10 +++---
>  arch/x86/kvm/vmx/nested.c       | 58 ++++++++++++++++++++-------------
>  arch/x86/kvm/vmx/nested.h       |  4 +--
>  arch/x86/kvm/vmx/vmx.c          |  2 ++
>  arch/x86/kvm/x86.c              |  2 +-
>  9 files changed, 79 insertions(+), 52 deletions(-)
> 

Queued 1-2-4-5-7 (for 5.6), thanks!

Paolo

