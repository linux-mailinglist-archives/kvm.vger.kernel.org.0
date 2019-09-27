Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2974C003A
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 09:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbfI0Hpc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 03:45:32 -0400
Received: from mail.codelabs.ch ([109.202.192.35]:39918 "EHLO mail.codelabs.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbfI0Hpc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 03:45:32 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.codelabs.ch (Postfix) with ESMTP id E89DFA0167;
        Fri, 27 Sep 2019 09:45:28 +0200 (CEST)
Received: from mail.codelabs.ch ([127.0.0.1])
        by localhost (fenrir.codelabs.ch [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 7pn2MKSVOG32; Fri, 27 Sep 2019 09:45:26 +0200 (CEST)
Received: from [192.168.10.191] (unknown [192.168.10.191])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.codelabs.ch (Postfix) with ESMTPSA id 80F67A0166;
        Fri, 27 Sep 2019 09:45:26 +0200 (CEST)
Subject: Re: [PATCH 0/2] KVM: nVMX: Bug fix for consuming stale
 vmcs02.GUEST_CR3
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190926214302.21990-1-sean.j.christopherson@intel.com>
From:   Reto Buerki <reet@codelabs.ch>
Openpgp: preference=signencrypt
Autocrypt: addr=reet@codelabs.ch; prefer-encrypt=mutual; keydata=
 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
Message-ID: <4100532d-1bf2-0e55-5f4b-99e574ba7061@codelabs.ch>
Date:   Fri, 27 Sep 2019 09:45:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190926214302.21990-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: de-LU
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/26/19 11:43 PM, Sean Christopherson wrote:
> Reto Buerki reported a failure in a nested VMM when running with HLT
> interception disabled in L1.  When putting L2 into HLT, KVM never actually
> enters L2 and instead cancels the nested run and pretends that VM-Enter to
> L2 completed and then exited on HLT (which KVM intercepted).  Because KVM
> never actually runs L2, KVM skips the pending MMU update for L2 and so
> leaves a stale value in vmcs02.GUEST_CR3.  If the next wake event for L2
> triggers a nested VM-Exit, KVM will refresh vmcs12->guest_cr3 from
> vmcs02.GUEST_CR3 and consume the stale value.
> 
> Fix the issue by unconditionally writing vmcs02.GUEST_CR3 during nested
> VM-Enter instead of deferring the update to vmx_set_cr3(), and skip the
> update of GUEST_CR3 in vmx_set_cr3() when running L2.  I.e. make the
> nested code fully responsible for vmcs02.GUEST_CR3.
> 
> I really wanted to go with a different fix of handling this as a one-off
> case in the HLT flow (in nested_vmx_run()), and then following that up
> with a cleanup of VMX's CR3 handling, e.g. to do proper dirty tracking
> instead of having the nested code do manual VMREADs and VMWRITEs.  I even
> went so far as to hide vcpu->arch.cr3 (put CR3 in vcpu->arch.regs), but
> things went south when I started working through the dirty tracking logic.
> 
> Because EPT can be enabled *without* unrestricted guest, enabling EPT
> doesn't always mean GUEST_CR3 really is the guest CR3 (unlike SVM's NPT).
> And because the unrestricted guest handling of GUEST_CR3 is dependent on
> whether the guest has paging enabled, VMX can't even do a clean handoff
> based on unrestricted guest.  In a nutshell, dynamically handling the
> transitions of GUEST_CR3 ownership in VMX is a nightmare, so fixing this
> purely within the context of nested VMX turned out to be the cleanest fix.
> 
> Sean Christopherson (2):
>   KVM: nVMX: Always write vmcs02.GUEST_CR3 during nested VM-Enter
>   KVM: VMX: Skip GUEST_CR3 VMREAD+VMWRITE if the VMCS is up-to-date
> 
>  arch/x86/kvm/vmx/nested.c |  8 ++++++++
>  arch/x86/kvm/vmx/vmx.c    | 15 ++++++++++-----
>  2 files changed, 18 insertions(+), 5 deletions(-)

Tested-by: Reto Buerki <reet@codelabs.ch>

Thanks!
