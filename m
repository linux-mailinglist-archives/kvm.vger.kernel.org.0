Return-Path: <kvm+bounces-40919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 944DCA5F43A
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 13:24:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 056E53A1DE6
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 12:24:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6096267390;
	Thu, 13 Mar 2025 12:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="EbCTWpuC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C65266B67
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 12:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741868688; cv=none; b=tN4ZYD2anAp/0sx3SJ/xyCTiNrDbHG7x4mg+9S3vOub1WH9S1OPgOD30viON/P7SgDyUontj2WHNPqkfQ+bZqdWTx6xjcGVMlzpoxbzxwX09EPN2c990OZZsP1fNreklFBc4jX5AVLumI7hV0E9Gg38zSFN2Giq2oZud2NidTxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741868688; c=relaxed/simple;
	bh=qUINEFrGdyqtUCxJgPIIWVSKNSceW/vG2w99VTb0EFQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uZw0U3W2QOh3HarP3xL/bBKMYQ5DxZDoZa+zMelUe2Hgps23vGZrH2hB/6W/KzuPxbMB7zclpuCoZnlNnQg1p3u2li45o2NDIepJKrZfWH0HLMyQVE8/ZHXUkYhjYg5MMgQfYOKriD9v75wFs6+BM3FpDRO+3HbtmOKeKoVz1VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=EbCTWpuC; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-388cae9eb9fso457723f8f.3
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 05:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1741868684; x=1742473484; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jdwK1Zh8ZZo6rwDf542VaxRAlTlQ9sZFdzOTXwzDIRU=;
        b=EbCTWpuCIEVmrusg4jm7PmZ3G9kQr3/k9FBQmvZQ8D7L9OQ+iISsTbF2CI9I7Bi7gG
         bkXR4Csa9wQus0Wn3s8RDbygCrSwQoxc0zR4YNMOspJKsGE+qogTlrrQv4/JIgdiLaQC
         srHIzpaxhUnaPIR/rbJblHFnLgfoenOWhKitdtVdX6uHq24OQ/Jk8asZPuloMdH88Gcb
         PwABAp+AOU8lCJ61EKwfQlNMR9F8nIEIwMFNi4vwTZIMkosSsHDu5x3I0O/zvJuFQpZQ
         CTaTAXGf8EJm2gSbBuYUb4oq4aKf0bSHvrfQou7r10dsjUH3wz5o/1X0jX53FbeEL0Ws
         caHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741868684; x=1742473484;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jdwK1Zh8ZZo6rwDf542VaxRAlTlQ9sZFdzOTXwzDIRU=;
        b=Qdn6N+4/AOPAZm93bmnRRK29dwQlTaAJYqK5aNZG1P9k9Vv6ktT+VCJgny9pjH3z7N
         lbV7HNtkfLsTOiedKxW06y1lnZn4UDwoLCkgdinJoLNaHnCCl06NvGhiDWeFjF7eAhEU
         4EYDw5i7J40jAXFu6p+pgjQf0lH99Js4HKaes+YQEe32aBIQkk7aYCkglCbNIDwt1pUi
         0F5qG1kjewlLSOYVPhoC+oCc8EgFqM0iBk8oAyGsgeAp1ozwg9DLSCdtSfXOkgQYqjtG
         K1i88T+z46BP0oJv2SbsD8yyy3HK+Qzbxq5vdrcqFfF/N7pcsa+EbxgP5IKqUEFd4mTs
         iONQ==
X-Forwarded-Encrypted: i=1; AJvYcCXBK2ATm2viHpr/hdqiRoKKFXVSpiT48XsWPHs+2m0N1FrVBjNsnGUQLsCiG/akS5w3G2g=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCR0SbaskCw2idDK4UxYQEXmz06ieYp1GDTmkEMUwUR9+V1ESs
	gikVX/ZnFN/BSg3BVYEdqYKjL1f0l7mCLCt197DJX1lXPqtozOpFV3xbGb3f2FA=
X-Gm-Gg: ASbGncthxQggRXbwYQW/X2hfJmmQMEN8yKJwJI1fEygzgPQZ8p37iDHkynDadnMT+lM
	erC/G/xVqWgqeTE7C+/nQ2sN4jgSwbfxNQROxcVMwGkq4NqsqsPcRi4kzJ4FFJn4JzNdO8V0ZnH
	SdCpJp/NY6lviOvowILkALSXlSJTGp+6EISrKzMhjDT+JnISqIdkug7r9h2oyzm4XuPD/1XOCNB
	WtaTZoBHSrv4V4l1ZYPZXXjeM87uzjv9JmcHSBom7iksg5W5tFo310kVqhauwZwB4lPhbulwDbm
	w/cmzR1sUIWJDEqFTCRBqguNA8YH/rtd
X-Google-Smtp-Source: AGHT+IHTTFdUMyPE8J6/FJ/Tz2TmgEnvUPiqAP3Vg4LJA9U623EyzHKoPA3QMg0KCVbZ9Z4v0fkfMA==
X-Received: by 2002:a05:6000:402a:b0:390:e5c6:920 with SMTP id ffacd0b85a97d-39132d22aa7mr18761264f8f.3.1741868684583;
        Thu, 13 Mar 2025 05:24:44 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::59a5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395c8975b90sm2006325f8f.53.2025.03.13.05.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 05:24:44 -0700 (PDT)
Date: Thu, 13 Mar 2025 13:24:43 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	Samuel Holland <samuel.holland@sifive.com>, Deepak Gupta <debug@rivosinc.com>
Subject: Re: [PATCH v3 01/17] riscv: add Firmware Feature (FWFT) SBI
 extensions definitions
Message-ID: <20250313-924c6711597160f50c4cf90e@orel>
References: <20250310151229.2365992-1-cleger@rivosinc.com>
 <20250310151229.2365992-2-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250310151229.2365992-2-cleger@rivosinc.com>

On Mon, Mar 10, 2025 at 04:12:08PM +0100, Clément Léger wrote:
> The Firmware Features extension (FWFT) was added as part of the SBI 3.0
> specification. Add SBI definitions to use this extension.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
> Tested-by: Samuel Holland <samuel.holland@sifive.com>
> Reviewed-by: Deepak Gupta <debug@rivosinc.com>
> ---
>  arch/riscv/include/asm/sbi.h | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

