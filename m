Return-Path: <kvm+bounces-63557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0307DC6AAFE
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 17:41:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 671604E4DAF
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 16:33:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA3143730DC;
	Tue, 18 Nov 2025 16:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="FAl0lKUw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B0B2D5C74
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 16:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763483405; cv=none; b=Qhuk/2VmXioZfXOLwYUGw5ryyp6ejfv+kogchMv+pF/vHJp0oqX48Hl/pWspTeftNY/VRfHxgzzEiGvZyQfETXse7ncWQ/WL4NkPJq7CnK+fvlVP9Y90YHvdNabK1rpLAAScV4KMwHmzHnLOj59vFmGNtf3/u3HgcRwzabVXCf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763483405; c=relaxed/simple;
	bh=A/wusK74GZDLcwfH/DOvStNeBXGSze+rsbfT7gJHkrA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iLJhwDY1+OHKonXvuttbDkv8IjrM3dL7KRVXNgttAyjKO4262z5a6duqW15BMQDOywNNcD9xIqT0SE0VdZVtZZs5pOIm0bSBN+XyXxGYcGTbaiEtx6QtqWtRaS2wwD3OFFcP3O20M9qlPwCTasjiFxxwmVJPKsBsddHnC9Pq2Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=FAl0lKUw; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-948733e7810so216895839f.0
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 08:30:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1763483402; x=1764088202; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0yJdnZ4DgOYRsr7OO5WlWkugNMhOrYa/k9ZrE1rVPkA=;
        b=FAl0lKUwJ7pWpeWsYH0r75H6grdlU3pngCJtULQM3BZKq79u+dM+dv1i0URuIkFLkk
         qrLRQqPsPjHw6TsMQhnYt/VDn3FCMJjQYzMSvza2IjD6LEdEfgRMXjhA8zpWFWnphWwI
         Veq37hOGBDHtlJJmD68r/GIqbNxy6Hkj6ZAe4dmCIqAyq1Ob3BXKwCWvTztOhmp0wL2Y
         cPcRVwrSAW60x1lPU0NASdZ/jLyaWNPKoZkqHq31FrDG/CAhVig3959Pd9DffuOGaGJc
         if7BPs/EUItqGOjqlpQAuL06uqHTJZhd7156vN9PdlvEQKLzAPeeheuNTkcn1SD67x7B
         MZ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763483402; x=1764088202;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0yJdnZ4DgOYRsr7OO5WlWkugNMhOrYa/k9ZrE1rVPkA=;
        b=YO8+PYBYeYYngwnFArKmKd0vOwnjsyprXFfKKT9LHRy6vXYjWDIbupQp+JrPhE1ioN
         GgudsJkDvAisAJJL6qjUeI5g9mZN9zqP8/b1sjj7ZZ4kePLAqZlKTIVHyfaqegksBtdV
         xrVbz6y+k75qjuIU8ENdrPh2wY0JZjz6HE1sQIgp4OiSwI/EHi6oYqTBQfuY7W+g7hD0
         zBBa2U8eFHPk88gKGNMa3hTuNs/J3OBNOjsRHicI0N6n5p9Tdt/Y2z0xGsxFPEs3agVT
         LLfPWY6R7pUXHX2o02r+vLkeBCFqT7QlScrXdiDisl5mCnZU68KIcKW1XeIV2riPTtCu
         YhAQ==
X-Gm-Message-State: AOJu0YzQfnfaXMVUsxQ3eQxTb52GgiDoq0KFQEpAsuIXOFPss0XwXcom
	7g0cJrTRcZGzUDjToG2XqLcL9LrF1POo4M0ENHJTqsSyj0/dug4vztIaGGk5RkZRuZMUDFSjU6l
	ftJM/R4r6CQ==
X-Gm-Gg: ASbGncu0KHzq2sLgwpIUIJPKLfTz08Bmrehs+7VtOplI3LiJgJsODaF7IQDWNOsS3FJ
	rIqJ+sN3XOfSaz/Y/0gzc0rfkxfhoDwA8giCs7e4Puvnr945Q3+PuaP/dfvF25d6yIj+LrJgTdf
	h0n0SotmbhwEtz0QSHPACNMVcHV26iSOhnAO+fdfCuWF/lnbOWDi6z15N7Xmu5mVmar/1Sj+uJ4
	cjAXiMBC4HKfsgnBZRKoMZ5K76eUjm1VaE9fgEOCLUFDeplV+LG8+F2wu2HTU0NeaD7hEzlPS0H
	AN86ZWM73WR6g2M3/ouyWZIl7S11PvcnnKrX+oM7Sf6v9rmpMMylsb6F/tbaOkGGwFjBavgCcWL
	UcPgYpVkboUzb0fJiXTYtXkFv5rFNagWfO/FlLnbw6q/Vmx31HeRgbRefJPtqLrkLUWBIrqVFlH
	eB8g9KBjQI8fV9
X-Google-Smtp-Source: AGHT+IFO5nk5R0BJgVuXU43g2Fx3qxnth4jxvTUDxYg2xc8gEMFAVUev25svr3RR+9DI6xEotRtsyQ==
X-Received: by 2002:a05:6638:a583:b0:593:3cfa:569d with SMTP id 8926c6da1cb9f-5b7c9c2f7b4mr8845328173.2.1763483401550;
        Tue, 18 Nov 2025 08:30:01 -0800 (PST)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b7bd3390d1sm6335071173.53.2025.11.18.08.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 08:30:01 -0800 (PST)
Date: Tue, 18 Nov 2025 10:30:00 -0600
From: Andrew Jones <ajones@ventanamicro.com>
To: Kevin Cheng <chengkev@google.com>
Cc: kvm@vger.kernel.org, yosryahmed@google.com, andrew.jones@linux.dev, 
	thuth@redhat.com, pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH] scripts/runtime.bash: Fix TIMEOUT env var
 override
Message-ID: <20251118-bfc923508a761fc0df77ee36@orel>
References: <20251117234835.1009938-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251117234835.1009938-1-chengkev@google.com>

On Mon, Nov 17, 2025 at 11:48:35PM +0000, Kevin Cheng wrote:
> According to unittests.txt timeout deinition, the TIMEOUT environment
> variable should override the optional timeout specified in
> unittests.cfg. Fix this by defaulting the timeout in run() to the
> TIMEOUT env var, followed by the timeout in unittests.cfg, and lastly by
> the previously defined default of 90s.

Missing sign-off.

And let's add

Fixes: fd149358c491 ("run scripts: add timeout support")

even though that commit didn't document the intention at all, because I
agree with the assumed intention documented with 7e62eeb72fe3 ("scripts:
Document environment variables").

> ---
>  scripts/runtime.bash | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 6805e97f90c8f..0704a390bfe1e 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -1,6 +1,5 @@
>  : "${RUNTIME_arch_run?}"
>  : "${MAX_SMP:=$(getconf _NPROCESSORS_ONLN)}"
> -: "${TIMEOUT:=90s}"
>  
>  PASS() { echo -ne "\e[32mPASS\e[0m"; }
>  SKIP() { echo -ne "\e[33mSKIP\e[0m"; }
> @@ -82,7 +81,7 @@ function run()
>      local machine="$8"
>      local check="${CHECK:-$9}"
>      local accel="${10}"
> -    local timeout="${11:-$TIMEOUT}" # unittests.cfg overrides the default
> +    local timeout="${TIMEOUT:-${11:-90s}}" # TIMEOUT env var overrides unittests.cfg
>      local disabled_if="${12}"
>  
>      if [ "${CONFIG_EFI}" == "y" ]; then
> -- 
> 2.52.0.rc1.455.g30608eb744-goog
>

Thanks,
drew

