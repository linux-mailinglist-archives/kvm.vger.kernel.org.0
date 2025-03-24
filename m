Return-Path: <kvm+bounces-41809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E86CA6DEF6
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 16:48:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BDED616C13B
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 15:48:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 636CD25F978;
	Mon, 24 Mar 2025 15:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TMNq+SRZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C022B13A41F
	for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 15:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742831304; cv=none; b=CUccaY3JiTRG3k+XNNZZ+j7N6UIkAb8VdGHYFw5R4fbl+Ic+xeSIc0pJJJ8zA59ctgXmv59GZCacmZaJ1dEIzWD9hqxGJZlpKL8RrrhjS+mIkDJ8sLaxncs4Efj3nVEeShpkjr7m0Du1xn+0kiLvJRBI5kc5V9upGNIjrHDN3hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742831304; c=relaxed/simple;
	bh=+wpFTG+SwBnhnvH78ViBaMrd4NWDi/4fRbVDO0SodlY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g5abp/RYmrGcSd4vSJScSZL5ycNLHQwFe14rRjgiB3oKBNTXvaehD5zZVfzU37NbaaJ6DeN6SqpAf3XQVLlfyrh2+4fpGwMS88D2km6F7gfoC4VvpKGzW2+EfB1x+PIl8ApmUkdCS7p+NvPz3MrsHdWpmuy2Nkh8WuHPH/1WBV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TMNq+SRZ; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43d04dc73b7so48965635e9.3
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 08:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742831301; x=1743436101; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LrMEg2SBRPufHHPsPTxdKBRIozyqsnf+0fw9wrne1Kw=;
        b=TMNq+SRZBAw2iHgfovKyOC8YYnXbprlRyi934Vu5TDcjXa/5BqDHc9ob/WlFfABT97
         o2Do2UVxwixKqXgUu5FI4UtmC/thvzKfUNfYzX6SCIpTiYPjvWlwEwc5Vi2Q3y1d/XUo
         2axyp8I29+yymB7amQIQrOKjfVVY7LR9Cb1crQEyspWQlNtXJGCDsStzaUZtUg4LpPxA
         Nj9TKXzArytAZ+JLsTCPOxEdxLe/ZdJjCRbsxgeGT6xc4PWOeIwxQBApxBIUz/fgmDRq
         6QgkOCFCbFemFb1psCCOS98Kh/UjCYaWzLh6LeCkYzoqphAhVQmfQM0zKLDl78ARJqMM
         UONQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742831301; x=1743436101;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LrMEg2SBRPufHHPsPTxdKBRIozyqsnf+0fw9wrne1Kw=;
        b=uBhCNkUlgTDjCUAN+7gBpccyZl6slq/5e+S4C16/py8/oPy2e/mrE1a5gjkCOINK6q
         pY/tTgVF4N2894zKB1xNqj/Sg2zD0qnc4Cd8650pR+opNCwHVvsxe5ec66Bnvd2U/XmN
         BEZuUcCNf/sjIcWGZczzAqmNqu6uken+rPn7k4avEkqy9h6KMSLUxmGupk0OzT/7BuDB
         bz/2S52lEBBbLmLGHEGrYgDI5nzNomp+TicFhvy3bisGjZKTEBlTVePf9Z7P2UKho62r
         dlo53xNN97i1XctUB77R8hbN1nhhsqySaVb38zAJQxWcW+365UhnbsiI4s0dld51OL1P
         4UHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVY6TakPa1Sd9voM5wmdFMPux0Q2LF+Y4QhyDVLHUfo4Hn7O5m3daipb547ymviGH4t/iM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxbg9/qJ7oOUUoLBjI9+HC/kc5DeQWilzTt4Ef5VXt/pXnnnGUc
	BIyxRziBF0+AdL4X+/ABCqyoHtRnR4Xj/Xm7hNYqP1cHywdNgWpKh3xnGDs5zH8=
X-Gm-Gg: ASbGncvQH3cEjLz41VZrr0R/iErliBKSW9JXyl9UXgGYifvzwnAlHv/NOzx5FvQ0QPJ
	w3Lt/bsvLIoxNBh6RMNId59M+1e2miwjA/E3Lw+ZUA/9MkIEccXXeOIZF0zEzHkie2SxeqFrQav
	oyrxYZIOzH5m9aFSE3aUmZQdbeTquFlLTLFlRLD3mYcAE5SmR1FsCRL/OygclPn6Z3XT7qJ700O
	aej+V4DiG0Cp5yNkPGq793IzOiwx4yFhA3K5iLELU7Jub/7IUAwpCIOidhvFYmEfIVx5jWGM5sE
	tVHL3E/w2ZOc7JmAgDUSQfZ3X4ctu3r9iRLbMF9H9/3suYZQEMdDYw==
X-Google-Smtp-Source: AGHT+IF4HKRqDp7H68XcsGcdXR2R+pX/n70fM2CJTR1c8n9FwVMwhpldYszXcap+M+tGB315WPIqBA==
X-Received: by 2002:a05:600c:19d4:b0:43c:fb95:c76f with SMTP id 5b1f17b1804b1-43d509e9eafmr116532925e9.9.1742831300985;
        Mon, 24 Mar 2025 08:48:20 -0700 (PDT)
Received: from myrica ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d4fd9e960sm123514055e9.29.2025.03.24.08.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 08:48:20 -0700 (PDT)
Date: Mon, 24 Mar 2025 15:48:19 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: eric.auger@redhat.com
Cc: andrew.jones@linux.dev, alexandru.elisei@arm.com,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, vladimir.murzin@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 1/5] configure: arm64: Don't display
 'aarch64' as the default architecture
Message-ID: <20250324154819.GA1844993@myrica>
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
 <20250314154904.3946484-3-jean-philippe@linaro.org>
 <1b0233dc-b303-4317-a65d-572cc3582b8a@redhat.com>
 <fcb7894d-51e5-4376-b32f-4cb9eb94b573@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fcb7894d-51e5-4376-b32f-4cb9eb94b573@redhat.com>

On Mon, Mar 17, 2025 at 09:27:32AM +0100, Eric Auger wrote:
> 
> 
> On 3/17/25 9:19 AM, Eric Auger wrote:
> > Hi Jean-Philippe,
> > 
> > 
> > On 3/14/25 4:49 PM, Jean-Philippe Brucker wrote:
> >> From: Alexandru Elisei <alexandru.elisei@arm.com>
> >>
> >> --arch=aarch64, intentional or not, has been supported since the initial
> >> arm64 support, commit 39ac3f8494be ("arm64: initial drop"). However,
> >> "aarch64" does not show up in the list of supported architectures, but
> >> it's displayed as the default architecture if doing ./configure --help
> >> on an arm64 machine.
> >>
> >> Keep everything consistent and make sure that the default value for
> >> $arch is "arm64", but still allow --arch=aarch64, in case they are users
> > there
> >> that use this configuration for kvm-unit-tests.
> >>
> >> The help text for --arch changes from:
> >>
> >>    --arch=ARCH            architecture to compile for (aarch64). ARCH can be one of:
> >>                            arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
> >>
> >> to:
> >>
> >>     --arch=ARCH            architecture to compile for (arm64). ARCH can be one of:
> >>                            arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
> >>
> >> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> >> ---
> >>  configure | 5 +++--
> >>  1 file changed, 3 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/configure b/configure
> >> index 06532a89..dc3413fc 100755
> >> --- a/configure
> >> +++ b/configure
> >> @@ -15,8 +15,9 @@ objdump=objdump
> >>  readelf=readelf
> >>  ar=ar
> >>  addr2line=addr2line
> >> -arch=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
> >> -host=$arch
> >> +host=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
> >> +arch=$host
> >> +[ "$arch" = "aarch64" ] && arch="arm64"
> > Looks the same it done again below
> 
> Ignore this. This is done again after explicit arch setting :-/ Need
> another coffee
> 
> So looks good to me
> Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks for the review!

Jean

