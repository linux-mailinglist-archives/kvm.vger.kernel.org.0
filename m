Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 716F7177258
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 10:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbgCCJ2H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 04:28:07 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41837 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727870AbgCCJ2G (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Mar 2020 04:28:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583227686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JawvsztqURHUMrivAZK9itm+6zuMO8VTLICNdnI7dxo=;
        b=hMFIc0CLGIWvyEMhAvtDytMosd8AHGgA2I9YUdZtQsGEu6eqEDBQcUuXU5MRCBWiYHLxVX
        GCB6HpBs78v99997mZSeKdDsW6RhbzMy7XFkNYfKR1A2GweLWMySM2KBHhafaNrpnTqWQm
        0A5YG50M8EtIdAtyM4SmiTi52W1YxkU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-zUrMuLcfMiawl1sTlG6lKg-1; Tue, 03 Mar 2020 04:28:04 -0500
X-MC-Unique: zUrMuLcfMiawl1sTlG6lKg-1
Received: by mail-wm1-f72.google.com with SMTP id m4so828203wmi.5
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 01:28:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JawvsztqURHUMrivAZK9itm+6zuMO8VTLICNdnI7dxo=;
        b=B0kmSetF08jGfUYpshcr0jiWuwod0jvrDe6Vfv7ECqDztUzmJOY4dI3YERseEOhAiX
         RURxWMWpQohmto0PPAS+Npg8XiyFUfR6P0w6aWGl5il39/7n4zZ4oKhdM1SbxlWMuXbM
         X5nVR+MSzkfLqqpV9a3Qwz00Swh6xqcAkRsPJMJex8lPYoqeqG0Go3sN9CvUoZnXqgrx
         Ayy8tFP078+H5GWkqp33FcpIIqRuMyqj4R0aJqRmtwFcyeQyWlc2JW5c9cMAehWBJknQ
         nzUuSy7HmcpYabzdH7b9eOQCpZFfeqd3jk8MXB5dfOIVMaGsTrIkI1lO7zPUXq+42Hgv
         NiDg==
X-Gm-Message-State: ANhLgQ0CKwtYgz4aIj+yylahY0gZVbZAvVf9jBOo+2T3RnVT9nDNGZ5b
        fVHsc8sCe3fAotr5eaxqv3k/cZ3veUtxWJVMTQYGY2HTGFLOthpfYBYOpFDVS5o/9w/Hm/hl1MQ
        kPm86i3+Du8bg
X-Received: by 2002:a5d:68ce:: with SMTP id p14mr3888596wrw.315.1583227683197;
        Tue, 03 Mar 2020 01:28:03 -0800 (PST)
X-Google-Smtp-Source: ADFU+vsJpUVTnRWkgQAQclEelI+BOvdB7TqEFgh/PbQcMZ6SzEsdA+mGSHrg8PNex6myJcsME0a9aA==
X-Received: by 2002:a5d:68ce:: with SMTP id p14mr3888556wrw.315.1583227682873;
        Tue, 03 Mar 2020 01:28:02 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:4c52:2f3b:d346:82de? ([2001:b07:6468:f312:4c52:2f3b:d346:82de])
        by smtp.gmail.com with ESMTPSA id a6sm3075433wmh.32.2020.03.03.01.28.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 01:28:02 -0800 (PST)
Subject: Re: [PATCH v3 0/7] KVM: x86/mmu: nVMX: 5-level paging cleanup and
 enabling
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200303020240.28494-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <748ad2db-f2da-d177-7ec8-54523465e64a@redhat.com>
Date:   Tue, 3 Mar 2020 10:28:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200303020240.28494-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/03/20 03:02, Sean Christopherson wrote:
> Clean up MMU code related to 5 level paging, expose 5-level EPT to L1, and
> additional clean up on top (mostly renames of functions/variables that
> caused me no end of confusion when trying to figure out what was broken
> at various times).
> 
> v3:
>   - Dropped fixes for existing 5-level bugs (merged for 5.6).
>   - Use get_guest_pgd() instead of get_guest_cr3_or_eptp(). [Paolo]
>   - Add patches to fix MMU role calculation to play nice with 5-level
>     paging without requiring additional CR4.LA_57 bit.
> 
> v2:
>   - Increase the nested EPT array sizes to accomodate 5-level paging in
>     the patch that adds support for 5-level nested EPT, not in the bug
>     fix for 5-level shadow paging.
> 
> Sean Christopherson (7):
>   KVM: x86/mmu: Don't drop level/direct from MMU role calculation
>   KVM: x86/mmu: Drop kvm_mmu_extended_role.cr4_la57 hack
>   KVM: nVMX: Allow L1 to use 5-level page walks for nested EPT
>   KVM: nVMX: Rename nested_ept_get_cr3() to nested_ept_get_eptp()
>   KVM: nVMX: Rename EPTP validity helper and associated variables
>   KVM: x86/mmu: Rename kvm_mmu->get_cr3() to ->get_guest_pgd()
>   KVM: nVMX: Drop unnecessary check on ept caps for execute-only
> 
>  arch/x86/include/asm/kvm_host.h |  3 +-
>  arch/x86/include/asm/vmx.h      | 12 +++++++
>  arch/x86/kvm/mmu/mmu.c          | 59 +++++++++++++++++----------------
>  arch/x86/kvm/mmu/paging_tmpl.h  |  4 +--
>  arch/x86/kvm/svm.c              |  2 +-
>  arch/x86/kvm/vmx/nested.c       | 52 ++++++++++++++++++-----------
>  arch/x86/kvm/vmx/nested.h       |  4 +--
>  arch/x86/kvm/vmx/vmx.c          |  3 +-
>  arch/x86/kvm/x86.c              |  2 +-
>  9 files changed, 82 insertions(+), 59 deletions(-)
> 

Queued, thanks.  I have a cleanup on top to unify set_cr3 and
set_tdp_cr3, which I'll post after testing it.

Paolo

