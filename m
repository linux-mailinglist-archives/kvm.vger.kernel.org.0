Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54A1753A52
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 14:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235548AbjGNMG1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 08:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbjGNMG0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 08:06:26 -0400
Received: from xry111.site (xry111.site [89.208.246.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1625430C6;
        Fri, 14 Jul 2023 05:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
        s=default; t=1689336385;
        bh=LIxcDZcLBMZIdbSr/T45y9VNE4gcQHTHKIV3HlOiko8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SKGqOkJkLYk9YnZ7JymlvDgkjG7nCxXejSlIsL2r0J6BZYrxjD45n20MmByEvWZxI
         G9pbaFrIZsyXAeO7o1YbUOP2UQcJVEPxtIUbu+cDYvXI465sWcvxmlgKvnHDjv8PZR
         PoFjqjLWnToGdi+qCLRJbIRoTLQOCuWFbuIbhUN4=
Received: from [192.168.124.11] (unknown [113.140.29.4])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
        (Client did not present a certificate)
        (Authenticated sender: xry111@xry111.site)
        by xry111.site (Postfix) with ESMTPSA id 7B93465CFE;
        Fri, 14 Jul 2023 08:06:22 -0400 (EDT)
Message-ID: <6a5ed2266138cc61cbe27577424bb53cda72378d.camel@xry111.site>
Subject: Re: [PATCH v16 05/30] LoongArch: KVM: Add vcpu related header files
From:   Xi Ruoyao <xry111@xry111.site>
To:     WANG Xuerui <kernel@xen0n.name>, bibo mao <maobibo@loongson.cn>,
        Huacai Chen <chenhuacai@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>, hejinyang@loongson.cn,
        Tianrui Zhao <zhaotianrui@loongson.cn>
Date:   Fri, 14 Jul 2023 20:06:20 +0800
In-Reply-To: <d58a20c9-1f52-c398-292b-2d2501a302e6@xen0n.name>
References: <20230629075538.4063701-1-zhaotianrui@loongson.cn>
         <20230629075538.4063701-6-zhaotianrui@loongson.cn>
         <CAAhV-H7P_GSsoo+g5o0BTCzK4fxwH5d2dQOYde-VpcGvn4SXQA@mail.gmail.com>
         <152f7869-d591-0134-cf9d-b55774a135e8@loongson.cn>
         <CAAhV-H4N2wdB8n7Pindv9WdVPLPOboK0Ys75SWOkMZU+=NWEbQ@mail.gmail.com>
         <152fbdd1-a21c-8ee1-d386-ec7f80b0bb97@loongson.cn>
         <d58a20c9-1f52-c398-292b-2d2501a302e6@xen0n.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2023-07-14 at 18:16 +0800, WANG Xuerui wrote:
> > > > > As all needed instructions have already upstream in binutils now =
and
> > > > > binutils 2.41 will be released soon, I suggest again to introduce
> > > > > AS_HAS_LVZ_EXTENSION and make KVM depend on AS_HAS_LVZ_EXTENSION.
> > > > It is a good news that binutils 2.41 has supported LVZ assemble lan=
guage.
> > > > we will add AS_HAS_LVZ_EXTENSION support, however KVM need not depe=
nd on
> > > > AS_HAS_LVZ_EXTENSION since bintuils 2.41 is not popularly used. yea=
p we
> > > > need write beautiful code, also we should write code with pratical =
usage.

I've raised this for a very early version of this series, but Paolo
decided using .word here should be fine:

https://lore.kernel.org/all/87268dce-1b5d-0556-7e65-2a75a7893cd1@redhat.com=
/

So in this case we should respect the decision of the KVM reviewer.  If
this breaks Clang build, we should improve Clang to support using .word
for hard coding an opcode.

Frankly I'm quite frustrated by "a new architecture needs so many
feature tests and hacks, here and there" and sometimes I just want to go
laid-up in bed instead of writing code or porting the distro (Linux From
Scratch).  But today I just got [a board from another Chinese vendor
targeting another new architecture] and to me they are doing things even
worse...  So maybe we are facing some inherent "no silver bullet
engineering issue".

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University
