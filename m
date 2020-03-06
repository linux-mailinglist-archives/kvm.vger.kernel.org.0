Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBD317B45E
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 03:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgCFCVi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 21:21:38 -0500
Received: from mga18.intel.com ([134.134.136.126]:19708 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgCFCVh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 21:21:37 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 18:21:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,520,1574150400"; 
   d="scan'208";a="413742155"
Received: from snr.bj.intel.com ([10.240.193.90])
  by orsmga005.jf.intel.com with ESMTP; 05 Mar 2020 18:21:35 -0800
From:   Luwei Kang <luwei.kang@intel.com>
To:     pbonzini@redhat.com, rth@twiddle.net, ehabkost@redhat.com,
        mst@redhat.com, marcel.apfelbaum@gmail.com
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH v1 0/3] PEBS virtualization enabling via DS in Qemu
Date:   Fri,  6 Mar 2020 18:20:02 +0800
Message-Id: <1583490005-27761-1-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PEBS virtualization will be first supported on ICELAKE server.
This patchset introduce a new CPU parameter "pebs"(e.g.
"-cpu Icelake-Server,pmu=true,pebs=true") that use for enable PEBS
feature in KVM guest, and add the support for save/load PEBS MSRs.

Luwei Kang (3):
  i386: Add "pebs" parameter to enable PEBS feature
  i386: Add support for save/load PEBS MSRs
  i386: Add support for save/load IA32_PEBS_DATA_CFG MSR

 hw/i386/pc.c          |  1 +
 target/i386/cpu.c     | 14 ++++++++++++++
 target/i386/cpu.h     | 15 +++++++++++++++
 target/i386/kvm.c     | 43 +++++++++++++++++++++++++++++++++++++++++++
 target/i386/machine.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 122 insertions(+)

-- 
1.8.3.1

