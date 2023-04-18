Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 599CC6E67B5
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 17:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbjDRPDD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 11:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbjDRPDB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 11:03:01 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4559497
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 08:03:00 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a5so17484555ejb.6
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 08:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1681830179; x=1684422179;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eGjicJYh31cK/BzEcNTDnxEWlOaJ3534uI99hwaIMVo=;
        b=dskV/5fmTBnuPXg8dBbwRM2jLIuB5HSspB+M35Au08MsAjD1QDLO4dePsRtCagOSkp
         j0AVSz8ihvO5jlimsrNfECSWNP+sy0kyTKWXXZu+xYbVQgpEQ+J/JnFakqLvWa10+LKt
         5LGVmjFMDGwVXn9KxcYPk10J1QmOolsKq+Y9W51VZoCfbOULOmXjQVh6GLNMF2isypVB
         d5yF0l6+xoKeXEh95053nEbKb9qHOyY+2v4H43S0uO8nAwjwngOFWD0NIx+apXbklBmP
         +/dDfNRRTxlzD1XwfIRzo6BJgRNuEULW0ucxXH76xXJMHCfYGI4bVmZ6j8db0dKtKDyE
         Rn+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681830179; x=1684422179;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eGjicJYh31cK/BzEcNTDnxEWlOaJ3534uI99hwaIMVo=;
        b=TZsKbENfrC68b1EA3KzWo9NfUNDwCqTZWsGFlpqXweXoY6dfj1Ttax8pSq/Xxbnehm
         2ggdGyBzmbefCIi9HlNpO5W0CL7sOlQgP/fPVRQLiYKfaq9dh3opQm/1HLCY1YgIFKMG
         9i4nCcWnDY3stRZ0W4cFpX5s835bM9HkTSIvIRC53//c9SBbrBIZ1ZaCaOVJ8fOTuBov
         4YSXVjZ8skgc8dYUmmtR2Wi+eJd+CeUNcATT5aDXgBfeOk9DnfvIDSjmg3C9QzV4t9W+
         m4JtAZwN/p9e+e1r4aBHo+aP6pJkhK+ayiCEqFOJVNRA8iLk3tC41DrIMlT1Ds2QDETb
         d6oA==
X-Gm-Message-State: AAQBX9c4LAtF1KQ7u0XUhLhV0htRQxfbcj2ab13uZ50cZLmyy1Vq4TCV
        UMoMTsYsDffTtOiwS4sezorBDE/7a2PAn3FVcqc=
X-Google-Smtp-Source: AKy350aArc0ZHsPFZsb2XaItpfCxJdWy6iOn8pitaahBEwUw0ddE2TaksuGLfOLXkECUqylpgzKCYw==
X-Received: by 2002:a17:907:6d24:b0:94f:3980:bf87 with SMTP id sa36-20020a1709076d2400b0094f3980bf87mr10489381ejc.43.1681830178676;
        Tue, 18 Apr 2023 08:02:58 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id i7-20020a170906698700b0094a9eb7598esm8050623ejr.120.2023.04.18.08.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 08:02:58 -0700 (PDT)
Date:   Tue, 18 Apr 2023 17:02:57 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Ben Dooks <ben.dooks@codethink.co.uk>
Cc:     kvm@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH kvmtool 1/2] riscv: add mvendorid/marchid/mimpid to sync
 kvm_riscv_config
Message-ID: <vnnhy5z6bvqxf7q4njqturux3bsqwjrrxgzbv5fklf5swg5ws7@rkvh6ds7qzef>
References: <20230418142241.1456070-1-ben.dooks@codethink.co.uk>
 <20230418142241.1456070-2-ben.dooks@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418142241.1456070-2-ben.dooks@codethink.co.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 18, 2023 at 03:22:40PM +0100, Ben Dooks wrote:
> Add the ONE_REG for the mvendorid/marchid/mimpid from the kernel
> commit 6ebbdecff6ae00557a52539287b681641f4f0d33, to ensure the
> struct is in sync with newer kernels for adding zicboz.
> 
> Ref: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/id=6ebbdecff6ae00557a52539287b681641f4f0d33
> 
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> ---
>  riscv/include/asm/kvm.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/riscv/include/asm/kvm.h b/riscv/include/asm/kvm.h
> index 8985ff2..92af6f3 100644
> --- a/riscv/include/asm/kvm.h
> +++ b/riscv/include/asm/kvm.h
> @@ -49,6 +49,9 @@ struct kvm_sregs {
>  struct kvm_riscv_config {
>  	unsigned long isa;
>  	unsigned long zicbom_block_size;
> +	unsigned long mvendorid;
> +	unsigned long marchid;
> +	unsigned long mimpid;
>  };
>  
>  /* CORE registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> -- 
> 2.39.2
>

These should get updated with a proper header update using
util/update_headers.sh

Thanks,
drew
