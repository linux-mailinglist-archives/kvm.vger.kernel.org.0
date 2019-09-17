Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3C3B512F
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 17:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729295AbfIQPOJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 11:14:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45392 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727454AbfIQPOJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 11:14:09 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CF583C058CB8
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 15:14:08 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id 190so1385368wme.4
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 08:14:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I4PB1FbT5VkDhYHBq97VeVQ0522bZ0vraJdaFOAhJuo=;
        b=IS9Pa45S3Tv5DqD8U570IBTzMnh/7H7r7ux2N4BFw4zny4qC8qo3nywnHu0wTULLfB
         c1OxJeg8NbTBUzoIYRZCA7uZv8vuq1h+McmwugMvAk62Q1y+Syjh/xPm/Pk83sMD0oQq
         MsHT9SIZMhPGsjAF2gZc6LBEdXes4Juz/RCoiUrIl7FW6ZiEyL4Oi6R6QdJxeF0y/G4f
         H2eMeFtbWWj7fzZDs/NfIEB7sE70/Iq5HAXnciBzHMTkxNVNU8RU18NJc2BBP9SNthA3
         TEzrH60FP4dyY19bPyIwUmpb2NPX0lBhH1Xs9+S8NLCyKKDZIO4d0fpVtioGTevD6BlO
         9K1Q==
X-Gm-Message-State: APjAAAVEjyccRNDTiGfKwleegs21ehVOdYgXy4VTElfqtY4S00C3+H4z
        MYfX9+9uXPcXpvayb7y2Mrtn/YwhMyAnyIl9x3sFiJrqg1sfvkSz6QJNIgnhv/LlayBrHBlnCQq
        deoZRt1/t6q7r
X-Received: by 2002:a05:600c:a:: with SMTP id g10mr3816314wmc.71.1568733247247;
        Tue, 17 Sep 2019 08:14:07 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwF9YRZou9rba0jj+36aOHC5cKqqWC2RMuT6lv4mHM7Undu6Vtwyk71MMpvH3Xf+0DWBq3Sxg==
X-Received: by 2002:a05:600c:a:: with SMTP id g10mr3816284wmc.71.1568733246955;
        Tue, 17 Sep 2019 08:14:06 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c46c:2acb:d8d2:21d8? ([2001:b07:6468:f312:c46c:2acb:d8d2:21d8])
        by smtp.gmail.com with ESMTPSA id r28sm3553198wrr.94.2019.09.17.08.14.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Sep 2019 08:14:06 -0700 (PDT)
Subject: Re: [PATCH v2 00/14] KVM: x86: Remove emulation_result enums
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>
References: <20190827214040.18710-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <8dec39ac-7d69-b1fd-d07c-cf9d014c4af3@redhat.com>
Date:   Tue, 17 Sep 2019 17:14:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190827214040.18710-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/08/19 23:40, Sean Christopherson wrote:
> Rework the emulator and its users to handle failure scenarios entirely
> within the emulator.
> 
> {x86,kvm}_emulate_instruction() currently returns a tri-state value to
> indicate success/continue, userspace exit needed, and failure.  The
> intent of returning EMULATE_FAIL is to let the caller handle failure in
> a manner that is appropriate for the current context.  In practice,
> the emulator has ended up with a mixture of failure handling, i.e.
> whether or not the emulator takes action on failure is dependent on the
> specific flavor of emulation.
> 
> The mixed handling has proven to be rather fragile, e.g. many flows
> incorrectly assume their specific flavor of emulation cannot fail or
> that the emulator sets state to report the failure back to userspace.
> 
> Move everything inside the emulator, piece by piece, so that the
> emulation routines can return '0' for exit to userspace and '1' for
> resume the guest, just like every other VM-Exit handler.
> 
> Patch 13/14 is a tangentially related bug fix that conflicts heavily with
> this series, so I tacked it on here.
> 
> Patch 14/14 documents the emulation types.  I added it as a separate
> patch at the very end so that the comments could reference the final
> state of the code base, e.g. incorporate the rule change for using
> EMULTYPE_SKIP that is introduced in patch 13/14.
> 
> v1:
>   - https://patchwork.kernel.org/cover/11110331/
> 
> v2:
>   - Collect reviews. [Vitaly and Liran]
>   - Squash VMware emultype changes into a single patch. [Liran]
>   - Add comments in VMX/SVM for VMware #GP handling. [Vitaly]
>   - Tack on the EPT misconfig bug fix.
>   - Add a patch to comment/document the emultypes. [Liran]
> 
> Sean Christopherson (14):
>   KVM: x86: Relocate MMIO exit stats counting
>   KVM: x86: Clean up handle_emulation_failure()
>   KVM: x86: Refactor kvm_vcpu_do_singlestep() to remove out param
>   KVM: x86: Don't attempt VMWare emulation on #GP with non-zero error
>     code
>   KVM: x86: Move #GP injection for VMware into x86_emulate_instruction()
>   KVM: x86: Add explicit flag for forced emulation on #UD
>   KVM: x86: Move #UD injection for failed emulation into emulation code
>   KVM: x86: Exit to userspace on emulation skip failure
>   KVM: x86: Handle emulation failure directly in kvm_task_switch()
>   KVM: x86: Move triple fault request into RM int injection
>   KVM: VMX: Remove EMULATE_FAIL handling in handle_invalid_guest_state()
>   KVM: x86: Remove emulation_result enums, EMULATE_{DONE,FAIL,USER_EXIT}
>   KVM: VMX: Handle single-step #DB for EMULTYPE_SKIP on EPT misconfig
>   KVM: x86: Add comments to document various emulation types
> 
>  arch/x86/include/asm/kvm_host.h |  40 +++++++--
>  arch/x86/kvm/mmu.c              |  16 +---
>  arch/x86/kvm/svm.c              |  62 ++++++--------
>  arch/x86/kvm/vmx/vmx.c          | 147 +++++++++++++-------------------
>  arch/x86/kvm/x86.c              | 133 ++++++++++++++++-------------
>  arch/x86/kvm/x86.h              |   2 +-
>  6 files changed, 195 insertions(+), 205 deletions(-)
> 

Queued, thanks (a couple conflicts had to be sorted out, but nothing
requiring a respin).

Paolo
