Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93953AED9E
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 16:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404787AbfIJOqw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 10:46:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54822 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404683AbfIJOqv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 10:46:51 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1D5867BDA5
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 14:46:51 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id f11so9064592wrt.18
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 07:46:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l65DH9YU8mGm5SKX7d473lQ/ogVgAEFpiCQPfaq4s9w=;
        b=LL9VG0Ae0gYGI1a9rMfeU+yEquXDZayg3urOVuO3+UeKwLZJjMsRfbAbsbK2CUPnnK
         EVrPiB907ry4YjNGZcH1CKgxoo8toMyZ9x5glHBlDQgP/CvhJ9pc2LcrGZpMRJRU9a44
         HV0l2tLa2SiLHQitfQaFFkIyYw4qoXJZZMtFmHLD1C2tNjeNHwP3L/1jVGwNj1dW3fXk
         2W3MMwEc8Bq1R9vDkKaRBcRFipB+D+cHru29hvcef6vzGtGBcx5801SqSsPG9iNWJ0rG
         O3MAdTIc20ZjL48S+Gkh0W6Ue+H2RI5I4NUjsTNqsIjiflw1iPumR7v/bLBfxectJ2Ob
         lbFQ==
X-Gm-Message-State: APjAAAX5H+pBYAlseCsoziT7ins9qi8/MeyTZNzHWaWlQ+SsNcMPJSy9
        hJJmNrwDcZSp7aUgH1SUyYm8q03zdDJCsn9kBkvPaOQ2SM9nMeEoZCVaG2xCPKGkAkOIehJnZqZ
        0rXDjQoo7ObH9
X-Received: by 2002:adf:a415:: with SMTP id d21mr29253255wra.94.1568126809755;
        Tue, 10 Sep 2019 07:46:49 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyEtqpz9+QHudRI7ZuVLKmH9ZYfUdB3RnY01oSb+YAktsbq6ibE/u2+TUEOXFJ5W8JaXy6TkQ==
X-Received: by 2002:adf:a415:: with SMTP id d21mr29253228wra.94.1568126809497;
        Tue, 10 Sep 2019 07:46:49 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id u83sm4830710wme.0.2019.09.10.07.46.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2019 07:46:49 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 3/3] x86: Bump max number of test CPUs to
 255
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Evgeny Yakovlev <wrfsh@yandex-team.ru>
References: <20190906163450.30797-1-sean.j.christopherson@intel.com>
 <20190906163450.30797-4-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <35a43a76-205c-48f3-a06e-c9883dd75c3f@redhat.com>
Date:   Tue, 10 Sep 2019 16:46:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190906163450.30797-4-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/09/19 18:34, Sean Christopherson wrote:
> The max number of CPUs is not actually enforced anywhere, e.g. manually
> setting '-smp 240' when running a unit test will cause random corruption
> and hangs during smp initialization.  Increase the max number of test
> CPUs to 255, which is the true max kvm-unit-tests can support without
> significant changes, e.g. it would need to boot with x2APIC enabled,
> support interrupt remapping, etc...
> 
> There is no known use case for running with more than 64 CPUs, but the
> cost of supporting 255 is minimal, e.g. increases the size of each test
> binary by a few kbs and burns a few extra cycles in init_apic_map().
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  lib/x86/apic-defs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/x86/apic-defs.h b/lib/x86/apic-defs.h
> index 7107f0f..b2014de 100644
> --- a/lib/x86/apic-defs.h
> +++ b/lib/x86/apic-defs.h
> @@ -6,7 +6,7 @@
>   * both in C and ASM
>   */
>  
> -#define MAX_TEST_CPUS (64)
> +#define MAX_TEST_CPUS (255)
>  
>  /*
>   * Constants for various Intel APICs. (local APIC, IOAPIC, etc.)
> 

Since this is not a multiple of 8 anymore, the previous patch should
have used (max_cpus + 7) / 8.  Fixed that and queued.

Paolo
