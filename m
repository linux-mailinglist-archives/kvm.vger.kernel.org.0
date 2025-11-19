Return-Path: <kvm+bounces-63730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C9561C6FB56
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 16:41:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B84EB4F5FA3
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 15:34:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62E9A2E62A2;
	Wed, 19 Nov 2025 15:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="H7jagQq/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f193.google.com (mail-il1-f193.google.com [209.85.166.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A82C285CB6
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 15:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763566453; cv=none; b=TQpylZ5IV3m+uwPaKdBY9EgYHiGsNi4cwDqgb6l8mamatr2XPA2PxV2UJs5PxSSDIEXHBtVY+VtxG3/blIfoM72HYQ2hTzxM5blq0LRDzFUUJYSWoxfLwrCQrSa3sZ+RJt7JOUO33VMz4yRMaKtdfOwojXI/k1Ij9fkm5KpQ9uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763566453; c=relaxed/simple;
	bh=4lQdeVY3VH2QJZwcwd4g5IfjGuUeNy2yw6QUZDY5VCc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kE1XuDVzCcblmlqumugB/TekEZOk3+QnSllGqDTcFF6EaOAx9zHy9MNy18j77nBN1pMKbe7ZQYY3CZoTn3FpHBvXxoaKhAcc8PWWFJ6nRsJkFVR7kS8+GBAiGTLvlkEdM9vglEx6ZyJJd3oKtS7dABQSs36/NzM0tOzd6zcay+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=H7jagQq/; arc=none smtp.client-ip=209.85.166.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-il1-f193.google.com with SMTP id e9e14a558f8ab-4330d78f935so41937245ab.2
        for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 07:34:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1763566450; x=1764171250; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=w1fdpJ5+3GRFj4jj6xIs9v9Fo+svphOHx6XA1rfUhj4=;
        b=H7jagQq/SgpA8Lbz+QghJSKw1NxhPfm0n6GHFTkNmAVYO5r0FctpLKBDe5VqFg/Rq+
         q5+vBhHSvC50BQXbFV+ihrDJAJPsvn4/er/UbTlHFFQZzGATsH+iYqtguS4h5O6Tt+Pu
         d/OlIoVGAsq3xckf0QzRcXp+bSYDMZ1nmwURoPaGaZSeskSQUiiWmqxXD4X6dDryEtKY
         BNF1exs6VDGGZvaPKKlV/KrPUTfDoqQumK8ZhUoUU1tKHKd2/J3DxatcSPHH4UsCOUse
         +ytFTmHorTZ+29h4mh6reRL1RXW9N149gW6oZXHFToaj9u8U52iLFg4JpH42FUyDa3/k
         QLKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763566450; x=1764171250;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w1fdpJ5+3GRFj4jj6xIs9v9Fo+svphOHx6XA1rfUhj4=;
        b=tSmbXXnDHJ1DdxFs9SuT+k4Z9blBJMM9z1TgUisLkrrJ6AhLWZ/pF7mXAc4EQHyeam
         +Db4b8wrn+0A1XFOOIrpV8M1XtQQsX7ZoO6tWBrxXO5h+nuKiVAqPiyED2HS/7WNcIvq
         b0F2RxxzuEsVMjSqGfRQiyCyvI6/qNAidw42sB77AfV5lNO5wPN5hoo9Uu4SJ/E+DvEN
         S5iQhm3itmE79f5xgJZMzdBNSx6x/08bWc/TlLUB+rA0f4fEvT7VNsJnmEkKShHkT9yd
         W1z6csIyen/Z5vbFl1VihqFppgsic1tsuFdxGkQQ7MWwCkMBOSQ26aETeUsXJWMN3txa
         26bQ==
X-Forwarded-Encrypted: i=1; AJvYcCWiMp1CDtWceEYchTNI6f0JQyt0ccRh+yosc/IzUFhh3NneDZrh91JBeirphDtJ0j7vYC4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvvIbuww0EmX2rElzbAVFdzJZIPd71hYvma7EGxLbNGYYEZz2v
	Dbn3PMvNF/xYt2kxCDlELBApZQBuuBmfdHjNk27S6EhLlv7lww57MpKX+ko05qz4C9k=
X-Gm-Gg: ASbGncvNUHEs8sJXYZwrHM1VSfaYUwEYwRxNtutfuYh0ukwa1oth7QpsBNyOIToZmTt
	pcoOU6ldyGU1aZlW29sTcTbA2edy1bEkahoy9SQFwZlKDt5+yBzQ4lMXkMLS+ssc6Em6KqiJQCp
	3DAvRx0ouwB3r6dOVvXRRKHjIAnWvohGdXyxph8DPbfMC0FSKaoc0yDoSj09erz5r7+S2Kz3l+b
	5snIPbaf5htchgaevf3+UR74/twMDHA3Er16osOpxxLBljCWJ/IRGeuHNMw5KdMUpVSIs0PmGXx
	IXAJmG/zfrB1gukytoCR4GjMZDT84WxrSqf1BLoxAarauxYQ7SQAtzhtjbIv3P/498MI3ZypzL+
	WcvGVrH/rwRn9eFRbT6LqvRZ2aFKJVRnbo5TLRKY3BeLMnY5zcMJd6g4dnctbNa+RVmtOHuyG6y
	eQNSAOBgA/A2Nh
X-Google-Smtp-Source: AGHT+IFDJZtgEmU/xKXBdBPh5jPVgt8DpT4PjPif1o0uBgO5oq25Qtiwdew7mHjWGTM8edF4aXD1tg==
X-Received: by 2002:a05:6e02:188f:b0:433:70e2:6292 with SMTP id e9e14a558f8ab-4348c942ed2mr244853635ab.15.1763566450054;
        Wed, 19 Nov 2025 07:34:10 -0800 (PST)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-434839e29a8sm98129465ab.34.2025.11.19.07.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 07:34:09 -0800 (PST)
Date: Wed, 19 Nov 2025 09:34:08 -0600
From: Andrew Jones <ajones@ventanamicro.com>
To: Joey Gouly <joey.gouly@arm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>, kvm@vger.kernel.org, 
	alexandru.elisei@arm.com, andrew.jones@linux.dev, kvmarm@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v3 00/10] arm64: EL2 support
Message-ID: <20251119-7493c53b2b8e315d7556f699@orel>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <20251119131827.GA2206028@e124191.cambridge.arm.com>
 <D63D4CE9-431B-4F76-B769-C4FFB37B76AF@gmail.com>
 <20251119140224.GA2210783@e124191.cambridge.arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119140224.GA2210783@e124191.cambridge.arm.com>

On Wed, Nov 19, 2025 at 02:02:24PM +0000, Joey Gouly wrote:
> Hi Nadav,
> 
> On Wed, Nov 19, 2025 at 03:48:13PM +0200, Nadav Amit wrote:
> > 
> > 
> > > On 19 Nov 2025, at 15:18, Joey Gouly <joey.gouly@arm.com> wrote:
> > > 
> > > On Thu, Sep 25, 2025 at 03:19:48PM +0100, Joey Gouly wrote:
> > >> Hi all,
> > >> 
> > >> This series is for adding support to running the kvm-unit-tests at EL2. These
> > >> have been tested with Linux 6.17-rc6 KVM nested virt.
> > >> 
> > >> This latest round I also tested using the run_tests.sh script with QEMU TCG,
> > >> running at EL2.
> > >> 
> > >> The goal is to later extend and add new tests for Nested Virtualisation,
> > >> however they should also work with bare metal as well.
> > > 
> > > Any comments on this series, would be nice to get it merged.
> > 
> > I wonder, does kvm-unit-tests run on bare-metal arm64 these days?
> > 
> > I ran it in-house some time ago (fixing several issues on the way),
> > but IIRC this issue was never fixed upstream:
> > 
> > https://lore.kernel.org/all/C812A718-DCD6-4485-BB5A-B24DE73A0FD3@gmail.com/
> > 
> 
> I haven't tested on real bare-metal hardware, I have been booting directly in
> QEMU with both .flat and .efi.

At one point arm64 builds worked on bare-metal - I added commit 993c37be77
("arm/arm64: Zero BSS and stack at startup") as part of that effort. I
don't know if it still works, though, since I haven't tested it in years.

As for this series, I was hoping someone more invested in arm64 would do
some reviewing and testing. Then, given we get some r-b's and t-b's, I'd
give it a quick skim and ship it.

Thanks,
drew

