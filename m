Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0AE72EA10
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 19:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240006AbjFMRlC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 13:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239881AbjFMRkx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 13:40:53 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E072172A
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 10:40:44 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1b3ac2e4555so19070985ad.0
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 10:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686678044; x=1689270044;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TUiBxscKO8lxYxMtPVe8+/s8hJqByIjywkgiabV0U6A=;
        b=s4Qj7sTv4RaeONGbkS2h8B7l9M99rdYQxeCqQ5bF39+5WTyVADCjAzRu6cL/x2Ipw9
         hjpwAmy6p8qiKXFROn2dbqtIjDZ9cVd8kH+t9SFGwEhR6BXEZIVxawbfQ1g9mUaLR4Q0
         tvIVHbYoGLoKxmmM1zjxAcxZfUnnGRYNddDlnU1qkJIA8Lmz6ap3sTr5wJjRVaJRX/jx
         T+s8MGZBgWS1YnmiJRLpkkgfCpeY177llUXhZJ/VQIQPncEfTnE1uV5cair3X+vnITTY
         VcbzbAXNrEbnmEMFpooGN43kwrYk5cfZQKcas9atrN1v8b7O1U64Vddq3j8A1tRb8rVj
         Hx5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686678044; x=1689270044;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TUiBxscKO8lxYxMtPVe8+/s8hJqByIjywkgiabV0U6A=;
        b=guf+4UtqM3fpFkRSYtMON4UWLyBUNaUomAf2Y6jp7PDJO+XjFnthvxDBYQvKbeTOJV
         CqRHouO0tMV6f4IlF30RBEo+ZZ8s6kKnInOdN6/Hu9W4kkSC191QsQ8EK0K2i2fmRYbe
         EVIQvhD5dOHAQh3wCZElHthGfQPXTgHhSouN5ycCcLhfs+sEeS/xYsr/Ma9Mi5eJ2QkQ
         zneMgflK/ZYyIROd7f/Q5ysRdeRx1EsY1z0rcG6hrLNiQuRmk0ocrEq+fLvX9mUEVUOy
         0ouEWp2FC2AdkKoE7QtUI160qwIdEE/WAfRirTD1+tSgUHIlDOXV31ZUqorLqG/Kg9p/
         h+cg==
X-Gm-Message-State: AC+VfDznEj7QW3E0mX50p1GKscjNa6MYKt2zO7X5GyxxISVnyoWik18Y
        EkkvyXtJz/jfdvOK49+KqsObANukmVqOSkJWB+w8O2+rQGQGQL3YgdIGI/QwA1HTkh5GY1eiWHz
        Dkj3mSnOx6KB5mv4Qb5X1lN1bq22ypT8N2XLa4VqsxjZ7pCRIvZ2bvtd+vA==
X-Google-Smtp-Source: ACHHUZ6E52MnItGVILB/Q/82mrEGXr8YgHX4o26Sbx31bK+7+m94Tq8PoX0Wb+sn41mLS/NGCxFxQReF47s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:7c05:b0:1af:93cf:5ffc with SMTP id
 x5-20020a1709027c0500b001af93cf5ffcmr1727641pll.2.1686678043976; Tue, 13 Jun
 2023 10:40:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jun 2023 10:40:37 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230613174037.1936197-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2023.06.14 - No Topic (Office Hours)
From:   Sean Christopherson <seanjc@google.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No topic this week, though as promised I will log on if people want to use the
time for "office hours".  E.g. feel free to come with questions about upstream
processes, the status or direction of a particular series, KVM technical details,
etc.

Date:  2023.06.14 (June 14th)
Time:  6am PDT
Video: https://meet.google.com/vdb-aeqo-knk
Phone: https://tel.meet/vdb-aeqo-knk?pin=3003112178656

Calendar: https://calendar.google.com/calendar/u/0?cid=Y182MWE1YjFmNjQ0NzM5YmY1YmVkN2U1ZWE1ZmMzNjY5Y2UzMmEyNTQ0YzVkYjFjN2M4OTE3MDJjYTUwOTBjN2Q1QGdyb3VwLmNhbGVuZGFyLmdvb2dsZS5jb20
Drive:    https://drive.google.com/drive/folders/1aTqCrvTsQI9T4qLhhLs_l986SngGlhPH?resourcekey=0-FDy0ykM3RerZedI8R-zj4A&usp=drive_link

Future Schedule:
June 21st - No Meeting (Sean OOO)
June 28th - Available!
July 5th  - No Meeting (Sean OOO)
July 12th - Available!
