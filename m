Return-Path: <kvm+bounces-35015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F67FA08C11
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 10:32:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 96868188DF2C
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 09:31:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76E6620ADD1;
	Fri, 10 Jan 2025 09:29:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5D7209F40
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 09:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736501378; cv=none; b=jUUkk5CQWd4rMjIctm6EPeVvvX86xRC2Nqk8AFnsUs+Fw2OuSKLpJLuITBAKT7KlavURJQ7NNJwhrdbGiTsTH8krgQDuucbFpLcol+B7vz0vizXrB0d4Vr5BHt53qaBJeKe0AcjtJLqltGk9K6iBG8P0MPNHcRbnfnTChszB+Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736501378; c=relaxed/simple;
	bh=yKfXgBYLq3c6h7aD3iGhnwjwCaxsEDwFUDLMv/FHQmg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fIO0iPmk3okNGLPnnjBLKWzbHNBshC7oxqJpljI/OoEHL9uYK0ChXN38Bm2IHStpPSz2BXMKwB7RQp0qcDezgBY0LugUqSe+ItPfpujYPzQmFWwbYO5gBD8COvt5aD+Ez/4TflrLyn5KnxAzUSnfTd1hW1MMEQ504Q0Y5phRwws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4YTx7m0Fb5z6K5VJ;
	Fri, 10 Jan 2025 17:24:52 +0800 (CST)
Received: from frapeml500006.china.huawei.com (unknown [7.182.85.219])
	by mail.maildlp.com (Postfix) with ESMTPS id A9E7B1408F9;
	Fri, 10 Jan 2025 17:29:32 +0800 (CST)
Received: from frapeml500003.china.huawei.com (7.182.85.28) by
 frapeml500006.china.huawei.com (7.182.85.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 10 Jan 2025 10:29:32 +0100
Received: from frapeml500003.china.huawei.com ([7.182.85.28]) by
 frapeml500003.china.huawei.com ([7.182.85.28]) with mapi id 15.01.2507.039;
 Fri, 10 Jan 2025 10:29:32 +0100
From: Alireza Sanaee <alireza.sanaee@huawei.com>
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
	=?iso-8859-1?Q?Philippe_Mathieu-Daud=E9?= <philmd@linaro.org>,
	=?iso-8859-1?Q?Daniel_P_=2E_Berrang=E9?= <berrange@redhat.com>, "Markus
 Armbruster" <armbru@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>, Richard Henderson
	<richard.henderson@linaro.org>, Eduardo Habkost <eduardo@habkost.net>,
	"Marcel Apfelbaum" <marcel.apfelbaum@gmail.com>, "wangyanan (Y)"
	<wangyanan55@huawei.com>, Jonathan Cameron <jonathan.cameron@huawei.com>,
	"Sia Jee Heng" <jeeheng.sia@starfivetech.com>
CC: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
Subject: RE: [PATCH v7 0/5] i386: Support SMP Cache Topology
Thread-Topic: [PATCH v7 0/5] i386: Support SMP Cache Topology
Thread-Index: AQHbYdutebewzlBbOU2Mh++jRDy+5rMPvXWQ
Date: Fri, 10 Jan 2025 09:29:32 +0000
Message-ID: <7ae0450f39d9446f9696531cd076b37e@huawei.com>
References: <20250108150150.1258529-1-zhao1.liu@intel.com>
In-Reply-To: <20250108150150.1258529-1-zhao1.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi Zhao,

Thanks for this quick reiteration.=20

I will prepare the ARM one too. I implemented the ACPI PPTT table to suppor=
t thread but later when I worked on device tree noticed the mismatch. Will =
remove those PPTT thread support for now.

Alireza

-----Original Message-----
From: Zhao Liu <zhao1.liu@intel.com>=20
Sent: Wednesday, January 8, 2025 3:02 PM
To: Paolo Bonzini <pbonzini@redhat.com>; Philippe Mathieu-Daud=E9 <philmd@l=
inaro.org>; Daniel P . Berrang=E9 <berrange@redhat.com>; Markus Armbruster =
<armbru@redhat.com>; Igor Mammedov <imammedo@redhat.com>; Michael S . Tsirk=
in <mst@redhat.com>; Richard Henderson <richard.henderson@linaro.org>; Edua=
rdo Habkost <eduardo@habkost.net>; Marcel Apfelbaum <marcel.apfelbaum@gmail=
.com>; wangyanan (Y) <wangyanan55@huawei.com>; Jonathan Cameron <jonathan.c=
ameron@huawei.com>; Alireza Sanaee <alireza.sanaee@huawei.com>; Sia Jee Hen=
g <jeeheng.sia@starfivetech.com>
Cc: qemu-devel@nongnu.org; kvm@vger.kernel.org; Zhao Liu <zhao1.liu@intel.c=
om>
Subject: [PATCH v7 0/5] i386: Support SMP Cache Topology

Hi folks,

This is my v7.

Compared with v6 [1], v7 dropped the "thread" level cache topology (cache p=
er thread):

 - Patch 1 is the new patch to reject "thread" parameter for smp-cache.
 - Ptach 2 dropped cache per thread support.
 (Others remain unchanged.)

There're several reasons:

 * Currently, neither i386 nor ARM have real hardware support for per-
   thread cache.
 * Supporting this special cache topology on ARM requires extra effort
   [2].

So it is unnecessary to support it at this moment, even though per- thread =
cache might have potential scheduling benefits for VMs without CPU affinity=
.

In the future, if there is a clear demand for this feature, the correct app=
roach would be to add a new control field in MachineClass.smp_props and ena=
ble it only for the machines that require it.


This series is based on the master branch at commit aa3a285b5bc5 ("Merge ta=
g 'mem-2024-12-21' of https://github.com/davidhildenbrand/qemu into staging=
").

Smp-cache support of ARM side can be found at [3].


Background
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

The x86 and ARM (RISCV) need to allow user to configure cache properties (c=
urrent only topology):
 * For x86, the default cache topology model (of max/host CPU) does not
   always match the Host's real physical cache topology. Performance can
   increase when the configured virtual topology is closer to the
   physical topology than a default topology would be.
 * For ARM, QEMU can't get the cache topology information from the CPU
   registers, then user configuration is necessary. Additionally, the
   cache information is also needed for MPAM emulation (for TCG) to
   build the right PPTT. (Originally from Jonathan)


About smp-cache
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

The API design has been discussed heavily in [4].

Now, smp-cache is implemented as a array integrated in -machine. Though -ma=
chine currently can't support JSON format, this is the one of the direction=
s of future.

An example is as follows:

smp_cache=3Dsmp-cache.0.cache=3Dl1i,smp-cache.0.topology=3Dcore,smp-cache.1=
.cache=3Dl1d,smp-cache.1.topology=3Dcore,smp-cache.2.cache=3Dl2,smp-cache.2=
.topology=3Dmodule,smp-cache.3.cache=3Dl3,smp-cache.3.topology=3Ddie

"cache" specifies the cache that the properties will be applied on. This fi=
eld is the combination of cache level and cache type. Now it supports "l1d"=
 (L1 data cache), "l1i" (L1 instruction cache), "l2" (L2 unified
cache) and "l3" (L3 unified cache).

"topology" field accepts CPU topology levels including "core", "module", "c=
luster", "die", "socket", "book", "drawer" and a special value "default". (=
Note, now, in v7, smp-cache doesn't support "thread".)

The "default" is introduced to make it easier for libvirt to set a default =
parameter value without having to care about the specific machine (because =
currently there is no proper way for machine to expose supported topology l=
evels and caches).

If "default" is set, then the cache topology will follow the architecture's=
 default cache topology model. If other CPU topology level is set, the cach=
e will be shared at corresponding CPU topology level.


[1]: Patch v6: https://lore.kernel.org/qemu-devel/20241219083237.265419-1-z=
hao1.liu@intel.com/
[2]: Gap of cache per thread for ARM: https://lore.kernel.org/qemu-devel/Z3=
efFsigJ6SxhqMf@intel.com/#t
[3]: ARM smp-cache: https://lore.kernel.org/qemu-devel/20250102152012.1049-=
1-alireza.sanaee@huawei.com/
[4]: API disscussion: https://lore.kernel.org/qemu-devel/8734ndj33j.fsf@pon=
d.sub.org/

Thanks and Best Regards,
Zhao
---
Alireza Sanaee (1):
  i386/cpu: add has_caches flag to check smp_cache configuration

Zhao Liu (4):
  hw/core/machine: Reject thread level cache
  i386/cpu: Support module level cache topology
  i386/cpu: Update cache topology with machine's configuration
  i386/pc: Support cache topology in -machine for PC machine

 hw/core/machine-smp.c |  9 ++++++
 hw/i386/pc.c          |  4 +++
 include/hw/boards.h   |  3 ++
 qemu-options.hx       | 30 +++++++++++++++++-
 target/i386/cpu.c     | 71 ++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 115 insertions(+), 2 deletions(-)

--
2.34.1



