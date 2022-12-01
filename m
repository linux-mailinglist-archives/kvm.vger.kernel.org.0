Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6737063F53A
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 17:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232225AbiLAQZ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 11:25:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232207AbiLAQZx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 11:25:53 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871D7A47F3
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 08:25:52 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id q17-20020a17090aa01100b002194cba32e9so5740355pjp.1
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 08:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7Hs75c2RhI6TXhTdmq3LNKwlHtjDutkhRkFYCtYKKrI=;
        b=Qpi4DGe/ljQZkxVzxzmv+mwMi5BwzACkFN6l31jQTjSBelVBkQ+PVUo3Xz03lrAst2
         zwJpCgGZQhZClhELY3Vy19Ae+NDtrzl+1S/d+CWrtVEgEwZ1vc5pLer3Pn5yNB2w7pA/
         eLesWhq2wJwal07BE5Ij1HetfU6apauIQlfJY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7Hs75c2RhI6TXhTdmq3LNKwlHtjDutkhRkFYCtYKKrI=;
        b=m7Q3C5YTE/LZ02fJh5SGXPGIQ+f/1aI3GQvcC+iPxWEQ4whpwLuzxDgFXlpbCUP/tA
         Q++JoOszAgfVWMcFmrACojqEgbyY6lyB6XIyZkDR+v+jf+BbkpTb6vwDUdBOSebgdcYq
         KAQrtmYBRepcEG9CxfUEwwNIvRS47vvU4A8ZDGHNsnqCg+QGbTgKHnR6mo8DxO1Bcsua
         Jh87RrTsmlgwzjyvhmG9qiMI1UfkadRCt7/uMvfoBSQVz3zOc/bzALthrfkx1nKnXRGT
         VLOp2l6D5HFcSDmgdKCQBMmvXDcSgIH6tEqacEzryAP95uLEZxgM+8RQWcaEL5EEd5GV
         i8tg==
X-Gm-Message-State: ANoB5pnn7ou92IbSFrgrX6vhp5b56JAMUCgJVyb0HfdRhXHlkyoPQglz
        a0XA7229FELM96SVYqHTRnDi3Q==
X-Google-Smtp-Source: AA0mqf5Yoi5gUr2+jfODvzG0lhgp9wysmv7TqcWatFoaSj460wZp7jPXjwuGpbg91q0r7SYRxRSPbg==
X-Received: by 2002:a17:90a:4594:b0:218:f745:76fe with SMTP id v20-20020a17090a459400b00218f74576femr39246937pjg.245.1669911952042;
        Thu, 01 Dec 2022 08:25:52 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q15-20020a17090311cf00b00176b63535adsm3861906plh.260.2022.12.01.08.25.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 08:25:51 -0800 (PST)
From:   coverity-bot <keescook@chromium.org>
X-Google-Original-From: coverity-bot <keescook+coverity-bot@chromium.org>
Date:   Thu, 1 Dec 2022 08:25:50 -0800
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-next@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Coverity: emulator_leave_smm(): Error handling issues
Message-ID: <202212010825.8589611F@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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

  Wed Nov 9 12:31:18 2022 -0500
    1d0da94cdafe ("KVM: x86: do not go through ctxt->ops when emulating rsm")

Coverity reported the following:

*** CID 1527763:  Error handling issues  (CHECKED_RETURN)
arch/x86/kvm/smm.c:631 in emulator_leave_smm()
625     		cr4 = kvm_read_cr4(vcpu);
626     		if (cr4 & X86_CR4_PAE)
627     			kvm_set_cr4(vcpu, cr4 & ~X86_CR4_PAE);
628
629     		/* And finally go back to 32-bit mode.  */
630     		efer = 0;
vvv     CID 1527763:  Error handling issues  (CHECKED_RETURN)
vvv     Calling "kvm_set_msr" without checking return value (as is done elsewhere 5 out of 6 times).
631     		kvm_set_msr(vcpu, MSR_EFER, efer);
632     	}
633     #endif
634
635     	/*
636     	 * Give leave_smm() a chance to make ISA-specific changes to the vCPU

If this is a false positive, please let us know so we can mark it as
such, or teach the Coverity rules to be smarter. If not, please make
sure fixes get into linux-next. :) For patches fixing this, please
include these lines (but double-check the "Fixes" first):

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1527763 ("Error handling issues")
Fixes: 1d0da94cdafe ("KVM: x86: do not go through ctxt->ops when emulating rsm")

Thanks for your attention!

-- 
Coverity-bot
