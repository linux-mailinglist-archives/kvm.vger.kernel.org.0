Return-Path: <kvm+bounces-62269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 39FF4C3E735
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 05:35:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A922E3ACAEA
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 04:34:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48FE827A47F;
	Fri,  7 Nov 2025 04:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="SKsNe9SL";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="gef2qNxF"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9354D253359;
	Fri,  7 Nov 2025 04:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762490076; cv=none; b=WsMPWYrQXIpOn/xHBKFXmINcCQkP7tyws0CQq+Y1A/mUQuTOeIlnTw8OGVNxW7kZ6JA6rztJH5BUKuWTuqDccumSdV0GOChRdCw9KjzGKB7Nv8nzOqmM09FJmP5Jm8g27ieqovjuxkBmQU8psnQKkM4uclVOtEG0YTi+ASn7ogw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762490076; c=relaxed/simple;
	bh=KOJbeHUyLYG9KJ1ZcFvivRQTk0UzPZm9j0A0g31EgXU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tfUlteVrYYyCiB0vkhmH0Lf03oa1UfyponqsNMYF56zCutGCBvwxO6OTAzon/eFe0yLuH+ml1ek/1al/TBkAKQNf+72kdIanQQzNKKfL46kfeY/HnJdKPZ45ogYsd2TI/WOolYrR0ffwzPPQt3qtzV32N0mebZx/DUxbb2xzsrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=SKsNe9SL; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=gef2qNxF; arc=none smtp.client-ip=202.12.124.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id DC0D71D00064;
	Thu,  6 Nov 2025 23:34:32 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Thu, 06 Nov 2025 23:34:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1762490072;
	 x=1762576472; bh=aAPBegNLzBYqzK9UWU8fWll390lmV0i9FqxDRNyc6/E=; b=
	SKsNe9SL6DV7gq5Q4XhlN5YNzzkEzTU/cSASxCxOaAoc+Ex3jhM8EbOsfeN24nkV
	17yAfuqqEWFP02F0jTjcDzEfQwaplP/7gDVAfXYo9JBdeQcZnKz+CGSUvigh0tLF
	GLNMPL0YmpcCikGbNvPDyMkiiMWSeanvc9ws3nJZAYyyBtdpG9be+RDsOEALWd4o
	M5dnZIHnZDhwdiB5ApP6au3o+NwctXl0oh3woRJuDnrXX848YLy7v34q8TQdZUul
	uQBmqHv/pzhpq6cqnWhFiIGkpNmftlkJJ3P7a1vePQJ8peR9X/uGn7aETFB2Jet4
	112oiR7zak0XTkE/X4FqsQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1762490072; x=
	1762576472; bh=aAPBegNLzBYqzK9UWU8fWll390lmV0i9FqxDRNyc6/E=; b=g
	ef2qNxFbEYsdtEEOMiNEZylr25QDTj0JHxK9GN4tMAQdFpaIknPpRdISktmwjIYk
	Bl1XmtI7VNvWiJfw2wOWp+e3GcvmHw82EW/lNCdfSYZxTMVlHo69ZGx/fn1Bj8Zf
	aMNpyRUVWThkrkKNRPoSGrNQuZdNnDc04rOudXiKJzTU37vZzUa34Ve0PdgAnlq6
	HvMsDOWmDIlzWaVfPe36P8hJT/KRglZz2JZ3WFPkgkN0KRM3wPbdBWcn2Wjwn3TZ
	r5Hlz5rC6clG0WvWe8a3cIAEPJqMDvN3CicIveBdCZME1IDi6D/4jQ+epXdfZvUb
	IqKZzYkw3mSseCkUm/EjA==
X-ME-Sender: <xms:13YNaTjmixltfISu22UJuEGEVeFHgjutDKyBeVav3OZeKAJM8DqRug>
    <xme:13YNad1jJza-eI684xqmaCsdK7-5w4BRJKOyfHSdEaICNbAUdpkCN6O5Ny1_isvN4
    A-Syw_wJ5wRCGIVnrTjrxuuCzWISmaNroXz9IJkKaGWKHpH7Q>
X-ME-Received: <xmr:13YNadhIe9VnkVD3lF8yay7ex_q_ZnqDlOz6SJmccynj40Vovy5KAyT8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddukeekjeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthejredttddtvdenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhepteetudelgeekieegudegleeuvdffgeehleeivddtfeektdekkeehffehudet
    hffhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hlvgigsehshhgriigsohhtrdhorhhgpdhnsggprhgtphhtthhopeegpdhmohguvgepshhm
    thhpohhuthdprhgtphhtthhopegthhhughhurghnghhqihhnghesihhnshhpuhhrrdgtoh
    hmpdhrtghpthhtohepkhifrghnkhhhvgguvgesnhhvihguihgrrdgtohhmpdhrtghpthht
    ohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqd
    hkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:13YNaddhpm7Sh0nC7_xphmBDQUjBTTywE39ET05p36gBmlEEs-rqow>
    <xmx:13YNaQnm3cTRjbv9VzkemJ6ggzbDzT3TR-N6jyMeMs1Kqv4eEC8ymA>
    <xmx:13YNaWvunygnrd_wx6uc65X1J7ayJt45XJ_vawakk76q8H9GzHoAQw>
    <xmx:13YNaW84AzRKPqdM25kPMqSzcNIJqwuBwjiovk8Wh2_sFi34lihl4Q>
    <xmx:2HYNaZ8imElv8VazJaCycQWT2yHUOUUDEcEtJ3YnvuroQLay4bdBDYaP>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 6 Nov 2025 23:34:31 -0500 (EST)
Date: Thu, 6 Nov 2025 21:34:30 -0700
From: Alex Williamson <alex@shazbot.org>
To: Chu Guangqing <chuguangqing@inspur.com>
Cc: <kwankhede@nvidia.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/1] vfio/mtty: Fix spelling typo in
 samples/vfio-mdev
Message-ID: <20251106213430.5d54045b.alex@shazbot.org>
In-Reply-To: <20251015015954.2363-2-chuguangqing@inspur.com>
References: <20251015015954.2363-1-chuguangqing@inspur.com>
	<20251015015954.2363-2-chuguangqing@inspur.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 15 Oct 2025 09:59:54 +0800
Chu Guangqing <chuguangqing@inspur.com> wrote:

> mtty.c
> The comment incorrectly used "atleast" instead of "at least".
> 
> Signed-off-by: Chu Guangqing <chuguangqing@inspur.com>
> ---
>  samples/vfio-mdev/mtty.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to vfio next branch for v6.19.  Thanks,

Alex

