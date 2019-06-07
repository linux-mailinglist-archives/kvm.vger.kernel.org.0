Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56FF2392AA
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 19:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730141AbfFGRBj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 13:01:39 -0400
Received: from foss.arm.com ([217.140.110.172]:44502 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728974AbfFGRBj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 13:01:39 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1FB553EF;
        Fri,  7 Jun 2019 10:01:39 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 87B373F71A;
        Fri,  7 Jun 2019 10:01:38 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will.deacon@arm.com>
Cc:     kvm@vger.kernel.org
Subject: [PATCH kvmtool v2 0/2] Automatically clean up ghost socket files
Date:   Fri,  7 Jun 2019 18:01:19 +0100
Message-Id: <20190607170121.16557-1-andre.przywara@arm.com>
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

Changelog:
v1 ... v2:
- Printing name of each remove socket file on lkvm list, removing summary.
- Printing name of removed socket file on lkvm run.

Andre Przywara (2):
  list: Clean up ghost socket files
  run: Check for ghost socket file upon VM creation

 kvm-ipc.c | 37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

-- 
2.17.1

