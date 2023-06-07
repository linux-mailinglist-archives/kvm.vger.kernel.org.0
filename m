Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABEB1726951
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 20:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjFGS7O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 14:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231890AbjFGS7N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 14:59:13 -0400
Received: from out-43.mta0.migadu.com (out-43.mta0.migadu.com [IPv6:2001:41d0:1004:224b::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF40E1BE5
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 11:59:08 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686164347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=5f3hQqNOVG0iocgssZYkGELn9GI00OnfmmVdr0bBEh8=;
        b=qzCCzIjw+mWQxeSwH4qAy29fQsfHj2lrn/fo9dKLzTV4sINyf8nWkUPAmkXIbB269ijzrr
        u6t1VVmLRI7kYYNUG6ofTNI1Hu7+5k6JWByt1nZPgKcLLYp5ANiFi237kS1YdlzHYm5u15
        htrj9BBPJ0lLqV63yFUswgHD5r2Np80=
From:   Andrew Jones <andrew.jones@linux.dev>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>
Subject: [kvm-unit-tests PATCH 0/3] EFI runtime fixes
Date:   Wed,  7 Jun 2023 20:59:02 +0200
Message-Id: <20230607185905.32810-1-andrew.jones@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While testing the new EFI support for Arm, I fixed a couple runtime
script issues.

Andrew Jones (3):
  arch-run: Extend timeout when booting with UEFI
  arm/efi/run: Add Fedora's path to QEMU_EFI
  configure: efi: Link correct run script

 arm/efi/run           | 15 ++++++++++-----
 configure             |  5 ++++-
 scripts/arch-run.bash | 10 ++++++++++
 x86/efi/run           |  2 +-
 4 files changed, 25 insertions(+), 7 deletions(-)

-- 
2.40.1

