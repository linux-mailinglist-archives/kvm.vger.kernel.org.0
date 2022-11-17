Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B559B62E3A3
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 18:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235068AbiKQR6l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 12:58:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234542AbiKQR6j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 12:58:39 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B50BD4;
        Thu, 17 Nov 2022 09:58:38 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id r18so2611265pgr.12;
        Thu, 17 Nov 2022 09:58:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rGXrWx6HFK+Q9BfRPqN7BWzNtrClITl0lfZIJgaN7FE=;
        b=C7ebDYXD3LxUWDBfB1bzgzD3vRA3xGqtCldmSMIL4I2LBr31r8TXCjyIC9JY1KIhev
         O2jKSBnWN8HHMWHIwJSfhR4NlPAek7s5bR+rekos0H+fU7pen1q24YJOV4XV86ed33nr
         Nx3jMdjRyCxPZMHMjmAbYDlXFxkR12a2xkOpUp+eSQA3XEpyQ2cPqYBo1qmBF5vonar0
         nWdkiB23BjL7/s7/EHNXF4w1VtlHs4u2wKlaTzBzCvIqMHm+s2tQLyczFuuQk9opvZyl
         g3zCOVUe4TRGB1xGuFYATkNTMYfwMf07PTRD8bgBUeE4WSwUqeziKENkoTHzvDvrUV/m
         DXZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rGXrWx6HFK+Q9BfRPqN7BWzNtrClITl0lfZIJgaN7FE=;
        b=cmy3xt/H8EMk+pWqVggi82zzGk5VKfaui3e6LeGjyenDKADfcpLSr35dWJGpRWOH+3
         yTc+o0SlYdTiTvH20Q9KXHjJeOHl8QZPB3se/dAUkLAA6YXASsC6Bfhi7zyc+XRWb9Gl
         UiJQf3uFY3TXpwVv3GQjg0RIPOZ4fFLjih1sPOkG4Wmk2nhtog+zPF0P1ErAzwpywJup
         ekBnVWBfBdtbY+KFtOvumvFZDQMwzKuLLR5kzMVqeRNK5W+9cUI4vcwXaETN04+qttGK
         i3QA7kK3zqvUvqY2QjLjn2Kb8+v37Q3HbIf1Vh0VNbBbaZkWdGVBXNGKBRc3Y7nl/YE2
         ZkeA==
X-Gm-Message-State: ANoB5pny/y9LrPfLclxplRG3AkXPhaJI8dku8sn9ixcM0Skgh0EEfNA0
        UQK/2IMduUtU5uMHpJYbyQE=
X-Google-Smtp-Source: AA0mqf4tFQJZXUWWNMcswBXjlc/dbd9XlhWG6hSAejNsgA8SwQCm4v2DGs1ZlGTLViC5hY7WiAEvBg==
X-Received: by 2002:a05:6a00:4c11:b0:56d:93d8:d81a with SMTP id ea17-20020a056a004c1100b0056d93d8d81amr4125579pfb.14.1668707917780;
        Thu, 17 Nov 2022 09:58:37 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id 185-20020a6214c2000000b005618189b0ffsm1437354pfu.104.2022.11.17.09.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 09:58:37 -0800 (PST)
Date:   Thu, 17 Nov 2022 09:58:36 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v10 033/108] KVM: x86/mmu: Allow non-zero value for
 non-present SPTE and removed SPTE
Message-ID: <20221117175836.GI2350331@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <a5be8d9fd5753e17ad2ae4b5fc360501bdf2e84a.1667110240.git.isaku.yamahata@intel.com>
 <2d5e7d04d2e9399b0883a16d8ba3379a57d5b9f5.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2d5e7d04d2e9399b0883a16d8ba3379a57d5b9f5.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 09, 2022 at 11:24:12AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> > diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> > index 2e08b2a45361..0b97a045c5f0 100644
> > --- a/arch/x86/kvm/mmu/spte.c
> > +++ b/arch/x86/kvm/mmu/spte.c
> > @@ -419,7 +419,9 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
> >  	shadow_dirty_mask	= has_ad_bits ? VMX_EPT_DIRTY_BIT : 0ull;
> >  	shadow_nx_mask		= 0ull;
> >  	shadow_x_mask		= VMX_EPT_EXECUTABLE_MASK;
> > -	shadow_present_mask	= has_exec_only ? 0ull : VMX_EPT_READABLE_MASK;
> > +	/* VMX_EPT_SUPPRESS_VE_BIT is needed for W or X violation. */
> > +	shadow_present_mask	=
> > +		(has_exec_only ? 0ull : VMX_EPT_READABLE_MASK) | VMX_EPT_SUPPRESS_VE_BIT;
> 
> I think this chunk can be in a separate patch since it doesn't handle fault from
> non-present to present, which is claimed by the patch title and changelog.
> 
> Or I think you need to describe handling W or X fault part in the changelog.

Ok, let me try to split that hunk.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
