Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933FF30B37E
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 00:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhBAX0r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 18:26:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25273 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229842AbhBAX0o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 18:26:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612221918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=3NlvvSEK6Q9k5kOj7hFhTGXtCazv2Lc7Wa4M2xagkr4=;
        b=OTvYOI+jHbZlSrvBjE6LsMeprU12S1YkCR3C4TQgCZJLqq893aAVgFQkXTd1mKxs7zhdnl
        MgM+1ivjF7CaabU4PpyMK/ildQDru/8Xp9IQbpZcmzLTi84FUReQCkx2n6DTWMHZAFERCJ
        ETmJesEQI2s99rKN4jKLrWZdEbAr8Ow=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-554-8hUBMuueNTOHm8ay6AkxBw-1; Mon, 01 Feb 2021 18:25:17 -0500
X-MC-Unique: 8hUBMuueNTOHm8ay6AkxBw-1
Received: by mail-wr1-f72.google.com with SMTP id n18so11426867wrm.8
        for <kvm@vger.kernel.org>; Mon, 01 Feb 2021 15:25:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=3NlvvSEK6Q9k5kOj7hFhTGXtCazv2Lc7Wa4M2xagkr4=;
        b=RxsiON16WezcQfW3S0PYark693ZAazCVc+Rj8QVMt5MxAsyWR0iS8GqSusHKuoNt6T
         6WUhmn8a/vkFrYR5j9WGBvpYGOlr/7Hufw4RirXCYc8jkYgi2+E08kxweNLgk0a6qkzV
         gK1PjplVb4NcoiN6yjdzYXCacFQdg8MEKQ3VRNOaHDgV2N7rW+CRQu5XcGbD8D9MAMPB
         0mYoFioEsEddat8q30YZ3V00fsEH0ipUnDgOMi1ZPft5Hwt3gcZeoPI1pb+KeRMNQxq1
         XW7ovk0qY0UUCUqk2a/StOaHUu50cMvXRo0vXLWSt+zD7J7saBjPZbzr5N/iyFBoRjYf
         rLZA==
X-Gm-Message-State: AOAM531aWpNwWAzgQMfAtW9aXGRz6Y1QwVwWo6YwBY8/wkCNJnojMZlA
        /qynD56Uu+zpY+dRU2/83TrAWY7dKWu+eDBmykZT9D2kc8IsDqYq8RQD422jaRjCMNokA3gE5/h
        YKHQKZt6DVw+6
X-Received: by 2002:a5d:4389:: with SMTP id i9mr20449594wrq.272.1612221914729;
        Mon, 01 Feb 2021 15:25:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy4HJP0YlL5i0Gxd468JQgYWduTKkfVlwthOeclSr3eUKT2z3XdRpKPsU0NR9y8yC+/NJR5iA==
X-Received: by 2002:a5d:4389:: with SMTP id i9mr20449577wrq.272.1612221914513;
        Mon, 01 Feb 2021 15:25:14 -0800 (PST)
Received: from redhat.com (bzq-79-177-39-148.red.bezeqint.net. [79.177.39.148])
        by smtp.gmail.com with ESMTPSA id z15sm27405334wrs.25.2021.02.01.15.25.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 15:25:13 -0800 (PST)
Date:   Mon, 1 Feb 2021 18:25:10 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        elic@nvidia.com, jasowang@redhat.com, mst@redhat.com
Subject: [GIT PULL] vdpa: bugfix
Message-ID: <20210201182510-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 19c329f6808995b142b3966301f217c831e7cf31:

  Linux 5.11-rc4 (2021-01-17 16:37:05 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 710eb8e32d04714452759f2b66884bfa7e97d495:

  vdpa/mlx5: Fix memory key MTT population (2021-01-20 03:47:04 -0500)

----------------------------------------------------------------
vdpa: bugfix

A single mlx bugfix.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Eli Cohen (1):
      vdpa/mlx5: Fix memory key MTT population

 drivers/vdpa/mlx5/core/mlx5_vdpa.h |  1 +
 drivers/vdpa/mlx5/core/mr.c        | 28 ++++++++++++----------------
 2 files changed, 13 insertions(+), 16 deletions(-)

