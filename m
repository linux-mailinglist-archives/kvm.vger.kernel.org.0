Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5F66626575
	for <lists+kvm@lfdr.de>; Sat, 12 Nov 2022 00:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234710AbiKKXU7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 18:20:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234619AbiKKXUT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 18:20:19 -0500
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E55836A6
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 15:19:56 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668208794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=U1SVQ+53JeaSnl/mk5LvPb98/eFUBJ5kc0qmJalJVWs=;
        b=KCkG+vpWHn6fOKTFYAqouxKFTb89yEJNg6JgS33w+TcJD3jPpaEufSv6ITxXslqTQSwp1d
        QTO5b/JXyQaucB4GtvkOcojBLdwAaupWTvUZ4dDkfaRCluFQ1VnUu19rgZWLyJPy6J3kQe
        864dtyWCUEPDGp3VmAZCZbHo5rx4Mkg=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Ricardo Koller <ricarkol@google.com>,
        David Matlack <dmatlack@google.com>, kvmarm@lists.linux.dev,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/2] KVM: selftests: Enable access_tracking_perf_test for arm64
Date:   Fri, 11 Nov 2022 23:19:44 +0000
Message-Id: <20221111231946.944807-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Small series to add support for arm64 to access_tracking_perf_test.
Well, really this corrects a bug that is benign on x86, but you get the
point.

Tested on an Ampere Altra system w/ all supported guest modes for that
platform.

Oliver Upton (2):
  KVM: selftests: Allow >1 guest mode in access_tracking_perf_test
  KVM: selftests: Build access_tracking_perf_test for arm64

 tools/testing/selftests/kvm/Makefile                    | 1 +
 tools/testing/selftests/kvm/access_tracking_perf_test.c | 3 +++
 2 files changed, 4 insertions(+)


base-commit: 30a0b95b1335e12efef89dd78518ed3e4a71a763
-- 
2.38.1.431.g37b22c650d-goog

