Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A60F04DA4C3
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 22:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351656AbiCOVrI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 17:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347782AbiCOVrH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 17:47:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C85F13CFD8
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 14:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647380753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=TMWlYfBFoHS2/7o7Ynfyizx0G8YqYPrV8iqUl9a8Ais4Lca8d68snKAYZF5toNPRU1QSxh
        ebUYjZrKgQaEpy3f1kJl2RCoVBlOeGV1Xnz73m4iJDFMgSGSRRsk1oKsrpvLNJnvrYwUsp
        RmnyANt2hgXL9aLgn4FJk1SAMHFnJUM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-LdWCWzAyPguxjOUBIZvQwg-1; Tue, 15 Mar 2022 17:45:50 -0400
X-MC-Unique: LdWCWzAyPguxjOUBIZvQwg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 40120185A7A4;
        Tue, 15 Mar 2022 21:45:50 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F3FE042D43C;
        Tue, 15 Mar 2022 21:45:49 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Ravi Bangoria <ravi.bangoria@amd.com>,
        Andi Kleen <ak@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: x86/pmu: Fix and isolate TSX-specific performance event logic
Date:   Tue, 15 Mar 2022 17:45:48 -0400
Message-Id: <20220315214548.2415349-1-pbonzini@redhat.com>
In-Reply-To: <20220309084257.88931-1-likexu@tencent.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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


