Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21AB17A6FAA
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 01:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbjISXuB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Sep 2023 19:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232267AbjISXuA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Sep 2023 19:50:00 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF881A4
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 16:49:54 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c448ba292dso32153795ad.3
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 16:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695167394; x=1695772194; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cWclKWB8xac/o1eunayy0YMZBLx+RYmGm5drldjb68o=;
        b=kSfV3YXVUCTj13oGXu1pH+f7yFrZrQTeGulmqsVgUO/JJfo57PWu0aNWuWyTmv6S6V
         jTLdXT1VebMheIvDJOwMZWwItFYeUWylsemslIpHMl9vWW+AUy+xaX1pf+5aPZRpMkIt
         hTHGXoNcAYOAY34gq8UjMS9j2WOLNgb4lwezfNUIPaCsWWujTI3Y7MV50s/aFKUPAJDy
         0+Gm7HUYsFY2oRqU6D2tClbdaCGbMhEdvbEaphu/ndewgLtPapWhAdNWZ2faLWYoNn9G
         E+T2mkPO3MuGMHPerJ/eMdC+g0fA9CeKB3RW0iOYurWcy6YNn1xzHQQX822XZTyW5YnX
         XD+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695167394; x=1695772194;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cWclKWB8xac/o1eunayy0YMZBLx+RYmGm5drldjb68o=;
        b=AsnmSFvj24QaJLOwXqOvm58zaIKkAIUUHogYUScT2zJEcUOmVb+hvS5I7GotVSoA9o
         MAB7JgMoVLFDCTnD7eJcqJSivxHVCUih9wQLxgJHyzFhxiuNtEO2eX7r/LAir44Td2FM
         jjJIT2Erh/bZnbPvsQgTvIXuNy1i1F5PdVxZ3vQ0GpJKzj9whMI4T9xI6IGgHN06NPaP
         v7XqBKC1FqgQfbgwRNHHrnM/M+oNXitI1JHj1q0qftlJtB/e39bpDzpjRkufueFQH+yN
         xBGcyRlObrWINnnVuLq5Ha1LD7CEmJ3+x6uRf9KQkZDleMobQ9dUbF5FM64YHAMXOmP0
         Z1ew==
X-Gm-Message-State: AOJu0YxhJjfAtQ9uWf5MV6BLGa5J8CgmJxUCbXmA8xBctK0EQapYqXkI
        4hY+QALF5BRFK02EFMIHKAP8rVVGxmA=
X-Google-Smtp-Source: AGHT+IHuwXo0DqirICwn2yMpD1AMyi0DynW6Ny/MrTjXIniGjisyYEYGIbsCAWVj4D+LoYeEULDiAn9hD4I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:120b:b0:1bb:c7c6:3462 with SMTP id
 l11-20020a170903120b00b001bbc7c63462mr11492plh.8.1695167394311; Tue, 19 Sep
 2023 16:49:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 19 Sep 2023 16:49:51 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230919234951.3163581-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2023.09.20 - No Topic (Office Hours)
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

No topic this week.  Feel free to come with questions about upstream processes,
the status or direction of a particular series, KVM technical details, etc.

Note!  The next three instances after this are canceled, as I will either be
unavailable or OOO.

Date:  2023.09.20 (September 20th)
Time:  6am PDT
Video: https://meet.google.com/vdb-aeqo-knk
Phone: https://tel.meet/vdb-aeqo-knk?pin=3003112178656

Calendar: https://calendar.google.com/calendar/u/0?cid=Y182MWE1YjFmNjQ0NzM5YmY1YmVkN2U1ZWE1ZmMzNjY5Y2UzMmEyNTQ0YzVkYjFjN2M4OTE3MDJjYTUwOTBjN2Q1QGdyb3VwLmNhbGVuZGFyLmdvb2dsZS5jb20
Drive:    https://drive.google.com/drive/folders/1aTqCrvTsQI9T4qLhhLs_l986SngGlhPH?resourcekey=0-FDy0ykM3RerZedI8R-zj4A&usp=drive_link

Future Schedule:
September 27th - Canceled (Sean Unvailable)
October 4th    - Canceled (Sean Unvailable)
October 11th   - Canceled (Sean OOO)
October 18th   - Available!
