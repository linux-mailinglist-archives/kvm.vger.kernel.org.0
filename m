Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4849918EE5B
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 04:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgCWDOj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Mar 2020 23:14:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:48945 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726979AbgCWDOj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Mar 2020 23:14:39 -0400
IronPort-SDR: /f7kq6CiHoI/ypBK6MGA4hJkG5inR1+EzZ73vEfWCsku+xUlFd4vt9ZO9Z8LSPWLVKU0FfCIY4
 7FM9nf20Ct7g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2020 20:14:38 -0700
IronPort-SDR: jFOHaTOf/TbRq7blbQLJLeIdgf9zS7fRX2leFtroj+bcuNV1wOz4P98aETg3smzoqnW9YHubT8
 CvJ+foaSKvwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,294,1580803200"; 
   d="scan'208";a="292453678"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.161])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Mar 2020 20:14:37 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 0/3] Misc patches for core_capabilites and split lock detection
Date:   Mon, 23 Mar 2020 10:56:55 +0800
Message-Id: <20200323025658.4540-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patch 1 renames core_capability to core_capabilities to align with the
latest SDM.

Patch 2 adds MSR_TEST_CTRL support.

Patch 3 prints info when guest is going to be killed due to split lock #AC

Xiaoyao Li (3):
  target/i386: Rename CORE_CAPABILITY to CORE_CAPABILITIES
  target/i386: Add support for TEST_CTRL MSR
  target/i386: Tell why guest exits to user space due to #AC

 target/i386/cpu.c     | 12 ++++++------
 target/i386/cpu.h     |  8 +++++---
 target/i386/kvm.c     | 30 +++++++++++++++++++++++++-----
 target/i386/machine.c | 20 ++++++++++++++++++++
 4 files changed, 56 insertions(+), 14 deletions(-)

-- 
2.20.1

