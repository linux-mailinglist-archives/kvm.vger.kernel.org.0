Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B845D69DA2F
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 05:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbjBUEqV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 23:46:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232643AbjBUEqT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 23:46:19 -0500
Received: from xry111.site (xry111.site [IPv6:2001:470:683e::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66FAD2412E
        for <kvm@vger.kernel.org>; Mon, 20 Feb 2023 20:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
        s=default; t=1676954221;
        bh=lefJq0PkABiE40hGP+cE8pG5V0Ru6IiPZz+2dOAh2DQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YYIpv6zJsqWzhdbfWvspbND955SnKSHHFRLw8GOhYDEntWPuWp0L+FW3BNKyhpLp8
         tjQuqncIr+DGVWcPhVYOI7rQFoMxbie6E3hL+87kmR7kFjtselhdw478SZHkQVKeB0
         /+2K8kPoxKsM5m7PzpEw7bx2ugJBGTfv7ArXjHII=
Received: from localhost.localdomain (xry111.site [IPv6:2001:470:683e::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
        (Client did not present a certificate)
        (Authenticated sender: xry111@xry111.site)
        by xry111.site (Postfix) with ESMTPSA id 9559265C4D;
        Mon, 20 Feb 2023 23:36:59 -0500 (EST)
Message-ID: <ef024d7e4e0207e76c165c1818d1bb21f07235ab.camel@xry111.site>
Subject: Re: [PATCH v2 01/29] LoongArch: KVM: Add kvm related header files
From:   Xi Ruoyao <xry111@xry111.site>
To:     Tianrui Zhao <zhaotianrui@loongson.cn>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn
Date:   Tue, 21 Feb 2023 12:36:58 +0800
In-Reply-To: <20230220065735.1282809-2-zhaotianrui@loongson.cn>
References: <20230220065735.1282809-1-zhaotianrui@loongson.cn>
         <20230220065735.1282809-2-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2023-02-20 at 14:57 +0800, Tianrui Zhao wrote:

/* snip */

> +/*
> + * for KVM_GET_FPU and KVM_SET_FPU
> + */
> +struct kvm_fpu {
> +	__u32 fcsr;
> +	__u32 none;
> +	__u64 fcc;    /* 8x8 */
> +	struct kvm_fpureg {
> +		__u64 val64[4];	//support max 256 bits
> +	} fpr[32];

Do we need __attribute__((__aligned__(16))) for fpureg (like
sc_extcontext in struct sigcontext)?

> +};
> +
> +/*
> + * For LOONGARCH, we use KVM_SET_ONE_REG and KVM_GET_ONE_REG to
          ^^^^^^^^^
          LoongArch

> access various
> + * registers.=C2=A0 The id field is broken down as follows:
> + *
> + *=C2=A0 bits[63..52] - As per linux/kvm.h
> + *=C2=A0 bits[51..32] - Must be zero.
> + *=C2=A0 bits[31..16] - Register set.

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University
