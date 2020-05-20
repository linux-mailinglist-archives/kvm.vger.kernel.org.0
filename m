Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3851DB45C
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 15:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgETNA2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 09:00:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22276 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726439AbgETNA1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 09:00:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589979625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vtwLpCcTit2OVWp8a2YL7RdmjJMudH8Vw35TudanvYM=;
        b=UdnTY1Edu55xq7KIvx6PesqFWtZsaWKtppV9cieLvmB+E7+31upjOMULbn7kFjcyf6TkYN
        bJzV0yrLmyUTR5kROPcJVDPM5KgcW874b1QGoss+T0lGUek+tf85o+UI/Ib65Gqmbod7Du
        6WtUOk8x058a7kOl+6UASsc2h4XtoX0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-kVS62CDGPhqSyfYu7YmrKA-1; Wed, 20 May 2020 09:00:23 -0400
X-MC-Unique: kVS62CDGPhqSyfYu7YmrKA-1
Received: by mail-wm1-f71.google.com with SMTP id u11so870318wmc.7
        for <kvm@vger.kernel.org>; Wed, 20 May 2020 06:00:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vtwLpCcTit2OVWp8a2YL7RdmjJMudH8Vw35TudanvYM=;
        b=O7gxi1E/aERA1R0o5PaaTUqys54DXvSnodyU8cIac5ox6BKgqmBZ8Ec2/0RERghcy0
         3Gyn6+oN3m0GCbbVu9wd3HPKZfwFXKa3Yyl+vIzl+URDoR7AtqIcYg3CW0uyNn2F0uR0
         bvBVWUf52wBYjNg3HxnwPHShUsl9KCXBQP92OFDDAU7IoVnCcLGxaorZ+d+0tkxjQydX
         AahRmF6Mzt2ICc3ME85oC3XVd5kIaLZYDmZG/P3OROlVm99l0Bu+Xb2ESL1pCwdCIKv0
         fte2WnaWlFKgp0YOEC4LHcX6/e9sp75zoeua6nf3b9/CCR1B33lYFdnTc8KIxSgGL6/R
         6CRA==
X-Gm-Message-State: AOAM533lREGsiNcky3mjkI5KKNvHZC3dAqRgqOSk5LeZOB0aXs0qwoV4
        opb+rwkl52LeTbuF0ZzyZ1xAMCUtP3VL8RTE0lh7PoSjB0AwPhLH6RqCyNAsZqyq7X4c9M8gAsn
        cK4vEZzEB49js
X-Received: by 2002:adf:fdc1:: with SMTP id i1mr427296wrs.0.1589979622421;
        Wed, 20 May 2020 06:00:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxnCq355+z+Oz9c/gOb5+5MlQ9JUxVessq1Rh7cNA3NtprMxMbg2gM3QyYAFpW8QTa8yHSHNw==
X-Received: by 2002:adf:fdc1:: with SMTP id i1mr427275wrs.0.1589979622227;
        Wed, 20 May 2020 06:00:22 -0700 (PDT)
Received: from [192.168.1.38] (17.red-88-21-202.staticip.rima-tde.net. [88.21.202.17])
        by smtp.gmail.com with ESMTPSA id h133sm3142083wmf.25.2020.05.20.06.00.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2020 06:00:21 -0700 (PDT)
Subject: Re: [PATCH v2 03/19] accel/kvm: Convert to
 ram_block_discard_disable()
To:     David Hildenbrand <david@redhat.com>, qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        qemu-s390x@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
References: <20200520123152.60527-1-david@redhat.com>
 <20200520123152.60527-4-david@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <2b6f0c1a-a2fd-0ecb-846e-848948266f8a@redhat.com>
Date:   Wed, 20 May 2020 15:00:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200520123152.60527-4-david@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi David,

On 5/20/20 2:31 PM, David Hildenbrand wrote:
> Discarding memory does not work as expected. At the time this is called,
> we cannot have anyone active that relies on discards to work properly.
> 
> Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>   accel/kvm/kvm-all.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index d06cc04079..7a6158fb99 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -40,7 +40,6 @@
>   #include "trace.h"
>   #include "hw/irq.h"
>   #include "sysemu/sev.h"
> -#include "sysemu/balloon.h"
>   #include "qapi/visitor.h"
>   #include "qapi/qapi-types-common.h"
>   #include "qapi/qapi-visit-common.h"
> @@ -2143,7 +2142,7 @@ static int kvm_init(MachineState *ms)
>   
>       s->sync_mmu = !!kvm_vm_check_extension(kvm_state, KVM_CAP_SYNC_MMU);
>       if (!s->sync_mmu) {
> -        qemu_balloon_inhibit(true);
> +        g_assert(ram_block_discard_disable(true));

Please do not evaluate code within an assert() call.

See the comment added to "qemu/osdep.h" in commit 262a69f4282:

/*
  * We have a lot of unaudited code that may fail in strange ways, or
  * even be a security risk during migration, if you disable assertions
  * at compile-time.  You may comment out these safety checks if you
  * absolutely want to disable assertion overhead, but it is not
  * supported upstream so the risk is all yours.  Meanwhile, please
  * submit patches to remove any side-effects inside an assertion, or
  * fixing error handling that should use Error instead of assert.
  */

>       }
>   
>       return 0;
> 

