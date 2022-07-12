Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98AAC571C82
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 16:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiGLO23 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 10:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiGLO2I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 10:28:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8B833B9DA2
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 07:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657636079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZYHjDyHRUCfENuUw1YAFJ33SC7QGQxArlza+HDxiHoc=;
        b=M+zMupxSQBDBYj0UIMIxz023jTxtoryxc+/X/h2oqHqYQ6Fjx4W/HF5YtZ/XdaDkW1uD5t
        7rv5BgRWaqe6en6dX3MHIdXVvr5wuOniAnq7RzkVVVftLVT1OEMMQLjUcIHRCHBCCf87Nf
        P0vThjDxOGg6PuUiFQwgzvdr6bozkLE=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-78-jaRxUyoiON6P9TCZVwY1jw-1; Tue, 12 Jul 2022 10:27:58 -0400
X-MC-Unique: jaRxUyoiON6P9TCZVwY1jw-1
Received: by mail-qt1-f200.google.com with SMTP id ey13-20020a05622a4c0d00b0031ec4d66fc9so191402qtb.21
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 07:27:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ZYHjDyHRUCfENuUw1YAFJ33SC7QGQxArlza+HDxiHoc=;
        b=dL1EJC2WordCVdqBUHUCjLQjd8qaw+nhk18w2LflFO/ZAba5KybVCCgIx0F24D7xW2
         sN3FE8TAiRzRDg+qQePQaRddD2VbMF+SMt2oCLjClocdeJ9mTPVYWr62Z4WUJDjxzflR
         mhLGUJ5CEBOxa4HY/uehh98evZd8uusmGJOFnTOlYmlY4JVTtDLr+UZGOiqAU/CdDSjy
         8zl46DqVfEQ2vX3oMpO9q9l4KTtyj9LpJcL5Q2M2+poUZt+3lSx3D03darcsxURSfdhk
         jj6/q/KbSTySDnTVKpxhENNLuf96X7ErhGBuCnmBGsNP5X0iA/BhoFO7JOuO3AfRljlN
         US8A==
X-Gm-Message-State: AJIora8/QWvT10VcAyU3ZeTuUjP4pWJuuG/5y92+zh+UEik/zIVV8x9x
        pKMRfn1asaGlEX/4L5tLgUmxpLad3iT1bnDBGkaZ2gQqLAdhFniIcAXihgVASQwdazAfYEnvjV8
        QVmih6ctJREOe
X-Received: by 2002:ad4:5ecb:0:b0:473:6181:4a23 with SMTP id jm11-20020ad45ecb000000b0047361814a23mr10713349qvb.17.1657636078018;
        Tue, 12 Jul 2022 07:27:58 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tUMyMFGKWXzHGloySmQayJm5YD9ab0hOL9dwX7wDj4Knm+oQErb26Ep1Oc8MEI68R7YUTjdw==
X-Received: by 2002:ad4:5ecb:0:b0:473:6181:4a23 with SMTP id jm11-20020ad45ecb000000b0047361814a23mr10713333qvb.17.1657636077796;
        Tue, 12 Jul 2022 07:27:57 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id s7-20020a05620a254700b006a6b374d8bbsm9828944qko.69.2022.07.12.07.27.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 07:27:56 -0700 (PDT)
Message-ID: <ee479e42605d3ed3276b66da69179dbfbcb05dbc.camel@redhat.com>
Subject: Re: [PATCH] KVM: nVMX: Always enable TSC scaling for L2 when it was
 enabled for L1
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Date:   Tue, 12 Jul 2022 17:27:53 +0300
In-Reply-To: <20220712135009.952805-1-vkuznets@redhat.com>
References: <20220712135009.952805-1-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-07-12 at 15:50 +0200, Vitaly Kuznetsov wrote:
> Windows 10/11 guests with Hyper-V role (WSL2) enabled are observed to
> hang upon boot or shortly after when a non-default TSC frequency was
> set for L1. The issue is observed on a host where TSC scaling is
> supported. The problem appears to be that Windows doesn't use TSC
> frequency for its guests even when the feature is advertised and KVM
> filters SECONDARY_EXEC_TSC_SCALING out when creating L2 controls from
> L1's. This leads to L2 running with the default frequency (matching
> host's) while L1 is running with an altered one.

Ouch.

I guess that needs a Fixes tag?

Fixes: d041b5ea93352b ("KVM: nVMX: Enable nested TSC scaling")

Also this is thankfully Intel specific, because in AMD you can't enable
TSC scaling - there is just an MSR with default value of 1.0,
which one can change if TSC scaling is supported in CPUID.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Best regards,
	Maxim Levitsky


> 
> Keep SECONDARY_EXEC_TSC_SCALING in secondary exec controls for L2 when
> it was set for L1. TSC_MULTIPLIER is already correctly computed and
> written by prepare_vmcs02().
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 778f82015f03..bfa366938c49 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2284,7 +2284,6 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
>                                   SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
>                                   SECONDARY_EXEC_APIC_REGISTER_VIRT |
>                                   SECONDARY_EXEC_ENABLE_VMFUNC |
> -                                 SECONDARY_EXEC_TSC_SCALING |
>                                   SECONDARY_EXEC_DESC);
>  
>                 if (nested_cpu_has(vmcs12,


