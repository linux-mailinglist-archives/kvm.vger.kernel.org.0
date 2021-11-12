Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E22144E77B
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 14:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbhKLNki (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 08:40:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53325 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231436AbhKLNkh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Nov 2021 08:40:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636724266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=VMVREI3yVdsf2ovdI+J7x2HzME0riYpb5eDLjKNGwrM=;
        b=XR8lRuN+6tiIWeywNKD5UDFQ+x7XFMp07FfZzp3E5Y6gP6rUn7r6XYlD7ZgnOYeNwismHn
        JB/UOKJR+um2ybMN7/yCoSa1H5bmDmfd55j6/L3IiGJaWDPv7psN0/mgYQIM8y1JOI5o4l
        2aif8mMZEM6tyE4nUIpt5tP8DVyAXzo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-JyusRFMaNCOZZaSi6_V5Yg-1; Fri, 12 Nov 2021 08:37:43 -0500
X-MC-Unique: JyusRFMaNCOZZaSi6_V5Yg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A6D0B8799E0;
        Fri, 12 Nov 2021 13:37:42 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.194.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E145A78B20;
        Fri, 12 Nov 2021 13:37:40 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, thuth@redhat.com, marcorr@google.com,
        zxwang42@gmail.com
Subject: [PATCH kvm-unit-tests 0/2] Groups are separated by spaces
Date:   Fri, 12 Nov 2021 14:37:37 +0100
Message-Id: <20211112133739.103327-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I wrote these patches quite a while ago and forgot to send them. Sending
now, now that I rediscovered them.

Andrew Jones (2):
  unittests.cfg: groups should be space separated
  runtime: Use find_word with groups

 README.md            | 2 +-
 arm/unittests.cfg    | 2 +-
 scripts/runtime.bash | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.31.1

