Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450B12B4F59
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388379AbgKPS22 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:28:28 -0500
Received: from mga02.intel.com ([134.134.136.20]:48461 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388365AbgKPS2Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:25 -0500
IronPort-SDR: TEPuvBFsSWGHNxGc9AhdAkMUj6cl+P7oHvegfFxaC7FJncE0YSVVYT2sOwZEIHmoV7hmr3/4y3
 +xS57VCqyEFA==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="157819228"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="157819228"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:25 -0800
IronPort-SDR: CWjwe3xKuC+kp8OHc6JKytQ8BahVNoyOSGnbKs3LTuRQuKARvdmCJSU3mmbNHDoJtgl+jM8YNA
 1MGbtaFVymqA==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400528424"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:24 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com
Subject: [RFC PATCH 67/67] KVM: X86: not for review: add dummy file for TDX-SEAM module
Date:   Mon, 16 Nov 2020 10:26:52 -0800
Message-Id: <b8dc44b28c68f8bebde09427c88e3e327cdfa391.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

This patch is not for review, but to make build success.
Add dummy empty file for TDX-SEAM module as
linux/lib/firmware/intel-seam/libtdx.so.

TDX-SEAM module isn't published. Its specification is at [1].

[1] Intel TDX Module 1.0 EAS
https://software.intel.com/content/dam/develop/external/us/en/documents/intel-tdx-module-1eas.pdf

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 lib/firmware/intel-seam/libtdx.so | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 lib/firmware/intel-seam/libtdx.so

diff --git a/lib/firmware/intel-seam/libtdx.so b/lib/firmware/intel-seam/libtdx.so
new file mode 100644
index 000000000000..e69de29bb2d1
-- 
2.17.1

