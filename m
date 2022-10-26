Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2786C60E40A
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 17:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234433AbiJZPFA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 11:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233876AbiJZPE6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 11:04:58 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516D65B051
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 08:04:54 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id 192so8400151pfx.5
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 08:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dQ34jIpbpDucuLY8ATaIgOEFfc2/bsjXaMGrXhKJTd8=;
        b=r9rdQmYlzGyPfFKt7mca+0RebQHXPMm0Jybf4cXSyhtKsjhZ+vYs1m14e9WHSkUTt3
         YWQNyvAN/JH+tH++h4hziuYXWw5MpFcbTtiyIZ9RURAhu0fr1qmNhuFMqhjM4dxti7h1
         tMoGdCPRgd/zQUoxo+TpbritmQbksQFyO6swiSQwjHmvlNet3i/DCd5L/TobtDoLrrLZ
         IpdqAt7CY4brrc5ixOS+fcseOqG+jKdWzcRSvXJYDqxRJW5hiuIsNdN/z5R9GSjF7wY3
         M8ybn5N2mNykI0+59Er0i6f7qP8q/sfAjwxqz1mCPBmUTqUwZuwggs5zn3PXlI+hoOes
         DfOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dQ34jIpbpDucuLY8ATaIgOEFfc2/bsjXaMGrXhKJTd8=;
        b=qbn6u8RTsQPDokumNXO9KKL+IEYNGoEtUN03tSIoKxVJ9rFDc6s9ldzF2DWKVL/xFG
         UeFnwpEsw/TXFCMlrSAxHt2m4Ii2KVKFhq4Bpasu86bI8UzcJqJDXSjOMzcbPV8cbaBd
         e+40SZeZYOx/6mi6iiFlABMyiPv825LOIzkso7kKj8iNBcBta7DJHUhGuO8+EaBnNdR1
         oKwZsCuYEevsIpsPjqOSyM9L7MkmMxt69UTZKxWQtxG3VWB78oeAkgLwmrMbVnSekBw5
         4lWrb20ZMlHqs0Js8ZWyQ9RjEFbBa2+hmRrxWsS9yeIJ0UKIhoYsQtku1j37JWZbDvF7
         fYFw==
X-Gm-Message-State: ACrzQf3WFnrdiPAizUrhvQawinVMHZDGQrpIMVvTh8cQ48xFXQNongBV
        a9JXPRloHdcBa2uFidu7q+JRvg==
X-Google-Smtp-Source: AMsMyM6i9nGclGqwXSChn6aRFvVz56lfZwjmMx8S3ni3ya+yn0nBh4V2pFfHRqUPiG6scf8AhHccmA==
X-Received: by 2002:a63:4c05:0:b0:46f:3dfb:98a1 with SMTP id z5-20020a634c05000000b0046f3dfb98a1mr4577492pga.30.1666796693548;
        Wed, 26 Oct 2022 08:04:53 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id p5-20020a170902e74500b0018658badef3sm3029872plf.232.2022.10.26.08.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 08:04:53 -0700 (PDT)
Date:   Wed, 26 Oct 2022 15:04:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Wang, Wei W" <wei.w.wang@intel.com>
Cc:     Vipin Sharma <vipinsh@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "andrew.jones@linux.dev" <andrew.jones@linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 2/5] KVM: selftests: Put command line options in
 alphabetical order in dirty_log_perf_test
Message-ID: <Y1lMkVip4AYIMZiK@google.com>
References: <20221021211816.1525201-1-vipinsh@google.com>
 <20221021211816.1525201-3-vipinsh@google.com>
 <DS0PR11MB63738A6EDEAFA2CC05BBE14CDC309@DS0PR11MB6373.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB63738A6EDEAFA2CC05BBE14CDC309@DS0PR11MB6373.namprd11.prod.outlook.com>
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

On Wed, Oct 26, 2022, Wang, Wei W wrote:
> On Saturday, October 22, 2022 5:18 AM, Vipin Sharma wrote:
> > There are 13 command line options and they are not in any order. Put them in
> > alphabetical order to make it easy to add new options.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > ---
> >  .../selftests/kvm/dirty_log_perf_test.c       | 36 ++++++++++---------
> >  1 file changed, 19 insertions(+), 17 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> > b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> > index 56e08da3a87f..5bb6954b2358 100644
> > --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> > +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> > @@ -406,50 +406,52 @@ int main(int argc, char *argv[])
> > 
> >  	guest_modes_append_default();
> > 
> > -	while ((opt = getopt(argc, argv, "eghi:p:m:nb:f:v:os:x:")) != -1) {
> > +	while ((opt = getopt(argc, argv, "b:ef:ghi:m:nop:s:v:x:")) != -1) {
> >  		switch (opt) {
> > +		case 'b':
> > +			guest_percpu_mem_size = parse_size(optarg);
> > +			break;
> 
> "break" wasn't there.
> This is kind of a functional change (i.e. bug fixing), and would be better to be
> moved to patch 1.

Ya, good catch.
