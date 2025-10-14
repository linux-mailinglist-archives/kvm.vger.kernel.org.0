Return-Path: <kvm+bounces-59997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id AA2FBBD79D6
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 08:48:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 938024EC15F
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 06:48:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 481AF2D3233;
	Tue, 14 Oct 2025 06:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JCnONr74"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461DF27280E
	for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 06:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760424514; cv=none; b=Y++KntokHC3Tegl3Kd28svvxvKcYw7aBKfG05HlJBiNQbDOLHgsHj79LTgE9EUajkuU6eB1OA+rXbqD2G9G0w4lz37v+1X07xjmE8CemMkqZemPVa9/NqZ03FDI22zXf902aUMT9+SWR7TlHscj/E6msdyeZ3Z5k3peq7dBUs+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760424514; c=relaxed/simple;
	bh=Pb4X6pA3zjo0/luemi6ccC2exhFezbhgdoWaxhzllq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BP3W/d5tHB6Oj6uG/6PCHr9gFh2X5Lp68uhRVsax8rjqRXoGJZtTkCtNIeE4KvDoCsrVuxI1s0JWkwuFev5R+ejhrA/NQF5uXk8UkaGprtUo3SwYgblsL+ehxiex1ov3eyLYrlvtuDG0Tt435elQEDFIThYuUxhhwA74PhgGu60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JCnONr74; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760424510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Jyokv8TZ9xK9Xt60THWv2ud2nta75kmCieKYYuxCcI=;
	b=JCnONr74aHbpKqwBDgklaSuyHWJqlURlO9FmktUjkNqbvpdejficWhi/B3gNrBfUFODCkD
	/iCoyafQwBl+1xjrZ+QjD6QFqCncGEaLV8Ku1itRFR5lRffhu1xaS/YJKP+c8XYYVhvTBI
	GaygqterNU5eNlgx52A9wUBBmoceqig=
From: Menglong Dong <menglong.dong@linux.dev>
To: Chu Guangqing <chuguangqing@inspur.com>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
 martin.lau@linux.dev, eddyz87@gmail.com, song@kernel.org,
 yonghong.song@linux.dev, john.fastabend@gmail.com, kpsingh@kernel.org,
 sdf@fomichev.me, haoluo@google.com, jolsa@kernel.org, kwankhede@nvidia.com,
 bpf@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Chu Guangqing <chuguangqing@inspur.com>
Subject: Re: [PATCH v2 1/1] samples/bpf: Fix spelling typo in samples/bpf
Date: Tue, 14 Oct 2025 14:48:19 +0800
Message-ID: <2240784.irdbgypaU6@7950hx>
In-Reply-To: <20251014060849.3074-2-chuguangqing@inspur.com>
References:
 <20251014060849.3074-1-chuguangqing@inspur.com>
 <20251014060849.3074-2-chuguangqing@inspur.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
X-Migadu-Flow: FLOW_OUT

On 2025/10/14 14:08, Chu Guangqing wrote:
> do_hbm_test.sh:
> The comment incorrectly used "upcomming" instead of "upcoming".
> 
> hbm.c
> The comment incorrectly used "Managment" instead of "Management".
> The comment incorrectly used "Currrently" instead of "Currently".
> 
> tcp_cong_kern.c
> The comment incorrectly used "deteremined" instead of "determined".
> 
> tracex1.bpf.c
> The comment incorrectly used "loobpack" instead of "loopback".
> 
> mtty.c
> The comment incorrectly used "atleast" instead of "at least".
> 
> Signed-off-by: Chu Guangqing <chuguangqing@inspur.com>

Hi, Guangqing.

The change log is preferred when you send a new version, which
can make people know the difference in this version quickly. It
could follow the SOB like this:

Signed-off-by: Chu Guangqing <chuguangqing@inspur.com>
---
v2:
- xxx
---

The content that wrapped by the "---" will not be visible after the
patch being applied, so you can put whatever you want here.

> ---
>  samples/bpf/do_hbm_test.sh  | 2 +-
>  samples/bpf/hbm.c           | 4 ++--
>  samples/bpf/tcp_cong_kern.c | 2 +-
>  samples/bpf/tracex1.bpf.c   | 2 +-
>  samples/vfio-mdev/mtty.c    | 2 +-

You titled the patch "samples/bpf: Fix spelling typo in samples/bpf",
but this file is not in the samples/bpf, right? So I think we'd better
split it out.

And it's preferred to tag you patch with "bpf" or "bpf-next", such
as [PATCH bpf-next V2], so the CI can run some testings for you,
even though it's not necessary for this patch.

BTW, "Guangqing Chu" will be better, according to the habit :)

Thanks!
Menglong Dong

>  5 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/samples/bpf/do_hbm_test.sh b/samples/bpf/do_hbm_test.sh
> index 38e4599350db..7f4f722787d5 100755
> --- a/samples/bpf/do_hbm_test.sh
> +++ b/samples/bpf/do_hbm_test.sh
> @@ -112,7 +112,7 @@ function start_hbm () {
>  processArgs () {
>    for i in $args ; do
>      case $i in
> -    # Support for upcomming ingress rate limiting
> +    # Support for upcoming ingress rate limiting
>      #in)         # support for upcoming ingress rate limiting
>      #  dir="-i"
>      #  dir_name="in"
> diff --git a/samples/bpf/hbm.c b/samples/bpf/hbm.c
> index bf66277115e2..fc88d4dbdf48 100644
> --- a/samples/bpf/hbm.c
> +++ b/samples/bpf/hbm.c
> @@ -5,7 +5,7 @@
>   * modify it under the terms of version 2 of the GNU General Public
>   * License as published by the Free Software Foundation.
>   *
> - * Example program for Host Bandwidth Managment
> + * Example program for Host Bandwidth Management
>   *
>   * This program loads a cgroup skb BPF program to enforce cgroup output
>   * (egress) or input (ingress) bandwidth limits.
> @@ -24,7 +24,7 @@
>   *		beyond the rate limit specified while there is available
>   *		bandwidth. Current implementation assumes there is only
>   *		NIC (eth0), but can be extended to support multiple NICs.
> - *		Currrently only supported for egress.
> + *		Currently only supported for egress.
>   *    -h	Print this info
>   *    prog	BPF program file name. Name defaults to hbm_out_kern.o
>   */
> diff --git a/samples/bpf/tcp_cong_kern.c b/samples/bpf/tcp_cong_kern.c
> index 2311fc9dde85..339415eac477 100644
> --- a/samples/bpf/tcp_cong_kern.c
> +++ b/samples/bpf/tcp_cong_kern.c
> @@ -5,7 +5,7 @@
>   * License as published by the Free Software Foundation.
>   *
>   * BPF program to set congestion control to dctcp when both hosts are
> - * in the same datacenter (as deteremined by IPv6 prefix).
> + * in the same datacenter (as determined by IPv6 prefix).
>   *
>   * Use "bpftool cgroup attach $cg sock_ops $prog" to load this BPF program.
>   */
> diff --git a/samples/bpf/tracex1.bpf.c b/samples/bpf/tracex1.bpf.c
> index 0ab39d76ff8f..ceedf0b1d479 100644
> --- a/samples/bpf/tracex1.bpf.c
> +++ b/samples/bpf/tracex1.bpf.c
> @@ -20,7 +20,7 @@ SEC("kprobe.multi/__netif_receive_skb_core*")
>  int bpf_prog1(struct pt_regs *ctx)
>  {
>  	/* attaches to kprobe __netif_receive_skb_core,
> -	 * looks for packets on loobpack device and prints them
> +	 * looks for packets on loopback device and prints them
>  	 * (wildcard is used for avoiding symbol mismatch due to optimization)
>  	 */
>  	char devname[IFNAMSIZ];
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> index 59eefe2fed10..6cb3e5974990 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -624,7 +624,7 @@ static void handle_bar_read(unsigned int index, struct mdev_state *mdev_state,
>  		u8 lsr = 0;
>  
>  		mutex_lock(&mdev_state->rxtx_lock);
> -		/* atleast one char in FIFO */
> +		/* at least one char in FIFO */
>  		if (mdev_state->s[index].rxtx.head !=
>  				 mdev_state->s[index].rxtx.tail)
>  			lsr |= UART_LSR_DR;
> 





