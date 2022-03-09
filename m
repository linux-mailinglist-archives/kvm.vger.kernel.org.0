Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF44C4D360C
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 18:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237031AbiCIRPt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 12:15:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238404AbiCIROT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 12:14:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF25112F412
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 09:09:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646845773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Z7l/xDj4zR793YWwmTzG872Z4EQ0qUiIYr9YimYADHc=;
        b=IBEMqPKsj8444VpRcDimpDvRWy6MV9jw0NcKooAqMQVAtYOuXfuBXlJ4lTMkO0LNmR1fED
        6iSjR8MxuJr2cC7hREjdaC5wB6DkLSqxJE4sNrTX+RO8rbgIewQLfr2iJ4sIrLW87THnwc
        q5YTvAqgOI6b6j3yInqP0p00Z2IiCTU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-kqkdZMLKNZC7FCoE81vQNg-1; Wed, 09 Mar 2022 12:09:30 -0500
X-MC-Unique: kqkdZMLKNZC7FCoE81vQNg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 38323801AFE;
        Wed,  9 Mar 2022 17:09:29 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C62F886B8F;
        Wed,  9 Mar 2022 17:09:28 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, jmattson@google.com
Subject: [PATCH 0/2] KVM: x86: add support for CPUID leaf 0x80000021
Date:   Wed,  9 Mar 2022 12:09:26 -0500
Message-Id: <20220309170928.1032664-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CPUID leaf 0x80000021 defines some features (or lack of bugs) of AMD
processors.  This small series implements it, and also synthesizes
for use on processors that do not have the "Null selector clear base"
erratum but do not support the leaf 0x80000021 either.

Paolo

Paolo Bonzini (2):
  KVM: x86: add support for CPUID leaf 0x80000021
  KVM: x86: synthesize CPUID leaf 0x80000021h if useful

 arch/x86/kvm/cpuid.c | 44 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

-- 
2.31.1

