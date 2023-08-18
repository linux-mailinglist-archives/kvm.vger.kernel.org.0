Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54C03780292
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 02:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351238AbjHRALU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 20:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356772AbjHRALT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 20:11:19 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8133AB6
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 17:10:56 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-589cc9f7506so4406697b3.2
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 17:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692317447; x=1692922247;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oyapjbDI9Y2xcGuEE3bsShb0ut9gM8qaZ4OyzlK0nfQ=;
        b=pm57qfR503UwOTOW86AsUmhpMR0vUk/Az1lcs8zsVy8J7AbcVyl51tv8B1lnsWvHy2
         8BZ7EMkmyazfgC4oPSMhtyl5wghvAOJz60qF8SOWgm++2JZzwTq0zrLx0uvhpQsFax3B
         vGIKn+sKZec0XOddIuiSzHe1R9IkQMXXGICAlBultYxZMk72x0ftjfoQFv4w+m6f7/kM
         FLCP2Zy14hBQ2QLzjq34/magRoBdV7haHWZuJigJxhoxSacSO5LrxPo4ghHw1V+VXlq5
         UiHxc0VnPbDpDcqSn7Fp51XQTEcdiO5N3nZPXxKIkY42txYNhg97eUnE+EbS72cZFwVA
         xj2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692317447; x=1692922247;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oyapjbDI9Y2xcGuEE3bsShb0ut9gM8qaZ4OyzlK0nfQ=;
        b=U9xBFMVOeiqd32f84I6emVKOOUnAA7qYdeZ5IL85Er98mLGf1WFFZX1Tt9SrDcokvu
         cvgODPX32ivw3Vvuj7OieQ4a2fvdgc76ExhaWWRjYQ9FgQksyA5lH368x+R1h/RBjXDu
         K5bCU4Wv306+JGFlbuQ1ade6GFj6RwKBFBIyf2GLvHgiyaHh/Dttx8+ESbDklOxLUIQt
         FbRAOIjg7Rn8S42y4KeBtcfrb7Qb3pgKu/+03OgiD4DZ4RBg2pJJ4CNFqfFHZRSzPIf7
         6xorGpjvotKviKxEvY/am0GVHEfqP2rLijSwvQGtkw+P1miI9fXnAC1gNBpjciEt+jfB
         qC6g==
X-Gm-Message-State: AOJu0YzynDVlLthApt05O3knpgkEhwQbLybYdeROvtPT+iLRLuAVX0la
        6ZAjSGzIY2xNdJo46suQOaEQks4xwls=
X-Google-Smtp-Source: AGHT+IF2K0HByTDqyxoAtNi3GKaEK1a+torqvRYfb2RcCLxRqUDddKGNT4/z5MKmnYArvwNj1pqm0rfzxwo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:168a:b0:c4e:1c21:e642 with SMTP id
 bx10-20020a056902168a00b00c4e1c21e642mr17453ybb.3.1692317447814; Thu, 17 Aug
 2023 17:10:47 -0700 (PDT)
Date:   Thu, 17 Aug 2023 17:09:24 -0700
In-Reply-To: <20230815203653.519297-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230815203653.519297-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <169229954681.1259376.195379194594068800.b4-ty@google.com>
Subject: Re: [PATCH v3 00/15] KVM: x86: Add "governed" X86_FEATURE framework
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zeng Guang <guang.zeng@intel.com>,
        Yuan Yao <yuan.yao@intel.com>
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

On Tue, 15 Aug 2023 13:36:38 -0700, Sean Christopherson wrote:
> Third and hopefully final version of the framework to manage and cache
> KVM-governed features, i.e. CPUID based features that require explicit
> KVM enabling and/or need to be queried semi-frequently by KVM.
> 
> This version is just the governed features patches, as I kept the TSC
> scaling patches in kvm-x86/misc but blasted away the goverend features
> with a forced push.
> 
> [...]

Applied to kvm-x86 misc, with a blurb added to the nVMX changelog to explain
how "nested" is factored in.

[01/15] KVM: x86: Add a framework for enabling KVM-governed x86 features
        https://github.com/kvm-x86/linux/commit/42764413d195
[02/15] KVM: x86/mmu: Use KVM-governed feature framework to track "GBPAGES enabled"
        https://github.com/kvm-x86/linux/commit/ccf31d6e6cc5
[03/15] KVM: VMX: Recompute "XSAVES enabled" only after CPUID update
        https://github.com/kvm-x86/linux/commit/1143c0b85c07
[04/15] KVM: VMX: Check KVM CPU caps, not just VMX MSR support, for XSAVE enabling
        https://github.com/kvm-x86/linux/commit/0497d2ac9b26
[05/15] KVM: VMX: Rename XSAVES control to follow KVM's preferred "ENABLE_XYZ"
        https://github.com/kvm-x86/linux/commit/662f6815786e
[06/15] KVM: x86: Use KVM-governed feature framework to track "XSAVES enabled"
        https://github.com/kvm-x86/linux/commit/fe60e8f65f79
[07/15] KVM: nVMX: Use KVM-governed feature framework to track "nested VMX enabled"
        https://github.com/kvm-x86/linux/commit/1c18efdaa314
[08/15] KVM: nSVM: Use KVM-governed feature framework to track "NRIPS enabled"
        https://github.com/kvm-x86/linux/commit/7a6a6a3bf5d8
[09/15] KVM: nSVM: Use KVM-governed feature framework to track "TSC scaling enabled"
        https://github.com/kvm-x86/linux/commit/4365a45571c7
[10/15] KVM: nSVM: Use KVM-governed feature framework to track "vVM{SAVE,LOAD} enabled"
        https://github.com/kvm-x86/linux/commit/4d2a1560ffc2
[11/15] KVM: nSVM: Use KVM-governed feature framework to track "LBRv enabled"
        https://github.com/kvm-x86/linux/commit/e183d17ac362
[12/15] KVM: nSVM: Use KVM-governed feature framework to track "Pause Filter enabled"
        https://github.com/kvm-x86/linux/commit/59d67fc1f0db
[13/15] KVM: nSVM: Use KVM-governed feature framework to track "vGIF enabled"
        https://github.com/kvm-x86/linux/commit/b89456aee78d
[14/15] KVM: nSVM: Use KVM-governed feature framework to track "vNMI enabled"
        https://github.com/kvm-x86/linux/commit/ee785c870d6f
[15/15] KVM: x86: Disallow guest CPUID lookups when IRQs are disabled
        https://github.com/kvm-x86/linux/commit/9717efbe5ba3

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
