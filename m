Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA05124F62
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 18:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbfLRRdI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 12:33:08 -0500
Received: from mail-wm1-f44.google.com ([209.85.128.44]:55099 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbfLRRdI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 12:33:08 -0500
Received: by mail-wm1-f44.google.com with SMTP id b19so2705456wmj.4
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2019 09:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=0KSQAOByRWNcFo6CmLFpjQla52nVgda6MjvtK71OjfQ=;
        b=i00TIWS7rVKXRnx5YSiXbdnnGV98R1qy3ySEMO4orhY0nAovV8Yql1oSxMx43zb2G/
         U0c9p58jW5/m+3PMROmWOsL/3cidlUpfempzLe9LJhLwR2pTnvJFqOnXrtta2eZj9J6i
         tK+1J5/MFwyQqmjgz43qCUZEkr6yahHfw73Eyj8FLGVYMJUyfHmFJ7I1NwdQCZdztWmH
         /8ZY7XdFdQIZq8TwvyjgScId78c8O7POOzhQ0EiqJGS7mYajmb5PJkd3AAX+786grXN9
         C12ZHwYqWAn+MK2TiHB0sJgm/dX5eZ6NrlMtZGB57HvsZjjWGabmTDlKIaqzNk/VDebx
         0ncQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=0KSQAOByRWNcFo6CmLFpjQla52nVgda6MjvtK71OjfQ=;
        b=LcpbvW4mESkHgyP5l5sUxJa4z+JNiu/3LIuWhTrV8js9C5THhfUTa3mFhoc2zQdc8c
         81olFOEI8C9BOAL9lEV8qf7zq0z/l57tJBP/ywigf17Ih6V4+zTmemhAOEYoHmCMZz+X
         e2MVqd5rmHIP0NrJnQ8Er6hyhKGRMnDlZfjnU6UwDha6H27jbLRraN6CFtQezxo/4Wwi
         lt2IV8fzLP+DguQduUvZkINPREVUISBmhgRr7aiJACXbCBvCP3H4yNieq9+MKADpx4aU
         mY/rfcWFFYQqPD9NP5ZRXI6uoQzFNbmJYZpz9CP9fOYhQUENr8Pe26HxcMXWokhfZqKw
         6OvA==
X-Gm-Message-State: APjAAAUkL+d58gDADj1fgm/F31c1sNrhaRCeeA+oFB3BHOmNPHUMWX3p
        zXU3fKeb3Z7Sb7ScxQEwronLyQSI
X-Google-Smtp-Source: APXvYqzL0AzK3EDfnvD/oi1jeRWasRsBKrzwYeD5CLLUkYy9qmza4H1KUW9GlwROAMlQCG4XcSUfzg==
X-Received: by 2002:a05:600c:294d:: with SMTP id n13mr4355808wmd.130.1576690386161;
        Wed, 18 Dec 2019 09:33:06 -0800 (PST)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id u22sm3411362wru.30.2019.12.18.09.33.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Dec 2019 09:33:05 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     cavery@redhat.com
Subject: [PATCH kvm-unit-tests 0/2] svm: make preparation more flexible
Date:   Wed, 18 Dec 2019 18:33:01 +0100
Message-Id: <1576690383-16170-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the future we may want tests that inject events while GIF=0 (this is
nice to cover check_nested_events or lack thereof).  Adjust the SVM
test harness to make this easy and not ad hoc.

Paolo

Paolo Bonzini (2):
  svm: introduce prepare_gif_clear callback
  svm: replace set_host_if with prepare_gif_clear callback

 x86/svm.c | 132 +++++++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 84 insertions(+), 48 deletions(-)

-- 
1.8.3.1

