Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E656C31B9
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 13:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbjCUMaz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 08:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjCUMax (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 08:30:53 -0400
Received: from xry111.site (xry111.site [IPv6:2001:470:683e::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F8BE211FF;
        Tue, 21 Mar 2023 05:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
        s=default; t=1679401840;
        bh=RIk1bW9UJ1N6hwpsv3iiYyeLz4E5i4Xo2Z7MHEEpqjw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UrurL81bAtGJJ3vZF1m5JCqI4EOjAq6EMSwanOFS3UJhoPWGXuutALltE8o6kYvFf
         KwIZslmJw9bw6RTmF+BlYodHgJPXwEd/QnWwXEeW33vnD7oE3xdEri+bAtmbZLWbcq
         wvc+BcyytHLH0o7Y5nGdQySA2P/RCTJsMd3qMBLc=
Received: from localhost.localdomain (xry111.site [IPv6:2001:470:683e::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
        (Client did not present a certificate)
        (Authenticated sender: xry111@xry111.site)
        by xry111.site (Postfix) with ESMTPSA id F2CD46633A;
        Tue, 21 Mar 2023 08:30:37 -0400 (EDT)
Message-ID: <75f843b2780fc3c3dcc1d0d8f78f2b955956316b.camel@xry111.site>
Subject: Re: [PATCH v4 05/29] LoongArch: KVM: Add vcpu related header files
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
Date:   Tue, 21 Mar 2023 20:30:36 +0800
In-Reply-To: <20230321035651.598505-6-zhaotianrui@loongson.cn>
References: <20230321035651.598505-1-zhaotianrui@loongson.cn>
         <20230321035651.598505-6-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2023-03-21 at 11:56 +0800, Tianrui Zhao wrote:
> +/* Tracepoints for VM exits */
> +#define kvm_trace_symbol_exit_types=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0\
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0({ KVM_TRACE_EXIT_IDLE,=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0"IDLE" },=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0\
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0{ KVM_TRACE_EXIT_CACHE,=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0"CACHE" },=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0\
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0{ KVM_TRACE_EXIT_SIGNAL,=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0"Signal" })

Looks like there shouldn't be "(" and ")".

> +#define kvm_trace_symbol_aux_op				\
> +	({ KVM_TRACE_AUX_RESTORE,	"restore" },	\
> +	{ KVM_TRACE_AUX_SAVE,		"save" },	\
> +	{ KVM_TRACE_AUX_ENABLE,		"enable" },	\
> +	{ KVM_TRACE_AUX_DISABLE,	"disable" },	\
> +	{ KVM_TRACE_AUX_DISCARD,	"discard" })

Likewise.

See the test robot report, and https://godbolt.org/z/bE8q97z1o.

The lesson: if a text book claims "you should always wrap the content of
a macro in ( ... )", we should burn it in the fire! :)

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University
