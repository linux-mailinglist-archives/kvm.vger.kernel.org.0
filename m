Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACFD13A2D9E
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 15:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbhFJOBn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 10:01:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29086 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230422AbhFJOBm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 10:01:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623333586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mKVrcSc+gpY1K9DdeeGIbcsbHCNAtzVPp6s0JFO9+sU=;
        b=H+TmODRJB9HaqgqGmXVny+VLt+vmI8jRIrlJd+fn23B0PvqKV5pvoM9/JBMEXsK7tPQVzf
        eQdSB/b6L8p13+CjcOFvqCnR1i+yQtMncaanQOBNwYN0d9B2G7kubgfw+pcXe2TeBA9HaN
        1EebrepK8Ec3akvy8kN7B2jdOYtTjbQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-YrQEi_Z8OD-6zV9y-_9mww-1; Thu, 10 Jun 2021 09:59:42 -0400
X-MC-Unique: YrQEi_Z8OD-6zV9y-_9mww-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C8259800D62
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 13:59:41 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-107.ams2.redhat.com [10.36.113.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B0621037E81;
        Thu, 10 Jun 2021 13:59:40 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [kvm-unit-tests PATCH 0/2] header guards: further cleanup
Date:   Thu, 10 Jun 2021 15:59:35 +0200
Message-Id: <20210610135937.94375-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Laurent had notices some further issues in my header guards series,
so I
- fixed some header guards I missed initially
- added header guards to some headers that actually define something
  (and don't just include another header)

I did not actually remove any header guards that might be unneeded.

Cornelia Huck (2):
  header guards: clean up some stragglers
  add header guards for non-trivial headers

 configure             | 4 ++--
 lib/argv.h            | 5 +++++
 lib/arm/asm/mmu-api.h | 4 ++--
 lib/arm/asm/mmu.h     | 6 +++---
 lib/arm/io.h          | 5 +++++
 lib/arm64/asm/mmu.h   | 6 +++---
 lib/pci.h             | 6 +++---
 lib/powerpc/io.h      | 5 +++++
 8 files changed, 28 insertions(+), 13 deletions(-)

-- 
2.31.1

