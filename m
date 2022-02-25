Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E90FD4C4273
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 11:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239591AbiBYKgw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 05:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239615AbiBYKgu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 05:36:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C1F0824FA02
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 02:36:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645785377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=cAm+dFNn771xkDY6QHufIXwXvhAWOLtxIryYk8gRG0tUIyGC5/nq/mQzWPO0+l9J5n5vkE
        fVmnY/wENoIPLNdp+sMKd0epCg3ppPZh1MuxuCfg21dpXcDAMfNF+dKJ5YGhyzAJVUJWdf
        u7xIuoDbdGCDyDrYf3M8X02GBrsk6TI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-acowaRhpO1SzPHVbAcN98Q-1; Fri, 25 Feb 2022 05:36:14 -0500
X-MC-Unique: acowaRhpO1SzPHVbAcN98Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4256F1091DA0;
        Fri, 25 Feb 2022 10:36:13 +0000 (UTC)
Received: from avogadro.lan (unknown [10.39.193.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E8812619D;
        Fri, 25 Feb 2022 10:36:11 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] x86/kvm: Don't waste memory if kvmclock is disabled
Date:   Fri, 25 Feb 2022 11:35:07 +0100
Message-Id: <20220225103507.483695-5-pbonzini@redhat.com>
In-Reply-To: 1645520523-30814-1-git-send-email-wanpengli@tencent.com
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.

Paolo


