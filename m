Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F126C33CFF6
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 09:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234980AbhCPIf0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 04:35:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:54572 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234981AbhCPIe4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 04:34:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D4790AE5C;
        Tue, 16 Mar 2021 08:34:54 +0000 (UTC)
Date:   Tue, 16 Mar 2021 09:34:57 +0100
From:   Borislav Petkov <bp@suse.de>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Kieran Bingham <kbingham@kernel.org>,
        Jessica Yu <jeyu@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 3/3] KVM: SVM: allow to intercept all exceptions for debug
Message-ID: <20210316083457.GA18822@zn.tnic>
References: <20210315221020.661693-1-mlevitsk@redhat.com>
 <20210315221020.661693-4-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210315221020.661693-4-mlevitsk@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 16, 2021 at 12:10:20AM +0200, Maxim Levitsky wrote:
> Add a new debug module param 'debug_intercept_exceptions' which will allow the
> KVM to intercept any guest exception, and forward it to the guest.
> 
> This can be very useful for guest debugging and/or KVM debugging with kvm trace.
> This is not intended to be used on production systems.
> 
> This is based on an idea first shown here:
> https://patchwork.kernel.org/project/kvm/patch/20160301192822.GD22677@pd.tnic/
> 
> CC: Borislav Petkov <bp@suse.de>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>

> ---
>  arch/x86/include/asm/kvm_host.h |  2 +
>  arch/x86/kvm/svm/svm.c          | 77 ++++++++++++++++++++++++++++++++-
>  arch/x86/kvm/svm/svm.h          |  5 ++-
>  arch/x86/kvm/x86.c              |  5 ++-
>  4 files changed, 85 insertions(+), 4 deletions(-)

Looks interesting, I'll give it a try when I get a chance in the coming days.

Thx!

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
