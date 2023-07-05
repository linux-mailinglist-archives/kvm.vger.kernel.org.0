Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3430F748481
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 14:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbjGEM6a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 08:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjGEM62 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 08:58:28 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6FEDA
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 05:58:27 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-51d9c71fb4bso6497328a12.2
        for <kvm@vger.kernel.org>; Wed, 05 Jul 2023 05:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1688561906; x=1691153906;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jQrDgXonDxL9axtRl5lwZsakY/CjkoP6IKvWcgWl998=;
        b=Vge9U9xIPTzswsZaPbqYxfhI6z8Z/UuxnLvU2uyCUZE3k5aAhdD7iJVTVc1UI0mEHd
         BhGcuR5WPggmOqTff8QC7f1LX50jW1RrYyNiBkU+GfpkHIaA+5ogqBO4UzA/ehcRYwSt
         92rcaer+1OM3e9Or1FJcTL9sWLRV5Me1sMhVCgU5S8VapRxf4Fb8vvyRss/TF74u3GJe
         J5k3CjvPrBAHouwI3hn0z3wbdtsSLssVxiH0/UJq2MBxD6KxJHHOmgfRHWzrMmddr5zX
         qoaP1R8WXwKNYb1sEsDJptZcCB9YuZzgzHO8e3kU1755r/KZzZ1ACukIdcJSFApMSdvG
         lUCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688561906; x=1691153906;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jQrDgXonDxL9axtRl5lwZsakY/CjkoP6IKvWcgWl998=;
        b=io6L+F3MmQwoKl8W6m5LV8eHuRJF2mSYWccKQ+ED/8rYuJUcly9DCXj7Se0SJx/TyO
         3Qyh6niiv4mOqhXv523ebmE90KlhPso9FPPQwPpZ73dbtugXENgYI1/IjAn0oPhd1roq
         b8xN+jh9a9tO5aCfTGy0mJhg2+dqJlX6zLdofKWHJLZOzfhFTlmovyKfIV/O4xw4uYoK
         r73PjxbfmXg/4H9z/RU86wwlgsfhZm3p5sjwsLbWTTyrpV0OBOchue4y+Uler4OZmouY
         foysE7oEXXG92zlwtHTVLMLRX/uFX6mp17gKt3OzSwnH67Jf1awpqyea1k1Fj/zh6BCE
         5fLg==
X-Gm-Message-State: ABy/qLZorxlNcaRqLzvmOJsGBXx6VbdQsR0G1fZj6x5LjeylxZkP8Kr4
        OCKvxSmh5MAha/oxX0o2DhDajA==
X-Google-Smtp-Source: APBJJlHiqjKjBQiht3ujNI3mPjt2v0U8ymFWVRPidfULSVfKhueCcRmrXgy7sd1cyBj91qvzThz7ug==
X-Received: by 2002:aa7:c98c:0:b0:51d:9db4:8201 with SMTP id c12-20020aa7c98c000000b0051d9db48201mr11179630edt.7.1688561906257;
        Wed, 05 Jul 2023 05:58:26 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id h8-20020aa7c948000000b0051d87e72159sm12571933edt.13.2023.07.05.05.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jul 2023 05:58:25 -0700 (PDT)
Date:   Wed, 5 Jul 2023 14:58:24 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Cc:     Alexandre Ghiti <alex@ghiti.fr>, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, kvm@vger.kernel.org,
        Conor Dooley <conor.dooley@microchip.com>, anup@brainfault.org,
        atishp@atishpatra.org
Subject: Re: [PATCH] RISC-V: KVM: provide UAPI for host SATP mode
Message-ID: <20230705-602410a4b627f419f8f9936c@orel>
References: <20230705091535.237765-1-dbarboza@ventanamicro.com>
 <994ae720-b3a1-1e67-ca9c-ca00e6525488@ghiti.fr>
 <029b87e1-d4bc-9deb-316b-b93c5bd2a37f@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <029b87e1-d4bc-9deb-316b-b93c5bd2a37f@ventanamicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 05, 2023 at 09:33:26AM -0300, Daniel Henrique Barboza wrote:
> 
> 
> On 7/5/23 09:18, Alexandre Ghiti wrote:
> > 
> > On 05/07/2023 11:15, Daniel Henrique Barboza wrote:
> > > KVM userspaces need to be aware of the host SATP to allow them to
> > > advertise it back to the guest OS.
> > > 
> > > Since this information is used to build the guest FDT we can't wait for
> > 
> > 
> > The thing is the "mmu-type" property in the FDT is never used: the kernel will probe the hardware and choose the largest available mode, or use "no4lvl"/"no5lvl" from the command line to restrict this mode. And FYI the current mode is exposed through cpuinfo. @Conor Can we deprecate this node or something similar?
> > 
> > Just a remark, not sure that helps :)
> 
> It does, thanks. I am aware that the current mode is exposed through cpuinfo.
> mvendorid/marchid/mimpid is also exposed there. As far as I understand we should
> rely on KVM to provide all CPU related info to configure a vcpu though.
> 
> A little background of where I'm coming from. One of the QEMU KVM cpu types (host)
> doesn't have an assigned satp_mode. The FDT creation of the 'virt' board relies on
> that info being present, and the result is that the board will segfault. I sent a
> fix for it that I hope will be queued shortly:
> 
> https://lore.kernel.org/qemu-devel/20230630100811.287315-3-dbarboza@ventanamicro.com/
> 
> Thus, if it's decided that the satp_mode FDT is deprecated, we can ignore this
> patch altogether. Thanks,

We'll eventually want the ability to get and set vsatp.mode from the VMM,
so we'll want KVM_REG_RISCV_CONFIG_REG(satp_mode) anyway. For now, since
we only support CPU passthrough with KVM, it's a convenient way to read
the host's mode (while PPC qemu-kvm does read cpuinfo, I'm not aware of
any other qemu-kvm doing that).

Thanks,
drew
