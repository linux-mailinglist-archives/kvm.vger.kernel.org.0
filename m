Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11092520609
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 22:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiEIUoN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 16:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiEIUoM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 16:44:12 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB0A285AFD
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 13:40:16 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id i10so25837080lfg.13
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 13:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BIXP48f9IFC0Hkj3azqmWJdeXSkX992GcZlhW28H8VI=;
        b=ExBCG/Z9ylStbbWLSb630ukgspNNaZiMDKsIaOm9cXuMHaShSG/KuFCizJHOKUOBkb
         hrsUyplPAjSLKoBSzTBRvovA9J9TJq/+fP4DT/Km6pOYaDSxCL9uWh0q/IzticNWrRSQ
         wo96KGXBMrjB7MZlUjkQ5fnvtxN5HH/GEhNiu5y2YDyMkyjG5mDmN20IgUbcpekxfKZo
         9XFh5ELEZgKTg8ftLN0k6uTCVIBXK8zdMjBdaUmLUH+Hd9Uqp8hEZmvXKg3gtpRT+0tq
         nUGr2PG+KZy2AgUzn/l/ZtCexGjkGBwRKrXfrX0SrGxUNi9tTn2FqhGmGRK7dBvRw+Xt
         oILQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BIXP48f9IFC0Hkj3azqmWJdeXSkX992GcZlhW28H8VI=;
        b=wc8X4SKFhUERycx1CZCItvAd1KXb3m9AAtiMNkjObURi6zRhoGVVsuz3u/NwiQ3+jE
         Vv+4/FNB/JSMAiW9liAPBJEjPqzSsgG1TEn0tLfDX2UE0exEq1JP3F1HMPrQwdYPBhBL
         +8R0eArBJVRsE4lUReUAJKWXwQWTO2eOy2qmm6C8itx2aEX1ze7K9olGKRs/sojenNyq
         rpQoIaritv1oxHPW+P/m8DTR+U+wuZOR6wwkx9gRyZNxmIWHp0KMLXmcXXAgzhpQISvq
         yemj4LpetubsU1d4pQR1VvCoJohYtJb/JIGuCO1njtvCNMswatUIAFmFfzWt4+lOLDAX
         vTNQ==
X-Gm-Message-State: AOAM530hRGbr3Cgp0T4bLrvn9yMPwFW2pW3qLscP2U/QcZVr2eUxZCWX
        paG2Se4aBT1T3rSusPhzsNfLUM8xEwE=
X-Google-Smtp-Source: ABdhPJzVCcKLfWr6G7EFGFFJvIjmpks60okM7ejP04II6B96+ISWXoAeAEmQU4v7dSmmet4Ipgxulg==
X-Received: by 2002:a05:6512:2145:b0:472:82f:2520 with SMTP id s5-20020a056512214500b00472082f2520mr14286596lfr.325.1652128814354;
        Mon, 09 May 2022 13:40:14 -0700 (PDT)
Received: from localhost.localdomain (88-115-234-153.elisa-laajakaista.fi. [88.115.234.153])
        by smtp.gmail.com with ESMTPSA id o25-20020ac24959000000b0047255d21121sm2051961lfi.80.2022.05.09.13.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 13:40:13 -0700 (PDT)
From:   Martin Radev <martin.b.radev@gmail.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, alexandru.elisei@arm.com,
        Martin Radev <martin.b.radev@gmail.com>
Subject: [PATCH v3 kvmtool 0/6] Fix few small issues in virtio code
Date:   Mon,  9 May 2022 23:39:34 +0300
Message-Id: <20220509203940.754644-1-martin.b.radev@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello everyone,

Thank you for the patience and for the reviews.

Here is the patchset with all of the changes.

Kind regards,
Martin

Martin Radev (6):
  kvmtool: Add WARN_ONCE macro
  mmio: Sanitize addr and len
  virtio: Use u32 instead of int in pci_data_in/out
  virtio: Sanitize config accesses
  virtio: Check for overflows in QUEUE_NOTIFY and QUEUE_SEL
  kvmtool: Have stack be not executable on x86

 include/kvm/util.h      | 10 ++++++++
 include/kvm/virtio-9p.h |  1 +
 include/kvm/virtio.h    |  3 ++-
 mmio.c                  |  4 +++
 virtio/9p.c             | 27 ++++++++++++++++-----
 virtio/balloon.c        | 10 +++++++-
 virtio/blk.c            | 10 +++++++-
 virtio/console.c        | 10 +++++++-
 virtio/mmio.c           | 40 ++++++++++++++++++++++++++----
 virtio/net.c            | 10 +++++++-
 virtio/pci.c            | 54 ++++++++++++++++++++++++++++++++++++-----
 virtio/rng.c            |  8 +++++-
 virtio/scsi.c           | 10 +++++++-
 virtio/vsock.c          | 10 +++++++-
 x86/bios/bios-rom.S     |  5 ++++
 x86/bios/entry.S        |  5 ++++
 16 files changed, 192 insertions(+), 25 deletions(-)

-- 
2.25.1

