Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D73961AB2DB
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 23:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442117AbgDOUpS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 16:45:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22712 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2442110AbgDOUpQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 16:45:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586983515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=FVXdUC3nRqfOSbJCPvdVOcmnkWtSfavnoYKnSEh27Xc=;
        b=SRaOOkfTATpDeE/fSLr+Y14pGYfFxdCS/Z1ien01bj1c3PlbAaFy43jM8QFB3guy/+Z3Bh
        yiGErvQYKn3Vhyu1XUl9YzVHOzqoRjzMrU1SicAg6ZEJAxNRUdf3uqhez7fb+5jKxLhj4o
        o49a5ML44ibPSXVPjnZ3EOCUrulorO0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-6Q5AUkr6P16CmMaFLJRvEA-1; Wed, 15 Apr 2020 16:45:13 -0400
X-MC-Unique: 6Q5AUkr6P16CmMaFLJRvEA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17C961005509;
        Wed, 15 Apr 2020 20:45:12 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-15.gru2.redhat.com [10.97.116.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 62EB15DA66;
        Wed, 15 Apr 2020 20:45:08 +0000 (UTC)
From:   Wainer dos Santos Moschetta <wainersm@redhat.com>
To:     pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     drjones@redhat.com, sean.j.christopherson@intel.com,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        krish.sadhukhan@oracle.com
Subject: [PATCH 0/1] selftests: kvm: Overlapped memory regions test
Date:   Wed, 15 Apr 2020 17:45:04 -0300
Message-Id: <20200415204505.10021-1-wainersm@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This introduces a test case to check memory slots with overlapped
regions on the guest address cannot be added. The cases checked
are described in the block comment upon test_overlap_memory_regions()
(see the patch 01).

I didn't see the need to calcute the addresses on compile/run-time, so I
just left them hard-coded (remember: aligned 1M to work on s390x).

It works on x86_64, aarch64, and s390x.

The patch is based on queue branch.

Ah, I did some cosmetic changes on test_add_max_memory_regions() too. If
it is not OK to be in a single patch...let me know.

Wainer dos Santos Moschetta (1):
  selftests: kvm: Add overlapped memory regions test

 .../selftests/kvm/set_memory_region_test.c    | 75 ++++++++++++++++++-
 1 file changed, 74 insertions(+), 1 deletion(-)

-- 
2.17.2

