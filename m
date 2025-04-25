Return-Path: <kvm+bounces-44257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 101C3A9C000
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 09:47:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 00A791B8666B
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 07:47:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59E062327A1;
	Fri, 25 Apr 2025 07:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="BONzwATD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE0D22D79B
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 07:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745567189; cv=none; b=qBCwAN1QVobAsApL0DBweMK451fkMw35DHnEPDXW0IJXANzvRhQ8/b5zvbwCZfJbPkSxy5bl4u6CLA3dvdVgJ14gz3z33B1h8d3CyuzKDfRFDKVjcCj/NHHy26eh173QhUESozqY2y4bZb3EhpxwWlLB6tYoIFUj+znxjEB9mMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745567189; c=relaxed/simple;
	bh=M2e5e0DbBcCkM53d/193BeEEWoXcJicJMcob4XfVxtg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=imYs6Xd+8kiQxTsyE2yxbm0AYQKLIfZBSzW55Pgsj1cm2TM1FrzmAn21P4z6mrg7NBnkwoZ0qXZM+wG7VKf0NFZeqQW4m78sjT2cpGjZ1JnChdq7Y02BXReBc3L0MIbvHhIAUgEnl8EqUsSTFXXkrJLDojxOdyG9Efboe+NfV/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=BONzwATD; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3914aba1ce4so1425152f8f.2
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 00:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745567186; x=1746171986; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yalr6Bu93K2GzLCvN0XHCxzUAzn2mCxagWptxLA843Q=;
        b=BONzwATDn/a2Jbfl2U/CRNZi6nvEygafRicZHs3E01vwo9Vk0ZH7vrqo9dHe7NAp51
         gS/di6U0SsI2y61hjPKlZN7hHtXGxxQCTYYAVie4dgOUhY+Q7N3WXWFsB8YN55Q9i2i2
         JTzQUtB+zF67/ain39qAEr9FBYWqwsQRfg+iIHrIaZ3G2odO5yQCBtr0IUMml9EP1bDq
         pZpxlieYZmifYhKjSmNVmUmK+dOcxlcC/l6OdbaAssA4ntsgHsMXAk+SWpAskvjBNyul
         8HHDB+GtNKM9Hs8rpxZeaAHMHyn9jyBJF3Jq+0ww5ss/Yx9ZAH3k/OAESYnYn+todGiu
         X7UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745567186; x=1746171986;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yalr6Bu93K2GzLCvN0XHCxzUAzn2mCxagWptxLA843Q=;
        b=kmGZx6VkWoMhkJSJFJ9QjG16Wq6nn4L5wX92sTBgOO3L3lyyV2PQW7I67dz09mSCiK
         H8LnlZlLJT5By+xzKvgSZ5StWA3hi1cSccYTioOqSNovIm9MIO/Nt+JM1vV5Zk4E1hJM
         7KyFNiVHzPKsqeE9kmK5O01zvjXBAPpqnKp5gN5FyyfkVhp4Uob13YvoHzdJAeigfGzp
         V2RIkeNITa6dRw++lgx9DX9BD9WIBbAhaXfXqyTVYW44hwU1bg7RHKVkp4E+UBN/N+tH
         9ErVhnatee7tqo5fjH+1xr1SbP1WFpnjA7IYKlprTALOBBVMk9+XgOIXim6VM8sH/rAd
         QW2g==
X-Forwarded-Encrypted: i=1; AJvYcCVZGaRs4OEz68B1vCz+ZgC1HGMczxL31BCoyhfFR1Ye2NQMbWrOgbUk8MoDHz2WInaqR04=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBLP81xoh7FHLNopJc/xFVLXAClmcH6fBxg1ph255QbWeJwC82
	cpFhHjDfrsI/3PmmKL/qHuH/oPhnYvREy7a6yK5fKZOZstmIG+bFxBQ5+lxWdtY=
X-Gm-Gg: ASbGncuoA096cUKYZyLXUvXPcJ+1ATAZ6/X/NJNhScSkkGAyc3uwMb6+vMCFepNeFlS
	M2pOSyCtPeJea8ZwKNXMHHS3TwEvnEa6nKg+f8rO7do+7wExkvBtFkuQXbhlqq2eu2hNpQHRF5a
	1dSU/C3MLDfd7iL/ARso8qewiflBGcJlETIb/7bIyKzZNbxuc4YmWwu/PPKC/idMs+PrnOxP9d2
	rR4vt371FG24NvPlG4BQIXWYRhaJP08CUurqXB+8sD17Ct/gNk3JsZ3GrbMajwYlxxY78gXF0Eo
	dq7SJfEoO9lDuO+LGuc7LEjSpDM3
X-Google-Smtp-Source: AGHT+IGuKsjAp/bE7iMICTe5tl7fZLkgjjuJMOyAsBGa6hvpBqMsjN2EfsDi9JbPSKmGTEeYZJEdtA==
X-Received: by 2002:a05:6000:4212:b0:38f:2ddd:a1bb with SMTP id ffacd0b85a97d-3a074e144a6mr901505f8f.8.1745567185228;
        Fri, 25 Apr 2025 00:46:25 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::f716])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a073e46c23sm1496676f8f.75.2025.04.25.00.46.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Apr 2025 00:46:24 -0700 (PDT)
Date: Fri, 25 Apr 2025 09:46:24 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	Samuel Holland <samuel.holland@sifive.com>, Deepak Gupta <debug@rivosinc.com>
Subject: Re: [PATCH v6 02/14] riscv: sbi: remove useless parenthesis
Message-ID: <20250425-00fafd9027c5b1be3dd1d78e@orel>
References: <20250424173204.1948385-1-cleger@rivosinc.com>
 <20250424173204.1948385-3-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250424173204.1948385-3-cleger@rivosinc.com>

On Thu, Apr 24, 2025 at 07:31:49PM +0200, Clément Léger wrote:
> A few parenthesis in check for SBI version/extension were useless,
> remove them.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  arch/riscv/kernel/sbi.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/riscv/kernel/sbi.c b/arch/riscv/kernel/sbi.c
> index 1989b8cade1b..1d44c35305a9 100644
> --- a/arch/riscv/kernel/sbi.c
> +++ b/arch/riscv/kernel/sbi.c
> @@ -609,7 +609,7 @@ void __init sbi_init(void)
>  		} else {
>  			__sbi_rfence	= __sbi_rfence_v01;
>  		}
> -		if ((sbi_spec_version >= sbi_mk_version(0, 3)) &&
> +		if (sbi_spec_version >= sbi_mk_version(0, 3) &&
>  		    sbi_probe_extension(SBI_EXT_SRST)) {
>  			pr_info("SBI SRST extension detected\n");
>  			pm_power_off = sbi_srst_power_off;
> @@ -617,8 +617,8 @@ void __init sbi_init(void)
>  			sbi_srst_reboot_nb.priority = 192;
>  			register_restart_handler(&sbi_srst_reboot_nb);
>  		}
> -		if ((sbi_spec_version >= sbi_mk_version(2, 0)) &&
> -		    (sbi_probe_extension(SBI_EXT_DBCN) > 0)) {
> +		if (sbi_spec_version >= sbi_mk_version(2, 0) &&
> +		    sbi_probe_extension(SBI_EXT_DBCN) > 0) {
>  			pr_info("SBI DBCN extension detected\n");
>  			sbi_debug_console_available = true;
>  		}
> -- 
> 2.49.0
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

