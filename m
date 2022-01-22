Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B13C496B07
	for <lists+kvm@lfdr.de>; Sat, 22 Jan 2022 09:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233677AbiAVIhs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Jan 2022 03:37:48 -0500
Received: from mga06.intel.com ([134.134.136.31]:1159 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230015AbiAVIhr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Jan 2022 03:37:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642840667; x=1674376667;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+EvRpqARg086TBgvq2dE04fcyG0zdE9UY5zo/dAjX6Y=;
  b=kAYmqTY9brvz5bukgbRaxOD3a2Pv1DHE6nOzRtE7qpUscxRsGnmEsyNE
   0NvynWMp5tiV9q2rZUZnQ0WHkQA7O3I6EIXulc6Q+QBJRwBWqe6st0zsK
   wuGk5freVXAMTE4EPYWlTSUWH0FdAvE0XQXpQzV/IlBEu0O+3Vu+XnkR3
   RNsZI273UzzLZwTK0wBFP7y3NdiNTrRq84Lth0NN9pcxvgkzm7jcd62m8
   YW/wjsliHJvTRgf5anXmFe3A0rLg6qjkrZOB8RWp35AIR9UNVXvKzFzoz
   7jBVltpxIteyD29ivO497HNf2VYtsjHXkQbLcGTONGz3qbG1ks7soLjb3
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10234"; a="306524166"
X-IronPort-AV: E=Sophos;i="5.88,307,1635231600"; 
   d="scan'208";a="306524166"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2022 00:37:44 -0800
X-IronPort-AV: E=Sophos;i="5.88,307,1635231600"; 
   d="scan'208";a="765937357"
Received: from sqa-gate.sh.intel.com (HELO michael.clx.dev.tsp.org) ([10.239.48.212])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2022 00:37:41 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, ehabkost@redhat.com, mtosatti@redhat.com,
        richard.henderson@linaro.org, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, likexu@tencent.com, wei.w.wang@intel.com
Cc:     weijiang.yang@intel.com
Subject: [PATCH v5 0/2] Enable legacy LBR support for guest
Date:   Sun, 23 Jan 2022 00:11:59 +0800
Message-Id: <20220122161201.73528-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM legacy LBR patches have been merged in kernel 5.12, this patchset
is to expose the feature to guest from the perf capability MSR. Qemu can
add LBR format in cpu option to achieve it, e.g., -cpu host,lbr-fmt=0x5,
the format should match host value in IA32_PERF_CAPABILITIES.

Note, KVM legacy LBR solution accelerates guest perf performace by LBR MSR
passthrough so it requires guest cpu model matches that of host's, i.e.,
only -cpu host is supported.

Change in v5:
	1. This patchset is rebased on tip : 6621441db5
	2. No functional change since v4.


Yang Weijiang (2):
  qdev-properties: Add a new macro with bitmask check for uint64_t
    property
  target/i386: Add lbr-fmt vPMU option to support guest LBR

 hw/core/qdev-properties.c    | 19 +++++++++++++++++
 include/hw/qdev-properties.h | 12 +++++++++++
 target/i386/cpu.c            | 40 ++++++++++++++++++++++++++++++++++++
 target/i386/cpu.h            | 10 +++++++++
 4 files changed, 81 insertions(+)

-- 
2.27.0

