Return-Path: <kvm+bounces-2194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B60877F324D
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 16:25:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 712DB282FDA
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 15:25:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACD9653803;
	Tue, 21 Nov 2023 15:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="gEyYscIO"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A41122;
	Tue, 21 Nov 2023 07:24:45 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A375A40E0031;
	Tue, 21 Nov 2023 15:24:42 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id drDDm86i-tax; Tue, 21 Nov 2023 15:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1700580279; bh=a0pSPzA4YzTjhILwwoujLhIc7aMp0osSFxqzbXIqYJc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gEyYscIOlX6+wyUppG5aTmb6ifnJpO9nqTc0YTlouPrLhK9NAlxcWGTglO5rpeW6a
	 bPcq5i/0niDSIOGT4mQauo0ENmzaaTj1DgMApeINw4U1TuJDE/1IaqXHcNtRXvWVXA
	 qxH3Ii9pnyJbUuUdiuLQoMr6J/0zRA9aumcdAJlk2VXdKfXrAzagDWe/enfYKdExhe
	 kKjUONYwdQFMBnxqYRjHp9iTJR8TGIsZZSlWgzt/cLUVxs2Pp7E/xiggcwqgt+EG2r
	 cBcedfdVjpCkfj8Yjbz/ycV3bRmEZLj5xhttCFGXJUXyRHp6n6xCuvl8+lqjRu92Ta
	 aq8afF6OGmHMezir7DLVbWUAqasz+ysaFXsr6mHpuRprlXnkNZkiVkPfe3WFGN59g/
	 PWWyqSbHNsAfJ9rEw7Tqsuc3a7aUu1GwpCuYoJKubCKKRfDjxz2l8YX4XwTKFJwMAK
	 JFj0WHiXG5IZHiULgNY3o6AgoOeZuRnR7BH1+mi9TkM72GEU5Yny/jZBBd/fmjzRmW
	 cJlbQvZUn3jxKQWGYbbMk775n5JLr5rsFp+Zq35/Xf/v2iPQz1QMhM5A5+Xp+xflNH
	 LCfNhTvSX9oITztDnJ3LbmrKDnkWHdchEfngAF8tkpV7OSyXb4XyLlCdS3/ZQWyrJ6
	 Wsj0dt1yUXgUUysRR3z5d3io=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1ED0040E01AD;
	Tue, 21 Nov 2023 15:24:00 +0000 (UTC)
Date: Tue, 21 Nov 2023 16:23:53 +0100
From: Borislav Petkov <bp@alien8.de>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
	ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
	tony.luck@intel.com, marcorr@google.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com
Subject: Re: [PATCH v10 10/50] x86/fault: Report RMP page faults for kernel
 addresses
Message-ID: <20231121152353.GEZVzLiUK7HY+2eRg0@fat_crate.local>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-11-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231016132819.1002933-11-michael.roth@amd.com>

On Mon, Oct 16, 2023 at 08:27:39AM -0500, Michael Roth wrote:
> RMP #PFs on kernel addresses are fatal and should never happen in

s/#PFs/faults/

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

