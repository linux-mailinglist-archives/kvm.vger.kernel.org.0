Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2C75594DA
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 10:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbiFXIGx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 04:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbiFXIGn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 04:06:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C2A5674E75
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 01:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656057944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=da9TkxTSqAd8mOJfLbmpqFuMnCRvtxeAfCR5vmwkobhhHiaC2KRwoy/voSMVgfv7EXwG6E
        ZH79ITW1lyH0JQCDXbI2qNZj5V+YJALOQTKq+ZntHuYmZ0kRuF1i9hn9Xum06A33KNWu1M
        lkEjzVT3VLPMxzQTnCZg3Upf+fLAGnM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-263-Qyj2W5XcPpqFURNIJGTQaw-1; Fri, 24 Jun 2022 04:05:41 -0400
X-MC-Unique: Qyj2W5XcPpqFURNIJGTQaw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F39FC101E167;
        Fri, 24 Jun 2022 08:05:40 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C22012166B26;
        Fri, 24 Jun 2022 08:05:40 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Shuah Khan <shuah@kernel.org>, Gao Chao <chao.gao@intel.com>,
        linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: selftest: Enhance handling WRMSR ICR register in x2APIC mode
Date:   Fri, 24 Jun 2022 04:05:35 -0400
Message-Id: <20220624080535.2720845-1-pbonzini@redhat.com>
In-Reply-To: <20220623094511.26066-1-guang.zeng@intel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.

Paolo


