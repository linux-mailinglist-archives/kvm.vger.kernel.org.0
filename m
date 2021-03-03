Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B663F32C615
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346655AbhCDA1Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:27:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60974 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346563AbhCCNK5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Mar 2021 08:10:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614776970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vBkU9PYoHb2RYR75LHHbOZBics9l/7QqXUZvwkT/bfc=;
        b=ILksb5JztHqlO4/wbhCeUbuR9IxsA3yLW/spCtgHekL79Dp2qagJXNFjszhBKJNuxFm0+G
        cC3XX8hhcEFiyTFJZcvDq4kYDSTLk44TJOibnPPcrTuzUo1oIz4Wo0UPEAnz4tL8KWhgdP
        VrZ78CbVDeNbZVI5cwDpAOWvjj79m+g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-HiyUce2xNGa5IYeQ4WiPqg-1; Wed, 03 Mar 2021 08:09:28 -0500
X-MC-Unique: HiyUce2xNGa5IYeQ4WiPqg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08BA6100B3B0;
        Wed,  3 Mar 2021 13:09:27 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-112-28.ams2.redhat.com [10.36.112.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 51E8060BFA;
        Wed,  3 Mar 2021 13:09:17 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Thomas Huth <thuth@redhat.com>
Subject: [PATCH v1 0/2] Get rid of legacy_s390_alloc() and phys_mem_set_alloc()
Date:   Wed,  3 Mar 2021 14:09:14 +0100
Message-Id: <20210303130916.22553-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's finally get rid of the alternative allocation function. Outcome of
a discussion in:
    https://lkml.kernel.org/r/20210303123517.04729c1e.cohuck@redhat.com

David Hildenbrand (2):
  s390x/kvm: Get rid of legacy_s390_alloc()
  exec: Get rid of phys_mem_set_alloc()

 include/sysemu/kvm.h |  4 ----
 softmmu/physmem.c    | 36 +++---------------------------------
 target/s390x/kvm.c   | 43 +++++--------------------------------------
 3 files changed, 8 insertions(+), 75 deletions(-)

-- 
2.29.2

