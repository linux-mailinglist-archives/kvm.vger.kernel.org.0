Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98099168210
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 16:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728976AbgBUPnq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 10:43:46 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:20783 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728177AbgBUPnq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Feb 2020 10:43:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582299825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9hFApa4WnwgjLlt8qFRZkEDvrHl4A5ayxF4/D+craX4=;
        b=HCAub9j4uDstyv9fCWG6n2gOo7gINFU1Jpe1efobxH992q9pcbYlpMMopE8lqdU+ua3aAG
        z8bvKuM56wOP2FL2AZZK2zXXeM+06K2f4dQki0eNQvE8F+sgK8HOLQOwTsJuQeF2xOtu7e
        oHOJogMWxfuCbbb+ZoSWzUO8jqNmBgk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-4tktPMMvPGGWdaiGTUXwGA-1; Fri, 21 Feb 2020 10:43:43 -0500
X-MC-Unique: 4tktPMMvPGGWdaiGTUXwGA-1
Received: by mail-wm1-f69.google.com with SMTP id q125so736503wme.1
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 07:43:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=9hFApa4WnwgjLlt8qFRZkEDvrHl4A5ayxF4/D+craX4=;
        b=EAFklD2c1tq6OAlCDMkpqTDAqw0ZqZMHq8uksCwpUGTMJp5OyXsQ6yJ7p1Q1Hfxh0g
         Ow1iOR9AyA4GELBPnYgInVTLAIYF6OWEPJukjSsaXAnwo1L4eOO7GegAVPWu0slRBYYh
         +SmPkwjWJhop3vK9V7iLCmbrTBMTrLvUD8Hpxd3ZlLXLRmMVCGP9kXuTG32mMWx14JBY
         vDFra/IiwqI4BBSJE/varxbWCM4Z2tWOmTS4Kk7a3S+x1hgMpG13oeaghfZdZoWtCrG+
         H/es6lBL48rXfaDjWK+Q1218SlXyYUOouClnPa6q83rYfV7SkE3rQmu92Z+LWroQ3yvR
         55RA==
X-Gm-Message-State: APjAAAXE1eeK4xet2penOnZTyhQJ6QyMlL7mj+r9BCrhjo9kdANLhXHj
        ngFd14b1ofuqlCPbYFYr31zWA38V1cgSk1UYGW5OrImQIiP7T7xNSK1IyyJbhcwrGbDv2wEITaI
        Bs7Ha+Gsnx+Y4
X-Received: by 2002:a5d:6646:: with SMTP id f6mr52594213wrw.276.1582299822619;
        Fri, 21 Feb 2020 07:43:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqwgLS/yqhalljwOZqZcOADqCDtfZeqLFsApuyQ44lfuvXa1CFlCcvGehaEzyXxYthKCMSpZ0A==
X-Received: by 2002:a5d:6646:: with SMTP id f6mr52594192wrw.276.1582299822418;
        Fri, 21 Feb 2020 07:43:42 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id x132sm7789284wmg.0.2020.02.21.07.43.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 07:43:41 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 25/61] KVM: x86: Use u32 for holding CPUID register value in helpers
In-Reply-To: <20200201185218.24473-26-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-26-sean.j.christopherson@intel.com>
Date:   Fri, 21 Feb 2020 16:43:41 +0100
Message-ID: <878skwq72q.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Change the intermediate CPUID output register values from "int" to "u32"
> to match both hardware and the storage type in struct cpuid_reg.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/cpuid.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index c1ac0995843d..72a79bdfed6b 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -95,7 +95,7 @@ static __always_inline struct cpuid_reg x86_feature_cpuid(unsigned x86_feature)
>  	return reverse_cpuid[x86_leaf];
>  }
>  
> -static __always_inline int *guest_cpuid_get_register(struct kvm_vcpu *vcpu, unsigned x86_feature)
> +static __always_inline u32 *guest_cpuid_get_register(struct kvm_vcpu *vcpu, unsigned x86_feature)
>  {
>  	struct kvm_cpuid_entry2 *entry;
>  	const struct cpuid_reg cpuid = x86_feature_cpuid(x86_feature);
> @@ -121,7 +121,7 @@ static __always_inline int *guest_cpuid_get_register(struct kvm_vcpu *vcpu, unsi
>  
>  static __always_inline bool guest_cpuid_has(struct kvm_vcpu *vcpu, unsigned x86_feature)
>  {
> -	int *reg;
> +	u32 *reg;
>  
>  	reg = guest_cpuid_get_register(vcpu, x86_feature);
>  	if (!reg)
> @@ -132,7 +132,7 @@ static __always_inline bool guest_cpuid_has(struct kvm_vcpu *vcpu, unsigned x86_
>  
>  static __always_inline void guest_cpuid_clear(struct kvm_vcpu *vcpu, unsigned x86_feature)
>  {
> -	int *reg;
> +	u32 *reg;
>  
>  	reg = guest_cpuid_get_register(vcpu, x86_feature);
>  	if (reg)

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

