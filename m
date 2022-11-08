Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7456218B3
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 16:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234468AbiKHPpu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 10:45:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234501AbiKHPpr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 10:45:47 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA92D58BD4
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 07:45:45 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id 7so13276015ybp.13
        for <kvm@vger.kernel.org>; Tue, 08 Nov 2022 07:45:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3WmnLZviTEtGOd04KwL6mismfEZmWFzPvbjT4L9wHzc=;
        b=PyrurgMiCSOMPjtWpQQibYYdz6w4YOWL+smQ01L99WmHlOWyZB6LEDiCXFuMbmG8LA
         WWbx3zVcdP1uF8iZlVy4hS3Zo5mAv6wZMFQTKygOrW7zJqU98v8oNQDQl2p17Hgnbva4
         7EZVXFMgLLccgQu/gU04QMDXhBzpwiQHajKrqfxBoRR9rRRJrrRpicJb611HLI3DSqCY
         SldvM4h14vHZzhTsGQLOEMbZG5lQzN/19GT9A//6BJ3PJs1My9j5ogViA//DoATAStJX
         k5a5YRvdXBwUNt3wHYsZrjExSxFtPSWGVezviYhJpU4eZxeqZr6Eiroupi+tAzKozpU2
         X6tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3WmnLZviTEtGOd04KwL6mismfEZmWFzPvbjT4L9wHzc=;
        b=DCdGrZ8o/Z+BTOqgWKP1DjAsFm1CXom5toQ1MuoWx5Tf/WoXiqZY85hhAOty+E5sty
         wYy2UawMR7pVwgyNU/BI0y58zRjiOYmMH4nuRm73nceI/Q+Muj6AEp1Zp3DqjVNtcjjk
         yqkeLEWuYEHhDp/E60GslKwbBgEjKiLlOueF+kCeW8A26iesNQjnEEhCytjRWbZFmLDH
         DQ2IvU756SnznFEzV3BSZmo65UmEcnNgJ2w7w+GGA4VbENK0V0QMG5Wd4uNTvbd+mq3n
         EUXRSwNbPJ7UokURFeUBbAenOWLbVwdX8zWUYyPQTa6ApD4BfHfbPMcGchxF3Psft5/W
         aoUQ==
X-Gm-Message-State: ACrzQf3Hl2eAQVHctLWsaejGgEvUys6Ja4cz/JdCck/l2/JF42ZJkd52
        /78ZSbsl29aaVWiSnTNpuRWcRs0S5aTJhFPEjyA=
X-Google-Smtp-Source: AMsMyM44pzUqCnadd4VjJw/YK/lkra4pmBy7tfkDjxKZBo5QUsk/LvtkrTBpymYLNTuoxVfNQ54iGrcoK48xpYBaPXY=
X-Received: by 2002:a05:6902:191:b0:6cd:3a43:cda3 with SMTP id
 t17-20020a056902019100b006cd3a43cda3mr42710682ybh.207.1667922345030; Tue, 08
 Nov 2022 07:45:45 -0800 (PST)
MIME-Version: 1.0
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Tue, 8 Nov 2022 10:45:33 -0500
Message-ID: <CAJSP0QXc9MOUuU9amBorzV4hf9A9HWFZrtn3sZzJ-OkWMwvNPw@mail.gmail.com>
Subject: Call for FOSDEM presentations on QEMU, KVM, and rust-vmm
To:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        Rust-VMM Mailing List <rust-vmm@lists.opendev.org>
Cc:     Mahmoud Abdelghany <blackbeard334@protonmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_05,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,
The yearly FOSDEM open source conference is now accepting talk
proposals. FOSDEM '23 will be held in Brussels, Belgium on 4 & 5
February.

FOSDEM is a huge free conference about all things open source and an
opportunity for anyone to present QEMU or KVM topics. Both in-person
and pre-recorded talks are being accepted this year.

Please consider submitting your talks to the following devrooms:

Emulator Development Room:
https://blackbeard334.github.io/fosdem23-emulator-devroom-cfp/

Virtualization and IaaS devroom:
https://fosdem.org/2023/schedule/track/virtualization_and_iaas/

Rust devroom:
https://rust-fosdem.github.io/

Thanks,
Stefan
