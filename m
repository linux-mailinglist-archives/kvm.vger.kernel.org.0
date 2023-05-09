Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB0386FD069
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 23:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235450AbjEIVA2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 17:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235356AbjEIVAV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 17:00:21 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28AFE61
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 13:59:50 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-6435bbedb4fso6917693b3a.3
        for <kvm@vger.kernel.org>; Tue, 09 May 2023 13:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20221208.gappssmtp.com; s=20221208; t=1683665974; x=1686257974;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dOA7aJvMFPIkPvFgyp6AOgLLNvmw7SXjInRd3Q4PUKk=;
        b=fER7egYWZZVJlKQe61uKSAjjxl4qpXLIRyuiKsUfwAK+LeTe18xU8zSiWYIcGHx1KM
         bl0QctHKOSFvOJ39wV8yANe3Jq9mNy+uhKRxWRggaEpCXiy0j4ZltBexvmMXRTC3KKVF
         jcDSwPmfmUzut/6g94HrsNBGmBrqQeWNA+oFfM9r1VPZ/mscu8UvoXE59o3APiYOQaHG
         r9cf46p/vhrwvD7scWdWeVh8DS9ppwbl/eLscWXTpwiPKvKJmZAf/YMgCnIsmkYN5oON
         /9jEX/mU44QFuAQ2NnK+ZauXyM0+mpohssZZK27GJwOmdwNMwotVoYi/xjU0VVdSIvcE
         4CLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683665974; x=1686257974;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dOA7aJvMFPIkPvFgyp6AOgLLNvmw7SXjInRd3Q4PUKk=;
        b=l30xfBjFsF0RIzbFRju9YzfVhLlc2D4aaArrlE+O/Wbaj9upA1WoIlouMLcLpcZrPc
         4CBnV7lxLNkklMAPWLKPq/Av7F4qKI5mw4IDkBsoWROgUSUG5ipWf8n+OoHYIvs/YVIF
         q7+nBlc/MzeBfbvBZgyki8Dp4Wh121e6mhUliIAHBqewB3nU7p8QcTc+eh+sVyvRiFKK
         nfqLnJcXFJtJyWK/PagFdi0dbwLg43KIAo82JFmSd4jwYW0IoePz0PkrWCKPaeofuKzb
         zIdMzoB392jAJ64Nh+v4twbclWmaYf/DECRBwJGBj6pFMIKNnjo2e0OSDN6cDZk11Eah
         RpAw==
X-Gm-Message-State: AC+VfDwZTGNq2Qc+nANWZfdTjjKJTDr6730uORu1/1rqql5UIDULZ57G
        zyHZb7IpiTfsjXaVXilGA+bBgg==
X-Google-Smtp-Source: ACHHUZ5Sk19YYdZdX1ZH0iYmz2+p2ZcC++WuYNTJtf0d4B1IkG2GfHwfxDHcw+x9GrNCAvqxF7kPDA==
X-Received: by 2002:a05:6a00:1383:b0:63b:599b:a2e6 with SMTP id t3-20020a056a00138300b0063b599ba2e6mr21128967pfg.27.1683665973734;
        Tue, 09 May 2023 13:59:33 -0700 (PDT)
Received: from localhost ([50.221.140.188])
        by smtp.gmail.com with ESMTPSA id j11-20020a62e90b000000b00571cdbd0771sm2158999pfh.102.2023.05.09.13.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 13:59:33 -0700 (PDT)
Date:   Tue, 09 May 2023 13:59:33 -0700 (PDT)
X-Google-Original-Date: Tue, 09 May 2023 13:59:04 PDT (-0700)
Subject:     Re: [PATCH -next v19 23/24] riscv: Enable Vector code to be built
In-Reply-To: <20230509-chitchat-elitism-bc4882a8ef8d@spud>
CC:     andy.chiu@sifive.com, Conor Dooley <conor.dooley@microchip.com>,
        linux-riscv@lists.infradead.org, anup@brainfault.org,
        atishp@atishpatra.org, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, Vineet Gupta <vineetg@rivosinc.com>,
        greentime.hu@sifive.com, guoren@linux.alibaba.com,
        Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     Conor Dooley <conor@kernel.org>
Message-ID: <mhng-8554b236-c9d4-4590-8941-ed7ca5316d18@palmer-ri-x1c9a>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 09 May 2023 09:53:17 PDT (-0700), Conor Dooley wrote:
> On Wed, May 10, 2023 at 12:04:12AM +0800, Andy Chiu wrote:
>> > > +config RISCV_V_DISABLE
>> > > +     bool "Disable userspace Vector by default"
>> > > +     depends on RISCV_ISA_V
>> > > +     default n
>> > > +     help
>> > > +       Say Y here if you want to disable default enablement state of Vector
>> > > +       in u-mode. This way userspace has to make explicit prctl() call to
>> > > +       enable Vector, or enable it via sysctl interface.
>> >
>> > If we are worried about breaking userspace, why is the default for this
>> > option not y? Or further,
>> >
>> > config RISCV_ISA_V_DEFAULT_ENABLE
>> >         bool "Enable userspace Vector by default"
>> >         depends on RISCV_ISA_V
>> >         help
>> >           Say Y here to allow use of Vector in userspace by default.
>> >           Otherwise, userspace has to make an explicit prctl() call to
>> >           enable Vector, or enable it via the sysctl interface.
>> >
>> >           If you don't know what to do here, say N.
>> >
>> 
>> Yes, expressing the option, where Y means "on", is more direct. But I
>> have a little concern if we make the default as "off". Yes, we create
>> this option in the worries of breaking userspace. But given that the
>> break case might be rare, is it worth making userspace Vector harder
>> to use by doing this? I assume in an ideal world that nothing would
>> break and programs could just use V without bothering with prctl(), or
>> sysctl. But on the other hand, to make a program robust enough, we
>> must check the status with the prctl() anyway. So I have no answer
>> here.
>
> FWIW my logic was that those who know what they are doing can turn it on
> & keep the pieces. I would expect distros and all that lark to be able to
> make an educated decision here. But those that do not know what they are
> doing should be given the "safe" option by default.
> CONFIG_RISCV_ISA_V is default y, so will be enabled for those upgrading
> their kernel. With your patch they would also get vector enabled by
> default. The chance of a breakage might be small, but it seems easy to
> avoid. I dunno...

It's really more of a distro/user question than anything else, I'm not 
really sure there's a right answer.  I'd lean towards turning V on by 
default, though: the defconfigs are meant for kernel hackers, so 
defaulting to the option that's more likely to break something seems 
like the way to go -- that way we see any possible breakages early and 
can go figure them out.

Depending on the risk tolerance of their users, distributions might want 
to turn this off by default.  I posted on sw-dev, which is generally the 
best way to find the distro folks.
