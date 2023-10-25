Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56F497D5F27
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 02:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjJYApS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 20:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjJYApR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 20:45:17 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4089F
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 17:45:14 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a7cfdacf8fso3305387b3.0
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 17:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698194714; x=1698799514; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IBzlLzg+dr2okumSatJwslJtQuC7+lJZNLV+PHh2KzY=;
        b=t1We2CDHza1o5zctxL9wdC5+JB5jKHYPDgcypmC1VOTLnc4dQIbzwb8hBmXvWfhsj5
         tU9J4eDyzpC82b1mqH2gxOInaTK/RdIOYtxlBQySBybdWl64CcgP3rfd86s/S/uYoGYn
         7I+Wu5fo5BN2/hPxVen+APY6ClpHl1nPqot65stB9yxhBZ7NH3YPlnMJ1vycIy2fw3MB
         BswoscJ0Q7N0guUrVgJaYPwPZl3Fq3RDm/iFCeiZZQbU7snaPNNiR6EggUBPj9wXGaYy
         qY1x1V4ieuLwSRS8xeQ8mtWNggISckYhPNqnG8ZsqTV5qysgd7yZX+p3LlGM2AeZSxMc
         ACsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698194714; x=1698799514;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IBzlLzg+dr2okumSatJwslJtQuC7+lJZNLV+PHh2KzY=;
        b=AbkSSofvHGsDJpD5+tlDda+06gqeaBQoy2l1IA7QECKiLE5fFKsYiWnWKUrNfPer7D
         jLtYGukJDUD+E5bhkL4JLt2XmybaUMWj58EpZDGLcJ3YGH+q9bENX1PQaotF1aFIapSp
         4YB+K6TwJfjQHk7OkySfi/7llJHC4MbdHeF9q0P7pRHdbq6nckuJsaP/Yvo5IfCXf0QE
         x9HdMAyPO37nUT/33pTz70YdUfH+7LcjMgUILwpM3z1s40xSyxGJLr42G0DEpfYcBGQ8
         1P90e9+p9lBNRyX2m0vc06acNQ+8rHpaB1+Cq5m9ZRK7DgKsn1GdDW9APWAtvNXTghY3
         Suaw==
X-Gm-Message-State: AOJu0YzneRKeW/n0I+vFQYwPoAjol0nWMdOo4s33lyKf2lxDE+ScOEgH
        5VOcF801ICSP/zyFolWY6YRFfadPrss=
X-Google-Smtp-Source: AGHT+IE0rzyMuQu+dmagkjFOIsButEe51YN9VAo/ljePrLbkdgYQ9shpuU8bvwIGK9Z3RDK6pgLuziD248E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d1c7:0:b0:d9a:ca20:1911 with SMTP id
 i190-20020a25d1c7000000b00d9aca201911mr408735ybg.4.1698194714225; Tue, 24 Oct
 2023 17:45:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 24 Oct 2023 17:45:12 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
Message-ID: <20231025004512.2709042-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2023.10.25 - No topic, but still a go
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No official topic again, but I just _love_ waking up before dawn, so I'll be
online ;-)
