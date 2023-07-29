Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B09B76801C
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 16:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbjG2OmL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 29 Jul 2023 10:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjG2OmJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 29 Jul 2023 10:42:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 691BB184
        for <kvm@vger.kernel.org>; Sat, 29 Jul 2023 07:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690641684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aaTO3QaD0GOGejnY8pM7Ukf0/a4v5tcRx0wJoosgtPY=;
        b=FScCKuH14W66Rdxi9ITtTuptocvgXvU54xCMbM2UtVGl/AxgTx2linFWpj1b5V9aEaNDuY
        4TTYwTbhM5QixX+N56n3800nSNBYHi7+4ypW32Ss79qoQZ3kRijYuJcaWlR5CRla/6sKbH
        LKSBaPwwd5AWZ7aSahY51oSzQBR0UX4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-578-lS-0MUq6PXGDRiHimjLmgw-1; Sat, 29 Jul 2023 10:41:20 -0400
X-MC-Unique: lS-0MUq6PXGDRiHimjLmgw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7EBB2858EED;
        Sat, 29 Jul 2023 14:41:19 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F83640C2063;
        Sat, 29 Jul 2023 14:41:19 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/irq: Conditionally register IRQ bypass consumer again
Date:   Sat, 29 Jul 2023 10:40:43 -0400
Message-Id: <20230729144042.2689788-1-pbonzini@redhat.com>
In-Reply-To: <20230724111236.76570-1-likexu@tencent.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.  I tweaked the commit message to explain
that originally commit 14717e203186 disabled registration
of the consumer on AMD machines.

Paolo


