Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD5D1EFEEE
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 19:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728163AbgFEReE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 13:34:04 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55789 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728126AbgFEReC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Jun 2020 13:34:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591378440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0aal65plzbeSyYXmLW554nnRb5RbtIzEAofuK3KvvwQ=;
        b=ep2sD15n/kOGnMkAQbxSTSv4JEt4NEExvSmkhPOq3GPe8hOAdqJ4oe2oW3x34irNhAObN9
        lqN+HJoWSlyocAwVsetBoaZSL3Mp+X1chBSPh1pTY5Vweg3EqaiZBYEFxxdfrOKLPLUX0C
        qTVob/rUMMYAuBGIQrylavKs+3BaqaQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-71-9yHlK5lxPiuMrJiV441cNw-1; Fri, 05 Jun 2020 13:33:58 -0400
X-MC-Unique: 9yHlK5lxPiuMrJiV441cNw-1
Received: by mail-wm1-f72.google.com with SMTP id l13so616098wmj.3
        for <kvm@vger.kernel.org>; Fri, 05 Jun 2020 10:33:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0aal65plzbeSyYXmLW554nnRb5RbtIzEAofuK3KvvwQ=;
        b=MAz/e4RzFx3rzi2ewP0IuNZVJrTD9X3nEhY+ms+tJKb1vtMDkGahAv03XWp5Ggtvop
         fH88M9/qxEc2GzNwCGfJ/G3AkiPvrYpauBq9D0Z70djci35YUrjIB5jw0KOyWJnh0esz
         31zNpKWef4316HbnOTh2aVCEFsFC39lHGyGOEiHe+fuo9zyU3kTO4ecgRHAzArU0ktjU
         tbzoX1c3TLloqm33a8MZQeOTbVZDfmxuG+9vFRLdP80LYL0/5sEAHpyr8fHYL4GGv5In
         dgzcUhObn9ymPdew27fEDkKptkF6uL351xpZ8tsRvCoAsUW3adf4Rk25KkO2bUJbeOj8
         1zMA==
X-Gm-Message-State: AOAM530kHMSgOiOsLF9rmksgD8bqRDd4gU3mZdQkuq0TiDXSBjWewvKT
        IB/fb3atxoogYz0INpPwqEUimtvcbriVQCsBp/vQPzQzcy9xXB4Ixh1cwjJbvRlPweHjXHFh/jY
        QDrEcqvTj2zEh
X-Received: by 2002:a5d:4e8c:: with SMTP id e12mr10304101wru.194.1591378437010;
        Fri, 05 Jun 2020 10:33:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyWiRtmf6SMYmlHoEbROCKhYR9wsQ37MKaaPkjq7nH4qScnMbizM4PvJ33BL3NHlCV8yf8D+g==
X-Received: by 2002:a5d:4e8c:: with SMTP id e12mr10304083wru.194.1591378436727;
        Fri, 05 Jun 2020 10:33:56 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.243.176])
        by smtp.gmail.com with ESMTPSA id c16sm12977772wrx.4.2020.06.05.10.33.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2020 10:33:56 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] Revert "KVM: x86: work around leak of
 uninitialized stack contents"
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
References: <20200605115906.532682-1-vkuznets@redhat.com>
 <20200605115906.532682-2-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <100b82ab-d6f5-7b0e-2d4b-13bc16ec273f@redhat.com>
Date:   Fri, 5 Jun 2020 19:33:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200605115906.532682-2-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/06/20 13:59, Vitaly Kuznetsov wrote:
> handle_vmptrst()/handle_vmread() stopped injecting #PF unconditionally
> and switched to nested_vmx_handle_memory_failure() which just kills the
> guest with KVM_EXIT_INTERNAL_ERROR in case of MMIO access, zeroing
> 'exception' in kvm_write_guest_virt_system() is not needed anymore.
> 
> This reverts commit 541ab2aeb28251bf7135c7961f3a6080eebcc705.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9e41b5135340..0097a97d331f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5647,13 +5647,6 @@ int kvm_write_guest_virt_system(struct kvm_vcpu *vcpu, gva_t addr, void *val,
>  	/* kvm_write_guest_virt_system can pull in tons of pages. */
>  	vcpu->arch.l1tf_flush_l1d = true;
>  
> -	/*
> -	 * FIXME: this should call handle_emulation_failure if X86EMUL_IO_NEEDED
> -	 * is returned, but our callers are not ready for that and they blindly
> -	 * call kvm_inject_page_fault.  Ensure that they at least do not leak
> -	 * uninitialized kernel stack memory into cr2 and error code.
> -	 */
> -	memset(exception, 0, sizeof(*exception));
>  	return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
>  					   PFERR_WRITE_MASK, exception);
>  }
> 

Queued, thanks.

Paolo

