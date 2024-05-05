Return-Path: <kvm+bounces-16596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FA3C8BC04A
	for <lists+kvm@lfdr.de>; Sun,  5 May 2024 13:39:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2010E1C2048D
	for <lists+kvm@lfdr.de>; Sun,  5 May 2024 11:39:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A40CB18C36;
	Sun,  5 May 2024 11:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=glanzmann.de header.i=@glanzmann.de header.b="XPS/khcK"
X-Original-To: kvm@vger.kernel.org
Received: from infra.glanzmann.de (infra.glanzmann.de [88.198.237.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9807111A8;
	Sun,  5 May 2024 11:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=88.198.237.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714909154; cv=none; b=rlDyPDEcjd9kYuWZoUVIj89FLFHlxRv4kJ8tHbflEfLPwP3WRTPUaHCBbW9xYW6yp7w+HsFL5WIzNrIdA8E/hP7nCXyK6NupIKidElKhIDXghZJRQ17GsHK8OBi3Nc669TX71ciQULrehJLfKSYBBc0YGS0ASM/a6yC/zaBhkqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714909154; c=relaxed/simple;
	bh=RTU6cfd46xPlUBW0KfgAdnCj+0ikjRajIHBUcOiRCr8=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=NVMwF+11NRTXjhIh1WVcj/ZpdwgoYbjLTeqayEipPYPL1s12KeZR1SkEK6wOMOWH+PYihWrAms0DhGAfsyyBoqbHndupXiXPirg9H0zffAxAwBSv0qvJJ0BcLA0inP48WFUEZ5ph0d1svHjmCOyMACOg0CNGg/6BjYMiOPlqj9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=glanzmann.de; spf=pass smtp.mailfrom=glanzmann.de; dkim=pass (4096-bit key) header.d=glanzmann.de header.i=@glanzmann.de header.b=XPS/khcK; arc=none smtp.client-ip=88.198.237.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=glanzmann.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=glanzmann.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=glanzmann.de;
	s=infra26101010; t=1714908568;
	bh=aYf2RxSJLLq0un4EWYICHjEP3BhOEWbaehFDxI8ZvOY=;
	h=Date:From:To:Subject:From;
	b=XPS/khcK0e6DDP1KMSmDppxPU8ZM/M0lbLnzazsaCzifG39GlLaPfpmebYsnOfjWy
	 koClpY7q+jT8P3+Oj0U2CIznScVfedZvH3EXcCMqesxnEpoJhBOrf2M6ZbYpJjYQI8
	 YDoAgaacsHEIj9ikBDizZNmzfJXs7dS061+YaQkXl2o6W+hoNW9AiUqDzpSn5WrcmE
	 GC/G+J/cIlTtADbrrPBkFQ/0B54HDr23vsl9fw7DTlpEomk70Sd/ObTdEBfIHJszVI
	 0WIhDd0IuSiCarbpXxs0JgHYINZiSdacFqsxYdzUAZZBuN4yomTmscxo5TTKrosBpG
	 xUyV+qs959tMMkmzSTz+H53LTelHcN09vnIvXkOo72Ag91EtXdqGgf8cn73f9Hg2AZ
	 9RYYfBvriEFRwjqYqcJ4Ix+h4gNuhnvEF1py06eaCPp2OqD/+GfbEuv/0rcnvkge4h
	 hxuawG+B07yE+a0vhAkG5to+wOwI3qeaLulRzMxOtrxDPwurP0VRWzfxxSBB8JmbZt
	 gFwDHB3/ObYqqWrp0KI9Xepji9nVpwK6tjljIh2Vs2Hvo7mfqOt1Z60jJNoIOgIKbY
	 +sqFMLpCs55k7nGwzQ5CLpesY+ETwxzSAhyte+Ucbz/QxIN71NuL0iJiXVv6fdx/gp
	 JfcB4fA1ZDOIjHdoA38+8/MM=
Received: by infra.glanzmann.de (Postfix, from userid 1000)
	id 289E07A80089; Sun,  5 May 2024 13:29:28 +0200 (CEST)
Date: Sun, 5 May 2024 13:29:28 +0200
From: Thomas Glanzmann <thomas@glanzmann.de>
To: kvm@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: I/O stalls when merging qcow2 snapshots on nfs
Message-ID: <ZjdtmFu92mSlaHZ2@glanzmann.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,
I often take snapshots in order to move kvm VMs from one nfs share to
another while they're running or to take backups. Sometimes I have very
large VMs (1.1 TB) which take a very long time (40 minutes - 2 hours) to
backup or move. They also write between 20 - 60 GB of data while being
backed up or moved. Once the backup or move is done the dirty snapshot
data needs to be merged to the parent disk. While doing this I often
experience I/O stalls within the VMs in the range of 1 - 20 seconds.
Sometimes worse. But I have some very latency sensitive VMs which crash
or misbehave after 15 seconds I/O stalls. So I would like to know if there
is some tuening I can do to make these I/O stalls shorter.

- I already tried to set vm.dirty_expire_centisecs=100 which appears to
  make it better, but not under 15 seconds. Perfect would be I/O stalls
  no more than 1 second.

This is how you can reproduce the issue:

- NFS Server:
mkdir /ssd
apt install -y nfs-kernel-server
echo '/nfs 0.0.0.0/0.0.0.0(rw,no_root_squash,no_subtree_check,sync)' > /etc/exports
exports -ra

- NFS Client / KVM Host:
mount server:/ssd /mnt
# Put a VM on /mnt and start it.
# Create a snapshot:
virsh snapshot-create-as --domain testy guest-state1 --diskspec vda,file=/mnt/overlay.qcow2 --disk-only --atomic --no-metadata -no-metadata

- In the VM:

# Write some data (in my case 6 GB of data are writen in 60 seconds due
# to the nfs client being connected with a 1 Gbit/s link)
fio --ioengine=libaio --filesize=32G --ramp_time=2s --runtime=1m --numjobs=1 --direct=1 --verify=0 --randrepeat=0 --group_reporting --directory=/mnt --name=write --blocksize=1m --iodepth=1 --readwrite=write --unlink=1
# Do some synchronous I/O
while true; do date | tee -a date.log; sync; sleep 1; done

- On the NFS Client / KVM host:
# Merge the snapshot into the parentdisk
time virsh blockcommit testy vda --active --pivot --delete

Successfully pivoted

real    1m4.666s
user    0m0.017s
sys     0m0.007s

I exported the nfs share with sync on purpose because I often use drbd
in sync mode (protocol c) to replicate the data on the nfs server to a
site which is 200 km away using a 10 Gbit/s link.

The result is:
(testy) [~] while true; do date | tee -a date.log; sync; sleep 1; done
Sun May  5 12:53:36 CEST 2024
Sun May  5 12:53:37 CEST 2024
Sun May  5 12:53:38 CEST 2024
Sun May  5 12:53:39 CEST 2024
Sun May  5 12:53:40 CEST 2024
Sun May  5 12:53:41 CEST 2024 < here I started virsh blockcommit
Sun May  5 12:53:45 CEST 2024
Sun May  5 12:53:50 CEST 2024
Sun May  5 12:53:59 CEST 2024
Sun May  5 12:54:04 CEST 2024
Sun May  5 12:54:22 CEST 2024
Sun May  5 12:54:23 CEST 2024
Sun May  5 12:54:27 CEST 2024
Sun May  5 12:54:32 CEST 2024
Sun May  5 12:54:40 CEST 2024
Sun May  5 12:54:42 CEST 2024
Sun May  5 12:54:45 CEST 2024
Sun May  5 12:54:46 CEST 2024
Sun May  5 12:54:47 CEST 2024
Sun May  5 12:54:48 CEST 2024
Sun May  5 12:54:49 CEST 2024

This is with 'vm.dirty_expire_centisecs=100' with the default values
'vm.dirty_expire_centisecs=3000' it is worse.

I/O stalls:
- 4 seconds
- 9 seconds
- 5 seconds
- 18 seconds
- 4 seconds
- 5 seconds
- 8 seconds
- 2 seconds
- 3 seconds

With the default vm.dirty_expire_centisecs=3000 I get something like that:

(testy) [~] while true; do date | tee -a date.log; sync; sleep 1; done
Sun May  5 11:51:33 CEST 2024
Sun May  5 11:51:34 CEST 2024
Sun May  5 11:51:35 CEST 2024
Sun May  5 11:51:37 CEST 2024
Sun May  5 11:51:38 CEST 2024
Sun May  5 11:51:39 CEST 2024
Sun May  5 11:51:40 CEST 2024 << virsh blockcommit
Sun May  5 11:51:49 CEST 2024
Sun May  5 11:52:07 CEST 2024
Sun May  5 11:52:08 CEST 2024
Sun May  5 11:52:27 CEST 2024
Sun May  5 11:52:45 CEST 2024
Sun May  5 11:52:47 CEST 2024
Sun May  5 11:52:48 CEST 2024
Sun May  5 11:52:49 CEST 2024

I/O stalls:

- 9 seconds
- 18 seconds
- 19 seconds
- 18 seconds
- 1 seconds

I'm open to any suggestions which improve the situation. I often have 10
Gbit/s network and a lot of dirty buffer cache, but at the same time I
often replicate synchronously to a second site 200 kms apart which only
gives me around 100 MB/s write performance.

With vm.dirty_expire_centisecs=10 even worse:

(testy) [~] while true; do date | tee -a date.log; sync; sleep 1; done
Sun May  5 13:25:31 CEST 2024
Sun May  5 13:25:32 CEST 2024
Sun May  5 13:25:33 CEST 2024
Sun May  5 13:25:34 CEST 2024
Sun May  5 13:25:35 CEST 2024
Sun May  5 13:25:36 CEST 2024
Sun May  5 13:25:37 CEST 2024 < virsh blockcommit
Sun May  5 13:26:00 CEST 2024
Sun May  5 13:26:01 CEST 2024
Sun May  5 13:26:06 CEST 2024
Sun May  5 13:26:11 CEST 2024
Sun May  5 13:26:40 CEST 2024
Sun May  5 13:26:42 CEST 2024
Sun May  5 13:26:43 CEST 2024
Sun May  5 13:26:44 CEST 2024

I/O stalls:

- 23 seconds
- 5 seconds
- 5 seconds
- 29 seconds
- 1 second

Cheers,
        Thomas

