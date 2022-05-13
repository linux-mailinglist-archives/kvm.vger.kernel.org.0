Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBFF7525941
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 03:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353427AbiEMBG1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 21:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376275AbiEMBGT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 21:06:19 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850763E5D4
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 18:06:18 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id f3so5683005qvi.2
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 18:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oxidecomputer.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z91PSjxKxv/xg8V6Yq4O38HKjfHfyrgOoNiw6F99ohA=;
        b=ZO7EhF3oUFOY4iZcrQhN7mbT8mltZ5oVGzXIP/06m/dsCkDb8ASa3k96pWHmdGQyc8
         LRyFtwC40zjpChR7393Eoh6eEjf30LsbFm50232PKg/d8JzvGWLyjnPLj44rxQYNcdto
         Ow7kTYGp1YblucH+GbJV9vQzXherUBimCL+4FanYxHTlOV3Z2t2/FObRqVVgs4sdzS3o
         KbiIOKbL40xUouv0ZiuGb7KIOUm3AV2YbimWIQL3pGHj7+j6cfd3n43H7/8eCNJ/ZHaQ
         jkC6ZzzID3gl4RzwuSqQkkiaUhOZTJvFfWOcgQGaj7uNfUgHE6pB4noR3wzBxy7O4YB5
         eKAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z91PSjxKxv/xg8V6Yq4O38HKjfHfyrgOoNiw6F99ohA=;
        b=snSPcHwa5ZzcDEApEso6qp/sup7JHzcJ7ZDcF12TJ3Xu0wQXCg6yFwLKtRh3vMt1aL
         cwmdv12G4+OZVgGt7NJB5zbIiFb2inLQc+ZeglpjbYssJ9tI7YmjeA72aVjNLzuhJOrR
         wwSfEgPPwWK0YG6cLLzSHTU+MGrmGTh8ZqCLW7P6A2jO1SV1D7jnUKUBu77l8uDp2nik
         W6je1zpStK4BVaqIa12FWdee9aCkV97g2kwDtXV2SPjbbOdiBC/AnxMqr9coGY4y/rql
         IPrKOoZTwdSi/egDvI+96FIDAxUPhsu7kmDmdRYO408p1GaFYWkFwg5mDjsFJ3gXRnG1
         +bvw==
X-Gm-Message-State: AOAM530DLaf7zxg2tNdHpEvQNphhO0Exlei1+SbAORmwjjmi7bRyA/Bq
        VXeiWkxhHApG8VNVjfXX8TD1cuI2ZFmffA==
X-Google-Smtp-Source: ABdhPJy4z5HiBDntude83hZudRevdAxxQ08IjeDDNGDfkVOzP9Nl2BkK45jNttA+S8//v+PpuBVe1g==
X-Received: by 2002:a05:6214:c29:b0:45a:fedd:7315 with SMTP id a9-20020a0562140c2900b0045afedd7315mr2528484qvd.59.1652403977133;
        Thu, 12 May 2022 18:06:17 -0700 (PDT)
Received: from doctor.oxide.gajendra.net ([2603:3005:b04:8100:f692:bfff:fe8b:cf8e])
        by smtp.gmail.com with ESMTPSA id cc6-20020a05622a410600b002f39b99f6b2sm619130qtb.76.2022.05.12.18.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 18:06:16 -0700 (PDT)
From:   Dan Cross <cross@oxidecomputer.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Dan Cross <cross@oxidecomputer.com>
Subject: [PATCH 0/2] kvm-unit-tests: Build changes to support illumos.
Date:   Fri, 13 May 2022 01:07:38 +0000
Message-Id: <20220513010740.8544-1-cross@oxidecomputer.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <Yn2ErGvi4XKJuQjI@google.com>
References: <Yn2ErGvi4XKJuQjI@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We have begun using kvm-unit-tests to test Bhyve under
illumos.  We started by cross-compiling the tests on Linux
and transfering the binary artifacts to illumos machines,
but it proved more convenient to build them directly on
illumos.

This patch series modifies the build infrastructure to allow
building on illumos; I have also tested these changes on Linux.
The required changes were pretty minimal.

Dan Cross (2):
  kvm-unit-tests: invoke $LD explicitly in
  kvm-unit-tests: configure changes for illumos.

 configure           | 5 +++--
 x86/Makefile.common | 6 +++---
 2 files changed, 6 insertions(+), 5 deletions(-)

-- 
2.31.1

