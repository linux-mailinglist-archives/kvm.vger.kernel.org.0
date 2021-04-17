Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5E5A36308B
	for <lists+kvm@lfdr.de>; Sat, 17 Apr 2021 16:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236452AbhDQOMB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Apr 2021 10:12:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23704 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236287AbhDQOMA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 17 Apr 2021 10:12:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618668693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8cZRq53B7la3BW2tolFkxnp9WJORZDssfh0utYgNoEw=;
        b=gFJ4CxW4iWmsqT7x3VZrbQTreqxx/gq2fpA0JTsUVe/MW7mVLMCx7qhksMhkjrEjOyZVDe
        Vzhl9Xm6d6Objwmt6cQHTzVOSpKm+ug1CgQVrtd9cKIMPQmObUuYINd1PyYQJ5gkedoVQN
        J702jNpp61PzV252SWBZuWmN8NBF32w=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-D9Nundt3N6OPUji2alMayA-1; Sat, 17 Apr 2021 10:11:31 -0400
X-MC-Unique: D9Nundt3N6OPUji2alMayA-1
Received: by mail-ed1-f69.google.com with SMTP id o4-20020a0564024384b0290378d45ecf57so8754565edc.12
        for <kvm@vger.kernel.org>; Sat, 17 Apr 2021 07:11:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8cZRq53B7la3BW2tolFkxnp9WJORZDssfh0utYgNoEw=;
        b=GVJel4qd5a8p48wp/lH/1eIDq5AV01ouZX1TwHQMLc0hRfg6aLmUlxS6dmKrYSuOQh
         Q2brjFW8Eidb5FgYMAqVfJb7prmdqB1tL6CArUIDmrnXUcjCYYD8ArY/D97ncH2mmzOc
         DLhvRZwU9tkgX/tjX8SvC4H6vSwmKXideDGaj4gDP/C7hmSlhz8TICjvorloFaZWnJUu
         vYlLa+aV9TlzCCjksne6Y74+9aMJzPe+bylmt+8X2ocLhisy4goWXGfagsGhIOGTBy0l
         yMHAHxF0GXu1p2DhG5yVzCJUTuXZSbuAY3eio63vvI9rZiOHdsvbgV/U35bJ3R34KQVE
         bZ6A==
X-Gm-Message-State: AOAM530j7OAkHHKZdiq2I0bcDlPXzTd1wGJzJn3+wfmuxLYOHogDLhhw
        J7nf++ofs7J9SAf8yYKJ1OxM9rAQ+LbkA4k6j0kG5e3p73uCMeP90EhKabHuOl97t/8VSAPTmfn
        DYYGisj+JqCax
X-Received: by 2002:a05:6402:453:: with SMTP id p19mr8722501edw.88.1618668690657;
        Sat, 17 Apr 2021 07:11:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy70bgbaAzlplSM3WlO360m5Cssrp++vVHTLmCkI43C9XOKAHatRoMfGDyinFJHlLEWw43NhQ==
X-Received: by 2002:a05:6402:453:: with SMTP id p19mr8722486edw.88.1618668690471;
        Sat, 17 Apr 2021 07:11:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w13sm7469179edx.80.2021.04.17.07.11.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Apr 2021 07:11:29 -0700 (PDT)
To:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        linux-sgx@vger.kernel.org
Cc:     seanjc@google.com, bp@alien8.de, jarkko@kernel.org,
        dave.hansen@intel.com, luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com
References: <cover.1618196135.git.kai.huang@intel.com>
 <a99e9c23310c79f2f4175c1af4c4cbcef913c3e5.1618196135.git.kai.huang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v5 10/11] KVM: VMX: Enable SGX virtualization for SGX1,
 SGX2 and LC
Message-ID: <9f568584-8b09-afe6-30a1-cbe280749f5d@redhat.com>
Date:   Sat, 17 Apr 2021 16:11:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <a99e9c23310c79f2f4175c1af4c4cbcef913c3e5.1618196135.git.kai.huang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/04/21 06:21, Kai Huang wrote:
> @@ -4377,6 +4380,15 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
>   	if (!vcpu->kvm->arch.bus_lock_detection_enabled)
>   		exec_control &= ~SECONDARY_EXEC_BUS_LOCK_DETECTION;
>   
> +	if (cpu_has_vmx_encls_vmexit() && nested) {
> +		if (guest_cpuid_has(vcpu, X86_FEATURE_SGX))
> +			vmx->nested.msrs.secondary_ctls_high |=
> +				SECONDARY_EXEC_ENCLS_EXITING;
> +		else
> +			vmx->nested.msrs.secondary_ctls_high &=
> +				~SECONDARY_EXEC_ENCLS_EXITING;
> +	}
> +

This is incorrect, I've removed it.  The MSRs can only be written by 
userspace.

If SGX is disabled in the guest CPUID, nested_vmx_exit_handled_encls can 
just do:

	if (!guest_cpuid_has(vcpu, X86_FEATURE_SGX) ||
	    !nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENCLS_EXITING))
		return false;

and the useless ENCLS exiting bitmap in vmcs12 will be ignored.

Paolo

