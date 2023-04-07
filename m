Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69EC96DA760
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 04:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239968AbjDGCFk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 22:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239902AbjDGCF0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 22:05:26 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40412CA16
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 19:03:49 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-536a4eba107so411746997b3.19
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 19:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680832966;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5mOOOVBrjOwv+MoGScqpEYd/dhRK//ZQEGPgsMvwqTs=;
        b=Kio7zqvX7S+swJCgWmjdI/IsfPEc8W5Bnfh/imYBEGG6i1W2TPbthhqMMFef6wO/PT
         9vTV0tfLUY4I/W6O0S1jVcri/wpTc70gnrEAosuMxCSrztHEVeg6iT2BDFlMhu+smjxx
         wanu2JffZw15fKB+IFTLNMhflLsUfYBquh9Z4qqQSdNszAlctzjOj2RgjdTpsutOYnGp
         bl2fPGy9r99zEJ68qi99oaDzHJ5G/S5lx7RpJ/mceki9RkySnsqAT/LOJaoLyhPNPlpK
         d0giczle5gT6qHNVCbdMkLwXXmxx9EQaKgV3MER7ee5YkVzxz7IutPsMHtJEUCbjuO2Y
         Rtrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680832966;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5mOOOVBrjOwv+MoGScqpEYd/dhRK//ZQEGPgsMvwqTs=;
        b=bUt1UNn83DtvUwRiIkavOs2GJsyM5JVMoSaqELw9TbIMR4VLDTZ9X4m1Ha2T982VbA
         qyODQRGGADEiJBMVbaXRiwagB6vVKx6tzD06EiiuziX6numOfOZI2UGZLh4qFQb0YjIZ
         hlbvmndhrSfmAUSDRRqODZju6bn671jZll0L53suaTvfSquEbah9C3Vkss36TnltIwj1
         owKnGe0d29+kCDFfWfS23sWv8SG1OrljjlTg7bM1YbHr1yEUJJromPnNz+zBXf756Y3M
         qZkIi22hqTcJ62Mels0se0gs1i22OLfV/T2b7gkwr8s6hfnZckyOUpBoaiyCDFoi2FQU
         j7uA==
X-Gm-Message-State: AAQBX9erzt0QpCwj+jJtXOONVMOtbkh/B5NbF8m94tY8+6eC/HEkTIRg
        g+f5rsMhS7tEqMcYSifH66CNHK4L0a8=
X-Google-Smtp-Source: AKy350aUJjslw1dyf3vcyHW6NPZ98mVWrtVdox2Ky48x8keLB62A6obvm/wVbgyDWYKrv85ubzVJNNnffXE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b64a:0:b0:544:cd0e:2f80 with SMTP id
 h10-20020a81b64a000000b00544cd0e2f80mr184079ywk.8.1680832965871; Thu, 06 Apr
 2023 19:02:45 -0700 (PDT)
Date:   Thu,  6 Apr 2023 19:02:27 -0700
In-Reply-To: <20230214050757.9623-1-likexu@tencent.com>
Mime-Version: 1.0
References: <20230214050757.9623-1-likexu@tencent.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <168083228231.867070.5028004042976729728.b4-ty@google.com>
Subject: Re: [PATCH v4 00/12] KVM: x86: Add AMD Guest PerfMonV2 PMU support
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 Feb 2023 13:07:45 +0800, Like Xu wrote:
> Starting with Zen4, core PMU on AMD platforms such as Genoa and
> Ryzen-7000 will support PerfMonV2, and it is also compatible with
> legacy PERFCTR_CORE behavior and msr addresses.
> 
> If you don't have access to the hardware specification, the commits
> d6d0c7f681fd..7685665c390d for host perf can also bring a quick
> overview. Its main change is the addition of three msr's equivalent
> to Intel V2, namely global_ctrl, global_status, global_status_clear.
> 
> [...]

Applied 1-3 to kvm-x86 pmu.  Note, I grabbed my full version of patch 2 that
also converts the "get" path.

My apologies for not reviewing this earlier in the cycle.  I need to pivot to
TDX+SNP stuff "soon", so AMD v2 support will likely miss 6.4, but I'll prioritize
reviewing and merging support in 6.5.

Thanks!

[01/12] KVM: x86/pmu: Rename pmc_is_enabled() to pmc_is_globally_enabled()
        https://github.com/kvm-x86/linux/commit/cdd2fbf6360e
[02/12] KVM: VMX: Refactor intel_pmu_{g,}set_msr() to align with other helpers
        https://github.com/kvm-x86/linux/commit/8bca8c5ce40b
[03/12] KVM: x86/pmu: Rewrite reprogram_counters() to improve performance
        https://github.com/kvm-x86/linux/commit/649bccd7fac9

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
