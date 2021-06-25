Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48F0B3B3FDF
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 10:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhFYJAR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 05:00:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58501 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229839AbhFYJAQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Jun 2021 05:00:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624611475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z7hC2aDaEZMwZuCypCIswjUuv9JA1ZXi3BbgeUjua2c=;
        b=JLWESkJ1kRXWyQdhixV4wsvckfdw5rgISRfpADGxDC5gWyNvFzOWugTkqv9SY9hyQBVEKL
        CKJe2eqRqMxGsHZZcm5M8o0zYs5XodsHpyb9crcaidhgguHGTpPH6NxBhyFBzZXZ9Id7NM
        ydWUlILCUDE4mKUK5yULM5EywMwfkzw=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-wWElaZP-O0COHkluV0XNfQ-1; Fri, 25 Jun 2021 04:57:54 -0400
X-MC-Unique: wWElaZP-O0COHkluV0XNfQ-1
Received: by mail-ej1-f72.google.com with SMTP id q14-20020a1709066aceb029049fa6bee56fso2841437ejs.21
        for <kvm@vger.kernel.org>; Fri, 25 Jun 2021 01:57:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z7hC2aDaEZMwZuCypCIswjUuv9JA1ZXi3BbgeUjua2c=;
        b=IUV0X/eD0NlFv2dPiCBEURQ2fWXwaEvNhlfX0v0iLchLVmfaL+SE78zOILp87rciq4
         7qF0n52KLG0DU1q0bOcZfATmKg5bg5aMJKOouwEKGqsTcHsVSaSLWS0XvioBld7TeSYE
         wu/vU2+8aj8+SXlE9svb9puemLy2zxo6y5gf5u+FzIaQSlawhqQSk6dbDuw0leKg5Mmu
         HwqGNVXQDKqCOhMxqPGCByPs0A49OXCXpCw6nTeYta+ZkS3ftrhbZ3oOMzxOE/3M8y2d
         V2RbzD8B5oWsQgTFJNzwuVnXrt9aW64NtpbVCDXPNrmphb3jRNI7gZLHpgbto0AvYpqV
         +9HA==
X-Gm-Message-State: AOAM530XGEGNrgrFVNVP0a9Pj/QKjpD/RlL4z1+EO4flrIlAfbb/aBsm
        rUYgzGeSmSz0H6Jgi/W76NiK6SEB9YfXU3b6P7dvZtZ8tkxfKF0mJULLuPNb4yAbzyBXfhM4m9g
        RP12wytzw/meY
X-Received: by 2002:aa7:c648:: with SMTP id z8mr1097312edr.384.1624611473118;
        Fri, 25 Jun 2021 01:57:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJysSqfGdK5bBctBEQT5D4lGEIgTGtqG/WbIFUmNaQcm+60RoRS+vvF3iacOwH1FhxuIliPxYA==
X-Received: by 2002:aa7:c648:: with SMTP id z8mr1097302edr.384.1624611473014;
        Fri, 25 Jun 2021 01:57:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id qq26sm2408826ejb.6.2021.06.25.01.57.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jun 2021 01:57:52 -0700 (PDT)
Subject: Re: [PATCH 05/54] Revert "KVM: x86/mmu: Drop
 kvm_mmu_extended_role.cr4_la57 hack"
To:     Yu Zhang <yu.c.zhang@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-6-seanjc@google.com>
 <20210625084644.ort4oojvd27oy4ca@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <09a49caf-6ff5-295b-d1ab-023549f6a23b@redhat.com>
Date:   Fri, 25 Jun 2021 10:57:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210625084644.ort4oojvd27oy4ca@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/06/21 10:47, Yu Zhang wrote:
>> But if L1 is crafty, it can load a new CR4 on VM-Exit and toggle LA57
>> without having to bounce through an unpaged section.  L1 can also load a
>
> May I ask how this is done by the guest? Thanks!

It can set HOST_CR3 and HOST_CR4 to a value that is different from the 
one on vmentry.

Paolo

