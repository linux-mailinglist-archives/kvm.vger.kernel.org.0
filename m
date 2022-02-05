Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B05034AA97D
	for <lists+kvm@lfdr.de>; Sat,  5 Feb 2022 15:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380171AbiBEOrE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Feb 2022 09:47:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35685 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232237AbiBEOrE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 5 Feb 2022 09:47:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644072423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aPLpvuiVypXts2FgeP2y88Eeuzjb+/ygbPxEt8OZv/4=;
        b=Qt7KDm1EuRrQY129YN72QPeRX82eUU7FAHgbq1gvmyuwS/nUN+vq6D/vf5BWQH+L4mYQrE
        MBJN+u0A9ZlSLQUM+j0manY5W+oi/3dJc81b4+vI6tj8qo4c9hJVKhLHjM8TMffXdKgix4
        pnNsl3sEwFvxh1dR2wGXblj8SHsaLkU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-290-yZ4XCRsTMgG6v9XVcvmwuQ-1; Sat, 05 Feb 2022 09:47:02 -0500
X-MC-Unique: yZ4XCRsTMgG6v9XVcvmwuQ-1
Received: by mail-ed1-f70.google.com with SMTP id b26-20020a056402139a00b004094fddbbdfso4771526edv.12
        for <kvm@vger.kernel.org>; Sat, 05 Feb 2022 06:47:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aPLpvuiVypXts2FgeP2y88Eeuzjb+/ygbPxEt8OZv/4=;
        b=mtvo8Kb+e3gusCsdsAyt57feq1kU+MnRRLCkWvFHlpkYnjRD/YJLdm5NwVz9tFBslY
         Y0zbNfG0oSm6c05NQ/HuwzfcmE4LMBjTxJ8cHt0K8lNocgQiXMdlLvL30cBgjKK/CVIy
         sAtQ/n7HXPev9L9XOWrrEOsU9vvqJk3ilgTKsR0QjUANQENrYyvJIakud0CgBXqEs0Hz
         doC49Rb7ARJaoV6BJ3WRsPqOyVJRCoLfsddAueWfI0VIlHv1MhW8rV0zfkL63VgY649E
         oF3alu7M9VjYls/oLt1vEaMWBHQ0JrSDI/ph9mC0sGL9R00Hg9Dk3W7VRelUmMmZHRM+
         9JAg==
X-Gm-Message-State: AOAM533Pvdcoj2tkdJyNqLvS0b2jfNumdGUkaozGGqWdx+hEF8EYfB4/
        RZMthAsxr3OHxn7WOr2x7RPor8s19fnIRmpVgw/RMA7LJz1AoU0LDFLbY88wn93TeLiuQGwOL1u
        q+Kp2a4Zy4k8a
X-Received: by 2002:a05:6402:1007:: with SMTP id c7mr4656908edu.424.1644072421482;
        Sat, 05 Feb 2022 06:47:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzekRqBKPktvzvqCpa6BNeqw4RYiEIa8aq6jU7oJn2qc5RF0X07KF/wHqGZiSVkAT4tRoUA9w==
X-Received: by 2002:a05:6402:1007:: with SMTP id c7mr4656885edu.424.1644072421248;
        Sat, 05 Feb 2022 06:47:01 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id g9sm1673202ejf.33.2022.02.05.06.47.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Feb 2022 06:47:00 -0800 (PST)
Message-ID: <32abf43b-7220-e905-c877-301fd1301ea1@redhat.com>
Date:   Sat, 5 Feb 2022 15:46:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 07/23] KVM: MMU: remove kvm_mmu_calc_root_page_role
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, vkuznets@redhat.com
References: <20220204115718.14934-1-pbonzini@redhat.com>
 <20220204115718.14934-8-pbonzini@redhat.com> <Yf1/ZyrPufhHKEep@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yf1/ZyrPufhHKEep@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/4/22 20:32, David Matlack wrote:
> On Fri, Feb 04, 2022 at 06:57:02AM -0500, Paolo Bonzini wrote:
>> Since the guest PGD is now loaded after the MMU has been set up
>> completely, the desired role for a cache hit is simply the current
>> mmu_role.  There is no need to compute it again, so __kvm_mmu_new_pgd
>> can be folded in kvm_mmu_new_pgd.
>>
>> As an aside, the !tdp_enabled case in the function was dead code,
>> and that also gets mopped up as a side effect.
> Couldn't the !tdp_enabled case be called via kvm_set_cr3() ->
> kvm_mmu_new_pgd()?
> 

Right, it's not dead code.  Rather, there never was a need for 
kvm_mmu_calc_root_page_role(vcpu) as opposed to just using what is 
already in vcpu->arch.mmu.

Paolo

