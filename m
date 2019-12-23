Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E07B129987
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2019 18:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbfLWRqG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Dec 2019 12:46:06 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54165 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726821AbfLWRqF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Dec 2019 12:46:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577123164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NyxEGXEk4VTpodZFpXSFYVpF4fMlWUtWZMOhYuzQAMg=;
        b=H6YcPugoPc5I8Ua5GS0EdWVcg3H4gSEfyb3npKn+kN92hR3WV6cl1J1/pH4CkAYGnYSvpi
        m4c9enjYVZdzCWajJzac7SMxDw0kfD6JP0qXCQYc6J8IRAEHo82ppwkFULi/TSO/2Ja5hp
        mMlQrFYrK1NSJMbVXuW640KZFRUIbCo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-5FGVO2ZiP5uF42Zs4PprIQ-1; Mon, 23 Dec 2019 12:46:03 -0500
X-MC-Unique: 5FGVO2ZiP5uF42Zs4PprIQ-1
Received: by mail-wr1-f72.google.com with SMTP id z10so4139502wrt.21
        for <kvm@vger.kernel.org>; Mon, 23 Dec 2019 09:46:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NyxEGXEk4VTpodZFpXSFYVpF4fMlWUtWZMOhYuzQAMg=;
        b=tW5pnV7pJwDR1hpypabLJeMrMicOVveuAhu00JK5/D3YWZk7OwF6mBMA5ifC8ZTfMC
         KtFtwuN9PT8KTxkeDfMn79RxaEdNusbTRSFQnludulk7e33mU1OHB4bRu5ysD/0UbLLQ
         nc+94bRW7WloUj6CfvyvPp+JJYkdF/mEYkQ1y1h2VNPHXcKjvOn7zIovJdqJJYciMx6I
         2OT26Ohxwcc/4nUssSX3LoH7zaGRrQ1Hlu1oq6Q797fzwaImgWzvA2aS4Kmw00xFicr4
         cj7Mdr9BlF3nEjhfKxNrW6a1IDfspC5+iRomSMXOwSx4wF2jopXUxrjmGbzVVGqJU/y+
         g42w==
X-Gm-Message-State: APjAAAWVjWky39dGTXmc3ewTiADvzkMT4zOyUPBoIDia2AgIbbOS2NKy
        NXWI0cuna5mrryHDwtanhR4ic8ulKn0cEatCZ3D82Gq77+8BsQwhsUrOAqtyHRmeWdP410x+oh5
        lKZG66wbQF4xo
X-Received: by 2002:adf:81e3:: with SMTP id 90mr30839600wra.23.1577123162149;
        Mon, 23 Dec 2019 09:46:02 -0800 (PST)
X-Google-Smtp-Source: APXvYqyZUjyHS0g/ecWSSGHeVn7Xac4ocH5nlnwcKETpadWsN+v9wPYW7uWyeK4z2lEr812dsaBq4A==
X-Received: by 2002:adf:81e3:: with SMTP id 90mr30839577wra.23.1577123161885;
        Mon, 23 Dec 2019 09:46:01 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:ac09:bce1:1c26:264c? ([2001:b07:6468:f312:ac09:bce1:1c26:264c])
        by smtp.gmail.com with ESMTPSA id u24sm124844wml.10.2019.12.23.09.46.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Dec 2019 09:46:01 -0800 (PST)
Subject: Re: [RESEND RFC 0/2] Paravirtualized Control Register pinning
To:     Liran Alon <liran.alon@oracle.com>
Cc:     John Andersen <john.s.andersen@intel.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20191220192701.23415-1-john.s.andersen@intel.com>
 <1EBCD42E-9109-47A1-B959-6363A509D48D@oracle.com>
 <15b57d6b-0f46-01f5-1f75-b9b55db0611a@redhat.com>
 <03F5FE31-E769-4497-922B-C8613F0951FA@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f4d3d392-8edf-54b2-1b90-417447240e22@redhat.com>
Date:   Mon, 23 Dec 2019 18:46:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <03F5FE31-E769-4497-922B-C8613F0951FA@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/12/19 18:28, Liran Alon wrote:
>>> Why reset CR pinned MSRs by userspace instead of KVM INIT
>>> handling?
>> Most MSRs are not reset by INIT, are they?
>> 
>> Paolo
>> 
> MSR_KVM_SYSTEM_TIME saved in vcpu->arch.time is reset at
> kvmclock_reset() which is called by kvm_vcpu_reset() (KVM INIT
> handler). In addition, vmx_vcpu_reset(), called from
> kvm_vcpu_reset(), also resets multiple MSRs such as:
> MSR_IA32_SPEC_CTRL (vmx->spec_ctrl) and MSR_IA32_UMWAIT_CONTROL
> (msr_ia32_umwait_control).

These probably can be removed, since they are zero at startup and at
least SPEC_CTRL is documented[1] to be unaffected by INIT.  However, I
couldn't find information about UMWAIT_CONTROL.

> Having said that, I see indeed that most of MSRs are being set by
> QEMU in kvm_put_msrs() when level >= KVM_PUT_RESET_STATE. When is
> triggered by qemu_system_reset() -> cpu_synchronize_all_post_reset ->
> cpu_synchronize_post_reset() -> kvm_cpu_synchronize_post_reset().
> 
> So given current design, OK I agree with you that CR pinned MSRs
> should be zeroed by userspace VMM.
> 
> It does though seems kinda weird to me that part of CPU state is
> initialised on KVM INIT handler and part of it in userspace VMM. It
> could lead to inconsistent (i.e. diverging from spec) CPU behaviour.

The reason for that is the even on real hardware INIT does not touch
most MSRs:

  9.1 Initialization overview

  Asserting the INIT# pin on the processor invokes a similar response to
  a hardware reset. The major difference is that during an INIT, the
  internal caches, MSRs, MTRRs, and x87 FPU state are left unchanged
  (although, the TLBs and BTB are invalidated as with a hardware reset).
  An INIT provides a method for switching from protected to real-address
  mode while maintaining the contents of the internal caches.

Paolo

[1]
https://software.intel.com/security-software-guidance/api-app/sites/default/files/336996-Speculative-Execution-Side-Channel-Mitigations.pdf

