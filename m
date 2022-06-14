Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5A4B54B6AF
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 18:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244902AbiFNQsC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 12:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344596AbiFNQrc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 12:47:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A9D3429362
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 09:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655225249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rsUXNxFSBPJLxuuSCdHvqhX854mWpjHL8UsxKW4ByL0=;
        b=EbGYCiYLWhJVDK70zfMQK3wWi5vbgtNhoJIc/gSWut3et0CM+G8rLmwlyJHZt/OYLNX8gM
        kUyWNLBkNWDN+UYRAhB/uoeYiBmw4ntcrdvleCsUe6AAjXympTOu/lICDaVodPKrs18Egj
        BiRxFjJWfhL9MgMnWHhqe8y2uHtbVm4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-MS9h4F77NrizwH_ULY9kHA-1; Tue, 14 Jun 2022 12:47:25 -0400
X-MC-Unique: MS9h4F77NrizwH_ULY9kHA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D210B299E75E;
        Tue, 14 Jun 2022 16:47:24 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C66E492CA2;
        Tue, 14 Jun 2022 16:47:24 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Tom Rix <trix@redhat.com>,
        kvm@vger.kernel.org, llvm@lists.linux.dev,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>
Subject: Re: [PATCH] KVM: SVM: Hide SEV migration lockdep goo behind CONFIG_DEBUG_LOCK_ALLOC
Date:   Tue, 14 Jun 2022 12:47:04 -0400
Message-Id: <20220614164703.1619648-1-pbonzini@redhat.com>
In-Reply-To: <20220613214237.2538266-1-seanjc@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.

For what it's worth, GCC also produces the warning with "make W=1".

Paolo


