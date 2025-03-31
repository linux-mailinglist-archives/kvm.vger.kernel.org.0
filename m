Return-Path: <kvm+bounces-42255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C154A76B1D
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 17:48:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2848F1890AF0
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 15:42:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04BB321CC4F;
	Mon, 31 Mar 2025 15:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FSKh8Jdg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4962153CE;
	Mon, 31 Mar 2025 15:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743435528; cv=none; b=NMnrjTew64O7WE+qRwZPsEi8reGiNMn6xm55fMMGG1H8JvWAEGNarxaEye8OqI30owob7gKqbMpFVx+YM0Kttz7VKQmgyuPFWmXKUnhXO9++f32pvcADmLzDcgDmMd+T/z6i3pUV8r1lR1fcnbJtiSlBr9QZhNAA8RXx9PEeMCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743435528; c=relaxed/simple;
	bh=uPSFDa3b3rPozp0DJtpTJXXVjrP8+jyf8IICol+dDB4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eo5m5biQR56wMYS5no6UjLoDC31IFVedyg9lgp4rQJpLKcPKBVxTMdVXfsHzub6I7eKEoqNr4Q34N6IdDhskQFjKD6sLd4Efr3cRP3YKkQXESw711CRSwDU15fZUxkdwVRr7G/GfHZ+ZCoXHsfYwv6yZ44EkD67SftRNfcT7O/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FSKh8Jdg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C72C4CEE3;
	Mon, 31 Mar 2025 15:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743435528;
	bh=uPSFDa3b3rPozp0DJtpTJXXVjrP8+jyf8IICol+dDB4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FSKh8JdgV0duer2kbzBdTNP5z5eGNu9pG/3/MHQNO1b+YqRPv750ZGkYlksOPDRgI
	 ncq/Yxtcg3xMJWF/B+xiDDVtJLSidlgAgexzyHgGf1KD+0eMo0gkioOveQCtUD/vA1
	 mXoi3SVE7K5BXW2FgStISu/J3rIAJzEGx/jk/1yXDLjDmb+/ZxImYeQ0pK0neE9TUS
	 0nxNsp1vvtAO1efpyo7oIdGM8P7irU5ppGB/6aRu4K5Ak9Ui7rT/sQ/Dhj9lvXozZ2
	 jBawS/LSOyr2+srkMLE82QgSDwJ0ac71X2amcl5dzDIhQR9jkEWN6UOQSLGqd86UdU
	 qmgno6/eIg/Pg==
Date: Mon, 31 Mar 2025 16:38:41 +0100
From: Conor Dooley <conor@kernel.org>
To: Atish Patra <atishp@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>, weilin.wang@intel.com,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v5 10/21] dt-bindings: riscv: add Counter delegation ISA
 extensions description
Message-ID: <20250331-cardigan-canary-cdec5038faf9@spud>
References: <20250327-counter_delegation-v5-0-1ee538468d1b@rivosinc.com>
 <20250327-counter_delegation-v5-10-1ee538468d1b@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="dG1PDbcUbNATIzue"
Content-Disposition: inline
In-Reply-To: <20250327-counter_delegation-v5-10-1ee538468d1b@rivosinc.com>


--dG1PDbcUbNATIzue
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 27, 2025 at 12:35:51PM -0700, Atish Patra wrote:
> Add description for the Smcdeleg/Ssccfg extension.
>=20
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

Acked-by: Conor Dooley <conor.dooley@microchip.com>

--dG1PDbcUbNATIzue
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZ+q3AQAKCRB4tDGHoIJi
0vhqAQCY9B8ZEw2rz3RmJIV81yzCSBeNKE2xgSdx/aEU/fDvlwD/dcuiA0D0Y5R4
7UBK9mlhN8m4DtBZ4u36l9HsPTBdMgg=
=xY5i
-----END PGP SIGNATURE-----

--dG1PDbcUbNATIzue--

