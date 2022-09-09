Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD2A5B35F5
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 13:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbiIILCJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 07:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiIILBr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 07:01:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFD1139AF7
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 04:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662721259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=s7r37HYigu2X97YLwHEdM4f5sKBhrEueO8Ol64hNJ+U=;
        b=dKS7BBj3eoYjUCtURRsXNewYH8jwDUzH3C8IOJHBvssIx080kefY/z/Lomr96/bYWplFXM
        f+kpO5S4AJbPNAi1zIqfm2mtHjEPkwhGqCR4ANZHPqCE7f4sDpT0BynGNooopmj8vWHMBL
        Xu4Kc56UQkylVkwz8QRWrfCagzS37nE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-532-NDDohuehOk2qew61_7ZepA-1; Fri, 09 Sep 2022 07:00:56 -0400
X-MC-Unique: NDDohuehOk2qew61_7ZepA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 030A185A58C;
        Fri,  9 Sep 2022 11:00:56 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA08F2166B26;
        Fri,  9 Sep 2022 11:00:36 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [RFC PATCH 0/1] accel/kvm: implement KVM_SET_USER_MEMORY_REGION_LIST
Date:   Fri,  9 Sep 2022 07:00:33 -0400
Message-Id: <20220909110034.740282-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the new KVM ioctl KVM_SET_USER_MEMORY_REGION_LIST.
Based on my QEMU serie "[RFC PATCH v2 0/3] accel/kvm: extend kvm memory listener to support".

Based-on: 20220909081150.709060-1-eesposit@redhat.com

Requires my KVM serie "[RFC PATCH 0/9] kvm: implement atomic memslot updates"
https://lkml.org/lkml/2022/9/9/533

Emanuele Giuseppe Esposito (1):
  kvm/kvm-all.c: implement KVM_SET_USER_MEMORY_REGION_LIST ioctl

 accel/kvm/kvm-all.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

-- 
2.31.1

