Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 904184D1C52
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 16:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348008AbiCHPw3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 10:52:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347920AbiCHPw3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 10:52:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E16F24F469
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 07:51:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646754692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=H2neXkxGNEc4b7pZVYO2vK4xXAqlNj1gQ2keJkOlVxuwthvwfSUPVMJJMdaooRczjE2ss6
        bF2mHOlehWQfsoa3cpAXFPkh7siSX4CmCB87/yZfwsAbxRMOrED6ILU04fc78TjVxq9g70
        zVm0mBwXZj+PX4yy+rGN5KP3szVcNPE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-185-QHVBMGK-Nq6GQL_r1Q9ZZw-1; Tue, 08 Mar 2022 10:51:28 -0500
X-MC-Unique: QHVBMGK-Nq6GQL_r1Q9ZZw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A9CEFC82;
        Tue,  8 Mar 2022 15:51:27 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D92307BCDA;
        Tue,  8 Mar 2022 15:51:26 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] KVM: SVM: Fix kvm_cache_regs.h inclusions for is_guest_mode()
Date:   Tue,  8 Mar 2022 10:51:21 -0500
Message-Id: <20220308155121.777714-1-pbonzini@redhat.com>
In-Reply-To: <20220304161032.2270688-1-pgonda@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

Queued, thanks.

Paolo


