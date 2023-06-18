Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFA0C734542
	for <lists+kvm@lfdr.de>; Sun, 18 Jun 2023 09:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjFRH6G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 18 Jun 2023 03:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjFRH6F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 18 Jun 2023 03:58:05 -0400
Received: from elvis.franken.de (elvis.franken.de [193.175.24.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 70D22E5B;
        Sun, 18 Jun 2023 00:57:54 -0700 (PDT)
Received: from uucp by elvis.franken.de with local-rmail (Exim 3.36 #1)
        id 1qAnIA-0001Qe-00; Sun, 18 Jun 2023 09:57:46 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id C0858C02FD; Sun, 18 Jun 2023 09:55:54 +0200 (CEST)
Date:   Sun, 18 Jun 2023 09:55:54 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Huacai Chen <chenhuacai@kernel.org>
Cc:     Yu Zhao <yuzhao@google.com>, aleksandar.qemu.devel@gmail.com,
        jiaxun.yang@flygoat.com, kvm@vger.kernel.org,
        linux-mips@vger.kernel.org, pbonzini@redhat.com,
        robh+dt@kernel.org, zhangfx@lemote.com
Subject: Re: [PATCH 5/5] MAINTAINERS: Update KVM/MIPS maintainers
Message-ID: <20230618075554.GA2858@alpha.franken.de>
References: <1596005919-29365-5-git-send-email-chenhc@lemote.com>
 <20230616071831.1452507-1-yuzhao@google.com>
 <20230616082322.GA7323@alpha.franken.de>
 <CAAhV-H54aipF6jXAiGpcjzpDy06Q28hmx-p4msvxgASHU5Z+cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAhV-H54aipF6jXAiGpcjzpDy06Q28hmx-p4msvxgASHU5Z+cw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR,T_SPF_TEMPERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 16, 2023 at 04:31:13PM +0800, Huacai Chen wrote:
> On Fri, Jun 16, 2023 at 4:23 PM Thomas Bogendoerfer
> <tsbogend@alpha.franken.de> wrote:
> >
> > index 957121a495f0..04cedf9f8811 100644
> > --- a/arch/mips/include/asm/kvm_host.h
> > +++ b/arch/mips/include/asm/kvm_host.h
> > @@ -317,7 +317,7 @@ struct kvm_vcpu_arch {
> >         unsigned int aux_inuse;
> >
> >         /* COP0 State */
> > -       struct mips_coproc *cop0;
> > +       struct mips_coproc cop0;
> Maybe keeping it as a pointer and allocate in kvm_arch_vcpu_create()
> is better? (smaller modification)

I thought about it, but then we have another dynmic object, which we
need to care about lifetime. And I don't think we need *cop any longer,
so this cleanes up the code and makes it even slightly faster.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
