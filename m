Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDBA6C1F56
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 12:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730637AbfI3KnB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 06:43:01 -0400
Received: from mail.codelabs.ch ([109.202.192.35]:53120 "EHLO mail.codelabs.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729870AbfI3KnB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 06:43:01 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.codelabs.ch (Postfix) with ESMTP id 0CEF2A0167;
        Mon, 30 Sep 2019 12:42:57 +0200 (CEST)
Received: from mail.codelabs.ch ([127.0.0.1])
        by localhost (fenrir.codelabs.ch [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id MDvV1xvHi7qw; Mon, 30 Sep 2019 12:42:54 +0200 (CEST)
Received: from [192.168.10.191] (unknown [192.168.10.191])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.codelabs.ch (Postfix) with ESMTPSA id 6675EA0148;
        Mon, 30 Sep 2019 12:42:54 +0200 (CEST)
Subject: Re: [PATCH v2 0/8] KVM: x86: nVMX GUEST_CR3 bug fix, and then some...
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>
References: <20190927214523.3376-1-sean.j.christopherson@intel.com>
From:   Reto Buerki <reet@codelabs.ch>
Openpgp: preference=signencrypt
Autocrypt: addr=reet@codelabs.ch; prefer-encrypt=mutual; keydata=
 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
Message-ID: <8414d3e8-9a68-e817-de5a-3e9ca6dc85bb@codelabs.ch>
Date:   Mon, 30 Sep 2019 12:42:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190927214523.3376-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/27/19 11:45 PM, Sean Christopherson wrote:
> *sigh*
> 
> v2 was shaping up to be a trivial update, until I started working on
> Vitaly's suggestion to add a helper to test for register availability.
> 
> The primary purpose of this series is to fix a CR3 corruption in L2
> reported by Reto Buerki when running with HLT interception disabled in L1.
> On a nested VM-Enter that puts L2 into HLT, KVM never actually enters L2
> and instead mimics HLT interception by canceling the nested run and
> pretending that VM-Enter to L2 completed and then exited on HLT (which
> KVM intercepted).  Because KVM never actually runs L2, KVM skips the
> pending MMU update for L2 and so leaves a stale value in vmcs02.GUEST_CR3.
> If the next wake event for L2 triggers a nested VM-Exit, KVM will refresh
> vmcs12->guest_cr3 from vmcs02.GUEST_CR3 and consume the stale value.
> 
> Fix the issue by unconditionally writing vmcs02.GUEST_CR3 during nested
> VM-Enter instead of deferring the update to vmx_set_cr3(), and skip the
> update of GUEST_CR3 in vmx_set_cr3() when running L2.  I.e. make the
> nested code fully responsible for vmcs02.GUEST_CR3.
> 
> Patch 02/08 is a minor optimization to skip the GUEST_CR3 update if
> vmcs01 is already up-to-date.
> 
> Patches 03 and beyond are Vitaly's fault ;-).
> 
> Patches 03 and 04 are tangentially related cleanup to vmx_set_rflags()
> that was discovered when working through the avail/dirty testing code.
> Ideally they'd be sent as a separate series, but they conflict with the
> avail/dirty helper changes and are themselves minor and straightforward.
> 
> Patches 05 and 06 clean up the register caching code so that there is a
> single enum for all registers which use avail/dirty tracking.  While not
> a true prerequisite for the avail/dirty helpers, the cleanup allows the
> new helpers to take an 'enum kvm_reg' instead of a less helpful 'int reg'.
> 
> Patch 07 is the helpers themselves, as suggested by Vitaly.
> 
> Patch 08 is a truly optional change to ditch decache_cr3() in favor of
> handling CR3 via cache_reg() like any other avail/dirty register.
> 
> 
> Note, I collected the Reviewed-by and Tested-by tags for patches 01 and 02
> even though I inverted the boolean from 'skip_cr3' to 'update_guest_cr3'.
> Please drop the tags if that constitutes a non-trivial functional change.
> 
> v2:
>   - Invert skip_cr3 to update_guest_cr3.  [Liran]
>   - Reword the changelog and comment to be more explicit in detailing
>     how/when KVM will process a nested VM-Enter without runnin L2.  [Liran]
>   - Added Reviewed-by and Tested-by tags.
>   - Add a comment in vmx_set_cr3() to explicitly state that nested
>     VM-Enter is responsible for loading vmcs02.GUEST_CR3.  [Jim]
>   - All of the loveliness in patches 03-08. [Vitaly]
> 
> Sean Christopherson (8):
>   KVM: nVMX: Always write vmcs02.GUEST_CR3 during nested VM-Enter
>   KVM: VMX: Skip GUEST_CR3 VMREAD+VMWRITE if the VMCS is up-to-date
>   KVM: VMX: Consolidate to_vmx() usage in RFLAGS accessors
>   KVM: VMX: Optimize vmx_set_rflags() for unrestricted guest
>   KVM: x86: Add WARNs to detect out-of-bounds register indices
>   KVM: x86: Fold 'enum kvm_ex_reg' definitions into 'enum kvm_reg'
>   KVM: x86: Add helpers to test/mark reg availability and dirtiness
>   KVM: x86: Fold decache_cr3() into cache_reg()
> 
>  arch/x86/include/asm/kvm_host.h |  5 +-
>  arch/x86/kvm/kvm_cache_regs.h   | 67 +++++++++++++++++------
>  arch/x86/kvm/svm.c              |  5 --
>  arch/x86/kvm/vmx/nested.c       | 14 ++++-
>  arch/x86/kvm/vmx/vmx.c          | 94 ++++++++++++++++++---------------
>  arch/x86/kvm/x86.c              | 13 ++---
>  arch/x86/kvm/x86.h              |  6 +--
>  7 files changed, 123 insertions(+), 81 deletions(-)

Series:
Tested-by: Reto Buerki <reet@codelabs.ch>

Thanks.
