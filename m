Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79CCD63F534
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 17:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbiLAQZ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 11:25:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbiLAQZ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 11:25:26 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F107991350
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 08:25:25 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id p24so2132711plw.1
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 08:25:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DJn63ijABqaX2jSzYldLgtMX1wvMD+wjMrL7ejU3DM4=;
        b=jmk3F/NJq35iV/doRjj3egs6c6k+X6EGEse4MdJIqMjLPyBNbo1AKFivgdvn9isEsu
         b2/fdEveK6CbqH6tF4SjKHNbD8g317v8VOBJ10LrTh8t8eG/36wa+kzxD+shOG6q69+h
         61DU5kG4G81dhs7bHAQo1DboGFu1f9j9UT8cI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DJn63ijABqaX2jSzYldLgtMX1wvMD+wjMrL7ejU3DM4=;
        b=TkxvZsG2mEUfTkHs/SUr+uQPetRGMDPHjiHTwzVdFtPQiplWBFQwCGvVlLWv8fNlcN
         4Rr4Ets/e/NhI8Svd32IwdVae6kmanW9KD8y6gyKD9IZBMzwoLqnnYzYxjJ9V7djBK6T
         BY9c7N2B4UMqS+0dRLvF2Rc07qFAZY+r7jxyRCDWkBBCQTZaLsqxvEI7fbW8MBSLeEbu
         gpZtt/Az7vuHewhldsHMksLVwrqajivxoItO3d/BDc8GNq0L2TSJMWPiKsQs81AOVDIX
         ZTV2U2bYwCOFp3YSq6tvKnDLlVgGRAjjDpC+ysKaYJCxXlPUcRTvda30fhgrlyonLMFz
         PVfA==
X-Gm-Message-State: ANoB5pn1vJ8tsscTE2mUfNCA6ZvJk3L3fcrJhw+gNi/tI1QqS/KlAmKv
        23Q40mv4XWpRsCc3itY5OHI62mYjsFWbkw==
X-Google-Smtp-Source: AA0mqf6q8cTCMSgXJrxqU+XiXGZ8uzcS2jxNQPGNqjyAVZeXMbJ7HfoBSvKaPcW1v/1bLGUCkYWc0g==
X-Received: by 2002:a17:902:db10:b0:189:5858:43c0 with SMTP id m16-20020a170902db1000b00189585843c0mr38387356plx.71.1669911925434;
        Thu, 01 Dec 2022 08:25:25 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id i22-20020a635416000000b00460ea630c1bsm2749336pgb.46.2022.12.01.08.25.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 08:25:24 -0800 (PST)
From:   coverity-bot <keescook@chromium.org>
X-Google-Original-From: coverity-bot <keescook+coverity-bot@chromium.org>
Date:   Thu, 1 Dec 2022 08:25:24 -0800
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-next@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Coverity: handle_vmclear(): Error handling issues
Message-ID: <202212010825.C23022D@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello!

This is an experimental semi-automated report about issues detected by
Coverity from a scan of next-20221201 as part of the linux-next scan project:
https://scan.coverity.com/projects/linux-next-weekly-scan

You're getting this email because you were associated with the identified
lines of code (noted below) that were touched by commits:

  Fri Dec 14 17:59:46 2018 +0100
    55d2375e58a6 ("KVM: nVMX: Move nested code to dedicated files")

Coverity reported the following:

*** CID 1527765:  Error handling issues  (CHECKED_RETURN)
arch/x86/kvm/vmx/nested.c:5269 in handle_vmclear()
5263     	 */
5264     	if (likely(!guest_cpuid_has_evmcs(vcpu) ||
5265     		   !evmptr_is_valid(nested_get_evmptr(vcpu)))) {
5266     		if (vmptr == vmx->nested.current_vmptr)
5267     			nested_release_vmcs12(vcpu);
5268
vvv     CID 1527765:  Error handling issues  (CHECKED_RETURN)
vvv     Calling "kvm_vcpu_write_guest" without checking return value (as is done elsewhere 7 out of 8 times).
5269     		kvm_vcpu_write_guest(vcpu,
5270     				     vmptr + offsetof(struct vmcs12,
5271     						      launch_state),
5272     				     &zero, sizeof(zero));
5273     	} else if (vmx->nested.hv_evmcs && vmptr == vmx->nested.hv_evmcs_vmptr) {
5274     		nested_release_evmcs(vcpu);

If this is a false positive, please let us know so we can mark it as
such, or teach the Coverity rules to be smarter. If not, please make
sure fixes get into linux-next. :) For patches fixing this, please
include these lines (but double-check the "Fixes" first):

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1527765 ("Error handling issues")
Fixes: 55d2375e58a6 ("KVM: nVMX: Move nested code to dedicated files")

Thanks for your attention!

-- 
Coverity-bot
