Return-Path: <kvm+bounces-39996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5270FA4D780
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 10:09:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F05DF188CC49
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 09:06:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83F551FE455;
	Tue,  4 Mar 2025 09:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="HoZUHGFH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4061EDA1E
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 09:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741078845; cv=none; b=HOpKEvhaA9WTxiJ7k1GtKsTZN+3N2b+X93RnB0l2zPc2hmbgLU5xtusR4Kk8saVzVO8FpZ4YDwFz4xTGaGhSU1TSL/9Eic6fpfzqjh7TmfHm3MVYh4niRJpVldirq1dj8I/z+WmLFzkyYmVQE1+X5zGYRMWN1n2pKqJgEIaWvc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741078845; c=relaxed/simple;
	bh=C5ZHUydAfD7qIPC2fugkdbL/7ZQbv9+E48hf7fmVHuI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZBNBW+OqiD8xEWYxc+mNbGz1Y6ZAfYhuHHFGOYW272FBHrxCKY1lOkLZCBWKd+dfwHAG9CBvWLVnA1ax4k0qUu6uhj+ZKxFqN0PPYG/Liyr1hhy8wQ/61n60+/05b5OcKHm7FECTcbZz9tS6emt24D2sHMWgsFQLN566Y64ONAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=HoZUHGFH; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43bcad638efso4049185e9.2
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 01:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1741078842; x=1741683642; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5UP7DmGMGEllBfFdaot9026+FUs+6/ByI4Mfm7p9ZUY=;
        b=HoZUHGFH3Y3FTWhwkHDQQUy4JseQKHJd+NaXAIQ5OId1VHbF6srGTfUWL4YPG9UU6t
         9OuRn+3XADWpRHOI/g7l9J+52arW586qdZvgBhfCMBlaE0P4Y32HnL9A55y/kA/LygU2
         QLAFLzP+hw15qhUlx+v7gJXMXdycytGcpQy3cMiEwrSVjnlKCur0jKKGoJ/Bmh5RvL72
         wCukzIqEB8iZTsvvm/H0yy1enT8OrcBWc9UGcVK7h+05c3b5r2TmsUSH5H9t6K4yJrHf
         V+rHcKmRSsU7DWv/JJMNRxnl5SRe8seaabn8A3pcz4DXhK6XPoG68ge2jV0iqLSG7fXI
         YyTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741078842; x=1741683642;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5UP7DmGMGEllBfFdaot9026+FUs+6/ByI4Mfm7p9ZUY=;
        b=PRK5PZCcLpJZM1gcepERknG+2iDVXsP7Y3h3trDrCb9kHIP/tYMUNd4l44vac7Uxbf
         Mn7vxSCmlcuIglKOxGVqlE+KGnD6NwS+S9mtG0/C83nScm9nUWxhTaRRL/WFtmIsSaNE
         zSbPjpFv3//ZVx3kApnmxAdUWo+s8pfdGVzdxv9ieJy8PLcGkG6qEvi3QRDgukI0UXbh
         3hVw6pPbkcEdE0q/3MD6J1c3jRvEALZEw+DaKWkx8cutXdxVvFjgZyPP5/C0wXUGeEGS
         C4fWYxzCABBPnygZhf6giMmwKs3OVRBlyLLrSRjmG0VUT5tE1HTFBu7M0PhKrdrDnDTa
         fH7w==
X-Forwarded-Encrypted: i=1; AJvYcCUlV1z0hV0H9zpKmZjujXe3mGBfuLn7T9X1tvzXCxEBTaDBaeOlL/BrGo06yBfd+X7JnH8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAagdD0OabZum2cVi/EbKeWQzp1TaZmJ5N/1qHRcGigi6z+dE9
	Xq990S+c84kQ4XZQXpkwnhOg3r3BuO7gah/UHWYwnrx2UOuQT6syxhqCR4l1XcE=
X-Gm-Gg: ASbGncufELKUbkBXQ3BiQyn4Foo7FckoeMlvYreJzPPx9sRMMqgVvLUn7++Bi8EASQN
	L0xZjlC7tdsiHgVkkgZYkgEVMvW7hImLZv+DLTMiCKr9JOQ7QWqVL+zm8PAYCoHv22Vd9wwiC5r
	zpL7w1ZdNQs+i2AKRo6auZSfFKa1mQAZdobhq5Aih28YhiwA0cn9+aBLPzEZXqePiYnMMV0lR4R
	tcO0+SOEaiiyuv2wduPcaq6ltKHiB1vr2Bx+xDen03eoKD2piuxu0q4LIhX6KdM+qThnsSKnqxs
	sA8RIfYxItYFFDwpqUCTfbCteJcPp+R7
X-Google-Smtp-Source: AGHT+IE98Wtw/qck2RNdbUy35iBZdcuCmo9BHlXLPhcqJEgVkq5LxR8GTapjzExbGuStv6PALsyUfQ==
X-Received: by 2002:a05:600c:3b23:b0:439:98b0:f8ce with SMTP id 5b1f17b1804b1-43ba66e60f5mr143195855e9.7.1741078842210;
        Tue, 04 Mar 2025 01:00:42 -0800 (PST)
Received: from localhost ([2a02:8308:a00c:e200::688c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bbf2edf84sm75715855e9.40.2025.03.04.01.00.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 01:00:41 -0800 (PST)
Date: Tue, 4 Mar 2025 10:00:41 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Atish Patra <atishp@rivosinc.com>
Cc: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 4/4] KVM: riscv: selftests: Allow number of interrupts
 to be configurable
Message-ID: <20250304-bb96798e9a1fd292430df3e8@orel>
References: <20250303-kvm_pmu_improve-v2-0-41d177e45929@rivosinc.com>
 <20250303-kvm_pmu_improve-v2-4-41d177e45929@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250303-kvm_pmu_improve-v2-4-41d177e45929@rivosinc.com>

On Mon, Mar 03, 2025 at 02:53:09PM -0800, Atish Patra wrote:
> It is helpful to vary the number of the LCOFI interrupts generated
> by the overflow test. Allow additional argument for overflow test
> to accommodate that. It can be easily cross-validated with
> /proc/interrupts output in the host.
> 
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  tools/testing/selftests/kvm/riscv/sbi_pmu_test.c | 38 +++++++++++++++++++-----
>  1 file changed, 31 insertions(+), 7 deletions(-)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

