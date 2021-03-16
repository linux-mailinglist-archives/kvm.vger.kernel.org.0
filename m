Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43B533D746
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 16:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhCPPYh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 11:24:37 -0400
Received: from foss.arm.com ([217.140.110.172]:46148 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229526AbhCPPYM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 11:24:12 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0783DD6E;
        Tue, 16 Mar 2021 08:24:12 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F3743F792;
        Tue, 16 Mar 2021 08:24:11 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, alexandru.elisei@arm.com,
        andre.przywara@arm.com
Subject: [kvm-unit-tests PATCH 0/4] Fix the devicetree parser for stdout-path
Date:   Tue, 16 Mar 2021 15:24:01 +0000
Message-Id: <20210316152405.50363-1-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This set of patches fixes the way we parse the stdout-path which is
used to set up the console. Prior to this, the code ignored the fact
that stdout-path is made of the path to the uart node as well as
parameters and as a result it would fail to find the relevant DT
node. In addition to minor fixes in the device tree code, this series
pulls a new version of libfdt from upstream.

Thanks,

Nikos

Nikos Nikoleris (4):
  lib/string: add strnlen and strrchr
  libfdt: Pull v1.6.0
  Makefile: Avoid double definition of libfdt_clean
  devicetree: Parse correctly the stdout-path

 lib/libfdt/README            |   3 +-
 Makefile                     |  12 +-
 lib/libfdt/Makefile.libfdt   |  10 +-
 lib/libfdt/version.lds       |  24 +-
 lib/libfdt/fdt.h             |  53 +--
 lib/libfdt/libfdt.h          | 766 +++++++++++++++++++++++++-----
 lib/libfdt/libfdt_env.h      | 109 ++---
 lib/libfdt/libfdt_internal.h | 206 +++++---
 lib/string.h                 |   5 +-
 lib/devicetree.c             |  15 +-
 lib/libfdt/fdt.c             | 200 +++++---
 lib/libfdt/fdt_addresses.c   | 101 ++++
 lib/libfdt/fdt_check.c       |  74 +++
 lib/libfdt/fdt_empty_tree.c  |  48 +-
 lib/libfdt/fdt_overlay.c     | 881 +++++++++++++++++++++++++++++++++++
 lib/libfdt/fdt_ro.c          | 512 +++++++++++++++-----
 lib/libfdt/fdt_rw.c          | 231 +++++----
 lib/libfdt/fdt_strerror.c    |  53 +--
 lib/libfdt/fdt_sw.c          | 297 ++++++++----
 lib/libfdt/fdt_wip.c         |  90 ++--
 lib/string.c                 |  30 +-
 21 files changed, 2890 insertions(+), 830 deletions(-)
 create mode 100644 lib/libfdt/fdt_addresses.c
 create mode 100644 lib/libfdt/fdt_check.c
 create mode 100644 lib/libfdt/fdt_overlay.c

-- 
2.25.1

