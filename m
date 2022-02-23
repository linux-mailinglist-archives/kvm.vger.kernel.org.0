Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADBD4C1248
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 13:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234296AbiBWME2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 07:04:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234733AbiBWME1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 07:04:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D31959A9A6
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 04:03:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645617839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RsEaduhosj3scr7jqtk40yT4gGh5J+A6qQR3OfG+EYs=;
        b=V6PxV1zkwGL/LaFr5TgA7o71/4WiQGOyOnUE540fjBEFMFuA0IC/ma6EIR1WBakloByL/D
        KCARzDILy7s6Exoa3y8ZjnnAEPjvYF/fEZTd1LmpTobxRCI3Eslo6RemiZRVk2lcdLgjJX
        LBG6bLbDALaf7m4mHZ+YnsNML8wo7rE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-449--vK5pthYOSiVxFMwfTldAA-1; Wed, 23 Feb 2022 07:03:57 -0500
X-MC-Unique: -vK5pthYOSiVxFMwfTldAA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D742801AB2
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 12:03:56 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B95E684948
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 12:03:55 +0000 (UTC)
Message-ID: <38346acd4f7b9cb5a38c3a1e2fba0ee01a82dc5b.camel@redhat.com>
Subject: Re: [PATCH 0/7] My set of KVM unit tests + fixes
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Date:   Wed, 23 Feb 2022 14:03:54 +0200
In-Reply-To: <20220208122148.912913-1-mlevitsk@redhat.com>
References: <20220208122148.912913-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-02-08 at 14:21 +0200, Maxim Levitsky wrote:
> Those are few kvm unit tests tha I developed.
> 
> Best regards,
>     Maxim Levitsky
> 
> Maxim Levitsky (7):
>   pmu_lbr: few fixes
>   svm: Fix reg_corruption test, to avoid timer interrupt firing in later
>     tests.
>   svm: NMI is an "exception" and not interrupt in x86 land
>   svm: intercept shutdown in all svm tests by default
>   svm: add SVM_BARE_VMRUN
>   svm: add tests for LBR virtualization
>   svm: add tests for case when L1 intercepts various hardware interrupts
>     (an interrupt, SMI, NMI), but lets L2 control either EFLAG.IF or GIF
> 
>  lib/x86/processor.h |   1 +
>  x86/pmu_lbr.c       |   6 +
>  x86/svm.c           |  41 +---
>  x86/svm.h           |  63 ++++++-
>  x86/svm_tests.c     | 447 +++++++++++++++++++++++++++++++++++++++++++-
>  x86/unittests.cfg   |   3 +-
>  6 files changed, 521 insertions(+), 40 deletions(-)
> 
> -- 
> 2.26.3
> 
> 
Any update on these patches?

Best regards,
	Maxim Levitsky

