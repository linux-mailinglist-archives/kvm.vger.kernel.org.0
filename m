Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 010C36BE831
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 12:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbjCQLdt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 07:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjCQLds (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 07:33:48 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8DCAA73D
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 04:33:11 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id ek18so19087125edb.6
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 04:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112; t=1679052789;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yQ9K6P7i+jvFreJ1ATNejSYxKdKOAxPSQW/y/Q0TXmA=;
        b=t78FWCdKObt7aRVDIrm3u3h4+YzFzy9nr8FSPqgqr5CS5PNRP7wthj8rpT5eR0rvxs
         YkJiondQuPYHOu5E8l0xv3FjekteWCwFDbkU58WE7midnYjzK7hshdLr/IvRXkpF7bq9
         ygLoM4bQ8ZyutHqPApW3zKICS2wmlYTa/n8+F7NwogpIKACPQQHwtWWQLTajzNSDyGkn
         HYNyzbx23+6oy0fiKvjP/cl/NHM70HEaoAPApbUN6gxHarCHi1KApAMQUdqJPrHGauCG
         S1dUxUH6OBaEKUp3EOUhhaCmAg9AUNYn8Y6mUAie9C+XDmvntO0qXQ5rZPTwZg8q4pDj
         eibg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679052789;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yQ9K6P7i+jvFreJ1ATNejSYxKdKOAxPSQW/y/Q0TXmA=;
        b=7KtChqQb+2Ox0yBN3Y5dJ2ohrJWcej0uKlYfmZJcf1/EDcsiLKwH/sfXvQtkypIh8B
         SG6qPPRn1jB3dVfbm1HLPiFbLtPn2Vnfek5afwpq/snIwXVv8piUPgHwJFNSYoz5Wn8r
         Cp/Sv0i6A0p63wiPCXSLWFcZDP3Yi1P2/tVrEkrVhggXNbpQOy27JQR4deL+tpLk4nmr
         pwkW/cR1hSJ/mUpc717a9eY30yEmOGqnhDOiOQWxadlAURZ1/Sx/1hnw997lRbs0PC7D
         npWw8YipJXDPCt7COuchHghqb5ZpKmK9Z/Jla2b/uBK2gPX1eookqGrqa8TSuRfgV7HI
         JqhQ==
X-Gm-Message-State: AO0yUKVES+8wkxRhzGnchptzCtwLS8GXg48ILG0EtgEgREiBAh7VW1Eq
        Mn/FwsS9msHzbaHBtnLN7RPTPOlrv13KWZBCP0fdZA==
X-Google-Smtp-Source: AK7set8GwJca1C5PPnQh4fRL74jDgwGSiutiqOWceaQ21v4CcPqAZLNGle/zPBe2F5T11d53xWGsltnp8i+e8WHVtmg=
X-Received: by 2002:a17:907:36e:b0:8b1:3d0d:5333 with SMTP id
 rs14-20020a170907036e00b008b13d0d5333mr7093608ejb.13.1679052789335; Fri, 17
 Mar 2023 04:33:09 -0700 (PDT)
MIME-Version: 1.0
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 17 Mar 2023 17:02:57 +0530
Message-ID: <CAAhSdy320bsv7=EBLcdiXyJcO6NWUFK9_XUvwF_KvFF8v91RpA@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv fixes for 6.3, take #1
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

We have one KVM RISC-V fix for 6.3:
1) Fix VM hang in case of timer delta being zero

Please pull.

Regards,
Anup

The following changes since commit eeac8ede17557680855031c6f305ece2378af326:

  Linux 6.3-rc2 (2023-03-12 16:36:44 -0700)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-6.3-1

for you to fetch changes up to 6eff38048944cadc3cddcf117acfa5199ec32490:

  riscv/kvm: Fix VM hang in case of timer delta being zero.
(2023-03-17 13:32:54 +0530)

----------------------------------------------------------------
KVM/riscv fixes for 6.3, take #1

- Fix VM hang in case of timer delta being zero

----------------------------------------------------------------
Rajnesh Kanwal (1):
      riscv/kvm: Fix VM hang in case of timer delta being zero.

 arch/riscv/kvm/vcpu_timer.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)
