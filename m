Return-Path: <kvm+bounces-23861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF7CA94EF58
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 16:18:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F317B1C21863
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 14:17:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 006B017E477;
	Mon, 12 Aug 2024 14:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Cu47vs/P"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507E51114
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 14:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723472274; cv=none; b=iPAx4FPVaUuZSno/l6p74Kwz+84O0+Tj9Bpj560Yw3qCyFOeGCqk8Pcy8ZiY+l1Z21OH5Iw1LlQ8zcAh+3byshCfPLe99i3LuBOqtxWS6m2eDmvl8IW+4dtI5xgvEFvfFy0pOvC3c0GNG3jJjVBwVaG45GlGBFcci7PukvJ4mts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723472274; c=relaxed/simple;
	bh=0v/4QrRoMK7deh+8elgKq7JFQ7NRp3Z62l+nD3XbzLU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DkfYZwslKKzD2u1SlKKoP6Jh9Z9z/AU069qJ/CXinxxnrQrN26no5ejL1rhGBPNSSRbw2k9+6H2GQyh1vSSUw+ODQ/YFiga0BDrfa7vvpsvGUftMDDvi4XhkQPIdHidyBlAqKEky0h77sscwL/26n6rt4r1019RA4q7Rwjhxyx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Cu47vs/P; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 12 Aug 2024 16:17:45 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723472270;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VbcmQiqmiyg5RwLBZcpaE379nhm9SS0LJIDOYDJHWn8=;
	b=Cu47vs/PeVHG5fn9EjYBFoi7U4ns7Jv0OmVUK06gKM1/nermfo8SSDvM16HebrAICVkR80
	aDQ+1CiCI7s86e5fGut26kfYqxa6JOAGNHkGLTrAVJaDM0uYKZnVC2FTNsHjrSbtCL6vQ6
	VQYOA6JH3jGcnX/BnrlBX5HgzvDm++8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>, Nico Boehr <nrb@linux.ibm.com>, 
	Thomas Huth <thuth@redhat.com>, linux-s390@vger.kernel.org, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 1/7] lib: Add pseudo random functions
Message-ID: <20240812-041127693229838a832fc373@orel>
References: <20240620141700.4124157-1-nsg@linux.ibm.com>
 <20240620141700.4124157-2-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240620141700.4124157-2-nsg@linux.ibm.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jun 20, 2024 at 04:16:54PM GMT, Nina Schoetterl-Glausch wrote:
> Add functions for generating pseudo random 32 and 64 bit values.
> The implementation uses SHA-256 and so the randomness should have good
> quality.
> Implement the necessary subset of SHA-256.
> The PRNG algorithm is equivalent to the following python snippet:
> 
> def prng32(seed):
>     from hashlib import sha256
>     state = seed.to_bytes(8, byteorder="big")
>     while True:
>         state = sha256(state).digest()
>         for i in range(8):
>             yield int.from_bytes(state[i*4:(i+1)*4], byteorder="big")
> 
> Acked-by: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> ---
>

There was a discussion about potentially needing random numbers for
RISC-V SBI tests, so I've queued this on riscv/sbi,
https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv%2Fsbi

Thanks,
drew

