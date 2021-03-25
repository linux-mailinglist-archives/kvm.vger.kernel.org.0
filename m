Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D13349638
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 16:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbhCYP51 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 11:57:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51536 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229695AbhCYP5H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 11:57:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616687825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=lD6wjnjJ9XnwU0ytJNLAVFancBc+NQ/9UGYPYbmVH8g=;
        b=hiEBl7K5lPTA1XywhnGkAo/2Wb/zZkBK+Yl8jGb6/8Z3NebLPMUHzNgGSrKUcEb/+PBpQb
        f+C/m+itT+oggk+HKRS7elJ/V33JzHr8wHCLQIMQUAWetEpVWWrAMPnYE1/Q/jA+0/Jjqc
        livwXHF3F52cnqk9XVrTDEi2YKkHq6c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-ZFRVf2SKM9KBOAqVfpB-oQ-1; Thu, 25 Mar 2021 11:57:01 -0400
X-MC-Unique: ZFRVf2SKM9KBOAqVfpB-oQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B31D7807904;
        Thu, 25 Mar 2021 15:57:00 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E9B3E5D749;
        Thu, 25 Mar 2021 15:56:58 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     nikos.nikoleris@arm.com, alexandru.elisei@arm.com
Subject: [PATCH kvm-unit-tests 0/2] arm64: One fix and one improvement
Date:   Thu, 25 Mar 2021 16:56:55 +0100
Message-Id: <20210325155657.600897-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix the loading of argc. Nikos reported an issue with its alignment
while testing target-efi (aligned to four bytes is OK, as long as we
only load four bytes like we should). Also, take a patch developed
while working on target-efi which can make debugging a bit more
convenient (by doing some subtraction for the test developer).

Andrew Jones (2):
  arm64: argc is an int
  arm64: Output PC load offset on unhandled exceptions

 arm/cstart64.S        | 2 +-
 arm/flat.lds          | 1 +
 lib/arm64/processor.c | 7 +++++++
 3 files changed, 9 insertions(+), 1 deletion(-)

-- 
2.26.3

