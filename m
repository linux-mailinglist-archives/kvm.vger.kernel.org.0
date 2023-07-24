Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4250575ECAB
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 09:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbjGXHlK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 03:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbjGXHk6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 03:40:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29700187
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 00:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690184412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=VUFdjV8PorXzgyBYbzZbuwBKjrzFWv5AGRDAvUDIsRY=;
        b=YNGL7KQOZh1j3w7Koy2eN1cAlKMI2Lzde8GNd49JeD4LiykLHJiHBMWqzgnWTzZGAt0DhA
        tZ1DmfhxRVJVclCCxey9X71iXAiycVTaTA2crdTAn5MRilzgKa1M4+K2aVYzPU7ePPsRNp
        0O9/KnTIlJ7Z21WgUI5exavLqSFlyvU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-536-9fDtQRixNRG1-7pa52odOQ-1; Mon, 24 Jul 2023 03:40:08 -0400
X-MC-Unique: 9fDtQRixNRG1-7pa52odOQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CBCBA8A31A2;
        Mon, 24 Jul 2023 07:40:07 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A0D44200BA63;
        Mon, 24 Jul 2023 07:40:07 +0000 (UTC)
From:   Shaoqin Huang <shahuang@redhat.com>
To:     andrew.jones@linux.dev
Cc:     Shaoqin Huang <shahuang@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 0/2] arm64: Define name for the original RES1 bit but now functinal bit
Date:   Mon, 24 Jul 2023 03:39:46 -0400
Message-Id: <20230724073949.1297331-1-shahuang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According the talk[1], because the architecture get updated, what used to be a
RES1 bit becomes a functinal bit. So we can define the name for these bits, this
also increase the readability.

[1] lore.kernel.org/ZLZQ6r4-9mVdg4Ry@monolith.localdoman

v1:
https://lore.kernel.org/all/20230719031926.752931-1-shahuang@redhat.com/
Thanks, Eric for the suggestions:
- Rephrase the commit title in patch 1.
- Use the _BITULL().
- Delete the SCTLR_EL1_RES1 and unwind its definition into
INIT_SCTLR_EL1_MMU_OFF.

Shaoqin Huang (2):
  arm64: Use _BITULL() to define SCTLR_EL1 bit fields
  arm64: Define name for these bits used in SCTLR_EL1

 lib/arm64/asm/sysreg.h | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

-- 
2.39.1

