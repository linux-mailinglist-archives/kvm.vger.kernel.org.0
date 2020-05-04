Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 242041C406F
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 18:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729718AbgEDQt7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 12:49:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56759 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728655AbgEDQt7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 12:49:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588610997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oHIFHZpMTFsS6o4C4eP4nmeKJgG/zhFL7wedsTnup60=;
        b=VxY0G9PidKrQ0eOpp/ncMeda9TwULTFan3Lqw/SGlHxy+AAh8v0h3A4L6Tcg3oOFsEXyzh
        m73/Z105RtZXPkEEO15k+jQGusrxoq0hjOfoAi+1BoML4vUls1VUMDVskTQM5UuJvZTH98
        SnFfXa3ZONlBW8tblddzHGqfGt1idNo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-MSqYEXePObq6cD09Gc7OzA-1; Mon, 04 May 2020 12:49:55 -0400
X-MC-Unique: MSqYEXePObq6cD09Gc7OzA-1
Received: by mail-wr1-f72.google.com with SMTP id 30so608722wrp.22
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 09:49:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oHIFHZpMTFsS6o4C4eP4nmeKJgG/zhFL7wedsTnup60=;
        b=gISIKvhPD1uGz9BHMo5wB+3D30pcqyNmFueVudruTylC7oLSrV34WXnKg1fi7ER+lv
         3E0Iflqo8uQRNs9j43sNVYL/R6jRYfJxo/cvyCkrE7QR/RmQ8XJekKo8t3u13zFurfWJ
         SH1Sb2i+E1TrEGH/8z0OCdYTa8zm1QZpdYeujy8nghYkuXuBfYQO65/5w+7YaT28cYDj
         Q8YD1fCQRnRnjEYI5WaLJMyESU/5KOK8TEKD8kmxRpgQNkSdJ1jdmwU/Ew2Lbn+Pthix
         dODJ85yJUUM6nnplzrYzYQHmpQwo+OnuMo6EbRJwJC9iQlhwHpQHpdC6q/eSNaV28w+8
         a/KQ==
X-Gm-Message-State: AGi0PuZWR/csMjp7V9MAii//TX6e5A4i2ayNGMna29JbCNZQrPXtEp0z
        8bV+ZNr5yGMrIQ7G48jAJtF4fJX+Obtwr4QTG35xU1260uwWIqbYrBazaeAx3T8Ttz11iB73/wC
        ZLc/IdL2jtntc
X-Received: by 2002:adf:ee88:: with SMTP id b8mr174145wro.93.1588610994691;
        Mon, 04 May 2020 09:49:54 -0700 (PDT)
X-Google-Smtp-Source: APiQypLKtFHZIUv4NcG3vTVjC4T0n5A2J4iO87GdeaxTeFI/aWSAwfse461FLfDPml9gQKYkw32KGw==
X-Received: by 2002:adf:ee88:: with SMTP id b8mr174120wro.93.1588610994397;
        Mon, 04 May 2020 09:49:54 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id d5sm19736003wrp.44.2020.05.04.09.49.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 09:49:53 -0700 (PDT)
Subject: Re: [PATCH 0/3] KVM: x86/mmu: Use kernel's PG_LEVEL_* enums
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Barret Rhoden <brho@google.com>
References: <20200428005422.4235-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <35a94d18-d6d1-78f1-aee5-0e40b5edc60b@redhat.com>
Date:   Mon, 4 May 2020 18:49:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200428005422.4235-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/04/20 02:54, Sean Christopherson wrote:
> Drop KVM's PT_{PAGE_TABLE,DIRECTORY,PDPE}_LEVEL KVM enums in favor of the
> kernel's PG_LEVEL_{4K,2M,1G} enums, which have far more user friendly
> names.
> 
> The KVM names were presumably intended to abstract away the page size.  In
> practice, the abstraction is only useful for a single line of code, a PSE
> paging related large page check.  For everything else, the abstract names
> do nothing but obfuscate the code.
> 
> Boot tested a PSE kernel under 32-bit KVM and 64-bit KVM, with and without
> EPT enabled.  Patches 2 and 3 generate no binary difference relative to
> patch 1 when compared via "objdump -d".
> 
> Sean Christopherson (3):
>   KVM: x86/mmu: Tweak PSE hugepage handling to avoid 2M vs 4M conundrum
>   KVM: x86/mmu: Move max hugepage level to a separate #define
>   KVM: x86/mmu: Drop KVM's hugepage enums in favor of the kernel's enums
> 
>  arch/x86/include/asm/kvm_host.h |  13 +---
>  arch/x86/kvm/mmu/mmu.c          | 118 +++++++++++++++-----------------
>  arch/x86/kvm/mmu/page_track.c   |   4 +-
>  arch/x86/kvm/mmu/paging_tmpl.h  |  18 ++---
>  arch/x86/kvm/mmu_audit.c        |   6 +-
>  arch/x86/kvm/svm/svm.c          |   2 +-
>  arch/x86/kvm/vmx/vmx.c          |   6 +-
>  arch/x86/kvm/x86.c              |   4 +-
>  8 files changed, 79 insertions(+), 92 deletions(-)
> 

Queued, thanks.

Paolo

