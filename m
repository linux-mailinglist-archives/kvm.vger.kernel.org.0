Return-Path: <kvm+bounces-27375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F2629846A5
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 15:20:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F5CF1C22DFD
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 13:20:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA7251A7265;
	Tue, 24 Sep 2024 13:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="FinKvE8U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42553224D7
	for <kvm@vger.kernel.org>; Tue, 24 Sep 2024 13:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727184046; cv=none; b=BuYzjqHtiK8CEKyoUrYsxkMiJ4HCGy5RhVU2iuEgpj20axixPj2eaiP0GkYU+UgwVSCvpiIcq+8L8WKAmob0lRo/ig7dwRdLCkVw/tO8riYUmZpoz7a2e8DfVtm3uDT3cy1rlNtSTbC7OCakqOX8mYwqVF4sjZPXOHeR97FD7pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727184046; c=relaxed/simple;
	bh=lvmH4HaUx+74z3ec3XE/DxrqOVnr2l6za8I8hUi4no4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M2Gdh4/uwZi5+L9qeHzfPEmxd1p8ecPbnji5wBtSDgtSpuCvz7Y0cqkIWbtX7X66pmN4aN/3WLb0seMF36xMvWGjV3KJGqntdddD+fY5VrzcqwFHX4RpOOMy0XiKvyWa8MeSod+WnMJyUVSxxGJXzpszqNGQbL76FVaUPUHKwlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=FinKvE8U; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4280ca0791bso54346105e9.1
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2024 06:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1727184043; x=1727788843; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2S1bo2mNr3KzTgDLUOXbWE6BvhWr9g2AE4hb9LNj6os=;
        b=FinKvE8UniRG25gctdDSHkEzD0kERLFecX4DUVPz0ThziRR5GHRs4EUgd+x08TNsT1
         O5E4UZu/xjXAAzxfKH0v6Mj4AkCMfPGbFaumx/ZvSo5p+PTJFOsHjP+JOQ4EUkrDwul7
         R7B8xUtwCsy9hdJo2sZWuiVF/1YIWlBvPB08m55PEhMHJyBmGeRCAX3hhlorDWMA5NFk
         LjTnETaI69cqtHeATVcP0YNky1TiU7p4ctO92m2GBOV9sSd6VEYdoTL/nPZJWkk6OaNL
         QrRTuyiNhl+rdnuNAfGo0TZih/nPk5nrJNkEDKG8EWDT6rRKPr6TudkV2DJNl3HlFB70
         pSkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727184043; x=1727788843;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2S1bo2mNr3KzTgDLUOXbWE6BvhWr9g2AE4hb9LNj6os=;
        b=dgrL4CgnYDY1vFt5/cBCS9+ptoFmt4LDVzlhKFbGdBLc3UaEf4UUMHi/COaNIe/Au7
         oeJS2GzIZMtSWmXkfvLy1OW+GGPug6iuxErVDtDgk/ftMiaJG5D6JuFlDtOk0PIDJeI3
         XBS3RR1biGJHULmVth5Di161dvHo9KfbvAcVoFjq/0XhafWyl0Om2Dr/aZbyUHIZ0xMo
         HkjKZZt6NMe5U6Tp4I6ZXL4eGt0sCpitusDuCYxAxuaXrjERfs7X1CJf8U9P68GwbWmR
         KJhYW+Enh9qSR7+Ob1YbK+03Ub/Z/BxakooD3rcTQOWBWWdYbp1JUN01cegZSEVNddF+
         LfdA==
X-Gm-Message-State: AOJu0YztWUe3wc+Idsv63I64om3PXAkWxUCMeXA1L5hzadqA7fqh28PM
	4lWKI6uTcQewx09OrA3hUWHB9vY9Vgn10TSeQ7gt1csmNolKs/Iff7Q+h6KVbEQ=
X-Google-Smtp-Source: AGHT+IFoQcNlNyRkAZ6sb9cku200jbPKtAjNoBvSTkl5nh1juxPfExr0nfqH4fe1NAtA+zAFoI0TmQ==
X-Received: by 2002:a05:600c:358b:b0:42c:b1e1:a45b with SMTP id 5b1f17b1804b1-42e7c16ed53mr112796865e9.19.1727184043381;
        Tue, 24 Sep 2024 06:20:43 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42e90291c9esm22463685e9.4.2024.09.24.06.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 06:20:43 -0700 (PDT)
Date: Tue, 24 Sep 2024 15:20:41 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: zhouquan@iscas.ac.cn
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, will@kernel.org, 
	julien.thierry.kdev@gmail.com, pbonzini@redhat.com, anup@brainfault.org
Subject: Re: [kvmtool PATCH 0/2] Add riscv isa exts based on linux-6.11
Message-ID: <20240924-c48e643c4a7a77c47b784fd1@orel>
References: <cover.1727174321.git.zhouquan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1727174321.git.zhouquan@iscas.ac.cn>

On Tue, Sep 24, 2024 at 07:03:27PM GMT, zhouquan@iscas.ac.cn wrote:
> From: Quan Zhou <zhouquan@iscas.ac.cn>
> 
> Add support for a few Zc* extensions, Zimop, Zcmop and Zawrs.
> 
> Quan Zhou (2):
>   Sync-up headers with Linux-6.11 kernel
>   riscv: Add Zc*/Zimop/Zcmop/Zawrs exts support
> 
>  include/linux/kvm.h                 | 27 +++++++++++++++-
>  powerpc/include/asm/kvm.h           |  3 ++
>  riscv/fdt.c                         |  7 +++++
>  riscv/include/asm/kvm.h             |  7 +++++
>  riscv/include/kvm/kvm-config-arch.h | 21 +++++++++++++
>  x86/include/asm/kvm.h               | 49 +++++++++++++++++++++++++++++
>  6 files changed, 113 insertions(+), 1 deletion(-)
> 
> 
> base-commit: b48735e5d562eaffb96cf98a91da212176f1534c
> -- 
> 2.34.1
>

These have already been posted by Anup [1].

[1] https://lore.kernel.org/all/20240831112743.379709-1-apatel@ventanamicro.com/

Thanks,
drew

