Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9FE644518
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 14:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233776AbiLFN5a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 08:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232642AbiLFN52 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 08:57:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D3F2B24B
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 05:56:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670334989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fmIsht13WsO0jxVe0Tc1U2Vvmzpu3jXmKmxaZEyP/wI=;
        b=M/CsAVp2Df21cqDDBz3474YVPJD7CiP9FFJkOkFoQWVyVH3wB/L0/1axb/Yty+xDGR+fM4
        i+cs5RBnzgOQp6XtTFjcoO7xKYx8i+S2OiY6T/VwA7TXfTFIwWJT/fSLMSbMnFpzMRRl49
        NY1IcwgpJXpWl1S2VNENkUH8pJKuYsU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-325-Rmdydxc-Mb2xX01fLMXCUw-1; Tue, 06 Dec 2022 08:56:28 -0500
X-MC-Unique: Rmdydxc-Mb2xX01fLMXCUw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DA0073815D5A;
        Tue,  6 Dec 2022 13:56:16 +0000 (UTC)
Received: from starship (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D84B2166B38;
        Tue,  6 Dec 2022 13:56:04 +0000 (UTC)
Message-ID: <10c3137863ccb0731e104a25e2a510b1cc4c4ae9.camel@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 09/27] svm: add simple nested shutdown
 test.
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Alex =?ISO-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        Nico Boehr <nrb@linux.ibm.com>,
        Cathy Avery <cavery@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Date:   Tue, 06 Dec 2022 15:56:03 +0200
In-Reply-To: <0cbe20fd-fe9c-cb5b-71ff-002724c3ebdb@redhat.com>
References: <20221122161152.293072-1-mlevitsk@redhat.com>
         <20221122161152.293072-10-mlevitsk@redhat.com>
         <0cbe20fd-fe9c-cb5b-71ff-002724c3ebdb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-12-01 at 14:46 +0100, Emanuele Giuseppe Esposito wrote:
> 
> Am 22/11/2022 um 17:11 schrieb Maxim Levitsky:
> > Add a simple test that a shutdown in L2 is intercepted
> > correctly by the L1.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  x86/svm_tests.c | 17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> > 
> > diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> > index a7641fb8..7a67132a 100644
> > --- a/x86/svm_tests.c
> > +++ b/x86/svm_tests.c
> > @@ -11,6 +11,7 @@
> >  #include "apic.h"
> >  #include "delay.h"
> >  #include "x86/usermode.h"
> > +#include "vmalloc.h"
> >  
> >  #define SVM_EXIT_MAX_DR_INTERCEPT 0x3f
> >  
> > @@ -3238,6 +3239,21 @@ static void svm_exception_test(void)
> >  	}
> >  }
> >  
> > +static void shutdown_intercept_test_guest(struct svm_test *test)
> > +{
> > +	asm volatile ("ud2");
> > +	report_fail("should not reach here\n");
> > +
> Remove empty line here

Will do,
Best regards,
	Maxim Levitsky

> > +}Add empty line here
> > +static void svm_shutdown_intercept_test(void)
> > +{
> > +	test_set_guest(shutdown_intercept_test_guest);
> > +	vmcb->save.idtr.base = (u64)alloc_vpage();
> > +	vmcb->control.intercept |= (1ULL << INTERCEPT_SHUTDOWN);
> > +	svm_vmrun();
> > +	report(vmcb->control.exit_code == SVM_EXIT_SHUTDOWN, "shutdown test passed");
> > +}
> > +


