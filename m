Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3B04559476
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 10:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbiFXH6b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 03:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbiFXH61 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 03:58:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8A1D413E8B
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 00:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656057502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=B6Apgxw/IrS3EVG0Nnh8kXVlDxbY7/qyTBwI1KP49LoYrfiJV0QSxkeXKv7SyxiiSnZq6s
        ZczZ4iAQoCOIfaP8PTQy5L/sXZbmxuvAd5eYo6PeUPsgCMkRN214JRvJSLbFTvJhAx5qUC
        RHfa4NSDXrH5ZlqBeMHi4P4RI23/GRQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-384-iVh-vAXKMCOyrOZG3vevWQ-1; Fri, 24 Jun 2022 03:58:18 -0400
X-MC-Unique: iVh-vAXKMCOyrOZG3vevWQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 24BAD3C0D188;
        Fri, 24 Jun 2022 07:58:18 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 98C1C1121314;
        Fri, 24 Jun 2022 07:58:17 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/svm: add __GFP_ACCOUNT to __sev_dbg_{en,de}crypt_user()
Date:   Fri, 24 Jun 2022 03:58:13 -0400
Message-Id: <20220624075813.2720462-1-pbonzini@redhat.com>
In-Reply-To: <20220623171858.2083637-1-mizhang@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.

Paolo


