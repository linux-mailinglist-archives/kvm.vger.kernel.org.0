Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1635A179E
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 19:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241701AbiHYREF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 13:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240821AbiHYREB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 13:04:01 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA597B7753
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 10:03:58 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d12so350183plr.6
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 10:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=wtCfQVk2hYCo/4eE2g12ZC1mwyOqJt01e7eHWQ9hAis=;
        b=Fy3+5Mj3vjR0pCTpQMmjzMmJuN4iZQa0pTJVCfpRFmSA+qdUpk0lWiSkH9CHOLfmpv
         VVXdp6X7D89f/PBNwGVcCVYKqpzBsF7j14+aOmBt/3tSkWLarMUy+epZG2ncXMWTXzmY
         LA8qVVPHiCBFd4lk/ymeK+jpu/UTIcfTXnuFQNss6puZjvPfesOXpJPZ37g/oFqFhvJD
         iWWCRzaFgpFLKK9CHUH5Stl0zIQzeW/ArSFy4RHxNjtcFHtIGAvLTOPrzPQga98iKpui
         n+0niHRDtkT2iDMTjhHky6xdBR3flTBJnIeo1XJdjf68MswgO3TxRhZnm/o6jL39BsPk
         ep5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=wtCfQVk2hYCo/4eE2g12ZC1mwyOqJt01e7eHWQ9hAis=;
        b=q9NAixzvFmhKqzd+jTPJmxK0WxzaMpCpVWFbLY9AD2YgAYFGrh9ULoirTDjzFrmFBm
         QYRTP7ww5uCYOvmYcix6YGwe9GhM/Pk3aQIHOqB5XXLcbLtXKpfeJi6MOodKC9eKIyG8
         xqJIWxGtrqzcSAboFvNXWfelaglkUrNePEdocDdpeuNG7hHd3hpgtW+nsHR4QO2TkJbI
         76RcPnTuxOZW2athAR+MaaDEMZq0l2uvYzJTpdCUOOhHjVY047074Vno6IHMcaj2DXyq
         oI28luLig/IsowyOPVHvmu4FN2FHZy4V3C/nPQd62u41i/TN3unplWWbdpaIBpzIeRBo
         joLQ==
X-Gm-Message-State: ACgBeo0JpJOKSWZMjGSvQLOqxzbsaMZtwPlh65MsBjkyjZD+x93WWjE1
        QfoGeRFAxGCw85C0UjiTGufBzLZmWCgyfw==
X-Google-Smtp-Source: AA6agR612y0OOZu/ohzPzfoak4TDFJI4ZaXeFvuCAcm/MAJIp7LJKrmaoQKMs2tQQmvL3xXTW3LucQ==
X-Received: by 2002:a17:90a:5d8a:b0:1f7:3c7a:9cc7 with SMTP id t10-20020a17090a5d8a00b001f73c7a9cc7mr32928pji.207.1661447037664;
        Thu, 25 Aug 2022 10:03:57 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y190-20020a6232c7000000b005368fcfb7f8sm9492863pfy.89.2022.08.25.10.03.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 10:03:57 -0700 (PDT)
Date:   Thu, 25 Aug 2022 17:03:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH] x86/emulator: Test POP-SS blocking
Message-ID: <YwereSW3UPhDNsnh@google.com>
References: <20220821215900.1419215-1-mhal@rbox.co>
 <20220821220647.1420411-1-mhal@rbox.co>
 <9b853239-a3df-f124-e793-44cbadfbbd8f@rbox.co>
 <YwOj6tzvIoG34/sF@google.com>
 <6d19f78f-120a-936b-3eba-e949ecc3509f@rbox.co>
 <YwZu1K5Rgb1sevsy@google.com>
 <69d74e6a-dd6b-28bb-8011-e204d4ab0253@rbox.co>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69d74e6a-dd6b-28bb-8011-e204d4ab0253@rbox.co>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 24, 2022, Michal Luczaj wrote:
> On 8/24/22 20:32, Sean Christopherson wrote:
> > Eh, let's completely skip usermode for code #DBs and not tweak __run_single_step_db_test().
> > It's easier to just have a standalone function.
> 
> Something like this?
> 
> static void test_pop_ss_code_db(bool fep_available)
> {
> 	write_ss(KERNEL_DS);
> 
> 	write_dr7(DR7_FIXED_1 |
> 		  DR7_ENABLE_DRx(0) |
> 		  DR7_EXECUTE_DRx(0) |
> 		  DR7_LEN_1_DRx(0));
> 
> #define POPSS_DB(desc, fep1, fep2)				\
> ({								\
> 	unsigned int r;						\
> 								\
> 	n = 0;							\
> 	asm volatile(/* jump to 32-bit code segment */		\
> 		     "ljmp *1f\n\t"				\
> 		     "1:\n\t"					\
> 		     "	.long 2f\n\t"				\
> 		     "	.word " xstr(KERNEL_CS32) "\n\t"	\
> 		     /* exercise POP SS blocking */		\
> 		     ".code32\n\t"				\
> 		     "2: lea 3f, %0\n\t"			\
> 		     "mov %0, %%dr0\n\t"			\
> 		     "push %%ss\n\t"				\
> 		     fep1 "pop %%ss\n\t"			\
> 		     fep2 "3: xor %0, %0\n\t"			\
> 		     /* back to long mode */			\
> 		     "ljmp %[cs64], $4f\n\t"			\
> 		     ".code64\n\t"				\

Ooh, I see what you meant by temporarily switching to 32-bit mode.  I was thinking
we could just make the POP SS testcase 32-bit only, but I didn't realize this test
is 64-bit only.  Argh, and so is emulate.c.  And now I get why you added a brand
new test.

Let's just add a new test.  The above can work, but it relies on the code and
stack being mapped with a 32-bit address, e.g. will break if KUT is ever changed
to not map everything low in the virtual address space.

I think it makes sense to rename emulator.c => emulator64.c, and then start a new
emulator.c for tests that apply to both 32-bit and 64-bit KUT.

I'll send a small series, the behavior is also different for AMD CPUs (I coded up
99% of this yesterday before realizing this morning that debug.c is 64-bit only).
