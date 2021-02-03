Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD6430D9EF
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 13:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbhBCMlc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 07:41:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35671 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229522AbhBCMl1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 07:41:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612355998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mXIEHt/+ZImaha+lRwXZShNsH0YZB0lQG8cbY1aYCEA=;
        b=Vr3Z+StNSdVpa0QwRpYwVrY3MNdhqpxmTjV8/AcAye3pXcH7z4jMWuEVjebDR1PRtoVSu9
        7JzogTFRShOSNsTN7BNpHiRMQAiRt6Ocge17/ClPT0BBYwiAWYxlB/vxS4oF15E2zF7Sgm
        8UoBF/iHfDkn7Gy3KZCZYUKo3Qa+sHw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-gEUxCX2kPWOhNyQTIKoxMw-1; Wed, 03 Feb 2021 07:39:56 -0500
X-MC-Unique: gEUxCX2kPWOhNyQTIKoxMw-1
Received: by mail-ed1-f72.google.com with SMTP id f21so11459809edx.23
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 04:39:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mXIEHt/+ZImaha+lRwXZShNsH0YZB0lQG8cbY1aYCEA=;
        b=UBXzuuCHWeGNJ3DjQ8uUyv3YxscytF1XOZJTMIlDJJJvd0H8vwgyOpDZhB/X8eOSx5
         w4abW6lkPxH23fkUmDkhWM3Mpvpye/Eg1DcA+VQXeXM31eY9MpVtyDAfzc9y1BQCbxhN
         aB6Vlo9MUwndSqZAGMpXOAsO4TazkCbi4Xa9SC8Euagff0w0QdIb3x+ZGYKr8JAmKKc6
         WAXga3c2xD4x57G3KtRHW30/ns6Zvb8fUmQDpEDn2MGMmaQ5+QzCX/GYL7NuIDFE9Tmf
         qCCpZsNzV63LSxki0VQ44FFocNinrVH/+j86sHUFWlCkXAOXlf01ku53dYiee2c6NQoa
         16sg==
X-Gm-Message-State: AOAM530H0x0lMovKbpr14JTwXkNEhzsWwDxErN0kdImn0FE8x2GZ7dNg
        AI2F5ENFR8RejgB1s9XgGWK6VzmmGHv7fhWNpud44+vY6nRK9w8dCYnH94KCfRXGTg9ujAmwW2A
        lboxAy+NIMqPo
X-Received: by 2002:a17:906:2993:: with SMTP id x19mr2816797eje.409.1612355995523;
        Wed, 03 Feb 2021 04:39:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyTXgGps9Cf5vzp942FAOVNGcW5hyMGurVlJU/3ZT8IdK2S9BrQGLYHWjZgagUazvZZuD63Lw==
X-Received: by 2002:a17:906:2993:: with SMTP id x19mr2816786eje.409.1612355995361;
        Wed, 03 Feb 2021 04:39:55 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id gt18sm952486ejb.104.2021.02.03.04.39.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 04:39:54 -0800 (PST)
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20210202185734.1680553-1-bgardon@google.com>
 <20210202185734.1680553-24-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 23/28] KVM: x86/mmu: Allow parallel page faults for the
 TDP MMU
Message-ID: <d2c4ae90-1e60-23ed-4bda-24cf88db04c9@redhat.com>
Date:   Wed, 3 Feb 2021 13:39:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210202185734.1680553-24-bgardon@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/02/21 19:57, Ben Gardon wrote:
> 
> -	write_lock(&vcpu->kvm->mmu_lock);
> +
> +	if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
> +		read_lock(&vcpu->kvm->mmu_lock);
> +	else
> +		write_lock(&vcpu->kvm->mmu_lock);
> +

I'd like to make this into two helper functions, but I'm not sure about 
the naming:

- kvm_mmu_read_lock_for_root/kvm_mmu_read_unlock_for_root: not precise 
because it's really write-locked for shadow MMU roots

- kvm_mmu_lock_for_root/kvm_mmu_unlock_for_root: not clear that TDP MMU 
operations will need to operate in shared-lock mode

I prefer the first because at least it's the conservative option, but 
I'm open to other opinions and suggestions.

Paolo

