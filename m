Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC0ED7D196D
	for <lists+kvm@lfdr.de>; Sat, 21 Oct 2023 00:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbjJTW6o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 18:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbjJTW6n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 18:58:43 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C466D7C
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 15:58:32 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d99ec34829aso1634599276.1
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 15:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697842711; x=1698447511; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nV7hUiXwTHfWM008m9tGJ1YLn/BzCMBzf+rjk0AGTB0=;
        b=qR9abIwpBYqeCJa+5pUkw3oT4J+WVdXGTIhNJLjANGmOSEvuNKiTXeDEIGEeEQw9u+
         BkAkETn5320gYhgmgXmse6GwZbQz5kidYKUB6iG5kHinHtYt+Biq09qRbd2BndnrHVcU
         lvXc9B3eL0rmfVlFwYVLe8eI+WtbozDtV/kBt9iqZ6ixErvPysc0+2n3FTCvrbTpVuTm
         PMcmhVuf8Nm2CZ+kz1Uk7ewYSJYgdYjojzkFzlEI3TMMwfc/V5+Jmv0APWmuC/M9jZ5q
         s0P14fBL5U0p4fWnvE71WtC+Q0QrIlRUV6Pvtb/hrpP5FDUwgdXXNTEuMT99WGRfz748
         /MEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697842711; x=1698447511;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nV7hUiXwTHfWM008m9tGJ1YLn/BzCMBzf+rjk0AGTB0=;
        b=rH8glwrPjeMrlJTN/II5vOsbAddAaT8g4DR6oKFcJ0u0cCwUYsO7GuzNRsA0SmbAnE
         e/kcTMqgOtoUD6/6A1MFiIb69XxO12nAIUiJ0u/gX4VmoCbcP4OFafgmmUL76jsM3+SV
         PtaSJLtBX7PMXckOGeMpLMrh9r2ItyY0Lyy+ucEwGXRYWSbg46TUV87WQ4NRgXVp1E1V
         YtUbzDPT4TuWCxhxMf4oKBuqmOUXUgLNqmtddktCbt1YF8fDvsKKmxXQwO7W7LGvxN/M
         Y3MsMAA3gYzbyAvs9XmjWhYai3C8xY5E74HV/BEBi8YhSCrZVUEEuRZCCEhrYtwwpK2+
         bVyg==
X-Gm-Message-State: AOJu0Yw7z35lnKGXv4X5IYvceHknmm0l23ZUiAU6vdcWWCbKDeFXgHMU
        +fVxNMK4NrWQjrlxEB9YYLAQdERA4iU=
X-Google-Smtp-Source: AGHT+IEAaQ9vGQXrDQ7YTSPaOgbWm4DgSvaj703/FKyK96m8YdUpJyMR/+YqbEiDiU0UsL/ZLPV3DFG2q3E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:938c:0:b0:d9a:37cf:c22b with SMTP id
 a12-20020a25938c000000b00d9a37cfc22bmr69932ybm.1.1697842711533; Fri, 20 Oct
 2023 15:58:31 -0700 (PDT)
Date:   Fri, 20 Oct 2023 15:56:29 -0700
In-Reply-To: <20231002040839.2630027-1-mizhang@google.com>
Mime-Version: 1.0
References: <20231002040839.2630027-1-mizhang@google.com>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <169766419668.1911126.2774635531681023250.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: x86: Service NMI requests after PMI requests in
 VM-Enter path
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mingwei Zhang <mizhang@google.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Like Xu <likexu@tencent.com>, Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 02 Oct 2023 04:08:39 +0000, Mingwei Zhang wrote:
> Service NMI requests after PMI requests in vcpu_enter_guest() so that KVM
> does not need to cancel and redo the VM-Enter. Because APIC emulation
> "injects" NMIs via KVM_REQ_NMI, handling PMI requests after NMI requests
> means KVM won't detect the pending NMI request until the final check for
> outstanding requests. Detecting requests at the final stage is costly as
> KVM has already loaded guest state, potentially queued events for
> injection, disabled IRQs, dropped SRCU, etc., most of which needs to be
> unwound.
> 
> [...]

Applied to kvm-x86 pmu, thanks!

I made a tweak to the code and massaged one part of the changelog.  For the
code, I hoisted PMU/PMI above SMI too, mainly to keep SMI+NMI together, but
also because *technically* the guest could configure LVTPC to send an SMI (LOL).

Regarding the changelog, I replaced the justification about correctness with
this:

    Note that changing the order of request processing doesn't change the end
    result, as KVM's final check for outstanding requests prevents entering
    the guest until all requests are serviced.  I.e. KVM will ultimately
    coalesce events (or not) regardless of the ordering.
    
The architectural behavior of NMIs and KVM's unintuitive simultaneous NMI
handling simply doesn't matter as far as this patch is concerned, especially
when considering the SMI technicality.  E.g. the net effect would be the same
even if KVM allowed only a single NMIs.

Please holler if you disagree with either/both of the above changes.

[1/1] KVM: x86: Service NMI requests after PMI requests in VM-Enter path
      https://github.com/kvm-x86/linux/commit/4b09cc132a59

--
https://github.com/kvm-x86/linux/tree/next
