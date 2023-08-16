Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E00B477E370
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 16:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245632AbjHPOUz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 10:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343565AbjHPOU1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 10:20:27 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5D11FE1
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 07:20:25 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-68874269d2cso1952559b3a.2
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 07:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692195625; x=1692800425;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=i1oB5KGOGGLmV8Hyuw5qnVZxUUxc0xqzMrgN+ZeuyH4=;
        b=ZWxhwbj3Flt0bO9lmrGhVUO1z+viu7lhI7DFNndVfioCj9WPrrs6Tufw6Mn7SGYGq1
         4M0GGXiHXdtmAshh8/EEgts4uwl3YmCLx4XdYUMuU3ocYkYU/MxiIvKgdBQ1Mrq7V7He
         P+IUoQ/KVu/PkEylxmDHU0SdZtLrAFZpnn6c8eNNRH5phOpdhpqZVwRBh+Ehri+tOoLY
         rKqYhyJLG0YWOFi9MD+JnUBd0ThjY3cZW7UzRFetJPEm2RltcoJdolGVljIEVxkpO177
         1hbSnmPn5dhUtbExAbJNqHfEGI2IQ1mpv2jaeYlmy806HVaWgQgSgk1yVbf25ABk94vN
         yX7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692195625; x=1692800425;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i1oB5KGOGGLmV8Hyuw5qnVZxUUxc0xqzMrgN+ZeuyH4=;
        b=Rq7nQIXNQD7xxnffRAjiZ5YwMQGimYLy8hP/LLtUnmx//0esFcn0FpM9MzMwmx8AbC
         UZJXqm/+ENc0ljv+H5z8tyxQjgLhZa6zVgBdlneaK1a/H8oxSsiMX6uq/LJev6VcFWxD
         WEFAO6fDikrqyLJTpAx8YYucnAbfhZ4tx/5UeVX/Cpvyj8ftktK5mMEvRNVfnOR6Hh5i
         2/7HL602yM1p1A2IFSw1JolgOPzyJPfuaWRwEX7D2UQIMlA42586BcPSlB5Q2dsNf4PL
         pnU6AJzEuhmRMKGwlHsrtL1J17PcSBn4S1tQ+BCnGJTRCxjf5z4eUchFZin0HeSWKuem
         42Ew==
X-Gm-Message-State: AOJu0YycCVp5nkkDPGAKalt0dZEQEmAHcNHIQ+pdwKd7ThLBc2i9Z+TL
        dcQFC5EZMONRFFWVGGjdPNr4s/HHZfI=
X-Google-Smtp-Source: AGHT+IHOZY+1RtbT+IwGQsfEVWjr8BXEVN7ReSuu487cknuQa9n8HgvNydglPHkYuZK0Jgji8yN7fuLP8qQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:8884:0:b0:686:df16:f887 with SMTP id
 z4-20020aa78884000000b00686df16f887mr949855pfe.6.1692195625320; Wed, 16 Aug
 2023 07:20:25 -0700 (PDT)
Date:   Wed, 16 Aug 2023 07:20:23 -0700
In-Reply-To: <6370c12ff6ec2c22ed5e1f1f37c1cf38a820a342.camel@intel.com>
Mime-Version: 1.0
References: <20230815203653.519297-1-seanjc@google.com> <20230815203653.519297-2-seanjc@google.com>
 <6370c12ff6ec2c22ed5e1f1f37c1cf38a820a342.camel@intel.com>
Message-ID: <ZNzbJ9Y+8Uon327c@google.com>
Subject: Re: [PATCH v3 01/15] KVM: x86: Add a framework for enabling
 KVM-governed x86 features
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Guang Zeng <guang.zeng@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yuan Yao <yuan.yao@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 16, 2023, Kai Huang wrote:
> > diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
> > new file mode 100644
> > index 000000000000..40ce8e6608cd
> > --- /dev/null
> > +++ b/arch/x86/kvm/governed_features.h
> > @@ -0,0 +1,9 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#if !defined(KVM_GOVERNED_FEATURE) || defined(KVM_GOVERNED_X86_FEATURE)
> > +BUILD_BUG()
> > +#endif
> > +
> > +#define KVM_GOVERNED_X86_FEATURE(x) KVM_GOVERNED_FEATURE(X86_FEATURE_##x)
> > +
> > +#undef KVM_GOVERNED_X86_FEATURE
> > +#undef KVM_GOVERNED_FEATURE
> 
> Nit:
> 
> Do you want to move the very last
> 
> 	#undef KVM_GOVERNED_FEATURE
> 
> out of "governed_features.h", but to the place(s) where the macro is defined?
> 
> Yes there will be multiple:
> 
> 	#define KVM_GOVERNED_FEATURE(x)	...
> 	#include "governed_features.h"
> 	#undef KVM_GOVERNED_FEATURE
> 
> But this looks clearer to me.

I agree the symmetry looks better, but doing the #undef in governed_features.h
is much more robust.  E.g. having the #undef in the header makes it all but impossible
to have a bug where we forget to #undef KVM_GOVERNED_FEATURE.  Or worse, have two
bugs where we forget to #undef and then also forget to #define in a later include
and consume the stale #define.

And I also want to follow the pattern used by kvm-x86-ops.h.
