Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34C301C9816
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 19:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgEGRmd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 13:42:33 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:51689 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726393AbgEGRmc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 May 2020 13:42:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588873350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dS0WUEY8VeRDN7lmBHiwBmpo9D+oZ69iTBhH8DiRzHQ=;
        b=K2ygtnCLNN/kvakxfFooQrjLUtzG5AzB9Xve7uQr3WplgrLxzS96x+nOncZrrExXdg0fST
        1kCnIO5oU9bL4bZa5m87ysRjsRwkTOHN+i9gA4LYnQF8NHR4dicitwUkiavBXHIREOO8fl
        +D8jJDAc2WG3pC1m0m+70Sre3jJKLBc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-492-m3yA0j99OOqmbMiiEjjlQg-1; Thu, 07 May 2020 13:42:28 -0400
X-MC-Unique: m3yA0j99OOqmbMiiEjjlQg-1
Received: by mail-wr1-f70.google.com with SMTP id a3so3873405wro.1
        for <kvm@vger.kernel.org>; Thu, 07 May 2020 10:42:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dS0WUEY8VeRDN7lmBHiwBmpo9D+oZ69iTBhH8DiRzHQ=;
        b=hZrxjqJoBI18Qetatuoz0hL+x8cG6y+3EpG0JAFF9blMrHWotzJQDS0rm0Bb0Ge62N
         TEhe4hIlf3O1oeGC2Urr2Uasq5gQSClTM5D4A5gfDJtYyfn9vrJApRkAwpf3tcNmQ512
         UWdGq/cTRTxPyFAWtkK1Qcz5nI9uuk7Qg0Ap54DUkDeSwoaMaXhaekWa5hIRVEr4n7v+
         3bfBLqlM2iuITpuxBx7e7KqF12dJrLVX8PSIAXgLwwJjZT8/s4JtUqVL5v+t6SiiL4GY
         gQu+xsob3/N7/xvFnvHT9DGCzcEqe71/Gl74dM/G/4WlupBoK+297ZsCS3Wh5g3fulS9
         dAWw==
X-Gm-Message-State: AGi0PuZEPQ7uDpEYhrpASMK4lw0vYHkN+J+yepH+//DvvuEs5XYn/cuO
        uDeW+HjwmjWrHv753lZShwoP3UZ3fqT1TlhMLBrqZ1yXXMRyFp2loS3skzXPEJWNWxRprydam+d
        Z/14XzTERKBsL
X-Received: by 2002:a7b:c0d5:: with SMTP id s21mr11337195wmh.107.1588873346904;
        Thu, 07 May 2020 10:42:26 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ2NeLasZrgSPXjWlLcCfOifYwtyuY/C/KWPEW0xlhdT0+GF5s1DA1gqBA6uhrvFIj8gcsfMA==
X-Received: by 2002:a7b:c0d5:: with SMTP id s21mr11337160wmh.107.1588873346364;
        Thu, 07 May 2020 10:42:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8d3e:39e5:cd88:13cc? ([2001:b07:6468:f312:8d3e:39e5:cd88:13cc])
        by smtp.gmail.com with ESMTPSA id w6sm9767182wrt.39.2020.05.07.10.42.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 10:42:25 -0700 (PDT)
Subject: Re: [PATCH 9/9] KVM: VMX: pass correct DR6 for GD userspace exit
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20200507115011.494562-1-pbonzini@redhat.com>
 <20200507115011.494562-10-pbonzini@redhat.com>
 <20200507161854.GF228260@xz-x1>
 <7abe5f7b-2b5a-4e32-34e2-f37d0afef00a@redhat.com>
 <20200507163839.GG228260@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <db06ffa7-1e3c-14e5-28b8-5053f4383ecf@redhat.com>
Date:   Thu, 7 May 2020 19:42:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200507163839.GG228260@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/05/20 18:38, Peter Xu wrote:
> On Thu, May 07, 2020 at 06:21:18PM +0200, Paolo Bonzini wrote:
>> On 07/05/20 18:18, Peter Xu wrote:
>>>>  		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) {
>>>> -			vcpu->run->debug.arch.dr6 = vcpu->arch.dr6;
>>>> +			vcpu->run->debug.arch.dr6 = DR6_BD | DR6_RTM | DR6_FIXED_1;
>>> After a second thought I'm thinking whether it would be okay to have BS set in
>>> that test case.  I just remembered there's a test case in the kvm-unit-test
>>> that checks explicitly against BS leftover as long as dr6 is not cleared
>>> explicitly by the guest code, while the spec seems to have no explicit
>>> description on this case.
>>
>> Yes, I noticed that test as well.  But I don't like having different
>> behavior for Intel and AMD, and the Intel behavior is more sensible.
>> Also...
> 
> Do you mean the AMD behavior is more sensible instead? :)

No, I mean within the context of KVM_EXIT_DEBUG: the Intel behavior is
to only include the latest debug exception in kvm_run's DR6 field, while
the AMD behavior would be to include all of them.  This was an
implementation detail (it happens because Intel sets kvm_run's DR6 from
the exit qualification of #DB), but it's more sensible too.

In addition:

* AMD was completely broken until this week, so the behavior of
KVM_EXIT_DEBUG is defined de facto by kvm_intel.ko.  Userspace has not
been required to set DR6 with KVM_SET_GUEST_DEBUG, and since we can
emulate that on AMD, we should.

* we have to fix anyway the fact that on AMD a KVM_EXIT_DEBUG is
clobbering the contents of the guest's DR6

>>> Intead of above, I'm thinking whether we should allow the userspace to also
>>> change dr6 with the KVM_SET_GUEST_DEBUG ioctl when they wanted to (right now
>>> iiuc dr6 from userspace is completely ignored), instead of offering a fake dr6.
>>> Or to make it simple, maybe we can just check BD bit only?
>>
>> ... I'm afraid that this would be a backwards-incompatible change, and
>> it would require changes in userspace.  If you look at v2, emulating the
>> Intel behavior in AMD turns out to be self-contained and relatively
>> elegant (will be better when we finish cleaning up nested SVM).
> 
> I'm still trying to read the other patches (I need some more digest because I'm
> even less familiar with nested...).  I agree that it would be good to keep the
> same behavior across Intel/AMD.  Actually that also does not violate Intel spec
> because the AMD one is stricter.

Again, careful---we're talking about KVM_EXIT_DEBUG, not the #DB exception.

Thanks,

Paolo

> However I guess then we might also want to
> fixup the kvm-unit-test too to aligh with the behaviors on leftover set bits.

