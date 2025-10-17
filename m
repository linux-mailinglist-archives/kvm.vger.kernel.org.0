Return-Path: <kvm+bounces-60348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EF95BEABC0
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 18:32:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 49ECD5A95CF
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 16:21:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90354299957;
	Fri, 17 Oct 2025 16:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="XmsHA4iR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE442857C6
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 16:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760717842; cv=none; b=NmOwYO0/Od+lxWvG4UGE9vA2YmBL9t2Cva4i8/KZOD/oDT7B5qMBrP4oUYgL1ZoMKxpVhdHqKeHJTjqHXSbonrhetSmdX3rB7NIm7FuDxKnp7/zrYWq9ngtBSP2F9G65fMCVXCA7DOZucx5ugbCScBbGvduaH8ZTInRgRdNDpxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760717842; c=relaxed/simple;
	bh=pPbWyGESoeFda9PL7qjMzI+KDFiJUk2WW07WgvOC0eo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mLi52WJnTN2USYuXTMgioIID3T50bAsrijv3fpxCesbyj6y9OaRXC0qLQpu9ysPlvIC5f/v9jGKepzHkJ908zbT85gX6rrUkf8r2TT+wWwA8Km4MdUh/yOLF0646t8WR2IRG8dSy1tNaFHltuEH/9DRdnv1HLTpsMwZu7i8VufU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=XmsHA4iR; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-430b621ec08so18106755ab.0
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 09:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1760717839; x=1761322639; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SE59U9D9FBD2TsP2y/MjrBzEhIdNihINvSqWeLt6f7A=;
        b=XmsHA4iRMCoUXkqoAhZz91mStbZj7/xZ0iyoONrFgdOm+jKx2lxaEn9Bc9f0rGxOuf
         9TISpV5P6qO8uTPgf6zJCqv+r8fhg8OVHCKf6oJGNjc16iBIiZt11YPTbnFmz5Xe+5kK
         IXUHAFPnBwQ7CbtyhIULtonUKMoPq0CMgcCRSo2Kojsn+wp4m+bCSRXg7Hy0QftbjPHP
         RXvTCpWz5U0Xp2XxOlKCSMfgi9TQQIm4V9f2ItyBVPkqA00asRhSutVjKgSy4vVfcBDH
         nQyIKlJZDPZ1c8LrumBep6Im4uutjqMDVxG6UV0fOiRHzuXkaVCe0yTODZhTSn8kN1xX
         JMuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760717839; x=1761322639;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SE59U9D9FBD2TsP2y/MjrBzEhIdNihINvSqWeLt6f7A=;
        b=uXxKk1eDflESMg1ds82hb5O+oIvVzSl0Wh+A++5SkePI1SwxXd7fkAwtUqQcX+O3iG
         ImcQGp5fLDdjVpyP1jA2iuWxZC6brtAA0LR+uhEE6B+HgSVdQ2crAMHJOKjKUkQ9yYVS
         pmbAzE8JYV9VOWPykwUfEdP1fFdQFLoUhOT6PeOpYci1CwJZ/dHEXWqxY8WY0HDer/s4
         7WU4bEwo9r7yqn7r9Mc0t5s9juudoPYl6WAKhPPrwAo/r2pJzrXY3ML6oYOGLizbNh5B
         /UO89+KyzDqLW0Qz7U/9vAkQY159beM4dB+op15NTcvfv9nAR602AYnisvt97BG4oLgD
         8clw==
X-Forwarded-Encrypted: i=1; AJvYcCVwR9Asd39eG9RfcCEW+IjLkx4CMnS2tZueR/UoTcqANg5VfpQBa7MmTPK5D+dARHR9Pz4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwYJCdJ3Gz7QG/4PFAZc2YoRwnd8nSmOE/P4r4AoPDhg9Jrc1j
	LiY5p727o0vgcsNg0EO9+ymQxUo347URYu3KmvFMlLNfb/h9z0ssugesHLRVP+G1lA0=
X-Gm-Gg: ASbGncvaRMYu12JM6uyEQMzjlvoubTq2wH0Gt17GUDULa14vFFWt7rkL/Jmcs51F1HO
	Yb2xBQ842sJ7l8QdD0r6MoIL0hZ9qUd36D0Pag3fNTNwblBH3QOPiJcJ+H/Gk/hGC2Jl1DPoMgT
	2Ey1RvwK6Q5OLudrbIcQbCOjUipEZn8kqhUmd2dvm658ovzXRBcJz2KnOaNWZ7f5cgyjySfe22N
	QAfkGnenJR3NbFCd15pjONbsDmd+vUUQ9bD9ChyDjfaGRpE8HgaakPVSE+sEv+u75ZIbHxe9J2C
	TgHqMWhZla0lRqhtbL3K4gBCLEInU4/1YacqWlAefwcWeXj28NuK4rTN17GV7FZbEkD0Bg1JDHx
	ofMJDAFysm9RcooA5C3Mv+1fTtcEuKAQYMDWUTMIdvaekRp7rSpiUQdd29qiQTJIfD/kII9mRbg
	RR0w==
X-Google-Smtp-Source: AGHT+IE/MHK6bGWFUML6lB8EABvgh/StOgVAz5yCP4m6sZL2slTHOrBxRy/hwICm8V+ly8yQelL67Q==
X-Received: by 2002:a05:6e02:b44:b0:430:ae1a:3375 with SMTP id e9e14a558f8ab-430c529df57mr60456845ab.26.1760717838760;
        Fri, 17 Oct 2025 09:17:18 -0700 (PDT)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5a8a979ab14sm8576173.65.2025.10.17.09.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 09:17:18 -0700 (PDT)
Date: Fri, 17 Oct 2025 11:17:17 -0500
From: Andrew Jones <ajones@ventanamicro.com>
To: Anup Patel <apatel@ventanamicro.com>
Cc: Atish Patra <atish.patra@linux.dev>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Alexandre Ghiti <alex@ghiti.fr>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 2/4] RISC-V: KVM: Add separate source for forwarded SBI
 extensions
Message-ID: <20251017-68a09a4da911ec4eec058592@orel>
References: <20251017155925.361560-1-apatel@ventanamicro.com>
 <20251017155925.361560-3-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017155925.361560-3-apatel@ventanamicro.com>

On Fri, Oct 17, 2025 at 09:29:23PM +0530, Anup Patel wrote:
> Add a separate source vcpu_sbi_forward.c for SBI extensions
> which are entirely forwarded to KVM user-space.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/kvm/Makefile           |  1 +
>  arch/riscv/kvm/vcpu_sbi_base.c    | 12 ------------
>  arch/riscv/kvm/vcpu_sbi_forward.c | 27 +++++++++++++++++++++++++++
>  arch/riscv/kvm/vcpu_sbi_replace.c |  7 -------
>  4 files changed, 28 insertions(+), 19 deletions(-)
>  create mode 100644 arch/riscv/kvm/vcpu_sbi_forward.c
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

