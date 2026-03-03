Return-Path: <kvm+bounces-72525-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0Bx2C/DhpmkPYQAAu9opvQ
	(envelope-from <kvm+bounces-72525-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 14:28:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F1E51F0382
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 14:28:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BCF1130D9428
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 13:24:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02CCB43D501;
	Tue,  3 Mar 2026 13:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RUqskrCw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274F6345CD3;
	Tue,  3 Mar 2026 13:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772544224; cv=none; b=eQHQONCdbku/dIBWMvUxSYgOC2LTupXX8Ij/8Qo55efTAJ9/fyMVpc458aUxB09meYSj+sD0AmqGr/jgpfwYwFKgbQUIBeD5apPL9ruDRin3HxigyBezEFXNsGI2p43KBK3GBy53hBVSod4mfXV7p4sk+Pvz/7gvXpRN7cuExVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772544224; c=relaxed/simple;
	bh=QXKFZaIGCPMx+aACFmMjJlQcbli93BFDeSlduovypIE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oYvFByKF4oBMoOxG2Fuk6yJDlbM2xNVjCXLjge33phcmrdHQLtAKBL1VW6lYO0xw85tymfAdh/G7pLvE8ABx/1CFqwDV01zM/GocT2kaHa3YWr6Y7qkufXcl36gXmOoXnXoAD/M3V0fWdfv2995hgcNm+dvnGfAqoQmPeYb7u7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RUqskrCw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D507C116C6;
	Tue,  3 Mar 2026 13:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772544223;
	bh=QXKFZaIGCPMx+aACFmMjJlQcbli93BFDeSlduovypIE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RUqskrCwytKCoz7NpxBgmM4C3jhH3crzoSTNxyVDDTwdv8G6ut6sKfUyApTW2XPoX
	 9WHaPeALwgD1XPhAKHOr8dE5Mmp1hV0mv0icFbbVLyfqOMlB3UFv/NkSMzIy7aazPM
	 LdTVjsG8/D2BW2Zl/G9fcDN8ulWmHcRG52y8mHgO0MyvHUIjhvPYk2YZ18z0zXPDpj
	 yuJOHNq8K+qFXpcELSHkihdCXpjX+HOVnTo0OJK69xLWZ/AgFFQfFspe14PlLLfoZJ
	 NKogQHOeytqZA3J7+vluUG0QdVF0rs6keDsM4BukFNuOL5XGuuFpvWPQbjoNvL4Gc4
	 iY8vhh/W4qIcw==
Message-ID: <29d38308-e8ae-42aa-8eeb-1c3b347c284b@kernel.org>
Date: Tue, 3 Mar 2026 14:23:32 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Stalls when starting a VSOCK listening socket: soft lockups, RCU
 stalls, timeout
Content-Language: en-GB, fr-BE
To: Jiri Slaby <jirislaby@kernel.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev,
 Netdev <netdev@vger.kernel.org>, rcu@vger.kernel.org,
 MPTCP Linux <mptcp@lists.linux.dev>,
 Linux Kernel <linux-kernel@vger.kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>,
 Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, "luto@kernel.org" <luto@kernel.org>,
 Stefano Garzarella <sgarzare@redhat.com>
References: <b24ffcb3-09d5-4e48-9070-0b69bc654281@kernel.org>
 <7f3e74d7-67dc-48d7-99d2-0b87f671651b@kernel.org>
From: Matthieu Baerts <matttbe@kernel.org>
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <7f3e74d7-67dc-48d7-99d2-0b87f671651b@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8F1E51F0382
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72525-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[matttbe@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,suse.com:url]
X-Rspamd-Action: no action

Hi Jiri,

On 26/02/2026 11:37, Jiri Slaby wrote:
> On 06. 02. 26, 12:54, Matthieu Baerts wrote:
>> Our CI for the MPTCP subsystem is now regularly hitting various stalls
>> before even starting the MPTCP test suite. These issues are visible on
>> top of the latest net and net-next trees, which have been sync with
>> Linus' tree yesterday. All these issues have been seen on a "public CI"
>> using GitHub-hosted runners with KVM support, where the tested kernel is
>> launched in a nested (I suppose) VM. I can see the issue with or without
>> debug.config. According to the logs, it might have started around
>> v6.19-rc0, but I was unavailable for a few weeks, and I couldn't react
>> quicker, sorry for that. Unfortunately, I cannot reproduce this locally,
>> and the CI doesn't currently have the ability to execute bisections.
> 
> Hmm, after the switch of the qemu guest kernels to 6.19, our (opensuse)
> build service is stalling in smp_call_function_many_cond() randomly too:
> https://bugzilla.suse.com/show_bug.cgi?id=1258936
> 
> The attachment from there contains sysrq-t logs too:
> https://bugzilla.suse.com/attachment.cgi?id=888612

I'm glad I'm not the only one with this issue :)

In your case, do you also have nested VMs with KVM support?

Are you able to easily reproduce the issue and change the guest kernel
in your build service?

On my side, any debugging steps need to be automated. Lately, it looks
like the issue is more easily triggered on a stable 6.19 kernel, than on
the last RC.

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
> 
> It fails randomly while building random packages (go, libreoffice,
> bayle, ...). I don't think it is VSOCK related in those cases, but who
> knows what the builds do...

Indeed, unlikely to be VSOCK then.

> I cannot reproduce locally either.
> 
> I came across:
>   614da1d3d4cd x86: make page fault handling disable interrupts properly
> but I have no idea if it could have impact on this at all.

Did it help to revert it?

Cheers,
Matt
-- 
Sponsored by the NGI0 Core fund.


