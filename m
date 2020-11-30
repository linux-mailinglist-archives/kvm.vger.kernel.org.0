Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 917972C8F62
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 21:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbgK3Urg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 15:47:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbgK3Urg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 15:47:36 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 578FFC0613CF
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 12:46:56 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id b12so342109pjl.0
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 12:46:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=x/UYRKS76yf6XV+YyHN7tG/MDSMbk5GQZD17BxeoDQc=;
        b=rXQMEKhuYVlgYkKLJroBygELIhh6G8eDW0jobPSDwfbRN9nDDLCqjs25zkkiEajzVX
         HEzfZ6kcm6GXau86ybPvY8uJlfCTdRNAcqxVOtgV1LsQYD+lITz4ZukV7THocsSson5u
         572Yv6G8Vc+DplRaeVP0hFH8JAzWkc/rLzM2T95z1fpG3r0YyPdOvSiAlFWBLNjKAoKQ
         77J5xcYYMx6VQUV3OyQaPzWmsgzbfVucGs63ZbCg0TOrxZlEpdxCeknB1NTDhm3o+dwo
         K48H/RzJ2d2YHeEjLVVeARlMfYhGWLLlS8l6/fb+C/QCg7OIYqB6o1dGmlRyJJTVo9g6
         lKMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=x/UYRKS76yf6XV+YyHN7tG/MDSMbk5GQZD17BxeoDQc=;
        b=aL0MF+JO8r/beck86uIPCRrluE6x5to6PPEFn/trDwLsLxERk4fZ7TV2nNk4/Hpfcl
         bni9PV/X24aDho+FPfCz9wF/QXALTUgprO8tcSn0hI5aI1oMHCVNii2U7WI19mi0O6rL
         +nMAoIleZeKbvMu0NRLkssUwmLakhueOe86p2AOz1FFRRCGLfa0FjiaaB9JmyHGyMwgp
         MljqN4Wn6GegFPNfQVD15t7Fi30iU3ii5fTNrjy7TuaBnDJVYzYeFBStbZdknDZNnpfT
         AdzNaEG1j8FEO3SmUyFYXsFqurGPUKR4ArdJx2xnJxU+0M6PLWduTzi3nkh1JUtpoqBW
         zXVg==
X-Gm-Message-State: AOAM533l8nX2z5apf6CZSKGRnye/LOBX6ZU+X3G65F31fGUOXIw1tD7j
        Kqv8Rp4XF7SBAQcxvXHnlzJJ0A==
X-Google-Smtp-Source: ABdhPJyb2yNeVPyi+nFomtJJqjOlBw81ew0j5HgRPmLNgebOlaGqNOBkJarwL+Kznzr1NeXQ0Kb58A==
X-Received: by 2002:a17:90b:1218:: with SMTP id gl24mr746492pjb.130.1606769215774;
        Mon, 30 Nov 2020 12:46:55 -0800 (PST)
Received: from google.com (242.67.247.35.bc.googleusercontent.com. [35.247.67.242])
        by smtp.gmail.com with ESMTPSA id u4sm1039406pgg.48.2020.11.30.12.46.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 12:46:55 -0800 (PST)
Date:   Mon, 30 Nov 2020 20:46:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: Reinstate userspace hypercall support
Message-ID: <X8VaO9DxaaKP7PFl@google.com>
References: <1bde4a992be29581e559f7a57818e206e11f84f5.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bde4a992be29581e559f7a57818e206e11f84f5.camel@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 28, 2020, David Woodhouse wrote:

...

> +static int complete_userspace_hypercall(struct kvm_vcpu *vcpu)
> +{
> +	kvm_rax_write(vcpu, vcpu->run->hypercall.ret);
> +
> +	return kvm_skip_emulated_instruction(vcpu);

This should probably verify the linear RIP is unchanged before modifying guest
state, e.g. to let userspace reset the vCPU in response to a hypercall.  See
complete_fast_pio_out().

> +}
> +
> +int kvm_userspace_hypercall(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_run *run = vcpu->run;
> +
> +	if (is_long_mode(vcpu)) {
> +		run->hypercall.longmode = 1;

Should this also capture the CPL?  I assume the motivation for grabbing regs
and longmode is to avoid having to call back into KVM on every hypercall, and I
also assume there are (or will be) hypercalls that are CPL0 only.

> +		run->hypercall.nr = kvm_rax_read(vcpu);
> +		run->hypercall.args[0] = kvm_rdi_read(vcpu);
> +		run->hypercall.args[1] = kvm_rsi_read(vcpu);
> +		run->hypercall.args[2] = kvm_rdx_read(vcpu);
> +		run->hypercall.args[3] = kvm_r10_read(vcpu);
> +		run->hypercall.args[4] = kvm_r8_read(vcpu);
> +		run->hypercall.args[5] = kvm_r9_read(vcpu);
> +		run->hypercall.ret = -KVM_ENOSYS;
> +	} else {
> +		run->hypercall.longmode = 0;
> +		run->hypercall.nr = (u32)kvm_rbx_read(vcpu);
> +		run->hypercall.args[0] = (u32)kvm_rbx_read(vcpu);
> +		run->hypercall.args[1] = (u32)kvm_rcx_read(vcpu);
> +		run->hypercall.args[2] = (u32)kvm_rdx_read(vcpu);
> +		run->hypercall.args[3] = (u32)kvm_rsi_read(vcpu);
> +		run->hypercall.args[4] = (u32)kvm_rdi_read(vcpu);
> +		run->hypercall.args[5] = (u32)kvm_rbp_read(vcpu);
> +		run->hypercall.ret = (u32)-KVM_ENOSYS;
> +	}

Why not get/set all GPRs (except maybe RIP and RSP) as opposed to implementing 
what I presume is Xen's ABI in a generic KVM user exit?  Copying 10 more GPRs
to/from memory is likely lost in the noise relative to the cost of the userspace
roundtrip.

> +	run->exit_reason = KVM_EXIT_HYPERCALL;
> +	vcpu->arch.complete_userspace_io = complete_userspace_hypercall;
> +
> +	return 0;
> +}
> +
>  int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  {
>  	unsigned long nr, a0, a1, a2, a3, ret;
>  	int op_64_bit;
>  
> +	if (vcpu->kvm->arch.user_space_hypercall)
> +		return kvm_userspace_hypercall(vcpu);
> +
>  	if (kvm_hv_hypercall_enabled(vcpu->kvm))
>  		return kvm_hv_hypercall(vcpu);
>  
