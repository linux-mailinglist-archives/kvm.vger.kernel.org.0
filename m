Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA5C976C8F2
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 11:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233730AbjHBJGS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 05:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233793AbjHBJGP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 05:06:15 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F973272D
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 02:06:13 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3fba8e2aa52so70588675e9.1
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 02:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690967172; x=1691571972;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hu7P5NCl9aaC7aDT0yq18Lt0mz/hHx0pz3Esj4sF7tc=;
        b=oQvmT7QbVMz1rQJc2hqTRIugO9tin+bDcsuf5SX4TEsk+tYvlmIWlh9fJWKZ4AoMcr
         gARTaxdsGTXg24KXWXUs3mBJoeehoeOEhPckHcMQYYuc0BB75ijKlQ1vAJmllvmIOVEn
         Uc3GT99LCrUoJL0OoKV9qNO/ZC5xJmLYVCckeoHJlyAS98vKDbGjvhhHeMbsqk7TYON4
         hUHupyeFVTLO2+ucyGcsN1s44h2GgkhSaEx7CCcYgChXkrd8JcCgfkQB7ALohlhuqyBm
         DH93KRiIJceoGhv+xJsouyN6ncwTJ+YZ7VnYJjzIpdkcIAiC1awM5nvcDdWMYu3d/EMb
         aaYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690967172; x=1691571972;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hu7P5NCl9aaC7aDT0yq18Lt0mz/hHx0pz3Esj4sF7tc=;
        b=gsKDkOMz3AqPC60bpgk/+5mLmJpxBCn7UGoz9We10e3oBgOF19VFd/2X4zE/HLszWw
         t5b8gH0GwXkKYUW0Zhy2cBVfRBqlnBqYLNp5aW6OXrVvmR0Fx97cZlEwg+nfE8R28MBX
         caUcfxTTAGfRjR0iKg5iI+a7i/bOL3LNlbYpaHJ5rPsguoCOPAYpOZT3SZTEEtuUuW/P
         SPnO0aitMW2QDF8cyC5PEG1sTfYEaDIif+Nd3lMkfD5l1cHDu8CC8gDT4cbXKfN6NQet
         +BryZ6yP2lUjp2S8Fj8yCoAeq43h/risJak5mMb99Bik07kFq8QxxMkJpxE6HNKadHaW
         OyUw==
X-Gm-Message-State: ABy/qLZ42UXpu0vwv23M2BAHRDH5FNVeenUL8gSDpc9QwO1JNQL9AsNx
        27TDv+94ja9MjS/L3+6dU7OXUA==
X-Google-Smtp-Source: APBJJlEsXnC7nncMeMiZPH9VffceoGFaN6V3Qjtf1+JRBLMjYToZP6nobGWbHzAcwa7EngAI95KEKA==
X-Received: by 2002:a1c:6a0e:0:b0:3fd:2e89:31bd with SMTP id f14-20020a1c6a0e000000b003fd2e8931bdmr4472634wmc.14.1690967171602;
        Wed, 02 Aug 2023 02:06:11 -0700 (PDT)
Received: from localhost (212-5-140-29.ip.btc-net.bg. [212.5.140.29])
        by smtp.gmail.com with ESMTPSA id u5-20020a7bc045000000b003fe1cdbc33dsm1157210wmc.9.2023.08.02.02.06.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Aug 2023 02:06:10 -0700 (PDT)
Date:   Wed, 2 Aug 2023 12:06:07 +0300
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Cc:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org, anup@brainfault.org, atishp@atishpatra.org
Subject: Re: [PATCH v2 0/9] RISC-V: KVM: change get_reg/set_reg error codes
Message-ID: <20230802-7d4fdd5978afe6f5edbf9a01@orel>
References: <20230801222629.210929-1-dbarboza@ventanamicro.com>
 <20230802-c76d712d088bc4b3057e3095@orel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230802-c76d712d088bc4b3057e3095@orel>
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SCC_BODY_URI_ONLY,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 02, 2023 at 12:04:25PM +0300, Andrew Jones wrote:
> On Tue, Aug 01, 2023 at 07:26:20PM -0300, Daniel Henrique Barboza wrote:
> > Hi,
> > 
> > In this new version 3 new patches (6, 7, 8) were added by Andrew's
> > request during the v1 review.
> > 
> > We're now avoiding throwing an -EBUSY error if a reg write is done after
> > the vcpu started spinning if the value being written is the same as KVM
> > already uses. This follows the design choice made in patch 3, allowing
> > for userspace 'lazy write' of registers.
> > 
> > I decided to add 3 patches instead of one because the no-op check made
> > in patches 6 and 8 aren't just a matter of doing reg_val = host_val.
> > They can be squashed in a single patch if required.
> > 
> > Please check the version 1 cover-letter [1] for the motivation behind
> > this work. Patches were based on top of riscv_kvm_queue.
> > 
> > Changes from v1:
> > - patches 6,7, 8 (new):
> >   - make reg writes a no-op, regardless of vcpu->arch.ran_atleast_once
> >     state, if the value being written is the same as the host
> > - v1 link: https://lore.kernel.org/kvm/20230731120420.91007-1-dbarboza@ventanamicro.com/
> > 
> > [1] https://lore.kernel.org/kvm/20230731120420.91007-1-dbarboza@ventanamicro.com/
> >
> 
> I found three missing conversions, which are in the diff below. Also, I
> saw that the vector registers were lacking good error returns, so I reworked
> that and attached a completely (not even compile) tested patch for them.
                                                   ^un

