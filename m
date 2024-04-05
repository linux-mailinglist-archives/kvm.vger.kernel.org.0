Return-Path: <kvm+bounces-13716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0957D899E73
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 15:37:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E67C1F22936
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 13:37:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 175D316D4DE;
	Fri,  5 Apr 2024 13:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GKtU9Vmk"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF3916D32F
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 13:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712324224; cv=none; b=hT8tLHQm89dxijHmSEwAEetdK/9BUgnuw5jxFiqOYxJgz9MDvl71Tc6efk7PCGbMfuyk/OQEXA01qMROUX6L2yY1CELc+vE9nZ99QwUQnYCOgypJVhaB6CZQRYJIvI2V83OKliJODpd358pP5fbgRPIVZF43/OBqvmGGMtVmVnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712324224; c=relaxed/simple;
	bh=8TjtdIezVlaAVbskTL4XhyCbsnV1INqRnVCikXe6fUc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ARR9d8nkhYUDETMM3tBbqyEK4X6jV6j8492ZpABUWC+VygAyNK+m0lZqyh0EUKiDqfANdzUadW1Xt9LkO42ntKUMZtBgAV5coDjkGx2LsUcdV6AOEPGGJTCq+lYok8qfO/72GyJ9Sx1P6Hy7l61Qs5eqXe1G3klvgRyC55dxb0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GKtU9Vmk; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 5 Apr 2024 15:36:56 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712324218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kAEkxyvGG8CTOMudCY/Qymr2d740f6GsB5DTl9aqF/0=;
	b=GKtU9VmkIxw3rYQksuwPeVvOhiIN6otv7lGx3TjXxU3mXC0udxW1zzEYsSyK9kq/hHVkHo
	5n6zPcg0AzKlHKx5hv2RnAiSpdmnz/5m6ng8rDl7wB6J6Lz33QugW9ez4I18KcJSojZP5F
	lm+kDVhLpsA3kxL4mRCWjJWnPD2rdI4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v8 04/35] (arm|s390): Use migrate_skip in
 test cases
Message-ID: <20240405-e8cc662f4e72089d6a54317f@orel>
References: <20240405083539.374995-1-npiggin@gmail.com>
 <20240405083539.374995-5-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240405083539.374995-5-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 05, 2024 at 06:35:05PM +1000, Nicholas Piggin wrote:
> Have tests use the new migrate_skip command in skip paths, rather than
> calling migrate_once to prevent harness reporting an error.
> 
> s390x/migration.c adds a new command that looks like it was missing
> previously.
> 
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  arm/gic.c              | 21 ++++++++++++---------
>  s390x/migration-cmm.c  |  8 ++++----
>  s390x/migration-skey.c |  4 +++-
>  s390x/migration.c      |  1 +
>  4 files changed, 20 insertions(+), 14 deletions(-)
>

Acked-by: Andrew Jones <andrew.jones@linux.dev>

