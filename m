Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4F484E47E9
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 21:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiCVU7A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 16:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiCVU67 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 16:58:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 800F825C6E
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 13:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647982649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZFOIWCfiW5FFrVsIemo3EMJNkTkxh5cnHQBDMq/mWQI=;
        b=IG+eWhjQLnNoWIPDepvrvJexrKEnLJze3WQJnBEucw9ajZzuwQVM5EtM4vmmgo8zOe43An
        eOCBB8kfXtlaM8zB3t1QUtCkolaFcnnPR60hg+hOScdI9pVHnNDegACwB66Aap+L4lNSDF
        BtWwhN51eFpkP0YQVAZtYgE7GE06t+A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-205-1Bc-Xk0XMbCz5LOqwYu3Vw-1; Tue, 22 Mar 2022 16:57:28 -0400
X-MC-Unique: 1Bc-Xk0XMbCz5LOqwYu3Vw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C37C1185A7A4
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 20:57:27 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D0F044010A02;
        Tue, 22 Mar 2022 20:57:26 +0000 (UTC)
Message-ID: <9373a32313e166f807b7b188a6c0c4665e098327.camel@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 0/9] KVM unit tests for SVM options
 features
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Date:   Tue, 22 Mar 2022 22:57:25 +0200
In-Reply-To: <20220322205613.250925-1-mlevitsk@redhat.com>
References: <20220322205613.250925-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-03-22 at 22:56 +0200, Maxim Levitsky wrote:
> Those are few fixes and unit tests I used to
> test svm optional features and few more svm feaures.
> 
> Best regards,
>     Maxim Levitsky
> 
> Maxim Levitsky (9):
>   pmu_lbr: few fixes
>   svm: Fix reg_corruption test, to avoid timer interrupt firing in later
>     tests.
>   svm: NMI is an "exception" and not interrupt in x86 land
>   svm: intercept shutdown in all svm tests by default
>   svm: add SVM_BARE_VMRUN
>   svm: add tests for LBR virtualization
>   svm: add tests for case when L1 intercepts various hardware interrupts
>   svm: add test for nested tsc scaling
>   svm: add test for pause filter and threshold
> 
>  lib/x86/msr.h       |   1 +
>  lib/x86/processor.h |   4 +
>  x86/pmu_lbr.c       |   6 +
>  x86/svm.c           |  57 ++---
>  x86/svm.h           |  71 +++++-
>  x86/svm_tests.c     | 582 +++++++++++++++++++++++++++++++++++++++++++-
>  x86/unittests.cfg   |   8 +-
>  7 files changed, 688 insertions(+), 41 deletions(-)
> 
> -- 
> 2.26.3
> 
> 
typo: I mean SVM optional features.

Best regards,
	Maxim Levitsky

