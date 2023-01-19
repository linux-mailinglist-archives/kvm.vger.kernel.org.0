Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEDD6743B4
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 21:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbjASUvg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 15:51:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjASUvC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 15:51:02 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0E92E0C7
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:51:01 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id i9-20020a17090a64c900b002297ffd390fso1437493pjm.0
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:51:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XsNKOZkXicuUiWtCUwXDxRNTwl8e+lP+GlMNu/Zjg6M=;
        b=JF8NAJSFnN55aB49k7/Uv/peGr/u7pSGRAMLm4JpTT83MaFh90yvAduttmZCb6BwHK
         t75bfnPw7ZPhC6ASYCKjOWRQ57+FbZtWIF2D801w/Tw1Wvv4fMdA7cCcz4kNwiu4mTMs
         2HNcfs4P7uP5DgdmSE2yE9v3IE45bVlHqKcEdIFADNd9GYzp3JjRTDUnuij/uHgfTd41
         Gzc7X8fsplVxQmdZxq+nCRZedaGXAaK/SQCAlU50jMepBJtGuNlRfaI78x92soGJLQsg
         Bg5U9I4f/vbZJ7CkoMUc9+Oef9zVN3/w3O/FycYVMRSWmMHAKFz7io7Zxubv9cO0ATvb
         7U9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XsNKOZkXicuUiWtCUwXDxRNTwl8e+lP+GlMNu/Zjg6M=;
        b=KNUz5c60DbKqVM2zPKCwpAuMi8b/AMLvAF9YGMU+B5VvCCn2QgQUCKyHiQ+ed5l2eX
         ZvfMxCzRlIoOSrbF5ZCw5S3PKojVpg1iTjxpvXi2v84wGlW6l0K5kjU+FXh9xGM182xm
         a5GJk11DzL+BtQHLtkw/wIm0qbttVPf43ft2xi7gwKuoAVJ88q1xrzqgXOWMp55cKXrd
         4BZZskQptRcjcngFOQVPi2S/IeCags6PAr7VRBPnKRHeJCNIHYbc52MfsbVTx94VJgaP
         1jLjzPyfMtZsgWBuf1kwGhCbAE6RdWEc7bOUPvlmQ2N5rsu6fZg586E7pEE5CTz2ZMso
         Ke6A==
X-Gm-Message-State: AFqh2krY0Fd0yWoZb4dvr5N+Ft6MHB+ixVqVLnCx0qaPzcXhkWGiuRIf
        pKZDECvsTY9D+LMsV3q6TfN66MtWyC8=
X-Google-Smtp-Source: AMrXdXt00r6KEjTmHH+Xwy4v/JD/mxOBK32bvnMYN1yS2pn4RGD9SGTHp9Qit1Etf++FfDA6vUdtwX9BXvk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ab94:b0:194:6417:cd27 with SMTP id
 f20-20020a170902ab9400b001946417cd27mr1100464plr.34.1674161461022; Thu, 19
 Jan 2023 12:51:01 -0800 (PST)
Date:   Thu, 19 Jan 2023 20:48:52 +0000
In-Reply-To: <20230118195905.gonna.693-kees@kernel.org>
Mime-Version: 1.0
References: <20230118195905.gonna.693-kees@kernel.org>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <167409066308.2374724.17477861672467900544.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: x86: Replace 0-length arrays with flexible arrays
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Kees Cook <keescook@chromium.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 18 Jan 2023 11:59:09 -0800, Kees Cook wrote:
> Zero-length arrays are deprecated[1]. Replace struct kvm_nested_state's
> "data" union 0-length arrays with flexible arrays. (How are the
> sizes of these arrays verified?) Detected with GCC 13, using
> -fstrict-flex-arrays=3:
> 
> arch/x86/kvm/svm/nested.c: In function 'svm_get_nested_state':
> arch/x86/kvm/svm/nested.c:1536:17: error: array subscript 0 is outside array bounds of 'struct kvm_svm_nested_state_data[0]' [-Werror=array-bounds=]
>  1536 |                 &user_kvm_nested_state->data.svm[0];
>       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from include/uapi/linux/kvm.h:15,
>                  from include/linux/kvm_host.h:40,
>                  from arch/x86/kvm/svm/nested.c:18:
> arch/x86/include/uapi/asm/kvm.h:511:50: note: while referencing 'svm'
>   511 |                 struct kvm_svm_nested_state_data svm[0];
>       |                                                  ^~~
> 
> [...]

Applied to kvm-x86 misc, thanks!  Based on the linux-next complaint, I assume
you (temporarily?) applied this to your tree as well.  Holler if I've confused
you :-)

[1/1] KVM: x86: Replace 0-length arrays with flexible arrays
      https://github.com/kvm-x86/linux/commit/2a8c2de0544e

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
