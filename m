Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 102E57727F9
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 16:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234699AbjHGOhq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 10:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234537AbjHGOho (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 10:37:44 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C132510F7
        for <kvm@vger.kernel.org>; Mon,  7 Aug 2023 07:37:43 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d4e1be2dd10so2351918276.0
        for <kvm@vger.kernel.org>; Mon, 07 Aug 2023 07:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691419063; x=1692023863;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9UP/423VqUYYkUR83r5F6CNLGgsSHv+QZbVscycIlEs=;
        b=Jlbx7CweBhCZDt1j2+kahnzMQZq5SxQdES9XmKiBBEkBHN2wxK9xfI+Gw2HqK3xad0
         V9WjAA3OIfHZ4ONpgrT8FYj5Kv8yD4gR+Zgy3XWe9BARbGKtBMu8BRQ5h6XswEKMTnhZ
         SL6Y+pSTrRVIzUhHI84jmwjgf8F8Q37+V5KVXmPfDS96f9iHNnPyed3g+hVokjAK1rKN
         mlLqg64/Nx1CE2tDsWNS+Y7L02/EfhdhdoEfnhUNo/ftXfpRBdeAFOzmsyu0rGAifGuo
         uwJx4bL8zdu2PxbBZEH4W1Id58z3b0Yd55j4sbjH2l3wBEc01uSwMY1g/ZgEva3w7hpr
         oFWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691419063; x=1692023863;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9UP/423VqUYYkUR83r5F6CNLGgsSHv+QZbVscycIlEs=;
        b=N5h79FY2t9vomtm7SyjEVWnngYYn6ekIpO6ZuOEk1iJDUY+mhLOqlnnS2fFzhHJztI
         2rsFj8iVsZUPWZAB9VaR4ltwe8dV7tCMwsEVzRrcW7BEJFpjbmlDqCEMDJuuujHU74JC
         mWcLNnQ6XSylhQ5bO74sLAE+KMdUhuwxh72casfE9ccf1l4JsXfiWePPzyjnZBJ7AyI+
         etZoG2MiM4Lg6Oi2Vi/hOGQsKsQ0KJj/6+4iOayumxEOkUCFztBiDHSHJIEIa42Phxhi
         z5cOPoy9dRHWSsbGbT1oep6bvfI5b1BnqA1uo5FJq5U707Nb1Ic20JcsUTVFlY1FjFiT
         uvMw==
X-Gm-Message-State: AOJu0YyEyr4wNrDx/6Wr1LzO1u53JlcqoHbH+NZE6xdpyjo+hKejb221
        1/hlX3q4UWJKNrv10pV44rsC3/eEOCI=
X-Google-Smtp-Source: AGHT+IGykU39o4HR+MjAgtoYlNmNIFUq98flNpcBT18y/0+MTksSJf2DlbYLxCSO70+K4368Pzc+MQrXvyU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2944:0:b0:d07:7001:495b with SMTP id
 p65-20020a252944000000b00d077001495bmr50431ybp.11.1691419062854; Mon, 07 Aug
 2023 07:37:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon,  7 Aug 2023 07:37:37 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230807143737.2155966-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2023.08.09 - CANCELED
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

Canceling this week as well, I'll be traveling on Wednesday.

Future Schedule:
August 16th - Available
August 23rd - Available
August 30th - Available
