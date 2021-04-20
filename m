Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3306365CEF
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 18:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbhDTQNn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 12:13:43 -0400
Received: from foss.arm.com ([217.140.110.172]:37748 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232174AbhDTQNl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 12:13:41 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E1B751474;
        Tue, 20 Apr 2021 09:13:09 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1BF7C3F73B;
        Tue, 20 Apr 2021 09:13:08 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com
Subject: [kvm-unit-tests RFC PATCH 0/1] configure: arm: Replace --vmm with --target
Date:   Tue, 20 Apr 2021 17:13:37 +0100
Message-Id: <20210420161338.70914-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an RFC because it's not exactly clear to me that this is the best
approach. I'm also open to using a different name for the new option, maybe
something like --platform if it makes more sense.

I see two use cases for the patch:

1. Using different files when compiling kvm-unit-tests to run as an EFI app
as opposed to a KVM guest (described in the commit message).

2. This is speculation on my part, but I can see extending
arm/unittests.cfg with a "target" test option which can be used to decide
which tests need to be run based on the configure --target value. For
example, migration tests don't make much sense on kvmtool, which doesn't
have migration support. Similarly, the micro-bench test doesn't make much
sense (to me, at least) as an EFI app. Of course, this is only useful if
there are automated scripts to run the tests under kvmtool or EFI, which
doesn't look likely at the moment, so I left it out of the commit message.

Using --vmm will trigger a warning. I was thinking about removing it entirely in
a about a year's time, but that's not set in stone. Note that qemu users
(probably the vast majority of people) will not be affected by this change as
long as they weren't setting --vmm explicitely to its default value of "qemu".

Alexandru Elisei (1):
  configure: arm: Replace --vmm with --target

 configure | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

-- 
2.31.1

