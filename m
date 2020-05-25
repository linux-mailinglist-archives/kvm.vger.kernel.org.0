Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDA4F1E118E
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 17:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404028AbgEYPWQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 11:22:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59022 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2403961AbgEYPWQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 11:22:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590420134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3TJhizQZw710Ykbd4e66mhSmTv6uHiaL8SGhqXCINH4=;
        b=GkTeX10eFJAhgr+nodDYWsigSQE6JJqGB1aefTBSksjmU7QRIX370ZnZ+NDFzG/CsXxNY3
        l+bDwmCjZADDaiBcFqv7boCw1QcPQHT06P9on2/gZLBtjmDEPE9Xg3AuM7581nx/rh8K8h
        BHJkFySH2+lrTuLg4NU93V0qSVvGlFY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-T2XkViTLNMSDx-ytUh40sA-1; Mon, 25 May 2020 11:22:13 -0400
X-MC-Unique: T2XkViTLNMSDx-ytUh40sA-1
Received: by mail-ed1-f71.google.com with SMTP id w15so6996556edi.11
        for <kvm@vger.kernel.org>; Mon, 25 May 2020 08:22:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=3TJhizQZw710Ykbd4e66mhSmTv6uHiaL8SGhqXCINH4=;
        b=Inlbvl6ZK0WLBfnNBHl3GNpAqi6+pPRHE8JG3QJ/XRsCtT2NviDOTjtsI/fHqiSZup
         BJN2TnbxLtL9+vQuGGt1bY4pvDeuVPL6KfTuI+yyrFWHeSnlDeSUzme1GBWWpyuxbVuF
         PYPUYfwNMQhsRobcUZfcP4mPOwaFalVLl1axi5LQ0fm5Qz8wfvXSAeqbkS2A8y1OiZjw
         WCXEJOaU5QJsF/zYWTlpUWFIsfJHFMSGewjigvA5pxU5TA2oHyFQixLT02xhucCfivKQ
         RE/yNyo7AOTnOZBNzDClTOxzdKcdyi3+AxEVy3LvuJw2xPFUguZOpzGk8Fy+95ZtpfnX
         7LVg==
X-Gm-Message-State: AOAM530eXDx26NGLnDUgEDtc4ZRdSMBkHgNNl2/BArgREeqIMxRum6XZ
        iFgxafqORkaXpflnzbB5yf1+IBTFgtn5nH5RLas8WFWtUZb+EM/S/NRi/FVdOVwIPWDiHD373iI
        xhHDBngQ+Qdqv
X-Received: by 2002:a17:907:392:: with SMTP id ss18mr20203726ejb.156.1590420132119;
        Mon, 25 May 2020 08:22:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyHlp16CRg1vF1duz4SE4yZIQh96KMOz7B1Iv5p6TQx/Ia7dapZMBxC7JxsIRul4uyMhi9igw==
X-Received: by 2002:a17:907:392:: with SMTP id ss18mr20203709ejb.156.1590420131831;
        Mon, 25 May 2020 08:22:11 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id cd12sm16045340ejb.95.2020.05.25.08.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 08:22:11 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe\, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen\, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [RFC 13/16] x86/kvmclock: Share hvclock memory with the host
In-Reply-To: <20200522125214.31348-14-kirill.shutemov@linux.intel.com>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com> <20200522125214.31348-14-kirill.shutemov@linux.intel.com>
Date:   Mon, 25 May 2020 17:22:10 +0200
Message-ID: <875zck82fx.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Kirill A. Shutemov" <kirill@shutemov.name> writes:

> hvclock is shared between the guest and the hypervisor. It has to be
> accessible by host.
>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  arch/x86/kernel/kvmclock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index 34b18f6eeb2c..ac6c2abe0d0f 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -253,7 +253,7 @@ static void __init kvmclock_init_mem(void)
>  	 * hvclock is shared between the guest and the hypervisor, must
>  	 * be mapped decrypted.
>  	 */
> -	if (sev_active()) {
> +	if (sev_active() || kvm_mem_protected()) {
>  		r = set_memory_decrypted((unsigned long) hvclock_mem,
>  					 1UL << order);
>  		if (r) {

Sorry if I missed something but we have other structures which KVM guest
share with the host,

sev_map_percpu_data():
...
	for_each_possible_cpu(cpu) {
		__set_percpu_decrypted(&per_cpu(apf_reason, cpu), sizeof(apf_reason));
		__set_percpu_decrypted(&per_cpu(steal_time, cpu), sizeof(steal_time));
		__set_percpu_decrypted(&per_cpu(kvm_apic_eoi, cpu), sizeof(kvm_apic_eoi));
	}
...

Do you handle them somehow in the patchset? (I'm probably just blind
failing to see how 'early_set_memory_decrypted()' is wired up)

-- 
Vitaly

