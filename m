Return-Path: <kvm+bounces-39267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9372CA45AFD
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 10:59:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CFBD37A37D1
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 09:57:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E8562459F3;
	Wed, 26 Feb 2025 09:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TmXTCPDU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CF42459CA;
	Wed, 26 Feb 2025 09:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740563796; cv=none; b=E2cQKeXbhdOlgG1i4PalHPS2c+ksltyTPLM+Cz8Vk4hUvMBoeuZG5D9ZQnv9arkiBTVNYzfRb17IWBAx7nT7KRMqm4sx2mq85N5COBRKDYeB5WAVcWekwkyeKdT+rv4T4C+oqm0zj8VZDJFkc/VZZwN+yhJv9oKcLODxOR0EgUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740563796; c=relaxed/simple;
	bh=1iExFtZ3QvWxcM47HUcAx+z+werqUEUymLyduVoKl+E=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XkvHOvedwAx2sALzTfYtaife+4mPFDqc4XCXi8MEnFygxKNvoMaomaeI98YT4k9YQeXXVgdY6ExtrO3kXHSjUM7QfEUf/TYVWUOaZMScymi5sb/YIyNMBW4byQfCtPENrcoIYIZtxSdrXsCogNjdT0v4KZ3J4ojwzDBykJDKXIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TmXTCPDU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37121C4CED6;
	Wed, 26 Feb 2025 09:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740563796;
	bh=1iExFtZ3QvWxcM47HUcAx+z+werqUEUymLyduVoKl+E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=TmXTCPDU7uiKjJOuSlwFAIbVncCjuP+EvqjS5MqLvrwPfA9pYdrBKYDVryiF+KgCl
	 yMBFPK/UOFoHxU/SSzprXZSSYmB8xnI1peLHdkgF54o3MTYigEsOrDFP7do9XbYWfd
	 x0TJxyW2IzLLNh5dRL8EYcuYw1REqkl9Cjzep/URf35j7AYT/g9DgQXfaedl5lyw2i
	 EZbjOqjEFZWuydFMnV3vuP0qN6OUysNpNL/7yfPhM9p7pDiHQ+YxiX/avdepjGpsJz
	 rkFBX7BQdMr1yGwsuLBZqz/CL3erfvG/lPtp4F70rTC7PIKtWChjD4wqGu4m6WKxY0
	 Obg0arufcesVg==
Date: Wed, 26 Feb 2025 10:56:28 +0100
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
 <linux-kernel@vger.kernel.org>, Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v3 00/14] Change ghes to use HEST-based offsets and add
 support for error inject
Message-ID: <20250226105628.7e60f952@foz.lan>
In-Reply-To: <20250225110115.6090e416@imammedo.users.ipa.redhat.com>
References: <cover.1738345063.git.mchehab+huawei@kernel.org>
	<20250203110934.000038d8@huawei.com>
	<20250203162236.7d5872ff@imammedo.users.ipa.redhat.com>
	<20250221073823.061a1039@foz.lan>
	<20250221102127.000059e6@huawei.com>
	<20250225110115.6090e416@imammedo.users.ipa.redhat.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Em Tue, 25 Feb 2025 11:01:15 +0100
Igor Mammedov <imammedo@redhat.com> escreveu:

> On Fri, 21 Feb 2025 10:21:27 +0000
> Jonathan Cameron <Jonathan.Cameron@huawei.com> wrote:
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
> > at all.   Even after this series I think we don't test HEST.  You add
> > a stub hest and exclusion but then in patch 12 the HEST stub is deleted whereas
> > it should be replaced with the example data for the test.  
> 
> that's what I was saying.
> HEST table should be in DSDT, but it's optional and one has to use
> 'ras=on' option to enable that, which we aren't doing ATM.
> So whatever changes are happening we aren't seeing them in tests
> nor will we see any regression for the same reason.
> 
> While white listing tables before change should happen and then updating them
> is the right thing to do, it's not sufficient since none of tests
> run with 'ras' enabled, hence code is not actually executed. 

Ok. Well, again we're not modifying HEST table structure on this
changeset. The only change affecting HEST is when the number of entries
increased from 1 to 2.

Now, looking at bios-tables-test.c, if I got it right, I should be doing
something similar to the enclosed patch, right?

If so, I have a couple of questions:

1. from where should I get the HEST table? dumping the table from the
   running VM?

2. what values should I use to fill those variables:

	int hest_offset = 40 /* HEST */;
	int hest_entry_size = 4;


> 
> > 
> > That indeed doesn't address testing the error data storage which would be
> > a different problem.  
> 
> I'd skip hardware_errors/CPER testing from QEMU unit tests.
> That's basically requires functioning 'APEI driver' to test that.
> 
> Maybe we can use Ani's framework to parse HEST and all the way
> towards CPER record(s) traversal, but that's certainly out of
> scope of this series.
> It could be done on top, but I won't insist even on that
> since Mauro's out of tree error injection testing will
> cover that using actual guest (which I assume he would
> like to run periodically).

Yeah, my plan is to periodically test it. I intend to setup somewhere
a CI to test Kernel, QEMU and rasdaemon altogether.

Thanks,
Mauro

---

diff --git a/tests/qtest/bios-tables-test.c b/tests/qtest/bios-tables-test.c
index 0a333ec43536..31e69d906db4 100644
--- a/tests/qtest/bios-tables-test.c
+++ b/tests/qtest/bios-tables-test.c
@@ -210,6 +210,8 @@ static void test_acpi_fadt_table(test_data *data)
     uint32_t val;
     int dsdt_offset = 40 /* DSDT */;
     int dsdt_entry_size = 4;
+    int hest_offset = 40 /* HEST */;
+    int hest_entry_size = 4;
 
     g_assert(compare_signature(&table, "FACP"));
 
@@ -242,6 +244,12 @@ static void test_acpi_fadt_table(test_data *data)
     /* update checksum */
     fadt_aml[9 /* Checksum */] = 0;
     fadt_aml[9 /* Checksum */] -= acpi_calc_checksum(fadt_aml, fadt_len);
+
+
+
+    acpi_fetch_table(data->qts, &table.aml, &table.aml_len,
+                     fadt_aml + hest_offset, hest_entry_size, "HEST", true);
+    g_array_append_val(data->tables, table);
 }
 
 static void dump_aml_files(test_data *data, bool rebuild)
@@ -2411,7 +2419,7 @@ static void test_acpi_aarch64_virt_oem_fields(void)
     };
     char *args;
 
-    args = test_acpi_create_args(&data, "-cpu cortex-a57 "OEM_TEST_ARGS);
+    args = test_acpi_create_args(&data, "-ras on -cpu cortex-a57 "OEM_TEST_ARGS);
     data.qts = qtest_init(args);
     test_acpi_load_tables(&data);
     test_oem_fields(&data);


