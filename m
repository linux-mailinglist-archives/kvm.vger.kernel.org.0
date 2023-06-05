Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9F3722C70
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 18:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbjFEQZx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 12:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbjFEQZw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 12:25:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D796FA
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 09:25:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1470760180
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 16:25:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DDEEC433D2;
        Mon,  5 Jun 2023 16:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685982349;
        bh=16FiVOWMTXNNpQp0H7L/tdt9yi6fRhkrrSyFhfGxu8c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AVdcyakeTxduLWkU3GRmvU3VQsPXzt9BcEoreWHTYpQmzw45TQKNhdNKFe5Py/UT7
         Xz7JEwTTyY8K6K8xtA0H62giQecLHdZhxkZqh/MCFE+o6wNSSRiVdoyKYln64o6NrB
         koAYRK0pdqIzkLi3BidxTrCxvYeAMXeUIT8QvqLQ8JosySORyw0SGmQ7119njw3U5G
         K6h09nBBKexTaXtcmxcrwkOXhYGR4OvJV5SmOeZCrCFAmy8ESUtOR3KlUvO/RgDYmS
         xpPhp/WO77Aewvd6N/LWCbT8XTYLxA14UbOWGtrE1YfCtlId0RvTRYKwDeZA97XJj0
         9wtbijcvo1qcQ==
Date:   Mon, 5 Jun 2023 17:25:44 +0100
From:   Conor Dooley <conor@kernel.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Andy Chiu <andy.chiu@sifive.com>, linux-riscv@lists.infradead.org,
        palmer@dabbelt.com, anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Subject: Re: [PATCH -next v21 23/27] riscv: detect assembler support for
 .option arch
Message-ID: <20230605-lustily-applaud-59a06b1faa0f@spud>
References: <20230605110724.21391-1-andy.chiu@sifive.com>
 <20230605110724.21391-24-andy.chiu@sifive.com>
 <20230605154832.GA3049210@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ewc9C06HFFJn/n/2"
Content-Disposition: inline
In-Reply-To: <20230605154832.GA3049210@dev-arch.thelio-3990X>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--ewc9C06HFFJn/n/2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 05, 2023 at 08:48:32AM -0700, Nathan Chancellor wrote:

> Just an FYI, this change has landed in LLVM main, so it should be in
> LLVM 17 in a few months:

Great! :)

--ewc9C06HFFJn/n/2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZH4MiAAKCRB4tDGHoIJi
0nZpAQCU4elzyp5+2Mb9o2H1xwDwXFZady15wNVtR+PBUCz/BwEA2uuxzOKonmHu
CPbNZHdop20Ib6yH5Zz1Y8oml0ADYgk=
=GRBI
-----END PGP SIGNATURE-----

--ewc9C06HFFJn/n/2--
