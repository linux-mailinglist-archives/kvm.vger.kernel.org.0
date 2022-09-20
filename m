Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95C6B5BEB77
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 18:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiITQ5d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 12:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiITQ5c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 12:57:32 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56135A8A6
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 09:57:31 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id w2so2146634qtv.9
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 09:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Zg891itN3F8aiUMK5HG8uHdAXpmkgv5tHBiD8t3x3HA=;
        b=AFqgNuWx1y3BmQSQCa7Av8IrSJ+XaA5XIEgmAyzIXECbxKuQ5buCbtk6JkFtKKI/hM
         fu+lxxm9k+lhCFCOqh1ytZh74CQI1p4oSCwqefc1uKBBpYAq09jD1cU1s7Tle2AwZymE
         cjLDub7nPqzsxYTl/on0+giio5QwUwA+Nl7dirZcrkQu9/c5fee2OMTSf/rzSitwafmW
         pMdDSVPtNAAAEXAiJWORYoDCsC0c2Ps013vJGD4Fe74vvxG4R7nmWpByQdBdWiJH/DWc
         MHyPkUsEMFiTQ1ZobVJwT/xa/lAWwdHAY/TtK0G5b5cMjvf6YIcu/2xrwUThZ+EULpKo
         9L2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Zg891itN3F8aiUMK5HG8uHdAXpmkgv5tHBiD8t3x3HA=;
        b=u3s4hr88ZXU4x5T4tT87XYmZbghSRdRSMsj6FzUexudhdUQ5O3f+LNbviL7cBpwx/R
         99dNub3D9Dd5wiiR9Q5Jv2XFGw7+wH/QfuYbGaNOXDYwebLUfrFrs6PndT5G809RoBcq
         9QGtSJUbksQjXCF3ErCDBEiFzijLSORTs79TCMjzJyscov5O71eBEJyFS1qLpMH5E6DT
         IT7Kp9rE/PTIb5qP62sWcpq9t72x9DOYBYk68xNGeFeaUsZXH2jVM1XrjAqtc6KHPuJq
         ENBVuqjg91CUekzQidEC6cuxyu7Mhn0Q7pSMXRgAcIuIDWdeoX2oo4V0pB+RI3Ofpmkb
         2Mug==
X-Gm-Message-State: ACrzQf2sjgsX7RNHLcQvTPoyhH+AgwUTXpa4XQni008Wy0vKZesbk72C
        yUyRwFj4+02pgGRnrz+CG7SPIdl4BiOwu1kXiT80BQ==
X-Google-Smtp-Source: AMsMyM4be5+ElTL/GaU0ZMBjwZNn5DNBuK8hRm3og2lGQjBvWgENU3h0rqDi5TAplSxKhJvPskK0M/1k1nhv+CImhiI=
X-Received: by 2002:ac8:4e43:0:b0:35c:fa87:d41b with SMTP id
 e3-20020ac84e43000000b0035cfa87d41bmr2798866qtw.137.1663693050960; Tue, 20
 Sep 2022 09:57:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220826231227.4096391-1-dmatlack@google.com> <20220826231227.4096391-2-dmatlack@google.com>
 <2433d3dba221ade6f3f42941692f9439429e0b6b.camel@intel.com> <CALzav=cgqJV+k5wAymUXFaTK5Q1h6UFSVSKjZZ30akq-q0FNOg@mail.gmail.com>
In-Reply-To: <CALzav=cgqJV+k5wAymUXFaTK5Q1h6UFSVSKjZZ30akq-q0FNOg@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 20 Sep 2022 09:57:05 -0700
Message-ID: <CALzav=cuwyFTn6zz+fJqjKNs6XYx2-N61sgMQ9K5C-Z=a4STZg@mail.gmail.com>
Subject: Re: [PATCH v2 01/10] KVM: x86/mmu: Change tdp_mmu to a read-only parameter
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Thu, Sep 1, 2022 at 9:47 AM David Matlack <dmatlack@google.com> wrote:
> On Tue, Aug 30, 2022 at 3:12 AM Huang, Kai <kai.huang@intel.com> wrote:
> > On Fri, 2022-08-26 at 16:12 -0700, David Matlack wrote:
[...]
> > > +#else
> > > +/* TDP MMU is not supported on 32-bit KVM. */
> > > +const bool tdp_mmu_enabled;
> > > +#endif
> > > +
> >
> > I am not sure by using 'const bool' the compile will always omit the function
> > call?  I did some experiment on my 64-bit system and it seems if we don't use
> > any -O option then the generated code still does function call.
> >
> > How about just (if it works):
> >
> >         #define tdp_mmu_enabled false
>
> I can give it a try. By the way, I wonder if the existing code
> compiles without -O. The existing code relies on a static inline
> function returning false on 32-bit KVM, which doesn't seem like it
> would be any easier for the compiler to optimize out than a const
> bool. But who knows.

Actually, how did you compile without -O and is that a supported use-case?

I tried both CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE (-O2) and
CONFIG_CC_OPTIMIZE_FOR_SIZE (-Os) and did not encounter any issues
building 32-bit KVM with this series.
