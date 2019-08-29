Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFEBA11BB
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 08:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbfH2G07 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 02:26:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49184 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfH2G07 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 02:26:59 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 879778980F6
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2019 06:26:59 +0000 (UTC)
Received: from thuth.com (ovpn-116-53.ams2.redhat.com [10.36.116.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 17FBC194B9;
        Thu, 29 Aug 2019 06:26:53 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Drew Jones <drjones@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PATCH] Update travis.yml to use bionic instead of trusty
Date:   Thu, 29 Aug 2019 08:26:50 +0200
Message-Id: <20190829062650.19325-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Thu, 29 Aug 2019 06:26:59 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ubuntu "trusty" is out of service, and at least for me, the Travis
jobs for kvm-unit-tests are failing because they can not find the
repositories anymore. Thus use a newer version of Ubuntu to do the
CI testing.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .travis.yml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/.travis.yml b/.travis.yml
index b06c33c..a4a165d 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -1,5 +1,5 @@
 sudo: false
-dist: trusty
+dist: bionic
 language: c
 compiler:
   - gcc
-- 
2.18.1

