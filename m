Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5492C50856C
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 12:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359210AbiDTKFe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 06:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239989AbiDTKFU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 06:05:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9065C1EC58
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 03:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650448953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=aUjBfjbFyhbVyLjDIRpyF9w3MCebYWZ5pEOAMcqZbA7KGWtfTTFDZ2pPlU31HcpoRSTxaf
        Obxuc03kyRk6PTvSLWoZ4paoMHBygtoH2xQni0EyvfA3mc7GI2NGvOgupmEcjwYDgin6iW
        h3PdWRRPCS+40sm+JToWaekah2Zlv2Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-282-7lBzOQ9VO_uQDxTu84rUaw-1; Wed, 20 Apr 2022 06:02:32 -0400
X-MC-Unique: 7lBzOQ9VO_uQDxTu84rUaw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A5018038E3;
        Wed, 20 Apr 2022 10:02:31 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6C77C40D0166;
        Wed, 20 Apr 2022 10:02:31 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oupton@google.com>,
        syzbot+df6fbbd2ee39f21289ef@syzkaller.appspotmail.com
Subject: Re: [PATCH] KVM: Initialize debugfs_dentry when a VM is created to avoid NULL deref
Date:   Wed, 20 Apr 2022 06:02:30 -0400
Message-Id: <20220420100230.1093187-1-pbonzini@redhat.com>
In-Reply-To: <20220415004622.2207751-1-seanjc@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.

Paolo


