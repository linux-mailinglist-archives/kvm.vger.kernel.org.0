Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3661D793302
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 02:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238251AbjIFAsD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 20:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjIFAsC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 20:48:02 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E99199
        for <kvm@vger.kernel.org>; Tue,  5 Sep 2023 17:47:59 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-68ca6c214f9so3541473b3a.3
        for <kvm@vger.kernel.org>; Tue, 05 Sep 2023 17:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693961279; x=1694566079; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mm+uTnlozNmENdpjjarK1tdFrnoDxjI+QJ2Wx4et7cs=;
        b=yFAsCs+NopkSjBaOFiM7KietMMkZTNdZ+FqZXk656FXJf2UaI8DPKcmN3ZXqQRztVz
         9hZDo8K2p1BtKzvTp8noibFkCLgLA467tShbTD1QkDVm1cWaHKJI+hnbzREEK+WH1C1y
         1Flw20+mvpcBjqsQrIcxtYK2Qond9FEkaieAfPVYFhzTWz4EQefNt/rCCKhIE0QBruBz
         C+xSSZOcKC06vjZktPh3bPuPYnBzFC8ga9eIayykvl8NaiehBdGZqpUF2Ciuc78zOtcC
         iGl0yvUXporNr3DQj6nFBJXglikPyZ7XzFI9Q17AK1v981PLsqRgnqdi4TdYje4AvwCE
         2y3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693961279; x=1694566079;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mm+uTnlozNmENdpjjarK1tdFrnoDxjI+QJ2Wx4et7cs=;
        b=P8rPntfdPYYvM4hadhx3BDMMBqcbdAQX4VqiqcQJxC65vjZXet3eHBJ3+J4bXLCBbU
         S2r0WQ18GYYQ4y/GjBNr/vM0nrlRuWP3ee0H9bumQLgNypG4TSEabYxkWu2wrgA47ske
         Jej8wXRKdZRm0mGVzMlBu6K03tTXo+zYgS12LZ37rW9hmVPfk8KbjCod6JmrPaKANNIm
         1LE1mBFKvGTYKfOOJWJy4Q2DOaMsVv9Bk/d/Pix0UJP7W6bd0SwlrTzwrlpTvnebgVeH
         vsgLKamkMFtnwrWYsHFWjFDzTfrfXA1/G6+rHASDuC1NUl2zayeBYvD8Vv/HLTbcbx8E
         WXsw==
X-Gm-Message-State: AOJu0Yz+rCgBJ9iloZ1/pVotxhwQdFieyIHNckYmW680ep7dHD8Q3Vuw
        BScmOt0yiwAT5x8CSSx1+gnbEu+Ta5Q=
X-Google-Smtp-Source: AGHT+IH6GdjZSsJm2YeoNS2euzD49BaDMH4oeX+RrxZvE5z+cZwyv1EYxgAaOzbkNOqR3sWWQ/CdiPCJ0Fk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d2a:b0:68c:460b:88f8 with SMTP id
 fa42-20020a056a002d2a00b0068c460b88f8mr6095864pfb.1.1693961278957; Tue, 05
 Sep 2023 17:47:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  5 Sep 2023 17:47:56 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230906004756.3741087-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2023.09.06 - No topic, but game on
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No topic for tomorrow, but I'll log on for "office hours".
