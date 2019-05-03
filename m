Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7357132DE
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 19:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbfECRIa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 13:08:30 -0400
Received: from foss.arm.com ([217.140.101.70]:37502 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726391AbfECRIa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 13:08:30 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BD27915A2;
        Fri,  3 May 2019 10:08:29 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EB9E03F557;
        Fri,  3 May 2019 10:08:28 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will.deacon@arm.com>
Cc:     kvm@vger.kernel.org
Subject: [PATCH kvmtool 0/2] Automatically clean up ghost socket files
Date:   Fri,  3 May 2019 18:08:19 +0100
Message-Id: <20190503170821.260705-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvmtool is creating UNIX socket inodes to communicate between a running
instance and a debug command issued by another lkvm process.
When kvmtool (or the kernel) crashes, those files are not cleaned up and
cause all kind of annoyances.
Those two patches delete leftover socket files on calling "lkvm list",
also remove an existing one (then reusing the same name) when creating
a guest.
This avoids random breakages when running kvmtool, and helps to run it
from scripts.

Cheers,
Andre

Andre Przywara (2):
  list: Clean up ghost socket files
  run: Check for ghost socket file upon VM creation

 kvm-ipc.c | 44 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 36 insertions(+), 8 deletions(-)

-- 
2.17.1

