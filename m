Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7F0D6E5F7E
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 13:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbjDRLOC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 07:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjDRLOA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 07:14:00 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A30189
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 04:13:59 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id o6-20020a05600c4fc600b003ef6e6754c5so13322243wmq.5
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 04:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681816437; x=1684408437;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jPG+EByWtb78pzF57RpBd7ku75iFcf4nl1NtQSIFcLQ=;
        b=LgUYzB95KzwclDNWr6BbGOpFRDAmsyBDZiSSZioxKgPRR9SnNdbP4FEBgC1RlV5kae
         vLgO5FANS8g1PSKCuvX0NZmla5FRTeWXD/bJkM8wJ+9jyCibaekxOK5JJJz0PAKouR2d
         SSovHTmzObHYuZLG1nxvnyrboPiaUPAgP8IkQ2boIC39r70O64vs/buYAH8awyKSQi7C
         N/Vcbqklas54jsNbT2ZkyoBpP4W7KV0zHQMD299wHsNkAltQ8JYzyeDztizQdohVut9F
         QeVuuJdMl6tIR3jcKUiv4Am25I3WUpba41MeV/7TVt0jCJkm9ZTWyCUmVAYUI4Kt0Jsh
         b34Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681816437; x=1684408437;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jPG+EByWtb78pzF57RpBd7ku75iFcf4nl1NtQSIFcLQ=;
        b=XN3c6ZR1GA1IHdBFq1KSC05tkrk5D/NTqk//ZtHPdUm2jjPz21wcSBP6uMLYTxcRTx
         MmQWZXuHqey5DSU88mMH4RpLC9ay/4dBikdEfZEFeTWiTsnf4dDuNgKfg1xXiqwT89qH
         mMmXExuxGg0zfu/LaRGRpqXClkShHMIDs9m8ni40Jw1aBAlaFl4ObdszrrBGV+Xe+2U+
         1649lgIYz5WhaR+cK5TxJilXVQ+FRhNLqw87j6bdgp/IQdnDf8h0CVGOenW3v6q00BzT
         DycCw/hZctr0Zn32moxSfbl1WAyHOjOaYKeiwA7xGsPmTFEAcz7uuK3y9iBGrVdnsfHn
         XOvQ==
X-Gm-Message-State: AAQBX9f9ijuvbdAdK4/6DAHn/Y8moolNyNJhVBuA5r6x2c+HA3DzoaBQ
        AIDOFMJjzKqSRRF/pQY2aSI=
X-Google-Smtp-Source: AKy350ZtwbsEmYGJyYs9BAskGiQs1cybo/6rZfGxYyrb1DsbI/NR7tJnNEAlZyWCdGtdfw3nLE9DlA==
X-Received: by 2002:a1c:7206:0:b0:3f1:6980:2cfe with SMTP id n6-20020a1c7206000000b003f169802cfemr8053240wmc.12.1681816437529;
        Tue, 18 Apr 2023 04:13:57 -0700 (PDT)
Received: from [192.168.10.76] (54-240-197-233.amazon.com. [54.240.197.233])
        by smtp.gmail.com with ESMTPSA id q9-20020a1ce909000000b003ee20b4b2dasm14497906wmc.46.2023.04.18.04.13.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 04:13:57 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <943c197d-c250-4851-557e-ec4d8d7250d9@xen.org>
Date:   Tue, 18 Apr 2023 12:13:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Reply-To: paul@xen.org
Subject: Re: [PATCH v3] KVM: x86/xen: Implement hvm_op/HVMOP_flush_tlbs
 hypercall
Content-Language: en-US
To:     "Kaya, Metin" <metikaya@amazon.co.uk>
Cc:     "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "seanjc@google.com" <seanjc@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <138f584bd86fe68aa05f20db3de80bae61880e11.camel@infradead.org>
 <20230418101306.98263-1-metikaya@amazon.co.uk>
 <3ede838b-15ef-a987-8584-cd871959797b@xen.org>
 <467e7c790c124cbcb98a764d4ae98ac2@amazon.co.uk>
Organization: Xen Project
In-Reply-To: <467e7c790c124cbcb98a764d4ae98ac2@amazon.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/04/2023 12:04, Kaya, Metin wrote:
> On 18/04/2023 11:48, Paul Durrant wrote:
>> On 18/04/2023 11:13, Metin Kaya wrote:
>>> Implement in-KVM support for Xen's HVMOP_flush_tlbs hypercall, which
>>> allows the guest to flush all vCPU's TLBs. KVM doesn't provide an
>>> ioctl() to precisely flush guest TLBs, and punting to userspace would
>>> likely negate the performance benefits of avoiding a TLB shootdown in
>>> the guest.
>>>
>>> Signed-off-by: Metin Kaya <metikaya@amazon.co.uk>
>>>
>>> ---
>>> v3:
>>>     - Addressed comments for v2.
>>>     - Verified with XTF/invlpg test case.
>>>
>>> v2:
>>>     - Removed an irrelevant URL from commit message.
>>> ---
>>>    arch/x86/kvm/xen.c                 | 15 +++++++++++++++
>>>    include/xen/interface/hvm/hvm_op.h |  3 +++
>>>    2 files changed, 18 insertions(+)
>>>
>>> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c index
>>> 40edf4d1974c..a63c48e8d8fa 100644
>>> --- a/arch/x86/kvm/xen.c
>>> +++ b/arch/x86/kvm/xen.c
>>> @@ -21,6 +21,7 @@
>>>    #include <xen/interface/vcpu.h>
>>>    #include <xen/interface/version.h>
>>>    #include <xen/interface/event_channel.h>
>>> +#include <xen/interface/hvm/hvm_op.h>
>>>    #include <xen/interface/sched.h>
>>>
>>>    #include <asm/xen/cpuid.h>
>>> @@ -1330,6 +1331,17 @@ static bool kvm_xen_hcall_sched_op(struct kvm_vcpu *vcpu, bool longmode,
>>>        return false;
>>>    }
>>>
>>> +static bool kvm_xen_hcall_hvm_op(struct kvm_vcpu *vcpu, int cmd, u64
>>> +arg, u64 *r) {
>>> +     if (cmd == HVMOP_flush_tlbs && !arg) {
>>> +             kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_TLB_FLUSH_GUEST);
>>> +             *r = 0;
>>> +             return true;
>>> +     }
>>> +
>>> +     return false;
>>> +}
>>
>> This code structure means that arg != NULL will result in the guest seeing ENOSYS rather than EINVAL.
>>
>>    Paul
> 
> Yes, because of this comment in David's email:
> "I don't even know that we care about in-kernel acceleration for the
> -EINVAL case. We could just return false for that, and let userspace
> (report and) handle it."
> 

Ok, fair enough.

Reviewed-by: Paul Durrant <paul@xen.org>
