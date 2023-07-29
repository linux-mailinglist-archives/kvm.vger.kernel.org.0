Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC560768011
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 16:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbjG2OaU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 29 Jul 2023 10:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232032AbjG2OaS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 29 Jul 2023 10:30:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577A94497
        for <kvm@vger.kernel.org>; Sat, 29 Jul 2023 07:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690640951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=SX4oxMn7O+zU2fMjEDn1iEJQz6eway2vkVobt9BVYXxR+V4H+W8BqT4DeQMM90rnbuStIY
        S0hIZHqqRU5KemkyQOE6vN49gF/zClcfoZRpkl/G2LaYoBqY5EBWJ6kCjH+vQ8utn4GIMU
        fBTkhnTLo0xqyOOHsUMdPUhN8BLsl3U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-212-ku5uj0kdP6m3U7wTlt4j_g-1; Sat, 29 Jul 2023 10:29:07 -0400
X-MC-Unique: ku5uj0kdP6m3U7wTlt4j_g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B6B285A58A;
        Sat, 29 Jul 2023 14:29:07 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 20F44492B02;
        Sat, 29 Jul 2023 14:29:07 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Hao Peng <flyingpenghao@gmail.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: X86: Use GFP_KERNEL_ACCOUNT for pid_table in ipiv
Date:   Sat, 29 Jul 2023 10:29:04 -0400
Message-Id: <20230729142904.2689211-1-pbonzini@redhat.com>
In-Reply-To: <CAPm50aLxCQ3TQP2Lhc0PX3y00iTRg+mniLBqNDOC=t9CLxMwwA@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.

Paolo


