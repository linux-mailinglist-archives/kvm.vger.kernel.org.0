Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E363B6D8AD9
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 01:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbjDEXCV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 19:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbjDEXCU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 19:02:20 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB593A8E
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 16:02:19 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id w5-20020a253005000000b00aedd4305ff2so37317284ybw.13
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 16:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680735739;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JxfEYGbVCV4S/fXyU/I/AKeA2AhPszyxn2UCdA7MdyI=;
        b=kJom4Xc3dW/pOEksokI87l3vSZpHUKbe6D8zsZid0YKYRsu1mzs3UYveZCuJtmivns
         RBkKhv6q6KtTbpohc2qa0POFZkLqEfXyXfDRxk2SbUtuCAUBGUvoatI/Q1pwNX4BbJik
         mWaL3IXDxDJx11G0GLRQX6RySNVgErXhW+NfZyjJCFeU73MJDKxlc884npiGGqHl7pDU
         uvKalB8oBiK+lbflFSdc0AwHG4L030VpXc4Wqbm8P7els+WgFRWjhC08hMT+AxmstItS
         /fjmlrVWE/oUaq9pfZODCXdI3b8oJLNTkBy8nDxY1k04F1aBjdBBJEn2AJu5TK6chCDJ
         TKxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680735739;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JxfEYGbVCV4S/fXyU/I/AKeA2AhPszyxn2UCdA7MdyI=;
        b=wjTkPfjgSym5e0j42QyhHN3MRJ9SrnmpfyE9WZRGs4LUyHQjeNWd3rOPjXXc60YBjE
         gbqf6aodcbaGsUWiRK5MlQGrNg+UWqev3jDFfDpzrl15S6g5GhPF3Lmf+gnHQUWzrJZJ
         LN+r/pIIinMKAm0QGfXSaPOkppxHnPKMc7WX2om1pxOjTnvGS1hAjzkwUir8U4T2ALTF
         eObJq4bIQXVx9h45f2Qq4JkLFsjcgW0QD/NzrlrFyKw7LrBLK1fcrcdXDLslCU4mi4me
         SaRSojA+j8b+dpsEGibUmLmXrbOJLkPE8/EQaWrr7biOqKqKIs/YYjMEXwtP9nLroIgO
         5zng==
X-Gm-Message-State: AAQBX9dyDVX3YKWEePv65rzFjZYzw+FDlawIEK/xxHpowZJ19iLRVYgm
        i7q6fw7wYxnURUpowPevwcTYSCF+OXw=
X-Google-Smtp-Source: AKy350aWUEb7JHDnHY1LsJhriUj+J370BiKmhc2gnHlvfmHVb/GdtmVfgKuUtXhCNZVAENhzHygCkryMW+4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:df57:0:b0:b68:7b14:186b with SMTP id
 w84-20020a25df57000000b00b687b14186bmr647716ybg.1.1680735739032; Wed, 05 Apr
 2023 16:02:19 -0700 (PDT)
Date:   Wed,  5 Apr 2023 16:00:56 -0700
In-Reply-To: <20230107011737.577244-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230107011737.577244-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <168073539441.619300.7176599093576537028.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH 0/3] x86: Add testcases for x2APIC MSRs
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
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

On Sat, 07 Jan 2023 01:17:34 +0000, Sean Christopherson wrote:
> Add tests to verify that RDMSR and WRMSR to x2APIC MSRs behave according
> to Intel's architecture, e.g. that writes to read-only MSRs and reads to
> write-only MSRs #GP, accesses to non-existent MSRs #GP, etc...
> 
> Many of the testcases fail without the associated KVM fixes:
> https://lore.kernel.org/all/20230107011025.565472-1-seanjc@google.com
> 
> [...]

Applied to kvm-x86 next, thanks!

[1/3] x86/msr: Skip built-in testcases if user provides custom MSR+value to test
      https://github.com/kvm-x86/kvm-unit-tests/commit/7fb714f76d70
[2/3] x86/apic: Refactor x2APIC reg helper to provide exact semantics
      https://github.com/kvm-x86/kvm-unit-tests/commit/14432cc362f1
[3/3] x86/msr: Add testcases for x2APIC MSRs
      https://github.com/kvm-x86/kvm-unit-tests/commit/a192b5c85e75

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next
