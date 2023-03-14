Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8325D6B97C4
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 15:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbjCNOWA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 10:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbjCNOVu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 10:21:50 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4721C9FE7C
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 07:21:23 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id p79-20020a25d852000000b00b32573a21a3so12158220ybg.18
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 07:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678803680;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CrebXHEEgV7/ZJf2x/Xp30WnKkVEGpg7BO+CpYifs0g=;
        b=Z/YVECleBD8nGbAu6SbQEnuXn/2AxTRkJonR6ApIuqQMYzsOeXeqUkljoMDp4wXcpk
         jaMs84GSa9o6Uj294RXJbldvhnWuxvmqV5edPGzSl52I1I0TMAt1Qb+yk1LOBBSXB/9M
         gJLiruVOV7MP+nF39xiZbE7JAE1MsfO67Fi6spn5xdX1mvqiVD58qMWK/bRY6R2lIhRP
         GlTfeYdNj7GlvRo0t8tGVCdGU0ukNdtyvTpFJ9RM7S4jnzUR6M8gVcQelXFwS/qm17T+
         H4IZVht6hpP1OXwhAWsf/CPgTSquMsDfWHASomSBCN6rClsdArc1EUexzGeE1BhyFiFD
         yRmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678803680;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CrebXHEEgV7/ZJf2x/Xp30WnKkVEGpg7BO+CpYifs0g=;
        b=qBBKDFPg9fH6UlYMNARgaYOnqn4ok2EM8lcqDU+6DT8NA1OXfK0yS4fC5C8jUoJHQR
         c5A41hrgn/pb/TQlouuwZtufy18nsoJUVkqF9mSymh8a6VaiT39+3onxztEtAcZyD6Q3
         KwJByG8LuDYwoSLUwBoxcHNe48jCBYz9IONoIMQ6vH+831V83lYNfJM397GILwMlqKKf
         Ypi1aJN2J0FUH42zdBpZPZ4U4Nsp8VKiDNf0CrA0Jm937ZRwZsgx3DyzWCn5z1cRbxig
         coReWT/Rf+q2aYFwTKzsViB8QxrWhP75Zxc7L0Txu+o7pe02R9xlTf6yRvSaIIfrAh7l
         kT5A==
X-Gm-Message-State: AO0yUKXj1r+dzKRLh6evp3D4Gr65XTWiLJR1PDJ8jqdKR6lIRjdnFg1H
        vYk3371BX80GYvuEsUnDX4TYYLwhmKg=
X-Google-Smtp-Source: AK7set8oHKmKT07W1Kf4d/Rl3lQEj+pgJjL8+mi6rKN48pnX5gmJ0qtlpw+W/6zLuxICTN7DMLib+V5gTlQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1024:b0:b4a:3896:bc17 with SMTP id
 x4-20020a056902102400b00b4a3896bc17mr155132ybt.0.1678803680269; Tue, 14 Mar
 2023 07:21:20 -0700 (PDT)
Date:   Tue, 14 Mar 2023 07:21:18 -0700
In-Reply-To: <ZBCeH5JB14Gl3wOM@jiechen-ubuntu-dev>
Mime-Version: 1.0
References: <20230312180048.1778187-1-jason.cj.chen@intel.com>
 <ZA9QZcADubkx/3Ev@google.com> <ZBCeH5JB14Gl3wOM@jiechen-ubuntu-dev>
Message-ID: <ZBCC3qEPHGWnx2JO@google.com>
Subject: Re: [RFC PATCH part-1 0/5] pKVM on Intel Platform Introduction
From:   Sean Christopherson <seanjc@google.com>
To:     Jason Chen CJ <jason.cj.chen@intel.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 14, 2023, Jason Chen CJ wrote:
> On Mon, Mar 13, 2023 at 09:33:41AM -0700, Sean Christopherson wrote:
> 
> > On Mon, Mar 13, 2023, Jason Chen CJ wrote:
> > > There are similar use cases on x86 platforms requesting protected
> > > environment which is isolated from host OS for confidential computing.
> > 
> > What exactly are those use cases?  The more details you can provide, the better.
> > E.g. restricting the isolated VMs to 64-bit mode a la TDX would likely simplify
> > the pKVM implementation.
> 
> Thanks Sean for your comments, I am very appreciated!
> 
> We are expected 

Who is "we"?  Unless Intel is making a rather large pivot, I doubt Intel is the
end customer of pKVM-on-x86.  If you aren't at liberty to say due NDA/confidentiality,
then please work with whoever you need to in order to get permission to fully
disclose the use case.  Because realistically, without knowing exactly what is
in scope and why, this is going nowhere.  

> to run protected VM with general OS and may with pass-thru secure devices support.

Why?  What is the actual use case?

> May I know your suggestion of "utilize SEAM" is to follow TDX SPEC then
> work out a SW-TDX solution, or just do some leverage from SEAM code?

Throw away TDX and let KVM run its own code in SEAM.
