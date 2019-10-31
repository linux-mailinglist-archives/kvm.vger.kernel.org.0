Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED242EAD3A
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2019 11:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbfJaKNF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Oct 2019 06:13:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56989 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726864AbfJaKNE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Oct 2019 06:13:04 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D64B736891
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2019 10:13:03 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id m17so2994696wrb.20
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2019 03:13:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/44dGZDsBYxX183Xkv/IJzL2AXdUhJfKJb3sAk+GH8E=;
        b=UZK0BlSddE/muCDu2ahNcB76ogD5HhjSVCOfHpPepOaXIEYiq4d7gW+JhaMW6B9K9W
         Nif9cxCxyw+PblK478xQxcRV9UV/wmLTCIvzjiz5kl5wWvTOhzEklpvLBdAibzesTH+J
         pvZm0+I3BHhTlq9hQitN6Pzo79MndUQMzyO/kxIChgmJiPR+3N0GUJNbQDgU5/uxHXAq
         nDfiy66toMMM7bfXEEnf+b07TUjdPwKb1B1qW4Nqnrrpg4Qz8Si4yWJ8IY7qbm/xVFll
         wo6wKlclx2fVrN7RvXkAPyQaRvVJnPS4r5Vlsz/NFNhvfAD49cu28Uc0OkUSCMd1dd2p
         M3+w==
X-Gm-Message-State: APjAAAWYqf4soNZdzuhQtCW5DePQbG/aehgBeqj+5SMbwAO2pGQ/J14y
        92zbvTq1m0a9pMTS6II5H7knbfy+t2CmTUjhnk50De03yX9V4ZFt5EC0aOzuH3QcmP1f1hCY4PH
        jLcIr3cNeKq50
X-Received: by 2002:a05:600c:cd:: with SMTP id u13mr4292454wmm.133.1572516782278;
        Thu, 31 Oct 2019 03:13:02 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzYM8gXGVVEDQkDLGTBzaFCpvtsN7CsDy2hTO82p36x1qbVVaPl+Hi7K3QQh7QkDmPfWzACzg==
X-Received: by 2002:a05:600c:cd:: with SMTP id u13mr4292425wmm.133.1572516781967;
        Thu, 31 Oct 2019 03:13:01 -0700 (PDT)
Received: from [172.20.53.126] ([91.217.168.176])
        by smtp.gmail.com with ESMTPSA id s21sm4205057wrb.31.2019.10.31.03.13.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2019 03:13:01 -0700 (PDT)
Subject: Re: [PATCH] arch: x86: kvm: mmu.c: use true/false for bool type
To:     SAURAV GIREPUNJE <saurav.girepunje@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, saurav.girepunje@hotmail.com
References: <20191029094104.GA11220@saurav>
 <20191029101300.GK4114@hirez.programming.kicks-ass.net>
 <20191029134246.GA4943@saurav>
 <20191029154423.GN4131@hirez.programming.kicks-ass.net>
 <20191031065739.GA5969@saurav>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <4af9e3b9-36f4-217f-c25c-3f4d64c0dde7@redhat.com>
Date:   Thu, 31 Oct 2019 11:13:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191031065739.GA5969@saurav>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/10/19 07:57, SAURAV GIREPUNJE wrote:
> On Tue, Oct 29, 2019 at 04:44:23PM +0100, Peter Zijlstra wrote:
>> On Tue, Oct 29, 2019 at 07:12:46PM +0530, SAURAV GIREPUNJE wrote:
>>> On Tue, Oct 29, 2019 at 11:13:00AM +0100, Peter Zijlstra wrote:
>>>> On Tue, Oct 29, 2019 at 03:11:04PM +0530, Saurav Girepunje wrote:
>>>>> Use true/false for bool type "dbg" in mmu.c
>>>>>
>>>>> Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>
>>>>> ---
>>>>>  arch/x86/kvm/mmu.c | 2 +-
>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>>>>> index 24c23c66b226..c0b1df69ce0f 100644
>>>>> --- a/arch/x86/kvm/mmu.c
>>>>> +++ b/arch/x86/kvm/mmu.c
>>>>> @@ -68,7 +68,7 @@ enum {
>>>>>  #undef MMU_DEBUG
>>>>>  
>>>>>  #ifdef MMU_DEBUG
>>>>> -static bool dbg = 0;
>>>>> +static bool dbg = true;
>>>>
>>>> You're actually changing the value from false to true. Please, if you
>>>> don't know C, don't touch things.
>>> Hi,
>>>
>>> Thanks for your review.
>>> I accept that I have given wrong value "true" to debug variable. It's my bad my typo mistake.  
>>> I will make sure that I will not touch your exclusive C code where we can assign 0/1 to a bool variable,
>>> As you have given me a free advice, I also request you to please don't review such small patches from newbie to discourage them.
>>
>> I will most certainly review whatever I want, and clearly it is needed.
> Do you want me to discard this patch or resend ?
> 

Hi Saurav,

In general I would be happy with replacing 0/1 with false/true, but not
in this particular case.  Despite working on KVM for quite some time I
have never found MMU_DEBUG particularly useful, therefore it is going to
go away soon and will be replaced with kernel tracepoints; see for
example commit 335e192a3fa4 ("KVM: x86: add tracepoints around
__direct_map and FNAME(fetch)", 2019-07-05).  Therefore, even such a
simple change would be very short lived.

Regarding this patch, I for one am happy that Peter caught the problem
in your patch.  His message was perhaps blunt but also honest;
contributing to the kernel requires a very good discipline.  I don't
want to discourage you from contributing, but I suggest that you look
into how you developed the patch (from the idea down to sending it) and
figure out how your mistake managed to slip.

Thanks,

Paolo
