Return-Path: <kvm+bounces-42993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 16DA7A81F62
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 10:10:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 50EB31896B20
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 08:06:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 194C525B664;
	Wed,  9 Apr 2025 08:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mV/sktkS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D66425C6E0
	for <kvm@vger.kernel.org>; Wed,  9 Apr 2025 08:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185977; cv=none; b=qT2nto2tMLVExlhMF01NNxW1qlJ5qSw4qEJvzEdFp0wvtCqDI9hAxFQnM61FmCWouZfT/m9ZCU3w5Qe5lJj1/618yYfb5kDuv4N6mnfWq/9CaqXUJFrCTMnBI05KMFrDyemHlc1WOOMFF1AVHmuN5txlMHFOoaPlQzEqIEI3Z8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185977; c=relaxed/simple;
	bh=I2s1W4IyDTQ8AYD3sBlVOogfmldQt5VB0rUpFb6frYw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=X0J+qKICCcNwUPJ/bewt5q34c8zdLiAKZPY5KJZX0OtqEMlbfSHSyaCYxxkj/Jcxx0dfmmwkeutDntjHfZU1GGY5xZa/bhnIcJufQWo/dAAevvU+nLJmpwYhIVtWK1LcGxTmDqExYCaZ1ORs3VpUFZLK0xxsp9Zw/7GCkANcX0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mV/sktkS; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744185975; x=1775721975;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=I2s1W4IyDTQ8AYD3sBlVOogfmldQt5VB0rUpFb6frYw=;
  b=mV/sktkSH60UxWtytQcI7tTRuE3Pkgq1uRpUI4E4ok1M7TyqJOQAX2R4
   NmnPHJ/Y6lGpnxPQ72Q5XhWuad/dA56MYrmuhTwWqqNLmF5GEta1yiNOJ
   YgROvNBea7MyUcuihTo40uDufZ8rEHE4cy+ezPGHUqCSGzQ2QfgsxYLFA
   eCzQ30Ld/8Rl++ZxRYKJyBfM+cKfkg2J5N44URH3gbshekwNTqiWgLptj
   uPN6RkfKFBcXfz/F6jkBCcxOJ2CfcLUidm9ask1nvDoVbQaD6CxMn4MCV
   ZYA32APZNmSgvJSJbmmAv42nH0LsJCviJxni7yoEDSJGHYh+YYVnO7VWF
   g==;
X-CSE-ConnectionGUID: SdydU3OeTJWcx4ohpP5wGw==
X-CSE-MsgGUID: RSeqL5miRYCXpYKEwCoScA==
X-IronPort-AV: E=McAfee;i="6700,10204,11397"; a="45809983"
X-IronPort-AV: E=Sophos;i="6.15,200,1739865600"; 
   d="scan'208";a="45809983"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 01:06:14 -0700
X-CSE-ConnectionGUID: fcVndc10Sea4PGTEMbFGbA==
X-CSE-MsgGUID: UhlfyyvqR0q34BJ/C4NDWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,200,1739865600"; 
   d="scan'208";a="151702575"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa002.fm.intel.com with ESMTP; 09 Apr 2025 01:06:07 -0700
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
Subject: [PATCH 0/5] accel/kvm: Support KVM PMU filter
Date: Wed,  9 Apr 2025 16:26:44 +0800
Message-Id: <20250409082649.14733-1-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

Now I've converted the previous RFC (v2) to PATCH.

Compared with RFC v2 [1], this version mianly have the following
changes:
 * Make PMU related QAPIs accept decimal value instead of string.
 * Introduce a three-level QAPI section to organize KVM PMU stuff.
 * Fix QAPI related style issues.
 * Rename "x86-default" format to "x86-select-umask".

Current pmu-filter QOM design could meet the requirements of both x86
and ARM sides.


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

-object '{"qom-type":"kvm-pmu-filter","id":"f0","action":"allow","events":[{"format":"raw","code":196}]}'

For x86, this object is inserted into kvm accelerator and is extended
to support fixed-counter and more formats ("x86-default" and
"x86-masked-entry"):

-accel kvm,pmu-filter=f0 \
-object '{"qom-type":"kvm-pmu-filter","id":"f0","action":"allow","x86-fixed-counter":0,"events":[{"format":"x86-masked-entry","select":196,"mask":255,"match":0,"exclude":true},{"format":"x86-masked-entry","select":197,"mask":255,"match":0,"exclude":true}]}'

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

* x86-select-umask format (i386 specific)

  x86 commonly uses select&umask to identify PMU events, and this format
  is used to support the select&umask. Then QEMU will encode select and
  umask into a raw format code.

* x86-masked-entry (i386 specific)

  This is a special format that x86's KVM_SET_PMU_EVENT_FILTER supports.


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

[1]: https://lore.kernel.org/qemu-devel/20250122090517.294083-1-zhao1.liu@intel.com/
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

 MAINTAINERS              |   2 +
 accel/kvm/kvm-pmu.c      | 177 +++++++++++++++++++++++++++++++++++++++
 accel/kvm/meson.build    |   1 +
 include/system/kvm-pmu.h |  51 +++++++++++
 include/system/kvm_int.h |   2 +
 qapi/accelerator.json    |  14 ++++
 qapi/kvm.json            | 130 ++++++++++++++++++++++++++++
 qapi/meson.build         |   1 +
 qapi/qapi-schema.json    |   1 +
 qapi/qom.json            |   3 +
 qemu-options.hx          |  67 ++++++++++++++-
 target/i386/kvm/kvm.c    | 176 ++++++++++++++++++++++++++++++++++++++
 12 files changed, 624 insertions(+), 1 deletion(-)
 create mode 100644 accel/kvm/kvm-pmu.c
 create mode 100644 include/system/kvm-pmu.h
 create mode 100644 qapi/accelerator.json
 create mode 100644 qapi/kvm.json

-- 
2.34.1


