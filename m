Return-Path: <kvm+bounces-38855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C42EA3F7FD
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 16:06:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A336F189DC48
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 15:06:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA3FA210190;
	Fri, 21 Feb 2025 15:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dOFYx0pg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC861208962;
	Fri, 21 Feb 2025 15:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740150367; cv=none; b=Z2JiP+f2xFS9JmOX4M9/1spfrtCjfkQ6+7hbtivVuJnzpyxG3kEDOgN8v/Jj7297OJf7fIb6rF5Od78oHir/vNmnvLSz/32Yhw6JA5O8LHr0cB0m8lNJS3S91i7sdUAhb2ODPhjoByGDd3R2qHlPaIlNWa0EVi2RiR80QVyqFHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740150367; c=relaxed/simple;
	bh=z949hO3MwOXAyFCNa2KF23enIns2zrbW6wuKQGwpDGA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=utg6fF5EnQteeWxGdikI/VE1GjzVJ5s+MSk6mYNg9e1n9LhPLQ8Phb015v0EO2A0805WtP8G0KCxZkTgORfdyIvJtc9NiqgW7GV3gD+elDkEhyEuXUOyGTHRqZyZ3dHCJI8MfEz4EPfGJIkw5H3Vf7kZp/wvs+XdJ4yN7l/A6q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dOFYx0pg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D99FC4CED6;
	Fri, 21 Feb 2025 15:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740150367;
	bh=z949hO3MwOXAyFCNa2KF23enIns2zrbW6wuKQGwpDGA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dOFYx0pgtFeJmTDUukXY6GQOXqGl42lq6X+gMyonqBl7FP/gI2aE7zyqxwN4APq6h
	 efrKTQV+HKkN3efyqi6hxldj2F7rjr0EkRw7oaZK6JzvA/JiV4P7Bj8byzy1fGfCdD
	 ed5jCTOWU8OUlPSHlcha20IJR2ag4JxtU3kLWzFAVnirVJlhycVVgJncDfEqFPqbtY
	 iXPYRp1lkIxi84zpv3yiQDORVzRqo6J0dg1idG7DlkAVYRTJtqEjlizqIFo/k/snA6
	 kqmihHXgKf7btUIGuChUjsAz0/f1X9yG59Jwb/IFb5qNUVtAYahtOmI9FB5lRXTS3C
	 o/q4eQhxcYLvg==
Date: Fri, 21 Feb 2025 16:05:59 +0100
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Igor Mammedov <imammedo@redhat.com>, "Michael S . Tsirkin"
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
 <linux-kernel@vger.kernel.org>, Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v3 00/14] Change ghes to use HEST-based offsets and add
 support for error inject
Message-ID: <20250221160530.020f6cec@foz.lan>
In-Reply-To: <20250221132306.77800dbf@sal.lan>
References: <cover.1738345063.git.mchehab+huawei@kernel.org>
	<20250203110934.000038d8@huawei.com>
	<20250203162236.7d5872ff@imammedo.users.ipa.redhat.com>
	<20250221073823.061a1039@foz.lan>
	<20250221102127.000059e6@huawei.com>
	<20250221132306.77800dbf@sal.lan>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Em Fri, 21 Feb 2025 13:23:06 +0100
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> escreveu:

> Em Fri, 21 Feb 2025 10:21:27 +0000
> Jonathan Cameron <Jonathan.Cameron@huawei.com> escreveu:
> 
> > On Fri, 21 Feb 2025 07:38:23 +0100
> > Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:
> >   
> > > Em Mon, 3 Feb 2025 16:22:36 +0100
> > > Igor Mammedov <imammedo@redhat.com> escreveu:
> > >     
> > > > On Mon, 3 Feb 2025 11:09:34 +0000
> > > > Jonathan Cameron <Jonathan.Cameron@huawei.com> wrote:
> > > >       
> > > > > On Fri, 31 Jan 2025 18:42:41 +0100
> > > > > Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:
> > > > >         
> > > > > > Now that the ghes preparation patches were merged, let's add support
> > > > > > for error injection.
> > > > > > 
> > > > > > On this series, the first 6 patches chang to the math used to calculate offsets at HEST
> > > > > > table and hardware_error firmware file, together with its migration code. Migration tested
> > > > > > with both latest QEMU released kernel and upstream, on both directions.
> > > > > > 
> > > > > > The next patches add a new QAPI to allow injecting GHESv2 errors, and a script using such QAPI
> > > > > >    to inject ARM Processor Error records.
> > > > > > 
> > > > > > If I'm counting well, this is the 19th submission of my error inject patches.          
> > > > > 
> > > > > Looks good to me. All remaining trivial things are in the category
> > > > > of things to consider only if you are doing another spin.  The code
> > > > > ends up how I'd like it at the end of the series anyway, just
> > > > > a question of the precise path to that state!        
> > > > 
> > > > if you look at series as a whole it's more or less fine (I guess you
> > > > and me got used to it)
> > > > 
> > > > however if you take it patch by patch (as if you've never seen it)
> > > > ordering is messed up (the same would apply to everyone after a while
> > > > when it's forgotten)
> > > > 
> > > > So I'd strongly suggest to restructure the series (especially 2-6/14).
> > > > re sum up my comments wrt ordering:
> > > > 
> > > > 0  add testcase for HEST table with current HEST as expected blob
> > > >    (currently missing), so that we can be sure that we haven't messed
> > > >    existing tables during refactoring.      
> > 
> > To potentially save time I think Igor is asking that before you do anything
> > at all you plug the existing test hole which is that we don't test HEST
> > at all.   Even after this series I think we don't test HEST.   
> 
> On a previous review (v2, I guess), Igor requested me to do the DSDT
> test just before and after the patch which is actually changing its
> content (patch 11). The HEST table is inside DSDT firmware, and it is
> already tested.
> 
> > You add
> > a stub hest and exclusion but then in patch 12 the HEST stub is deleted whereas
> > it should be replaced with the example data for the test.  
> 
> This was actually a misinterpretation from my side: patch 10 adds the
> etc/hardware_errors table (mistakenly naming it as HEST), but this
> was never tested. For the next submission, I'll drop etc/hardware_errors
> table from patches 10 and 12.
> 
> > That indeed doesn't address testing the error data storage which would be
> > a different problem.  
> > > 
> > > Not sure if I got this one. The HEST table is part of etc/acpi/tables,
> > > which is already tested, as you pointed at the previous reviews. Doing
> > > changes there is already detected. That's basically why we added patches
> > > 10 and 12:
> > > 
> > > 	[PATCH v3 10/14] tests/acpi: virt: allow acpi table changes for a new table: HEST
> > > 	[PATCH v3 12/14] tests/acpi: virt: add a HEST table to aarch64 virt and update DSDT
> > > 
> > > What tests don't have is a check for etc/hardware_errors firmware inside 
> > > tests/data/acpi/aarch64/virt/, but, IMO, we shouldn't add it there.
> > > 
> > > See, hardware_errors table contains only some skeleton space to
> > > store:
> > > 
> > > 	- 1 or more error block address offsets;
> > > 	- 1 or more read ack register;
> > > 	- 1 or more HEST source entries containing CPER blocks.
> > > 
> > > There's nothing there to be actually checked: it is just some
> > > empty spaces with a variable number of fields.
> > > 
> > > With the new code, the actual number of CPER blocks and their
> > > corresponding offsets and read ack registers can be different on 
> > > different architectures. So, for instance, when we add x86 support,
> > > we'll likely start with just one error source entry, while arm will
> > > have two after this changeset.
> > > 
> > > Also, one possibility to address the issues reported by Gavin Shan at
> > > https://lore.kernel.org/qemu-devel/20250214041635.608012-1-gshan@redhat.com/
> > > would be to have one entry per each CPU. So, the size of such firmware
> > > could be dependent on the number of CPUs.
> > > 
> > > So, adding any validation to it would just cause pain and probably
> > > won't detect any problems.    
> > 
> > If we did do this the test would use a fixed number of CPUs so
> > would just verify we didn't break a small number of variants. Useful
> > but to me a follow up to this series not something that needs to
> > be part of it - particularly as Gavin's work may well change that!  
> 
> I don't think that testing etc/hardware_errors would detect any
> regressions. It will just create a test scenario that will require
> constant changes, as adding any entry to HEST would hit it. 

Btw, there is just one patch on this series touching 
etc/hardware_errors:

	https://lore.kernel.org/qemu-devel/647f9c974e606924b6b881a83e047d1d4dff47d5.1740148260.git.mchehab+huawei@kernel.org/T/#u

The table change is due to this simple hunk:

diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
index 4f174795ed60..7b6e90d69298 100644
--- a/hw/arm/virt-acpi-build.c
+++ b/hw/arm/virt-acpi-build.c
@@ -896,6 +896,7 @@ static void acpi_align_size(GArray *blob, unsigned align)
 
 static const AcpiNotificationSourceId hest_ghes_notify[] = {
     { ACPI_HEST_SRC_ID_SYNC, ACPI_GHES_NOTIFY_SEA },
+    { ACPI_HEST_SRC_ID_QMP, ACPI_GHES_NOTIFY_GPIO },
 };


Before such patch, /etc/hardware_errors has:

	- 1 error block offset;
	- 1 ack register;
	- 1 GHESv2 entry for SEA

After the change:

- for virt-9.2: nothing changes, as hw/arm/virt-acpi-build.c will
  use the backward-compatible table with a single entry to be
  added to HEST:

	static const AcpiNotificationSourceId hest_ghes_notify_9_2[] = {
	    { ACPI_HEST_SRC_ID_SYNC, ACPI_GHES_NOTIFY_SEA },
	};

- for virt-latest/virt-10.0, it will use the new table to create two
  sources:

	static const AcpiNotificationSourceId hest_ghes_notify[] = {
	    { ACPI_HEST_SRC_ID_SYNC, ACPI_GHES_NOTIFY_SEA },
	    { ACPI_HEST_SRC_ID_QMP, ACPI_GHES_NOTIFY_GPIO },
	};

  which will actually mean that /etc/hardware_errors will now have:

	- 2 error block offsets (one for SEA, one for GED);
	- 2 ack registers (one for SEA, one for GED);
	- 1 GHESv2 entry for SEA notifier;
	- 1 GHESv2 entry for GED GPIO notifier.

With the discussions with Gavin, for virt-10.0 and above, we may end changing 
the new table (hest_ghes_notify) to have one SEA entry per CPU, plus the GPIO 
one, and add an extra logic at the error injection logic to select the SEA
entry based on the CPU ID and/or based on having an already acked
SEA notifier.
 
> 
> Besides that, I don't think adding support for it would be a simple
> matter of adding another table. See, after this series, there are two 
> different scenarios for the /etc/hardware_errors:
> 
> - one with a single GHESv2 entry, for virt-9.2;
> - another one with two GHESv2 entries for virt-10.0 and above that
>   will dynamically change its size (starting from 2) depending on
>   the features we add, and if we'll have one entry per CPU or not.
> 
> Right now, the tests there are only for "virt-latest": there's no
> test directory for "virt-9.2". Adding support for virt-legacy will 
> very likely require lots of changes there at the test infrastructure,
> as it will require some virt migration support. 
> 
> > > What could be done instead is to have a different type of tests that
> > > would use the error injection script to check if regressions are 
> > > introduced after QEMU 10.0. Such new kind of test would require
> > > this series to be merged first. It would also require the usage of
> > > an OSPM image with some testing tools on it. This is easier said 
> > > than done, as besides the complexity of having an OSPM test image,
> > > such kind of tests would require extra logic, specially if it would
> > > check regressions for SEA and other notification sources.
> > >     
> > Agreed that a more end to end test is even better, but those are
> > quite a bit more complex so definitely a follow up.  
> 
> Yes, but it could be simpler than modifying ACPI tests to handle
> migration.
> 
> The way I see is that such kind of integration could be done by some
> gitlab workflow that would run an error injection script inside a
> pre-defined image emulating both virt-9.2 and virt-latest and checking
> if the HEST tables were properly generated for both SEA and GED
> sources.
> 
> This is probably easier for GED, as the QMP interface already
> detects that the read ack register was changed by the OSPM. For
> SEA, it may require either some additional instrumentation or to
> capture OSPM logs.
> 
> Anyway, ether way, a change like that is IMO outside the escope of
> this series, as it will require lots of unrelated changes.
> 
> Regards,
> Mauro
> 



Thanks,
Mauro

