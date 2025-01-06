Return-Path: <kvm+bounces-34601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A8888A0272C
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 14:55:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2CB7418856D5
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 13:55:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 762A21DDC2D;
	Mon,  6 Jan 2025 13:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="RB6Ycofn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC1273451
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 13:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736171717; cv=none; b=XcVH92lXIGWm/fzNv3sc+XDKs//KnGcfp/rEAkaGz2veZH4CJxoA2Ap7iT66uXhIw2FgYj7zI5dh+iEh0L2lfXkklo5pR2zA2gOZCva7/CFanmIzAspFH1IDzARr1J26XHFonL4LzoNdH+j2uXUYQlCfsXBGaUJ0KGL/h2thoQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736171717; c=relaxed/simple;
	bh=qE+kGC9QGLF1Nj1+UwT88o2V+6quGha0QvhC+2q+RXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DLBjOdXMa5GFmqFTBdkBJ/3J4gt8ORBhcx1v+YxzN+w2ypvKrtcFvSs6Cczr2+g9U4XgakfLDHGZ8tZze3FDXydKpJbD48EfaCH+L+lf8hJdNSxFIUX5gR3v5sncJoLI0Tsr9xi+GOY8RXqhjIhx4l3KNbgQqNT1v7ZpgCjEXac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=RB6Ycofn; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-38633b5dbcfso13849374f8f.2
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 05:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1736171714; x=1736776514; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+PtiW3OqUvs8CS+s0qiIMYN9i+4vbOFKlpELD3NbBK0=;
        b=RB6YcofnSnBt/iyKMbjM7+aLBinONL+FtgX+AM3RUSpPIq6n5f7c7c6XuSslaymfLw
         UpnT4A5+7qopZMzMkNtPIe7D+81yPxHXr3DM/PAD+9bNgtR+73iaZt+6lZMawkEfyHOK
         seZsRlVml7QouNk4iHpvsQdf/P+H3HLVp9NqCAjw2PGaRr1/nBTZI4Le5knU1t+IGkIC
         QPKcYpYnmI5PBWv1FbirFbAMNhSJ8izavH3o6/JPPql2aZ68Omm1MGxr/AIs/XlvNJbK
         NswLXS99S5DuN/wZsoWJzy3F7g4UKFWlajJsD26uS01sXug1+x22mW47BzgbQyke3Uft
         Mrqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736171714; x=1736776514;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+PtiW3OqUvs8CS+s0qiIMYN9i+4vbOFKlpELD3NbBK0=;
        b=TnHDx7rmRVOvbV9o0J0Cp8M3m6YlVBRuD6eLYObVQEMcUHfY/0hKZ+USBSsFWs+Tpf
         art74r3Fs7AZGfVnYPnfUlAvfsv2iproOXNFzg3q9BC36Kz9s23RJ8CGHlFZAiw6Jesz
         PPNSGHo8vzqcI48qU6jT/DqeRHnKAg3iKPNncfu7NlpErAmuXtTEcG2I6yNKrNXca8kc
         SXSp3iVqaRxhYvsJC6a8pEiWkoAGQ0rwYVH36iRwgGuWLtI7Jsb9ul+qNncpGbgm2BPW
         iI/v7FDSQW9sOuX7aCza/lwdQu4Y+0j5qtcjYQq0PzuJFtQLnfPizPaAGqBVDqUDXoz0
         Do4A==
X-Gm-Message-State: AOJu0Yz1d8PDnLVmnn2OWOTw+WMpBb2z2hjgpTdfC2/aL3mT0axhLtJl
	PApBe+K+wZrE+xiOqr9S25WOpohugGXkQAcxSDoVYlfsx4FZ1cFIsJomsMu2AZ8=
X-Gm-Gg: ASbGncvNqDL4k5vV+AwSKm/CuUhyyCZHUwsMzUC4pMaof6Um0ZgoFmTIw2rdahljWZo
	J6kvULofrYaNg3oLXHrkeZ5kS/WH27lsHw4LBG9j7DiRN2EPbyPyk8eK1/DAmPvgeKR2y8urgXl
	EggvYPwxrLS/qCjTqCWdXJ0vHwNHuiAwqhPCcmA8dbi93Gb5Cv6ae8ZbBeSDYkmTumxleSudyVP
	G6reiV5OZFNKbyvtG+eLgv7+DNblgWpa1+vEfixz7wBFpiADLGhUodEx+1HtNW1Df4b5Bgk0ZWG
	e6PrLMNJB6aKAVDuYT252Uq/XOhsy3towv3+TUO0Bw==
X-Google-Smtp-Source: AGHT+IFQZoFcZKpFUlkMbtP7vcuqEf3/c5Y2lSqVd0PkAXjcMdYLjO4gBwMH3anWvN0fYtFvBl8CtQ==
X-Received: by 2002:adf:a445:0:b0:38a:2b39:9205 with SMTP id ffacd0b85a97d-38a2b3993dfmr38095742f8f.33.1736171713973;
        Mon, 06 Jan 2025 05:55:13 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c832a90sm47386140f8f.28.2025.01.06.05.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2025 05:55:13 -0800 (PST)
Date: Mon, 6 Jan 2025 14:55:12 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Anup Patel <apatel@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v4 0/5] riscv: add SBI SSE extension tests
Message-ID: <20250106-daa8e0da7de4e560f17b4d38@orel>
References: <20241125162200.1630845-1-cleger@rivosinc.com>
 <ada1c6da-d91c-4177-9173-9a7cdb0af2fb@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ada1c6da-d91c-4177-9173-9a7cdb0af2fb@rivosinc.com>

On Mon, Jan 06, 2025 at 11:11:42AM +0100, Clément Léger wrote:
> Gentle ping ?

Thanks for the reminder. I'll try to get to it this week.

drew

> 
> Thanks,
> 
> Clément
> 
> On 25/11/2024 17:21, Clément Léger wrote:
> > This series adds an individual test for SBI SSE extension as well as
> > needed infrastructure for SSE support. It also adds test specific
> > asm-offsets generation to use custom OFFSET and DEFINE from the test
> > directory.
> > 
> > ---
> > 
> > V4:
> >  - Fix typo sbi_ext_ss_fid -> sbi_ext_sse_fid
> >  - Add proper asm-offset generation for tests
> >  - Move SSE specific file from lib/riscv to riscv/
> > 
> > V3:
> >  - Add -deps variable for test specific dependencies
> >  - Fix formatting errors/typo in sbi.h
> >  - Add missing double trap event
> >  - Alphabetize sbi-sse.c includes
> >  - Fix a6 content after unmasking event
> >  - Add SSE HART_MASK/UNMASK test
> >  - Use mv instead of move
> >  - move sbi_check_sse() definition in sbi.c
> >  - Remove sbi_sse test from unitests.cfg
> > 
> > V2:
> >  - Rebased on origin/master and integrate it into sbi.c tests
> > 
> > Clément Léger (5):
> >   kbuild: allow multiple asm-offsets file to be generated
> >   riscv: use asm-offsets to generate SBI_EXT_HSM values
> >   riscv: Add "-deps" handling for tests
> >   riscv: lib: Add SBI SSE extension definitions
> >   riscv: sbi: Add SSE extension tests
> > 
> >  scripts/asm-offsets.mak  |   22 +-
> >  riscv/Makefile           |   10 +-
> >  lib/riscv/asm/csr.h      |    2 +
> >  lib/riscv/asm/sbi.h      |   83 +++
> >  riscv/sbi-tests.h        |   12 +
> >  riscv/sbi-asm.S          |   96 +++-
> >  riscv/asm-offsets-test.c |   19 +
> >  riscv/sbi-sse.c          | 1043 ++++++++++++++++++++++++++++++++++++++
> >  riscv/sbi.c              |    3 +
> >  riscv/.gitignore         |    1 +
> >  10 files changed, 1278 insertions(+), 13 deletions(-)
> >  create mode 100644 riscv/asm-offsets-test.c
> >  create mode 100644 riscv/sbi-sse.c
> >  create mode 100644 riscv/.gitignore
> > 
> 

