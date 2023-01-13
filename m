Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDF59668EE4
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 08:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241084AbjAMHOD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 02:14:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241318AbjAMHNj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 02:13:39 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32678461E;
        Thu, 12 Jan 2023 23:00:11 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id h21so18299287qta.12;
        Thu, 12 Jan 2023 23:00:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:feedback-id:from:to:cc:subject:date:message-id:reply-to;
        bh=IEJ0RgYFWYuGkSWcE2UNfpfugMWI4UMIvk+Fs4raKDA=;
        b=SqNUSrwQ3gQtb6Png+bWV7Nr74hIYGYoPhlwqPYKJJ9KxehYfcbrKKEZd8djKp9WjK
         NO2RO8YzjOzO2+5P6+64+fRwnxSHIG2/VSI/hzsVO4Eu3X4hw3PRpQs61Iw/9wpWnt8h
         DoGSLo9/JVEPlYP5VwIApLpoSyKFJ4dPk7HNeFOeI+hyFg9qJiojQ10HwbBmc+aUyKxF
         huczoIBuc+3oz1X69veM/pSeEggO9zHXQDaxAr5QTOyzeG3/vyAUhZA0UsxtFV5BD2zI
         Zu//tkoBlUIFa3NaQe+aiSiWGblxqpDeo5vfNx6yBIIIKe+J1DGVyOJ9a6FGvkXntqkc
         2UMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:feedback-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IEJ0RgYFWYuGkSWcE2UNfpfugMWI4UMIvk+Fs4raKDA=;
        b=wcAynSha/gDKp64syuEJWIkvjIHj6nd63/YTwLL3iiBAJsxNBt+UzBi4C6rfat73MG
         13zoQcAMF6yjkW2AlfGjs6/3jnxNfKGF5EbbxneO2SHOtGzp3lNDGI+9+QAVLNdL9ldS
         abvrJmnfdFjA7Z7tSDRWtQwDuslb8EgesvYLLPiVVjCbH4gBK5Dpftm/besByXhoxeon
         BHUlDXepbEq3oCAu16Gl2dQdmv+IrsxdW7mHvxkXIsCzFl7x86dowAqMsNFh78GwMARt
         zcN4DtGNy/tlcJ9f9Oz6EcPm99CQC5+G/oFvgpgbgBszjdiAftk+pS8LSvqNzwjCtsgo
         D9cg==
X-Gm-Message-State: AFqh2kqII1ZKPaqtFZoFCU31uHz8QtrM8qzmZnKkvLE6XgMAN1Gt0RqA
        rtsUK80H7JDrql2iYhBlYVI=
X-Google-Smtp-Source: AMrXdXtQ+UIq2zTu75lLrtMACSpY1pf8vZbmw5XYeKPQbA+d/0c0SxFcJLLgdsagzx83Y1TY/dYinQ==
X-Received: by 2002:a05:622a:4a09:b0:3af:7ebe:9b56 with SMTP id fv9-20020a05622a4a0900b003af7ebe9b56mr20265670qtb.25.1673593205485;
        Thu, 12 Jan 2023 23:00:05 -0800 (PST)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id i17-20020a05620a405100b006cfc01b4461sm12383899qko.118.2023.01.12.23.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 23:00:04 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 189D227C005B;
        Fri, 13 Jan 2023 02:00:03 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 13 Jan 2023 02:00:04 -0500
X-ME-Sender: <xms:cwHBY_wPussJAFlg1phz4_nEXJGGqdJLDkdhIV6saeutOmsLw-lzFQ>
    <xme:cwHBY3RS23Tju7rSaF4sCPUEkV4aj79YnSt2SdiL9v6ORNyBoVVKTJn9_pZQorgqk
    mH5-o9bgsC9zfPnfA>
X-ME-Received: <xmr:cwHBY5Wrxl-sEUODovqHcNuTq8dZdYkVJVzdZt-0V8S1E4EgayEiu0GhtCk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrleejgddutdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomhepuehoqhhunhcu
    hfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrghtth
    gvrhhnpeeggeeukeeghfevudektdevjeehhfekffevueefudeivdelteeltdekheejgfei
    veenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepsghoqhhunhdomhgvshhmthhprghuthhhphgv
    rhhsohhnrghlihhthidqieelvdeghedtieegqddujeejkeehheehvddqsghoqhhunhdrfh
    gvnhhgpeepghhmrghilhdrtghomhesfhhigihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:cwHBY5hY_u0kZ23DwIdcaqAMPxe_zHboP6xC1HL_UFjsvOMiBYpEPw>
    <xmx:cwHBYxANSJGlIoDRo98IUFoSwvNaiMbR9x297OKYeeE9lnAz336dXg>
    <xmx:cwHBYyKMEANiMrCoF_B_tGA3GLzjN00ph-8g7pg3gIOuuPlGVKbD1w>
    <xmx:cwHBY12bl1PT57WoOrvUY0fyRmNgHjHUqwM7la46YZg5LySAHWGVrQ>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Jan 2023 02:00:02 -0500 (EST)
From:   Boqun Feng <boqun.feng@gmail.com>
To:     linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, seanjc@google.com,
        Joel Fernandes <joel@joelfernandes.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH 0/3] Detect SRCU related deadlocks
Date:   Thu, 12 Jan 2023 22:59:52 -0800
Message-Id: <20230113065955.815667-1-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is actually a leftover of the recursive read deadlock detection
patchset:

	https://lore.kernel.org/lkml/20180411135647.21496-1-boqun.feng@gmail.com/

I resolve comments then and add more test cases, and hopefully this can
fulfill the request from KVM:

	https://lore.kernel.org/lkml/a14a13a690277d4cc95a4b26aa2d9a4d9b392a74.camel@infradead.org/

;-)

The patch #3 is now WIP for two reasons:

*	It may conflicts with Paul's patchset on removing CONFIG_SRCU

*	I haven't found a proper way to "reinit" srcu_struct when
	lockdep selftest runs: cleanup_srcu_struct() needs workqueue
	however the tests can run before there is one.

Anyway, these selftests prove the detection actually works. And as
always, feedbacks and comments are welcome!

Regards,
Boqun

Boqun Feng (3):
  locking/lockdep: Introduce lock_sync()
  rcu: Equip sleepable RCU with lockdep dependency graph checks
  WIP: locking/lockdep: selftests: Add selftests for SRCU

 include/linux/lockdep.h  |  5 +++
 include/linux/srcu.h     | 23 +++++++++++--
 kernel/locking/lockdep.c | 34 +++++++++++++++++++
 kernel/rcu/srcutiny.c    |  2 ++
 kernel/rcu/srcutree.c    |  2 ++
 lib/locking-selftest.c   | 71 ++++++++++++++++++++++++++++++++++++++++
 6 files changed, 135 insertions(+), 2 deletions(-)

-- 
2.38.1

