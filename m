Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6B8F76277A
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 01:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbjGYXlx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 19:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbjGYXlw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 19:41:52 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3576E12E
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 16:41:51 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-5635233876bso3169069a12.0
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 16:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690328510; x=1690933310;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UWcC6NZnwplKxnJubHdIw6W1xXpN9D0rWOANNHWmQz4=;
        b=4QoIsgD0aKg8cm7D42eqOcaczpv+G18YfoUra8P5i9LdEAb4sPivfVku7GILRprbbn
         876cPLdUSl+t4WX66PhvT9iozT/Y/zPI8TUxxbrS0qPqew4Ws3XF2/D6p0hOPa2AH+If
         yztZ4H5r0HUHmzjuAhea6YhAgFzQmxLc7veIzn7nu3NnrH+wzpEbRL93XXs4LfqLShM4
         q/kAXlzY52E1yg8s32d7kbHzVDtsSUp96nq4QDLa2xkcxq8oGPNgLui7lYD4BYqhWHUs
         u1K8vywP6SK/80LYzu1X/hAXxa2QpWcBTau5IffV458XfYn3Xk4MsZ+zDbylKSBhG018
         kcXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690328510; x=1690933310;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UWcC6NZnwplKxnJubHdIw6W1xXpN9D0rWOANNHWmQz4=;
        b=E3NOWj5KBAc1MBzQRiaB2HoOCkjZCtJ0A8JHNIzl0oT0I3SzLOPTyXS/bU0BWp4+TE
         ji85ECg09i/adp0JvpVY8ZTeIlAQ2To6bvqKulJ03rreL6EIvb9ssWZoeQQeOYvQOMoz
         kSil4g1ZXoRuvBORkrn/guBZ5Yr0OJrsYv7mDz/nftKwo1HwVWkn7TrUQs6eDnRwVmId
         4KblIho5oRck39eY4jEsbn52stHgF6x1esNK9nL4RGIFvEwkVBxwTGtvlm/6j8R1fLcT
         h9xABNKg1KqjmHL+yI+ddZAaHLQgCkQOvbQo0wPFPl7IbI2fGrGLw29sWRrQN02ld1Qa
         lcUg==
X-Gm-Message-State: ABy/qLY7Iz1p3hWeVI6liGDdPiCjd94OZF3a2Iq8Tvsk1ZIXIR6yznVv
        /xIDMHAokPJqcqZxsr1iDbdZowrhg+U=
X-Google-Smtp-Source: APBJJlEfUJLdUrmrbSlFBFGHSdTPzHYSaXbojZzRQq0Qqk2F9CvFkeKhfcnsFT29n4IYiT0HAeKLuEt5S3o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:7411:0:b0:563:4869:f54d with SMTP id
 p17-20020a637411000000b005634869f54dmr2530pgc.11.1690328510698; Tue, 25 Jul
 2023 16:41:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 25 Jul 2023 16:41:45 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230725234145.351635-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2023.07.19 - No topic
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

No topic for tomorrow.  I'll log on in case anyone wants to have an informal
dicsussion about something.

Date:  2023.07.26 (July 26th)
Time:  6am PDT
Video: https://meet.google.com/vdb-aeqo-knk
Phone: https://tel.meet/vdb-aeqo-knk?pin=3003112178656

Calendar: https://calendar.google.com/calendar/u/0?cid=Y182MWE1YjFmNjQ0NzM5YmY1YmVkN2U1ZWE1ZmMzNjY5Y2UzMmEyNTQ0YzVkYjFjN2M4OTE3MDJjYTUwOTBjN2Q1QGdyb3VwLmNhbGVuZGFyLmdvb2dsZS5jb20
Drive:    https://drive.google.com/drive/folders/1aTqCrvTsQI9T4qLhhLs_l986SngGlhPH?resourcekey=0-FDy0ykM3RerZedI8R-zj4A&usp=drive_link

Future Schedule:
August 2nd  - Available
August 9th  - Available
August 16th - Available
