Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35565422074
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 10:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233312AbhJEISt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 04:18:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31587 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232965AbhJEISs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 04:18:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633421818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DeXqgvhgZgba5cIjEbA+9+dV2VIz1J/oWf8XDFTEfK8=;
        b=TIWt8QpgIG0h4BiN5pJEKug5lL6wmBSsc07u8t5LM1j4L5tGGiGYrkuqcyAZ+CxULRSr8S
        mpgEvQkXKkJbj5lt/CdKrukd7e8ZzyqKQZEXGUlhvTmWmpfAAuRXQCeSAfHVbyOBTgHuZm
        Ddl6mGnAYIN7UuqqmnE7zjB3InrTZrA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-DK0pzxehMvmpalx93ZWMnA-1; Tue, 05 Oct 2021 04:16:57 -0400
X-MC-Unique: DK0pzxehMvmpalx93ZWMnA-1
Received: by mail-ed1-f69.google.com with SMTP id u17-20020a50d511000000b003daa3828c13so19849738edi.12
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 01:16:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DeXqgvhgZgba5cIjEbA+9+dV2VIz1J/oWf8XDFTEfK8=;
        b=OUDUkGB8WtJfm5yH/zYjG03w+f0nZxzrbaKD1ZIiWopaNUxz7YpStK720oRMLXDa3w
         IVfcKVTMPolbyRsv+yvD5W/cbdyv3oo73um4NY+6+imkh4jq+1MV7jbTX2sVFv1Qcvrg
         EhTuNhX3BSXR+85AvyDTYhidDxLDH12Y7wN+QlkrMyONDPeRvKyowzCEHGJM0DL1q0Ls
         11QX5YcU8uKKwM0gpzfcmvL2LjE0Q2zW9vKIpWpApTBHv/AESQP3XeEAhPXgHr3o56iV
         kYJvDcBFXN/WB91YfBVufObA27Lqph9hoX/KOq09t0gI6GkzkWDHcMJL0qcz+VkCTxCs
         mfsA==
X-Gm-Message-State: AOAM533VXxgcWBCCeYu4B0Z3PR5GF5OcuE0VwGP0x2oUX2U2TG8Wsl9U
        gQRgkp3Z+4SMDWVUupigWpx2WXG8L6aQheLyayLG1WCMl9e8u8d7AbI1NTXRwZn4tjvxxZVHQXj
        Xag4AxU7uBWBc
X-Received: by 2002:a17:907:7752:: with SMTP id kx18mr23187398ejc.276.1633421815923;
        Tue, 05 Oct 2021 01:16:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzmXIYwBOhjzUkkaolL36RKArL5ziaNRpgjgyrCtjtf0CYVdBeKNCWcMb3UURJlB/NfDNp5cA==
X-Received: by 2002:a17:907:7752:: with SMTP id kx18mr23187377ejc.276.1633421815739;
        Tue, 05 Oct 2021 01:16:55 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id b2sm8435115edv.73.2021.10.05.01.16.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 01:16:55 -0700 (PDT)
Message-ID: <e99f0dcc-0748-9754-cca1-916ff6be406e@redhat.com>
Date:   Tue, 5 Oct 2021 10:16:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v10 10/28] x86/fpu/xstate: Update the XSTATE save function
 to support dynamic states
Content-Language: en-US
To:     "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     "bp@suse.de" <bp@suse.de>, "Lutomirski, Andy" <luto@kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Macieira, Thiago" <thiago.macieira@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <87pmsnglkr.ffs@tglx>
 <0F4DCBED-7A0B-4C0C-A63A-3C7E9AC065D5@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <0F4DCBED-7A0B-4C0C-A63A-3C7E9AC065D5@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/10/21 00:54, Bae, Chang Seok wrote:
> FWIW, the proposed KVM patch for AMX looks to take (1) here [1] and
> Paolo said [2]:
> 
>      Most guests will not need the whole xstate feature set.  So perhaps you
>      could set XFD to the host value | the guest value, trap #NM if the
>      host XFD is zero, and possibly reflect the exception to the guest's XFD
                    ^^^^

(better: if the host XFD is nonzero, and the guest XCR0 includes any bit 
whose state is optional).

>      and XFD_ERR.

This comment is about letting arch/x86/kernel resize current->thread.fpu 
while the guest runs.  It's not necessary before KVM supports AMX, 
because KVM will never let a guest set XCR0[18] (__kvm_set_xcr).

Thomas instead was talking about allocation of vcpu->arch.guest_fpu and 
vcpu->arch.user_fpu.

For dynamic allocation in kvm_save_current_fpu, you can retrieve the 
XINUSE bitmask (XGETBV with RCX=1).  If it contains any bits that have 
optional state, you check if KVM's vcpu->arch.guest_fpu or 
vcpu->arch.user_fpu are already big enough, and if not do the reallocation.

If X86_FEATURE_XGETBV1 is not available, you will not need to resize. 
If XFD is supported but X86_FEATURE_XGETBV1 is not, you can just make 
kvm_arch_init fail with -ENODEV.  It's a nonsensical combination.

Thanks,

Paolo

>      In addition, loading the guest XFD MSRs should use the MSR autoload
>      feature (add_atomic_switch_msr).
> 
> And then I guess discussion goes on..

