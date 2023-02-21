Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D49A669DAF8
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 08:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233488AbjBUHMi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 02:12:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232229AbjBUHMh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 02:12:37 -0500
Received: from xry111.site (xry111.site [IPv6:2001:470:683e::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142F022DE0;
        Mon, 20 Feb 2023 23:12:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
        s=default; t=1676963552;
        bh=NT/bxUyjuTgTucQjfscaHAPS7A8qYlPCOPobgEa3YIs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Gb7iilyha/kuE2nXkDzG9kS3IfmZjb72Z9KoFm0gVyIRfrwlhx+sOSIInvQtmNVXK
         H/SWHKGu0s89aHQBuuDJ+vvmQVYXQ8r3GO43D2HnQCjgHaURn+378TDcUfFIODg1Pj
         Swic/omrgdMn8TyrUlLh73lzVmCHq/AO3sKDj7/o=
Received: from [IPv6:240e:457:1010:6c8d:9501:85b0:822b:e7ed] (unknown [IPv6:240e:457:1010:6c8d:9501:85b0:822b:e7ed])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
        (Client did not present a certificate)
        (Authenticated sender: xry111@xry111.site)
        by xry111.site (Postfix) with ESMTPSA id 78D4E66B3F;
        Tue, 21 Feb 2023 02:12:22 -0500 (EST)
Message-ID: <4cd00b5cdc78da6357d2d326e607b169faee34a8.camel@xry111.site>
Subject: Re: [PATCH v2 05/29] LoongArch: KVM: Add vcpu related header files
From:   Xi Ruoyao <xry111@xry111.site>
To:     maobibo <maobibo@loongson.cn>,
        Tianrui Zhao <zhaotianrui@loongson.cn>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>
Date:   Tue, 21 Feb 2023 15:12:16 +0800
In-Reply-To: <7d6125dd-29e8-14d8-b1d7-d8c14d7bec80@loongson.cn>
References: <20230220065735.1282809-1-zhaotianrui@loongson.cn>
         <20230220065735.1282809-6-zhaotianrui@loongson.cn>
         <497693ca2cbc443c1d9f796c3aace6c9987bec72.camel@xry111.site>
         <7d6125dd-29e8-14d8-b1d7-d8c14d7bec80@loongson.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2023-02-21 at 14:46 +0800, maobibo wrote:
> > On Mon, 2023-02-20 at 14:57 +0800, Tianrui Zhao wrote:
> > > +/* GCSR */
> > > +static inline u64 gcsr_read(u32 reg)
> > > +{
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u64 val =3D 0;
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0asm volatile (
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0"parse_r __reg, %[val]\n\t"
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0".word 0x5 << 24 | %[reg] << 10 | 0 << 5 | __reg\n\=
t"
> >=20
> > Don't do this.=C2=A0 You should add the instruction to binutils first, =
then
> > make CONFIG_KVM depend on the assembler supporting this instruction.
> > This is completely unreadable and only fine for an internal PoC.
>=20
> We are preparing to submit these instruction support for binutils,
> however it is still necessary. Supposing that it is supported in future
> gcc version, we can not drop existing gcc 12/13 supporting to compiling
> kernel with LoongArch architecture.

You can drop the support for KVM with less capable Binutils versions,
like:

config AS_HAS_LVZ
    def_bool $(as-instr some_gcsr_insn \$r0, \$gcsr0)

config KVM
    depends on AS_HAS_LVZ

>=20
> Maybe there will be human readable code like this:
> #if GCC_SUPPORT_KVM_INSTR
> =C2=A0 ...
> #else
> =C2=A0 asm volatile (".word=C2=A0=C2=A0 "
> =C2=A0 ...
> #endif
>=20
> Regards
> Bibo, Mao

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University
