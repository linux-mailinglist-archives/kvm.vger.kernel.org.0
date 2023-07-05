Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19D457486D6
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 16:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbjGEOvw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 10:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231676AbjGEOvv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 10:51:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E21F1703
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 07:51:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97FD8615A5
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 14:51:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A9FC433C9;
        Wed,  5 Jul 2023 14:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688568710;
        bh=xH3lyctIueZw4PQfaohnlvwl58gEmyuFjcz953X1GNs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HJWRW3aaJHyl/yYeSXazp4YCkgA1+ygkYkSUg7Tr6/uT3J0CQ+Xmc0VR2dsctzqYU
         aHFLdUkCuXumO3F1yX6Syl6v8FpeUd56393GqISXaD+qq6e/G/wxEqaKIOAmoQXsz9
         Lw6PqVht7IBC2eACsGvZjAHdVUuaPlM5JUDkkPMpqUZOjf/VsgvXjtDbYQA2+cQCy8
         3FX/FBiDVocwnR45Bdl7yqXruIMs2Kv195Tcm1x9yBQVBx160xkYMEcynVhJQTd+1i
         pjZLt6L6rmiCxKJpi11vc+xBFeIp4E82PVRHLlICbAn5zro5wAoT/s75OVwQQPu4bC
         mN2qmynznVpYQ==
Date:   Wed, 5 Jul 2023 15:51:45 +0100
From:   Conor Dooley <conor@kernel.org>
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Alexandre Ghiti <alex@ghiti.fr>, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, kvm@vger.kernel.org,
        Conor Dooley <conor.dooley@microchip.com>, anup@brainfault.org,
        atishp@atishpatra.org
Subject: Re: [PATCH] RISC-V: KVM: provide UAPI for host SATP mode
Message-ID: <20230705-bogged-remindful-b2ccef9be2ac@spud>
References: <20230705091535.237765-1-dbarboza@ventanamicro.com>
 <994ae720-b3a1-1e67-ca9c-ca00e6525488@ghiti.fr>
 <029b87e1-d4bc-9deb-316b-b93c5bd2a37f@ventanamicro.com>
 <20230705-602410a4b627f419f8f9936c@orel>
 <20230705-fondue-bagginess-66c25f1a4135@spud>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jHe0oA0IsObFFmge"
Content-Disposition: inline
In-Reply-To: <20230705-fondue-bagginess-66c25f1a4135@spud>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--jHe0oA0IsObFFmge
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 05, 2023 at 03:44:02PM +0100, Conor Dooley wrote:

> (@Drew, I remember why now that the property is optional - nommu exists)

Wait, no that makes no sense - there's "riscv,none" for that.

--jHe0oA0IsObFFmge
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZKWDgQAKCRB4tDGHoIJi
0vxrAP90gWO0dKip3YD/2jmXnN51P9sS9XD2AI0cd5feduqkKgD6AgI6B7JrOQGJ
IoMLFctxzEz4TX5aDaRdjyZwERAu0wM=
=j/Rn
-----END PGP SIGNATURE-----

--jHe0oA0IsObFFmge--
