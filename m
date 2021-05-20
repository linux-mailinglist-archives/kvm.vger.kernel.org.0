Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E14C38B270
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 17:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238934AbhETPE0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 11:04:26 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:54219 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240141AbhETPEI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 May 2021 11:04:08 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 1827A19409BD;
        Thu, 20 May 2021 10:56:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 20 May 2021 10:56:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=1RuXScUYzcGIpx3b8
        iFAVEDzYE0Pc6TLx+tOKwThO3g=; b=EakPvUnCYOg3KzbxK+3agXEvK8p6cKvpF
        E6KUYj7YyCERSqBtNAVZ8EHWPpK17aadwSrxa1XYlVGcjV283vl3O32ww79Q/cyM
        kw7XEay91Q7g33yITV3Gx6mOjBJYhuVm8uAFNIahwn9SrSONEKFsYw14LwryxGrB
        1UskGMsXA+zxzeyMBUWwIWls4svjgzXhJTkd21Qk/a6JZuO/F+G/1O+YzaRysv8a
        yvUHhWftyI0TCcXIuD1H936au+paMMBzciJGGm+8yNowLVa2vvGJ+kDRjyYRobrT
        dwFOMEkgTqUAU+BayqHkW8OWZMpEPebulOrksph1uKidLdPCNSjuw==
X-ME-Sender: <xms:snimYAl4O7Vl-BwUsYqThqxoYXpRxMqz7NZ4LgIVwbmzeW6S1DBw3Q>
    <xme:snimYP1NbFZoygUewhWa45ynzjOzmpTlPniVKWlh3mAtgV1QA0GYj8UGbJ2ZJjVtn
    rXojDjFjE1othgk1KA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdejuddgkeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihguucfg
    ughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrdgtoh
    hmqeenucggtffrrghtthgvrhhnpeduhfetvdfhgfeltddtgeelheetveeufeegteevtddu
    iedvgeejhfdukeegteehheenucfkphepkedurddukeejrddviedrvdefkeenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegurghvihgurdgvughm
    ohhnughsohhnsehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:snimYOrayly7AW4ha6POw5SGQUrwfLDxjE7Xsvt_Z1eAfJrNGKBgJA>
    <xmx:snimYMndqMOi-OgP0RptekQu2103daQJ45I5r3-olgGyTloq1t6I1A>
    <xmx:snimYO3IuAXizCBB1CwQ_Y7Az1HacfJo47_N8iV2V9fR_gLnsdNkMw>
    <xmx:s3imYB2ZBALk_UjMcesyWhXI4UdsHwuXFyrnR1Pf3cAcCipCmfkLig>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Thu, 20 May 2021 10:56:49 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 7d490b61;
        Thu, 20 May 2021 14:56:47 +0000 (UTC)
From:   David Edmondson <david.edmondson@oracle.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Babu Moger <babu.moger@amd.com>,
        David Edmondson <david.edmondson@oracle.com>
Subject: [RFC PATCH 0/7] Support protection keys in an AMD EPYC-Milan VM
Date:   Thu, 20 May 2021 15:56:40 +0100
Message-Id: <20210520145647.3483809-1-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD EPYC-Milan CPUs introduced support for protection keys, previously
available only with Intel CPUs.

AMD chose to place the XSAVE state component for the protection keys
at a different offset in the XSAVE state area than that chosen by
Intel.

To accommodate this, modify QEMU to behave appropriately on AMD
systems, allowing a VM to properly take advantage of the new feature.

Further, avoid manipulating XSAVE state components that are not
present on AMD systems.

The code in patch 6 that changes the CPUID 0x0d leaf is mostly dumped
somewhere that seemed to work - I'm not sure where it really belongs.

David Edmondson (7):
  target/i386: Declare constants for XSAVE offsets
  target/i386: Use constants for XSAVE offsets
  target/i386: Clarify the padding requirements of X86XSaveArea
  target/i386: Prepare for per-vendor X86XSaveArea layout
  target/i386: Introduce AMD X86XSaveArea sub-union
  target/i386: Adjust AMD XSAVE PKRU area offset in CPUID leaf 0xd
  target/i386: Manipulate only AMD XSAVE state on AMD

 target/i386/cpu.c            | 19 +++++----
 target/i386/cpu.h            | 80 ++++++++++++++++++++++++++++--------
 target/i386/kvm/kvm.c        | 57 +++++++++----------------
 target/i386/tcg/fpu_helper.c | 20 ++++++---
 target/i386/xsave_helper.c   | 70 +++++++++++++++++++------------
 5 files changed, 152 insertions(+), 94 deletions(-)

-- 
2.30.2

