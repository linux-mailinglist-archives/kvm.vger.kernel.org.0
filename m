Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7457F59747F
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 18:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241148AbiHQQty (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 12:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241179AbiHQQtg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 12:49:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D318A5808C
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 09:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660754973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/1ipQ5oQZFUN9YfGsBUkFyNrn9BZ6I7shHodgrk8s0Y=;
        b=Fk/5aBXPyPzqazI0YgPRZRCLEfzymETr9+1plNaPIZm5Y1giOTAdiVn1MVTiG9fos+JHd7
        dmc2PfUZGJznD8L7QM2Ox8JEbEweDn36NBu7DaLBpyzkUwczhmkXF3+u+2t1exOgao/Jpd
        yKdmR7cbidw/07d96IJZe0FMfkON0qs=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-226-C16sgF-VMJuZFWf3CgR5rQ-1; Wed, 17 Aug 2022 12:49:31 -0400
X-MC-Unique: C16sgF-VMJuZFWf3CgR5rQ-1
Received: by mail-ej1-f69.google.com with SMTP id nc38-20020a1709071c2600b007309af9e482so3131502ejc.2
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 09:49:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=/1ipQ5oQZFUN9YfGsBUkFyNrn9BZ6I7shHodgrk8s0Y=;
        b=lW0gfjexIB0rBU6rI5TlP7+oq6KiTxUz8lGCSk5epY5MqFp6Klm31CRArWAX7cTFjk
         fpjdoGXwwaYopI8wraqBJ33PxucEYBWugrheEPX8UPOqceP2XN0ynuY36BONzunrJhjo
         aX5shi+0iXk+9O7p0JrRidmbl7SJQttUuunCMyQSrSgZEej1AhLrmFnjX4W2isczmK6V
         FuuP2x6XRkEApkAfhsEgXlWNUM8h4XpHNje3qWoGqMcRa0JBZ15bLvFIQJi1OvL1i8Dz
         i3QOI40MFff3j7gFnXs225+sQmc/7ln8IB67wt7i7wvYlVTGfSYmgr10duESRMtrToTB
         B5KA==
X-Gm-Message-State: ACgBeo33QZL0Qr53qeoTGBDoEwqg6gA16FPB3W56F2HFDxHAn38G88Sl
        prVpDcj8yQHrlWWrFBuGi/nPYTEeUftcdp25yIfN2ipOtkQJs3a/xa6g1wGkEJwr8DwsuebiVAx
        +36czpaQxdBSv
X-Received: by 2002:a17:907:28d6:b0:731:100c:8999 with SMTP id en22-20020a17090728d600b00731100c8999mr17172349ejc.210.1660754970462;
        Wed, 17 Aug 2022 09:49:30 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7MrOYH1NnxHco479ZJzy2zL+mc4tH6RAgfWX0tYEUKApZKrUDtPkzquVyBCD6/hlYsBWXJmw==
X-Received: by 2002:a17:907:28d6:b0:731:100c:8999 with SMTP id en22-20020a17090728d600b00731100c8999mr17172340ejc.210.1660754970221;
        Wed, 17 Aug 2022 09:49:30 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id u4-20020a50eac4000000b0043ba7df7a42sm11094531edp.26.2022.08.17.09.49.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Aug 2022 09:49:29 -0700 (PDT)
Message-ID: <69d0b2c3-0c14-83c8-0913-4ee163f9c1df@redhat.com>
Date:   Wed, 17 Aug 2022 18:49:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v2 2/9] KVM: x86: remove return value of kvm_vcpu_block
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        mlevitsk@redhat.com, vkuznets@redhat.com
References: <20220811210605.402337-1-pbonzini@redhat.com>
 <20220811210605.402337-3-pbonzini@redhat.com> <Yvwpb6ofD1S+Rqk1@google.com>
 <78616cf8-2693-72cc-c2cc-5a849116ffc7@redhat.com>
 <Yv0aHXcmuivyJDXw@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yv0aHXcmuivyJDXw@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/17/22 18:41, Sean Christopherson wrote:
> On Wed, Aug 17, 2022, Paolo Bonzini wrote:
>> On 8/17/22 01:34, Sean Christopherson wrote:
>>> Isn't freeing up the return from kvm_vcpu_check_block() unnecessary?  Can't we
>>> just do:
>>>
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 9f11b505cbee..ccb9f8bdeb18 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -10633,7 +10633,7 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
>>>                   if (hv_timer)
>>>                           kvm_lapic_switch_to_hv_timer(vcpu);
>>>
>>> -               if (!kvm_check_request(KVM_REQ_UNHALT, vcpu))
>>> +               if (!kvm_arch_vcpu_runnable(vcpu))
>>>                           return 1;
>>>           }
>>>
>>>
>>> which IMO is more intuitive and doesn't require reworking halt-polling (again).
>>
>> This was my first idea indeed.  However I didn't like calling
>> kvm_arch_vcpu_runnable() again and "did it schedule()" seemed to be a less
>> interesting result from kvm_vcpu_block() (and in fact kvm_vcpu_halt() does
>> not bother passing it up the return chain).
> 
> The flip side of calling kvm_arch_vcpu_runnable() again is that KVM will immediately
> wake the vCPU if it becomes runnable after kvm_vcpu_check_block().  The edge cases
> where the vCPU becomes runnable late are unlikely to truly matter in practice, but
> on the other hand manually re-checking kvm_arch_vcpu_runnable() means KVM gets both
> cases "right" (waited=true iff vCPU actually waited, vCPU awakened ASAP), whereas
> squishing the information into the return of kvm_vcpu_check_block() means KVM gets
> both cases "wrong" (waited=true even if schedule() was never called, vCPU left in
> a non-running state even though it's runnable).
> 
> My only hesitation with calling kvm_arch_vcpu_runnable() again is that it could be
> problematic if KVM somehow managed to consume the event that caused kvm_vcpu_has_events()
> to return true, but I don't see how that could happen without it being a KVM bug.

No, I agree that it cannot happen, and especially so after getting rid 
of the kvm_check_nested_events() call in kvm_arch_vcpu_runnable().

I'll reorder the patches and apply your suggestion.

Paolo

