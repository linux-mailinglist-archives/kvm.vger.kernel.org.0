Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F030D709EF3
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 20:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbjESSRM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 14:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjESSRL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 14:17:11 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F9712C
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 11:17:09 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-2533b914d33so3761610a91.3
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 11:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684520229; x=1687112229;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=p7OoJfw3RHMFn7mGuM4fGvncHAWlDYR0N8g6j4d0nVE=;
        b=DbwE3NxE6r7NeADpJ6ABRv/bnfbI/0LJHJMB4K9aetjV+ctmPbRt8KZUZnB01lVh5f
         Pg+4MezKvCs8pFl8SfCID+aeV7vPPOze2DihxQ255PZc9nbStbalRpZJxN/8KtbLFUqz
         mPvEu2FuiKLgDWEjbLSBchLAPyq7FcJtsXX/+0NVzcRG6xJp0tL8ef+iRpeXJiY5MOrJ
         LlsX9CDFab32oYpXoHnXeD2nF0SzwspoWHRrSlISx7x5U8+1O4idqew6Bm8pZvyzys41
         WhqXGk9Nz5xYy7crWzMUSDrORyjLJm8D3jkz6U2qM0DnOf+nYH9bfJYsNfR0I3NoWlSd
         yUsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684520229; x=1687112229;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p7OoJfw3RHMFn7mGuM4fGvncHAWlDYR0N8g6j4d0nVE=;
        b=bh74/yw467p3tOTyvPE598cmSKd9ew6AtBSXkicQIxRffh2hp7IDOaue9fbtAHoWvT
         5j045ifWIdOAwOjZQQ2b7xRNu3Il901iLu2g5QwHDV3ov8XdU33j21jDNJuH28ghuxPH
         T4bc+PrDL3cC42CRLgpTZN71jNcIs++uAkMuqcZnftO45xl81r3dMqrjVnOovyz0vK3+
         INCLgWsB1LRQWJUgNEYkGX81NnXeJJ6tYnrnHOexzY6ie5UfVg/mGGtjB5rtw1RtJmcC
         GMdy8My6xRHCNoBn8IYc2gztC0CeRCH8DaNfwtkXTzR/kwIcajvJheWwWdZFmpter2cL
         CYqw==
X-Gm-Message-State: AC+VfDy4h0bYskvIQCfzfdenihMp7fB1i6MNLHnwlxzq0ScVKZLyxPQb
        Tl6L2yPaGblUS8dLnc7eFctHGeCnWdQ=
X-Google-Smtp-Source: ACHHUZ5hiuYY7xIICZlrf2NJEEijsjU6hS74QOOvmQfsNtxcSIqUyXsJfot6x9ETVDyakelaxsAowBF8Hlg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:b03:b0:253:8392:8c2f with SMTP id
 bf3-20020a17090b0b0300b0025383928c2fmr678602pjb.6.1684520229207; Fri, 19 May
 2023 11:17:09 -0700 (PDT)
Date:   Fri, 19 May 2023 11:17:07 -0700
In-Reply-To: <20230404122652.275005-3-aleksandr.mikhalitsyn@canonical.com>
Mime-Version: 1.0
References: <20230404122652.275005-1-aleksandr.mikhalitsyn@canonical.com> <20230404122652.275005-3-aleksandr.mikhalitsyn@canonical.com>
Message-ID: <ZGe9I+S78pQ/RPs7@google.com>
Subject: Re: [PATCH 2/2] KVM: SVM: add some info prints to SEV init
From:   Sean Christopherson <seanjc@google.com>
To:     Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc:     pbonzini@redhat.com,
        "=?iso-8859-1?Q?St=E9phane?= Graber" <stgraber@ubuntu.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 04, 2023, Alexander Miqqqqkhalitsyn wrote:
> Let's add a few pr_info's to sev_hardware_setup to make SEV/SEV-ES
> enabling a little bit handier for users. Right now it's too hard
> to guess why SEV/SEV-ES are failing to enable.

Hmm, I'm somewhat torn, but I'm against taking this patch, at least not in its
current form.  I appreciated that determining why KVM isn't enabling SEV/SEV-ES
is annoying, but there's very little actionable information provided here that
isn't also super obvious.  I also don't want to start us down a slippery slope
of printing out messages every time KVM doesn't enable a feature.

If someone tries to enable SEV and doesn't check that their CPU supports SEV,
then IMO that's on them.  Ditto for SEV-ES.

The NPT thing is mildly interesting, but practically speaking I don't expect that
to ever be a hindrace for generic enabling.  Ditto for MMIO caching.

The decode assists check is (a) completely unactionable for the vast, vast majority
of users and (b) is a WARN_ON_ONCE() condition.

The ASID stuff is by far the most interesting, but that's also quite interesting
for when SEV and SEV-ES _are_ fully supported.

So if we want to provide the user more info, I'd prefer to do something like the
below, which I think would be more helpful and would avoid my slippery slope
concerns.

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c25aeb550cd9..eb4c6e3812d9 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2216,7 +2216,6 @@ void __init sev_hardware_setup(void)
        if (misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count))
                goto out;
 
-       pr_info("SEV supported: %u ASIDs\n", sev_asid_count);
        sev_supported = true;
 
        /* SEV-ES support requested? */
@@ -2243,11 +2242,16 @@ void __init sev_hardware_setup(void)
        sev_es_asid_count = min_sev_asid - 1;
        if (misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count))
                goto out;
-
-       pr_info("SEV-ES supported: %u ASIDs\n", sev_es_asid_count);
        sev_es_supported = true;
 
 out:
+       if (boot_cpu_has(X86_FEATURE_SEV))
+               pr_info("SEV %s (ASIDs %u - %u)\n",
+                       sev_supported ? "enabled" : "disabled", ...);
+       if (boot_cpu_has(X86_FEATURE_SEV_ES))
+               pr_info("SEV-ES %s (ASIDs %u - %u)\n",
+                       sev_es_supported ? "enabled" : "disabled", ...);
+
        sev_enabled = sev_supported;
        sev_es_enabled = sev_es_supported;
 #endif
