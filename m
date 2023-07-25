Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D49F761C46
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 16:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbjGYOwL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 10:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbjGYOwK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 10:52:10 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21BD8E77
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 07:52:09 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-cf4cb742715so6351403276.2
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 07:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690296728; x=1690901528;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EuswUUvQmlUzTdyahqM81yDJAxq5BDNLAyifzL2kDmw=;
        b=7enRUTFU36NlUV9k9d1LrREoh+PMOSydJcFHqM8HdWaoNOed7TBfam0E/XN0ZlxYSk
         4tmDx90iMpGViFu3k2dOrI7kt7F7JiNgFrj+RNcyVDf3Hv/YxtEm1OJRcfvvElOt2kaw
         iOdJL6cbiLfFdZ8bLmX7zwAJWQ32b/+TP5oyS2n6J7mUwa1huLnwQFScSv9ia0JQqMeM
         Ej8edqyM+Iqq9l++k1hKMa5Jh1/+2nDihG0RaQTghkMXCxPOhaXtTbDwOhdErn3xQG3G
         D3kyvvd9WhJz06j/rAEQPPwC3N4y/gBNo2O6x5esGTdPgmI6FxAQoJU7HFp3Ju74s6HW
         p3Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690296728; x=1690901528;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EuswUUvQmlUzTdyahqM81yDJAxq5BDNLAyifzL2kDmw=;
        b=EpP8sIwYYJvFcQz+yg7seP6KXMxgd4Feqqc1W9yLxnn7L/86JT15yUZFktXYbl5snp
         O5hMODa7XF3OYb/6xJPvWFKwpm/wuGwkChahkfGy3gCUxgO21fOnBptRj4Ou3qsQEBOb
         ibuRAUCFmnQ4fxqLRHMW7Yc1TfLDD0iG61IyXeBIW/9LlwftXCi1WvlV4FsAJZIegiJh
         sbwnpcZUAkpszqxjefgIxvFizkCNpS+2V92tHfDGZHw0wG9mZQhuf+68nPRwQEDfw7Tp
         63byp3DvPuzk62+JAMhFBiMTYDO7a/n6KTY8s/BPwJdOkUnHqitIY3xRFuwMvP8CoL67
         YB9w==
X-Gm-Message-State: ABy/qLa6lbuGszW2k3Ya3GmQYHU6h1iu/aNT/J6ooJy3YgGs1+ganfDc
        esZSorGCVYwJLmhwgw8gnBqsyFozGl8=
X-Google-Smtp-Source: APBJJlHwdGIL3JCt/pfGQUNXJV+D65iPFoi1/mWhFsnklNLdam+UscJ1tOBOQQ3YxFKj5jbkaGWuXjffR6s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:521:b0:d11:3c58:2068 with SMTP id
 y1-20020a056902052100b00d113c582068mr30906ybs.2.1690296728331; Tue, 25 Jul
 2023 07:52:08 -0700 (PDT)
Date:   Tue, 25 Jul 2023 07:52:06 -0700
In-Reply-To: <20230725100844.3416164-1-foxywang@tencent.com>
Mime-Version: 1.0
References: <20230725100844.3416164-1-foxywang@tencent.com>
Message-ID: <ZL/hlrWFzrtcdcmH@google.com>
Subject: Re: [PATCH] kvm: vmx: fix a trivial comment in vmx_vcpu_after_set_cpuid()
From:   Sean Christopherson <seanjc@google.com>
To:     Yi Wang <up2wing@gmail.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        wanpengli@tencent.com, Yi Wang <foxywang@tencent.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 25, 2023, Yi Wang wrote:
> The commit b6247686b7571 ("KVM: VMX: Drop caching of KVM's desired
> sec exec controls for vmcs01") renamed vmx_compute_secondary_exec_control()
> to vmx_secondary_exec_control(), but forgot to modify the comment.
> 
> Signed-off-by: Yi Wang <foxywang@tencent.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 0ecf4be2c6af..26d62990fea7 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7722,7 +7722,7 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  
> -	/* xsaves_enabled is recomputed in vmx_compute_secondary_exec_control(). */
> +	/* xsaves_enabled is recomputed in vmx_secondary_exec_control(). */
>  	vcpu->arch.xsaves_enabled = false;

I have an in-progress patch[*] that reworks this code and wipes out the stale
comment as a side effect.  Thank you though!

[*] https://lore.kernel.org/all/20230217231022.816138-4-seanjc@google.com
