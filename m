Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5E494C41E2
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 11:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239305AbiBYKAB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 05:00:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239295AbiBYJ77 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 04:59:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 89B7F235308
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 01:59:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645783166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=ekfzpjy7PjJZzws1nFzBO6u8OrBKSt6RdIStSP8S9sjxIjjUs9KJ2erjgv/1uMLH/lsya5
        IGbR6hjSw0EdfwtQq5zNGc3V+3+Q0serSzPWmRoL3K+St3kfaNo2VXi4rmuzPekKnI4U2R
        IiHJ4NG796ZGz/Nz41ZyAFxLj8pnDLo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-231--NNTKHDeMnGT8LgT246Qkg-1; Fri, 25 Feb 2022 04:59:21 -0500
X-MC-Unique: -NNTKHDeMnGT8LgT246Qkg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DBBEA804311;
        Fri, 25 Feb 2022 09:59:19 +0000 (UTC)
Received: from avogadro.lan (unknown [10.39.193.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 808987B6D4;
        Fri, 25 Feb 2022 09:59:17 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH] KVM: x86: Temporarily drop kvm->srcu when uninitialized vCPU is blocking
Date:   Fri, 25 Feb 2022 10:59:06 +0100
Message-Id: <20220225095907.478995-3-pbonzini@redhat.com>
In-Reply-To: 20220224212646.3544811-1-seanjc@google.com
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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

