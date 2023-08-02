Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAAEC76C83D
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 10:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbjHBIRf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 04:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233878AbjHBIR3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 04:17:29 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08BBA10E
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 01:17:24 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-99c0cb7285fso467123066b.0
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 01:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690964242; x=1691569042;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1ldftGtGE3zBMdAsfK66SnrRKaY4BxtS34znrPguj00=;
        b=VZqg9aULNEJ7UAIeUZOwVIpEb7J/gAa6BbzIysq7Qjg2B9i6MmbL+iJ60H+mEFeXwO
         7+xUEszd8iITALIH9uNbRd230JgmuGEdOgIcHcoQXy8XHBMUwuDC0LWzoAky73O0QTDE
         IK88InVrjSBCb7Smd0ockQwMZ+jN0jOJhAL/oUvyo3VLBhj11Yx6rgBjirBPF3gNpvql
         VnLkA8pYwpIQoZHuaaj3iEqDeC9dmb6s5trPnFhpRiNySbdp+i8/UaG7vpEzM2DJLNnJ
         K9GPMwod2L+xnnD7JQwHpzQ/+/yFdbJScFCkjmOQpf5t8q6mbraixrpnNxbtEVKLyltB
         We2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690964242; x=1691569042;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1ldftGtGE3zBMdAsfK66SnrRKaY4BxtS34znrPguj00=;
        b=QUltAWhJKwxfGF4qQVGCY7Xbesm0oVL0jE6q0sCY50nIXuuqg8ODU3OH4S7i0KqfBB
         5OP35CXEeY/xfeu1d5gtuZ+qyUoj7B/ynUdpjSHjWmFVuMBrIJvrndGgZQ2D3Ho/PUAm
         Tv6Xe6mxXyZvTlBtFEi1d+tRNPZdqMnfLz+7IYWodPtrlV8wJy9XlWa/OKE8Jw1J8FKp
         tPbC/0ConHPWTiyp/POJGnn6SQbzNTzt/nIvh/1XiuNpqp7z5QrwtQqR4s3cwUmsk+9p
         tMZPgk0K3LLYXqNN1Gc704qTE8Zb6hHLgkIZtPVO5jUxifZ20tX/zkAsgWH2SiDST49K
         0L5A==
X-Gm-Message-State: ABy/qLZXR2aus1HTjaDOp4FMD9GJsg7csUigEnG1HDcU0aFRCcJwzEW4
        Qco/3pxhuZxQUtW6Ssc/RqsrgcMroqjv+M2Y/m3Akg==
X-Google-Smtp-Source: APBJJlE4se+P1KQKrNIWrSJYRpYsIXMW3uMaA4HkJOuaP9fCZ8JPzwkKO0enEcgnoSzjZqUYJquFHA==
X-Received: by 2002:a17:907:7893:b0:989:450:e585 with SMTP id ku19-20020a170907789300b009890450e585mr3875932ejc.45.1690964242457;
        Wed, 02 Aug 2023 01:17:22 -0700 (PDT)
Received: from localhost (212-5-140-29.ip.btc-net.bg. [212.5.140.29])
        by smtp.gmail.com with ESMTPSA id u7-20020a170906408700b009786ae9ed50sm8651597ejj.194.2023.08.02.01.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Aug 2023 01:17:21 -0700 (PDT)
Date:   Wed, 2 Aug 2023 11:17:20 +0300
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Cc:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org, anup@brainfault.org, atishp@atishpatra.org
Subject: Re: [PATCH v2 9/9] docs: kvm: riscv: document EBUSY in
 KVM_SET_ONE_REG
Message-ID: <20230802-4751804e563fb13903ef6277@orel>
References: <20230801222629.210929-1-dbarboza@ventanamicro.com>
 <20230801222629.210929-10-dbarboza@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230801222629.210929-10-dbarboza@ventanamicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 01, 2023 at 07:26:29PM -0300, Daniel Henrique Barboza wrote:
> The EBUSY errno is being used for KVM_SET_ONE_REG as a way to tell
> userspace that a given reg can't be written after the vcpu started.
> 
> Signed-off-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
> ---
>  Documentation/virt/kvm/api.rst | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index c0ddd3035462..229e7cc091c8 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -2259,6 +2259,8 @@ Errors:
>    EINVAL   invalid register ID, or no such register or used with VMs in
>             protected virtualization mode on s390
>    EPERM    (arm64) register access not allowed before vcpu finalization
> +  EBUSY    (riscv) register access not allowed after the vcpu has run
> +           at least once

We allow access (reading, even before, and now also writing when the value
is the same), so this should be worded in a way that conveys the register
may not be changed after the vcpu has run once.

Thanks,
drew
