Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01F436754B6
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 13:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbjATMgW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 07:36:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbjATMgN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 07:36:13 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E8ABFF60;
        Fri, 20 Jan 2023 04:35:47 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id lp10so2035145pjb.4;
        Fri, 20 Jan 2023 04:35:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yV2oWoct8jHvEDKh4g0zGEsKHmT9W9Ju3bzPj5+1tu8=;
        b=cLfNGiZ4VehBisHJ7fG9F9FZmP0dx1kunOo8soWbrbDm2xThbYLWvfj6sFinIgy83o
         vAen82QLHPpigagRHSrUSPweUMZzzHwKXJKHOsZgmIaSJIbv7Af9PYQRGGt/hZUh4Nio
         OE9m/HzJuFV7IFFhp7Y7Zf2SYEd98Hne8G2HbJ0wKUSWH4SeDYxvWG2MQTOVSpcuLYlJ
         f26FPB/X6LCjpfWaOSGAPFjbdyZqz0jwHJSJatZikoOtpUzM7uCeQ5TnPFG954bRtmYL
         LBtl2PbRWkdOcrwdms7kNukWpMPi4zCTWigSGjrDpecjYZQLJoWfnDepmMPvPnT2b8P6
         j/Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yV2oWoct8jHvEDKh4g0zGEsKHmT9W9Ju3bzPj5+1tu8=;
        b=K/D7kif2iXCahzoXUp+sT6I83v2SStV6pWqxi47QY41gNEd2GYD5ZNpQRBEeuOoZJ3
         /D7QGwI8T8IvZyQ6XQFFtUk+SrEZhzS8+U50I0iyVQaF26c2Z17RIkPi5mjRbmDNs640
         R5BB3hIHB9rFRzRNU7JZ+qehTDcudQw8v+o3snZrC/gIIQR+IappoBprCZi086gKXdFK
         yODOhkxRZafiYEgNxhKjvZB+VIniNdMFyjEH+AdmrODtnOHro1XeIspa7HeisVEvZ75Z
         ZhYFxZi17/3xe9uDyhusbL3sntgprLbvbuvAuQynCjnQXf++GW7/2gTXBGWSNniIbG40
         RcIw==
X-Gm-Message-State: AFqh2kr0td2nPHASR1p19LL5s8DDwuiulyZbHRho3geeA2TnGLixuvZS
        KztgSfvlUqqkBGsZ5IdLHGY=
X-Google-Smtp-Source: AMrXdXspLJ9QM5pigmWO1C3y1SzqRqvDgFvZVsrGZuQJqOCB8Eh6WcmAQdK+Zh1gdWOZoCdxKnXM7w==
X-Received: by 2002:a17:90b:4a91:b0:229:2a8e:90cf with SMTP id lp17-20020a17090b4a9100b002292a8e90cfmr15091662pjb.26.1674218144295;
        Fri, 20 Jan 2023 04:35:44 -0800 (PST)
Received: from debian.me (subs02-180-214-232-6.three.co.id. [180.214.232.6])
        by smtp.gmail.com with ESMTPSA id t13-20020a170902b20d00b001926a76e8absm26910006plr.114.2023.01.20.04.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 04:35:42 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id E62DD104FAC; Fri, 20 Jan 2023 19:35:37 +0700 (WIB)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Freedesktop DRI List <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation <linux-doc@vger.kernel.org>,
        Linux KVM <kvm@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Oded Gabbay <ogabbay@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jeffrey Hugo <quic_jhugo@quicinc.com>,
        Ofir Bitton <obitton@habana.ai>,
        Sean Christopherson <seanjc@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH linux-next 0/3] Documentation fixes for linux-next (Jan 20)
Date:   Fri, 20 Jan 2023 19:35:31 +0700
Message-Id: <20230120123534.137413-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=729; i=bagasdotme@gmail.com; h=from:subject; bh=xTrUPK9bQjBpPVPof0lzCkWtR4B7Q/FejCVqz3qmtzY=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDMmnuvpvz+G5cJv7zF+ra5ZBBg0zN/d6/Fo1RfnFrNrO47IV M7VsOkpZGMS4GGTFFFkmJfI1nd5lJHKhfa0jzBxWJpAhDFycAjCRNxMZGabcdJbrOx188Of/0OdzOf avlBRYK+0174Lnfe8zK+LUeA4xMuzgOngz0IGp6ZS2u0x6nOisHdN5j7RoCD5k+7FjwRnHCQwA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Here are fixes for recent htmldocs warnings reported in linux-next. Each
patches can be picked up separately if ACKed.

Bagas Sanjaya (3):
  Documentation: accel: escape wildcard in special file path
  habanalabs: Fix list of /sys/class/habanalabs/hl<n>/status
  kvm: x86/pmu: Add blank line separator before
    KVM_CAP_PMU_EVENT_MASKED_EVENTS code path list

 .../ABI/testing/sysfs-driver-habanalabs       | 23 ++++++++++---------
 Documentation/accel/introduction.rst          |  6 ++---
 Documentation/virt/kvm/api.rst                |  1 +
 3 files changed, 16 insertions(+), 14 deletions(-)


base-commit: d514392f17fd4d386cfadde7f849d97db4ca1fb0
-- 
An old man doll... just what I always wanted! - Clara

