Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D401F42C696
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 18:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbhJMQpJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 12:45:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49502 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232459AbhJMQpI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 12:45:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634143384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/e6cfVxkr5vPKsiEU+j3LjXGhBNwH7w08o08DYnXwoo=;
        b=dX+CWd51vgSAX7CQ9WXF3DjeVU76ueWBMt1LPz6wG61I6vPj5ZvmP9hqQu9Yx/rHxoJXsU
        zp0offdc3fkDGwDpg8QuxcMF/tQynHsziQ0iONzsevzXu6E4WjPMozR4ZS2Rf/cE6S7Ay1
        Dz9aTeb3/4GFeBWhdz/GVU4kXnrL8D4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-dhBpKgvyPSi646gr1HAAQg-1; Wed, 13 Oct 2021 12:43:03 -0400
X-MC-Unique: dhBpKgvyPSi646gr1HAAQg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45019101B4A9;
        Wed, 13 Oct 2021 16:43:02 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.192.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D18345DA60;
        Wed, 13 Oct 2021 16:43:00 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, thuth@redhat.com, ahmeddan@amazon.com
Subject: [PATCH kvm-unit-tests 0/2] Introduce strtoll/strtoull
Date:   Wed, 13 Oct 2021 18:42:57 +0200
Message-Id: <20211013164259.88281-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A recent posting by Daniele Ahmed inspired me to write a patch adding
strtoll/strtoull. While doing that I noticed check_mul_overflow wasn't
working and found copy+paste errors with it and check_sub_overflow.

Andrew Jones (2):
  compiler.h: Fix typos in mul and sub overflow checks
  lib: Introduce strtoll/strtoull

 lib/linux/compiler.h |  4 ++--
 lib/stdlib.h         |  2 ++
 lib/string.c         | 51 ++++++++++++++++++++++++++++++++------------
 3 files changed, 41 insertions(+), 16 deletions(-)

-- 
2.31.1

