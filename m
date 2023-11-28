Return-Path: <kvm+bounces-2594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B13A7FB661
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 10:54:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9BE941C210B1
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 09:54:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EE484C3AC;
	Tue, 28 Nov 2023 09:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="SDs4/28U"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A164109;
	Tue, 28 Nov 2023 01:54:01 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D8A4C40E01B1;
	Tue, 28 Nov 2023 09:53:58 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=fail (4096-bit key)
	reason="fail (body has been altered)" header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id bH8nQNUDPbpB; Tue, 28 Nov 2023 09:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1701165236; bh=aoMnhTr7jFd65n5Bx4KqYKvZ0RjDqIT+i/qp/fJf9sY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SDs4/28UNi7ssKZUpSxEQAK1JKNEFUDteBwUljeJdP1EjxfBr73XRShv17qhnE29j
	 Nf09IzxD+prQAm/Q4rOhBt85lPfBZiCTMRhQ9NoX5QIPwbFEix/+iBCG5+vxIOX98q
	 /NHeUoHAO18Of1mgtQH8/PuVEmf5Fb+rl0mDobbU5qiD7ptINcz2Eq73gPYwBCpH9C
	 qA9uASBrO9JaCtJT5E7ahhCs1Xie3EWLOLbdfWofmx5MGdX4g6Xwo2IHyGDRyw/So1
	 8UVeLkmc2VUZvqwlkbkNpjOoqkVxGhEcW7dgbGQtUoU+BaSRpcTEyZyFn58R0xAI7G
	 AjTaLWdZXbOi0lvAQE79lhCDmmqS+oLctYcxTJ82oWH0j5RPue1TUtCPisLSB3xEJZ
	 cMLZz3hOt6Np+xbUrFWqu3iZjOSrlFaxohNLV4uoAuto/1l8eJGgz9lFzdRTj+OdAT
	 FOHxijYdEySTKyj/1+Q/EKl3+WvDTXVazCchOy4n78gFYKZe8SiP7bmrdyIhdRcItk
	 DWXt4pwBXpMxosc56Zeo1QiMHBq5iDNcisNfkHf0Dk57xnhOlBt9kvuONbMGmiJ0RW
	 CEkO7XTK28htgUb78Jk8jfxji1wVzlYL7VOje+gqe5m1pSejuzet3rgDYLIblYpcfH
	 fFzIm7U20KE3ud/SyQRiGiIs=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9763840E0195;
	Tue, 28 Nov 2023 09:53:34 +0000 (UTC)
Date: Tue, 28 Nov 2023 10:53:29 +0100
From: Borislav Petkov <bp@alien8.de>
To: Xin Li <xin3.li@intel.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
	kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
	tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, luto@kernel.org, pbonzini@redhat.com,
	seanjc@google.com, peterz@infradead.org, jgross@suse.com,
	ravi.v.shankar@intel.com, mhiramat@kernel.org,
	andrew.cooper3@citrix.com, jiangshanlai@gmail.com,
	nik.borisov@suse.com
Subject: Re: [PATCH v12 20/37] x86/fred: Disallow the swapgs instruction when
 FRED is enabled
Message-ID: <20231128095329.GQZWW4mTdTdmhZ+wS4@fat_crate.local>
References: <20231003062458.23552-1-xin3.li@intel.com>
 <20231003062458.23552-21-xin3.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231003062458.23552-21-xin3.li@intel.com>
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 02, 2023 at 11:24:41PM -0700, Xin Li wrote:
> +	 * Note, LKGS loads the GS base address into the IA32_KERNEL_GS_BASE
> +	 * MSR instead of the GS segment=E2=80=99s descriptor cache. As such,=
 the

:verify_diff: WARNING: Unicode char [=E2=80=99] (0x8217 in line: +     * =
MSR instead of the GS segment=E2=80=99s descriptor cache. As such, the

Just do a normal ' - char number 0x27.

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

