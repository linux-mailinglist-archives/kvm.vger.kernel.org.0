Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1990428E71A
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 21:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390293AbgJNTOu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Oct 2020 15:14:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21071 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390270AbgJNTOu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Oct 2020 15:14:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602702889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rI9Og6WXe8ERyQKhuGsm2wLNYwzxUYrIlHuAVicIZVM=;
        b=iiuqpSww7eg/76nFXVcJTzJNilQmw8cwwydAuopRhwjiVxEkC9EM3WGpGgzoO6FqYP8v34
        0JQhk0hL5y/Y8bpeiNi0uAAw08CHWOleB1uuyuGDwELMvmQoTd4X3sbMXLx9n5ZG+LKEEi
        4CXPdb/onE1f/CYMAvYCTMiQLiMY9R8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-35vkk8vDMc6w7vEJoMY7sg-1; Wed, 14 Oct 2020 15:14:47 -0400
X-MC-Unique: 35vkk8vDMc6w7vEJoMY7sg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DAB83E9001
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 19:14:46 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.195.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D27C5577C;
        Wed, 14 Oct 2020 19:14:45 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, thuth@redhat.com
Subject: [PATCH kvm-unit-tests 0/3] A few miscellaneous fixes
Date:   Wed, 14 Oct 2020 21:14:41 +0200
Message-Id: <20201014191444.136782-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While recently working on kvm-unit-tests I found a few bugs.
Posting the patches now since the series I'm working on may
not get merged for awhile.


Andrew Jones (3):
  lib/string: Fix getenv name matching
  scripts: Save rematch before calling out of for_each_unittest
  arm/arm64: Change dcache_line_size to ulong

 lib/arm/asm/processor.h   | 2 +-
 lib/arm/setup.c           | 2 +-
 lib/arm64/asm/processor.h | 2 +-
 lib/string.c              | 5 ++++-
 scripts/common.bash       | 4 +++-
 5 files changed, 10 insertions(+), 5 deletions(-)

-- 
2.26.2

