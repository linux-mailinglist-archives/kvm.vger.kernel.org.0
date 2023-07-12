Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1097374FC13
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 02:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjGLAXz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 20:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjGLAXy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 20:23:54 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10882171C
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 17:23:52 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b9de7951easo27922625ad.0
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 17:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689121431; x=1691713431;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ds0aEFrJozDV/A3gP0D2y0rC14J5rwEi5Dw5pCEsing=;
        b=XobwyjGiSSSuciaAIawQSNUHt0xIyY5c+tc38AqJd9cSUoPPK3i91OOeqmZRXtpGju
         4W045I4+Cq4eSpfqstF1BaYguMjLv3/3evVtAvLGnFbOrsVhgpdqCJTZjTud3C0z9O1F
         K/4tGswt0yNfVAMPFenELHyuvb6YJyNmXQW7+2zYh2W2gxV5opkJx9wO0HygjWu0Mpa6
         0z/GHpVXIHwQSMWg/j8dpRcQlDIwpVKE6bQ5h/H3CgSaa9zeqhMztEzQ+mmypGfouQhm
         Hf/EcVILUAQMD/yvUKZXlxll4tYrMSxgvgfhX5n+VE3jXxPKSXpj2RVSCdTumOtkAHcJ
         bDPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689121431; x=1691713431;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ds0aEFrJozDV/A3gP0D2y0rC14J5rwEi5Dw5pCEsing=;
        b=Kgnk5jR6uWy7qP3rAYqWBWbW1xtJ/l6/keVVd7NNtI7PDUvTn/YJxBFDQKaASQLQY+
         xU772W5JUmzBPbjZe9UZnVCSsbLLHr85ttvTmmUBzFzAWaH9d89mIyAdDlLzdr3u5xj8
         Bs7OrEQ9M9UtclGYbKif3Oo++PrL41PPwrab0GY84ZY8hYape6o2nbjhhA+4RvRHeoMS
         Jiy65aTr+gTyDBQwQjxbo3TRVotJnSb9rX8lzOfuyBYahbIirwr0GWPSa6LSiYbAQc+O
         1Lmdz3ls17OamnvUtJ29xeML74l6q9MAqzXlACUoUeMiLdPZn3JqV63IkNJvSZqPDfmi
         yr/A==
X-Gm-Message-State: ABy/qLY4Mxq4LNzegEWa4gAd+FB0V2SoL+7pcXp1igl125QBAZB6mlHY
        EU9bzZ041ZnxL00gtGGARdh/UnFjMzCyN/H7p5nLsScWCWmGacjxTgSVNqLu8lAg5gXAFrdTtn+
        OXZ4MjO8fUeMWMglqo97Fa1VHSRALNM86EKbzQOsjzq4H6JJkTgiL9YcjAQ==
X-Google-Smtp-Source: APBJJlFWZiAVE/LORxHqV6F1DJr/fdbicVW3J4ypsK7k2ZFpuiYk2xc1DoJxaBc9RROqQ6BJ15nEO2Kvolg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2441:b0:1b8:a758:3020 with SMTP id
 l1-20020a170903244100b001b8a7583020mr14074336pls.12.1689121431037; Tue, 11
 Jul 2023 17:23:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 11 Jul 2023 17:23:47 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230712002347.656854-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2023.07.11 - CANCELED
From:   Sean Christopherson <seanjc@google.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Apologies for the late notice, and for canceling again, which I said I wasn't
going to do.  I wanted to discuss guest_mem() development this week, but I
didn't get my prep work done in time.

Next week, I want to like to discuss the KVM MC, specifically how we want to
utilize the 3 hours, as well as coordinating guest_mem() development.  I'll get
confirmation off-list that we'll have enough of a quorum to have a worthwhile
discussion on one or both topics.

Future Schedule:
July 19th - KVM MC format, guest_mem() development
July 26th - Available 
August 2nd - Available
August 9th - Available
