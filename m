Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69B4F424212
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 18:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbhJFQDW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 12:03:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22583 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239206AbhJFQDW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 12:03:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633536089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=OAkPYQUkRcg8PFHlT+Q0RqmnkuohhFQT31Nl0K9EecE=;
        b=WYUH9nt1GysoK9e7O+M8hScjSlP8s1YCDLHGRbfiw0enFM+Ky0acoaTwJwu9T83QKYbghV
        y+/Z5KZ7tw9QyWxVjVF+Fzzt8asmd6rpv9MpqLu+z3sy81yzvC6pgXHctosMnX+APGCbTc
        jGoV+OzTrVTL0dDuu9Xph7K78GvXs5o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-zyGo5ZYIOlS6hgqMT2aWjA-1; Wed, 06 Oct 2021 12:01:26 -0400
X-MC-Unique: zyGo5ZYIOlS6hgqMT2aWjA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4EB1F84A5E1;
        Wed,  6 Oct 2021 16:01:25 +0000 (UTC)
Received: from gondolin.fritz.box (unknown [10.39.193.118])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A7CEB6091B;
        Wed,  6 Oct 2021 16:01:23 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH 0/2] s390: downsize my responsibilities
Date:   Wed,  6 Oct 2021 18:01:18 +0200
Message-Id: <20211006160120.217636-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I currently don't have as much time to work on s390 things
anymore, so let's adjust some of my entries.

Cornelia Huck (2):
  KVM: s390: remove myself as reviewer
  vfio-ccw: step down as maintainer

 MAINTAINERS | 2 --
 1 file changed, 2 deletions(-)

-- 
2.31.1

