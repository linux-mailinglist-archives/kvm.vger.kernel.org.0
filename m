Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22F076646C
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 04:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728780AbfGLC2h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 22:28:37 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45927 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728737AbfGLC2h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 22:28:37 -0400
Received: by mail-pl1-f193.google.com with SMTP id y8so3990669plr.12
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 19:28:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=txM7NRAPhKKOhPah/KvbJzpjgw2fG+quBcemGqRzwNM=;
        b=geDC67YVyOOwLtMBUDitaOv3vTDzDZkQkikYEUWxtMsno2FM7S3xHRCHxQfboCDHdk
         4BQra2iSZD8Q+atIV2SGnEn30YuBsRZn38RMeny2+gJQQQbXHY94fFF3FwhK7FkN55Pa
         hP4Zpu1sHmFLxSTAENl/VfQq9TfmdDBgCqhAq2SCRww2wLZxEYZ5YYgUrVUHf4IEHo6y
         b8wFVU2w4w8d4fLkLVf5cjxsoMpJ4/Nz2zS4UMrDVDzLKkgavSu2xlodd+/pFv+ATrt+
         A9H48LVaiI565NoTvY/W3Z/AhHTMerdCBCC6+UMnk3+qYVey/TCt8cRJcl/DDSwXecRB
         BF0g==
X-Gm-Message-State: APjAAAXOQX1LeWdixyijy3hX/fhrqQ+kXMbh3x9LS4OLwE6aV7Sysmgn
        ZURbXQfkNkfTlwWGBsVFQ72aUSTmhQkTog==
X-Google-Smtp-Source: APXvYqziN1QMo38n+tDNuOyYGcrDVuVJpxys7+4CoQrKQ9kAsgbv5CYuv9TZm1KtmD6GypM0G6mH4w==
X-Received: by 2002:a17:902:8a94:: with SMTP id p20mr8325453plo.312.1562898516530;
        Thu, 11 Jul 2019 19:28:36 -0700 (PDT)
Received: from xz-x1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f15sm7389259pje.17.2019.07.11.19.28.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 19:28:35 -0700 (PDT)
From:   Peter Xu <zhexu@redhat.com>
X-Google-Original-From: Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Luiz Capitulino <lcapitulino@redhat.com>, peterx@redhat.com,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [kvm-unit-tests PATCH v2 0/3] tscdeadline_latency: Some fixes of hangs
Date:   Fri, 12 Jul 2019 10:28:22 +0800
Message-Id: <20190712022825.1366-1-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The previous version only contain patch 1 but when at it I noticed
more ways to hang it... so let's fix them all up...

v2:
- use safe_halt() as suggested [Sean]
- added two more patches

Peter Xu (3):
  tscdeadline_latency: Check condition first before loop
  tscdeadline_latency: Limit size
  tscdeadline_latency: Stop timer when reach max loop

 x86/tscdeadline_latency.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

-- 
2.21.0

