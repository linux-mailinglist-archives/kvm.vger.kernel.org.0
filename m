Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 099BF6D6926
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 18:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235456AbjDDQqp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 12:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjDDQqo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 12:46:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE7D4E6C;
        Tue,  4 Apr 2023 09:46:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C83E6367B;
        Tue,  4 Apr 2023 16:46:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A65CC433EF;
        Tue,  4 Apr 2023 16:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680626802;
        bh=EOynIrMe4icDg+MA2Rcia/HiUrf33I33TA7StNPiBIg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jcMQoxexEFGKw823dUQ0DXje5S8P4gWt/XM+l1CwqRBWpU/+PfsrdEIXJUj3oKaAX
         xJXVvlfESDScv2bwz+tmUg92jDon22E204DzabM7ZOk+7MoMVI3C4fZqAZpB4gzGu/
         a6RbTXgzRmIFvMzLhDWkkzEDXqHW5ezdTj4x1xQ5vZBzdcULzR20GmvG+poIBROMjJ
         fznTMFVJMQtM9S9Z0NWbA+86yUYQ3lYsixpySxWdk/AhqD9z+h+4fFCSo/WF3BNev3
         fsz11Wnc8X0orn7Pe8XVmgdM0lburhJTjmAtSKl2LEcF+nG6AL1TzvcvofAUiz1SQP
         N2iua/noEMuoQ==
Date:   Tue, 4 Apr 2023 17:46:37 +0100
From:   Conor Dooley <conor@kernel.org>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Atish Patra <atishp@rivosinc.com>
Subject: Re: [PATCH v4 2/9] RISC-V: Detect AIA CSRs from ISA string
Message-ID: <20230404-facecloth-curdle-f2d5d46e1375@spud>
References: <20230404153452.2405681-1-apatel@ventanamicro.com>
 <20230404153452.2405681-3-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Y+UmWbrC7kSZZPyg"
Content-Disposition: inline
In-Reply-To: <20230404153452.2405681-3-apatel@ventanamicro.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Y+UmWbrC7kSZZPyg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Thanks for fixing up the order Anup.

--Y+UmWbrC7kSZZPyg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZCxUWgAKCRB4tDGHoIJi
0lq2AP9V7qRL9e4htc1SIvwLo8GdgdrsRvqOb05PBMTv8maS1wEApsDgm01rwMwv
g3teQBkWZLDsAZADrY9kH1KQi72E/AM=
=wrvU
-----END PGP SIGNATURE-----

--Y+UmWbrC7kSZZPyg--
