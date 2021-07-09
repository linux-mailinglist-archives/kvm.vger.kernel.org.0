Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E233C26C9
	for <lists+kvm@lfdr.de>; Fri,  9 Jul 2021 17:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbhGIP2i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jul 2021 11:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbhGIP2i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jul 2021 11:28:38 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE41C0613E5
        for <kvm@vger.kernel.org>; Fri,  9 Jul 2021 08:25:54 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id 17so9034829pfz.4
        for <kvm@vger.kernel.org>; Fri, 09 Jul 2021 08:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4+x/tLj7KO5ZbPTSoUn/UUl7/+Vat4+pnrtWwfsdqjw=;
        b=k3CNi9e5CMnvmIJPbBbFRFxGFvTWWbixUFmQ4AVZRkPNCMXWBNtkw6vDTC3lrocvzb
         3G4zyv5jkXKGgCIkQdp3zjGW+7HU+THxEn6hPW+iBR2A8tN7lGIrshmpzQlIJgUlk1xd
         0NIIzVdU4/6/SmM+bt6LBpaM+yJn/r/McR6+RBWdHFc41kAOprh/GHP+lrj/WW3bIcUP
         lPkE5bKG0mMo8eoocsomQqCl1WEmYDsnNQ4CWl/KHkRWRlf90AmMnDjNIpj7XYUtB7EH
         PlB9r3tKlwvl0bcACqlNPFCoSiEVbBPZ0zUtjY3bxOnLe1MHX7iSJYMoQ+saTYPHN7Kw
         p8Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4+x/tLj7KO5ZbPTSoUn/UUl7/+Vat4+pnrtWwfsdqjw=;
        b=qXUC74jyw7OWvwrQHESpVTO3EwD3jHR0O3KXOcZKp8l5fChcuwdruGu/BSrQVjImM5
         PLEz6zqjrk6S1O8TOOeg2KUZIit6CpiAj4+mHqm5fEW4C0XyRiSveviVFTvfhcCDtpGS
         Oc24a+VvL6M7/x16qmLaLsB2r/92k5NAbYujotpnV4AQBHnE7P/N4dZQKONYHSSD1y9+
         7YCZMUCwfXiuxQVNvw4/pV1AlXi6ksid5Lq0a9GJsYbsmP8YO+bFV3e3MD9b4xP48tEw
         9pvmn/Njy/VMq9cAteoyMtb89lz3e6zq7EgVD29ruD6p1SaI+yOAaFunWQMJN9vAOw6J
         70Qg==
X-Gm-Message-State: AOAM530qbLz+t/z8euXeD197SkZzSV1riJFMIUW1y0nM6OM8dF3hW3lg
        oxmwjvDpaU8t1DrmYvxMX4Tp3g==
X-Google-Smtp-Source: ABdhPJx3Owk3w4ZPADXEQ7bqpMo2RvotaGPMwJuy+2uBaxoVlfJ/qdyGRQGfkJ87+J3FSxdPcvdn5g==
X-Received: by 2002:aa7:8218:0:b029:316:88e:2a3a with SMTP id k24-20020aa782180000b0290316088e2a3amr37883661pfi.16.1625844353933;
        Fri, 09 Jul 2021 08:25:53 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id p3sm13537981pjt.0.2021.07.09.08.25.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 08:25:53 -0700 (PDT)
Date:   Fri, 9 Jul 2021 15:25:49 +0000
From:   David Matlack <dmatlack@google.com>
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v1 4/4] KVM: stats: Add halt polling related histogram
 stats
Message-ID: <YOhqfXMVSaGkJkAe@google.com>
References: <20210706180350.2838127-1-jingzhangos@google.com>
 <20210706180350.2838127-5-jingzhangos@google.com>
 <YOdxLwJx00nQIR87@google.com>
 <CAAdAUti1C0s6b4acDeLHQqbFgswiwuUZNN+mVc4Zeh8_ZTRNzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAdAUti1C0s6b4acDeLHQqbFgswiwuUZNN+mVc4Zeh8_ZTRNzQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 09, 2021 at 10:18:20AM -0500, Jing Zhang wrote:
> On Thu, Jul 8, 2021 at 4:42 PM David Matlack <dmatlack@google.com> wrote:
> >
> > On Tue, Jul 06, 2021 at 06:03:50PM +0000, Jing Zhang wrote:
> > >
> > > diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
> > > index 9f52f282b1aa..4931d03e5799 100644
> > > --- a/arch/powerpc/include/asm/kvm_host.h
> > > +++ b/arch/powerpc/include/asm/kvm_host.h
> > > @@ -103,7 +103,6 @@ struct kvm_vcpu_stat {
> > >       u64 emulated_inst_exits;
> > >       u64 dec_exits;
> > >       u64 ext_intr_exits;
> > > -     u64 halt_wait_ns;
> >
> > The halt_wait_ns refactor should be a separate patch.
> >
> How about putting it into a separate commit? Just want to keep all
> halt related change in the
> same patch series.

I think we're on the same page: move the halt_wait_ns changes to a
separate patch but still part of this series.
