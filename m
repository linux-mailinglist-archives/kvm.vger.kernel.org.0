Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99A5D70B4EE
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 08:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbjEVGRs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 02:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbjEVGRq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 02:17:46 -0400
Received: from xry111.site (xry111.site [89.208.246.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4E9DB;
        Sun, 21 May 2023 23:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
        s=default; t=1684736260;
        bh=yIi6ZOjy+E6qviZRUdHvLuggrTIRwROuyCYtl1GPs/c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PowzOCIkGK3QPPK1zhPYjhGrmt6OzZ3lAY1BvQvpwmo2Pna3qsXwu/R4pDlxoH7K0
         aH/LjNoZ3zGKusbk1YJhG2xiz3Lp3x8bsdO9jnx0aSx3ACXjdGsy3WqKP4zbgvqTp9
         9r1Po7UIPb+xZMSI+YcLUyS5/EyB7OKtHwL0AsYA=
Received: from [IPv6:240e:358:114f:a600:dc73:854d:832e:5] (unknown [IPv6:240e:358:114f:a600:dc73:854d:832e:5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
        (Client did not present a certificate)
        (Authenticated sender: xry111@xry111.site)
        by xry111.site (Postfix) with ESMTPSA id A8DC46627E;
        Mon, 22 May 2023 02:17:31 -0400 (EDT)
Message-ID: <e442508c20e8a077892a90b54fdbea302026eacd.camel@xry111.site>
Subject: Re: [PATCH v10 00/30] Add KVM LoongArch support
From:   Xi Ruoyao <xry111@xry111.site>
To:     WANG Xuerui <kernel@xen0n.name>, maobibo <maobibo@loongson.cn>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Tianrui Zhao <zhaotianrui@loongson.cn>
Date:   Mon, 22 May 2023 14:17:24 +0800
In-Reply-To: <90b2fc60-af26-4ba6-f775-7db2514a62f4@xen0n.name>
References: <20230515021522.2445551-1-zhaotianrui@loongson.cn>
         <02f07d8e-e1c2-2ec0-59c3-f5b4ef0463dc@loongson.cn>
         <4529ee5b-364a-7819-c727-71cf94057b8b@xen0n.name>
         <99371487-717a-64d6-1c3d-aaeaee6f20db@loongson.cn>
         <90b2fc60-af26-4ba6-f775-7db2514a62f4@xen0n.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.1 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2023-05-22 at 10:37 +0800, WANG Xuerui wrote:
> > Manual is actually one issue, however it does not prevent the review
> > process. There are some drivers for *fruit* devices, I can not find
> > the hw manual also.=C2=A0 With the manual, it helps to review and point=
s
> > out the further and detailed issues.
>=20
> There's a *slight* difference: the certain vendor you've mentioned is=20
> historically uncooperative in providing the documentation, so outside=20
> contributors had to reverse-engineer and document the HW themselves; but=
=20
> in Loongson's case, you *are* the vendor, so you are probably in a=20
> position that can make everyone's life easier by at least pushing for=20
> the docs release...

And some other differences:

1. *fruit* devices use an ARM64 which is already documented anyway.
2. *fruit* devices are more "popular" and the maintainer can test on it
more easily.  And *fruit* have more fans (esp. more fans with CS/EE
skills, while we have more [expletive deleted] fans :( ) so their
reverse-engineer effort is easier as well.  Yes it may be not fair to
others, but the world is just not fair.
3. *fruit* is really a bad example... When people ask me how to build
Linux From Scratch on *fruit* I just tell them "try to avoid things from
a vendor with no intention to allow you run another OS".

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University
