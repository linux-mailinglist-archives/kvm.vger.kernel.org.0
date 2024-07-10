Return-Path: <kvm+bounces-21261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B662492C9EC
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 06:38:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D98901C22F83
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 04:38:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27B304A9B0;
	Wed, 10 Jul 2024 04:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DfYB1hbd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEA31EEF8
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 04:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720586166; cv=none; b=lT4yKRPIscXvNNYFUKs9iVUxGjFew9PWtBJCFYUYb+BmqZe37ZPcy5IJGzoJ7pwrMlx0GrFEIDqDyvf9deIcc6tDIC1DFYxavR/bCGPvyoW+NelsT/djPXjpfyNjnTy3BHZSzaAFOrqlVEDe7x2Fp/saOZuDowKCp0cw6y5h/ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720586166; c=relaxed/simple;
	bh=PibKnXq9Pq/c31n0bxDbMaIs/xxPngjdmk6sa7uOb+M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=r0V3EnfYPxT7bOz/88f5TGrqaflYnmuxg2xjJlFwPdL2Mg+2UMyQUcveEM9Pbyfk4SDPBlTg3Gplzwlppol1f18TLlpL8YfIsuGps6+pzJ6dk4ggpGaVZjvuiM9L2Z0qr+7w4xo/mSYtDmJcnRRkLQ1XmBp0V05nNCftQL9f5hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DfYB1hbd; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720586163; x=1752122163;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=PibKnXq9Pq/c31n0bxDbMaIs/xxPngjdmk6sa7uOb+M=;
  b=DfYB1hbde4ybKT5l+NiedmZdoPNNgTonX3LOz61tddC9ra5F/3dIRlCO
   cnI3WB5MPoZ2G0oYX8Ln3GZDj3yZ8610bYdCzAFA+D8sZhU+Mk4ra23sV
   CQ/zVMl8GXaQbLW0fZj2GEj67vj7Xi/NdOTanIy4kl9t79rNXUKCdHRC5
   DWNzjrWD9ykaHux1xOlwJ2gXTsrXnc5O6cY6U/rxC7iYyTu+X8l7OgkDu
   JJ92o5cmXKRfV26QSk94mDKkLSNTFdM06kA6DGvSHWEjjUqBJOcfzWMYc
   zOrQaidiKHWgiknNBmbMy3BEyUlled5PUUIlQulh0uStBpCbCLYYr95e9
   g==;
X-CSE-ConnectionGUID: XjnfS59ZTBmsik6uyJorwg==
X-CSE-MsgGUID: QBrvT76/TvSXVucCD9xjoQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11128"; a="28473749"
X-IronPort-AV: E=Sophos;i="6.09,197,1716274800"; 
   d="scan'208";a="28473749"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2024 21:35:56 -0700
X-CSE-ConnectionGUID: xL+EWwXbRIeKbL4iBoT2oQ==
X-CSE-MsgGUID: SL/LYDmCRTOQF7RGGpwW5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,197,1716274800"; 
   d="scan'208";a="79238097"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa001.fm.intel.com with ESMTP; 09 Jul 2024 21:35:51 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eauger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Sebastian Ott <sebott@redhat.com>,
	Gavin Shan <gshan@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Yuan Yao <yuan.yao@intel.com>,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Mingwei Zhang <mizhang@google.com>,
	Jim Mattson <jmattson@google.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC 0/5] accel/kvm: Support KVM PMU filter
Date: Wed, 10 Jul 2024 12:51:12 +0800
Message-Id: <20240710045117.3164577-1-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi QEMU maintainers, arm and PMU folks,

I picked up Shaoqing's previous work [1] on the KVM PMU filter for arm,
and now is trying to support this feature for x86 with a JSON-compatible
API.

While arm and x86 use different KVM ioctls to configure the PMU filter,
considering they all have similar inputs (PMU event + action), it is
still possible to abstract a generic, cross-architecture kvm-pmu-filter
object and provide users with a sufficiently generic or near-consistent
QAPI interface.

That's what I did in this series, a new kvm-pmu-filter object, with the
API like:

-object '{"qom-type":"kvm-pmu-filter","id":"f0","events":[{"action":"allow","format":"raw","code":"0xc4"}]}'

For i386, this object is inserted into kvm accelerator and is extended
to support fixed-counter and more formats ("x86-default" and
"x86-masked-entry"):

-accel kvm,pmu-filter=f0 \
-object pmu='{"qom-type":"kvm-pmu-filter","id":"f0","x86-fixed-counter":{"action":"allow","bitmap":"0x0"},"events":[{"action":"allow","format":"x86-masked-entry","select":"0xc4","mask":"0xff","match":"0","exclude":true},{"action":"allow","format":"x86-masked-entry","select":"0xc5","mask":"0xff","match":"0","exclude":true}]}'

This object can still be added as the property to the arch CPU if it is
desired as a per CPU feature (as Shaoqin did for arm before).

Welcome your feedback and comments!


Introduction
============


Formats supported in kvm-pmu-filter
-----------------------------------

This series supports 3 formats:

* raw format (general format).

  This format indicates the code that has been encoded to be able to
  index the PMU events, and which can be delivered directly to the KVM
  ioctl. For arm, this means the event code, and for i386, this means
  the raw event with the layout like:

      select high bit | umask | select low bits

* x86-default format (i386 specific)

  x86 commonly uses select&umask to identify PMU events, and this format
  is used to support the select&umask. Then QEMU will encode select and
  umask into a raw format code.

* x86-masked-entry (i386 specific)

  This is a special format that x86's KVM_SET_PMU_EVENT_FILTER supports.


Hexadecimal value string
------------------------

In practice, the values associated with PMU events (code for arm, select&
umask for x86) are often expressed in hexadecimal. Further, from linux
perf related information (tools/perf/pmu-events/arch/*/*/*.json), x86/
arm64/riscv/nds32/powerpc all prefer the hexadecimal numbers and only
s390 uses decimal value.

Therefore, it is necessary to support hexadecimal in order to honor PMU
conventions.

However, unfortunately, standard JSON (RFC 8259) does not support
hexadecimal numbers. So I can only consider using the numeric string in
the QAPI and then parsing it to a number.

To achieve this, I defined two versions of PMU-related structures in
kvm.json:
 * a native version that accepts numeric values, which is used for
   QEMU's internal code processing,

 * and a variant version that accepts numeric string, which is used to
   receive user input.

kvm-pmu-filter object will take care of converting the string version
of the event/counter information into the numeric version.

The related implementation can be found in patch 1.


CPU property v.s. KVM property
------------------------------

In Shaoqin's previous implementation [1], KVM PMU filter is made as a
arm CPU property. This is because arm uses a per CPU ioctl
(KVM_SET_DEVICE_ATTR) to configure KVM PMU filter.

However, for x86, the dependent ioctl (KVM_SET_PMU_EVENT_FILTER) is per
VM. In the meantime, considering that for hybrid architecture, maybe in
the future there will be a new per vCPU ioctl, or there will be
practices to support filter fixed counter by configuring CPUIDs.

Based on the above thoughts, for x86, it is not appropriate to make the
current per-VM ioctl-based PMU filter a CPU property. Instead, I make it
a kvm property and configure it via "-accel kvm,pmu-filter=obj_id".

So in summary, it is feasible to use the KVM PMU filter as either a CPU
or a KVM property, depending on whether it is used as a CPU feature or a
VM feature.

The kvm-pmu-filter object, as an abstraction, is general enough to
support filter configurations for different scopes (per-CPU or per-VM).


[1]: https://lore.kernel.org/qemu-devel/20240409024940.180107-1-shahuang@redhat.com/

Thanks and Best Regards,
Zhao
---
Zhao Liu (5):
  qapi/qom: Introduce kvm-pmu-filter object
  i386/kvm: Support initial KVM PMU filter
  i386/kvm: Support event with select&umask format in KVM PMU filter
  i386/kvm: Support event with masked entry format in KVM PMU filter
  i386/kvm: Support fixed counter in KVM PMU filter

 MAINTAINERS                |   1 +
 accel/kvm/kvm-pmu.c        | 367 +++++++++++++++++++++++++++++++++++++
 accel/kvm/meson.build      |   1 +
 include/sysemu/kvm-pmu.h   |  43 +++++
 include/sysemu/kvm_int.h   |   2 +
 qapi/kvm.json              | 255 ++++++++++++++++++++++++++
 qapi/meson.build           |   1 +
 qapi/qapi-schema.json      |   1 +
 qapi/qom.json              |   3 +
 target/i386/kvm/kvm.c      | 211 +++++++++++++++++++++
 target/i386/kvm/kvm_i386.h |   1 +
 11 files changed, 886 insertions(+)
 create mode 100644 accel/kvm/kvm-pmu.c
 create mode 100644 include/sysemu/kvm-pmu.h
 create mode 100644 qapi/kvm.json

-- 
2.34.1


