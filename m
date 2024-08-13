Return-Path: <kvm+bounces-23990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 75413950567
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 14:45:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 20FF81F2585E
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 12:45:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7D4F19ADBA;
	Tue, 13 Aug 2024 12:44:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA5221345;
	Tue, 13 Aug 2024 12:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723553086; cv=none; b=OVSzewwwR9Dt8e8M21FtThU0bZSKS+H4r9EC02x5t75EdrmJd8dYL8cF9leJB5xORuXHUShC/9BzZnFDCqs0w+zODKHOyKFgf6csuI6vWXFjS5muJc8vq+5t7IF5aS8Sby4KC45A9s05tyLh/eruJKIhnNcE8VtIopiC/GvDNSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723553086; c=relaxed/simple;
	bh=TKWfOWzLWVudQW+3N1D8UgwQTXbcIzRaIJKQiKf9uQ4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=jEEQ9zR+xTigaUUzUGtnSBS9uU7AMymo650IzdXJXbaG4WAIABkrDqKIqDE3K7he/h7IE0h2dBRtudfXcfjQbONrNMOZERU8sCSwUcKRdle6C8fYsv5n3gOXpctY4z+9fuVqXGArEXONyqecIIwGxUkSk47kOoLTqnEtwyixzBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4WjrgZ5Pznz4wd0;
	Tue, 13 Aug 2024 22:44:42 +1000 (AEST)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu, Naveen N Rao <naveen@kernel.org>, Gautam Menghani <gautam@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20240716115206.70210-1-gautam@linux.ibm.com>
References: <20240716115206.70210-1-gautam@linux.ibm.com>
Subject: Re: [PATCH v2] KVM: PPC: Book3S HV: Refactor HFSCR emulation for KVM guests
Message-Id: <172355306298.70508.13351301741599635833.b4-ty@ellerman.id.au>
Date: Tue, 13 Aug 2024 22:44:22 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

On Tue, 16 Jul 2024 17:22:04 +0530, Gautam Menghani wrote:
> Refactor HFSCR emulation for KVM guests when they exit out with
> H_FAC_UNAVAIL to use a switch case instead of checking all "cause"
> values, since the "cause" values are mutually exclusive; and this is
> better expressed with a switch case.
> 
> 

Applied to powerpc/topic/ppc-kvm.

[1/1] KVM: PPC: Book3S HV: Refactor HFSCR emulation for KVM guests
      https://git.kernel.org/powerpc/c/9739ff4887c77a38575c23b12766b0a37c8be13c

cheers

