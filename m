Return-Path: <kvm+bounces-20925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79440926DBC
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 05:00:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FDBE28284F
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 03:00:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F39117BAB;
	Thu,  4 Jul 2024 03:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nJRotp2q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B0B12B73
	for <kvm@vger.kernel.org>; Thu,  4 Jul 2024 03:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720062035; cv=none; b=ePZ75jpjNIagy8fQyTWwsUJVj41hIJjgXAwjHf64y9+5fOt4nVTx2XTmI4xxqPKCC3XmWsP/qysGlumgQ6VizvLjofwrh4XmydD88GNXJIpigWSNLskckru9+QiPp5z7n0y9kOXJJYVTN2mDYUTZ8JK5bC96X1eg+nNVpnwFwnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720062035; c=relaxed/simple;
	bh=KBoR7Jmf7Pr5F6X5IGhcrEKtNKryr9HfJ/qoLYd34tM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Sdf4E5oLm4v26gb7DmW7VBoKKcJ+W0DCMY+cdkTCgwHnlFjKVaZSCfbPPS1s+0Wiqu7dR3obTPZexpim21R6DpkrjSi5orRd1O/mb6luOWpuOarC6Bc10q4UDTrPc3svrd80RDp9S5WMH2fDYHdf93XF/8ZkTfiIM7WibD56JAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nJRotp2q; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720062034; x=1751598034;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KBoR7Jmf7Pr5F6X5IGhcrEKtNKryr9HfJ/qoLYd34tM=;
  b=nJRotp2qgGqO46dqhdpl4vEXBhAQDVIHyehyxSbvWqlIaSGOKwc0hzZA
   RrUq6FJXo96Gi6ZwjSOvcZktnhp/0Xx7qEdX70OgF2sD1lBEa5l8Ge6XN
   YfI5g+Tny+sC7SP+UrkUPoO4+IrPbzCXPgGwmgUX6agPinxXOp13deo99
   /ySl9u5Di50XIEDeKm+g8gF3jb2LBy73UBGnHR0RuFlh6v7TtSXYrfZLd
   jkoRHBXaiFwCoH3GMqxABp5gXNcOqvQDK2sNhqOLbwreB7Vo+jS1p6tj7
   UlJ3m9EtIWzdRgQHb6oqNvxKzl4zDOJu+8YHFf+73DhGXJ64rTF/gyaaf
   Q==;
X-CSE-ConnectionGUID: DQTYMVTyRfqvxCjTGbUIxg==
X-CSE-MsgGUID: D9r/XMmbQ1+4huZij2Hlxw==
X-IronPort-AV: E=McAfee;i="6700,10204,11122"; a="39838047"
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="39838047"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2024 20:00:33 -0700
X-CSE-ConnectionGUID: dGDY2TfnTCKtQ4Qs7N3qfQ==
X-CSE-MsgGUID: R7lm3lAoSgCI7aZI4Ltnlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="51052086"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa004.fm.intel.com with ESMTP; 03 Jul 2024 20:00:27 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH 0/8] Introduce SMP Cache Topology
Date: Thu,  4 Jul 2024 11:15:55 +0800
Message-Id: <20240704031603.1744546-1-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

Since the previous RFC v2, I've reimplemented smp-cache object based on
Daniel's comment (thanks Daniel!), which is both flexible to support
current cache topology requirements and extensible.

So, I officially convert the RFC to PATCH.

Background on smp cache topology can be found in the previous RFC v2
cover letter:

https://lore.kernel.org/qemu-devel/20240530101539.768484-1-zhao1.liu@intel.com/

The following content focuses on this series implementation of the
smp-cache object.


About smp-cache
===============

In fact, the smp-cache object introduced in this series is a bit
different from Daniel's original suggestion. Instead of being integrated
into -smp, it is created explicitly via -object, and the smp-cache
property is added to -machine to link to this object.

An example is as follows:

-object '{"qom-type":"smp-cache","id":"cache0","caches":[{"name":"l1d","topo":"core"},{"name":"l1i","topo":"core"},{"name":"l2","topo":"module"},{"name":"l3","topo":"socket"}]}'
-machine smp-cache=cache0


Such the design change is based on the following 2 reasons:
 * Defining the cache with a JSON list is very extensible and can
   support more cache properties.

 * But -smp, as the sugar of machine property "smp", is based on keyval
   format, and doesn't support options with JSON format. Thus it's not
   possible to add a JSON format based option to -smp/-machine for now.

So, I decoupled the creation of the smp-cache object from the -machine
to make both -machine and -object happy!


Welcome your feedback!


Thanks and Best Regards,
Zhao
---
Changelog:

Main changes since RFC v2:
 * Dropped cpu-topology.h and cpu-topology.c since QAPI has the helper
   (CpuTopologyLevel_str) to convert enum to string. (Markus)
 * Fixed text format in machine.json (CpuTopologyLevel naming, 2 spaces
   between sentences). (Markus)
 * Added a new level "default" to de-compatibilize some arch-specific
   topo settings. (Daniel)
 * Moved CpuTopologyLevel to qapi/machine-common.json, at where the
   cache enumeration and smp-cache object would be added.
   - If smp-cache object is defined in qapi/machine.json, storage-daemon
     will complain about the qmp cmds in qapi/machine.json during
     compiling.
 * Referred to Daniel's suggestion to introduce cache JSON list, though
   as a standalone object since -smp/-machine can't support JSON.
 * Linked machine's smp_cache to smp-cache object instead of a builtin
   structure. This is to get around the fact that the keyval format of
   -machine can't support JSON.
 * Wrapped the cache topology level access into a helper.
 * Split as a separate commit to just include compatibility checking and
   topology checking.
 * Allow setting "default" topology level even though the cache
   isn't supported by machine. (Daniel)
 * Rewrote the document of smp-cache object.

Main changes since RFC v1:
 * Split CpuTopology renaimg out of this RFC.
 * Use QAPI to enumerate CPU topology levels.
 * Drop string_to_cpu_topo() since QAPI will help to parse the topo
   levels.
 * Set has_*_cache field in machine_get_smp(). (JeeHeng)
 * Use "*_cache=topo_level" as -smp example as the original "level"
   term for a cache has a totally different meaning. (Jonathan)
---
Zhao Liu (8):
  hw/core: Make CPU topology enumeration arch-agnostic
  qapi/qom: Introduce smp-cache object
  hw/core: Add smp cache topology for machine
  hw/core: Check smp cache topology support for machine
  i386/cpu: Support thread and module level cache topology
  i386/cpu: Update cache topology with machine's configuration
  i386/pc: Support cache topology in -machine for PC machine
  qemu-options: Add the description of smp-cache object

 MAINTAINERS                 |   2 +
 hw/core/machine-smp.c       |  86 ++++++++++++++++++++++++++++++
 hw/core/machine.c           |  22 ++++++++
 hw/core/meson.build         |   1 +
 hw/core/smp-cache.c         | 103 ++++++++++++++++++++++++++++++++++++
 hw/i386/pc.c                |   4 ++
 include/hw/boards.h         |  11 +++-
 include/hw/core/smp-cache.h |  27 ++++++++++
 include/hw/i386/topology.h  |  18 +------
 qapi/machine-common.json    |  97 ++++++++++++++++++++++++++++++++-
 qapi/qapi-schema.json       |   4 +-
 qapi/qom.json               |   3 ++
 qemu-options.hx             |  58 ++++++++++++++++++++
 target/i386/cpu.c           |  83 +++++++++++++++++++++--------
 target/i386/cpu.h           |   4 +-
 15 files changed, 478 insertions(+), 45 deletions(-)
 create mode 100644 hw/core/smp-cache.c
 create mode 100644 include/hw/core/smp-cache.h

-- 
2.34.1


