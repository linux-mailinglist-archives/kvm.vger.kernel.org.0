Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C459B60689D
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 21:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbiJTTGv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 15:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiJTTGt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 15:06:49 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62DD61C69D0
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 12:06:48 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id h12so343317pjk.0
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 12:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZXQ8iP9UFLtOA+n2U0frY2ICV2czMZ1F9q7UPMeeipE=;
        b=gzN/iGr2XGNgqjDND0ttO3zPdP1Zs1bgDS5O3g2m16r0F201WPF8KChJPQ+oTL0Epe
         gM83GVKR1eFET37XCRcgHVVMEyRM/TblmubP2wkoYi+UWCDbAcqryZ5otPr0MYyyueyV
         S1Mtmxqj59o6L/gyJUHKaNJVP++nnERGOXRQRzvUJ/MJwcYqOtXFhud1hZMtsTLgDA3E
         OFR/CgZGGDhRktQIQJNlVhORd3+xWahTLitmUgleMUkT3hodbMf1JQkxvqG7W3Gqvt8p
         2slrqc0kw4NI9myKTXk0lwXLEWL8xTkzpZzsFkdX0ehiH+lMQIB/qKDrV0R/ZuhkMOT9
         BTAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZXQ8iP9UFLtOA+n2U0frY2ICV2czMZ1F9q7UPMeeipE=;
        b=lKqjIjVUg1tpStBfWvaUbDkja+ydkC7k5dQ6BJM0iRzzITHQjH3QqJRY97BM4w+Jr1
         e0UAUFWZUVjTopEdKbbhD+kHJrONqjEBfmwnl9oODL+d9PQS43wmD2FLUsAyKOHg3AAX
         mss0XRwbo1dJtYdwGbnrX16IhEhSptk+zjvmEYXx/sIV/V/wDXzMftGsQCMYlKIyTXdO
         hZBRKYpFcfWyIuJcXUpGr94FYuFu5UCyCr/whHDx5gGgI8g50EM8X5/oGqSOR5Xze/8K
         vQDDVN9LjZ8ttVki1+wIH4CAOwyCRxqr8VnqmACeDN9NHTYv5RPagbLgYlA0U7PhSzag
         wMnQ==
X-Gm-Message-State: ACrzQf0HJTixYMHmR2aN7eJ+mxf7GZv72sYtNqGewMw/U2/KyxO5I7Er
        C8GsrN+u0ePHKt9Qvw32LE2zRg==
X-Google-Smtp-Source: AMsMyM4APDSan3/IZ2ry94ah7fZ2g+jUSUnGHOsv/+edaqGHc/GOY91im/c62dAMxDHJKtiAcSojxg==
X-Received: by 2002:a17:902:b415:b0:178:2835:29e7 with SMTP id x21-20020a170902b41500b00178283529e7mr15382263plr.86.1666292807348;
        Thu, 20 Oct 2022 12:06:47 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h9-20020a170902f54900b001788ccecbf5sm13437511plf.31.2022.10.20.12.06.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 12:06:46 -0700 (PDT)
Date:   Thu, 20 Oct 2022 19:06:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 08/16] svm: add nested shutdown test.
Message-ID: <Y1GcQ1vJptwmUtga@google.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
 <20221020152404.283980-9-mlevitsk@redhat.com>
 <4f991c306dca5764c5822fca43f8092001817790.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f991c306dca5764c5822fca43f8092001817790.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 20, 2022, Maxim Levitsky wrote:
> On Thu, 2022-10-20 at 18:23 +0300, Maxim Levitsky wrote:
> > +static void svm_shutdown_intercept_test(void)
> > +{
> > +	void* unmapped_address = alloc_vpage();
> > +
> > +	/*
> > +	 * Test that shutdown vm exit doesn't crash L0
> > +	 *
> > +	 * Test both native and emulated triple fault
> > +	 * (due to exception merging)
> > +	 */
> > +
> > +
> > +	/*
> > +	 * This will usually cause native SVM_EXIT_SHUTDOWN
> > +	 * (KVM usually doesn't intercept #PF)
> > +	 * */
> > +	test_set_guest(shutdown_intercept_test_guest);
> > +	vmcb->save.idtr.base = (u64)unmapped_address;
> > +	vmcb->control.intercept |= (1ULL << INTERCEPT_SHUTDOWN);
> > +	svm_vmrun();
> > +	report (vmcb->control.exit_code == SVM_EXIT_SHUTDOWN, "shutdown (BP->PF->DF->TRIPLE_FAULT) test passed");
> > +
> > +	/*
> > +	 * This will usually cause emulated SVM_EXIT_SHUTDOWN
> > +	 * (KVM usually intercepts #UD)
> > +	 */
> > +	test_set_guest(shutdown_intercept_test_guest2);
> > +	vmcb_ident(vmcb);
> > +	vmcb->save.idtr.limit = 0;
> > +	vmcb->control.intercept |= (1ULL << INTERCEPT_SHUTDOWN);
> > +	svm_vmrun();
> > +	report (vmcb->control.exit_code == SVM_EXIT_SHUTDOWN, "shutdown (UD->DF->TRIPLE_FAULT) test passed");
> > +}
> > +
> >  struct svm_test svm_tests[] = {
> >  	{ "null", default_supported, default_prepare,
> >  	  default_prepare_gif_clear, null_test,
> > @@ -3382,6 +3432,7 @@ struct svm_test svm_tests[] = {
> >  	TEST(svm_intr_intercept_mix_smi),
> >  	TEST(svm_tsc_scale_test),
> >  	TEST(pause_filter_test),
> > +	TEST(svm_shutdown_intercept_test),
> >  	{ NULL, NULL, NULL, NULL, NULL, NULL, NULL }
> >  };
> 
> Note that on unpatched KVM, this test will cause a kernel panic on the host
> if run.
> 
> I sent a patch today with a fix for this.

I'm confused.  The KVM patches address a bug where KVM screws up if the SHUTDOWN
(or INIT) is _not_ intercepted by L1, but the test here does intercept SHUTDOWN.
Are there more bugs lurking in KVM, or am I missing something?
