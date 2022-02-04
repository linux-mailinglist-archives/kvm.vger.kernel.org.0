Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA1204A9573
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 09:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245733AbiBDItg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 03:49:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:53740 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244674AbiBDItg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 03:49:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643964575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KmoD3b9T2QlVeR55XUKFS9sSRzif+Zqzh068n/5n3FA=;
        b=f0BzoJFmLgfODsUYAYxhpx39IHBxzkXA3/RF/o092B+1wnRjQbkuaXdAdPELcNPQpz6SYh
        qX2SbVHTw95BTQrXc9lYNVl0y356c/rb79lkxN3EhG3wLLtc5ksYivcrfBr/dN+VzQ4p/j
        aNCTvwFawyAEaUqWYMnk7eVHh9IWHq8=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-201-uN6ZFHViOR69OgHOIiBkDw-1; Fri, 04 Feb 2022 03:49:34 -0500
X-MC-Unique: uN6ZFHViOR69OgHOIiBkDw-1
Received: by mail-ej1-f69.google.com with SMTP id v2-20020a170906292200b006a94a27f903so2251924ejd.8
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 00:49:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KmoD3b9T2QlVeR55XUKFS9sSRzif+Zqzh068n/5n3FA=;
        b=OtBJ0MAOkt1MXoM6G7xSas4BvyjPVtGKBH+SFdX7iUPLdAPAZ8kjeTzbac0KaNAfTP
         otcxKZqEHngvNBjU1NtYFmVxpAImVtjSPk42co8pnYqsZNIdCrtkpMSmTX93J7TDuQIE
         zzrX0cF0tNE18U8V8jmKruXbDrLwyIpqIqr3MOcbqAnJ+tI18oKi66XxkOu/G3X5YE94
         PmwRznWjBO79v2CrrRcoZlHRihS6Qu7ucfIVKceRM/SKqdZDPpvRw1973xZNur4G1IXU
         JvfOSdCbI+GmHSrsQwoFIHeNJVincgHEOOjgAX5p3OC0pQxogCGPi9vx6jbDHIF/oNzL
         PJ1A==
X-Gm-Message-State: AOAM530fwB7IHq4PRqza5r1T8QED9HiaKa/uDLyz8ksNvwM2RM2j0Svv
        y3oxpclnsJEdKAaHhvyXpG0ryeTQWlMgpIGZbWPWYXP06F5rk4AG/WQ0QL7uKwWNB/+ZPJYj2rW
        OTfmFzt10CVLY
X-Received: by 2002:a17:907:2d88:: with SMTP id gt8mr1604546ejc.618.1643964573348;
        Fri, 04 Feb 2022 00:49:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxvInqjlWbjztNR1P4DcWcUE2FAOcKPCXPBcb6/ec1lRJOz1W9DqXcHE6darCzcl4xe6tB2fg==
X-Received: by 2002:a17:907:2d88:: with SMTP id gt8mr1604530ejc.618.1643964573160;
        Fri, 04 Feb 2022 00:49:33 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id g9sm428003ejf.33.2022.02.04.00.49.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Feb 2022 00:49:32 -0800 (PST)
Message-ID: <53c1864c-f966-0412-deb5-10912e84555c@redhat.com>
Date:   Fri, 4 Feb 2022 09:49:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 0/6] KVM: selftests: Introduce selftests for enlightened
 MSR-Bitmap feature
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
References: <20220203104620.277031-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220203104620.277031-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/3/22 11:46, Vitaly Kuznetsov wrote:
> KVM gained support for enlightened MSR-Bitmap Hyper-V feature (Hyper-V
> on KVM) for both nVMX and nSVM, test it in selftests.
> 
> Vitaly Kuznetsov (6):
>    KVM: selftests: Adapt hyperv_cpuid test to the newly introduced
>      Enlightened MSR-Bitmap
>    KVM: selftests: nVMX: Properly deal with 'hv_clean_fields'
>    KVM: selftests: nVMX: Add enlightened MSR-Bitmap selftest
>    KVM: selftests: nSVM: Set up MSR-Bitmap for SVM guests
>    KVM: selftests: nSVM: Update 'struct vmcb_control_area' definition
>    KVM: selftests: nSVM: Add enlightened MSR-Bitmap selftest
> 
>   tools/testing/selftests/kvm/Makefile          |   1 +
>   .../selftests/kvm/include/x86_64/evmcs.h      | 150 ++++++++++++++-
>   .../selftests/kvm/include/x86_64/svm.h        |   9 +-
>   .../selftests/kvm/include/x86_64/svm_util.h   |   6 +
>   tools/testing/selftests/kvm/lib/x86_64/svm.c  |   6 +
>   .../testing/selftests/kvm/x86_64/evmcs_test.c |  64 ++++++-
>   .../selftests/kvm/x86_64/hyperv_cpuid.c       |  29 +--
>   .../selftests/kvm/x86_64/hyperv_svm_test.c    | 175 ++++++++++++++++++
>   8 files changed, 424 insertions(+), 16 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
> 

Queued, thanks.

Paolo

