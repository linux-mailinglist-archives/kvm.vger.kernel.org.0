Return-Path: <kvm+bounces-57700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 65384B5914F
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 10:52:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C77C6523E73
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 08:52:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03F9128C860;
	Tue, 16 Sep 2025 08:52:02 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C68E4286890
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 08:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758012721; cv=none; b=IuHeLP8RjFsmarx6g21DOmLNNWYxkibckEn2G8vDe47lzcdv4LVznGr5VGfD7K69XaVML4C2vZ65l/KDr9eUOWtY0AK8hngipog4s8GQvgyzClAu/S2PfLEQsjql9luxHExMz2PNBvwFhf5Mn+yyGjwh4cg7PsBur8FgB2CZAm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758012721; c=relaxed/simple;
	bh=tm+NCdi5iMOP8NvF2xieeub/HnBoiVobuY1HwX9FSEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KCcUwg/c8/osKyTUqCI57RynF8K+S9EAqQPB0JspfXF2MVTlWrF4Wcy66DjpoSlduRBf+4xzXzlyZUplXc9iPdY/hodeyFUQaCjV17P0tRCFRkwYZn0qgPeqdBSPdS/CHcOxslMApy94h33K834+i3I5BiycX6ejHXhbSvjLPYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EF55812FC;
	Tue, 16 Sep 2025 01:51:50 -0700 (PDT)
Received: from donnerap (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 26CC83F66E;
	Tue, 16 Sep 2025 01:51:58 -0700 (PDT)
Date: Tue, 16 Sep 2025 09:51:55 +0100
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>
Cc: Julien Thierry <julien.thierry.kdev@gmail.com>, Marc Zyngier
 <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, Alexandru
 Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH kvmtool v3 0/6] arm64: Nested virtualization support
Message-ID: <20250916095155.2b3e69d3@donnerap>
In-Reply-To: <aL7ZPlm3kANwiWb3@willie-the-truck>
References: <20250729095745.3148294-1-andre.przywara@arm.com>
	<aL7ZPlm3kANwiWb3@willie-the-truck>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 8 Sep 2025 14:25:18 +0100
Will Deacon <will@kernel.org> wrote:

> Hi Andre,
> 
> On Tue, Jul 29, 2025 at 10:57:39AM +0100, Andre Przywara wrote:
> > This is v3 of the nested virt support series, adjusting commit messages
> > and adding a check that FEAT_E2H0 is really available.  
> 
> Do you plan to respin this addressing Alexandru's outstanding comments?

Yes, will do.

Cheers,
Andre

