Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2BF3B65D3
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 16:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729301AbfIROWh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 10:22:37 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36588 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbfIROWh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 10:22:37 -0400
Received: by mail-wm1-f67.google.com with SMTP id t3so285986wmj.1;
        Wed, 18 Sep 2019 07:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=6nKowSJkmj6y8SDyX3nXm1VDFEY4+KARvCaZgONZgTY=;
        b=sHvaxBqPoh9HdPutDdOHYNG2SiQafQqOoadtmSUHyz4TErj7HkOAVFdD3fLxc1PVw1
         lpqaAH51OsWTKx8X84zmbkSqZgFQhhFGjJqKE1ov9OuP6FIXbGEBwQQhqy8+1Ce5pAf3
         VUaUWu3i8/CW+QmemKXDsJM/WfwkC/bBbjxlz9kKSZgeMwwINkDivaEp/HfTCGuvTU14
         4jB4VoH5Wqsfbf+Xqg3kURDJ4nT6Xjkv1KHFx0VF1wgXnjlXpclZbq4U6UVvmz/qKd3Z
         JbGq8HyiiCxAtqGObSJ2bAXe6jge6XbJrNNTO5AmIu41RCgeXFXFN8BYojJddSg1kv8v
         poUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=6nKowSJkmj6y8SDyX3nXm1VDFEY4+KARvCaZgONZgTY=;
        b=SDCwECkup0cPakP6adTzco2rnMk4zoPguBFBEpQVKJT9ztkYhIi7zq/14TQwZNVP6M
         DcNWxNZpBQDdSAiBgTZIwDNTh9HBs+wehvpB0dUwKBr+Xw9z99l371SqBasnulrDvprq
         ACjZBwessEHjnGcqwajR6OtH8jnigiwqsTbYRD985zBQRRjspakqWER4Oi7hUXgG/tQf
         2GFJKx5AoaAWJGUHHYIynHDZ83SkBMejBuSfbfTMpXtHDUpCClrCY1tkVwaLrMJ1MjVZ
         WFcoVysgCTJZuHfKeJl9IjLdaCtSPWdSRdrW9IqSUAdEUlL2b8b/MhkZDt7DpES4rZs/
         4BLg==
X-Gm-Message-State: APjAAAVSXOrFSk7xxAXOuBmPKkf9qzn86mrA6T3f9JsV9ttonVwSVJv8
        MCZXY15juoYa6AjolEGPklpHtV9A
X-Google-Smtp-Source: APXvYqzCiXXfMRBxI/rS2G2gjm1hhgWe8jjxTZ2GV+783JJXtxbjxzg3RbvVoB2WwI7yT9MKS+K5RA==
X-Received: by 2002:a1c:1d85:: with SMTP id d127mr3358148wmd.14.1568816555351;
        Wed, 18 Sep 2019 07:22:35 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id q19sm10849959wra.89.2019.09.18.07.22.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 07:22:34 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Subject: [GIT PULL] Urgent KVM fix
Date:   Wed, 18 Sep 2019 16:22:33 +0200
Message-Id: <1568816553-26210-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

this pull request is independent of the merge window.  Please pull it as it
fixes a longstanding bug that was recently found by both Google humans
and bots (syzkaller).

The following changes since commit a9c20bb0206ae9384bd470a6832dd8913730add9:

  Merge tag 'kvm-s390-master-5.3-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into kvm-master (2019-09-14 09:25:30 +0200)

are available in the git repository at:


  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus-urgent

for you to fetch changes up to b60fe990c6b07ef6d4df67bc0530c7c90a62623a:

  KVM: coalesced_mmio: add bounds checking (2019-09-18 15:56:55 +0200)

----------------------------------------------------------------
Fix missing bounds-checking in coalesced_mmio (CVE-2019-14821).

----------------------------------------------------------------
Matt Delco (1):
      KVM: coalesced_mmio: add bounds checking

 virt/kvm/coalesced_mmio.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)
