Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E65F160FC72
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 17:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236068AbiJ0Py5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 11:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235003AbiJ0Pyz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 11:54:55 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8073D89909
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 08:54:54 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id 4so1983487pli.0
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 08:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=s5sI8szusFJEbfSYRrAdqVoTFSpw2g4RWHDE0/gEBAY=;
        b=SCReENR146A0K22z9LTlu85JRbq0ZITXUxHuw6xcUvmhYAAH9ykUkjgnuzHlFM/rab
         WUuBFyebbtIGKutWig/k/Yd60+c7eE7njfRoz3u4j3+hwYqYn2kEgatQrKDZKM0P5Is/
         8hkZxoI/mbCWNIBsRaGxtDo+xIFdy7oux5OK6TXNOGh+KLYubL3eUx4892gCx6jVZ7q+
         AKlXkJbiGH9UWJcFTCCnVWfXX9+rZNxU1fJgl4+otOSoCXQ38oW9WFfRFvi8qvfx8IkZ
         goiHzZaeLaVCn1LQGTh3q1tpemnJ5WpPA9pJ+ThZ2uLRq5534rlgPxH/Fxsxu/z+9vVd
         Yziw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s5sI8szusFJEbfSYRrAdqVoTFSpw2g4RWHDE0/gEBAY=;
        b=YXtTe79J6QK7vp5nzUgFzvJKUu67TPepWD21uO4Y512Ctik8IpWQ6wB+or0+9Lmfa8
         yYoq0u5+ibDo7J7t7ww1fQc9RAs7oDjQiCHevUxhsp7Vhd/2E8wBg3S9DSmuVlO1lNRx
         eDGx3hFwTqP3d+rIvtA7ma0j9wYACpR9kn+pJ1DPgVwg4ik7m7riz4d1XhMVCrJmkFwW
         uslpkC/3h3buP6tZIcmP95TsMyXZxkNcPdwaPUlWDU7fA/CPilfaL+8iDeQF/gbtNP0U
         qLMj7UhdDExkZimWuffIrbBRip9uxfCOpHTc0Uw/K5j/uclQ9LDz1PJFxz4pZCU8s3MB
         D3Pw==
X-Gm-Message-State: ACrzQf1uqhX09l2/AAijRx0DVOnjgSU4z9kMWiwwaL7ZFP/CPr3KG+sg
        NbgWEIel2J3PS/8+sJZodmAOOA==
X-Google-Smtp-Source: AMsMyM7ltmEOibg+mvFXb/NhpI5e7KBunDxNOgVJ4HxvwRp/4zJ0gCF35OlZ1bqSH259pSccquSiwA==
X-Received: by 2002:a17:903:230b:b0:186:6041:51bf with SMTP id d11-20020a170903230b00b00186604151bfmr38771719plh.24.1666886093731;
        Thu, 27 Oct 2022 08:54:53 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a12-20020aa78e8c000000b0056bd1bf4243sm1341357pfr.53.2022.10.27.08.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 08:54:53 -0700 (PDT)
Date:   Thu, 27 Oct 2022 15:54:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 02/16] x86: add few helper functions for
 apic local timer
Message-ID: <Y1qpyXWqvQLBeTta@google.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
 <20221020152404.283980-3-mlevitsk@redhat.com>
 <Y1GeEoC7qMz40QDc@google.com>
 <de3d97ff23cc401e916b15b47207b45514446e4d.camel@redhat.com>
 <Y1a49abli07rqyww@google.com>
 <b006eda72356d75b5ee308c3a91bf3359bb6e9ab.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b006eda72356d75b5ee308c3a91bf3359bb6e9ab.camel@redhat.com>
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

On Thu, Oct 27, 2022, Maxim Levitsky wrote:
> On Mon, 2022-10-24 at 16:10 +0000, Sean Christopherson wrote:
> > On Mon, Oct 24, 2022, Maxim Levitsky wrote:
> > > On Thu, 2022-10-20 at 19:14 +0000, Sean Christopherson wrote:
> > > > On Thu, Oct 20, 2022, Maxim Levitsky wrote:
> > > > > +       // ensure that a pending timer is serviced
> > > > > +       irq_enable();
> > > > 
> > > > Jumping back to the "nop" patch, I'm reinforcing my vote to add sti_nop().  I
> > > > actually starting typing a response to say this is broken before remembering that
> > > > a nop got added to irq_enable().
> > > 
> > > OK, although, for someone that doesn't know about the interrupt shadow (I
> > > guess most of the people that will look at this code), the above won't
> > > confuse them, in fact sti_nop() might confuse someone who doesn't know about
> > > why this nop is needed.
> > 
> > The difference is that sti_nop() might leave unfamiliar readers asking "why", but
> > it won't actively mislead them.  And the "why" can be easily answered by a comment
> > above sti_nop() to describe its purpose.  A "see also safe_halt()" with a comment
> > there would be extra helpful, as "safe halt" is the main reason the STI shadow is
> > even a thing.
> > 
> > On the other hand, shoving a NOP into irq_enable() is pretty much guaranteed to
> > cause problems for readers that do know about STI shadows since there's nothing
> > in the name "irq_enable" that suggests that the helper also intentionally eats the
> > interrupt shadow, and especically because the kernel's local_irq_enable() distills
> > down to a bare STI.
> 
> I still don't agree with you on this at all. I would like to hear what other
> KVM developers think about it.

Why not just kill off irq_enable() and irq_disable() and use sti() and cli()?
Then we don't have to come to any agreement on whether or not shoving a NOP into
irq_enable() is a good idea.

> safe_halt actually is a example for function that abstacts away the nop -
> just what I want to do.

The difference is that "safe halt" is established terminology that specifically
means "STI immediately followed by HLT".
