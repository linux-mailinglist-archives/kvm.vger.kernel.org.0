Return-Path: <kvm+bounces-39591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 75DCAA482B9
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 16:18:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F6F31889489
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 15:14:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 161C926A1A5;
	Thu, 27 Feb 2025 15:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KlMV9lS3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBF3259493;
	Thu, 27 Feb 2025 15:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740669231; cv=none; b=ZFoBiNfLTvS9TLVv17juMvHOKNEjwbJYfPlLVQBT65UWy6G7941AAgfznAboaCRiUuXltG9NZSoOHiHipKC2G/cYTgzn9HGEwq+cZdxqniYh4eMqcC1rhcBFwx/xLXUc/mi3IFgDIs0Zt4eRHFjgOKo/eAxs4ORpzJF90yvrEqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740669231; c=relaxed/simple;
	bh=iRdlLeLNV1v/SdkmRrf//HdDAGmEp0/h9w4ViUssNHI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=exN1RCs0lp4ENaaBQem+kSoEH7iQSjqlxbiVexLaK28lafCvNNsFAMdL8y4ZCJZdxB3krIBdiSVKoP+Z2Li6xlPrXH3kSzGKJiNvk7RqPaTrYEIKvjYNfOggVEUhDmnpjWEM/4dyt9ZMn6etUYMOuK3EqceNAt9ewRrDrSSG3+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KlMV9lS3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A22C4CEDD;
	Thu, 27 Feb 2025 15:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740669230;
	bh=iRdlLeLNV1v/SdkmRrf//HdDAGmEp0/h9w4ViUssNHI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=KlMV9lS37dpdw08l0ZO9yoYTuDxJ4zhPda/N50v/03oY2/UWS9pwfZc8fajaTrV11
	 uYsB7hW9K9j6tYE4pcLxuha5pJp0rYMOuaZdUEQfLKeQ+v0OnQeMOPYTGmLYe1GwJ8
	 8D/PtrCKkKjCNupk0/u0ha6GvrEZLlf6hixpN9MCfzc4O0NGAQIGDf6mPYbyLpCR8c
	 7n25zAJcN1SF6DSQVnLZF2XS5bLjBeLRGDKX3o8laLNBPnhHOGVChdf78Kk1m8PxXY
	 Gu6hygs/eIQMK2jeqKggfMzN74Yfw/J+t/XQkFVsToGsT27SwWuhNrybsKQI0ZuKCP
	 8vMe+5FUiBLNQ==
Date: Thu, 27 Feb 2025 16:13:43 +0100
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: Igor Mammedov <imammedo@redhat.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Jonathan Cameron
 <Jonathan.Cameron@huawei.com>, Shiju Jose <shiju.jose@huawei.com>,
 qemu-arm@nongnu.org, qemu-devel@nongnu.org, Philippe =?UTF-8?B?TWF0aGll?=
 =?UTF-8?B?dS1EYXVkw6k=?= <philmd@linaro.org>, Ani Sinha
 <anisinha@redhat.com>, Cleber Rosa <crosa@redhat.com>, Dongjiu Geng
 <gengdongjiu1@gmail.com>, Eduardo Habkost <eduardo@habkost.net>, Eric Blake
 <eblake@redhat.com>, John Snow <jsnow@redhat.com>, Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>, Markus Armbruster <armbru@redhat.com>,
 Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Shannon Zhao
 <shannon.zhaosl@gmail.com>, Yanan Wang <wangyanan55@huawei.com>, Zhao Liu
 <zhao1.liu@intel.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 00/21]Change ghes to use HEST-based offsets and add
 support for error inject
Message-ID: <20250227161343.5249e9b8@foz.lan>
In-Reply-To: <20250227143028.22372363@imammedo.users.ipa.redhat.com>
References: <cover.1740653898.git.mchehab+huawei@kernel.org>
	<20250227143028.22372363@imammedo.users.ipa.redhat.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Em Thu, 27 Feb 2025 14:30:28 +0100
Igor Mammedov <imammedo@redhat.com> escreveu:

> On Thu, 27 Feb 2025 12:03:30 +0100
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:
> 
> > Now that the ghes preparation patches were merged, let's add support
> > for error injection.
> > 
> > On this version, HEST table got added to ACPI tables testing for aarch64 virt.
> > 
> > There are also some patch reorder to help reviewers to check the changes.
> > 
> > The code itself is almost identical to v4, with just a few minor nits addressed.  
> 
> series still has checkpatch errors 'line over 80' which are not false positive,
> it needs to be fixed

The long line warnings are at the patch adding the Python script. IMO,
all but one are false positives:

1. Long lines at patch description because of the tool output example added
   inside the commit description:

	ERROR: line over 90 characters
	#148: FILE: scripts/arm_processor_error.py:83:
	+[Hardware Error]:     bus error, operation type: Generic read (type of instruction or data request cannot be determined)

	ERROR: line over 90 characters
	#153: FILE: scripts/arm_processor_error.py:88:
	+[Hardware Error]:     Program execution can be restarted reliably at the PC associated with the error.

	WARNING: line over 80 characters
	#170: FILE: scripts/arm_processor_error.py:105:
	+[Hardware Error]:    00000000: 13 7b 04 05 01                                   .{...

	WARNING: line over 80 characters
	#174: FILE: scripts/arm_processor_error.py:109:
	+[Firmware Warn]: GHES: Unhandled processor error type 0x10: micro-architectural error

	ERROR: line over 90 characters
	#175: FILE: scripts/arm_processor_error.py:110:
	+[Firmware Warn]: GHES: Unhandled processor error type 0x14: TLB error|micro-architectural error

   IMO, breaking command output at the description is a bad practice.

2. Big strings at help message:

	WARNING: line over 80 characters
	#261: FILE: scripts/arm_processor_error.py:196:
	+                           help="Power State Coordination Interface - PSCI state")

	ERROR: line over 90 characters
	#276: FILE: scripts/arm_processor_error.py:211:
	+                        help="Number of errors: 0: Single error, 1: Multiple errors, 2-65535: Error count if known")

	WARNING: line over 80 characters
	#278: FILE: scripts/arm_processor_error.py:213:
	+                        help="Error information (UEFI 2.10 tables N.18 to N.20)")

	ERROR: line over 90 characters
	#287: FILE: scripts/arm_processor_error.py:222:
	+                        help="Type of the context (0=ARM32 GPR, 5=ARM64 EL1, other values supported)")


	WARNING: line over 80 characters
	#1046: FILE: scripts/qmp_helper.py:442:
	+                           help="Marks the timestamp as precise if --timestamp is used")

	WARNING: line over 80 characters
	#1048: FILE: scripts/qmp_helper.py:444:
	+                           help=f"General Error Data Block flags: {gedb_flags_bits}")

   Those might be changed if we add one variable per string to store the
   help lines, at the expense of doing some code obfuscation.

   I don't think doing it is a good idea.

3. Long class function names that are part of Python's standard library:

	ERROR: line over 90 characters
	#576: FILE: scripts/ghes_inject.py:29:
	+    parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter,

   We can't change the big name of the argparse formatter. The only
   possible fix would be to obfuscate it by doing:

	format = argparse.ArgumentDefaultsHelpFormatter,
	parser = argparse.ArgumentParser(formatter_class=format,

   IMO this is a bad practice.

4. False-positive warning disable for pylint coding style tool:

	ERROR: line over 90 characters
	#805: FILE: scripts/qmp_helper.py:201:
	+        data.extend(value.to_bytes(num_bytes, byteorder="little"))  # pylint: disable=E1101

	WARNING: line over 80 characters
	#1028: FILE: scripts/qmp_helper.py:424:
	+        g_gen = parser.add_argument_group("Generic Error Data")  # pylint: disable=E1101

   AFAIKT, those need to be at the same line for pylint to process them
   properly.

5. A long name inside an indented block:

	WARNING: line over 80 characters
	#1109: FILE: scripts/qmp_helper.py:505:
	+                                                   value=args.gen_err_valid_bits,

   Again the only solution would be to obfuscate the argument, like:

	a = args.gen_err_valid_bits

							    value=a,

   Not nice, IMHO.

Now, there is one warning that I is not a false positive, which I ended
missing:

	WARNING: line over 80 characters
	#1227: FILE: scripts/qmp_helper.py:623:
	+            ret = self.send_cmd("qom-get", args, may_open=True, return_error=False)

I'll fix it at the next respin.

Regards,
Mauro

