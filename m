Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33ABE2F9487
	for <lists+kvm@lfdr.de>; Sun, 17 Jan 2021 19:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729542AbhAQSWE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Jan 2021 13:22:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40074 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728895AbhAQSWB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 17 Jan 2021 13:22:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610907635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uJIoOhvCGZIzme7GO6g9mBo0n7uG93HV8b3Dtunyfrg=;
        b=Gnn8XMWOw7XyFC/K/54fPpRnyqJY2lmFZpaggIHtpsmOqnN9k8hZyJLP7l6geq5TquByE1
        PXFlFZgLcUscHzIM6y84z1WFEREyLSMxXZx2OJOfKWOTg286kwGYd0KsrX0jEk1I8tEo69
        mC5MDE/8KEQ6xWbJPzg+15SFv7LmYdc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-lXtN1d3rN--N42qcw3Hypw-1; Sun, 17 Jan 2021 13:20:33 -0500
X-MC-Unique: lXtN1d3rN--N42qcw3Hypw-1
Received: by mail-ed1-f71.google.com with SMTP id n8so4765459edo.19
        for <kvm@vger.kernel.org>; Sun, 17 Jan 2021 10:20:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uJIoOhvCGZIzme7GO6g9mBo0n7uG93HV8b3Dtunyfrg=;
        b=Y3ywwED0uEKlERAQWiv2TULSS1SFjM8TGXMGC0OKPrAHTmYrz9CRcbrPjDNK/2Huqk
         2hxCZMfSvAwhPO0BGzofpydVlRqYKg9CsOxAZ474psEMnhqzSw+z3MjSyNs+FnQaX1sS
         bzEolpNMIFW8916L8qxvSdU31XUt1Zxlus/69YYhOvwEcZKYJmBRp9wydA2p/wnIxpNO
         7AiHSbhRKBk9C7gqQ072WESZRXrotwQufn9Z1lANOoWfXmFvCgsvwrnMLWNsqm/O66wS
         9zxF8JBi+5E8pnSb3A0QX5y2Yy1IzelTmREgAuAh5krXTZ+Lu3QdlYF0guw9RSk4ZuLK
         XRgw==
X-Gm-Message-State: AOAM530NrsGIN7awB+WymubjUD4AwcUPGwDwlpBX2WDkRnymPGEUv06K
        A5g2EnM0cOwKIZHGZN3DMq5Nnl0O8BcJZsBQT+MWemXeCM5ijULifnSMQVup24kNSkeYDKy4Q6y
        oaniKdsb2RDwl
X-Received: by 2002:a17:906:44a:: with SMTP id e10mr10232559eja.265.1610907632174;
        Sun, 17 Jan 2021 10:20:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxFsUFM3peO0LryV+GLQp/07YHvRk9lCVbQSK1TBRwPv7+UzJlbfaFJ8w6pkDzpCproASUr3w==
X-Received: by 2002:a17:906:44a:: with SMTP id e10mr10232541eja.265.1610907632001;
        Sun, 17 Jan 2021 10:20:32 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d18sm9608042edz.14.2021.01.17.10.20.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jan 2021 10:20:31 -0800 (PST)
To:     Wei Huang <whuang2@amd.com>, Wei Huang <wei.huang2@amd.com>,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        seanjc@google.com, joro@8bytes.org, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com, mlevitsk@redhat.com
References: <20210112063703.539893-1-wei.huang2@amd.com>
 <090232a9-7a87-beb9-1402-726bb7cab7e6@redhat.com>
 <ed93c796-1750-7cb8-ed4d-dc9c4b68b5a3@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/2] KVM: x86: Add emulation support for #GP triggered by
 VM instructions
Message-ID: <7ea9f2d8-6688-612c-21a8-f3f3517da122@redhat.com>
Date:   Sun, 17 Jan 2021 19:20:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <ed93c796-1750-7cb8-ed4d-dc9c4b68b5a3@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/01/21 08:00, Wei Huang wrote:
> If the whole body inside if-statement is moved out, do you expect the
> interface of x86_emulate_decoded_instruction to be something like:
> 
> int x86_emulate_decoded_instruction(struct kvm_vcpu *vcpu,
>                                      gpa_t cr2_or_gpa,
>                                      int emulation_type, void *insn,
>                                      int insn_len,
>                                      bool write_fault_to_spt)

An idea is to making the body of the new function just

         init_emulate_ctxt(vcpu);

         /*
          * We will reenter on the same instruction since
          * we do not set complete_userspace_io.  This does not
          * handle watchpoints yet, those would be handled in
          * the emulate_ops.
          */
         if (!(emulation_type & EMULTYPE_SKIP) &&
             kvm_vcpu_check_breakpoint(vcpu, &r))
                 return r;

         ctxt->interruptibility = 0;
         ctxt->have_exception = false;
         ctxt->exception.vector = -1;
         ctxt->exception.error_code_valid = false;

         ctxt->perm_ok = false;

         ctxt->ud = emulation_type & EMULTYPE_TRAP_UD;

         r = x86_decode_insn(ctxt, insn, insn_len);

         trace_kvm_emulate_insn_start(vcpu);
         ++vcpu->stat.insn_emulation;
         return r;

because for the new caller, on EMULATION_FAILED you can just re-enter 
the guest.

> And if so, what is the emulation type to use when calling this function
> from svm.c? EMULTYPE_VMWARE_GP?

Just 0 I think.

Paolo

