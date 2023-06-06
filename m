Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C914B724B04
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 20:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238634AbjFFSPh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 14:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238340AbjFFSPc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 14:15:32 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C2C1702
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 11:15:30 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-565a1788f3fso105118007b3.0
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 11:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686075330; x=1688667330;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JWWF6XrdjkOawOX4RNsKj9Dqj2PN4moMYd7StgsnMQw=;
        b=nI9Jb9yMkiUS4oIqTfi1JlPX2HFlW2UaeccX6YNTUduJeERK0uYRz8kRKvqXPcmIhj
         P0HQ2lZSssQLQx7WXwg6QAUzNlcXzPiDJGAO/hgu685KwdxX0s2Vgcp8URYh6LCX2fWi
         8+amWzbyn/OqYrpunvfFoZE1PsQMRj8JQxum1LZBv43kCTGewDA2hl1+AmZAGGZMloY6
         Rf8uLEhZtr6y86T8gNj6BBT6/GFb509F7lZyqZha0Dkb3ezS5T4xENCwD7L6aEU6Kddc
         Ct7Kb82xBRUhLAXgHr+ks8UbLxG+5g5tpyMYEVSBehEH/dzLK6y/WHrGRD8X20sLqlCI
         LO0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686075330; x=1688667330;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JWWF6XrdjkOawOX4RNsKj9Dqj2PN4moMYd7StgsnMQw=;
        b=jObZmgNEKxL5+G7GAzGAoBM47VR+0H2C5gGTLd8Xzv8p1OoO876F3HEt4i33glQN39
         xDW2z2IxqJjS2t/NUIzRP9mOB04K22mJtxKD5E83PqmDJK7kX0UFzkXeHr2GdQQ19j62
         2FCcm4GsUneT/zIQOzwB31itUROAtLc6HtemlXB1xwKAxfvJfqpnWmeK/sPO1AdG9NSm
         VAT7BTEKxiXisaMAlx5AhwmLDqJb8PzWeBnjWYA2OJ+4xUsPA4rCo5Jlc/uMo72RONZk
         g0Whxshp58K+UHEEK7oDSiXcy3wsABrJygPbtcjOEGbyqnRKsxNOZDN4uWooVxaRbQZ2
         dugA==
X-Gm-Message-State: AC+VfDzT8M2eaxBoFIQQj6ClFQcJCDK0+g35UhNC+ygdH3Fa7RybKN3L
        VMdDe2RmGb4HqvNyxhRS3Uy7idTuTb8EWLnA9wfvfjwRKWU7i3WyKd6yI/tCpgGSZl+bGPsg2us
        9BZYl40pA6Cfw6gYlLjcPAvHiTFDgyxNfAqJPUHuZVOpQafI5k8UQT5Q5ZQ==
X-Google-Smtp-Source: ACHHUZ5fFG/h+CVk72eejA5nWOCg00kOAKqMfa8xaoIsagS+I4oeyC8jYmSKPY0EewdBmgD9Ni+5mN5z5s0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1143:b0:ba8:736a:5bec with SMTP id
 p3-20020a056902114300b00ba8736a5becmr1670574ybu.6.1686075329918; Tue, 06 Jun
 2023 11:15:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  6 Jun 2023 11:15:25 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230606181525.1295020-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2023.06.07 - pKVM on x86
From:   Sean Christopherson <seanjc@google.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Topic:      pKVM on x86/Intel
Objective:  Present use case, gather feedback on high-level design/approach
Background: https://lore.kernel.org/all/20230312180048.1778187-1-jason.cj.chen@intel.com

Date:  2023.06.07 (June 7th)
Time:  6am PDT
Video: https://meet.google.com/vdb-aeqo-knk
Phone: https://tel.meet/vdb-aeqo-knk?pin=3003112178656

Calendar: https://calendar.google.com/calendar/u/0?cid=Y182MWE1YjFmNjQ0NzM5YmY1YmVkN2U1ZWE1ZmMzNjY5Y2UzMmEyNTQ0YzVkYjFjN2M4OTE3MDJjYTUwOTBjN2Q1QGdyb3VwLmNhbGVuZGFyLmdvb2dsZS5jb20
Drive:    https://drive.google.com/drive/folders/1aTqCrvTsQI9T4qLhhLs_l986SngGlhPH?resourcekey=0-FDy0ykM3RerZedI8R-zj4A&usp=drive_link

Future Schedule:
June 14th - Available!
June 21st - No Meeting (Sean OOO)
June 28th - Available!
July 5th  - No Meeting (Sean OOO)
