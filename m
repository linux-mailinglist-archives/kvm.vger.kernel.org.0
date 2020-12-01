Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5162CACA1
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 20:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392452AbgLATob (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Dec 2020 14:44:31 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:57580 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388204AbgLATob (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Dec 2020 14:44:31 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606851829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oZMSZJ9B+pz4ruoX5S7orWGoTaF0HgBc602QZCF7JU0=;
        b=QyfQHzxckn7qkBjfSV1pVAqUbTsikduDPHWrdQAG4HTwq3CU87bm9fh86gPlw6fEmGjQRu
        FsIWiMLLpu8hq2exqVwQAmoAX/A9ua6qeL+qEQurSj2OvookL6Bfwym7sj+lxqoxq8Fkyy
        F22enYcGxORliy0GZB+lzqdE0V2En9mFxRrmdLXvh2gRd7d0+CB2vnghntpG9TiOp7kwfg
        2xYQO2IGZp/p29qKcHwRwJEGDte9MrezEjaoJL72J7zA8Gmd3Nw+EJkLg4JUH05w/l04le
        6TC0fOtF0Zkq9x9ETfEjMfGTXQgUv/lfOXL/WGRT37ZDof1+UXmE8zuC4J7Z2A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606851829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oZMSZJ9B+pz4ruoX5S7orWGoTaF0HgBc602QZCF7JU0=;
        b=IV+1qwmcMVimGabIbOlbCXyCdVSW8AFP3DTZ8qkuiNlrV6sVb/EFXVJQPGl2uW/HuMh/2E
        AMwe7s/QlMKY39AA==
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list\:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer\:X86 ARCHITECTURE \(32-BIT AND 64-BIT\)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 1/2] KVM: x86: implement KVM_SET_TSC_PRECISE/KVM_GET_TSC_PRECISE
In-Reply-To: <20201130133559.233242-2-mlevitsk@redhat.com>
References: <20201130133559.233242-1-mlevitsk@redhat.com> <20201130133559.233242-2-mlevitsk@redhat.com>
Date:   Tue, 01 Dec 2020 20:43:49 +0100
Message-ID: <87h7p5fh1m.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 30 2020 at 15:35, Maxim Levitsky wrote:
> +  struct kvm_tsc_info {
> +	__u32 flags;
> +	__u64 nsec;
> +	__u64 tsc;
> +	__u64 tsc_adjust;
> +  };
> +
> +flags values for ``struct kvm_tsc_info``:
> +
> +``KVM_TSC_INFO_TSC_ADJUST_VALID``
> +
> +  ``tsc_adjust`` contains valid IA32_TSC_ADJUST value

Why exposing TSC_ADJUST at all? Just because?

Thanks,

        tglx
