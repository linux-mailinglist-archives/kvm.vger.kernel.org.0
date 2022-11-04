Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9F861953E
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 12:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbiKDLQk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 07:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiKDLQi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 07:16:38 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7012F45
        for <kvm@vger.kernel.org>; Fri,  4 Nov 2022 04:16:37 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4943421875;
        Fri,  4 Nov 2022 11:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1667560596; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YKUajCa0vYm8BVoEhd8nn50gaUsUGtXjzFoK42godr4=;
        b=ZDoAT5oH7WrRVvePqr1APmGvxQlR/yr3kehyMmxigLk99+Z4v2V96kErcmuJPWpGZ5eSxv
        zvQ9oesCxfszIJxyS7pOZUsWVZYWKFuB10bF3ATKpV/3WuQR+wZ57ZcC5dqibrGPTrVjVn
        0wg3I7JDxo+FcgZu5xsTAVGdmJmNcRo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1667560596;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YKUajCa0vYm8BVoEhd8nn50gaUsUGtXjzFoK42godr4=;
        b=uAv2fAz5EmM7uS1p+REJPg8nGNYl5IvGXXFX88t3uK3gQUDXEsdYjA7bYY/TQbCMxEmirA
        DQBMT6Agr/4Po+DQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 420F513216;
        Fri,  4 Nov 2022 11:16:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id BxQZEJT0ZGOVPwAAMHmgww
        (envelope-from <matthias.gerstner@suse.de>); Fri, 04 Nov 2022 11:16:36 +0000
Date:   Fri, 4 Nov 2022 12:16:30 +0100
From:   Matthias Gerstner <matthias.gerstner@suse.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH] tools/kvm_stat: fix attack vector with user controlled
 FUSE mounts
Message-ID: <Y2T0khQR9DtEyuF4@kasco.suse.de>
References: <20221103135927.13656-1-matthias.gerstner@suse.de>
 <f5315936-fbdf-c7b1-e7a9-f494001eebfd@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Z9AA1ShoZyhrRY6F"
Content-Disposition: inline
In-Reply-To: <f5315936-fbdf-c7b1-e7a9-f494001eebfd@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Z9AA1ShoZyhrRY6F
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Fri, 4 Nov 2022 12:16:30 +0100
From: Matthias Gerstner <matthias.gerstner@suse.de>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Subject: Re: [PATCH] tools/kvm_stat: fix attack vector with user controlled
 FUSE mounts

On Thu, Nov 03, 2022 at 03:21:12PM +0100, Paolo Bonzini wrote:
> On 11/3/22 14:59, Matthias Gerstner wrote:
> > The fix is simply to use the file system type field instead. Whitespace
> > in the mount path is escaped in /proc/mounts thus no further safety
> > measures in the parsing should be necessary to make this correct.
>=20
> Can you please send a patch to replace seq_printf with seq_escape in=20
> afs_show_devname though?  I couldn't find anything that prevents=20
> cell->name and volume->name from containing a space, so better safe than=
=20
> sorry.

I only checked this during runtime using a tmpfs and assumed this would
be true for all file systems.

Sure I can come up with a patch. Should I send a new single patch
containing both changes, a new patch series with two patches or do I
need to send the afs change to a different mailing list? Sorry - I'm new
to kernel development.

Cheers

Matthias

--Z9AA1ShoZyhrRY6F
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE82oG1A8ab1eESZdjFMQFyXGSNVMFAmNk9I8ACgkQFMQFyXGS
NVMK9hAAi+mM2vz2J/ZqNA5jtugRUs8/vlaHndrJ6jWbHaibZPzHHNeJrZV6hRcm
rWNQ0DJVPMOiLqLgQDDYQfvfG+QryCZ3oAnkKIUQ3mDpMYi9C8MA0wuOKKwi8SY/
VtgXuMCaKXqfc0Ton7v32FG8rDh1ThAAqZhI3sPc/00m1iUTT+FCDnjF+gGooES2
vVLFCxkruAgYdVKsBXRNzBO1ZucwnQQMz1bgA4CHaZqjKGgXUGaa8XXl3Hyd+pFv
1Sad8MPKYV4ayGoSaAP4n4w69w3FKmYQ5okIcgF1k6Q0Zkmw/asXcK8H2LjeU+7k
stOJX1BEX3QQCSkptEr34drBvXpXIkbD0agC0QHWYitcPeJkYnnoN4J8W7QLtvV+
lZC1JS2JpdFxGo1E0JWAu69WO2R6zZADkb+6s1wjQv72ITLAcrCHcyKOdS+sF3o8
QOD0vHLIMqe0k+RWgBd23OBCw5kR6f0HpEsM/7hj47gMEsm+5nVkhFxX8mqUqRGD
9JGG38ojQCta5+Hme+UnDud+9TfqNzEVatVauQYTpFsTs7uShtoTHDbb2yiOpZaK
g9ogs7Ezmb3q0aI70d6iqOJR9RkdtV75WVaCu/qZW4Fw9Zkqxb7meve4JDpAiuFb
eJNd557Pt2YKkAaZ4FZpRj3QEWXz6J/ljG67l0wbvF3KzZFFgMY=
=mg18
-----END PGP SIGNATURE-----

--Z9AA1ShoZyhrRY6F--
