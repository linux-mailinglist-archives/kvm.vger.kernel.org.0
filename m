Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10C9115A7F8
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 12:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbgBLLej (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 06:34:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42072 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725781AbgBLLej (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 06:34:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581507279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gpv3hmiKhNJErWt12V+bN+ctI46+LQe++ZHEt5hiNjQ=;
        b=T5CmLMGMz4g9vvDyl+bLHE9JNj6bB4SuUgGlKVwP2MNf5ePEHv7a3cBWC8n0Ebbq4lPXF4
        1ZElvrbpyQgHnUaUv6psx+7o3mrBjkPZxJ2dqOlHvaIDMzS9l+Elns4yUXfkaroefg6xh0
        BSfqRSqQNnUyIKlXV1np9B0LBtcCnK8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-sGorclZEOBasFqe9mITkoA-1; Wed, 12 Feb 2020 06:34:32 -0500
X-MC-Unique: sGorclZEOBasFqe9mITkoA-1
Received: by mail-wr1-f69.google.com with SMTP id 90so700096wrq.6
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 03:34:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gpv3hmiKhNJErWt12V+bN+ctI46+LQe++ZHEt5hiNjQ=;
        b=UG4D3emqSp8XX8Hhwdfa5WriLPPaLEMTFcQHBWGDZaSJ22jMGhIum9929HUJXT3KKl
         ReMOkOSP50yr7Io0pQxVMQLapd1Jt5HV3uevUBzeRG7bpFuC8FCyl7p3xmrFPNXijm4C
         TD1KJeMkqVFktfFYkJwYrQ7BtpTZfRIeExaDyiYITNIBgZ0S44EW0GugE5n7/SzXhFzu
         rqg/VoaSRcWyt16vxcVjnQC5iwth4rUFXZdExF5XGAwtn5cnSTRe3vhTyMdCQ9Y89QKe
         krdViIoXQ0Z2ihrN9MxysCvUMY7h9JtZZWim/bhPSitwRC1l2yX7wqE64+P68aMElmXe
         blMQ==
X-Gm-Message-State: APjAAAXWSvgOzXy6Re2m3Msbz1BC8bp1P6jDEtXdTjCbbhO5sQ8qoY1j
        zfw/4xXPBMKXonS6t0kHVRDREinJnlYbPnMGJ2QAA/tZcfTDuNvHidCEmO/KyQOwZs025lv8/ko
        rJEmetgwhIm5R
X-Received: by 2002:a1c:f003:: with SMTP id a3mr12607105wmb.41.1581507271138;
        Wed, 12 Feb 2020 03:34:31 -0800 (PST)
X-Google-Smtp-Source: APXvYqxf2KqvkPL1hvrVqNPxXioexfMZHG38UdbcYujLw8aYF64uH1QKFeUsSbFMC8lIzkA22CAmXg==
X-Received: by 2002:a1c:f003:: with SMTP id a3mr12607080wmb.41.1581507270853;
        Wed, 12 Feb 2020 03:34:30 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:652c:29a6:517b:66d9? ([2001:b07:6468:f312:652c:29a6:517b:66d9])
        by smtp.gmail.com with ESMTPSA id p15sm323833wma.40.2020.02.12.03.34.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 03:34:29 -0800 (PST)
Subject: Re: [PATCH v3 0/5] Handle monitor trap flag during instruction
 emulation
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200207103608.110305-1-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <045fcfb5-8578-ad22-7c3e-6bbf20c4ea35@redhat.com>
Date:   Wed, 12 Feb 2020 12:34:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200207103608.110305-1-oupton@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/02/20 11:36, Oliver Upton wrote:
> v1: http://lore.kernel.org/r/20200113221053.22053-1-oupton@google.com
> v2: http://lore.kernel.org/r/20200128092715.69429-1-oupton@google.com
> 
> v1 => v2:
>  - Don't split the #DB delivery by vendors. Unconditionally injecting
>    #DB payloads into the 'pending debug exceptions' field will cause KVM
>    to get stuck in a loop. Per the SDM, when hardware injects an event
>    resulting from this field's value, it is checked against the
>    exception interception bitmap.
>  - Address Sean's comments by injecting the VM-exit into L1 from
>    vmx_check_nested_events().
>  - Added fix for nested INIT VM-exits + 'pending debug exceptions' field
>    as it was noticed in implementing v2.
>  - Drop Peter + Jim's Reviewed-by tags, as the patch set has changed
>    since v1.
> 
> v2 => v3:
>  - Merge the check/set_pending_dbg helpers into a single helper,
>    vmx_update_pending_dbg(). Add clarifying comment to this helper.
>  - Rewrite commit message, descriptive comment for change in 3/5 to
>    explicitly describe the reason for mutating payload delivery
>    behavior.
>  - Undo the changes to kvm_vcpu_do_singlestep(). Instead, add a new hook
>    to call for 'full' instruction emulation + 'fast' emulation.
> 
> KVM already provides guests the ability to use the 'monitor trap flag'
> VM-execution control. Support for this flag is provided by the fact that
> KVM unconditionally forwards MTF VM-exits to the guest (if requested),
> as KVM doesn't utilize MTF. While this provides support during hardware
> instruction execution, it is insufficient for instruction emulation.
> 
> Should L0 emulate an instruction on the behalf of L2, L0 should also
> synthesize an MTF VM-exit into L1, should control be set.
> 
> The first patch corrects a nuanced difference between the definition of
> a #DB exception payload field and DR6 register. Mask off bit 12 which is
> defined in the 'pending debug exceptions' field when applying to DR6,
> since the payload field is said to be compatible with the aforementioned
> VMCS field.
> 
> The second patch sets the 'pending debug exceptions' VMCS field when
> delivering an INIT signal VM-exit to L1, as described in the SDM. This
> patch also introduces helpers for setting the 'pending debug exceptions'
> VMCS field.
> 
> The third patch massages KVM's handling of exception payloads with
> regard to API compatibility. Rather than immediately delivering the
> payload w/o opt-in, instead defer the payload + inject
> before completing a KVM_GET_VCPU_EVENTS. This maintains API
> compatibility whilst correcting #DB behavior with regard to higher
> priority VM-exit events.
> 
> Fourth patch introduces MTF implementation for emulated instructions.
> Identify if an MTF is due on an instruction boundary from
> kvm_vcpu_do_singlestep(), however only deliver this VM-exit from
> vmx_check_nested_events() to respect the relative prioritization to
> other VM-exits. Since this augments the nested state, introduce a new
> flag for (de)serialization.
> 
> Last patch adds tests to kvm-unit-tests to assert the correctness of MTF
> under several conditions (concurrent #DB trap, #DB fault, etc). These
> tests pass under virtualization with this series as well as on
> bare-metal.
> 
> Based on commit 2c2787938512 ("KVM: selftests: Stop memslot creation in
> KVM internal memslot region").
> 
> Oliver Upton (4):
>   KVM: x86: Mask off reserved bit from #DB exception payload
>   KVM: nVMX: Handle pending #DB when injecting INIT VM-exit
>   KVM: x86: Deliver exception payload on KVM_GET_VCPU_EVENTS
>   KVM: nVMX: Emulate MTF when performing instruction emulation
> 
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/include/uapi/asm/kvm.h |  1 +
>  arch/x86/kvm/svm.c              |  1 +
>  arch/x86/kvm/vmx/nested.c       | 54 ++++++++++++++++++++++++++++++++-
>  arch/x86/kvm/vmx/nested.h       |  5 +++
>  arch/x86/kvm/vmx/vmx.c          | 37 +++++++++++++++++++++-
>  arch/x86/kvm/vmx/vmx.h          |  3 ++
>  arch/x86/kvm/x86.c              | 39 ++++++++++++++++--------
>  8 files changed, 126 insertions(+), 15 deletions(-)
> 

Queued (for 5.6-rc2), thanks.

Paolo

