Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3DB6939DE
	for <lists+kvm@lfdr.de>; Sun, 12 Feb 2023 21:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjBLUkD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 15:40:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBLUkC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 15:40:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABDEF743;
        Sun, 12 Feb 2023 12:40:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF4A960DD8;
        Sun, 12 Feb 2023 20:40:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA01C433EF;
        Sun, 12 Feb 2023 20:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676234400;
        bh=1lpQpS/GNYNsRnTys9bYtupcbQYB/e2MlWlD8j8Iyk0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QjQVzY80cG0ggpySjSEr93J17VA8nsCLIBFQ1nDZmlfUja++nfU4rqdrQRio3d6K4
         zGhMSYpE2lmDh47vE/JztnwpJcR99hTFt3aDi5DOESEd+/IAii3N+WQP/owvUPoW/p
         zQhqgUIn0UqJDDoSinvGU5uyp1KLRmb1lDd7AQeVw/ToXIYUZx3mN67qlgEkE0FOBa
         JgK3kAP5WJJJ+LhxNi0YxMZlkhdY+1AHJriMYeTAPBnln2gQR2iEzSSf3mNKMHgbO0
         NCaN7OtupoRouqSdC3ggZWvb61PZvKnc1wWX/onr7RMrAgd5pj5hqnLD3xXpRWThcH
         pqJ4KgxdKACYQ==
Date:   Sun, 12 Feb 2023 20:39:54 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Jisheng Zhang <jszhang@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Andrew Jones <ajones@ventanamicro.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v5 00/13] riscv: improve boot time isa extensions handling
Message-ID: <Y+lOmmdakfHH6ENr@spud>
References: <20230212154333.GA3760469@roeck-us.net>
 <Y+kM//nuDv29Z9qJ@spud>
 <Y+kU9nDBTttZRLLq@spud>
 <Y+kcgcncQO/2DNLo@spud>
 <Y+kqi8bQE+8hLfOF@spud>
 <a059a815-dcb0-c575-b5a4-f9433e268e9b@roeck-us.net>
 <Y+kt04c1iRlzUNLA@spud>
 <48d2ac96-abdd-23bc-b167-08dc2c1a1dbe@roeck-us.net>
 <Y+kzy1y3Z3j3Ohs9@spud>
 <89c99d4a-8f0a-4e7e-9f93-2dc9f881ab9f@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="r/j8IOIYHWgmuS0W"
Content-Disposition: inline
In-Reply-To: <89c99d4a-8f0a-4e7e-9f93-2dc9f881ab9f@roeck-us.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--r/j8IOIYHWgmuS0W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 12, 2023 at 12:27:10PM -0800, Guenter Roeck wrote:
> On 2/12/23 10:45, Conor Dooley wrote:
> ...
> >=20
> > > However, I still see that the patch series
> > > results in boot hangs with the sifive_u qemu emulation, where
> > > the log ends with "Oops - illegal instruction". Is that problem
> > > being addressed as well ?
> >=20
> > Hmm, if it died on the last commit in this series, then I am not sure.
> > If you meant with riscv/for-next or linux-next that's fixed by a patch
> > from Samuel:
> > https://patchwork.kernel.org/project/linux-riscv/patch/20230212021534.5=
9121-3-samuel@sholland.org/
> >=20
>=20
> It failed after the merge, so it looks like it may have been merge damage.
>=20
> Anyway, I applied
>=20
> RISC-V: Don't check text_mutex during stop_machine

That being:
https://lore.kernel.org/all/20220322022331.32136-1-palmer@rivosinc.com/
Which handles the lockdep assertion during stop_machine...

> riscv: Fix early alternative patching
> riscv: Fix Zbb alternative IDs
>=20
> and the sifive_u emulation no longer crashes. However, I still get
>=20
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: CPU: 0 PID: 0 at arch/riscv/kernel/patch.c:71 pat=
ch_insn_write+0x222/0x2f6

=2E..but doesn't prevent the early "spam" of assertion failures from the
code patching for alternatives. I sent a patch to take the lock during
the alternative patching which should get rid of them for you. It did
for me at least!
https://lore.kernel.org/all/20230212194735.491785-1-conor@kernel.org

> repeated several times.
>=20
> I then also tested
>=20
> riscv: patch: Fixup lockdep warning in stop_machine

This one just deletes the lockdep check, so I would expect it to remove
the complaints.

> riscv: Fix early alternative patching
> riscv: Fix Zbb alternative IDs
>=20
> which works fine (no warning backtrace) for sifive_u, but gives me
>=20
> WARNING: CPU: 0 PID: 0 at kernel/trace/trace_events.c:433 trace_event_raw=
_init+0xde/0x642

Hmm, do you have the full splat for this one handy?

> and a whole lot of
>=20
> event btrfs_clear_extent_bit has unsafe dereference of argument 1
>=20
> and similar messages when running the "virt" emulation. That was there be=
fore,
> but drowned in the noise. Ok, guess I'll need another round of bisect.

Thanks for all of your testing :)


--r/j8IOIYHWgmuS0W
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY+lOmgAKCRB4tDGHoIJi
0mb0AP4w2tfCzWoQKw3GDg+IxQSapgGUTgwTcCv5HKLmE8DmNwEAyUG4YtMOwXIF
DmFrRRrKoqUaSRzqyXHt/CFbUN1fGwk=
=KiVj
-----END PGP SIGNATURE-----

--r/j8IOIYHWgmuS0W--
