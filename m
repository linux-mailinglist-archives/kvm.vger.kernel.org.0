Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3E164A49B9
	for <lists+kvm@lfdr.de>; Mon, 31 Jan 2022 15:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239118AbiAaO4q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jan 2022 09:56:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232149AbiAaO4q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jan 2022 09:56:46 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7323DC061714;
        Mon, 31 Jan 2022 06:56:45 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id h21so25943069wrb.8;
        Mon, 31 Jan 2022 06:56:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pT9hn88xj4KqpnIxHPTqIquz0n6gebNZn/sKquRbpv8=;
        b=ENvmsHT7O6XGAJN3YWHwG82jBdiJt7qCn7RVo/f89OuMERzjEO4n5N9kzXZZvaRWQs
         iSV8IPxZ7u3Hv2b3vdfm+6MOBNUnBBXbxec5A7YiTX+scr2VAYxDfUR+FOE4PFThEKCU
         E7G7c8Glhynh0IHSmRp+rZy95pLjTzdyUixV2RlgcBKZafTAIYgaPZ6lhO5VWM7vF2/2
         g46A+2rZmsmx1ZhVgFuYpxEkako06nxW95+C6HpEc5jftmCyaIErx05+pvKUwUx1OzMp
         xvcW++Znqi9GKl4O2Mp3D4qJE/PYGLMeDB6nPwhXBP718QVuvA4yOliBLDdbhy5dvzZU
         SIQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pT9hn88xj4KqpnIxHPTqIquz0n6gebNZn/sKquRbpv8=;
        b=nnqTCyvs7xifaOPPtFWkc/kUvoEPSA58fIZpdQT2rTQMtzBL0cuqPN9NI5RVRYhNKG
         zdEBBSiOBk/Lqk33WGQl3QGiRlcirD18Eh8tpidDmIyTX6KH9ws110R4WmNtQO3Ni4Al
         Y59ACVHQGEjikqGOMcRNe+C2TQSEPGGI9BpV+64PtuUJg+7SR8yCoHjV8DKLJCiaMPHv
         tUbaMA/yRiDbBVK6PLKJmXFpYgfgFdCrxaUz+V0k5mp680VSIPgpSJpsBGsqGza6FmhF
         5z1AqE/fT2Yv2JVS3HhFOXPZE418oIjI80kQhZJOVpn5ewJe8xljHdIjrnii1BD5kzcw
         rLCQ==
X-Gm-Message-State: AOAM532sf18Wx/E41iLLaWColyx94o1V9wjxuAW24dj3e0RtIokI/mrv
        dPMN4/cGVHYITW4qZ716W3YVKXf+zPE=
X-Google-Smtp-Source: ABdhPJxxLWx9fsGzQK6SD4rf2B8/QQlfXfqffP9NnF8qulhVta9yI8LWU2f3NwfVN9SYBkB3lq645A==
X-Received: by 2002:adf:d08c:: with SMTP id y12mr18250340wrh.346.1643641004010;
        Mon, 31 Jan 2022 06:56:44 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id v5sm8915747wmh.19.2022.01.31.06.56.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 06:56:43 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <6979e482-1f07-4148-b9d7-d91cfa98c081@redhat.com>
Date:   Mon, 31 Jan 2022 15:56:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 01/22] KVM: x86: Drop unnecessary and confusing
 KVM_X86_OP_NULL macro
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
References: <20220128005208.4008533-1-seanjc@google.com>
 <20220128005208.4008533-2-seanjc@google.com>
 <152db376-b0f3-3102-233c-a0dbb4011d0c@redhat.com>
 <YfQO+ADS1wnefoSr@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YfQO+ADS1wnefoSr@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/28/22 16:42, Sean Christopherson wrote:
> On Fri, Jan 28, 2022, Paolo Bonzini wrote:
>> On 1/28/22 01:51, Sean Christopherson wrote:
>>> Drop KVM_X86_OP_NULL, which is superfluous and confusing.  The macro is
>>> just a "pass-through" to KVM_X86_OP; it was added with the intent of
>>> actually using it in the future, but that obviously never happened.  The
>>> name is confusing because its intended use was to provide a way for
>>> vendor implementations to specify a NULL pointer, and even if it were
>>> used, wouldn't necessarily be synonymous with declaring a kvm_x86_op as
>>> DEFINE_STATIC_CALL_NULL.
>>>
>>> Lastly, actually using KVM_X86_OP_NULL as intended isn't a maintanable
>>> approach, e.g. bleeds vendor details into common x86 code, and would
>>> either be prone to bit rot or would require modifying common x86 code
>>> when modifying a vendor implementation.
>>
>> I have some patches that redefine KVM_X86_OP_NULL as "must be used with
>> static_call_cond".  That's a more interesting definition, as it can be used
>> to WARN if KVM_X86_OP is used with a NULL function pointer.
> 
> I'm skeptical that will actually work well and be maintainble.  E.g. sync_pir_to_ir()
> must be explicitly check for NULL in apic_has_interrupt_for_ppr(), forcing that path
> to do static_call_cond() will be odd.  Ditto for ops that are wired up to ioctl()s,
> e.g. the confidential VM stuff, and for ops that are guarded by other stuff, e.g. the
> hypervisor timer.
> 
> Actually, it won't just be odd, it will be impossible to disallow NULL a pointer
> for KVM_X86_OP and require static_call_cond() for KVM_X86_OP_NULL.  static_call_cond()
> forces the return to "void", so any path that returns a value needs to be manually
> guarded and can't use static_call_cond(), e.g.

You're right and I should have looked up the series instead of going by 
memory.  What I did was mostly WARNing on KVM_X86_OP that sets NULL, as 
non-NULL ops are the common case.  I also added KVM_X86_OP_RET0 to 
remove some checks on kvm_x86_ops for ops that return a value.

All in all I totally agree with patches 2-11 and will apply them (patch 
2 to 5.17 even, as a prerequisite to fix the AVIC race).  Several of 
patches 13-21 are also mostly useful as it clarifies the code, and the 
others I guess are okay in the context of a coherent series though 
probably they would have been rejected as one-offs.  However, patches 12 
and 22 are unnecessary uses of the C preprocessor in my opinion.

Paolo
