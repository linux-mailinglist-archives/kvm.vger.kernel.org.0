Return-Path: <kvm+bounces-73247-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ID3cApqwrWnh6AEAu9opvQ
	(envelope-from <kvm+bounces-73247-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 08 Mar 2026 18:23:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EBC9023163F
	for <lists+kvm@lfdr.de>; Sun, 08 Mar 2026 18:23:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 21054300693E
	for <lists+kvm@lfdr.de>; Sun,  8 Mar 2026 17:23:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFCEC3939C7;
	Sun,  8 Mar 2026 17:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AxLf6j4G"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB63286412;
	Sun,  8 Mar 2026 17:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772990597; cv=none; b=UcqAVlZKBurGLSAxMpHkkehx08H8IanslVA7E2PMNf01cE8Msqyo9TYmtHDhABqxltKb737Qvj/Xhj4RtTAmV11vY77o+N3dIypFqCyfehiCh9PDgT1WTAvWtp241+pGBq+MbB8T4S8yNfsfpPZjl8U4cDFXNdV4dBEgDCieZuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772990597; c=relaxed/simple;
	bh=aKTiLeBUT/yyVrfF+UX9Dm/tjm0IVzbkGDksBmzpY0Y=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=PioeYBUGINGx9gCVU2T51vtI971lTBzSDOiS+B2wZpQOjhVgbgbqoxcEstd3hsvcDntq2wAtGFZoQRGjqhkq4dJTpEG6G0bF1kUJHoZi2CRWgBwH7PZ1AkMndoX0N4Hi3NxUI7OGoSBYiUJK4yOUpHLuPkicdqAPkZ4NKRKd1Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AxLf6j4G; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC301C116C6;
	Sun,  8 Mar 2026 17:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772990596;
	bh=aKTiLeBUT/yyVrfF+UX9Dm/tjm0IVzbkGDksBmzpY0Y=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=AxLf6j4GvGHT+C8ZRyPQ8SdmNN8dUN+vRNWyNZgN/eeKcMM83VgsKiv2Thvnni7mF
	 CfgmTPF5cBDong5YKy9PoAEZZLFYWmSGaY/yFgJtjGTUB++iQ0ZTbwUwg41cVL2Hb4
	 aVDzcTTxsw+4N3cFJLEvBKbS0+/gIDH6gRh1dsIbaYxkTvJmMEHmDQkpGBhoMAbTtQ
	 yiPpUo051i5ohiLr/B8HHuV9Jw6JIpHsXv65F8axnnjl4GvPp5YG5dLQbEOC3wVSye
	 wmL+EvQq9IJY1MIDsWdo/YtrWIjcfslHSeKCRPBvaG1GdZz4KFU1L8KJDa5bRAczNO
	 ioxyQ4Cvo8vUQ==
Date: Sun, 8 Mar 2026 18:23:08 +0100
From: Matthieu Baerts <matttbe@kernel.org>
To: Thomas Gleixner <tglx@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Jiri Slaby <jirislaby@kernel.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, Netdev <netdev@vger.kernel.org>,
	rcu@vger.kernel.org, MPTCP Linux <mptcp@lists.linux.dev>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>, luto@kernel.org,
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <MKoutny@suse.com>,
	Waiman Long <longman@redhat.com>, Marco Elver <elver@google.com>
Message-ID: <57c1e171-9520-4288-9e2d-10a72a499968@kernel.org>
In-Reply-To: <87v7f61cnl.ffs@tglx>
References: <863a5291-a636-47d0-891c-bb0524d2e134@kernel.org> <20260302114636.GL606826@noisy.programming.kicks-ass.net> <717310d8-6274-4b7f-8a19-561c45f5f565@kernel.org> <a2b573b4-af61-4b84-a7d1-012ed6bb23c9@kernel.org> <ba067933-bf3b-476d-a0bb-53eda56996ca@kernel.org> <87zf4m2qvo.ffs@tglx> <47cba228-bba7-4e58-a69d-ea41f8de6602@kernel.org> <87tsuu2i59.ffs@tglx> <7efde2b5-3b72-4858-9db0-22493d446301@kernel.org> <87qzpx2sck.ffs@tglx> <20260306152458.GT606826@noisy.programming.kicks-ass.net> <87ldg42eu7.ffs@tglx> <87h5qr2rzi.ffs@tglx> <87eclu3coa.ffs@tglx> <87v7f61cnl.ffs@tglx>
Subject: Re: Stalls when starting a VSOCK listening socket: soft lockups,
 RCU stalls, timeout
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Correlation-ID: <57c1e171-9520-4288-9e2d-10a72a499968@kernel.org>
X-Rspamd-Queue-Id: EBC9023163F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73247-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-0.923];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[matttbe@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

08 Mar 2026 17:58:26 Thomas Gleixner <tglx@kernel.org>:

> On Sun, Mar 08 2026 at 10:15, Thomas Gleixner wrote:
>
>> On Sat, Mar 07 2026 at 23:29, Thomas Gleixner wrote:
>>> I'll look at it more tomorrow in the hope that this rested brain
>>> approach works out again.
>>
>> There is another one of the same category. Combo patch below.
>
> This rested brain thing is clearly a myth. The patch actually solves
> nothing because the code ensures that the TRANSIT bit is never set
> together with the ONCPU bit.

Thank you for having shared these patches. I confirm the myth: I can
still reproduce the issue on my side.

> One of those moments where you just hope that the earth opens up and
> swallows you.
>
> So I'm back to square one. I go and do what I should have done in the
> first place. Write a debug patch with trace_printks and let the people
> who can actually trigger the problem run with it.

Happy to test such debug patches!

Cheers,
Matt

