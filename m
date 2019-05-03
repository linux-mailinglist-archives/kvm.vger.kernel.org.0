Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE8A13300
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 19:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728789AbfECRP4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 13:15:56 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:37630 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726633AbfECRPy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 13:15:54 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 80E3415A2;
        Fri,  3 May 2019 10:15:54 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 810693F557;
        Fri,  3 May 2019 10:15:53 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will.deacon@arm.com>
Cc:     Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
        kvm@vger.kernel.org
Subject: [PATCH kvmtool 0/4] kvmtool: clang/GCC9 fixes
Date:   Fri,  3 May 2019 18:15:40 +0100
Message-Id: <20190503171544.260901-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When compiling kvmtool with clang (works only on aarch64/arm), it turned
up some interesting warnings. One of those is also issued by GCC9.

This series fixes them. More details in each commit message.

Please have look!

Cheers,
Andre.

Andre Przywara (4):
  vfio: remove spurious ampersand
  vfio: remove unneeded test
  vfio: rework vfio_irq_set payload setting
  virtio/blk: Avoid taking pointer to packed struct

 vfio/pci.c   | 28 ++++++++++++++--------------
 virtio/blk.c |  4 ++--
 2 files changed, 16 insertions(+), 16 deletions(-)

-- 
2.17.1

