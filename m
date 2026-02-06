Return-Path: <kvm+bounces-70436-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sIv4OX/WhWl7HAQAu9opvQ
	(envelope-from <kvm+bounces-70436-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 12:54:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 241BDFD639
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 12:54:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B03693034DDA
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 11:54:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D3283A0E8F;
	Fri,  6 Feb 2026 11:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AO4waCPl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F0A374738;
	Fri,  6 Feb 2026 11:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770378859; cv=none; b=LB/es5LhdBW0H47P95YVUWgA/DZlw2Q4wR6TnWQPtvZnMFI75V56Y0JO4/zl+7xYDmr7biRIDzq1Sfb5WzoLrHseL/ab90WWnDehQCS8kKk3van4W5WV/y49YxQlVRx6UnrpFLyMZwesZHmt11KXSfzUy4SUkm+WcBMG++BKWHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770378859; c=relaxed/simple;
	bh=Pe56j0HaKrszANh8yLrsT8yt2Dq0fHW7HJT8K/0C1m0=;
	h=Message-ID:Date:MIME-Version:From:To:Cc:Subject:Content-Type; b=ojBTdcixruPOBmBsHGYB/PvqAgDnVkni7oiEB8s7bJkG6QTCmtjCjXm6iN+ym0t9/Xfv1iLlZ2ZohbUBf3rzsNZykBbz+6Sm8Jwt+rlgW9OLtIjpWa1tQShYnadBQmdzoRh9Rgkg+qLQIe1b92CkO5E5Y3+dpOJ8VNNLNV3uu3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AO4waCPl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47926C116C6;
	Fri,  6 Feb 2026 11:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770378859;
	bh=Pe56j0HaKrszANh8yLrsT8yt2Dq0fHW7HJT8K/0C1m0=;
	h=Date:From:To:Cc:Subject:From;
	b=AO4waCPlwbAz9hcOaao+XEHaLzVSCW8kneAI8xLwpn8q0bImYWE7sxfVKGjKqV6km
	 GK9IFl9SaV0Qsg1rXCC8/oHmHShlBqap76og0zHUGRm5u2ZwQsfoZM/tyWlPSe+gOR
	 ipfWKcMz+x4RdEYInL8KaBk1TyD70t+I6iTvkH1nhrfGQLBAT3Sb4egeNmFBUJjoab
	 +qfSmQubyAz6FxZmYdnQlzRPvIrYcnuRL6YDD2zTpOAGt5+sinuvhS9WGEyTGOkHdy
	 NJnO3+IARz0G0W5BsbISu6mK1ekfAQPOGZKME2bIgDW0T7gaC9Q3prPhb88nNMznwi
	 yd4saZ6I+671Q==
Message-ID: <b24ffcb3-09d5-4e48-9070-0b69bc654281@kernel.org>
Date: Fri, 6 Feb 2026 12:54:13 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
From: Matthieu Baerts <matttbe@kernel.org>
Content-Language: en-GB, fr-BE
To: Stefan Hajnoczi <stefanha@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev,
 Netdev <netdev@vger.kernel.org>, rcu@vger.kernel.org,
 MPTCP Linux <mptcp@lists.linux.dev>,
 Linux Kernel <linux-kernel@vger.kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>,
 Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 "Paul E. McKenney" <paulmck@kernel.org>
Subject: Stalls when starting a VSOCK listening socket: soft lockups, RCU
 stalls, timeout
Autocrypt: addr=matttbe@kernel.org; keydata=
 xsFNBFXj+ekBEADxVr99p2guPcqHFeI/JcFxls6KibzyZD5TQTyfuYlzEp7C7A9swoK5iCvf
 YBNdx5Xl74NLSgx6y/1NiMQGuKeu+2BmtnkiGxBNanfXcnl4L4Lzz+iXBvvbtCbynnnqDDqU
 c7SPFMpMesgpcu1xFt0F6bcxE+0ojRtSCZ5HDElKlHJNYtD1uwY4UYVGWUGCF/+cY1YLmtfb
 WdNb/SFo+Mp0HItfBC12qtDIXYvbfNUGVnA5jXeWMEyYhSNktLnpDL2gBUCsdbkov5VjiOX7
 CRTkX0UgNWRjyFZwThaZADEvAOo12M5uSBk7h07yJ97gqvBtcx45IsJwfUJE4hy8qZqsA62A
 nTRflBvp647IXAiCcwWsEgE5AXKwA3aL6dcpVR17JXJ6nwHHnslVi8WesiqzUI9sbO/hXeXw
 TDSB+YhErbNOxvHqCzZEnGAAFf6ges26fRVyuU119AzO40sjdLV0l6LE7GshddyazWZf0iac
 nEhX9NKxGnuhMu5SXmo2poIQttJuYAvTVUNwQVEx/0yY5xmiuyqvXa+XT7NKJkOZSiAPlNt6
 VffjgOP62S7M9wDShUghN3F7CPOrrRsOHWO/l6I/qJdUMW+MHSFYPfYiFXoLUZyPvNVCYSgs
 3oQaFhHapq1f345XBtfG3fOYp1K2wTXd4ThFraTLl8PHxCn4ywARAQABzSRNYXR0aGlldSBC
 YWVydHMgPG1hdHR0YmVAa2VybmVsLm9yZz7CwZEEEwEIADsCGwMFCwkIBwIGFQoJCAsCBBYC
 AwECHgECF4AWIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZUDpDAIZAQAKCRD2t4JPQmmgcz33
 EACjROM3nj9FGclR5AlyPUbAq/txEX7E0EFQCDtdLPrjBcLAoaYJIQUV8IDCcPjZMJy2ADp7
 /zSwYba2rE2C9vRgjXZJNt21mySvKnnkPbNQGkNRl3TZAinO1Ddq3fp2c/GmYaW1NWFSfOmw
 MvB5CJaN0UK5l0/drnaA6Hxsu62V5UnpvxWgexqDuo0wfpEeP1PEqMNzyiVPvJ8bJxgM8qoC
 cpXLp1Rq/jq7pbUycY8GeYw2j+FVZJHlhL0w0Zm9CFHThHxRAm1tsIPc+oTorx7haXP+nN0J
 iqBXVAxLK2KxrHtMygim50xk2QpUotWYfZpRRv8dMygEPIB3f1Vi5JMwP4M47NZNdpqVkHrm
 jvcNuLfDgf/vqUvuXs2eA2/BkIHcOuAAbsvreX1WX1rTHmx5ud3OhsWQQRVL2rt+0p1DpROI
 3Ob8F78W5rKr4HYvjX2Inpy3WahAm7FzUY184OyfPO/2zadKCqg8n01mWA9PXxs84bFEV2mP
 VzC5j6K8U3RNA6cb9bpE5bzXut6T2gxj6j+7TsgMQFhbyH/tZgpDjWvAiPZHb3sV29t8XaOF
 BwzqiI2AEkiWMySiHwCCMsIH9WUH7r7vpwROko89Tk+InpEbiphPjd7qAkyJ+tNIEWd1+MlX
 ZPtOaFLVHhLQ3PLFLkrU3+Yi3tXqpvLE3gO3LM7BTQRV4/npARAA5+u/Sx1n9anIqcgHpA7l
 5SUCP1e/qF7n5DK8LiM10gYglgY0XHOBi0S7vHppH8hrtpizx+7t5DBdPJgVtR6SilyK0/mp
 9nWHDhc9rwU3KmHYgFFsnX58eEmZxz2qsIY8juFor5r7kpcM5dRR9aB+HjlOOJJgyDxcJTwM
 1ey4L/79P72wuXRhMibN14SX6TZzf+/XIOrM6TsULVJEIv1+NdczQbs6pBTpEK/G2apME7vf
 mjTsZU26Ezn+LDMX16lHTmIJi7Hlh7eifCGGM+g/AlDV6aWKFS+sBbwy+YoS0Zc3Yz8zrdbi
 Kzn3kbKd+99//mysSVsHaekQYyVvO0KD2KPKBs1S/ImrBb6XecqxGy/y/3HWHdngGEY2v2IP
 Qox7mAPznyKyXEfG+0rrVseZSEssKmY01IsgwwbmN9ZcqUKYNhjv67WMX7tNwiVbSrGLZoqf
 Xlgw4aAdnIMQyTW8nE6hH/Iwqay4S2str4HZtWwyWLitk7N+e+vxuK5qto4AxtB7VdimvKUs
 x6kQO5F3YWcC3vCXCgPwyV8133+fIR2L81R1L1q3swaEuh95vWj6iskxeNWSTyFAVKYYVskG
 V+OTtB71P1XCnb6AJCW9cKpC25+zxQqD2Zy0dK3u2RuKErajKBa/YWzuSaKAOkneFxG3LJIv
 Hl7iqPF+JDCjB5sAEQEAAcLBXwQYAQIACQUCVeP56QIbDAAKCRD2t4JPQmmgc5VnD/9YgbCr
 HR1FbMbm7td54UrYvZV/i7m3dIQNXK2e+Cbv5PXf19ce3XluaE+wA8D+vnIW5mbAAiojt3Mb
 6p0WJS3QzbObzHNgAp3zy/L4lXwc6WW5vnpWAzqXFHP8D9PTpqvBALbXqL06smP47JqbyQxj
 Xf7D2rrPeIqbYmVY9da1KzMOVf3gReazYa89zZSdVkMojfWsbq05zwYU+SCWS3NiyF6QghbW
 voxbFwX1i/0xRwJiX9NNbRj1huVKQuS4W7rbWA87TrVQPXUAdkyd7FRYICNW+0gddysIwPoa
 KrLfx3Ba6Rpx0JznbrVOtXlihjl4KV8mtOPjYDY9u+8x412xXnlGl6AC4HLu2F3ECkamY4G6
 UxejX+E6vW6Xe4n7H+rEX5UFgPRdYkS1TA/X3nMen9bouxNsvIJv7C6adZmMHqu/2azX7S7I
 vrxxySzOw9GxjoVTuzWMKWpDGP8n71IFeOot8JuPZtJ8omz+DZel+WCNZMVdVNLPOd5frqOv
 mpz0VhFAlNTjU1Vy0CnuxX3AM51J8dpdNyG0S8rADh6C8AKCDOfUstpq28/6oTaQv7QZdge0
 JY6dglzGKnCi/zsmp2+1w559frz4+IC7j/igvJGX4KDDKUs0mlld8J2u2sBXv7CGxdzQoHaz
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70436-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 241BDFD639
X-Rspamd-Action: no action

Hi Stefan, Stefano, + VM, RCU, sched people,

First, I'm sorry to cc a few MLs, but I'm still trying to locate the
origin of the issue I'm seeing.

Our CI for the MPTCP subsystem is now regularly hitting various stalls
before even starting the MPTCP test suite. These issues are visible on
top of the latest net and net-next trees, which have been sync with
Linus' tree yesterday. All these issues have been seen on a "public CI"
using GitHub-hosted runners with KVM support, where the tested kernel is
launched in a nested (I suppose) VM. I can see the issue with or without
debug.config. According to the logs, it might have started around
v6.19-rc0, but I was unavailable for a few weeks, and I couldn't react
quicker, sorry for that. Unfortunately, I cannot reproduce this locally,
and the CI doesn't currently have the ability to execute bisections.

The stalls happen before starting the MPTCP test suite. The init program
creates a VSOCK listening socket via socat [1], and different hangs are
then visible: RCU stalls followed by a soft lockup [2], only a soft
lockup [3], sometimes the soft lockup comes with a delay [4] [5], or
there is no RCU stalls or soft lockups detected after one minute, but VM
is stalled [6]. In the last case, the VM is stopped after having
launched GDB to get more details about what was being executed.

It feels like the issue is not directly caused by the VSOCK listening
socket, but the stalls always happen after having started the socat
command [1] in the background.

One last thing: I thought my issue was linked to another one seen on XFS
side and reported by Shinichiro Kawasaki [7], but apparently not.
Indeed, Paul McKenney mentioned Shinichiro's issue is probably fixed by
Thomas Gleixner's series called "sched/mmcid: Cure mode transition woes"
[8]. I applied these patches from Peter Zijlstra's tree from
tip/sched/urgent [9], and my issue is still present.

Any idea what could cause that, where to look at, or what could help to
find the root cause?

Commit info, kernel config, vmlinux, etc. are available on the CI side
on GitHub -- you need to click on the Summary button at the top left --
but I can share them here if needed.

Cheers,
Matt


[1] socat "VSOCK-LISTEN:1024,reuseaddr,fork" \
      "EXEC:\"${vsock_exec}\",pty,stderr,setsid,sigint,sane,echo=0" &

[2] From:
https://github.com/multipath-tcp/mptcp_net-next/actions/runs/21723325004/job/62658752123#step:7:7288

> [   22.040424] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> [   22.043079] rcu: 	3-...0: (1 GPs behind) idle=b87c/1/0x4000000000000000 softirq=75/76 fqs=2100
> [   22.043387] rcu: 	(detected by 0, t=21005 jiffies, g=-1019, q=84 ncpus=4)
> [   22.043595] Sending NMI from CPU 0 to CPUs 3:
> [   22.043627] NMI backtrace for cpu 3
> [   22.043632] CPU: 3 UID: 0 PID: 0 Comm: swapper/3 Not tainted 6.19.0-rc7+ #1 PREEMPT(voluntary) 
> [   22.043635] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [   22.043637] RIP: 0010:__schedule (include/linux/cpumask.h:1222)
> [   22.043643] Code: 75 b4 e8 0e d1 a7 ff 3b 45 b4 48 8b 7d b8 8b 55 a8 41 89 c4 73 66 89 c0 f0 49 0f ab 86 50 06 00 00 73 31 eb 57 89 55 a8 f3 90 <8b> 35 39 c8 6a 00 48 89 7d b8 89 75 b4 e8 d9 d0 a7 ff 3b 45 b4 48
> All code
> ========
>    0:	75 b4                	jne    0xffffffffffffffb6
>    2:	e8 0e d1 a7 ff       	call   0xffffffffffa7d115
>   31:	83 c1 01             	add    $0x1,%ecx
>   34:	48 63 c1             	movslq %ecx,%rax
>   37:	48 83 f8 3f          	cmp    $0x3f,%rax
>   3b:	76 bc                	jbe    0xfffffffffffffff9
>   3d:	48                   	rex.W
>   3e:	83                   	.byte 0x83
>   3f:	c4                   	.byte 0xc4
> 
> Code starting with the faulting instruction
> ===========================================
>    0:	8b 42 08             	mov    0x8(%rdx),%eax
>    3:	a8 01                	test   $0x1,%al
>    5:	75 f7                	jne    0xfffffffffffffffe
>    7:	83 c1 01             	add    $0x1,%ecx
>    a:	48 63 c1             	movslq %ecx,%rax
>    d:	48 83 f8 3f          	cmp    $0x3f,%rax
>   11:	76 bc                	jbe    0xffffffffffffffcf
>   13:	48                   	rex.W
>   14:	83                   	.byte 0x83
>   15:	c4                   	.byte 0xc4
> [   28.498759] RSP: 0018:ffa0000000397b18 EFLAGS: 00000202
> [   28.498761] RAX: 0000000000000011 RBX: ff1100017acac340 RCX: 0000000000000003
> [   28.498762] RDX: ff1100017adb0aa0 RSI: 0000000000000003 RDI: 00007f27e4acf000
> [   28.498763] RBP: 0000000000000202 R08: ff1100017adb0aa0 R09: 0000000000000003
> [   28.498763] R10: ffffffffffffffff R11: 0000000000000003 R12: 0000000081484d01
> [   28.498764] R13: 0000000000000002 R14: ff1100017ac98000 R15: 0000000000000001
> [   28.498773] FS:  00007f27e50d86c0(0000) GS:ff110001f7d77000(0000) knlGS:0000000000000000
> [   28.498774] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   28.498775] CR2: 00007f27d8000020 CR3: 00000001009ac003 CR4: 0000000000373ef0
> [   28.498776] Call Trace:
> [   28.498817]  <TASK>
> [   28.498818]  ? __pfx_should_flush_tlb (arch/x86/mm/tlb.c:1298)
> [   28.498824]  ? __pfx_flush_tlb_func (arch/x86/mm/tlb.c:1125)
> [   28.498825]  ? unlink_anon_vmas (mm/rmap.c:438)
> [   28.498829]  on_each_cpu_cond_mask (arch/x86/include/asm/preempt.h:95 (discriminator 1))
> [   28.498830]  flush_tlb_mm_range (arch/x86/include/asm/paravirt.h:91)
> [   28.498832]  tlb_flush_mmu_tlbonly (include/asm-generic/tlb.h:407)
> [   28.498835]  tlb_finish_mmu (mm/mmu_gather.c:356)
> [   28.498837]  vms_clear_ptes (mm/vma.c:1279)
> [   28.498839]  vms_complete_munmap_vmas (include/linux/mm.h:2928)
> [   28.498841]  do_vmi_align_munmap (mm/vma.c:1580)
> [   28.498844]  do_vmi_munmap (mm/vma.c:1627)
> [   28.498846]  __vm_munmap (mm/vma.c:3247)
> [   28.498849]  __x64_sys_munmap (mm/mmap.c:1077 (discriminator 1))
> [   28.498850]  do_syscall_64 (arch/x86/entry/syscall_64.c:63 (discriminator 1))
> [   28.498855]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:131)
> [   28.498857] RIP: 0033:0x7f27e538d7bb
> [   28.498875] Code: 73 01 c3 48 c7 c1 e0 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 0b 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e0 ff ff ff f7 d8 64 89 01 48
> All code
> ========
>    0:	73 01                	jae    0x3
>    2:	c3                   	ret
>    3:	48 c7 c1 e0 ff ff ff 	mov    $0xffffffffffffffe0,%rcx
>    a:	f7 d8                	neg    %eax
>    c:	64 89 01             	mov    %eax,%fs:(%rcx)
>    f:	48 83 c8 ff          	or     $0xffffffffffffffff,%rax
>   13:	c3                   	ret
>   14:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
>   1b:	00 00 00 
>   1e:	90                   	nop
>   1f:	f3 0f 1e fa          	endbr64
>   23:	b8 0b 00 00 00       	mov    $0xb,%eax
>   28:	0f 05                	syscall
>   2a:*	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax		<-- trapping instruction
>   30:	73 01                	jae    0x33
>   32:	c3                   	ret
>   33:	48 c7 c1 e0 ff ff ff 	mov    $0xffffffffffffffe0,%rcx
>   3a:	f7 d8                	neg    %eax
>   3c:	64 89 01             	mov    %eax,%fs:(%rcx)
>   3f:	48                   	rex.W
> 
> Code starting with the faulting instruction
> ===========================================
>    0:	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax
>    6:	73 01                	jae    0x9
>    8:	c3                   	ret
>    9:	48 c7 c1 e0 ff ff ff 	mov    $0xffffffffffffffe0,%rcx
>   10:	f7 d8                	neg    %eax
>   12:	64 89 01             	mov    %eax,%fs:(%rcx)
>   15:	48                   	rex.W
> [   28.498876] RSP: 002b:00007f27e50d77f8 EFLAGS: 00000202 ORIG_RAX: 000000000000000b
> [   28.498878] RAX: ffffffffffffffda RBX: 0000000000009000 RCX: 00007f27e538d7bb
> [   28.498878] RDX: 00007f27e53cc280 RSI: 0000000000009000 RDI: 00007f27e4ac7000
> [   28.498879] RBP: 00007f27e50d7a80 R08: 000000000000004d R09: 0000000000000000
> [   28.498880] R10: 0000000000000008 R11: 0000000000000202 R12: 00007f27e4ac7000
> [   28.498880] R13: 00007f27e50d78a0 R14: 0000000000000001 R15: 0000000000000000
> [   28.498881]  </TASK>



[3]
https://github.com/multipath-tcp/mptcp_net-next/actions/runs/21723325004/job/62658752082#step:7:7609

> [   30.907497][    C1] watchdog: BUG: soft lockup - CPU#1 stuck for 26s! [virtme-ng-init:76]
> [   30.907506][    C1] Modules linked in:
> [   30.907510][    C1] irq event stamp: 53188
> [   30.907512][    C1] hardirqs last  enabled at (53187): irqentry_exit (kernel/entry/common.c:220)
> [   30.907521][    C1] hardirqs last disabled at (53188): sysvec_apic_timer_interrupt (arch/x86/include/asm/hardirq.h:78)
> [   30.907526][    C1] softirqs last  enabled at (52956): handle_softirqs (kernel/softirq.c:469 (discriminator 2))
> [   30.907531][    C1] softirqs last disabled at (52951): __irq_exit_rcu (kernel/softirq.c:657)
> [   30.907537][    C1] CPU: 1 UID: 0 PID: 76 Comm: virtme-ng-init Not tainted 6.19.0-rc7+ #1 PREEMPT(full) 
> [   30.907541][    C1] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [   30.907544][    C1] RIP: 0010:smp_call_function_many_cond (kernel/smp.c:351 (discriminator 5))
> [   30.907550][    C1] Code: cf 07 00 00 8b 43 08 a8 01 74 38 48 b8 00 00 00 00 00 fc ff df 49 89 f4 48 89 f5 49 c1 ec 03 83 e5 07 49 01 c4 83 c5 03 f3 90 <41> 0f b6 04 24 40 38 c5 7c 08 84 c0 0f 85 9c 08 00 00 8b 43 08 a8
> All code
> ========
>    0:	cf                   	iret
>    1:	07                   	(bad)
>    2:	00 00                	add    %al,(%rax)
>    4:	8b 43 08             	mov    0x8(%rbx),%eax
>    7:	a8 01                	test   $0x1,%al
>    9:	74 38                	je     0x43
>    b:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
>   12:	fc ff df 
>   15:	49 89 f4             	mov    %rsi,%r12
>   18:	48 89 f5             	mov    %rsi,%rbp
>   1b:	49 c1 ec 03          	shr    $0x3,%r12
>   1f:	83 e5 07             	and    $0x7,%ebp
>   22:	49 01 c4             	add    %rax,%r12
>   25:	83 c5 03             	add    $0x3,%ebp
>   28:	f3 90                	pause
>   2a:*	41 0f b6 04 24       	movzbl (%r12),%eax		<-- trapping instruction
>   2f:	40 38 c5             	cmp    %al,%bpl
>   32:	7c 08                	jl     0x3c
>   34:	84 c0                	test   %al,%al
>   36:	0f 85 9c 08 00 00    	jne    0x8d8
>   3c:	8b 43 08             	mov    0x8(%rbx),%eax
>   3f:	a8                   	.byte 0xa8
> 
> Code starting with the faulting instruction
> ===========================================
>    0:	41 0f b6 04 24       	movzbl (%r12),%eax
>    5:	40 38 c5             	cmp    %al,%bpl
>    8:	7c 08                	jl     0x12
>    a:	84 c0                	test   %al,%al
>    c:	0f 85 9c 08 00 00    	jne    0x8ae
>   12:	8b 43 08             	mov    0x8(%rbx),%eax
>   15:	a8                   	.byte 0xa8
> [   30.907553][    C1] RSP: 0018:ffffc9000101f6a0 EFLAGS: 00000202
> [   30.907555][    C1] RAX: 0000000000000011 RBX: ffff888152040c00 RCX: 0000000000000000
> [   30.907557][    C1] RDX: ffff8881520ba948 RSI: ffff888152040c08 RDI: 0000000000000000
> [   30.907559][    C1] RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000001
> [   30.907560][    C1] R10: 0000000000000001 R11: 00007f21a6200000 R12: ffffed102a408181
> [   30.907561][    C1] R13: ffff8881520ba940 R14: ffffed102a417529 R15: 0000000000000001
> [   30.907573][    C1] FS:  00007f21a69186c0(0000) GS:ffff8881cc22e000(0000) knlGS:0000000000000000
> [   30.907585][    C1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   30.907587][    C1] CR2: 00007f2198000020 CR3: 0000000107149002 CR4: 0000000000370ef0
> [   30.907591][    C1] Call Trace:
> [   30.907596][    C1]  <TASK>
> [   30.907603][    C1]  ? __pfx_should_flush_tlb (arch/x86/mm/tlb.c:1298)
> [   30.907612][    C1]  ? __pfx_flush_tlb_func (arch/x86/mm/tlb.c:1125)
> [   30.907626][    C1]  ? kasan_quarantine_put (arch/x86/include/asm/irqflags.h:26)
> [   30.907637][    C1]  ? __pfx_smp_call_function_many_cond (kernel/smp.c:784)
> [   30.907646][    C1]  ? kmem_cache_free (mm/slub.c:6674 (discriminator 3))
> [   30.907656][    C1]  ? __pfx_should_flush_tlb (arch/x86/mm/tlb.c:1298)
> [   30.907660][    C1]  on_each_cpu_cond_mask (kernel/smp.c:1044)
> [   30.907664][    C1]  ? __pfx_flush_tlb_func (arch/x86/mm/tlb.c:1125)
> [   30.907669][    C1]  kvm_flush_tlb_multi (arch/x86/kernel/kvm.c:666)
> [   30.907675][    C1]  ? __pfx_kvm_flush_tlb_multi (arch/x86/kernel/kvm.c:666)
> [   30.907679][    C1]  ? get_flush_tlb_info (arch/x86/mm/tlb.c:1434 (discriminator 1))
> [   30.907686][    C1]  flush_tlb_mm_range (arch/x86/include/asm/paravirt.h:91)
> [   30.907690][    C1]  ? rcu_read_lock_any_held (kernel/rcu/update.c:386 (discriminator 1))
> [   30.907695][    C1]  ? __pfx_flush_tlb_mm_range (arch/x86/mm/tlb.c:1452)
> [   30.907703][    C1]  tlb_flush_mmu_tlbonly (include/asm-generic/tlb.h:407)
> [   30.907712][    C1]  tlb_finish_mmu (mm/mmu_gather.c:356)
> [   30.907718][    C1]  vms_clear_ptes (mm/vma.c:1279)
> [   30.907724][    C1]  ? vms_complete_munmap_vmas (include/linux/mmap_lock.h:386)
> [   30.907728][    C1]  ? __pfx_vms_clear_ptes (mm/vma.c:1258)
> [   30.907738][    C1]  ? __pfx_mas_store_gfp (lib/maple_tree.c:5119)
> [   30.907747][    C1]  vms_complete_munmap_vmas (include/linux/mm.h:2928)
> [   30.907750][    C1]  ? vms_gather_munmap_vmas (mm/vma.c:1495)
> [   30.907776][    C1]  do_vmi_align_munmap (mm/vma.c:1580)
> [   30.907780][    C1]  ? lock_acquire.part.0 (kernel/locking/lockdep.c:470)
> [   30.907784][    C1]  ? find_held_lock (kernel/locking/lockdep.c:5350 (discriminator 1))
> [   30.907789][    C1]  ? __pfx_do_vmi_align_munmap (mm/vma.c:1561)
> [   30.907792][    C1]  ? __lock_release.isra.0 (kernel/locking/lockdep.c:5536)
> [   30.907800][    C1]  ? put_pid.part.0 (arch/x86/include/asm/atomic.h:93 (discriminator 4))
> [   30.907826][    C1]  do_vmi_munmap (mm/vma.c:1627)
> [   30.907832][    C1]  __vm_munmap (mm/vma.c:3247)
> [   30.907837][    C1]  ? __pfx___vm_munmap (mm/vma.c:3238)
> [   30.907841][    C1]  ? _copy_to_user (arch/x86/include/asm/uaccess_64.h:121)
> [   30.907858][    C1]  __x64_sys_munmap (mm/mmap.c:1077 (discriminator 1))
> [   30.907861][    C1]  ? lockdep_hardirqs_on (kernel/locking/lockdep.c:4473)
> [   30.907863][    C1]  ? do_syscall_64 (arch/x86/include/asm/irqflags.h:42)
> [   30.907866][    C1]  do_syscall_64 (arch/x86/entry/syscall_64.c:63 (discriminator 1))
> [   30.907871][    C1]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:131)
> [   30.907875][    C1] RIP: 0033:0x7f21a6bc47bb
> [   30.907880][    C1] Code: 73 01 c3 48 c7 c1 e0 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 0b 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e0 ff ff ff f7 d8 64 89 01 48
> All code
> ========
>    0:	73 01                	jae    0x3
>    2:	c3                   	ret
>    3:	48 c7 c1 e0 ff ff ff 	mov    $0xffffffffffffffe0,%rcx
>    a:	f7 d8                	neg    %eax
>    c:	64 89 01             	mov    %eax,%fs:(%rcx)
>    f:	48 83 c8 ff          	or     $0xffffffffffffffff,%rax
>   13:	c3                   	ret
>   14:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
>   1b:	00 00 00 
>   1e:	90                   	nop
>   1f:	f3 0f 1e fa          	endbr64
>   23:	b8 0b 00 00 00       	mov    $0xb,%eax
>   28:	0f 05                	syscall
>   2a:*	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax		<-- trapping instruction
>   30:	73 01                	jae    0x33
>   32:	c3                   	ret
>   33:	48 c7 c1 e0 ff ff ff 	mov    $0xffffffffffffffe0,%rcx
>   3a:	f7 d8                	neg    %eax
>   3c:	64 89 01             	mov    %eax,%fs:(%rcx)
>   3f:	48                   	rex.W
> 
> Code starting with the faulting instruction
> ===========================================
>    0:	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax
>    6:	73 01                	jae    0x9
>    8:	c3                   	ret
>    9:	48 c7 c1 e0 ff ff ff 	mov    $0xffffffffffffffe0,%rcx
>   10:	f7 d8                	neg    %eax
>   12:	64 89 01             	mov    %eax,%fs:(%rcx)
>   15:	48                   	rex.W
> [   30.907882][    C1] RSP: 002b:00007f21a69177f8 EFLAGS: 00000202 ORIG_RAX: 000000000000000b
> [   30.907884][    C1] RAX: ffffffffffffffda RBX: 0000000000009000 RCX: 00007f21a6bc47bb
> [   30.907886][    C1] RDX: 00007f21a6c03280 RSI: 0000000000009000 RDI: 00007f21a62fe000
> [   30.907887][    C1] RBP: 00007f21a6917a80 R08: 0000000000000050 R09: 0000000000000000
> [   30.907889][    C1] R10: 0000000000000008 R11: 0000000000000202 R12: 00007f21a62fe000
> [   30.907890][    C1] R13: 00007f21a69178a0 R14: 0000000000000001 R15: 0000000000000000
> [   30.907902][    C1]  </TASK>



[4]
https://github.com/multipath-tcp/mptcp_net-next/actions/runs/21741113372/job/62716612654#step:7:12820
[5]
https://github.com/multipath-tcp/mptcp_net-next/actions/runs/21741112047/job/62716608856#step:7:14820

[6]
https://github.com/multipath-tcp/mptcp_net-next/actions/runs/21741112047/job/62716608836#step:7:4811


# l

> virt_spin_lock (lock=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/arch/x86/include/asm/qspinlock.h:106
> 106			goto __retry;
> 101	 __retry:
> 102		val = atomic_read(&lock->val);
> 103	
> 104		if (val || !atomic_try_cmpxchg(&lock->val, &val, _Q_LOCKED_VAL)) {
> 105			cpu_relax();
> 106			goto __retry;
> 107		}
> 108	
> 109		return true;
> 110	}


# bt full

> #0  virt_spin_lock (lock=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/arch/x86/include/asm/qspinlock.h:106
>         val = <optimized out>
> #1  queued_spin_lock_slowpath (lock=0xff1100017acab300, val=0x1) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/locking/qspinlock.c:141
>         prev = <optimized out>
>         next = 0x1
>         node = <optimized out>
>         old = <optimized out>
>         tail = <optimized out>
>         idx = <optimized out>
>         locked = <optimized out>
>         __vpp_verify = <optimized out>
>         __vpp_verify = <optimized out>
>         pao_ID__ = <optimized out>
>         pao_tmp__ = <optimized out>
>         pto_val__ = <optimized out>
>         pto_tmp__ = <optimized out>
>         pao_ID__ = <optimized out>
>         pao_tmp__ = <optimized out>
>         pto_val__ = <optimized out>
>         pto_tmp__ = <optimized out>
>         pao_ID__ = <optimized out>
>         pao_tmp__ = <optimized out>
>         pto_val__ = <optimized out>
>         pto_tmp__ = <optimized out>
> #2  0xffffffff813de445 in raw_spin_rq_lock_nested (rq=0xff1100017acab300, subclass=0x1) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/core.c:639
>         lock = <optimized out>
> #3  0xffffffff813ef2d5 in raw_spin_rq_lock (rq=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/sched.h:1580
> No locals.
> #4  _raw_spin_rq_lock_irqsave (rq=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/sched.h:1600
>         flags = <optimized out>
>         __dummy = <optimized out>
>         __dummy2 = <optimized out>
> #5  rq_lock_irqsave (rq=<optimized out>, rf=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/sched.h:1893
> No locals.
> #6  sched_balance_rq (this_cpu=0x7acab300, this_rq=0x1, sd=0x1, idle=2060104448, continue_balancing=0x0) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/fair.c:11867
>         ld_moved = 0x1
>         cur_ld_moved = <optimized out>
>         active_balance = <optimized out>
>         sd_parent = <optimized out>
>         group = <optimized out>
>         busiest = <optimized out>
>         rf = <optimized out>
>         cpus = <optimized out>
>         env = {sd = 0xff1100010020b400, src_rq = 0xff1100017acab300, src_cpu = 0x1, dst_cpu = 0x0, dst_rq = 0xff1100017ac2b300, dst_grpmask = 0xff110001001e4930, new_dst_cpu = 0x0, idle = CPU_NEWLY_IDLE, imbalance = 0x1, cpus = 0xff1100017ac183e0, flags = 0x1, loop = 0x0, loop_break = 0x20, loop_max = 0x2, fbq_type = all, migration_type = migrate_task, tasks = <incomplete type>}
>         need_unlock = <optimized out>
>         redo = <optimized out>
>         more_balance = <optimized out>
>         __vpp_verify = <optimized out>
>         __dummy = <optimized out>
>         __dummy2 = <optimized out>
>         __vpp_verify = <optimized out>
> #7  0xffffffff813efe9b in sched_balance_newidle (this_rq=<optimized out>, rf=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/fair.c:12932
>         weight = <optimized out>
>         domain_cost = 0xff1100017acab300
>         next_balance = <optimized out>
>         this_cpu = 0x20b400
>         continue_balancing = 0x1
>         t0 = <optimized out>
>         t1 = <optimized out>
>         curr_cost = 0x0
>         sd = 0xff1100010020b400
>         pulled_task = 0x1
>         __dummy = <optimized out>
>         __dummy2 = <optimized out>
>         __dummy = <optimized out>
>         __dummy2 = <optimized out>
> #8  pick_next_task_fair (rq=0xff1100010020b400, prev=0x1, rf=0x1) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/fair.c:8973
>         se = 0xfffb6e65
>         p = <optimized out>
>         new_tasks = <optimized out>
>         again = <optimized out>
>         idle = <optimized out>
>         simple = <optimized out>
> #9  0xffffffff81e1337e in __pick_next_task (rq=<optimized out>, prev=<optimized out>, rf=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/core.c:5890
>         class = 0xff1100010224aa00
>         p = 0xffffffff824b34a8 <fair_sched_class>
>         restart = <optimized out>
> #10 pick_next_task (rq=<optimized out>, prev=<optimized out>, rf=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/core.c:6426
> No locals.
> #11 __schedule (sched_mode=0x7acab300) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/core.c:6809
>         prev = 0xff1100010146c380
>         next = 0xffffffff824b34a8 <fair_sched_class>
>         preempt = 0x1
>         is_switch = 0x1
>         switch_count = <optimized out>
>         prev_state = <optimized out>
>         rf = <incomplete type>
>         rq = <optimized out>
>         cpu = <optimized out>
>         keep_resched = <optimized out>
>         __vpp_verify = <optimized out>
> #12 0xffffffff81e14097 in __schedule_loop (sched_mode=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/core.c:6949
> No locals.
> #13 schedule () at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/core.c:6964
>         tsk = <optimized out>
> #14 0xffffffff8179e372 in request_wait_answer (req=0xff11000100910160) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/fuse/dev.c:552
>         __int = <optimized out>
>         __out = <optimized out>
>         __wq_entry = <incomplete type>
>         __ret = <optimized out>
>         __ret = <optimized out>
>         fc = 0xff110001023e6800
>         fiq = <optimized out>
>         err = <optimized out>
> #15 0xffffffff8179e5a0 in __fuse_request_send (req=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/fuse/dev.c:599
>         fiq = 0x0
> #16 __fuse_simple_request (idmap=0xff1100017acab300, fm=0x1, args=0x1) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/fuse/dev.c:693
>         fc = 0xff110001023e6800
>         req = 0xff11000100910160
>         ret = 0xff110001023e6800
> #17 0xffffffff817a47d9 in fuse_simple_request (fm=<optimized out>, args=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/fuse/fuse_i.h:1263
> No locals.
> #18 fuse_lookup_name (sb=0xff1100017acab300, nodeid=0x1, name=0x1, outarg=0xff1100017acab300, inode=0x0) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/fuse/dir.c:574
>         fm = <optimized out>
>         args = <incomplete type>
>         forget = <optimized out>
>         attr_version = <optimized out>
>         evict_ctr = <optimized out>
>         err = 0x411620
> #19 0xffffffff817a49c9 in fuse_lookup (dir=0xff11000100606a00, entry=0xff11000100411600, flags=0x1) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/fuse/fuse_i.h:1062
>         outarg = <incomplete type>
>         fc = <optimized out>
>         inode = 0x0
>         newent = 0xffa00000003afaf0
>         err = <optimized out>
>         epoch = <optimized out>
>         outarg_valid = 0x0
>         locked = <optimized out>
>         out_iput = <optimized out>
> #20 0xffffffff816c9e63 in __lookup_slow (name=0xff1100017acab300, dir=0x1, flags=0x1) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/namei.c:1866
>         dentry = 0xff11000100411600
>         old = <optimized out>
>         inode = 0xff11000100606a00
>         wq = <incomplete type>
> #21 0xffffffff816c9f69 in lookup_slow (name=0xff1100017acab300, dir=0x1, flags=0x1) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/namei.c:1883
>         inode = <optimized out>
>         res = <optimized out>
> #22 0xffffffff816cddd8 in walk_component (nd=<optimized out>, flags=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/namei.c:2229
>         dentry = 0x1
> #23 lookup_last (nd=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/namei.c:2730
> No locals.
> #24 path_lookupat (nd=0xff1100017acab300, flags=0x1, path=0x1) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/namei.c:2754
>         s = 0x1 <error: Cannot access memory at address 0x1>
>         err = <optimized out>
> #25 0xffffffff816cfee0 in filename_lookup (dfd=0x7acab300, name=0x1, flags=0x1, path=0xff1100017acab300, root=0x0) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/namei.c:2783
>         retval = 0x1
>         nd = {path = <incomplete type>, last = {{{hash = 0x314ef79d, len = 0x4}, hash_len = 0x4314ef79d}, name = 0xff110001009f1029 "dpkg"}, root = <incomplete type>, inode = 0xff11000100606a00, flags = 0x5, state = 0x2, seq = 0x0, next_seq = 0x0, m_seq = 0x34, r_seq = 0x4, last_type = 0x0, depth = 0x0, total_link_count = 0x0, stack = 0xffa00000003afcd8, internal = {{link = <incomplete type>, done = <incomplete type>, name = 0x0, seq = 0x0}, {link = <incomplete type>, done = <incomplete type>, name = 0x0, seq = 0x0}}, name = 0xff110001009f1000, pathname = 0xff110001009f1020 "/var/lib/dpkg", saved = 0x0, root_seq = 0x2, dfd = 0xffffff9c, dir_vfsuid = <incomplete type>, dir_mode = 0x41ed}
> #26 0xffffffff816c1a8c in vfs_statx (dfd=0x7acab300, filename=0x1, flags=0x1, stat=0xff1100017acab300, request_mask=0x0) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/stat.c:353
>         path = <incomplete type>
>         lookup_flags = 0x5
>         error = 0xffffff9c
> #27 0xffffffff816c2863 in do_statx (dfd=0x7acab300, filename=0x1, flags=0x1, mask=0x7acab300, buffer=0x0) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/stat.c:769
>         stat = {result_mask = 0x0, mode = 0x0, nlink = 0x0, blksize = 0x0, attributes = 0x0, attributes_mask = 0x0, ino = 0x0, dev = 0x0, rdev = 0x0, uid = <incomplete type>, gid = <incomplete type>, size = 0x0, atime = <incomplete type>, mtime = <incomplete type>, ctime = <incomplete type>, btime = <incomplete type>, blocks = 0x0, mnt_id = 0x0, change_cookie = 0x0, subvol = 0x0, dio_mem_align = 0x0, dio_offset_align = 0x0, dio_read_offset_align = 0x0, atomic_write_unit_min = 0x0, atomic_write_unit_max = 0x0, atomic_write_unit_max_opt = 0x0, atomic_write_segments_max = 0x0}
>         error = 0x1
> #28 0xffffffff816c2ab0 in __do_sys_statx (dfd=<optimized out>, filename=<optimized out>, flags=<optimized out>, mask=<optimized out>, buffer=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/stat.c:823
>         ret = 0xffffff9c
>         name = <error reading variable name (Cannot access memory at address 0x0)>
> #29 __se_sys_statx (dfd=<optimized out>, filename=<optimized out>, flags=<optimized out>, mask=<optimized out>, buffer=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/stat.c:812
>         ret = <optimized out>
> #30 __x64_sys_statx (regs=0xff1100017acab300) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/stat.c:812
> No locals.
> #31 0xffffffff81e07124 in do_syscall_x64 (regs=<optimized out>, nr=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/arch/x86/entry/syscall_64.c:63
>         unr = <optimized out>
> #32 do_syscall_64 (regs=0xff1100017acab300, nr=0x1) at /home/runner/work/mptcp_net-next/mptcp_net-next/arch/x86/entry/syscall_64.c:94
> No locals.
> #33 0xffffffff81000130 in entry_SYSCALL_64 () at /home/runner/work/mptcp_net-next/mptcp_net-next/arch/x86/entry/entry_64.S:122
> No locals.
> #34 0x000000000000000e in ?? ()
> No symbol table info available.
> #35 0x0000000000000001 in ?? ()
> No symbol table info available.
> #36 0x00007fff8cbcae40 in ?? ()
> No symbol table info available.
> #37 0x00007fbb012d6530 in ?? ()
> No symbol table info available.
> #38 0x00007fbb00d14c70 in ?? ()
> No symbol table info available.
> #39 0x00007fbb00d14e00 in ?? ()
> No symbol table info available.
> #40 0x0000000000000246 in ?? ()
> No symbol table info available.
> #41 0x0000000000000fff in ?? ()
> No symbol table info available.
> #42 0x0000000000000000 in ?? ()
> No symbol table info available.


# info frame ; info registers

> Stack level 0, frame at 0xffa00000003af740:
>  rip = 0xffffffff81e1c641 in virt_spin_lock (/home/runner/work/mptcp_net-next/mptcp_net-next/arch/x86/include/asm/qspinlock.h:106); saved rip = 0xffffffff813de445
>  inlined into frame 1
>  source language c.
>  Arglist at unknown address.
>  Locals at unknown address, Previous frame's sp in rsp
> rax            0x1                 0x1
> rbx            0xff1100017acab300  0xff1100017acab300
> rcx            0xff1100017acab300  0xff1100017acab300
> rdx            0x1                 0x1
> rsi            0x1                 0x1
> rdi            0xff1100017acab300  0xff1100017acab300
> rbp            0x2                 0x2
> rsp            0xffa00000003af738  0xffa00000003af738
> r8             0x0                 0x0
> r9             0x400               0x400
> r10            0x0                 0x0
> r11            0x2                 0x2
> r12            0x1                 0x1
> r13            0xff110001001e48c0  0xff110001001e48c0
> r14            0xffa00000003af810  0xffa00000003af810
> r15            0xff110001001e4940  0xff110001001e4940
> rip            0xffffffff81e1c641  0xffffffff81e1c641 <queued_spin_lock_slowpath+305>
> eflags         0x2                 [ IOPL=0 ]
> cs             0x10                0x10
> ss             0x18                0x18
> ds             0x0                 0x0
> es             0x0                 0x0
> fs             0x0                 0x0
> gs             0x0                 0x0
> fs_base        0x7fbb00d156c0      0x7fbb00d156c0
> gs_base        0xff110001f7cf7000  0xff110001f7cf7000
> k_gs_base      0x0                 0x0
> cr0            0x80050033          [ PG AM WP NE ET MP PE ]
> cr2            0x7fbaf8001118      0x7fbaf8001118
> cr3            0x1022df003         [ PDBR=1057503 PCID=3 ]
> cr4            0x373ef0            [ SMAP SMEP OSXSAVE PCIDE FSGSBASE VMXE LA57 UMIP OSXMMEXCPT OSFXSR PGE MCE PAE PSE ]
> cr8            0x1                 0x1
> efer           0xd01               [ NXE LMA LME SCE ]
> xmm0           {v4_float = {0x0, 0x0, 0x0, 0x0}, v2_double = {0x0, 0x0}, v16_int8 = {0x0 <repeats 16 times>}, v8_int16 = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, v4_int32 = {0x0, 0x0, 0x0, 0x0}, v2_int64 = {0x0, 0x0}, uint128 = 0x0}
> xmm1           {v4_float = {0x4, 0x0, 0x2c, 0x0}, v2_double = {0x4, 0x2c}, v16_int8 = {0x4, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x2c, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, v8_int16 = {0x4, 0x0, 0x0, 0x0, 0x2c, 0x0, 0x0, 0x0}, v4_int32 = {0x4, 0x0, 0x2c, 0x0}, v2_int64 = {0x4, 0x2c}, uint128 = 0x2c0000000000000004}
> xmm2           {v4_float = {0xf8000fb0, 0x7fba, 0x2c, 0x0}, v2_double = {0x7fbaf8000fb0, 0x2c}, v16_int8 = {0xb0, 0xf, 0x0, 0xf8, 0xba, 0x7f, 0x0, 0x0, 0x2c, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, v8_int16 = {0xfb0, 0xf800, 0x7fba, 0x0, 0x2c, 0x0, 0x0, 0x0}, v4_int32 = {0xf8000fb0, 0x7fba, 0x2c, 0x0}, v2_int64 = {0x7fbaf8000fb0, 0x2c}, uint128 = 0x2c00007fbaf8000fb0}
> xmm3           {v4_float = {0x59ff1020, 0x5555, 0x1e, 0x0}, v2_double = {0x555559ff1020, 0x1e}, v16_int8 = {0x20, 0x10, 0xff, 0x59, 0x55, 0x55, 0x0, 0x0, 0x1e, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, v8_int16 = {0x1020, 0x59ff, 0x5555, 0x0, 0x1e, 0x0, 0x0, 0x0}, v4_int32 = {0x59ff1020, 0x5555, 0x1e, 0x0}, v2_int64 = {0x555559ff1020, 0x1e}, uint128 = 0x1e0000555559ff1020}
> xmm4           {v4_float = {0xf8000090, 0x7fba, 0x0, 0x0}, v2_double = {0x7fbaf8000090, 0x0}, v16_int8 = {0x90, 0x0, 0x0, 0xf8, 0xba, 0x7f, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, v8_int16 = {0x90, 0xf800, 0x7fba, 0x0, 0x0, 0x0, 0x0, 0x0}, v4_int32 = {0xf8000090, 0x7fba, 0x0, 0x0}, v2_int64 = {0x7fbaf8000090, 0x0}, uint128 = 0x7fbaf8000090}
> xmm5           {v4_float = {0xff0000, 0x0, 0xff0000, 0x0}, v2_double = {0xff0000, 0xff0000}, v16_int8 = {0x0, 0x0, 0xff, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xff, 0x0, 0x0, 0x0, 0x0, 0x0}, v8_int16 = {0x0, 0xff, 0x0, 0x0, 0x0, 0xff, 0x0, 0x0}, v4_int32 = {0xff0000, 0x0, 0xff0000, 0x0}, v2_int64 = {0xff0000, 0xff0000}, uint128 = 0xff00000000000000ff0000}
> xmm6           {v4_float = {0xff0000, 0x0, 0x0, 0x0}, v2_double = {0xff0000, 0x0}, v16_int8 = {0x0, 0x0, 0xff, 0x0 <repeats 13 times>}, v8_int16 = {0x0, 0xff, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, v4_int32 = {0xff0000, 0x0, 0x0, 0x0}, v2_int64 = {0xff0000, 0x0}, uint128 = 0xff0000}
> xmm7           {v4_float = {0x0, 0x0, 0x0, 0x0}, v2_double = {0x0, 0x0}, v16_int8 = {0x0 <repeats 16 times>}, v8_int16 = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, v4_int32 = {0x0, 0x0, 0x0, 0x0}, v2_int64 = {0x0, 0x0}, uint128 = 0x0}
> xmm8           {v4_float = {0x0, 0x0, 0x0, 0x0}, v2_double = {0x0, 0x0}, v16_int8 = {0x0 <repeats 16 times>}, v8_int16 = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, v4_int32 = {0x0, 0x0, 0x0, 0x0}, v2_int64 = {0x0, 0x0}, uint128 = 0x0}
> xmm9           {v4_float = {0x0, 0x0, 0x0, 0x0}, v2_double = {0x0, 0x0}, v16_int8 = {0x0 <repeats 16 times>}, v8_int16 = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, v4_int32 = {0x0, 0x0, 0x0, 0x0}, v2_int64 = {0x0, 0x0}, uint128 = 0x0}
> xmm10          {v4_float = {0x0, 0x0, 0x0, 0x0}, v2_double = {0x0, 0x0}, v16_int8 = {0x0 <repeats 16 times>}, v8_int16 = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, v4_int32 = {0x0, 0x0, 0x0, 0x0}, v2_int64 = {0x0, 0x0}, uint128 = 0x0}
> xmm11          {v4_float = {0x0, 0x0, 0x0, 0x0}, v2_double = {0x0, 0x0}, v16_int8 = {0x0 <repeats 16 times>}, v8_int16 = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, v4_int32 = {0x0, 0x0, 0x0, 0x0}, v2_int64 = {0x0, 0x0}, uint128 = 0x0}
> xmm12          {v4_float = {0x0, 0x0, 0x0, 0x0}, v2_double = {0x0, 0x0}, v16_int8 = {0x0 <repeats 16 times>}, v8_int16 = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, v4_int32 = {0x0, 0x0, 0x0, 0x0}, v2_int64 = {0x0, 0x0}, uint128 = 0x0}
> xmm13          {v4_float = {0x0, 0x0, 0x0, 0x0}, v2_double = {0x0, 0x0}, v16_int8 = {0x0 <repeats 16 times>}, v8_int16 = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, v4_int32 = {0x0, 0x0, 0x0, 0x0}, v2_int64 = {0x0, 0x0}, uint128 = 0x0}
> xmm14          {v4_float = {0x0, 0x0, 0x0, 0x0}, v2_double = {0x0, 0x0}, v16_int8 = {0x0 <repeats 16 times>}, v8_int16 = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, v4_int32 = {0x0, 0x0, 0x0, 0x0}, v2_int64 = {0x0, 0x0}, uint128 = 0x0}
> xmm15          {v4_float = {0x0, 0x0, 0x0, 0x0}, v2_double = {0x0, 0x0}, v16_int8 = {0x0 <repeats 16 times>}, v8_int16 = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, v4_int32 = {0x0, 0x0, 0x0, 0x0}, v2_int64 = {0x0, 0x0}, uint128 = 0x0}
> mxcsr          0x1f80              [ IM DM ZM OM UM PM ]


# thread apply all bt full

> Thread 4 (Thread 1.4 (CPU#3 [running])):
> #0  virt_spin_lock (lock=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/arch/x86/include/asm/qspinlock.h:106
>         val = <optimized out>
> #1  queued_spin_lock_slowpath (lock=0xff1100017acab300, val=0x1) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/locking/qspinlock.c:141
>         prev = <optimized out>
>         next = 0x1
>         node = <optimized out>
>         old = <optimized out>
>         tail = <optimized out>
>         idx = <optimized out>
>         locked = <optimized out>
>         __vpp_verify = <optimized out>
>         __vpp_verify = <optimized out>
>         pao_ID__ = <optimized out>
>         pao_tmp__ = <optimized out>
>         pto_val__ = <optimized out>
>         pto_tmp__ = <optimized out>
>         pao_ID__ = <optimized out>
>         pao_tmp__ = <optimized out>
>         pto_val__ = <optimized out>
>         pto_tmp__ = <optimized out>
>         pao_ID__ = <optimized out>
>         pao_tmp__ = <optimized out>
>         pto_val__ = <optimized out>
>         pto_tmp__ = <optimized out>
> #2  0xffffffff813de445 in raw_spin_rq_lock_nested (rq=0xff1100017acab300, subclass=0x1) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/core.c:639
>         lock = <optimized out>
> #3  0xffffffff813ef2d5 in raw_spin_rq_lock (rq=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/sched.h:1580
> No locals.
> #4  _raw_spin_rq_lock_irqsave (rq=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/sched.h:1600
>         flags = <optimized out>
>         __dummy = <optimized out>
>         __dummy2 = <optimized out>
> #5  rq_lock_irqsave (rq=<optimized out>, rf=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/sched.h:1893
> No locals.
> #6  sched_balance_rq (this_cpu=0x7acab300, this_rq=0x1, sd=0x1, idle=2060104448, continue_balancing=0x0) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/fair.c:11867
>         ld_moved = 0x1
>         cur_ld_moved = <optimized out>
>         active_balance = <optimized out>
>         sd_parent = <optimized out>
>         group = <optimized out>
>         busiest = <optimized out>
>         rf = <optimized out>
>         cpus = <optimized out>
>         env = {sd = 0xff1100010020ba00, src_rq = 0xff1100017acab300, src_cpu = 0x1, dst_cpu = 0x3, dst_rq = 0xff1100017adab300, dst_grpmask = 0xff110001001e4ab0, new_dst_cpu = 0x0, idle = CPU_NEWLY_IDLE, imbalance = 0x1, cpus = 0xff1100017ad983e0, flags = 0x1, loop = 0x0, loop_break = 0x20, loop_max = 0x2, fbq_type = all, migration_type = migrate_task, tasks = <incomplete type>}
>         need_unlock = <optimized out>
>         redo = <optimized out>
>         more_balance = <optimized out>
>         __vpp_verify = <optimized out>
>         __dummy = <optimized out>
>         __dummy2 = <optimized out>
>         __vpp_verify = <optimized out>
> #7  0xffffffff813efe9b in sched_balance_newidle (this_rq=<optimized out>, rf=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/fair.c:12932
>         weight = <optimized out>
>         domain_cost = 0xff1100017acab300
>         next_balance = <optimized out>
>         this_cpu = 0x20ba00
>         continue_balancing = 0x1
>         t0 = <optimized out>
>         t1 = <optimized out>
>         curr_cost = 0x0
>         sd = 0xff1100010020ba00
>         pulled_task = 0x1
>         __dummy = <optimized out>
>         __dummy2 = <optimized out>
>         __dummy = <optimized out>
>         __dummy2 = <optimized out>
> #8  pick_next_task_fair (rq=0xff1100010020ba00, prev=0x1, rf=0x1) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/fair.c:8973
>         se = 0xfffb6e63
>         p = <optimized out>
>         new_tasks = <optimized out>
>         again = <optimized out>
>         idle = <optimized out>
>         simple = <optimized out>
> #9  0xffffffff81e1337e in __pick_next_task (rq=<optimized out>, prev=<optimized out>, rf=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/core.c:5890
>         class = 0x32
>         p = 0xffffffff824b34a8 <fair_sched_class>
>         restart = <optimized out>
> #10 pick_next_task (rq=<optimized out>, prev=<optimized out>, rf=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/core.c:6426
> No locals.
> #11 __schedule (sched_mode=0x7acab300) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/core.c:6809
>         prev = 0xff11000100238000
>         next = 0xffffffff824b34a8 <fair_sched_class>
>         preempt = 0x1
>         is_switch = 0x1
>         switch_count = <optimized out>
>         prev_state = <optimized out>
>         rf = <incomplete type>
>         rq = <optimized out>
>         cpu = <optimized out>
>         keep_resched = <optimized out>
>         __vpp_verify = <optimized out>
> #12 0xffffffff81e14097 in __schedule_loop (sched_mode=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/core.c:6949
> No locals.
> #13 schedule () at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/core.c:6964
>         tsk = <optimized out>
> #14 0xffffffff814833ba in futex_do_wait (q=0x1, timeout=0x1) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/futex/waitwake.c:358
> No locals.
> #15 0xffffffff81483b7e in __futex_wait (uaddr=0xff1100017acab300, flags=0x1, val=0x1, to=0xff1100017acab300, bitset=0x0) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/futex/waitwake.c:687
>         q = {list = <incomplete type>, task = 0xff11000100238000, lock_ptr = 0xff11000100a15684, wake = 0xffffffff81482a80 <futex_wake_mark>, wake_data = 0x0, key = {shared = {i_seq = 0xff11000102bf0000, pgoff = 0x7fbb00f16000, offset = 0x992}, private = {{mm = 0xff11000102bf0000, __tmp = 0xff11000102bf0000}, address = 0x7fbb00f16000, offset = 0x992}, both = {ptr = 0xff11000102bf0000, word = 0x7fbb00f16000, offset = 0x992, node = 0xffffffff}}, pi_state = 0x0, rt_waiter = 0x0, requeue_pi_key = 0x0, bitset = 0xffffffff, requeue_state = <incomplete type>, drop_hb_ref = 0x0}
>         ret = 0x1
> #16 0xffffffff81483c68 in futex_wait (uaddr=0xff1100017acab300, flags=0x1, val=0x1, abs_time=0xff1100017acab300, bitset=0x0) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/futex/waitwake.c:715
>         timeout = {timer = <incomplete type>, task = 0x0}
>         to = <optimized out>
>         restart = <optimized out>
>         ret = 0xffffffff
> #17 0xffffffff8147f4a5 in do_futex (uaddr=0xff1100017acab300, op=0x1, val=0x1, timeout=0xff1100017acab300, uaddr2=0x0, val2=0x400, val3=0xffffffff) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/futex/syscalls.c:130
>         flags = 0x1
>         cmd = <optimized out>
> #18 0xffffffff8147f6ad in __do_sys_futex (uaddr=<optimized out>, op=<optimized out>, val=<optimized out>, utime=<optimized out>, uaddr2=<optimized out>, val3=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/futex/syscalls.c:207
>         ret = <optimized out>
>         cmd = <optimized out>
>         t = 0x0
>         tp = 0xff1100017acab300
>         ts = <incomplete type>
> #19 __se_sys_futex (uaddr=<optimized out>, op=<optimized out>, val=<optimized out>, utime=<optimized out>, uaddr2=<optimized out>, val3=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/futex/syscalls.c:188
>         ret = <optimized out>
> #20 __x64_sys_futex (regs=0xff1100017acab300) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/futex/syscalls.c:188
> No locals.
> #21 0xffffffff81e07124 in do_syscall_x64 (regs=<optimized out>, nr=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/arch/x86/entry/syscall_64.c:63
>         unr = <optimized out>
> #22 do_syscall_64 (regs=0xff1100017acab300, nr=0x1) at /home/runner/work/mptcp_net-next/mptcp_net-next/arch/x86/entry/syscall_64.c:94
> No locals.
> #23 0xffffffff81000130 in entry_SYSCALL_64 () at /home/runner/work/mptcp_net-next/mptcp_net-next/arch/x86/entry/entry_64.S:122
> No locals.
> #24 0x0000000000000000 in ?? ()
> No symbol table info available.
> 
> Thread 3 (Thread 1.3 (CPU#2 [running])):
> #0  virt_spin_lock (lock=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/arch/x86/include/asm/qspinlock.h:106
>         val = <optimized out>
> #1  queued_spin_lock_slowpath (lock=0xff1100017acab300, val=0x1) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/locking/qspinlock.c:141
>         prev = <optimized out>
>         next = 0x1
>         node = <optimized out>
>         old = <optimized out>
>         tail = <optimized out>
>         idx = <optimized out>
>         locked = <optimized out>
>         __vpp_verify = <optimized out>
>         __vpp_verify = <optimized out>
>         pao_ID__ = <optimized out>
>         pao_tmp__ = <optimized out>
>         pto_val__ = <optimized out>
>         pto_tmp__ = <optimized out>
>         pao_ID__ = <optimized out>
>         pao_tmp__ = <optimized out>
>         pto_val__ = <optimized out>
>         pto_tmp__ = <optimized out>
>         pao_ID__ = <optimized out>
>         pao_tmp__ = <optimized out>
>         pto_val__ = <optimized out>
>         pto_tmp__ = <optimized out>
> #2  0xffffffff813de445 in raw_spin_rq_lock_nested (rq=0xff1100017acab300, subclass=0x1) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/core.c:639
>         lock = <optimized out>
> #3  0xffffffff813ef2d5 in raw_spin_rq_lock (rq=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/sched.h:1580
> No locals.
> #4  _raw_spin_rq_lock_irqsave (rq=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/sched.h:1600
>         flags = <optimized out>
>         __dummy = <optimized out>
>         __dummy2 = <optimized out>
> #5  rq_lock_irqsave (rq=<optimized out>, rf=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/sched.h:1893
> No locals.
> #6  sched_balance_rq (this_cpu=0x7acab300, this_rq=0x1, sd=0x1, idle=2060104448, continue_balancing=0x0) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/fair.c:11867
>         ld_moved = 0x1
>         cur_ld_moved = <optimized out>
>         active_balance = <optimized out>
>         sd_parent = <optimized out>
>         group = <optimized out>
>         busiest = <optimized out>
>         rf = <optimized out>
>         cpus = <optimized out>
>         env = {sd = 0xff1100010020b800, src_rq = 0xff1100017acab300, src_cpu = 0x1, dst_cpu = 0x2, dst_rq = 0xff1100017ad2b300, dst_grpmask = 0xff110001001e4a30, new_dst_cpu = 0x0, idle = CPU_NEWLY_IDLE, imbalance = 0x1, cpus = 0xff1100017ad183e0, flags = 0x1, loop = 0x0, loop_break = 0x20, loop_max = 0x2, fbq_type = all, migration_type = migrate_task, tasks = <incomplete type>}
>         need_unlock = <optimized out>
>         redo = <optimized out>
>         more_balance = <optimized out>
>         __vpp_verify = <optimized out>
>         __dummy = <optimized out>
>         __dummy2 = <optimized out>
>         __vpp_verify = <optimized out>
> #7  0xffffffff813efe9b in sched_balance_newidle (this_rq=<optimized out>, rf=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/fair.c:12932
>         weight = <optimized out>
>         domain_cost = 0xff1100017acab300
>         next_balance = <optimized out>
>         this_cpu = 0x20b800
>         continue_balancing = 0x1
>         t0 = <optimized out>
>         t1 = <optimized out>
>         curr_cost = 0x0
>         sd = 0xff1100010020b800
>         pulled_task = 0x1
>         __dummy = <optimized out>
>         __dummy2 = <optimized out>
>         __dummy = <optimized out>
>         __dummy2 = <optimized out>
> #8  pick_next_task_fair (rq=0xff1100010020b800, prev=0x1, rf=0x1) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/fair.c:8973
>         se = 0xfffb6e64
>         p = <optimized out>
>         new_tasks = <optimized out>
>         again = <optimized out>
>         idle = <optimized out>
>         simple = <optimized out>
> #9  0xffffffff81e1337e in __pick_next_task (rq=<optimized out>, prev=<optimized out>, rf=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/core.c:5890
>         class = 0xffa00000003bfc50
>         p = 0xffffffff824b34a8 <fair_sched_class>
>         restart = <optimized out>
> #10 pick_next_task (rq=<optimized out>, prev=<optimized out>, rf=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/core.c:6426
> No locals.
> #11 __schedule (sched_mode=0x7acab300) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/core.c:6809
>         prev = 0xff11000102369680
>         next = 0xffffffff824b34a8 <fair_sched_class>
>         preempt = 0x1
>         is_switch = 0x1
>         switch_count = <optimized out>
>         prev_state = <optimized out>
>         rf = <incomplete type>
>         rq = <optimized out>
>         cpu = <optimized out>
>         keep_resched = <optimized out>
>         __vpp_verify = <optimized out>
> #12 0xffffffff81e14097 in __schedule_loop (sched_mode=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/core.c:6949
> No locals.
> #13 schedule () at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/core.c:6964
>         tsk = <optimized out>
> #14 0xffffffff8179e372 in request_wait_answer (req=0xff11000103061000) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/fuse/dev.c:552
>         __int = <optimized out>
>         __out = <optimized out>
>         __wq_entry = <incomplete type>
>         __ret = <optimized out>
>         __ret = <optimized out>
>         fc = 0xff110001023e6800
>         fiq = <optimized out>
>         err = <optimized out>
> #15 0xffffffff8179e5a0 in __fuse_request_send (req=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/fuse/dev.c:599
>         fiq = 0x0
> #16 __fuse_simple_request (idmap=0xff1100017acab300, fm=0x1, args=0x1) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/fuse/dev.c:693
>         fc = 0xff110001023e6800
>         req = 0xff11000103061000
>         ret = 0xff110001023e6800
> #17 0xffffffff817a27e2 in fuse_simple_request (fm=<optimized out>, args=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/fuse/fuse_i.h:1263
> No locals.
> #18 fuse_readlink_folio (inode=0xff11000100614e00, folio=0xffd40000040c1800) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/fuse/dir.c:1834
>         fm = <optimized out>
>         desc = <incomplete type>
>         ap = <incomplete type>
>         link = <optimized out>
>         res = <optimized out>
> #19 0xffffffff817a2943 in fuse_get_link (dentry=0xff1100017acab300, inode=0xff1100017acab300, callback=0x1) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/fuse/dir.c:1873
>         fc = <optimized out>
>         folio = <optimized out>
>         err = <optimized out>
> #20 0xffffffff816cc950 in pick_link (nd=0xff1100017acab300, link=0x1, inode=0xff11000100614e00, flags=0x7acab300) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/namei.c:2013
>         get = 0xff1100017acab300
>         last = 0xffa00000003bfd88
>         res = 0x1 <error: Cannot access memory at address 0x1>
>         error = <optimized out>
>         all_done = <optimized out>
> #21 0xffffffff816ccb5e in step_into_slowpath (nd=0xff1100017acab300, flags=0x1, dentry=0x1) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/namei.c:2074
>         path = <incomplete type>
>         inode = 0x0
>         err = <optimized out>
> #22 0xffffffff816d14f7 in step_into (nd=<optimized out>, flags=<optimized out>, dentry=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/namei.c:2099
> No locals.
> #23 open_last_lookups (nd=<optimized out>, file=<optimized out>, op=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/namei.c:4584
>         delegated_inode = <optimized out>
>         dir = 0xff1100010040ad80
>         open_flag = 0x1
>         got_write = <optimized out>
>         dentry = 0xff110001006af840
>         res = <optimized out>
>         retry = <optimized out>
> #24 path_openat (nd=0xff1100017acab300, op=0x1, flags=0x1) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/namei.c:4793
>         s = 0xff110001006af840 "\004"
>         file = <optimized out>
>         error = 0x0
> #25 0xffffffff816d2618 in do_filp_open (dfd=0x7acab300, pathname=0x1, op=0x1) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/namei.c:4823
>         nd = {path = <incomplete type>, last = {{{hash = 0xf361748d, len = 0xd}, hash_len = 0xdf361748d}, name = 0xff11000102348031 "systemd-udevd"}, root = <incomplete type>, inode = 0xff110001004ac380, flags = 0x10001, state = 0x2, seq = 0x0, next_seq = 0x0, m_seq = 0x34, r_seq = 0x4, last_type = 0x0, depth = 0x1, total_link_count = 0x1, stack = 0xffa00000003bfd88, internal = {{link = <incomplete type>, done = <incomplete type>, name = 0x0, seq = 0x2}, {link = <incomplete type>, done = <incomplete type>, name = 0x0, seq = 0x0}}, name = 0xff11000102348000, pathname = 0xff11000102348020 "/usr/lib/systemd/systemd-udevd", saved = 0x0, root_seq = 0x2, dfd = 0xffffff9c, dir_vfsuid = <incomplete type>, dir_mode = 0x41ed}
>         flags = 0x1
>         filp = 0x1
> #26 0xffffffff816c3baf in do_open_execat (fd=0x7acab300, name=0x1, flags=0x1) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/exec.c:783
>         err = <optimized out>
>         file = <optimized out>
>         open_exec_flags = <incomplete type>
>         __ptr = <optimized out>
>         __val = <optimized out>
> #27 0xffffffff816c3de0 in alloc_bprm (fd=0x7acab300, filename=0x1, flags=0x1) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/exec.c:1409
>         bprm = <optimized out>
>         file = <optimized out>
>         retval = <optimized out>
> #28 0xffffffff816c48fd in do_execveat_common (fd=0x7acab300, filename=0x1, flags=0x0, envp=..., argv=...) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/exec.c:1810
>         bprm = <optimized out>
>         retval = <optimized out>
> #29 0xffffffff816c5988 in do_execve (filename=<error reading variable: Cannot access memory at address 0x0>, __argv=<optimized out>, __envp=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/exec.c:1933
>         argv = <optimized out>
>         envp = <optimized out>
> #30 __do_sys_execve (filename=<optimized out>, argv=<optimized out>, envp=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/exec.c:2009
> No locals.
> #31 __se_sys_execve (filename=<optimized out>, argv=<optimized out>, envp=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/exec.c:2004
>         ret = <optimized out>
> #32 __x64_sys_execve (regs=0xff1100017acab300) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/exec.c:2004
> No locals.
> #33 0xffffffff81e07124 in do_syscall_x64 (regs=<optimized out>, nr=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/arch/x86/entry/syscall_64.c:63
>         unr = <optimized out>
> #34 do_syscall_64 (regs=0xff1100017acab300, nr=0x1) at /home/runner/work/mptcp_net-next/mptcp_net-next/arch/x86/entry/syscall_64.c:94
> No locals.
> #35 0xffffffff81000130 in entry_SYSCALL_64 () at /home/runner/work/mptcp_net-next/mptcp_net-next/arch/x86/entry/entry_64.S:122
> No locals.
> #36 0x0000000000000003 in ?? ()
> No symbol table info available.
> #37 0x00007fbaf4000e50 in ?? ()
> No symbol table info available.
> #38 0x0000555559fefea0 in ?? ()
> No symbol table info available.
> #39 0x00007fbaf4000d90 in ?? ()
> No symbol table info available.
> #40 0x00007fbb0090de60 in ?? ()
> No symbol table info available.
> #41 0x00007fbaf4000cb0 in ?? ()
> No symbol table info available.
> #42 0x0000000000000202 in ?? ()
> No symbol table info available.
> #43 0x0000000000000008 in ?? ()
> No symbol table info available.
> #44 0x0000000000000000 in ?? ()
> No symbol table info available.
> 
> Thread 2 (Thread 1.2 (CPU#1 [running])):
> #0  num_possible_cpus () at /home/runner/work/mptcp_net-next/mptcp_net-next/include/linux/cpumask.h:1222
> No locals.
> #1  mm_get_cid (mm=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/sched.h:3782
>         cid = 0x4
> #2  mm_cid_from_cpu (t=<optimized out>, cpu_cid=0x4, mode=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/sched.h:3844
>         max_cids = <optimized out>
>         tcid = <optimized out>
>         mm = <optimized out>
> #3  mm_cid_schedin (next=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/sched.h:3900
>         mm = 0xff11000102bf0000
>         cpu_cid = <optimized out>
>         mode = <optimized out>
> #4  mm_cid_switch_to (prev=<optimized out>, next=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/sched.h:3935
> No locals.
> #5  context_switch (rq=<optimized out>, prev=<optimized out>, next=<optimized out>, rf=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/core.c:5249
> No locals.
> #6  __schedule (sched_mode=0x2bf0650) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/core.c:6867
>         prev = 0xff1100010031da00
>         next = 0xff1100010146da00
>         preempt = 0x4
>         is_switch = 0x0
>         switch_count = <optimized out>
>         prev_state = <optimized out>
>         rf = <incomplete type>
>         rq = <optimized out>
>         cpu = <optimized out>
>         keep_resched = <optimized out>
>         __vpp_verify = <optimized out>
> #7  0xffffffff81e14232 in schedule_idle () at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/core.c:6990
> No locals.
> #8  0xffffffff813f68a9 in cpu_startup_entry (state=46073424) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/idle.c:430
> No locals.
> #9  0xffffffff8135fef4 in start_secondary (unused=0xff11000102bf0650) at /home/runner/work/mptcp_net-next/mptcp_net-next/arch/x86/kernel/smpboot.c:312
> No locals.
> #10 0xffffffff8132b266 in secondary_startup_64 () at /home/runner/work/mptcp_net-next/mptcp_net-next/arch/x86/kernel/head_64.S:418
> No locals.
> #11 0x0000000000000000 in ?? ()
> No symbol table info available.
> 
> Thread 1 (Thread 1.1 (CPU#0 [running])):
> #0  virt_spin_lock (lock=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/arch/x86/include/asm/qspinlock.h:106
>         val = <optimized out>
> #1  queued_spin_lock_slowpath (lock=0xff1100017acab300, val=0x1) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/locking/qspinlock.c:141
>         prev = <optimized out>
>         next = 0x1
>         node = <optimized out>
>         old = <optimized out>
>         tail = <optimized out>
>         idx = <optimized out>
>         locked = <optimized out>
>         __vpp_verify = <optimized out>
>         __vpp_verify = <optimized out>
>         pao_ID__ = <optimized out>
>         pao_tmp__ = <optimized out>
>         pto_val__ = <optimized out>
>         pto_tmp__ = <optimized out>
>         pao_ID__ = <optimized out>
>         pao_tmp__ = <optimized out>
>         pto_val__ = <optimized out>
>         pto_tmp__ = <optimized out>
>         pao_ID__ = <optimized out>
>         pao_tmp__ = <optimized out>
>         pto_val__ = <optimized out>
>         pto_tmp__ = <optimized out>
> #2  0xffffffff813de445 in raw_spin_rq_lock_nested (rq=0xff1100017acab300, subclass=0x1) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/core.c:639
>         lock = <optimized out>
> #3  0xffffffff813ef2d5 in raw_spin_rq_lock (rq=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/sched.h:1580
> No locals.
> #4  _raw_spin_rq_lock_irqsave (rq=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/sched.h:1600
>         flags = <optimized out>
>         __dummy = <optimized out>
>         __dummy2 = <optimized out>
> #5  rq_lock_irqsave (rq=<optimized out>, rf=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/sched.h:1893
> No locals.
> #6  sched_balance_rq (this_cpu=0x7acab300, this_rq=0x1, sd=0x1, idle=2060104448, continue_balancing=0x0) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/fair.c:11867
>         ld_moved = 0x1
>         cur_ld_moved = <optimized out>
>         active_balance = <optimized out>
>         sd_parent = <optimized out>
>         group = <optimized out>
>         busiest = <optimized out>
>         rf = <optimized out>
>         cpus = <optimized out>
>         env = {sd = 0xff1100010020b400, src_rq = 0xff1100017acab300, src_cpu = 0x1, dst_cpu = 0x0, dst_rq = 0xff1100017ac2b300, dst_grpmask = 0xff110001001e4930, new_dst_cpu = 0x0, idle = CPU_NEWLY_IDLE, imbalance = 0x1, cpus = 0xff1100017ac183e0, flags = 0x1, loop = 0x0, loop_break = 0x20, loop_max = 0x2, fbq_type = all, migration_type = migrate_task, tasks = <incomplete type>}
>         need_unlock = <optimized out>
>         redo = <optimized out>
>         more_balance = <optimized out>
>         __vpp_verify = <optimized out>
>         __dummy = <optimized out>
>         __dummy2 = <optimized out>
>         __vpp_verify = <optimized out>
> #7  0xffffffff813efe9b in sched_balance_newidle (this_rq=<optimized out>, rf=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/fair.c:12932
>         weight = <optimized out>
>         domain_cost = 0xff1100017acab300
>         next_balance = <optimized out>
>         this_cpu = 0x20b400
>         continue_balancing = 0x1
>         t0 = <optimized out>
>         t1 = <optimized out>
>         curr_cost = 0x0
>         sd = 0xff1100010020b400
>         pulled_task = 0x1
>         __dummy = <optimized out>
>         __dummy2 = <optimized out>
>         __dummy = <optimized out>
>         __dummy2 = <optimized out>
> #8  pick_next_task_fair (rq=0xff1100010020b400, prev=0x1, rf=0x1) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/fair.c:8973
>         se = 0xfffb6e65
>         p = <optimized out>
>         new_tasks = <optimized out>
>         again = <optimized out>
>         idle = <optimized out>
>         simple = <optimized out>
> #9  0xffffffff81e1337e in __pick_next_task (rq=<optimized out>, prev=<optimized out>, rf=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/core.c:5890
>         class = 0xff1100010224aa00
>         p = 0xffffffff824b34a8 <fair_sched_class>
>         restart = <optimized out>
> #10 pick_next_task (rq=<optimized out>, prev=<optimized out>, rf=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/core.c:6426
> No locals.
> #11 __schedule (sched_mode=0x7acab300) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/core.c:6809
>         prev = 0xff1100010146c380
>         next = 0xffffffff824b34a8 <fair_sched_class>
>         preempt = 0x1
>         is_switch = 0x1
>         switch_count = <optimized out>
>         prev_state = <optimized out>
>         rf = <incomplete type>
>         rq = <optimized out>
>         cpu = <optimized out>
>         keep_resched = <optimized out>
>         __vpp_verify = <optimized out>
> #12 0xffffffff81e14097 in __schedule_loop (sched_mode=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/core.c:6949
> No locals.
> #13 schedule () at /home/runner/work/mptcp_net-next/mptcp_net-next/kernel/sched/core.c:6964
>         tsk = <optimized out>
> #14 0xffffffff8179e372 in request_wait_answer (req=0xff11000100910160) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/fuse/dev.c:552
>         __int = <optimized out>
>         __out = <optimized out>
>         __wq_entry = <incomplete type>
>         __ret = <optimized out>
>         __ret = <optimized out>
>         fc = 0xff110001023e6800
>         fiq = <optimized out>
>         err = <optimized out>
> #15 0xffffffff8179e5a0 in __fuse_request_send (req=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/fuse/dev.c:599
>         fiq = 0x0
> #16 __fuse_simple_request (idmap=0xff1100017acab300, fm=0x1, args=0x1) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/fuse/dev.c:693
>         fc = 0xff110001023e6800
>         req = 0xff11000100910160
>         ret = 0xff110001023e6800
> #17 0xffffffff817a47d9 in fuse_simple_request (fm=<optimized out>, args=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/fuse/fuse_i.h:1263
> No locals.
> #18 fuse_lookup_name (sb=0xff1100017acab300, nodeid=0x1, name=0x1, outarg=0xff1100017acab300, inode=0x0) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/fuse/dir.c:574
>         fm = <optimized out>
>         args = <incomplete type>
>         forget = <optimized out>
>         attr_version = <optimized out>
>         evict_ctr = <optimized out>
>         err = 0x411620
> #19 0xffffffff817a49c9 in fuse_lookup (dir=0xff11000100606a00, entry=0xff11000100411600, flags=0x1) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/fuse/fuse_i.h:1062
>         outarg = <incomplete type>
>         fc = <optimized out>
>         inode = 0x0
>         newent = 0xffa00000003afaf0
>         err = <optimized out>
>         epoch = <optimized out>
>         outarg_valid = 0x0
>         locked = <optimized out>
>         out_iput = <optimized out>
> #20 0xffffffff816c9e63 in __lookup_slow (name=0xff1100017acab300, dir=0x1, flags=0x1) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/namei.c:1866
>         dentry = 0xff11000100411600
>         old = <optimized out>
>         inode = 0xff11000100606a00
>         wq = <incomplete type>
> #21 0xffffffff816c9f69 in lookup_slow (name=0xff1100017acab300, dir=0x1, flags=0x1) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/namei.c:1883
>         inode = <optimized out>
>         res = <optimized out>
> #22 0xffffffff816cddd8 in walk_component (nd=<optimized out>, flags=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/namei.c:2229
>         dentry = 0x1
> #23 lookup_last (nd=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/namei.c:2730
> No locals.
> #24 path_lookupat (nd=0xff1100017acab300, flags=0x1, path=0x1) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/namei.c:2754
>         s = 0x1 <error: Cannot access memory at address 0x1>
>         err = <optimized out>
> #25 0xffffffff816cfee0 in filename_lookup (dfd=0x7acab300, name=0x1, flags=0x1, path=0xff1100017acab300, root=0x0) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/namei.c:2783
>         retval = 0x1
>         nd = {path = <incomplete type>, last = {{{hash = 0x314ef79d, len = 0x4}, hash_len = 0x4314ef79d}, name = 0xff110001009f1029 "dpkg"}, root = <incomplete type>, inode = 0xff11000100606a00, flags = 0x5, state = 0x2, seq = 0x0, next_seq = 0x0, m_seq = 0x34, r_seq = 0x4, last_type = 0x0, depth = 0x0, total_link_count = 0x0, stack = 0xffa00000003afcd8, internal = {{link = <incomplete type>, done = <incomplete type>, name = 0x0, seq = 0x0}, {link = <incomplete type>, done = <incomplete type>, name = 0x0, seq = 0x0}}, name = 0xff110001009f1000, pathname = 0xff110001009f1020 "/var/lib/dpkg", saved = 0x0, root_seq = 0x2, dfd = 0xffffff9c, dir_vfsuid = <incomplete type>, dir_mode = 0x41ed}
> #26 0xffffffff816c1a8c in vfs_statx (dfd=0x7acab300, filename=0x1, flags=0x1, stat=0xff1100017acab300, request_mask=0x0) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/stat.c:353
>         path = <incomplete type>
>         lookup_flags = 0x5
>         error = 0xffffff9c
> #27 0xffffffff816c2863 in do_statx (dfd=0x7acab300, filename=0x1, flags=0x1, mask=0x7acab300, buffer=0x0) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/stat.c:769
>         stat = {result_mask = 0x0, mode = 0x0, nlink = 0x0, blksize = 0x0, attributes = 0x0, attributes_mask = 0x0, ino = 0x0, dev = 0x0, rdev = 0x0, uid = <incomplete type>, gid = <incomplete type>, size = 0x0, atime = <incomplete type>, mtime = <incomplete type>, ctime = <incomplete type>, btime = <incomplete type>, blocks = 0x0, mnt_id = 0x0, change_cookie = 0x0, subvol = 0x0, dio_mem_align = 0x0, dio_offset_align = 0x0, dio_read_offset_align = 0x0, atomic_write_unit_min = 0x0, atomic_write_unit_max = 0x0, atomic_write_unit_max_opt = 0x0, atomic_write_segments_max = 0x0}
>         error = 0x1
> #28 0xffffffff816c2ab0 in __do_sys_statx (dfd=<optimized out>, filename=<optimized out>, flags=<optimized out>, mask=<optimized out>, buffer=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/stat.c:823
>         ret = 0xffffff9c
>         name = <error reading variable name (Cannot access memory at address 0x0)>
> #29 __se_sys_statx (dfd=<optimized out>, filename=<optimized out>, flags=<optimized out>, mask=<optimized out>, buffer=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/stat.c:812
>         ret = <optimized out>
> #30 __x64_sys_statx (regs=0xff1100017acab300) at /home/runner/work/mptcp_net-next/mptcp_net-next/fs/stat.c:812
> No locals.
> #31 0xffffffff81e07124 in do_syscall_x64 (regs=<optimized out>, nr=<optimized out>) at /home/runner/work/mptcp_net-next/mptcp_net-next/arch/x86/entry/syscall_64.c:63
>         unr = <optimized out>
> #32 do_syscall_64 (regs=0xff1100017acab300, nr=0x1) at /home/runner/work/mptcp_net-next/mptcp_net-next/arch/x86/entry/syscall_64.c:94
> No locals.
> #33 0xffffffff81000130 in entry_SYSCALL_64 () at /home/runner/work/mptcp_net-next/mptcp_net-next/arch/x86/entry/entry_64.S:122
> No locals.
> #34 0x000000000000000e in ?? ()
> No symbol table info available.
> #35 0x0000000000000001 in ?? ()
> No symbol table info available.
> #36 0x00007fff8cbcae40 in ?? ()
> No symbol table info available.
> #37 0x00007fbb012d6530 in ?? ()
> No symbol table info available.
> #38 0x00007fbb00d14c70 in ?? ()
> No symbol table info available.
> #39 0x00007fbb00d14e00 in ?? ()
> No symbol table info available.
> #40 0x0000000000000246 in ?? ()
> No symbol table info available.
> #41 0x0000000000000fff in ?? ()
> No symbol table info available.
> #42 0x0000000000000000 in ?? ()
> No symbol table info available.


[7] https://lore.kernel.org/aXdO52wh2rqTUi1E@shinmob

[8] https://lore.kernel.org/20260201192234.380608594@kernel.org

[9]
https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/log/?h=sched/urgent
-- 
Sponsored by the NGI0 Core fund.


