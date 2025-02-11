Return-Path: <kvm+bounces-37838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1603DA30AAB
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 12:47:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F1DC3A9782
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 11:45:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0424524C692;
	Tue, 11 Feb 2025 11:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cy5xeCzT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150691FCF6D
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 11:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739274025; cv=none; b=DxwIOxZkxU+nKn7ypDJbIxLkyuXQT2IpMPiAgejzkU73cBwJ6gezRUF3vzZkslHmAVwMQpeKHlv9k50Oe8IhUPldpxuCCm+8PEZf5nsUSAXh5hzSqJAtEdrM56vJEpT9wLN/v3RiEeXg10nXhIzYZKmdpDapzSC0qbzCR8IQe5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739274025; c=relaxed/simple;
	bh=pcp80HDdGNyyYRaaTFdwe56MotwaveT/iimpr56ihOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OQD/RhhYScHZl6jgFBpguPkknuEX559Jk8XXe3BwFt/4r9BkpInLhPshQ8YGB3j5DqufAMZuiSskILlTwuBVx0MnYk2kR5RO5NRrTKICt8nGfyrJSFXnHYMXjCZkqCEAvEF76hJryhNk9nbulJszNGYxzcu34p6PlWVK4uHEHJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cy5xeCzT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25A0C4CEDD;
	Tue, 11 Feb 2025 11:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739274024;
	bh=pcp80HDdGNyyYRaaTFdwe56MotwaveT/iimpr56ihOI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cy5xeCzTYMkmLEDYlILUUKqPc7p1JV8E+KtZk8TykHU7kMs8fTRJ5mryIJUzX1jhH
	 frPKH/vVGyU8fxN9xKReULQV0NjXeo1EVW/mSekhnG7MwFpgENmcp+amqVjvuLj8Li
	 lfTWE3YK1T6yZvvt8wV7u4IFQrLaz3VYFq0S0Cdt3t54iBKeceDUREuQHMGWInrc0X
	 kno769aq+IbO/kvSP9/pO76n9ThJjiQycDDVMD8aZ67neJGiFzPSGNChSrftVIZweQ
	 lR49dM/OEsGktZuvApa1j0sl6YX6wS575D6l+tpNQkukpGSiab5I70VQgV6dbnK3FS
	 OcJxipNAgQtxw==
Date: Tue, 11 Feb 2025 11:40:19 +0000
From: Will Deacon <will@kernel.org>
To: Anup Patel <apatel@ventanamicro.com>
Cc: julien.thierry.kdev@gmail.com, maz@kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Subject: Re: [kvmtool PATCH 2/6] Add __KERNEL_DIV_ROUND_UP() macro
Message-ID: <20250211114018.GB8965@willie-the-truck>
References: <20250127132424.339957-1-apatel@ventanamicro.com>
 <20250127132424.339957-3-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250127132424.339957-3-apatel@ventanamicro.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Jan 27, 2025 at 06:54:20PM +0530, Anup Patel wrote:
> The latest virtio_pci.h header from Linux-6.13 kernel requires
> __KERNEL_DIV_ROUND_UP() macro so define it conditionally in
> linux/kernel.h.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  include/linux/kernel.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 6c22f1c..df42d63 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -8,6 +8,9 @@
>  #define round_down(x, y)	((x) & ~__round_mask(x, y))
>  
>  #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
> +#ifndef __KERNEL_DIV_ROUND_UP
> +#define __KERNEL_DIV_ROUND_UP(n,d)	DIV_ROUND_UP(n,d)
> +#endif

I'm happy to take this for now, but perhaps we should be pulling
in the uapi const.h header instead of rolling this ourselves? Ideally,
kernel.h would disappear altogether.

Will

