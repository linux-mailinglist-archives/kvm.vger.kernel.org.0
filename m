Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 119396E6713
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 16:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbjDROXY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 10:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbjDROXU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 10:23:20 -0400
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C72915442
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 07:22:53 -0700 (PDT)
Received: from [167.98.27.226] (helo=rainbowdash)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1pomEF-003hrL-CT; Tue, 18 Apr 2023 15:22:43 +0100
Received: from ben by rainbowdash with local (Exim 4.96)
        (envelope-from <ben@rainbowdash>)
        id 1pomEF-0066nR-0M;
        Tue, 18 Apr 2023 15:22:43 +0100
From:   Ben Dooks <ben.dooks@codethink.co.uk>
To:     kvm@vger.kernel.org
Cc:     linux-riscv@lists.infradead.org, ajones@ventanamicro.com
Subject: Add zicboz support for riscv kvmtool
Date:   Tue, 18 Apr 2023 15:22:39 +0100
Message-Id: <20230418142241.1456070-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is two simple patches, the first to sync the defines to ensure
that the struct kvm_riscv_config is sync with upstream and the second
to allow zicboz support into the guest.

[PATCH kvmtool 1/2] riscv: add mvendorid/marchid/mimpid to sync
[PATCH kvmtool 2/2] riscv: add zicboz support

