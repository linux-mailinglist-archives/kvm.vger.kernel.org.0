Return-Path: <kvm+bounces-38835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E7BAEA3ECF5
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 07:38:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43CCE189523A
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 06:38:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F2731FDA90;
	Fri, 21 Feb 2025 06:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RJAy0pSy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EE31E3DCF;
	Fri, 21 Feb 2025 06:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740119911; cv=none; b=fYniXeM0tvglZbD4+dlPle4a85AyKVvnL/mNJyRaYyZPIIVcQhO6p1cZGKeaA8pJPwBOIVorb1myZwhomtZ95toU5blAhMwQrL4yn7vzwhPcMqjnUgMlZOfVEDWSMK26NLaamVS52KveegpDgByRsui9vO39Lgf5Qg0Pe9DWQps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740119911; c=relaxed/simple;
	bh=/EHL/JF7eS2/0snZ5wf6InM7vQD6VHbo9/K5D6CX9L0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SWNUILIWfs1rP8lNLqSc5wI9e2mqGLUmGZ9+7pbLocGBXtDhA9eos3D5esWOHWtSjmLATYWDjCPBJTn+qi63YTuwixDT7FcWgulu2K/WqtH0Zyu48VmGW/z9yRtJ5ZWP0ibU944tKpr5VaN4FSFwF5Ghi9qxCBoOWzGLK8laRn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RJAy0pSy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85360C4CED6;
	Fri, 21 Feb 2025 06:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740119911;
	bh=/EHL/JF7eS2/0snZ5wf6InM7vQD6VHbo9/K5D6CX9L0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=RJAy0pSy9nloi45ZfVr2VIvSdhDZrcj3GMNjoGco/4ViDspRkD7izHUXO4p8H98Pm
	 iF+EzITh0CrR6V93B83ApcchhbN1YEBrZDSwUHFGrd1lci8Nuzi72G/VdxO4l+Cw8o
	 Cec5q2Q5UMtzSGg6D/HRNrW97IsVyi1Km/skTmVpKqxH1aMrnk3GEclzFcoqC/qbCq
	 Vg5CwzTqHRHY4fs6dPuaNRKi3CkiV3tibVQrGgIi83mqfH796Mding6pT4Tv01jVKt
	 GuYHUvuAYS8pq83qdFJ6pi9p3uBf6S7WAB78EEvyhIkbF38mnvtgH0LeSFVRzycLB+
	 Pal/yO0+U7GgQ==
Date: Fri, 21 Feb 2025 07:38:23 +0100
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: Igor Mammedov <imammedo@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>, "Michael S . Tsirkin"
 <mst@redhat.com>, Shiju Jose <shiju.jose@huawei.com>,
 <qemu-arm@nongnu.org>, <qemu-devel@nongnu.org>, Philippe =?UTF-8?B?TWF0?=
 =?UTF-8?B?aGlldS1EYXVkw6k=?= <philmd@linaro.org>, Ani Sinha
 <anisinha@redhat.com>, Cleber Rosa <crosa@redhat.com>, Dongjiu Geng
 <gengdongjiu1@gmail.com>, Eduardo Habkost <eduardo@habkost.net>, Eric Blake
 <eblake@redhat.com>, John Snow <jsnow@redhat.com>, Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>, "Markus Armbruster" <armbru@redhat.com>,
 Michael Roth <michael.roth@amd.com>, "Paolo Bonzini" <pbonzini@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Shannon Zhao
 <shannon.zhaosl@gmail.com>, Yanan Wang <wangyanan55@huawei.com>, Zhao Liu
 <zhao1.liu@intel.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 00/14] Change ghes to use HEST-based offsets and add
 support for error inject
Message-ID: <20250221073823.061a1039@foz.lan>
In-Reply-To: <20250203162236.7d5872ff@imammedo.users.ipa.redhat.com>
References: <cover.1738345063.git.mchehab+huawei@kernel.org>
	<20250203110934.000038d8@huawei.com>
	<20250203162236.7d5872ff@imammedo.users.ipa.redhat.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Em Mon, 3 Feb 2025 16:22:36 +0100
Igor Mammedov <imammedo@redhat.com> escreveu:

> On Mon, 3 Feb 2025 11:09:34 +0000
> Jonathan Cameron <Jonathan.Cameron@huawei.com> wrote:
> 
> > On Fri, 31 Jan 2025 18:42:41 +0100
> > Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:
> >   
> > > Now that the ghes preparation patches were merged, let's add support
> > > for error injection.
> > > 
> > > On this series, the first 6 patches chang to the math used to calculate offsets at HEST
> > > table and hardware_error firmware file, together with its migration code. Migration tested
> > > with both latest QEMU released kernel and upstream, on both directions.
> > > 
> > > The next patches add a new QAPI to allow injecting GHESv2 errors, and a script using such QAPI
> > >    to inject ARM Processor Error records.
> > > 
> > > If I'm counting well, this is the 19th submission of my error inject patches.    
> > 
> > Looks good to me. All remaining trivial things are in the category
> > of things to consider only if you are doing another spin.  The code
> > ends up how I'd like it at the end of the series anyway, just
> > a question of the precise path to that state!  
> 
> if you look at series as a whole it's more or less fine (I guess you
> and me got used to it)
> 
> however if you take it patch by patch (as if you've never seen it)
> ordering is messed up (the same would apply to everyone after a while
> when it's forgotten)
> 
> So I'd strongly suggest to restructure the series (especially 2-6/14).
> re sum up my comments wrt ordering:
> 
> 0  add testcase for HEST table with current HEST as expected blob
>    (currently missing), so that we can be sure that we haven't messed
>    existing tables during refactoring.

Not sure if I got this one. The HEST table is part of etc/acpi/tables,
which is already tested, as you pointed at the previous reviews. Doing
changes there is already detected. That's basically why we added patches
10 and 12:

	[PATCH v3 10/14] tests/acpi: virt: allow acpi table changes for a new table: HEST
	[PATCH v3 12/14] tests/acpi: virt: add a HEST table to aarch64 virt and update DSDT

What tests don't have is a check for etc/hardware_errors firmware inside 
tests/data/acpi/aarch64/virt/, but, IMO, we shouldn't add it there.

See, hardware_errors table contains only some skeleton space to
store:

	- 1 or more error block address offsets;
	- 1 or more read ack register;
	- 1 or more HEST source entries containing CPER blocks.

There's nothing there to be actually checked: it is just some
empty spaces with a variable number of fields.

With the new code, the actual number of CPER blocks and their
corresponding offsets and read ack registers can be different on 
different architectures. So, for instance, when we add x86 support,
we'll likely start with just one error source entry, while arm will
have two after this changeset.

Also, one possibility to address the issues reported by Gavin Shan at
https://lore.kernel.org/qemu-devel/20250214041635.608012-1-gshan@redhat.com/
would be to have one entry per each CPU. So, the size of such firmware
could be dependent on the number of CPUs.

So, adding any validation to it would just cause pain and probably
won't detect any problems.

What could be done instead is to have a different type of tests that
would use the error injection script to check if regressions are 
introduced after QEMU 10.0. Such new kind of test would require
this series to be merged first. It would also require the usage of
an OSPM image with some testing tools on it. This is easier said 
than done, as besides the complexity of having an OSPM test image,
such kind of tests would require extra logic, specially if it would
check regressions for SEA and other notification sources.

Thanks,
Mauro

