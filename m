Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 186A0758BF8
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 05:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbjGSDUN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 23:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjGSDUM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 23:20:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8EA91BDB
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 20:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689736770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=khu8dsP1eNtDOWLTOwMXhcur87DLm12aw9cZwTUOwUM=;
        b=jVuBFTLx7OACyoUL4eVBV84DJjytHkwA3xXHDGh0c0tKhXBl1KpGDVQW/Jqp5RDfRDNolX
        yfKECpILyaXY1MrjllwwFoqj6kTHECXtz7lBX8lrVOMkqSF80i8jCjAL2cf57cQDyrC6lZ
        gsoz5/UbKbF/DzSLc/J/zQyusq5wn7c=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-127-RAjSCbZIPrGg3qdaq6QUbg-1; Tue, 18 Jul 2023 23:19:28 -0400
X-MC-Unique: RAjSCbZIPrGg3qdaq6QUbg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 125043804504;
        Wed, 19 Jul 2023 03:19:28 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EB1104CD0F8;
        Wed, 19 Jul 2023 03:19:27 +0000 (UTC)
From:   Shaoqin Huang <shahuang@redhat.com>
To:     andrew.jones@linux.dev
Cc:     Shaoqin Huang <shahuang@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 0/2] arm64: Define name for the original RES1 bit but now functinal bit
Date:   Tue, 18 Jul 2023 23:19:24 -0400
Message-Id: <20230719031926.752931-1-shahuang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According the talk[1], because the architecture get updated, what used to be a
RES1 bit becomes a functinal bit. So we can define the name for these bits, this
also increase the readability.

[1] lore.kernel.org/ZLZQ6r4-9mVdg4Ry@monolith.localdoman

Shaoqin Huang (2):
  arm64: Replace the SCTLR_EL1 filed definition by _BITUL()
  arm64: Define name for the bits used in SCTLR_EL1_RES1

 lib/arm64/asm/sysreg.h | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

-- 
2.39.1

