Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6230F1AC9C7
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 17:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898447AbgDPNo3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 09:44:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29795 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2898433AbgDPNoX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 09:44:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587044661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VNwYgeif6SS8pR2Shi4E6mQu99cc3aS7IJK5cTr/jMU=;
        b=gGqXPaxIp18rkpx2BOddliikPgJXGFApHzF31xFRdlunZgdoNHLYN3o87IrNMMMjBX6eml
        e6WwWDW8FUfidQApR+uae6UOF9iKE26xw7hMAcnQrqBwIgV5dVf28N8zoNpTgbs71ElKDa
        sQmeOKQhzH6DPmGo1YJDhHyhaD23H9s=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-yjWqjSPQPou8NH6-27P2RQ-1; Thu, 16 Apr 2020 09:44:10 -0400
X-MC-Unique: yjWqjSPQPou8NH6-27P2RQ-1
Received: by mail-wm1-f70.google.com with SMTP id c196so1210520wmd.3
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 06:44:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VNwYgeif6SS8pR2Shi4E6mQu99cc3aS7IJK5cTr/jMU=;
        b=AJxbZyc3tB5EwdjgLA6z3HwRw+q5ZiBojZa0KwZCCT/02Yr86pDwsYZWSmGloBFBmW
         HdngH6oxRArT8u1uFGbMLAudLw0VJVf576bRPgCY/FkCTRpyMK1xdu5o/0fpvQHWovQV
         fWoR7A0QvD0C1D9+xdHhMMMPDtZVkSvhKhX8lgQsGhohQsnk0CtsjYLrPSKeeqP54vYC
         mHriR7RCgi15On4mi6hp4eIdN7vj0aPEEIJwFs+q32t/nC0FJAxB0qEEtmeCTSrP8nYt
         FossubRLFOJ4z4mOUsX9kMamMHHkjYkrhCwsaA3qYv2F7AeL+NpA0Cbcd0PP/UOJtxgZ
         dilw==
X-Gm-Message-State: AGi0PuaJFPPkXqvpuuZF3t1kKnDb7iMJXgqsXQM7wTaFQD3fIETh5QSJ
        EN7kKDuwf0P+yHrYcRz5pe+In8olvMpC+kEFiyysDwZv1EMo3k6VPZ8xG2xXBQXYAesv3sK5har
        mkTeDbZixPUhz
X-Received: by 2002:a1c:9e42:: with SMTP id h63mr4711032wme.115.1587044648696;
        Thu, 16 Apr 2020 06:44:08 -0700 (PDT)
X-Google-Smtp-Source: APiQypJbJo3jezBS7NrZjbC7U3OMTYgi+dwQqgaUpndr48EWx/XnTEuvdzSDmjn7g2cPMV+vyM9+Dg==
X-Received: by 2002:a1c:9e42:: with SMTP id h63mr4711010wme.115.1587044648389;
        Thu, 16 Apr 2020 06:44:08 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:399d:3ef7:647c:b12d? ([2001:b07:6468:f312:399d:3ef7:647c:b12d])
        by smtp.gmail.com with ESMTPSA id s24sm3860611wmj.28.2020.04.16.06.44.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2020 06:44:07 -0700 (PDT)
Subject: Re: [PATCH v2 00/10] KVM: VMX: Unionize vcpu_vmx.exit_reason
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
References: <20200415175519.14230-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a77ca940-afe4-a94a-2698-6cda0f95ba5c@redhat.com>
Date:   Thu, 16 Apr 2020 15:44:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200415175519.14230-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/04/20 19:55, Sean Christopherson wrote:
> Convert the exit_reason field in struct vcpu_vmx from a vanilla u32 to a
> union, (ab)using the union to provide access to the basic exit reason and
> flags.
> 
> There is a fairly substantial delta relative to v1, as I ran with Vitaly's
> suggestion to split nested_vmx_exit_reflected() into VM-Fail, "L0 wants"
> and "L1 wants", and move the tracepoint into nested_vmx_reflect_vmexit().
> IMO, this yields cleaner and more understandable code overall, and helps
> eliminate caching the basic exit reason (see below) by avoiding large
> functions that repeatedly query the basic exit reason.  The refactoring
> isn't strictly related to making exit_reason a union, but the code would
> conflict horribly and the end code nicely demonstrates the value of using
> a union for the exit reason.
> 
> There are three motivating factors for making exit_reason a union:
> 
>   - Help avoid bugs where a basic exit reason is compared against the full
>     exit reason, e.g. there have been two bugs where MCE_DURING_VMENTRY
>     was incorrectly compared against the full exit reason.
> 
>   - Clarify the intent of related flows, e.g. exit_reason is used for both
>     "basic exit reason" and "full exit reason", and it's not always clear
>     which of the two is intended without a fair bit of digging.
> 
>   - Prepare for future Intel features, e.g. SGX, that add new exit flags
>     that are less restricted than FAILED_VMENTRY, i.e. can be set on what
>     is otherwise a standard VM-Exit.
> 
> v2:
>   - Don't snapshot the basic exit reason, i.e. either use vmx->exit_reason
>     directly or snapshot the whole thing.  The resulting code is similar
>     to Xiaoyao's original patch, e.g. vmx_handle_exit() now uses
>     "exit_reason.basic" instead of "exit_reason" to reference the basic
>     exit reason.
>   - Split nested_vmx_exit_reflected() into VM-Fail, "L0 wants" and "L1
>     wants", and move the tracepoint into nested_vmx_reflect_vmexit().
>     [Vitaly]
>   - Use a "union vmx_exit_reason exit_reason" to handle a consistency
>     check VM-Exit on VM-Enter in nested_vmx_enter_non_root_mode() to avoid
>     some implicit casting shenanigans. [Vitaly]
>   - Collect tags. [Vitaly]
> 
> v1: https://lkml.kernel.org/r/20200312184521.24579-1-sean.j.christopherson@intel.com

For now I committed only patches 1-9, just to limit the conflicts with
the other series.  I would like to understand how you think the
conflicts should be fixed with the union.

Paolo

