Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C5023DE22
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 19:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729896AbgHFRP3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 13:15:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36429 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730259AbgHFRPZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 13:15:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596734119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qmd9lA9V2WmAck1ZMV5IDD4q2AP3yXBJ6bMUOiVD5uI=;
        b=BWcz/RKuFOJf/sXrHyD8waAr/wpfp+449wNTo1OU8LC7Q5ju+sJnPvooeLXBO994LBXtkR
        LpRLZPi38RHBP2Gdy2gzMeDwx+a/fdvnPS7j+sdK9GcEaeywrHj0PKclT9m/t8z4aJDxoC
        pmkU2RQpcZ48dC2Lz1jDEl0DqKTux20=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-v-66GkEwOIScLzrzmawPAw-1; Thu, 06 Aug 2020 08:44:18 -0400
X-MC-Unique: v-66GkEwOIScLzrzmawPAw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1764E52AB7
        for <kvm@vger.kernel.org>; Thu,  6 Aug 2020 12:44:08 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-114-17.ams2.redhat.com [10.36.114.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 429F65C1BD;
        Thu,  6 Aug 2020 12:44:03 +0000 (UTC)
From:   Mohammed Gamal <mgamal@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Mohammed Gamal <mgamal@redhat.com>
Subject: [kvm-unit-tests PATCH 0/3] x86: Add guest physical bits tests
Date:   Thu,  6 Aug 2020 14:43:55 +0200
Message-Id: <20200806124358.4928-1-mgamal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series re-enables the guest physical bits tests, in addition
timeouts are also tweaked for AMD without NPT enabled, and the tests are
also disabled on AMD with NPT enabled, since we aren't able to support them
properly due to the way CPUs set PTE bits on NPT VM exits

Mohammed Gamal (3):
  unittests.cfg: Increase timeout for access test
  x86/access: Skip running guest physical bits tests on AMD with NPT
    enabled
  Revert "access: disable phys-bits=36 for now"

 x86/access.c      | 8 ++++++++
 x86/unittests.cfg | 3 ++-
 2 files changed, 10 insertions(+), 1 deletion(-)

-- 
2.26.2

