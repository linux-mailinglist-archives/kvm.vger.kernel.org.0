Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65810655316
	for <lists+kvm@lfdr.de>; Fri, 23 Dec 2022 18:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbiLWRJK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Dec 2022 12:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbiLWRJI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Dec 2022 12:09:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A83245
        for <kvm@vger.kernel.org>; Fri, 23 Dec 2022 09:08:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671815302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=WbAgH+4FeqSduBvTVJV4RWKQ+yi5pgMRKiABTRXXuvj1SvI3p5Ub9iWMFM5kqfa8DTPVZt
        l9iybRqxj1WFWdwyt8urIc2vGqetUE1AG0DnoBG1qV/wWy+p5c7xcWvvKoTQF91W+72fdE
        snfGW5g54aEbEmoAGCKmZKejFxykPPs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-179-FKgNEwA2McK3rD07IYV0lw-1; Fri, 23 Dec 2022 12:08:21 -0500
X-MC-Unique: FKgNEwA2McK3rD07IYV0lw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D1C7738041DB;
        Fri, 23 Dec 2022 17:08:20 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A860240ED784;
        Fri, 23 Dec 2022 17:08:20 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        coverity-bot <keescook@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: x86: hyper-v: Fix 'using uninitialized value' Coverity warning
Date:   Fri, 23 Dec 2022 12:08:18 -0500
Message-Id: <20221223170818.1622313-1-pbonzini@redhat.com>
In-Reply-To: <20221208102700.959630-1-vkuznets@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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


