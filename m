Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A775B5741
	for <lists+kvm@lfdr.de>; Mon, 12 Sep 2022 11:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiILJhG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 05:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiILJhF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 05:37:05 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9EAB3336D
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 02:37:03 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id q62-20020a17090a17c400b00202a3497516so5264203pja.1
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 02:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=r0Jqf0b2ze0i2sJD/MFozANH+9lzPJ4MNqut+fAakn4=;
        b=dg/ZXPkiNBHtMUxAY4rMoJnJWo86vXaHFQRNN9WKl/aKIQ/AKAazUqE6FBlb4SJCkf
         TDU2sOriLDQTKKMkB8zg/W6thXrFoNUOPN6XWsdbC8ID0yk8vDEbxiJFGX+3tkeeTh6J
         wv1q1VqOpf9TfejqeGbQOLyEm857lxLgXRfOVHQZbGnM4IYeWGMLKFLS2c64k+1E0KYO
         JpGMYECvDtsVjyvdApW/ZonHr/b0m3RQ8Ca0+uni0mRZmShW7cuGhAfXAUSYLQ02G9Hb
         xZQ83sAOeGBuzF7gwHCwrsBd11T8YN9EJNGli3263Op+Ix/nJtyu69gM8q+kHSOgo7u7
         yeaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=r0Jqf0b2ze0i2sJD/MFozANH+9lzPJ4MNqut+fAakn4=;
        b=r6asl3tMyspgs2tpqI9GdirXOYKqnj40i5/oIPh66KUHNaqXai81SF1jkZBxijzh5N
         DNjOTJ3UiW1562MVWjvB4Veztff/n8rLbMHKzIifCW3BkUp6YDTnuxpwMy/wmyis96ME
         bgTGiDwRYU3I+1FVDeldB4dmwAPKkT6BKhjnTCIpe1muNLKkgM8sOlWk4PfKywMS1OmV
         AHejnpRGsthWVZCJ2cSxo1ibRYK5OCEZ5Gq0bI/oXLbeLB7nvBlDDN1yGhIz0anaw6FO
         5eNhx0hSZJFGjfYxG8O8UdcpT+DyiHlch0OxBsZKNVi4RwB1F2/XYDGv1UuKy4xzA5lG
         A/sQ==
X-Gm-Message-State: ACgBeo07isETsOSKrzWbCB3yYw8u3wREbLOrcPrcIx6XNd2OV8qfh2wS
        YtZLJ3hEehvEIDrMi5piYBrlsA==
X-Google-Smtp-Source: AA6agR4VNTBZMJ84bGEX6gNS8FSFjFu7/mwCUz97Tdh6ba1M1DJawhtV7GYcBeq58N89uaPukF72qw==
X-Received: by 2002:a17:90b:1c82:b0:1ee:eb41:b141 with SMTP id oo2-20020a17090b1c8200b001eeeb41b141mr23427481pjb.143.1662975423267;
        Mon, 12 Sep 2022 02:37:03 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u127-20020a626085000000b0053e80618a23sm4958694pfb.34.2022.09.12.02.37.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 02:37:02 -0700 (PDT)
Date:   Mon, 12 Sep 2022 09:36:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH kernel] KVM: SVM: Fix function name in comment
Message-ID: <Yx79ugW49M3FT/Zp@google.com>
References: <20220912075219.70379-1-aik@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912075219.70379-1-aik@amd.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 12, 2022, Alexey Kardashevskiy wrote:
> A recent renaming patch missed 1 spot, fix it.
> 
> This should cause no behavioural change.
> 
> Fixes: 23e5092b6e2a ("KVM: SVM: Rename hook implementations to conform to kvm_x86_ops' names")
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 28064060413a..3b99a690b60d 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3015,7 +3015,7 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
>  	/*
>  	 * As an SEV-ES guest, hardware will restore the host state on VMEXIT,
>  	 * of which one step is to perform a VMLOAD.  KVM performs the
> -	 * corresponding VMSAVE in svm_prepare_guest_switch for both
> +	 * corresponding VMSAVE in svm_prepare_switch_to_guest for both
>  	 * traditional and SEV-ES guests.
>  	 */

Rather than match the rename, what about tweaking the wording to not tie the comment
to the function name, e.g. "VMSAVE in common SVM code".

Even better, This would be a good opportunity to reword this comment to make it more
clear why SEV-ES needs a hook, and to absorb the somewhat useless comments below.

Would something like this be accurate?  Please modify and/or add details as necessary.

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 3b99a690b60d..c50c6851aedb 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3013,19 +3013,14 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
 void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
 {
        /*
-        * As an SEV-ES guest, hardware will restore the host state on VMEXIT,
-        * of which one step is to perform a VMLOAD.  KVM performs the
-        * corresponding VMSAVE in svm_prepare_switch_to_guest for both
-        * traditional and SEV-ES guests.
+        * Manually save host state that is automatically loaded by hardware on
+        * VM-Exit from SEV-ES guests, but that is not saved by VMSAVE (which is
+        * performed by common SVM code).  Hardware unconditionally restores
+        * host state, and so KVM skips manually restoring this state in common
+        * code.
         */
-
-       /* XCR0 is restored on VMEXIT, save the current host value */
        hostsa->xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
-
-       /* PKRU is restored on VMEXIT, save the current host value */
        hostsa->pkru = read_pkru();
-
-       /* MSR_IA32_XSS is restored on VMEXIT, save the currnet host value */
        hostsa->xss = host_xss;
 }
 

