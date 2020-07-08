Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3D92187E1
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 14:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729278AbgGHMnY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 08:43:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48033 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729012AbgGHMnX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 08:43:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594212202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WV6M1edub7XkEemGRBxIe4WR8aj11TMDUW7v+GRjIBg=;
        b=BdNai/0vhc4WR6gTgd1RnC0d+1FAbKAh7aB48pbCRsOo9mkLb7sO7uFza7YjM64ObaP6tz
        y4NjZPTEnoS+Swq4GMrwOMxbczwLnPO1CDK7EkeX1RgjloyfVHy2KRYO8xDh8aNg1a3z16
        hev0TTVg32REvXTWFRguKPlcZ94emzk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-qgPXMkHiPwCJZ0Mc7zpUBA-1; Wed, 08 Jul 2020 08:43:21 -0400
X-MC-Unique: qgPXMkHiPwCJZ0Mc7zpUBA-1
Received: by mail-wr1-f69.google.com with SMTP id o25so51791385wro.16
        for <kvm@vger.kernel.org>; Wed, 08 Jul 2020 05:43:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WV6M1edub7XkEemGRBxIe4WR8aj11TMDUW7v+GRjIBg=;
        b=mxVY6V0kIPPhMYwjSO9irKoiGLs8Lc+EWTt0y0US1DVCMpFO3S6ymdF7CZ957YZJpp
         1buhrUKYmxbiShi6BIB5XesG+vVl4ZacY0KFpyJLkofNSsA3HNI2+qOaEfh1J0k610Tz
         6E2dZN9mXkIMgMzqSaBgYyCq/I8x5hNhT1Wjdb4kK6787yaJw2Bs90mrnhRmlNASvuvq
         LR3IW87DXz15zEwoD7p5Z83Qj3jYctg6W/YVFVIOLWdtXmfaON+rL5Q3fDPEM9M3C+cr
         CeN2Bnudsa3gsA12qtuiJjipbc+EUPMseMu+SCVMvLZ+J1wmrF1hsg0mexmu/dQuaPSM
         bQow==
X-Gm-Message-State: AOAM533VTpVNSq/g0xjx2FaZCYwB6Vn87Gr2k9n3f7L7aStTtwlRP2XC
        UHYPbM9OKOYOO7zZnGLrU8d47xZI9xbDde+WFeypB2Ij3MrWauxJjvlzLjoNSKbqRQLNC56qAZU
        8ok6UfZKK9VMN
X-Received: by 2002:a1c:7313:: with SMTP id d19mr8669921wmb.147.1594212200016;
        Wed, 08 Jul 2020 05:43:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxkoQtC57N6nn9Fjhc1r7NZTTbvaPCCGsS00bdHLaY5V5WFB96pVfk+xMJs0avi9JF/QeP6gw==
X-Received: by 2002:a1c:7313:: with SMTP id d19mr8669908wmb.147.1594212199839;
        Wed, 08 Jul 2020 05:43:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id 26sm5701946wmj.25.2020.07.08.05.43.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 05:43:19 -0700 (PDT)
Subject: Re: [PATCH v3 3/8] KVM: X86: Introduce kvm_check_cpuid()
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20200708065054.19713-1-xiaoyao.li@intel.com>
 <20200708065054.19713-4-xiaoyao.li@intel.com>
 <3a085ea6-1f2b-904a-99a4-e10ed00e99a0@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9c691531-512a-41ef-883c-1831c75b8e8b@redhat.com>
Date:   Wed, 8 Jul 2020 14:43:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <3a085ea6-1f2b-904a-99a4-e10ed00e99a0@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/07/20 14:28, Xiaoyao Li wrote:
>> @@ -202,12 +208,16 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
>>           vcpu->arch.cpuid_entries[i].padding[2] = 0;
>>       }
>>       vcpu->arch.cpuid_nent = cpuid->nent;
>> +    r = kvm_check_cpuid(vcpu);
>> +    if (r) {
>> +        vcpu->arch.cpuid_nent = 0;
> 
> Paolo,
> 
> here lack a kvfree(cpuid_entries);
> Can you help fix it?
> 
> Apologize for it.

Actually I hadn't queued this patch; my mistake.  You can fix it and resend.

Paolo

