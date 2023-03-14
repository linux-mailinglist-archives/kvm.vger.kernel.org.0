Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87FFD6B96B4
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 14:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbjCNNrg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 09:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232402AbjCNNrL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 09:47:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A213B872
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 06:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678801397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=YUIf/4BKRtkZDE71i3EdFZ7WtLL8GJOJ82BbbOPM839SwklgGaMB7uZhv1X+9kdCbHLLrs
        GlQOovPUx2KQu/C2CI20GsWvPnG3gFcUUJLa4gY4ss1w+gkR09X/qeqsBwF5bGj+8wYO6a
        GVQR5GEjlLsa/DcsW1fp9j70uhhbmFM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-224-hX2O_XCeNy6zWm_XlLU5hg-1; Tue, 14 Mar 2023 09:43:14 -0400
X-MC-Unique: hX2O_XCeNy6zWm_XlLU5hg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1F209101A55E;
        Tue, 14 Mar 2023 13:43:14 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EEBC151FF;
        Tue, 14 Mar 2023 13:43:13 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw@amazon.co.uk>
Subject: Re: [PATCH v2 0/4] KVM: selftests: xen_shinfo cleanups and slowpath test
Date:   Tue, 14 Mar 2023 09:43:13 -0400
Message-Id: <20230314134313.3053279-1-pbonzini@redhat.com>
In-Reply-To: <20230204024151.1373296-1-seanjc@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.

Paolo


