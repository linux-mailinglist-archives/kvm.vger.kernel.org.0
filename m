Return-Path: <kvm+bounces-57489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75BC8B55D9A
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 03:30:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CBA937B4807
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 01:29:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37BAA1B5EB5;
	Sat, 13 Sep 2025 01:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NzFHYSp7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A749460;
	Sat, 13 Sep 2025 01:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757727036; cv=none; b=KW0Kfz6LiBzsV1eV+dZkeiw7DbIbaovJWa1Vma4fylL3FUX0H4GkbyNByzH+cOifmAV1JI6vyskVWof5yjqRjjfFb8m9A1f6/IX0+rXOymhUyvIdcuA8ql+BSiBICcfDlkt1UvKk0C95MojxolPR62i+IDQZa2SGzFoTSukyTfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757727036; c=relaxed/simple;
	bh=NqmYTFLNlgJCW+t+zwPLK3FAWSRW5RzSUK74Vz4Mfxg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=JILY0SfDwPDle5F7kmTgSSfvIUPZ9Q3vAybg9ZGUG2TU74UO+NuX89SxGWt5GkrL+wEhuHmTdM1UYqpNWvtzzhcUwbwFfawQAAdxAygb4n/gWo8DvK8nx3TbSvirkLrtj2cslKXiPwE3PmqN51EGVVW9m6j8TOzIE0bKXwCqSHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NzFHYSp7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A4D4C4CEF1;
	Sat, 13 Sep 2025 01:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757727035;
	bh=NqmYTFLNlgJCW+t+zwPLK3FAWSRW5RzSUK74Vz4Mfxg=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=NzFHYSp7YYJ7PISif48D19LeoghOBY9n/DWZRzc9KcYpmPIXH0ZDmsZvAkCRQMbTw
	 S6lnr+UmkVZPoO1v6oNL+xdFIhWUVt/b/gWQOQFTALRBdM4RDORACR/pGxR+1W/uo+
	 0Zu3U2/oANPftZjHgnIOGjDLNaS31Xhusb/G3AXWNJHTyouv914OiyQuO9/Lv/+/dP
	 saCS00n6CpkPZ+0Rple2xNopgnVhRuDzTGpzKStpHcigI9cJd0UfY2/xi455GYmlOh
	 TSW/fmSfvBco1nXWbk0xfRywdpqMRmLQFlRtSbbzxvxLozNomCbSUr7kRQAG27Ymf7
	 uli+XnYJ9mdIQ==
Date: Fri, 12 Sep 2025 19:30:29 -0600 (MDT)
From: Paul Walmsley <pjw@kernel.org>
To: Alexandre Ghiti <alexghiti@rivosinc.com>
cc: Paul Walmsley <paul.walmsley@sifive.com>, 
    Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
    Alexandre Ghiti <alex@ghiti.fr>, Anup Patel <anup@brainfault.org>, 
    Atish Patra <atish.patra@linux.dev>, linux-riscv@lists.infradead.org, 
    linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
    kvm-riscv@lists.infradead.org, Andrew Jones <ajones@ventanamicro.com>
Subject: Re: [PATCH v5 2/3] riscv: Strengthen duplicate and inconsistent
 definition of RV_X()
In-Reply-To: <20250620-dev-alex-insn_duplicate_v5_manual-v5-2-d865dc9ad180@rivosinc.com>
Message-ID: <a0ca072b-74fd-82b6-1e7f-e15183d0495b@kernel.org>
References: <20250620-dev-alex-insn_duplicate_v5_manual-v5-0-d865dc9ad180@rivosinc.com> <20250620-dev-alex-insn_duplicate_v5_manual-v5-2-d865dc9ad180@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Fri, 20 Jun 2025, Alexandre Ghiti wrote:

> RV_X() macro is defined in two different ways which is error prone.
> 
> So harmonize its first definition and add another macro RV_X_mask() for
> the second one.
> 
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>

Thanks.  I updated this one to uppercase the name of the RV_X_MASK macro.  
That way it matches the naming of the rest of the macros in the file.  
Queued for v6.18.


- Paul

