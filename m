Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58D3858ED13
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 15:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbiHJNYq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 09:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232233AbiHJNYk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 09:24:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4E8432A727
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 06:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660137878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kg+212SwqPQ85DhNxlglluD+rOqSDfNrGpQk6wrs2ag=;
        b=HO21nXmIkTSPvkfYZTHWNNd/Oj+WB+bznLceUnN2n/2D705XFBCOJm49/ZaguJ27CEYwmw
        LQGGpQqeF6PPTW8MykVGeFB8gsQf8sFeWmD/03hPMnYPfEm7gZO1Li55d+QeSxtsVuwVqW
        Djhdi4WjI1GD/SOKjxZb5TLwpF4cfSY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473--hyYnYL3PiGnorxBwyRBFw-1; Wed, 10 Aug 2022 09:24:37 -0400
X-MC-Unique: -hyYnYL3PiGnorxBwyRBFw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9025380231E;
        Wed, 10 Aug 2022 13:24:36 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6D9301121314;
        Wed, 10 Aug 2022 13:24:36 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH 0/3] KVM: x86: Intel PERF_CAPABILITIES fix and cleanups
Date:   Wed, 10 Aug 2022 09:24:00 -0400
Message-Id: <20220810132359.322831-1-pbonzini@redhat.com>
In-Reply-To: <20220727233424.2968356-1-seanjc@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.  The patches have been out for almost two weeks and,
based on the thread, any other cleanups/fixes can be one on top
(particularly the feature MSR one).

Paolo


