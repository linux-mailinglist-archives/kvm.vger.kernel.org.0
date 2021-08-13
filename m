Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 365A03EB46D
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 13:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240255AbhHMLM6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 07:12:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29083 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239980AbhHMLM5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 07:12:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628853150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=F6vr0In16m9rgXZ2xn6s5MTMIkxvuXnfj2L7XMux6kg=;
        b=JEeP4pSe8eVbo85vM+7l6X87Hj6s9rrsJtT1LzIEhkI1ctKE/5ucBecBcVYVaxBG81x+mZ
        URNEES9uFj9j9EQI3+LYdms7Rz4axZiNsrq3kvzpu9qOsu99E0YXEVaipIblTGP7keoo19
        3NZInRmhrBnqBw8aRCVh/YoX54rsDVw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-IqI2jWeTP9O2w2xWES_4pQ-1; Fri, 13 Aug 2021 07:12:27 -0400
X-MC-Unique: IqI2jWeTP9O2w2xWES_4pQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53E9187D542;
        Fri, 13 Aug 2021 11:12:26 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1368C60C04;
        Fri, 13 Aug 2021 11:12:26 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     babu.moger@amd.com
Subject: [PATCH kvm-unit-tests 0/2] access: cut more execution time on reserved bit tests
Date:   Fri, 13 Aug 2021 07:12:23 -0400
Message-Id: <20210813111225.3603660-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cut execution time by another 25%, from ~4 minutes to 2:40.

Paolo Bonzini (2):
  access: optimize check for multiple reserved bits
  access: treat NX as reserved if EFER.NXE=0

 x86/access.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

-- 
2.27.0

