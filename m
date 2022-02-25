Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD854C41E3
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 11:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239084AbiBYKAA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 05:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239288AbiBYJ76 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 04:59:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6226E195323
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 01:59:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645783166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=WGq8M13NbjCpWC6Op/MaW4uiFq+u225fpBJ8hYFCkkXcyfrC9bnxjoBGkuJf1J+Wy2X/W0
        /XWtdhodiPX8mtz9jE20PGvraOy35Z64JwffkV66EEnYy94fWl1syXXk4YRrJ9AeXouGWT
        hE0a5xagsK1+Ki8bkJijCRVglYH3QA8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-0ZyelL3mM5-L5JHtWGBSmQ-1; Fri, 25 Feb 2022 04:59:25 -0500
X-MC-Unique: 0ZyelL3mM5-L5JHtWGBSmQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD899FC81;
        Fri, 25 Feb 2022 09:59:23 +0000 (UTC)
Received: from avogadro.lan (unknown [10.39.193.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D2F27B6C5;
        Fri, 25 Feb 2022 09:59:20 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH] KVM: x86: Reacquire kvm->srcu in vcpu_run() if exiting on pending signal
Date:   Fri, 25 Feb 2022 10:59:07 +0100
Message-Id: <20220225095907.478995-4-pbonzini@redhat.com>
In-Reply-To: 20220224190609.3464071-1-seanjc@google.com
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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


