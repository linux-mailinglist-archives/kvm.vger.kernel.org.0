Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8CB607E3B
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 20:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbiJUSW3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 14:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiJUSW1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 14:22:27 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D58253BE0
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 11:22:26 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id y4so3095810plb.2
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 11:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wck+muLAxLDCxfIP+3i9zIUWykRb/pohhRWDh4LFtKA=;
        b=LPA0o3fKU9iwxQt3YTae3C7bsOPZhr/phA7P4mhC5gpgwXFHminLRHhU77qercRKgR
         1tsPEaRIrC5X4AHSYFHu+MPHcdjlbm3TFdAKdN8b1J6IsH0c0lHNU0U4TcWIaVq/F03X
         HLvoAQsY5kLFHT3F5Ij8quGmwAuyBdUgBYdUIEhS8LIUXkTKlMdYInulR6a+S8unNcw6
         lbeNXoaP29cUmu9kKj2zJPC1DrBNAl2xfR97fQ6cJ969APLa0ZHI/SmLRQ4yArWntWok
         ZtyZlluW8VTKVdPgG3IbRZ1/NLWUIJmAqj469nauofac9H42RgkLo/yizcemozK02vha
         8DwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wck+muLAxLDCxfIP+3i9zIUWykRb/pohhRWDh4LFtKA=;
        b=VTBYNkx/qW433v35K/IYVn0iUG7a3hQmxx4xwYc1zZeaE1tDn1E8ELBhXyPyUrseeb
         GZE7NZ8bwrzqa78wAwyTmNJ9BXnX30Zha09bF6Re/rnt0mdRi3Qlfs6PH8RBr3GyCiWQ
         7nAFUjS22iynHynoX2FYqmX1zra7LUvuOaO+9My0wA4WJbOIWaLjSddAOKT8/R8UizKP
         gm+gtdO4emXRcK/10bFuaGggq6/LX9w0TzF67KpUfQF80h8mEk1pAZaAs2L8KS65PGmH
         x3Hl4UPE6qFTdP125jexP35o1GW+Np/E+fzaJM0JEkusQmfItQ5u8BRMX00eEtZWriXM
         RELQ==
X-Gm-Message-State: ACrzQf16GYANpUImsMr+9VNtriwqs63q6jNdA+/pbTrwI8barLg842o3
        0C8DbrA+1Op8WbinXre3ppFjhQ==
X-Google-Smtp-Source: AMsMyM4LZY+3iUsv1i4u6JzQXRc1fGTWW+gyzSVix4Z9SqUaS1ond8f97+NkSfpPP/dXyeYaE/aZqw==
X-Received: by 2002:a17:902:ce08:b0:179:ed2b:8cd8 with SMTP id k8-20020a170902ce0800b00179ed2b8cd8mr20629755plg.23.1666376546379;
        Fri, 21 Oct 2022 11:22:26 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f7-20020a170902684700b0017a04542a45sm2524651pln.159.2022.10.21.11.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 11:22:25 -0700 (PDT)
Date:   Fri, 21 Oct 2022 18:22:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 12/13] x86/pmu: Add assignment
 framework for Intel-specific HW resources
Message-ID: <Y1LjXfnCpf4k5uf8@google.com>
References: <20220819110939.78013-1-likexu@tencent.com>
 <20220819110939.78013-13-likexu@tencent.com>
 <Yz4IwVKje90pcIUN@google.com>
 <8aeb4890-269b-1bd5-abe6-974e79858390@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8aeb4890-269b-1bd5-abe6-974e79858390@gmail.com>
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

On Fri, Oct 21, 2022, Like Xu wrote:
> On 6/10/2022 6:44 am, Sean Christopherson wrote:
> > On Fri, Aug 19, 2022, Like Xu wrote:
> > > @@ -142,12 +148,22 @@ static void global_disable(pmu_counter_t *cnt)
> > >   			~(1ull << cnt->idx));
> > >   }
> > > +static inline uint32_t get_gp_counter_msr(unsigned int i)
> > 
> > Rather than helpers, what about macros?  The problem with "get" is that it sounds
> > like the helper is actually reading the counter/MSR.  E.g. see MSR_IA32_MCx_CTL()
> > 
> > Something like this?
> > 
> >    MSR_PERF_GP_CTRx()
> 
> The base address msr is different for intel and amd (including K7), and
> using different macros in the same location sounds like it would require a
> helper.

I wasn't thinking different macros, I was thinking a macro that consumes the
gp_counter_base.

But actually, there's no need to use a macro, it's really just the naming
convention that I think we should use.  It obviously violates the preferred style,
but in this case I think the deviation is a net postive.

static inline uint32_t MSR_PERF_GP_CTRx(unsigned int i)
{
	return gp_counter_base + i;
}
