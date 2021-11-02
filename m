Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBA4442BBB
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 11:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbhKBKli (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 06:41:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29208 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229720AbhKBKlh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Nov 2021 06:41:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635849542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bhltnQ/IDYqVqoMtn3iaf/jbw6dys4TOAVjSoP2en70=;
        b=ftuYvz0f2o6T0IsG/mLmnfyOCN375S3GXhghzfrdmVhPeap+Y7knJ1neDhzZmJzDbnlPBa
        aS5lwtpPlkwZxoomH5TgLPm4RUt9vV83HzhR49g4HzFtmcjcRWPOFkNvgwd7UgixiVl7Wf
        O2PzCHbDUPKFmidNtWBvr/JUX6Upo9M=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-2j0Peku-MIGFoIDbt3gTkA-1; Tue, 02 Nov 2021 06:39:00 -0400
X-MC-Unique: 2j0Peku-MIGFoIDbt3gTkA-1
Received: by mail-wm1-f72.google.com with SMTP id v10-20020a1cf70a000000b00318203a6bd1so685835wmh.6
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 03:39:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bhltnQ/IDYqVqoMtn3iaf/jbw6dys4TOAVjSoP2en70=;
        b=QducrzgqFZLQzAyOtwasKPe9BGxDju+B5GUwUgP/+SnHFYtyA+76oxr6ZrQlk1P3JR
         15TQ5uAQpdvY7jFP8JgJUgHphZaSLf2LieBMC6Kv94B5zHrn4ZrCwznrl4RH/Yxf2AX5
         yGWgOig0gwdzOXn6wdkef1aJtbCCdkoUwAJQYHAIN3Kg8Yvhez06YI1F9cYMdMMRb3O6
         CH9a/mERfcchX2ZgWORWk8BL8LhevD9o0CyAVxZ/DBxHlVKsUCfLqjDkX8lY6LzzXnaE
         hj6O3xqgaVNqzYn7Gk2Q9O7/1hqChhi6857g6AMBDwhoNx+7va+gCnMEALDCDC2r/WNa
         nArw==
X-Gm-Message-State: AOAM532OJDzSIRQPZFV1C0NfnaT28RZqw7v+WavSO51HstFtRU6V48tb
        ZceQj6/Dv0zviI6gk5qHkUy6CjYGoQSPPvm7CPVTliSdA1JJzkBQk2aM6UDo/Pj3tI31JViciNS
        ZMlszjnIyIErp
X-Received: by 2002:a05:600c:19cf:: with SMTP id u15mr5891740wmq.45.1635849539784;
        Tue, 02 Nov 2021 03:38:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJykeawxvx6bfayKvUepPf21+4UINAxY2GvERM+EexrDVyOcHBFWoYxiAKXSaZmBxwjDCvQC3A==
X-Received: by 2002:a05:600c:19cf:: with SMTP id u15mr5891714wmq.45.1635849539573;
        Tue, 02 Nov 2021 03:38:59 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id i13sm2427238wmq.41.2021.11.02.03.38.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 03:38:58 -0700 (PDT)
Message-ID: <343745d4-d60b-5f62-fef5-a00004a73f71@redhat.com>
Date:   Tue, 2 Nov 2021 11:38:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 3/3] KVM: SVM: add migration support for nested TSC
 scaling
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
References: <20211101132300.192584-1-mlevitsk@redhat.com>
 <20211101132300.192584-4-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211101132300.192584-4-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/11/21 14:23, Maxim Levitsky wrote:
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>   target/i386/cpu.c     |  5 +++++
>   target/i386/cpu.h     |  4 ++++
>   target/i386/kvm/kvm.c | 15 +++++++++++++++
>   target/i386/machine.c | 23 +++++++++++++++++++++++
>   4 files changed, 47 insertions(+)

It's easier to migrate it unconditionally:

diff --git a/target/i386/machine.c b/target/i386/machine.c
index e1138693f3..83c2b91529 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -1286,8 +1286,7 @@ static bool amd_tsc_scale_msr_needed(void *opaque)
      X86CPU *cpu = opaque;
      CPUX86State *env = &cpu->env;

-    return env->amd_tsc_scale_msr &&
-           env->amd_tsc_scale_msr != MSR_AMD64_TSC_RATIO_DEFAULT;
+    return (env->features[FEAT_SVM] & CPUID_SVM_TSCSCALE);
  }

  static const VMStateDescription amd_tsc_scale_msr_ctrl = {

> +    if (env->features[FEAT_SVM] & CPUID_SVM_TSCSCALE) {
> +        env->amd_tsc_scale_msr =  MSR_AMD64_TSC_RATIO_DEFAULT;
> +    }

and also set it unconditionally here, so that it's always passed 
correctly to KVM.

I queued patches 2 and 3, for (1) I need to think more about migration 
to older QEMU versions.

Paolo

