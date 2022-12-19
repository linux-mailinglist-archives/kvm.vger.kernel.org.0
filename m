Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD77651481
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 21:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbiLSU5E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 15:57:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232470AbiLSU4x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 15:56:53 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0351D6551
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 12:56:53 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id d15so10235537pls.6
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 12:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AP0DPgy6juzYjbnmoSK4DSIse02YvBVHuic1zb1crI0=;
        b=n2Cb9GinsIjyEaT+YGxcLDI2zefP9STnyh6mk+easKE+YmRAE9neZPO5KKQ0un7hzA
         1WfQoF2Qy0Oo6ffwsDhxOVc59fCZU/OEXw2pDj+gQV0719Bol/qBcaBjr/N/1fCixHbV
         ii3Mixw1qykkBdRq56vPuUoU5eSuiWj0Y/li7hPZ1nkZn0PUrxr1Ssco3G6XWTYk0jUX
         q4f7k/NwuXW5lT7SorZpgTcJN3pVISAhO39PNgwLfXd7DlNY8/GHIY8XYdFgsXUjmFu0
         W9mV9ZnGjHaq6eAnzo7i3kzYthj9wRa40zLu/snuft72nTrG+Y3Azx55N1JgbakviMQY
         s+6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AP0DPgy6juzYjbnmoSK4DSIse02YvBVHuic1zb1crI0=;
        b=kgpH5FNC+KkWCfiBK60jYyoAj8uH3fbS9HGBXOQMIq2po8gA75FOe5wLcGLa9ALDkJ
         c0OaFhC3hf2s2+8lGznLNuztMybKlTVA5B/eu5narsf8IyXOTzmaszoEOgG+Gj/7DrMZ
         /53BaeSFB121TMoIwaF+7Vge4EEo2z8u1vfmV62h0ZH6XdIC2Dfnoagr6JMcpc4l2fIq
         9+h/tfZ7bL73td8tqt4DiiCRFd22YCKExWIm+VcAeKnp1BPnxTDUi1QcersyBH3E0wLR
         hRjBQF3eUeooOn/YblP4BBc0aahCHSWu3gmKxyXKG2WVZ6JTBufGekMR/PsnEqGcPdyT
         lzlw==
X-Gm-Message-State: AFqh2kp7VL0e3bqDe18wPOs0F96CPMz5HFrDWVxggHcFo9QEkz9yaD7t
        YLvGJ5aO29bF3haMXNxCSTlnfw==
X-Google-Smtp-Source: AMrXdXuYwK2oZVtQXVR6Uo4lZSOvVHJU5q2NtoAiJA4PqmRch5RIgzCrcaxiZPZosP5g1PcjUUJE1g==
X-Received: by 2002:a17:902:e5cd:b0:189:b910:c6d2 with SMTP id u13-20020a170902e5cd00b00189b910c6d2mr1353085plf.1.1671483412369;
        Mon, 19 Dec 2022 12:56:52 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id q18-20020a17090311d200b00188f07c9eedsm7601657plh.176.2022.12.19.12.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 12:56:51 -0800 (PST)
Date:   Mon, 19 Dec 2022 20:56:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     coverity-bot <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-next@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: Coverity: handle_vmclear(): Error handling issues
Message-ID: <Y6DQEFYmjLTXvw/g@google.com>
References: <202212010825.C23022D@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202212010825.C23022D@keescook>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 01, 2022, coverity-bot wrote:
> Hello!
> 
> This is an experimental semi-automated report about issues detected by
> Coverity from a scan of next-20221201 as part of the linux-next scan project:
> https://scan.coverity.com/projects/linux-next-weekly-scan
> 
> You're getting this email because you were associated with the identified
> lines of code (noted below) that were touched by commits:
> 
>   Fri Dec 14 17:59:46 2018 +0100
>     55d2375e58a6 ("KVM: nVMX: Move nested code to dedicated files")
> 
> Coverity reported the following:
> 
> *** CID 1527765:  Error handling issues  (CHECKED_RETURN)
> arch/x86/kvm/vmx/nested.c:5269 in handle_vmclear()
> 5263     	 */
> 5264     	if (likely(!guest_cpuid_has_evmcs(vcpu) ||
> 5265     		   !evmptr_is_valid(nested_get_evmptr(vcpu)))) {
> 5266     		if (vmptr == vmx->nested.current_vmptr)
> 5267     			nested_release_vmcs12(vcpu);
> 5268
> vvv     CID 1527765:  Error handling issues  (CHECKED_RETURN)
> vvv     Calling "kvm_vcpu_write_guest" without checking return value (as is done elsewhere 7 out of 8 times).
> 5269     		kvm_vcpu_write_guest(vcpu,
> 5270     				     vmptr + offsetof(struct vmcs12,
> 5271     						      launch_state),
> 5272     				     &zero, sizeof(zero));
> 5273     	} else if (vmx->nested.hv_evmcs && vmptr == vmx->nested.hv_evmcs_vmptr) {
> 5274     		nested_release_evmcs(vcpu);
> 
> If this is a false positive, please let us know so we can mark it as
> such, or teach the Coverity rules to be smarter. If not, please make
> sure fixes get into linux-next. :) For patches fixing this, please
> include these lines (but double-check the "Fixes" first):
> 
> Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
> Addresses-Coverity-ID: 1527765 ("Error handling issues")
> Fixes: 55d2375e58a6 ("KVM: nVMX: Move nested code to dedicated files")

Nit on the bot, if it's going to provide a Fixes without human verification, then
it should probably try to bisect (which I realize could get quite nasty).  Both
this VMCLEAR issue and the SMM issue report bogus Fixes due to code movement.  If
the blamed commit on this won't hadn't been so obviously wrong I likely would have
copy+pasted without ever verifying.

Maybe just omit the Fixes entirely and rely on the above "touched by commits" to
provide the developer with the hint?
