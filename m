Return-Path: <kvm+bounces-16891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BFBB88BE9C8
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:53:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 59AEC1F24CA5
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 16:53:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9BAC2D796;
	Tue,  7 May 2024 16:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="f12l5SQp"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BA4182AF
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 16:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715100775; cv=none; b=N+5D3Cb+OAtlrKTXWy0E8npAzs+vAbvlKF+eX4x0B7fu6zR4uuwTuGVzFX9/dTpZvc6yPJS0BOvaVS2ox40JCSwxfKUjffOnfD71MRjSkkHGTIGzjZp+30CF1djbxBPFBKJ9N0OBoFtovTRQDhO0VlnVVi3/f/sIUH10m75NRMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715100775; c=relaxed/simple;
	bh=9d1il97f/NLbhz6KeARpDvqTFrX7jDVVILM7uqq5K8s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fr/rD7lqg3XktZ4Iulzf5i5arGJ1RCv3R/FkcMetZUukRy++ol7xC9ctLjt7bOepl2/K/NrpQLEl6tgtPSzP/5n4Mft9F8tvNlCqBeHfCcw4SEtP1PphdoIqTLFmtl1meIhRFohNFqXSXUEuVY2bPhvA4x8jL6r3VAF9aUo21gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=f12l5SQp; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 7 May 2024 18:52:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1715100770;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4RpTd6tdyv3VnipQuZDaMG+zhXF/8EENNowO/9cqVPc=;
	b=f12l5SQpKVP3BP3d0UTUilxNaGbHfYqYmYko8Z8BT1k6de7aWzmvKG7C6OEufI2IIaaGOL
	1ccQTApFXiVtwwgGYrBK1osOkKLH4q2n3CkZdmbyGciamQPclnACp+czUYGjQbQWiQCTUI
	T9T9EUijPM3RqoZ5AyU0aQZxpl5F37I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Thomas Huth <thuth@redhat.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] travis.yml: Update the aarch64 and
 ppc64le jobs to Jammy
Message-ID: <20240507-715514f1926819d21f229551@orel>
References: <20240507133426.211454-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240507133426.211454-1-thuth@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Tue, May 07, 2024 at 03:34:26PM GMT, Thomas Huth wrote:
> Ubuntu Focal is now four years old, so we might miss some new compiler
> warnings that have been introduced in later versions. Ubuntu Jammy is
> available in Travis since a while already, so let's update to that
> version now.
> 
> Unfortunately, there seems to be a linking problem with Jammy on s390x,
> so we have to keep the s390x on Focal for now.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  .travis.yml | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/.travis.yml b/.travis.yml
> index 9b987641..99d55c5f 100644
> --- a/.travis.yml
> +++ b/.travis.yml
> @@ -1,4 +1,4 @@
> -dist: focal
> +dist: jammy
>  language: c
>  cache: ccache
>  compiler: clang
> @@ -20,13 +20,14 @@ jobs:
>  
>      - arch: ppc64le
>        addons:
> -        apt_packages: clang-11 qemu-system-ppc
> +        apt_packages: clang qemu-system-ppc
>        env:
> -      - CONFIG="--arch=ppc64 --endian=little --cc=clang-11 --cflags=-no-integrated-as"
> +      - CONFIG="--arch=ppc64 --endian=little --cc=clang --cflags=-no-integrated-as"
>        - TESTS="emulator rtas-get-time-of-day rtas-get-time-of-day-base
>            rtas-set-time-of-day selftest-setup spapr_hcall"
>  
>      - arch: s390x
> +      dist: focal
>        addons:
>          apt_packages: clang-11 qemu-system-s390x
>        env:
> -- 
> 2.45.0
>

Acked-by: Andrew Jones <andrew.jones@linux.dev>

