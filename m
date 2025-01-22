Return-Path: <kvm+bounces-36227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 454A6A18DB8
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 09:46:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A0CC3ABB59
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 08:46:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B927E1F76C7;
	Wed, 22 Jan 2025 08:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IZw4rDa/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371641C3C0B
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 08:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737535569; cv=none; b=l3E84KB7Dtd2S92vbs6ZplxC/1SLYQ5hXwcMfqhs85Tir2mCW8vb7NO3JPAq3kCydivbfV1iRuc78HPRiK7/Jq1+S/8lq5bAbC2NA1GxwSYd9BH1z72xvaKjAzB3lJeqBxdbc9rKbo/MBfvDSVwVNKXgfWYZ4Rlt5DmP6IUEvnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737535569; c=relaxed/simple;
	bh=/qineeskdRgbE6vyAA/6OrXfiv6ADTg5jvwZfxbwbN8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DqG73xsbxrx/z3zEEKbnM8ttmP0TfaG/UtFO8CmssIv3urbz8OonBDT69NrFi04ZiLc9+K89QHIXCweHBT6rC9eL9qbAD4xDeO2B0CE4JVLAu7SMJFznr1A1Y+06mi1md7sriTXAcAy5gFNqHudpL+SiM+Lrqzt7sou2yXjuqWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IZw4rDa/; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737535568; x=1769071568;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/qineeskdRgbE6vyAA/6OrXfiv6ADTg5jvwZfxbwbN8=;
  b=IZw4rDa/EIA/MU0Y35Ahjwekkqc/XyHtXPwCwR+e/zcxGlS2ej0hXs8O
   UK0++34qNp4aejxPymHgJ9CA9rkzo4q3ygCR3G9T8c2/l2ykso+2n2kEd
   tqxl7f9WtwI72EgP19CvRi6ITG1JJpZY8BWEMzoJJohaqDG6KuUqEmhJv
   WU/dZiyC715qIwliQngnFc/+LBJjhOksYgTsSpvu5Uvk9QLyJnEP72eEQ
   xALYrt4rgTxVgdaxqaYuiKXicxT9ZbTJU1HdoicHbdM/Hd5FoyrCIQJ6m
   aO4WQJBgr/Rn2mPQqfmLok/Il0NgjbXVa/34EzfM4W3kTsL29barSq+Jr
   w==;
X-CSE-ConnectionGUID: qFQt3bmXRZeoAByPGNAMzQ==
X-CSE-MsgGUID: o+wnthEESmWjnjo0oKj7eQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11322"; a="60451536"
X-IronPort-AV: E=Sophos;i="6.13,224,1732608000"; 
   d="scan'208";a="60451536"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2025 00:46:07 -0800
X-CSE-ConnectionGUID: jZTTLQ1qSGSsEYjLO0x7Lw==
X-CSE-MsgGUID: S3odIcLiQFWXMDZ8Y+AHMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="112049608"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 22 Jan 2025 00:46:03 -0800
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
	Dapeng Mi <dapeng1.mi@intel.com>,
	Yi Lai <yi1.lai@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC v2 0/5] accel/kvm: Support KVM PMU filter
Date: Wed, 22 Jan 2025 17:05:12 +0800
Message-Id: <20250122090517.294083-1-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

Sorry for the long wait, but RFC v2 is here at last.

Compared with v1 [1], v2 mianly makes `action` as a global parameter,
and all events (and fixed counters) are based on a unified action.

Learned from the discussion with Shaoqin in v1, current pmu-filter QOM
design could meet the requirements from the ARM KVM side.


Background
==========

I picked up Shaoqing's previous work [2] on the KVM PMU filter for arm,
and now is trying to support this feature for x86 with a JSON-compatible
API.

While arm and x86 use different KVM ioctls to configure the PMU filter,
considering they all have similar inputs (PMU event + action), it is
still possible to abstract a generic, cross-architecture kvm-pmu-filter
object and provide users with a sufficiently generic or near-consistent
QAPI interface.

That's what I did in this series, a new kvm-pmu-filter object, with the
API like:

-object '{"qom-type":"kvm-pmu-filter","id":"f0","action":"allow","events":[{"format":"raw","code":"0xc4"}]}'

For i386, this object is inserted into kvm accelerator and is extended
to support fixed-counter and more formats ("x86-default" and
"x86-masked-entry"):

-accel kvm,pmu-filter=f0 \
-object pmu='{"qom-type":"kvm-pmu-filter","id":"f0","action":"allow","x86-fixed-counter":{"bitmap":"0x0"},"events":[{"format":"x86-masked-entry","select":"0xc4","mask":"0xff","match":"0","exclude":true},{"format":"x86-masked-entry","select":"0xc5","mask":"0xff","match":"0","exclude":true}]}'

This object can still be added as the property to the arch CPU if it is
desired as a per CPU feature (as Shaoqin did for arm before).


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

In Shaoqin's previous implementation [2], KVM PMU filter is made as a
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

[1]: https://lore.kernel.org/qemu-devel/20240710045117.3164577-1-zhao1.liu@intel.com/
[2]: https://lore.kernel.org/qemu-devel/20240409024940.180107-1-shahuang@redhat.com/

Thanks and Best Regards,
Zhao
---
Zhao Liu (5):
  qapi/qom: Introduce kvm-pmu-filter object
  i386/kvm: Support basic KVM PMU filter
  i386/kvm: Support event with select & umask format in KVM PMU filter
  i386/kvm: Support event with masked entry format in KVM PMU filter
  i386/kvm: Support fixed counter in KVM PMU filter

 MAINTAINERS              |   1 +
 accel/kvm/kvm-pmu.c      | 386 +++++++++++++++++++++++++++++++++++++++
 accel/kvm/meson.build    |   1 +
 include/system/kvm-pmu.h |  44 +++++
 include/system/kvm_int.h |   2 +
 qapi/kvm.json            | 246 +++++++++++++++++++++++++
 qapi/meson.build         |   1 +
 qapi/qapi-schema.json    |   1 +
 qapi/qom.json            |   3 +
 target/i386/kvm/kvm.c    | 176 ++++++++++++++++++
 10 files changed, 861 insertions(+)
 create mode 100644 accel/kvm/kvm-pmu.c
 create mode 100644 include/system/kvm-pmu.h
 create mode 100644 qapi/kvm.json

-- 
2.34.1


