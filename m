Return-Path: <kvm+bounces-39272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C2441A45D31
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 12:31:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2EF1C172DCC
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 11:31:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E01AC2153FA;
	Wed, 26 Feb 2025 11:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Izt1h1lk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61D017BB35;
	Wed, 26 Feb 2025 11:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740569477; cv=none; b=W+lSOxDaEefh1d99yT1aVNT8uDr/5FrvvrgG3j8iYDESVvEV/SGn8bm0Xf/JduXDERgsDnE624ifWIqsrkKZIVCUg1uN+yeAoa7+HJVMC4NRoZ0dSDRuufnquLFA6HAdnVgQjHOOwPF4pDuCUATidVl/+xgN2QLzQMwNmQZEtlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740569477; c=relaxed/simple;
	bh=AqaQc47KScGcVr3eESFC0LndEz0Dr5eNjmVGnvzicIk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RxeRXf//5UeowglVpZljL0lM+u/18zf0KIhQP5N4DunWHUhGcHYA1a3p25/AL2h2CEK9pOjPxTpdikjnOA+OrGmioXHSQpD4fglmyRC5UGRn1H9ZM3ud8oEVEOxdCloWO8xuYdYSsNlZlSiIAalWRTFA3QAgPyaHGf+UzHCWDpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Izt1h1lk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3D5C4CED6;
	Wed, 26 Feb 2025 11:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740569475;
	bh=AqaQc47KScGcVr3eESFC0LndEz0Dr5eNjmVGnvzicIk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Izt1h1lkeViZUXbX7cUqtNidC2hDYndE19VlJ7nGxVdqiwfFPZNThnALtoJ1mRWTv
	 FE9n1R8I9Mgvq/nb+A53gSSg7gD4Ds67aUoWH3FCViVhbUq86OVIoPt4kXRp+YkWpS
	 vGa7GoOWEQ93bedM7Y/MQQSShgCM47hyqZ7eN3RLwUIJGWW1HVAGtni1ppEqEtgsR4
	 B1I7LDg6NM+yebNMf71VyoizsgFUp/Av92aKxUzQ0Dv0pXEe/ZMQ4XyhjWcYMySBoa
	 ASmUSChsBrLtBLtXPu24jxH4NJuPkpv2+W2LVXjUFOJHPd9YkEdhJXn65VJMkJAVgs
	 Pxj052z2bRgrQ==
Date: Wed, 26 Feb 2025 12:31:07 +0100
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
Message-ID: <20250226123107.0cdb2e17@foz.lan>
In-Reply-To: <20250226122303.0131ce8b@foz.lan>
References: <cover.1738345063.git.mchehab+huawei@kernel.org>
	<20250203110934.000038d8@huawei.com>
	<20250203162236.7d5872ff@imammedo.users.ipa.redhat.com>
	<20250221073823.061a1039@foz.lan>
	<20250221102127.000059e6@huawei.com>
	<20250225110115.6090e416@imammedo.users.ipa.redhat.com>
	<20250226105628.7e60f952@foz.lan>
	<20250226122303.0131ce8b@foz.lan>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Em Wed, 26 Feb 2025 12:23:03 +0100
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> escreveu:

> Em Wed, 26 Feb 2025 10:56:28 +0100
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org> escreveu:
> 
> > Em Tue, 25 Feb 2025 11:01:15 +0100
> > Igor Mammedov <imammedo@redhat.com> escreveu:
> >   
> > > On Fri, 21 Feb 2025 10:21:27 +0000
> > > Jonathan Cameron <Jonathan.Cameron@huawei.com> wrote:
> > >     
> > > > On Fri, 21 Feb 2025 07:38:23 +0100
> > > > Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:
> > > >       
> > > > > Em Mon, 3 Feb 2025 16:22:36 +0100
> > > > > Igor Mammedov <imammedo@redhat.com> escreveu:
> > > > >         
> > > > > > On Mon, 3 Feb 2025 11:09:34 +0000
> > > > > > Jonathan Cameron <Jonathan.Cameron@huawei.com> wrote:
> > > > > >           
> > > > > > > On Fri, 31 Jan 2025 18:42:41 +0100
> > > > > > > Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:
> > > > > > >             
> > > > > > > > Now that the ghes preparation patches were merged, let's add support
> > > > > > > > for error injection.
> > > > > > > > 
> > > > > > > > On this series, the first 6 patches chang to the math used to calculate offsets at HEST
> > > > > > > > table and hardware_error firmware file, together with its migration code. Migration tested
> > > > > > > > with both latest QEMU released kernel and upstream, on both directions.
> > > > > > > > 
> > > > > > > > The next patches add a new QAPI to allow injecting GHESv2 errors, and a script using such QAPI
> > > > > > > >    to inject ARM Processor Error records.
> > > > > > > > 
> > > > > > > > If I'm counting well, this is the 19th submission of my error inject patches.              
> > > > > > > 
> > > > > > > Looks good to me. All remaining trivial things are in the category
> > > > > > > of things to consider only if you are doing another spin.  The code
> > > > > > > ends up how I'd like it at the end of the series anyway, just
> > > > > > > a question of the precise path to that state!            
> > > > > > 
> > > > > > if you look at series as a whole it's more or less fine (I guess you
> > > > > > and me got used to it)
> > > > > > 
> > > > > > however if you take it patch by patch (as if you've never seen it)
> > > > > > ordering is messed up (the same would apply to everyone after a while
> > > > > > when it's forgotten)
> > > > > > 
> > > > > > So I'd strongly suggest to restructure the series (especially 2-6/14).
> > > > > > re sum up my comments wrt ordering:
> > > > > > 
> > > > > > 0  add testcase for HEST table with current HEST as expected blob
> > > > > >    (currently missing), so that we can be sure that we haven't messed
> > > > > >    existing tables during refactoring.          
> > > > 
> > > > To potentially save time I think Igor is asking that before you do anything
> > > > at all you plug the existing test hole which is that we don't test HEST
> > > > at all.   Even after this series I think we don't test HEST.  You add
> > > > a stub hest and exclusion but then in patch 12 the HEST stub is deleted whereas
> > > > it should be replaced with the example data for the test.      
> > > 
> > > that's what I was saying.
> > > HEST table should be in DSDT, but it's optional and one has to use
> > > 'ras=on' option to enable that, which we aren't doing ATM.
> > > So whatever changes are happening we aren't seeing them in tests
> > > nor will we see any regression for the same reason.
> > > 
> > > While white listing tables before change should happen and then updating them
> > > is the right thing to do, it's not sufficient since none of tests
> > > run with 'ras' enabled, hence code is not actually executed.     
> > 
> > Ok. Well, again we're not modifying HEST table structure on this
> > changeset. The only change affecting HEST is when the number of entries
> > increased from 1 to 2.
> > 
> > Now, looking at bios-tables-test.c, if I got it right, I should be doing
> > something similar to the enclosed patch, right?
> > 
> > If so, I have a couple of questions:
> > 
> > 1. from where should I get the HEST table? dumping the table from the
> >    running VM?
> > 
> > 2. what values should I use to fill those variables:
> > 
> > 	int hest_offset = 40 /* HEST */;
> > 	int hest_entry_size = 4;  
> 
> Thanks,
> Mauro
> 
> As a reference, this is the HEST table before the patch series:

This is the diff of the HEST table before/after this series.

As already commented, the diff is basically:

	-[024h 0036 004h]          Error Source Count : 00000001
	+[024h 0036 004h]          Error Source Count : 00000002

Plus the new entry for source ID 1 using notify type 7 (GPIO):

	+[084h 0132 002h]               Subtable Type : 000A [Generic Hardware Error Source V2]
	+[086h 0134 002h]                   Source Id : 0001
	+[088h 0136 002h]           Related Source Id : FFFF
	...
	+[0A4h 0164 001h]                 Notify Type : 07 [GPIO]
	...
	+[0D0h 0208 008h]           Read Ack Preserve : FFFFFFFFFFFFFFFE
	+[0D8h 0216 008h]              Read Ack Write : 0000000000000001

Complete diff follows.

Regards,
Mauro

---

diff -u hest-before-changes.dsl hest-after-changes.dsl
--- hest-before-changes.dsl     2025-02-26 11:23:30.845089077 +0000
+++ hest-after-changes.dsl      2025-02-26 11:25:29.095066026 +0000
@@ -11,16 +11,16 @@
  */
 
 [000h 0000 004h]                   Signature : "HEST"    [Hardware Error Source Table]
-[004h 0004 004h]                Table Length : 00000084
+[004h 0004 004h]                Table Length : 000000E0
 [008h 0008 001h]                    Revision : 01
-[009h 0009 001h]                    Checksum : E0
+[009h 0009 001h]                    Checksum : 68
 [00Ah 0010 006h]                      Oem ID : "BOCHS "
 [010h 0016 008h]                Oem Table ID : "BXPC    "
 [018h 0024 004h]                Oem Revision : 00000001
 [01Ch 0028 004h]             Asl Compiler ID : "BXPC"
 [020h 0032 004h]       Asl Compiler Revision : 00000001
 
-[024h 0036 004h]          Error Source Count : 00000001
+[024h 0036 004h]          Error Source Count : 00000002
 
 [028h 0040 002h]               Subtable Type : 000A [Generic Hardware Error Source V2]
 [02Ah 0042 002h]                   Source Id : 0000
@@ -55,19 +55,62 @@
 [069h 0105 001h]                   Bit Width : 40
 [06Ah 0106 001h]                  Bit Offset : 00
 [06Bh 0107 001h]        Encoded Access Width : 04 [QWord Access:64]
-[06Ch 0108 008h]                     Address : 0000000139E40008
+[06Ch 0108 008h]                     Address : 0000000139E40010
 
 [074h 0116 008h]           Read Ack Preserve : FFFFFFFFFFFFFFFE
 [07Ch 0124 008h]              Read Ack Write : 0000000000000001
 
-Raw Table Data: Length 132 (0x84)
+[084h 0132 002h]               Subtable Type : 000A [Generic Hardware Error Source V2]
+[086h 0134 002h]                   Source Id : 0001
+[088h 0136 002h]           Related Source Id : FFFF
+[08Ah 0138 001h]                    Reserved : 00
+[08Bh 0139 001h]                     Enabled : 01
+[08Ch 0140 004h]      Records To Preallocate : 00000001
+[090h 0144 004h]     Max Sections Per Record : 00000001
+[094h 0148 004h]         Max Raw Data Length : 00000400
+
+[098h 0152 00Ch]        Error Status Address : [Generic Address Structure]
+[098h 0152 001h]                    Space ID : 00 [SystemMemory]
+[099h 0153 001h]                   Bit Width : 40
+[09Ah 0154 001h]                  Bit Offset : 00
+[09Bh 0155 001h]        Encoded Access Width : 04 [QWord Access:64]
+[09Ch 0156 008h]                     Address : 0000000139E40008
+
+[0A4h 0164 01Ch]                      Notify : [Hardware Error Notification Structure]
+[0A4h 0164 001h]                 Notify Type : 07 [GPIO]
+[0A5h 0165 001h]               Notify Length : 1C
+[0A6h 0166 002h]  Configuration Write Enable : 0000
+[0A8h 0168 004h]                PollInterval : 00000000
+[0ACh 0172 004h]                      Vector : 00000000
+[0B0h 0176 004h]     Polling Threshold Value : 00000000
+[0B4h 0180 004h]    Polling Threshold Window : 00000000
+[0B8h 0184 004h]       Error Threshold Value : 00000000
+[0BCh 0188 004h]      Error Threshold Window : 00000000
+
+[0C0h 0192 004h]   Error Status Block Length : 00000400
+[0C4h 0196 00Ch]           Read Ack Register : [Generic Address Structure]
+[0C4h 0196 001h]                    Space ID : 00 [SystemMemory]
+[0C5h 0197 001h]                   Bit Width : 40
+[0C6h 0198 001h]                  Bit Offset : 00
+[0C7h 0199 001h]        Encoded Access Width : 04 [QWord Access:64]
+[0C8h 0200 008h]                     Address : 0000000139E40018
 
-    0000: 48 45 53 54 84 00 00 00 01 E0 42 4F 43 48 53 20  // HEST......BOCHS 
+[0D0h 0208 008h]           Read Ack Preserve : FFFFFFFFFFFFFFFE
+[0D8h 0216 008h]              Read Ack Write : 0000000000000001
+
+Raw Table Data: Length 224 (0xE0)
+
+    0000: 48 45 53 54 E0 00 00 00 01 68 42 4F 43 48 53 20  // HEST.....hBOCHS 
     0010: 42 58 50 43 20 20 20 20 01 00 00 00 42 58 50 43  // BXPC    ....BXPC
-    0020: 01 00 00 00 01 00 00 00 0A 00 00 00 FF FF 00 01  // ................
+    0020: 01 00 00 00 02 00 00 00 0A 00 00 00 FF FF 00 01  // ................
     0030: 01 00 00 00 01 00 00 00 00 04 00 00 00 40 00 04  // .............@..
     0040: 00 00 E4 39 01 00 00 00 08 1C 00 00 00 00 00 00  // ...9............
     0050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  // ................
-    0060: 00 00 00 00 00 04 00 00 00 40 00 04 08 00 E4 39  // .........@.....9
+    0060: 00 00 00 00 00 04 00 00 00 40 00 04 10 00 E4 39  // .........@.....9
     0070: 01 00 00 00 FE FF FF FF FF FF FF FF 01 00 00 00  // ................
-    0080: 00 00 00 00                                      // ....
+    0080: 00 00 00 00 0A 00 01 00 FF FF 00 01 01 00 00 00  // ................
+    0090: 01 00 00 00 00 04 00 00 00 40 00 04 08 00 E4 39  // .........@.....9
+    00A0: 01 00 00 00 07 1C 00 00 00 00 00 00 00 00 00 00  // ................
+    00B0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  // ................
+    00C0: 00 04 00 00 00 40 00 04 18 00 E4 39 01 00 00 00  // .....@.....9....
+    00D0: FE FF FF FF FF FF FF FF 01 00 00 00 00 00 00 00  // ................


Thanks,
Mauro

