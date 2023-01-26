Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3442B67C272
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 02:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235678AbjAZBfX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 20:35:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236186AbjAZBfC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 20:35:02 -0500
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2826842BE0
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 17:35:01 -0800 (PST)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1pKrAJ-0008Hh-AL
        for kvm@vger.kernel.org; Thu, 26 Jan 2023 02:34:59 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From; bh=chALMGIoQDmaei/8EfRkNa4wN80rSPvBAehTZctm2VM=; b=tX7NpyNxqJ3J6
        EdWE0NUYJIXo/2Osgs66/HUoYaBzXmh87RzteOf6vs8YLg5B4OEPZI8z3BXSPXcqKalVR5TBRs896
        +uNJXzx/84q08nNTmvtlh37UgOqG6mQ9BcNm29KaA0IG5FTz089732BA04IQdUaP/093z09Ih9FkA
        UUKgx+a0Ps1p/mYDbD+2PPc5Q82ZSlUocUAkrlAEefuCYCbgQCHhxAVe37UR5Rkd5EzwlOKFuwkoW
        g1bxYHWibUjkK8nSJXDuwv6Oi+39H36aWpxuUBuuoQfsENMFYWzH4xHHHY1JHQh00sRbi1thl+6rG
        5mWbJm7SRw+AyUwFangdQ==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1pKrAJ-0003BP-0p; Thu, 26 Jan 2023 02:34:59 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1pKrA6-00010H-TK; Thu, 26 Jan 2023 02:34:46 +0100
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH 0/3] KVM: x86/emulator: Segment load fixes
Date:   Thu, 26 Jan 2023 02:34:02 +0100
Message-Id: <20230126013405.2967156-1-mhal@rbox.co>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two small fixes for __load_segment_descriptor(), along with a KUT
x86/emulator test.

And a question to maintainers: is it ok to send patches for two repos in
one series?

Michal Luczaj (3):
  KVM: x86/emulator: Fix segment load privilege level validation
  KVM: x86/emulator: Fix comment in __load_segment_descriptor()
  x86: Test CPL=3 DS/ES/FS/GS RPL=DPL=0 segment descriptor load

-- 
2.39.0

