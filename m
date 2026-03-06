Return-Path: <kvm+bounces-73019-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QAmqB3C1qml9VgEAu9opvQ
	(envelope-from <kvm+bounces-73019-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 12:07:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A51BC21F6E4
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 12:07:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6B342301D317
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 11:07:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0E3A386C30;
	Fri,  6 Mar 2026 11:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="niRYr2GU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8E9382F15;
	Fri,  6 Mar 2026 11:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772795220; cv=none; b=YDiN+r+9Gw03wrMf0PLCOWHMoaskZonOY2BA4oUDFgsx7kXC5yu2FFlSsA7uJS/dYPa9nfqW/bGU1MlzUloujJlPNrEDpWM5oCaCT0uWyZsMegQP8X7h7aHEKsO/ckXPI8jLuI9YpTDx6WqtB9daHngc6mUV7oYsIZh8MbXsEso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772795220; c=relaxed/simple;
	bh=5JLFleFOGu2yk6q3/LVcwXRgVRIsHMw1XzIURCrmxSs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hdty7cG86xga+EJZI8glT4JGr+EUzrFjAUgnWqyTwla0rZarIj66AtgxXlhh6QnPqrjjQqShUYrEsdjtyZbfsIsm2FlBRlYd7lJWi0Wpse+3Jl6qqM54WadSAty0omABefsbXusRvQsqT5awtDusSHAHynUWgQd21GauBjIAVu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=niRYr2GU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E533C4CEF7;
	Fri,  6 Mar 2026 11:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772795219;
	bh=5JLFleFOGu2yk6q3/LVcwXRgVRIsHMw1XzIURCrmxSs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=niRYr2GUkeZ2evtY/MvpTINahTL9FeEOM2+S5jIOhI6rTICEN4ErbX/41cP3OcnQk
	 zhd2aol7vsSHYfqBanZvFiKJcNJc6c4P89P7ym6dPfWZKLhYYMXYar4U8Pdft4PWnT
	 fygpvXhCsB69JLcRjvP2uqCg8fjYbwpXeM/cE7qNEJfb1msgEIWCQl/tf49x0ZGqn0
	 mrfXLzAm9K2gKESMGb16yku1dBu7nk1ppJCDfTKLNkWttrSTSXXuNLZaasQnr9ATSW
	 EFnRv7/BKOZYAfL8DUdTEHwCuhf7KQyUra8DtlOk4TzKJd2blbg/WJLhMHSgfV9Lx7
	 xvZe13Ywzo6dQ==
Message-ID: <9798cb27-0f52-42fa-b0da-a7834039da1f@kernel.org>
Date: Fri, 6 Mar 2026 12:06:51 +0100
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
To: Thomas Gleixner <tglx@kernel.org>, Jiri Slaby <jirislaby@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>
Cc: Stefan Hajnoczi <stefanha@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, Netdev <netdev@vger.kernel.org>,
 rcu@vger.kernel.org, MPTCP Linux <mptcp@lists.linux.dev>,
 Linux Kernel <linux-kernel@vger.kernel.org>,
 Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, "luto@kernel.org"
 <luto@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <MKoutny@suse.com>,
 Waiman Long <longman@redhat.com>
References: <b24ffcb3-09d5-4e48-9070-0b69bc654281@kernel.org>
 <7f3e74d7-67dc-48d7-99d2-0b87f671651b@kernel.org>
 <863a5291-a636-47d0-891c-bb0524d2e134@kernel.org>
 <20260302114636.GL606826@noisy.programming.kicks-ass.net>
 <717310d8-6274-4b7f-8a19-561c45f5f565@kernel.org>
 <a2b573b4-af61-4b84-a7d1-012ed6bb23c9@kernel.org>
 <ba067933-bf3b-476d-a0bb-53eda56996ca@kernel.org> <87zf4m2qvo.ffs@tglx>
 <47cba228-bba7-4e58-a69d-ea41f8de6602@kernel.org> <87tsuu2i59.ffs@tglx>
 <7efde2b5-3b72-4858-9db0-22493d446301@kernel.org> <87qzpx2sck.ffs@tglx>
From: Matthieu Baerts <matttbe@kernel.org>
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <87qzpx2sck.ffs@tglx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A51BC21F6E4
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73019-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	MIME_TRACE(0.00)[0:+];
	HAS_ORG_HEADER(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[matttbe@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

Hi Thomas,

Thank you for looking into this!

On 06/03/2026 10:57, Thomas Gleixner wrote:
> On Fri, Mar 06 2026 at 06:48, Jiri Slaby wrote:
>> On 05. 03. 26, 20:25, Thomas Gleixner wrote:
>>> Is there simple way to reproduce?
>>
>> Unfortunately not at all. To date, I even cannot reproduce locally, it 
>> reproduces exclusively in opensuse build service (and github CI as per 
>> Matthieu's report). I have a project in there with packages which fail 
>> more often than others:
>>    https://build.opensuse.org/project/monitor/home:jirislaby:softlockup
>> But it's all green ATM.
>>
>> Builds of Go 1.24 and tests of rust 1.90 fail the most. The former even 
>> takes only ~ 8 minutes, so it's not that intensive build at all. So the 
>> reasons are unknown to me. At least, Go apparently uses threads for 
>> building (unlike gcc/clang with forks/processes). Dunno about rust.
> 
> I tried with tons of test cases which stress test mmcid with threads and
> failed.

On my side, I didn't manage to reproduce it locally either.


> Can you provide me your .config, source version, VM setup (Number of
> CPUs, memory etc.)?

My CI ran into this issue 2 days ago, with and without a debug kernel
config. The kernel being tested was on top of 'net-next', which was on
top of this commit from Linus' tree: fbdfa8da05b6 ("selftests:
tc-testing: fix list_categories() crash on list type").

- Config without debug:


https://github.com/user-attachments/files/25791728/config-run-22657946888-normal-join.gz

- Config with debug:


https://github.com/user-attachments/files/25791960/config-run-22657946888-debug-nojoin.gz

- Just in case, stacktraces available there:

  https://github.com/multipath-tcp/mptcp_net-next/actions/runs/22657946888


My tests are being executed in VMs I don't control using a kernel v6.14
on Azure with 4 vCPUs, 16GB of RAM, and KVM nested support. From more
details about what's in it:


https://github.com/actions/runner-images/blob/ubuntu24/20260302.42/images/ubuntu/Ubuntu2404-Readme.md


From there, a docker container is started, from which QEMU 10.1.0
(Debian 1:10.1.0+ds-5ubuntu2.2) is launched with 4 vCPU and 5GB of RAM
using this command:


/usr/bin/qemu-system-x86_64 \
  -name mptcpdev \
  -m 5120M \
  -smp 4 \
  -chardev socket,id=charvirtfs5,path=/tmp/virtmevrwrzu5k \
  -device vhost-user-fs-device,chardev=charvirtfs5,tag=ROOTFS \
  -object memory-backend-memfd,id=mem,size=5120M,share=on \
  -numa node,memdev=mem \
  -machine accel=kvm:tcg \
  -M microvm,accel=kvm,pcie=on,rtc=on \
  -cpu host,topoext=on \
  -parallel none \
  -net none \
  -echr 1 \
  -chardev file,path=/proc/self/fd/2,id=dmesg \
  -device virtio-serial-device \
  -device virtconsole,chardev=dmesg \
  -chardev stdio,id=console,signal=off,mux=on \
  -serial chardev:console \
  -mon chardev=console \
  -vga none \
  -display none \
  -device vhost-vsock-device,guest-cid=3 \
  -kernel
/home/runner/work/mptcp_net-next/mptcp_net-next/.virtme/build/arch/x86/boot/bzImage
\
  -append 'virtme_hostname=mptcpdev nr_open=1048576
virtme_link_mods=/home/runner/work/mptcp_net-next/mptcp_net-next/.virtme/build/.virtme_mods/lib/modules/0.0.0
virtme_rw_overlay0=/tmp console=hvc0 earlyprintk=serial,ttyS0,115200
virtme_console=ttyS0 psmouse.proto=exps
virtme.vsockexec=`/tmp/virtme-console/3.sh`
virtme_chdir=home/runner/work/mptcp_net-next/mptcp_net-next
virtme_root_user=1 rootfstype=virtiofs root=ROOTFS raid=noautodetect rw
debug nokaslr mitigations=off softlockup_panic=1 nmi_watchdog=1
hung_task_panic=1 panic=-1 oops=panic
init=/usr/local/lib/python3.13/dist-packages/virtme/guest/bin/virtme-ng-init'
\
  -gdb tcp::1234 \
  -qmp tcp::3636,server,nowait \
  -no-reboot


It is possible to locally launch the same command using the same QEMU
version (but not the same host kernel) with the help of Docker:

  $ cd <kernel source code>
  # docker run -v "${PWD}:${PWD}:rw" -w "${PWD}" --rm \
    -it --privileged mptcp/mptcp-upstream-virtme-docker:latest \
    manual normal

This will build a new kernel in O=.virtme/build, launch it and give you
access to a prompt.


After that, you can do also use the "auto" mode with the last built
image to boot the VM, only print "OK", stop and retry if there were no
errors:

  $ cd <kernel source code>
  $ echo 'echo OK' > .virtme-exec-run
  # i=1; \
    while docker run -v "${PWD}:${PWD}:rw" -w "${PWD}" --rm \
    -it --privileged mptcp/mptcp-upstream-virtme-docker:latest \
    vm auto normal; do \
      echo "== Attempt: $i: OK =="; \
      i=$((i+1)); \
    done; \
    echo "== Failure after $i attempts =="


> I tried to find it on that github page Matthiue mentioned but I'm
> probably too stupid to navigate this clicky interface.

I'm sorry about that, I understand, the interface is not very clear. Do
not hesitate to tell me if you need anything else from me.

Cheers,
Matt
-- 
Sponsored by the NGI0 Core fund.


