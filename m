Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 637A853358E
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 04:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbiEYC6v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 22:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbiEYC6u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 22:58:50 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB8F42D1FB
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 19:58:47 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id l20-20020a17090a409400b001dd2a9d555bso3881317pjg.0
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 19:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=YK1wCpCRboLwffskekgnWbUl6nIZlpuhCNf3mYDZPpU=;
        b=PtpIRRwFj/q816SmM7zw1Hnj7L8SNrWSU1anLslWGSwN0KfueD4j20tJvQYYyYPMZ7
         Lx5J1me79HRChl2o6oWtGKZJxIoOPFG2yECi5qX2r6RPrVJbK7RTB9mZ++tO/mcZCuqS
         8EXUFDXUl/bicPsb6EzbTfeYRBdQ44H/cseK3JOlgHBk0iapBu5aB2AU2JSXq0gMPQTQ
         n20j+4uEpqHPFD2uFLkP6bWq43rT+WaMJqRqcW6v9Q84Wm7Un6mSSsJKN7nssA3vyMXa
         wGcllgKlchS+8BIF2KxwQsR+GX9UOecqHDsGsFfmKb2YRNkwLx3KUPl+2dFRx/DMnMtJ
         VM8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=YK1wCpCRboLwffskekgnWbUl6nIZlpuhCNf3mYDZPpU=;
        b=DMj6awxQLE+ZaWaOFJM01mp3pA6MX8wvHgdpyACBFt3wzM69cuKDpbVeHSdJLN8486
         1Pm4SqvVM015w4N88detb/SCe9ro2pOs2cw9QW2LLH/Xm7zn3dhqcQKfUKs5erKiYE9e
         kPHxL3FRA8lvlBMJTPTPVpghEL+s4p3FmOG26cgtr03N2sgihV0jn8vjTugsYRsT45Jn
         J7k77H8gA/p9zcuV4wsPe6OYdrlZ6TW+vNMC0uRMOulPb/vK3Y9Ck9CqwfsrP/Dsywpx
         WfQArymHt57hY/301wy7hLkZstS0fRePjUKyO+MhjRTmVmKguH+zSgpXB770t5zbCfzh
         mRrQ==
X-Gm-Message-State: AOAM531CtyrTv5mGOBlN8KucxkAsZ0Kmv5Qe/q81FKzv1UsN/Jqia7xi
        RF+D87o0cs2BHh1ee/QnOT+nag==
X-Google-Smtp-Source: ABdhPJwEYgmMAy7wgZWt09CThY9XrTxAbiuM8JQFI5KtQXXlfe79I0fwyydxqgVJ3pr+knW4+NKw5w==
X-Received: by 2002:a17:90b:1c92:b0:1dd:10ff:8f13 with SMTP id oo18-20020a17090b1c9200b001dd10ff8f13mr7860126pjb.54.1653447527364;
        Tue, 24 May 2022 19:58:47 -0700 (PDT)
Received: from [10.61.2.177] (110-175-254-242.static.tpgi.com.au. [110.175.254.242])
        by smtp.gmail.com with ESMTPSA id l17-20020a629111000000b0050dc76281ccsm9926630pfe.166.2022.05.24.19.58.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 May 2022 19:58:46 -0700 (PDT)
Message-ID: <6d291eba-1055-51c3-f015-d029a434b2c0@ozlabs.ru>
Date:   Wed, 25 May 2022 12:58:41 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:101.0) Gecko/20100101
 Thunderbird/101.0
Subject: Re: [PATCH kernel] KVM: Don't null dereference ops->destroy
Content-Language: en-US
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm-ppc@vger.kernel.org
References: <20220524055208.1269279-1-aik@ozlabs.ru>
 <Yo05tuQZorCO/kc0@google.com>
 <cc19c541-0b5b-423e-4323-493fd8dafdd8@ozlabs.ru>
In-Reply-To: <cc19c541-0b5b-423e-4323-493fd8dafdd8@ozlabs.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/25/22 11:52, Alexey Kardashevskiy wrote:
> 
> 
> On 5/25/22 06:01, Sean Christopherson wrote:
>> On Tue, May 24, 2022, Alexey Kardashevskiy wrote:
>>> There are 2 places calling kvm_device_ops::destroy():
>>> 1) when creating a KVM device failed;
>>> 2) when a VM is destroyed: kvm_destroy_devices() destroys all devices
>>> from &kvm->devices.
>>>
>>> All 3 Book3s's interrupt controller KVM devices (XICS, XIVE, 
>>> XIVE-native)
>>> do not define kvm_device_ops::destroy() and only define release() which
>>> is normally fine as device fds are closed before KVM gets to 2) but
>>> by then the &kvm->devices list is empty.
>>>
>>> However Syzkaller manages to trigger 1).
>>>
>>> This adds checks in 1) and 2).
>>>
>>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>>> ---
>>>
>>> I could define empty handlers for XICS/XIVE guys but
>>> kvm_ioctl_create_device() already checks for ops->init() so I guess
>>> kvm_device_ops are expected to not have certain handlers.
>>
>> Oof.  IMO, ->destroy() should be mandatory in order to pair with 
>> ->create().


After reading
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=2bde9b3ec8bdf60788e9e 
and neighboring commits, it sounds that each create() should be paired 
with either destroy() or release() but not necessarily both.

So I'm really not sure dummy handlers is a good idea. Thanks,


>> kvmppc_xive_create(), kvmppc_xics_create(), and 
>> kvmppc_core_destroy_vm() are doing
>> some truly funky stuff to avoid leaking the device that's allocate in 
>> ->create().
> 
> Huh it used to be release() actually, nice:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5422e95103cf9663bc
> 
> 
>> A nop/dummy ->destroy() would be a good place to further document 
>> those shenanigans.
>> There's a comment at the end of the ->release() hooks, but that's 
>> still not very
>> obvious.
> 
> I could probably borrow some docs from here:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6f868405faf067e8cfb
> 
> 
> Thanks for the review! At very least I'll add the dummies.
> 
> 
>> The comment above kvmppc_xive_get_device() strongly suggests that 
>> keeping the
>> allocation is a hack to avoid having to audit all relevant code paths, 
>> i.e. isn't
>> done for performance reasons.




-- 
Alexey
