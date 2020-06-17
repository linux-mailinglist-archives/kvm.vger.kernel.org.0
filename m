Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1379E1FD39B
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 19:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgFQRhs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 13:37:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55252 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726511AbgFQRhr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 13:37:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592415465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2hNrLKFzx+SU91EcmopqxtknC1GSH8vyiR3LApBQTDs=;
        b=KRy6Ly5WyCxZthah6nJzmHzzaSgcuVlT3iEZObTbeY75Comc4T/FlSTsNcXEXYaKu2Hd+x
        lp4CLTf86NgdYno3cwVZuN+3pROcCQjFNwaOzJSKTdP0CT6LdHyi3KvDYa98d5L2miwUck
        ikTQoJOYmIj3zvvbkEh9DxHea6q0G24=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-151YugsHMlGM23N1dhmmPw-1; Wed, 17 Jun 2020 13:37:44 -0400
X-MC-Unique: 151YugsHMlGM23N1dhmmPw-1
Received: by mail-wr1-f69.google.com with SMTP id w4so1671656wrl.13
        for <kvm@vger.kernel.org>; Wed, 17 Jun 2020 10:37:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2hNrLKFzx+SU91EcmopqxtknC1GSH8vyiR3LApBQTDs=;
        b=Tf31jjxkwN8swVvsV1CeeYiSRPrSSZeFXWK1yZN04UoCN48i1PiPwYB++8EnrzK6oA
         AIuaVMq0uWTL9S6fmK2Dy7L7Uuou58Mc89jk8UbCSG9nHLMZyTrSwsnPSA/QA1V3Dyn5
         AhIPUcD7PuJcZfszQ+KJlEOztIVvZfr9zDOGPhvx/YbNNz26n9n39x7gyAkOKSbMd19R
         HvDHOgPkFOBQoqxNGq/O62VJzSjEsC3G1WmHIM7y8jJABsCCETrIifCz8kIvfvLtl3tX
         fWa3QpRxJcDyssSDiiVEIPxF5/m90e0i7pnSewGjUzAjwZ9UFJH/I98txfM+9JBQaYJt
         n5yA==
X-Gm-Message-State: AOAM532EzJLbzsu1tElKEUInhhpcLbjBb7vtw6pnWTiVJEQR9DPEOyyP
        Z6KKzSTIUCfDRIy4VSrPXPXBW6QsQD4Qu/OpUYsEZ8XXAbGAO+/vf6MS9gQUfSNtBjJuybrGKjq
        vYo+ulSwYnOHe
X-Received: by 2002:a05:600c:2317:: with SMTP id 23mr9817908wmo.139.1592415463042;
        Wed, 17 Jun 2020 10:37:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx3YciH+f5OVe46ah2MB16qI0Gn1EiHqQ45UZ3u1EYqtXDANLy3Fba09QkOgNONjBrTbeFuXw==
X-Received: by 2002:a05:600c:2317:: with SMTP id 23mr9817888wmo.139.1592415462827;
        Wed, 17 Jun 2020 10:37:42 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:48a4:82f8:2ffd:ec67? ([2001:b07:6468:f312:48a4:82f8:2ffd:ec67])
        by smtp.gmail.com with ESMTPSA id r4sm334822wro.32.2020.06.17.10.37.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2020 10:37:42 -0700 (PDT)
Subject: Re: [PATCH] target/arm/kvm: Check supported feature per accelerator
 (not per vCPU)
To:     Andrew Jones <drjones@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
        kvm@vger.kernel.org, qemu-arm@nongnu.org,
        Haibo Xu <haibo.xu@linaro.org>
References: <20200617130800.26355-1-philmd@redhat.com>
 <20200617152319.l77b4kdzwcftx7by@kamzik.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <69f9adc8-28ec-d949-60aa-ba760ea210a9@redhat.com>
Date:   Wed, 17 Jun 2020 19:37:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200617152319.l77b4kdzwcftx7by@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/06/20 17:23, Andrew Jones wrote:
>>
>> Fix by kvm_arm_<FEATURE>_supported() functions take a AccelState
>> argument (already realized/valid at this point) instead of a
>> CPUState argument.
> I'd rather not do that. IMO, a CPU feature test should operate on CPU,
> not an "accelerator".

If it's a test that the feature is enabled (e.g. via -cpu) then I agree.  
For something that ends up as a KVM_CHECK_EXTENSION or KVM_ENABLE_CAP on 
the KVM fd, however, I think passing an AccelState is better.
kvm_arm_pmu_supported case is clearly the latter, even the error message
hints at that:

+        if (kvm_enabled() && !kvm_arm_pmu_supported(current_accel())) {
             error_setg(errp, "'pmu' feature not supported by KVM on this host");
             return;
         }

but the same is true of kvm_arm_aarch32_supported and kvm_arm_sve_supported.

Applying the change to kvm_arm_pmu_supported as you suggest below would be
a bit of a bandaid because it would not have consistent prototypes.  Sp
for Philippe's patch

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Thanks,

Paolo

> How that test is implemented is another story.
> If the CPUState isn't interesting, but it points to something that is,
> or there's another function that uses globals to get the job done, then
> fine, but the callers of a CPU feature test shouldn't need to know that.
> 
> I think we should just revert d70c996df23f and then apply the same
> change to kvm_arm_pmu_supported() that other similar functions got
> with 4f7f589381d5.

