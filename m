Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1831784D45
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 01:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbjHVXSL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 19:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231699AbjHVXSK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 19:18:10 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBC8E54
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 16:17:48 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1c09d82dfc7so10242645ad.0
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 16:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692746268; x=1693351068;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fgHncrCicSiDGEmSYSoSO7cxQ/oxsYZ6nl0Vwv41qjY=;
        b=cen000SwggUPmQthb+FOb307QZRQVBlVqXcPwYtWSNnLkVIR9N+RKYbneM99or4yZ0
         lMd9qsKuodNpMZ9ckMdN1+/ue7u2vgT7yRfsd6ZcKz3XC1DC4Hy393tCjfpT0/KRgU7W
         sr/82osMqgE37QelnSkDZfq47c4/4THpZXYcvi7CsRM7ewcOqE9+0vNu5qQIdxryoeWx
         usj6QGMXg/usdPq2DtDZwkCfvQATCvdy0zm5KrL3HifVTWcIY+xWEB3I6wckVX1tBYGN
         Y0Fd7w2ZALIMH/hqJfqLyVIrt9YnpIpmhowGKeVQV+i9SPABNYQRREH4fqVJ3nDIRc9M
         eDKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692746268; x=1693351068;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fgHncrCicSiDGEmSYSoSO7cxQ/oxsYZ6nl0Vwv41qjY=;
        b=gbteYnDa0YpeoRChkkPk/407/V9Wc7AQtTs+2CayhKxgWtPRijaW1imtq6Pet9XU6a
         o455k719ttnQpObXvCz7w1JCUsK46xTDyrBLzRGMjDYVwVoTTB6MdeUe1r7wSGh+TJIR
         QCSvhlcTGxZvqB8PNfp+Tclva6ATLOPfEtcPrgjryrcRvjq6rIVBaqKRptpoq+K4sY6f
         DVwKeM1qaOk1o7EOcYrJ4er+2Te55gkgYheW2r82axpy9MXGf1sFmrz7dLpNx+vd/Mfz
         o/I5Pe7YppfhO9HRFdRYdt4wT5m5S0KTTCYAmE8wodJgk7vC+53ZST3bys5hSr8t5bnG
         7v5w==
X-Gm-Message-State: AOJu0YzuHP3vYQBmxnVNmJuU4sdKW5SKGMYNMKbezkwEjCnypMlBxIOZ
        xcoLFQ66qVvkcUbyiF/jzlSo+Ubsqlc=
X-Google-Smtp-Source: AGHT+IEA2yuOwLNumNpA3A8I+q5pHNsif7cq7hmFKeDKm1OQ1/AMjvmw5fQcRFarkE/zxDY0YJSMt6joixc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:22cd:b0:1bb:cd10:823f with SMTP id
 y13-20020a17090322cd00b001bbcd10823fmr4902890plg.5.1692746268314; Tue, 22 Aug
 2023 16:17:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Aug 2023 16:17:40 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230822231740.2448696-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2023.08.23 - CANCELED
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Canceling this week.  I need to write-up the refreshed guest_memfd() todo list
that I promised to give in last week's impromptu discussion.

Future Schedule:
August 30th    - Available
September 6th  - Available
September 13th - Available
