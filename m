Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2592A1836
	for <lists+kvm@lfdr.de>; Sat, 31 Oct 2020 15:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgJaOfh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 31 Oct 2020 10:35:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39412 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727708AbgJaOfh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 31 Oct 2020 10:35:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604154936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H0lkAu0LuB0tOs+5f8N9+fz1OpdbLPMVMxAKM8Po2Ws=;
        b=XOUYCwC6remB89fB/zAvt53XgyYCfTN1YKFcF/nu7U77u7uRc1OiO2g2Ir8UYeJpe7W4ZK
        vHrW0Tx/O8jjpLdO3vaeWYab5+y7x4oje7URx5fWbU/jNfS0aShBFUR6hV675h39BJimo9
        Sx6n2Az6kd8BmGA49IcqrSLFa0Fnk8Q=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-An16-kRqPQiKj_omjbaaBg-1; Sat, 31 Oct 2020 10:35:34 -0400
X-MC-Unique: An16-kRqPQiKj_omjbaaBg-1
Received: by mail-wr1-f71.google.com with SMTP id n14so4067537wrp.1
        for <kvm@vger.kernel.org>; Sat, 31 Oct 2020 07:35:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H0lkAu0LuB0tOs+5f8N9+fz1OpdbLPMVMxAKM8Po2Ws=;
        b=lWstHDvIYK12YfL8sbGL9D6eAEZ2NGPVm7EW/ImzZvK1F37cXb6zq5cRivUW+CFZr0
         hJNYhWf0ZpcByONrc+lYmUmQ303ACX5lDcqukhxVtzEYCcpynO/MghpAnpeEznJ+vh0Z
         ye5fryK8tXIIeg6nTVQfUGBOIQBshONAHk+TM3TbYecMamFpqHgMt1fleqT2wQxyt3Rj
         NRCmKOzwOkkH9rgLFHx+WFNTfD7wLzV/9xhd2cKfI9mEsfzCCAmnqEBhpn19VK9br6Ue
         NVcw/zdYk16RTJ2FlwH5PuGreXnjUsmW6AZz8ycBWbU7Pz8dYpTIL433QRBCBpFkOM5r
         CnSg==
X-Gm-Message-State: AOAM533Y+oQbVjtiqDn0wjjZBsRSqdAhAUNWDT2YrEpnWleAonE0HMVj
        fATuKmjGa9oK+zWMrmQicM61RcvglNQOVrO2objFyj0mlcva4ZeaogYd/PdG4iz/K4KlJ+oBkL3
        WelrBEYUdMCEi
X-Received: by 2002:adf:bc13:: with SMTP id s19mr9937610wrg.338.1604154932823;
        Sat, 31 Oct 2020 07:35:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzRUEvE78CjaR4PD/v54GUMMq51fFQdnVnGD7YpW4KmEScBQ8r2gsS4wkXgkWdYcQLslmW02A==
X-Received: by 2002:adf:bc13:: with SMTP id s19mr9937597wrg.338.1604154932571;
        Sat, 31 Oct 2020 07:35:32 -0700 (PDT)
Received: from [192.168.178.64] ([151.20.250.56])
        by smtp.gmail.com with ESMTPSA id c185sm8913539wma.44.2020.10.31.07.35.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2020 07:35:31 -0700 (PDT)
To:     Marc Zyngier <maz@kernel.org>
Cc:     David Brazdil <dbrazdil@google.com>, Gavin Shan <gshan@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Qais Yousef <qais.yousef@arm.com>,
        Quentin Perret <qperret@google.com>,
        Santosh Shukla <sashukla@nvidia.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20201030164017.244287-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.10, take #1
Message-ID: <6a598342-93dd-58dc-1615-b9773605f32c@redhat.com>
Date:   Sat, 31 Oct 2020 15:35:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201030164017.244287-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/10/20 17:40, Marc Zyngier wrote:
> Hi Paolo,
> 
> It was good to see you (and everyone else) at KVM Forum this week!
> 
> And to celebrate, here's a first batch of fixes for KVM/arm64. A bunch
> of them are addressing issues introduced by the invasive changes that
> took place in the 5.10 merge window (MM, nVHE host entry). A few
> others are addressing some older bugs (VFIO PTE mappings, AArch32
> debug, composite huge pages), and a couple of improvements
> (HYP-visible capabilities are made more robust).

Better now than later! Thanks, pulled.

Paolo

