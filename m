Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87FC0A7E5F
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 10:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728448AbfIDIwJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 04:52:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46010 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbfIDIwI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 04:52:08 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C67233082E20;
        Wed,  4 Sep 2019 08:52:08 +0000 (UTC)
Received: from thuth.com (ovpn-116-69.ams2.redhat.com [10.36.116.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A421600CD;
        Wed,  4 Sep 2019 08:52:04 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] KVM: s390: Check for invalid bits in kvm_valid_regs and kvm_dirty_regs
Date:   Wed,  4 Sep 2019 10:51:58 +0200
Message-Id: <20190904085200.29021-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Wed, 04 Sep 2019 08:52:08 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Avoid invalid bits in kvm_valid_regs and kvm_dirty_regs on s390x.

v2:
 - Split the single patch from v1 into two separate patches
   (I've kept the Reviewed-bys from v1, but if you don't agree with the
    patch description of the 2nd patch, please complain)

Thomas Huth (2):
  KVM: s390: Disallow invalid bits in kvm_valid_regs and kvm_dirty_regs
  KVM: selftests: Test invalid bits in kvm_valid_regs and kvm_dirty_regs
    on s390x

 arch/s390/include/uapi/asm/kvm.h              |  6 ++++
 arch/s390/kvm/kvm-s390.c                      |  4 +++
 .../selftests/kvm/s390x/sync_regs_test.c      | 30 +++++++++++++++++++
 3 files changed, 40 insertions(+)

-- 
2.18.1

