Return-Path: <kvm+bounces-47075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E160EABCFD1
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 08:48:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A0DA1892364
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 06:48:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94C8825CC78;
	Tue, 20 May 2025 06:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y90pPUPL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B497E19259F;
	Tue, 20 May 2025 06:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747723693; cv=none; b=h5n+Bjq9Ok6lUBEwSAcDGC18sFnuDoAleJMt4KuqqwWivrTBsTdtaV3YvBBe2nmwT8DNbQsX6cFs4r+yqChwyIm9AqbWXj+vJwP86/TS956eiPSri+ZpqoWjtzazpxsCFPscgaRV68IHox7sk645IU5LW9aUUp87HH4sUhSWhc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747723693; c=relaxed/simple;
	bh=0+iJkTRrs7XDpaJleK3LNCPN518ONweiiRIUBZT4Fkw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IZ+8s5PJlo/2dHI3vLe7AeLWiqYa9RJwGoRQTfcGwTWlCyYXF4+myAOYQHQh1U22ZoVOTYgkPoKy2hIX06XFn43Kee8YvfAetm1m/cnCISRxixs076SOHw7Akka3BVNUKynTK5QVVwpwkO3AdCKSh7ODehDFeqbgcEM0s4y8GAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y90pPUPL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75961C4CEEB;
	Tue, 20 May 2025 06:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747723693;
	bh=0+iJkTRrs7XDpaJleK3LNCPN518ONweiiRIUBZT4Fkw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Y90pPUPLqBE90/nX/wrvHjO0GfpL6Z1+QhBNtIlX8ADk216FDvOcJpZvzQzUVRJJi
	 0X9T2yhVWWYhrMni2pvwW/Fg1ONIdBdCgYHVJi5zpRSrwpgDivT9e+3K+yF8vWtrH4
	 22MfW5FQ66Q29TZe7Ypr3LVrd6M0oYtH8q4DtwdYcfODfZ/qFpvBKUbBSi2M4VzPTz
	 mi1pzjnwf6uPM0vgbIiYFGkKvFHZuEIlof6m28+k9pN8naTRFyFcHg4VZb45PexQt/
	 2Mmu/UYgFSM5yecC5v2PQi32eUTvsWQxNf4KLrMWd3qJijbMUkpS8TrVA9jxCI8IfA
	 0GWQzF8q7evPg==
Date: Tue, 20 May 2025 08:48:05 +0200
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Igor Mammedov <imammedo@redhat.com>, Jonathan Cameron
 <Jonathan.Cameron@huawei.com>, Shiju Jose <shiju.jose@huawei.com>,
 qemu-arm@nongnu.org, qemu-devel@nongnu.org, Philippe =?UTF-8?B?TWF0aGll?=
 =?UTF-8?B?dS1EYXVkw6k=?= <philmd@linaro.org>, Gavin Shan
 <gshan@redhat.com>, Ani Sinha <anisinha@redhat.com>, Cleber Rosa
 <crosa@redhat.com>, Dongjiu Geng <gengdongjiu1@gmail.com>, Eduardo Habkost
 <eduardo@habkost.net>, Eric Blake <eblake@redhat.com>, John Snow
 <jsnow@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Markus
 Armbruster <armbru@redhat.com>, Michael Roth <michael.roth@amd.com>, Paolo
 Bonzini <pbonzini@redhat.com>, Peter Maydell <peter.maydell@linaro.org>,
 Shannon Zhao <shannon.zhaosl@gmail.com>, Yanan Wang
 <wangyanan55@huawei.com>, Zhao Liu <zhao1.liu@intel.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 00/20] Change ghes to use HEST-based offsets and add
 support for error inject
Message-ID: <20250520084805.5b34d888@foz.lan>
In-Reply-To: <20250511094546-mutt-send-email-mst@kernel.org>
References: <cover.1741374594.git.mchehab+huawei@kernel.org>
 <20250511094343-mutt-send-email-mst@kernel.org>
 <20250511094546-mutt-send-email-mst@kernel.org>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Em Sun, 11 May 2025 09:45:55 -0400
"Michael S. Tsirkin" <mst@redhat.com> escreveu:

> On Sun, May 11, 2025 at 09:45:04AM -0400, Michael S. Tsirkin wrote:
> > On Fri, Mar 07, 2025 at 08:14:29PM +0100, Mauro Carvalho Chehab wrote:  
> > > Hi Michael,
> > > 
> > > I'm sending v8 to avoid a merge conflict with v7 due to this
> > > changeset:
> > > 
> > >    611f3bdb20f7 ("hw/acpi/ghes: Make  static")  
> > 
> > 
> > 
> > Applied 1-13.
> > Patch 14 needs to apply compat to 10.0 machine type as well.  
> 
> Sorry i meant 1-11.

Changed on the newest version I just submitted:

	https://lore.kernel.org/qemu-devel/cover.1747722973.git.mchehab+huawei@kernel.org/

Thanks,
Mauro

