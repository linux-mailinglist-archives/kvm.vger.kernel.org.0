Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61B1D97FBA
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 18:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728874AbfHUQKy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 12:10:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39092 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728818AbfHUQKy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 12:10:54 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D810A81127
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2019 16:10:53 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id d64so1375877wmc.7
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2019 09:10:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=bf53ejuZOSlhLHtc61nY4jW1OHoIiOodIZXqnz8kWvg=;
        b=e+cRJZv/R0fTfExfxSuk23smrfUN5Rczhdn6wlb9Vj61+5sTNnrd3GyGwCPUuiHdpt
         PJz7z6efqtuWQtfQSNbfe7kFTL29qmQ7jAP5ZdUHK8zGkt9S3VUPXoN9XXYQZeJJwbah
         2mo1OZALM4wRUKk1CiV5RcLVzedfdTzJauq4HmIQM1oZEM6rPV4suweqCoseuSB6hzvE
         DDRMO4U7U20jEoYWFF0fpuS55Ekwb+EWA4HRv1MoVRM1BZsR43C2UjqWac5pO+J9CE3m
         945Vq2o0bHIFFgjcDJIFHQjrozCNqSiBOi2DHOtBo+Or3hMK//o6jWMZNMutTSUxZm/O
         6YPw==
X-Gm-Message-State: APjAAAVB25LyKLn8FPsXI0iLzhM4RxT930cnV6IozVDgBjTi4aIzwDy+
        0kBh2kDESiDT2Lp6wH+q7qB3A43qp01U8NAbX/8gQhvg5CAo0IW/NRbHzN6QsGX9gj55WjnjqzU
        uUMlduAJrUfeC
X-Received: by 2002:a1c:9855:: with SMTP id a82mr848386wme.134.1566403852525;
        Wed, 21 Aug 2019 09:10:52 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzdsWcz+VcTHqGsZOaqeDIrpPhGJL8gZbM8ALMEUzVtEXgCpMS5vYwrM5kvS3PBSwdJYwDiOA==
X-Received: by 2002:a1c:9855:: with SMTP id a82mr848370wme.134.1566403852278;
        Wed, 21 Aug 2019 09:10:52 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id z8sm742639wmi.7.2019.08.21.09.10.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2019 09:10:51 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH] selftests/kvm: make platform_info_test pass on AMD
In-Reply-To: <20190610172255.6792-1-vkuznets@redhat.com>
References: <20190610172255.6792-1-vkuznets@redhat.com>
Date:   Wed, 21 Aug 2019 18:10:50 +0200
Message-ID: <87a7c2qz1x.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> test_msr_platform_info_disabled() generates EXIT_SHUTDOWN but VMCB state
> is undefined after that so an attempt to launch this guest again from
> test_msr_platform_info_enabled() fails. Reorder the tests to make test
> pass.
>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  tools/testing/selftests/kvm/x86_64/platform_info_test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/kvm/x86_64/platform_info_test.c b/tools/testing/selftests/kvm/x86_64/platform_info_test.c
> index 40050e44ec0a..f9334bd3cce9 100644
> --- a/tools/testing/selftests/kvm/x86_64/platform_info_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/platform_info_test.c
> @@ -99,8 +99,8 @@ int main(int argc, char *argv[])
>  	msr_platform_info = vcpu_get_msr(vm, VCPU_ID, MSR_PLATFORM_INFO);
>  	vcpu_set_msr(vm, VCPU_ID, MSR_PLATFORM_INFO,
>  		msr_platform_info | MSR_PLATFORM_INFO_MAX_TURBO_RATIO);
> -	test_msr_platform_info_disabled(vm);
>  	test_msr_platform_info_enabled(vm);
> +	test_msr_platform_info_disabled(vm);
>  	vcpu_set_msr(vm, VCPU_ID, MSR_PLATFORM_INFO, msr_platform_info);
>  
>  	kvm_vm_free(vm);

Ping!

-- 
Vitaly
