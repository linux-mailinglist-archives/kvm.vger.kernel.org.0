Return-Path: <kvm+bounces-16754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 225518BD3C4
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 19:21:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D307928544E
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 17:21:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4421915747F;
	Mon,  6 May 2024 17:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=glanzmann.de header.i=@glanzmann.de header.b="HOLkT+Ax"
X-Original-To: kvm@vger.kernel.org
Received: from infra.glanzmann.de (infra.glanzmann.de [88.198.237.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417E415746D;
	Mon,  6 May 2024 17:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=88.198.237.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715016106; cv=none; b=CyzmsiBFy7ClmKNlrCcBE+MHXSJa5Ur0hOvRhCYIwnIr6f+5nhaU1cXikTCSM+BMAvrXrdHAmFe6Ad22vFxfUnxmB1rBCKRXOqYvK2UePxEEcaD2LTM8N51P5xXLqt3YljOaNHw+wDHfNdzuLDHhsdC0XMyE5TOkPgjLAvVfF08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715016106; c=relaxed/simple;
	bh=ijBZ+cCjAu+pyVvDBQiDGDE+nLLa2TRIbWOErH78470=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=H0FGv9QlBEwNvgh77cgM3f88ntiY+OLBm+gNd9ae6vEXI/c9YfmUw6QE6w3Nf/9rmU0jBx3Xj9bEJAyjbf0Omv4U6ZYpY75s7qehmQzSZis+ROOrcZBc2J1mqgX3DzwEnThCnrY2m+4FP4tJFZIrrWTpFITLTZTY7c9Y5tXRGDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=glanzmann.de; spf=pass smtp.mailfrom=glanzmann.de; dkim=pass (4096-bit key) header.d=glanzmann.de header.i=@glanzmann.de header.b=HOLkT+Ax; arc=none smtp.client-ip=88.198.237.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=glanzmann.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=glanzmann.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=glanzmann.de;
	s=infra26101010; t=1715016092;
	bh=Id6dU8mifl2aS/FvwZ33rY95kfK1oEaav7fGLDNbayg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=HOLkT+AxNH2dlR/8+P3Z1DVKpH4R0xi9+RpxtfHgHdwl8CR8VDvS+CAZ5DuTpdnKd
	 qkT1F0PIn7gH+7CkEl24YvbItWHnp6F9XYvruSKeLdhCdigmc+0T3ArnXMCQihlhDX
	 nkaqxrqH0xQaqbZqGlzCcaBO7NVFfWAC3BOlFQoCboZMQ9TP6n5xuPUzFqSSYiF15P
	 IF+Tg2cNrJfrcOTrBnhVKvV2ZRXDrWcabH5dxGLe9/81pxbTSbvkUkxcw0o0QsRJSS
	 +hZX4B7sKE+eCntbib2ywWm3+pBQJfZb972Lg2h7PP5CGS1r5L0iQ6cDIIyCsm7i6f
	 PpgXYWgBv9E12DnQdzpfCHH1RC12mfInqmIFdSDGuLC2ZWoiX1UxmPev5LKc8sF/dG
	 eHXSDnqzFsom0xtmYTX0vk/I/UP8ecUx7hz8yenaHDu6Mi3eR/TiTxEwTSqzp9ZQx7
	 yEhk8K1qjNLXnczVT4nM6ZQ3ginjeoQqXsgs4KbgkgZ1+4oSDXrFb9QUsx29ztEw8k
	 i4eQmDPK2WDxsAKTiB0zGUdqiYNe6nxgdNreMATEYeeHjv2rKHCiOcxmZBwGT8grRW
	 QgzpvU5oP4A8Nj/qqd6L7HxtdMbuNrUTmYZXC3wdQ9VVJR0FSbZVI1+ENcpz8OWItS
	 8aWI+AsXI0xo0HBbJU8G72P8=
Received: by infra.glanzmann.de (Postfix, from userid 1000)
	id CDAFF7A80089; Mon,  6 May 2024 19:21:32 +0200 (CEST)
Date: Mon, 6 May 2024 19:21:32 +0200
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trondmy@hammerspace.com>
Cc: kvm@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: I/O stalls when merging qcow2 snapshots on nfs
Message-ID: <ZjkRnJD7wQRnn1Lf@glanzmann.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74f183ca71fbde90678f138077965ffd19bed91b.camel@hammerspace.com>
 <CC139243-7C48-4416-BE71-3C7B651F00FC@redhat.com>

Hello Ben and Trond,

> On 5 May 2024, at 7:29, Thomas Glanzmann wrote paraphrased:

> When commiting 20 - 60 GB snapshots on kvm VMs which are stored on NFS I get 20
> seconds+ I/O stalls.

> When doing backups and migrations with kvm on NFS I get I/O stalls in
> the guest. How to avoid that?

* Benjamin Coddington <bcodding@redhat.com> [2024-05-06 13:25]:
> What NFS version ends up getting mounted here?

NFS 4.2: (below output has already your's and Tronds options added)

172.31.0.1:/nfs on /mnt type nfs4 (rw,relatime,vers=4.2,rsize=1048576,wsize=1048576,namlen=255,hard,proto=tcp,nconnect=16,timeo=600,retrans=2,sec=sys,clientaddr=172.31.0.6,local_lock=none,write=eager,addr=172.31.0.1)

> You might eliminate some head-of-line blocking issues with the
> "nconnect=16" mount option to open additional TCP connections.

> My view of what could be happening is that the IO from your guest's process
> is congesting with the IO from your 'virsh blockcommit' process, and we
> don't currently have a great way to classify and queue IO from various
> sources in various ways.

thank you for reminding me of nconnect. I evaluated it with VMware ESX and saw
no benefit when benchmarking it with a single VM and dismissed it. But of
course it makes sense when having more than one concurrent I/O stream.

* Trond Myklebust <trondmy@hammerspace.com> [2024-05-06 15:47]:
> Two suggestions:
>    1. Try mounting the NFS partition on which these VMs reside with the
>       "write=eager" mount option. That ensures that the kernel kicks
>       off the write of the block immediately once QEMU has scheduled it
>       for writeback. Note, however that the kernel does not wait for
>       that write to complete (i.e. these writes are all asynchronous).
>    2. Alternatively, try playing with the 'vm.dirty_ratio' or
>       'vm.dirty_bytes' values in order to trigger writeback at an
>       earlier time. With the default value of vm.dirty_ratio=20, you
>       can end up caching up to 20% of your total memory's worth of
>       dirty data before the VM triggers writeback over that 1Gbit link.

Thank you for the option write=eager. I was not aware of that but I
often run into problems where a 10 Gbit/s network pipe fills up my
buffer cache and than tries to destage GB 128 GB * 0.2 - 25.6 GB to the
disk which can't keep in my case and resulting in long I/O stalls. Usually my
disks can take between 100 (synchronous replicated drbd link 200km) - 500 MB/s
(SATA SSDs). I tried to tell kernel to destage faster by
(vm.dirty_expire_centisecs=100) which improved some workloads but not all.

So, I think I found a solution to my problem by doing the following:

- Increase NFSD threads to 128:

cat > /etc/nfs.conf.d/storage.conf <<'EOF'
[nfsd]
threads = 128

[mountd]
threads = 8
EOF
echo 128 > /proc/fs/nfsd/threads

- Mount the nfs volume with -o nconnect=16,write=eager

- Use iothreads and cache=none.

  <iothreads>2</iothreads>
  <driver name='qemu' type='qcow2' cache='none' discard='unmap' iothread='1'/>

By doing the above I no longer see any I/O stalls longer than one second (in my
date loop 2 seconds time difference).

Thank you two again for helping me out with this.

Cheers,
	Thomas

PS: Cache=writethrough and without I/O threads the I/O stalls for the time blockcommit executes.

