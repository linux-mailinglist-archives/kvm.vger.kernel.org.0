Return-Path: <kvm+bounces-70461-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uORsI2Qhhmm/JwQAu9opvQ
	(envelope-from <kvm+bounces-70461-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 18:14:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 05446100D02
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 18:14:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 11507302C760
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 17:13:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A17993A1D12;
	Fri,  6 Feb 2026 17:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pp+u/PbV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D194D36C0C7;
	Fri,  6 Feb 2026 17:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770398030; cv=none; b=IreBVSST62V7XmGjrdvJgUZqp+/W3WpH1DipWnUY+8HBoBwIbe27bJr4jDzJtHT9QRd3C6Zu0ucLh5je/gPYTiT7NWhxS9x78zAL4NT1m7XtuKmATwSJ8oin03zAFloWp0EQR85oW8JoKwz7+NXcxiMggrk3ZWjwYzt6GZnl1W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770398030; c=relaxed/simple;
	bh=GLzNiltKbkC1Pow+qhGIJkVK+++Chfm8SxgjlZAIaN4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fBr0DNLnLE7QXwz9nSy3aiw2WPOY7U4KqBIQKexikmOY0YVhQqhdb7jtD++mkNLMGL9eXAPqi7ZXH0vTmpDeRwk1FqfVwQ5/jc5JTpYrwbYbgBqcHPTOWKj72HImcQWx6xukw6AoYiBX0cdIDORrtZFO2e4XjHrgsVS0BkyZJVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pp+u/PbV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF1BC19423;
	Fri,  6 Feb 2026 17:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770398030;
	bh=GLzNiltKbkC1Pow+qhGIJkVK+++Chfm8SxgjlZAIaN4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pp+u/PbVSWQA84fO+VdvbGB/pOEKDgdosJkXeD0tCqvEV90UhoYRHKLTzUHj8E8nX
	 YQV+xGkSD/dw/IsCbKVBx9lXoSmiNHZFCKt8Jlvg0oJw1eeTZOzbmvt/M1ohftVvKI
	 EV60JNljbvlJRoMM7KMY7gW2wRhqcGyGShr+9dOweHsc4g9SriZVo/+C6oaeKoPA92
	 mntzdpAZkd3B4mM1cznnn5AXOd3XUvtWNQ1xe96fO02TABaj7jjhoK9RvOVOgkpYKj
	 uM9xgJPcp/Uc1QH+gg7OeHpbKjR+IaYYRVJQ7Nuw8wd84UeS2TdMwCPgpehYxDndzY
	 3BCnL1Uco332g==
Message-ID: <d7724321-3e04-4fc3-be64-e19a6103de64@kernel.org>
Date: Fri, 6 Feb 2026 18:13:44 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: Stalls when starting a VSOCK listening socket: soft lockups, RCU
 stalls, timeout
Content-Language: en-GB, fr-BE
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, Netdev <netdev@vger.kernel.org>,
 rcu@vger.kernel.org, MPTCP Linux <mptcp@lists.linux.dev>,
 Linux Kernel <linux-kernel@vger.kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>,
 Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 "Paul E. McKenney" <paulmck@kernel.org>
References: <b24ffcb3-09d5-4e48-9070-0b69bc654281@kernel.org>
 <aYYWQHiu8j_Zlu3v@sgarzare-redhat>
From: Matthieu Baerts <matttbe@kernel.org>
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <aYYWQHiu8j_Zlu3v@sgarzare-redhat>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70461-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	HAS_ORG_HEADER(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[matttbe@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mptcp.dev:url]
X-Rspamd-Queue-Id: 05446100D02
X-Rspamd-Action: no action

Hi Stefano,

Thank you for your reply!

On 06/02/2026 17:38, Stefano Garzarella wrote:
> On Fri, Feb 06, 2026 at 12:54:13PM +0100, Matthieu Baerts wrote:
>> Hi Stefan, Stefano, + VM, RCU, sched people,
> 
> Hi Matt,
> 
>>
>> First, I'm sorry to cc a few MLs, but I'm still trying to locate the
>> origin of the issue I'm seeing.
>>
>> Our CI for the MPTCP subsystem is now regularly hitting various stalls
>> before even starting the MPTCP test suite. These issues are visible on
>> top of the latest net and net-next trees, which have been sync with
>> Linus' tree yesterday. All these issues have been seen on a "public CI"
>> using GitHub-hosted runners with KVM support, where the tested kernel is
>> launched in a nested (I suppose) VM. I can see the issue with or without
> 
> Just to be sure I'm on the same page, the issue is in the most nested
> guest, right? (the last VM started)

That's correct. From what I see [1], each GitHub-hosted runner is a new
VM, and I'm launching QEmu from there.

[1]
https://docs.github.com/en/actions/concepts/runners/github-hosted-runners

>> debug.config. According to the logs, it might have started around
>> v6.19-rc0, but I was unavailable for a few weeks, and I couldn't react
>> quicker, sorry for that. Unfortunately, I cannot reproduce this locally,
>> and the CI doesn't currently have the ability to execute bisections.
>>
>> The stalls happen before starting the MPTCP test suite. The init program
>> creates a VSOCK listening socket via socat [1], and different hangs are
>> then visible: RCU stalls followed by a soft lockup [2], only a soft
>> lockup [3], sometimes the soft lockup comes with a delay [4] [5], or
>> there is no RCU stalls or soft lockups detected after one minute, but VM
>> is stalled [6]. In the last case, the VM is stopped after having
>> launched GDB to get more details about what was being executed.
>>
>> It feels like the issue is not directly caused by the VSOCK listening
>> socket, but the stalls always happen after having started the socat
>> command [1] in the background.
>>
>> One last thing: I thought my issue was linked to another one seen on XFS
>> side and reported by Shinichiro Kawasaki [7], but apparently not.
>> Indeed, Paul McKenney mentioned Shinichiro's issue is probably fixed by
>> Thomas Gleixner's series called "sched/mmcid: Cure mode transition woes"
>> [8]. I applied these patches from Peter Zijlstra's tree from
>> tip/sched/urgent [9], and my issue is still present.
>>
>> Any idea what could cause that, where to look at, or what could help to
>> find the root cause?
> 
> Mmm, nothing comes to mind at the vsock side :-(

That's OK, thank you for having checked! I hope someone else in CC can
help me finding the root cause!

> I understand that bisection can't be done in the CI env, but can you
> confirm in some way that 6.18 is working right with the same userspace?

Yes, I can confirm that. We run the tests on both the dev ("export") and
fixes ("export-net") branches, but also on stable versions:

  https://ci-results.mptcp.dev/flakes.html

(The "critical issues" have their headers red)

We don't see such issues in v6.18 and old kernels.

> That could help to try to identify at least if there is anything in
> AF_VSOCK we merged recently that can trigger that.

Our dev branch is on top of net-next, I guess I would have seen issues
directly related to AF_VSOCK earlier than after the net-next freeze in
January. Here, it looks like the first issues came during Linus' merge
window from the beginning of December, e.g. [2] is from the 4th of
December, on top of 'net' which was at commit 8f7aa3d3c732 ("Merge tag
'net-next-6.19' of
git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next") from
Linus tree.

[2]
https://github.com/multipath-tcp/mptcp_net-next/actions/runs/19919313666/job/57104626001#step:7:5052

Cheers,
Matt
-- 
Sponsored by the NGI0 Core fund.


