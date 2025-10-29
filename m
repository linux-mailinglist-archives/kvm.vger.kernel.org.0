Return-Path: <kvm+bounces-61417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F061C1D0FF
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 20:54:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 07BD83AC07E
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 19:53:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C0C735A14F;
	Wed, 29 Oct 2025 19:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="C7Q3gOI6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kyU4Om3r";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="C7Q3gOI6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kyU4Om3r"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA9419CD03
	for <kvm@vger.kernel.org>; Wed, 29 Oct 2025 19:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761767631; cv=none; b=f/EQ3ONLs1SUB1vqSCodgaewPQ7FgPw8BGSs9zmMjylTtu4scHHUFafl/1DDAn/Jjv9+Hc4ZKuJIm3pflP3l/w5BmyYwFE/IWOQ20SfkcaifN+peOwu3nRQ6btnSU4sk5yW1KsoKQDMyuoaWx+bCTBCBQEECvQ9JE9l/4nvi3WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761767631; c=relaxed/simple;
	bh=NYvovgAj7zt8GDEAG7ywAu9miawDzsAFbj86c/i3NWc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jGmQceU4dhEItvt9x/VJmkp+LRsyS8OJcMeG1vUWTJSl3yMecfDCWoHrBYI0xWhSZ43LJclXw+XGOyQk2IzJfurdF4cIXKKzfcTAbTCYEzbmVHJCar/2kpuJjUDTW0enY6rUhZbb5pPKWfALqFMiW89QQ1wPwnX2qI9EmzV/u2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=C7Q3gOI6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kyU4Om3r; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=C7Q3gOI6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kyU4Om3r; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from kitsune.suse.cz (unknown [10.100.12.127])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4BF0C5C551;
	Wed, 29 Oct 2025 19:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761767627; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NPKuRCtRL+cGFEISJPZpkrApshhoy8kZay3T7ph1BY8=;
	b=C7Q3gOI6kmERxvs74t0egUwH7m7NezGuwT1J8o/PcJPPL6MKdjSIgcZIsAmfTdNIITqqvu
	FnBH6dVl6r+/dOMLyFKEOh3G9Kbikdp+ncGrAmWy5b/aY4TBhHMmVhv2iCZFYhupdis9SX
	0c70YYQ0Xk++ZtO+Ctxt2vRKDpzSB4k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761767627;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NPKuRCtRL+cGFEISJPZpkrApshhoy8kZay3T7ph1BY8=;
	b=kyU4Om3rTn7cn6qiWi1M4P34MvfF4+0iO51SR/7z+QznWZgOMXPbj3WZRU/r3ZuN+dMwzu
	gELeh4jqtdreaECQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761767627; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NPKuRCtRL+cGFEISJPZpkrApshhoy8kZay3T7ph1BY8=;
	b=C7Q3gOI6kmERxvs74t0egUwH7m7NezGuwT1J8o/PcJPPL6MKdjSIgcZIsAmfTdNIITqqvu
	FnBH6dVl6r+/dOMLyFKEOh3G9Kbikdp+ncGrAmWy5b/aY4TBhHMmVhv2iCZFYhupdis9SX
	0c70YYQ0Xk++ZtO+Ctxt2vRKDpzSB4k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761767627;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NPKuRCtRL+cGFEISJPZpkrApshhoy8kZay3T7ph1BY8=;
	b=kyU4Om3rTn7cn6qiWi1M4P34MvfF4+0iO51SR/7z+QznWZgOMXPbj3WZRU/r3ZuN+dMwzu
	gELeh4jqtdreaECQ==
Date: Wed, 29 Oct 2025 20:53:46 +0100
From: Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Cc: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	qemu-devel@nongnu.org, Chinmay Rath <rathc@linux.ibm.com>,
	qemu-ppc@nongnu.org, Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?iso-8859-1?Q?C=E9dric?= Le Goater <clg@redhat.com>
Subject: Re: [PATCH v2 00/11] hw/ppc/spapr: Remove deprecated pseries-3.0 ->
 pseries-4.2 machines
Message-ID: <aQJwyoC-BclJRdXE@kitsune.suse.cz>
References: <20251021084346.73671-1-philmd@linaro.org>
 <aPdpjysqFBAMTvG-@kitsune.suse.cz>
 <1f952d10-9630-42d6-8d24-b7461f90aa9f@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1f952d10-9630-42d6-8d24-b7461f90aa9f@linux.ibm.com>
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_ZERO(0.00)[0];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_SEVEN(0.00)[10];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_CC(0.00)[linaro.org,nongnu.org,linux.ibm.com,gmail.com,vger.kernel.org,redhat.com];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On Wed, Oct 29, 2025 at 11:00:18PM +0530, Shivaprasad G Bhat wrote:
> Hi Michal,
> 
> On 10/21/25 4:37 PM, Michal Suchánek wrote:
> > Hello,
> > 
> > I noticed removal of old pSeries revisions.
> > 
> > FTR to boot Linux 3.0 I need pSeries-2.7 (already removed earlier).
> > 
> > The thing that broke booting linux 3.0 for me is
> > 357d1e3bc7d2d80e5271bc4f3ac8537e30dc8046 spapr: Improved placement of
> > PCI host bridges in guest memory map
> > 
> > I do not use Linux 3.0 anymore which is the reason I did not notice this
> > breakage due to old platform revision removal.
> 
> I tried booting linux kernel 3.13.0-170-generic from ubuntu 14.04.6 LTS with
> the oldest supported machine pseries-5.0 as of now.
> 
> It worked fine.
> 
> 
> qemu-system-ppc64 -machine pseries-5.0 -accel tcg -nographic -m size=12G
> -cpu power8 -smp 1 -drive file=/root/images/ubuntu16.04.qcow2,format=qcow2,if=none,id=drive-virtio-disk0
> -device virtio-blk-pci,drive=drive-virtio-disk0,id=virtio-disk0 -serial
> mon:stdio -kernel /root/images/vmlinux-3.13.0-170-generic -initrd
> /root/images/initrd.img-3.13.0-170-generic -append
> "BOOT_IMAGE=/boot/vmlinux-4.4.0-142-generic
> root=UUID=94fba90c-dbb0-4f8d-bc3e-acd5f2e54749 ro vt.handoff=7"
> 
> 
> shiva@ubuntu:~$ uname -a
> Linux ubuntu 3.13.0-170-generic #220-Ubuntu SMP Thu May 9 12:44:25 UTC 2019
> ppc64le ppc64le ppc64le GNU/Linux
> shiva@ubuntu:~$ cat /proc/cpuinfo
> processor    : 0
> cpu        : POWER8 (architected), altivec supported
> clock        : 1000.000000MHz
> revision    : 2.0 (pvr 004d 0200)
> 
> timebase    : 512000000
> platform    : pSeries
> model        : IBM pSeries (emulated by qemu)
> machine        : CHRP IBM pSeries (emulated by qemu)
> 
> 
> Hope that helps.

How does that help?

Of course newer kernels do work.

However, distributions using Linux 3.0 don't anymore, at least that
particular Linux 3.0 build.

I am not particularly concerned, only noting that the qemu pSeries
emulation is not suitable for running very old distributions because
they are not compatible with newer qemu.

It can be a bug in the old kernel but it's not triggered by actual
hardware nor older qemu. Or it may bee a bug with that new qemu PCI bus
organization that is not triggered by newer kernel. I don't know and
since nobody cared enough to diagnose it so far we will probably never
know.

Thanks

Michal

