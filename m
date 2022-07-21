Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AED057D0BC
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 18:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbiGUQJF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 12:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiGUQJC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 12:09:02 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C167AB30
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 09:09:01 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 23so2059293pgc.8
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 09:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kq4tOcuZKKIb0aovN9uV6YoC9FJ55HmRLJusfu89XEw=;
        b=DuWt7aywVJ00JB3vT7dMSz8Z9Cox7G/gaFzAXv8RkZfpCyc92322h9/2Oa/8mJF4PJ
         MMQ+YYhkdOyrsDwmQeO4STsE1c3vQMoCorFyOoivDTt7bJ1J3nd/+lZaVmUbzZbZ4PP+
         QcxpcPqPEbOtJhiW997e+hAtBFfdfyIBz4B75b8S/Jkg48rrRIERk0R0qGcsAoxhxd7A
         7ClJF0yE6dlV0GgeI+yaik8a0jORzuKog4snzsRbdoaTFDNRTmy5bJKWgtY+uthUcpu+
         iy5BYeYgw3mN9LWkKvaaiTgj7sF36AQFmn+q0g/LoCooKkaS5v3pFYKPWjv1/aiarsXh
         KQsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kq4tOcuZKKIb0aovN9uV6YoC9FJ55HmRLJusfu89XEw=;
        b=o3ZAw8cv3RqByd67cRGcDcTnzQy7aYQxRxfdUNeduQ25Xk6Dp4uPHiT1HO15SF5xNz
         wEa7nAh1UREhXULsjxEPbUUA/7xsqT2UIX6bQghvfN7plSL+oiTevyJSmlOCXVd1LEsO
         BGN7iE2jIvVzbo6bm4i4nU8JZ1ygZxM78AFzhgbkcHq6tE1lr2YX4fc9h6h6coti5udE
         LEMQfexe39HdHNxU0BfM/mCJhr1/HmeLoQ4MDC1FJkoDlzyR8oFZPPZdqeGvPIqxAdJz
         0Uhbwz/6ekSqnDqttIeqH/P7Jd4hZWdSN9bufvlYP0dnRUcsEkuNlU7WumWph7TEXiH1
         fPpA==
X-Gm-Message-State: AJIora/yfMvfXR+RizNdSkgSuXefHbOHtD58lDLVhWxpdVBtU7DIkm4a
        lyfW7gjuERGm7y5Galbtd/bqwA==
X-Google-Smtp-Source: AGRyM1t8MidjDat9EYC6vZTVSXYGFfAYpEF0IwsYFp46gFNQKqfw66NG3/h0fClfB3dy8eVykGg/+g==
X-Received: by 2002:a63:f011:0:b0:416:4b7:5ae4 with SMTP id k17-20020a63f011000000b0041604b75ae4mr37730179pgh.380.1658419740817;
        Thu, 21 Jul 2022 09:09:00 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id i66-20020a626d45000000b00525373aac7csm1992670pfc.26.2022.07.21.09.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 09:09:00 -0700 (PDT)
Date:   Thu, 21 Jul 2022 16:08:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Santosh Shukla <santosh.shukla@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 4/7] KVM: SVM: Report NMI not allowed when Guest busy
 handling VNMI
Message-ID: <Ytl6GLui7UQFi3FO@google.com>
References: <20220709134230.2397-1-santosh.shukla@amd.com>
 <20220709134230.2397-5-santosh.shukla@amd.com>
 <Yth5hl+RlTaa5ybj@google.com>
 <c5acc3ac2aec4b98f9211ca3f4100c358bf2f460.camel@redhat.com>
 <Ytlpxa2ULiIQFOnj@google.com>
 <413f59cd3c0a80c5b71a0cd033fdaad082c5a0e7.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <413f59cd3c0a80c5b71a0cd033fdaad082c5a0e7.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 21, 2022, Maxim Levitsky wrote:
> On Thu, 2022-07-21 at 14:59 +0000, Sean Christopherson wrote:
> > Yep.  Dropping an NMI in the last case is ok, AFAIK no CPU will pend multiple NMIs
> > while another is in-flight.  But triggering an immediate exit in svm_nmi_allowed()
> > will hang the vCPU as the second pending NMI will never go away since the vCPU
> 
> The idea is to trigger the immediate exit only when a NMI was just injected (V_NMI_PENDING=1)
> but not masked (that is currently in service, that is V_NMI_MASK=0).

I assume you mean "and an NMI is currently NOT in service"?

Anyways, we're on the same page, trigger an exit if and only if there's an NMI pending
and the vCPU isn't already handling a vNMI.  We may need to explicitly drop one of
the pending NMIs in that case though, otherwise the NMI that _KVM_ holds pending could
get "injected" well after NMIs are unmasked, which could suprise the guest.  E.g.
guest IRETs from the second (of three) NMIs, KVM doesn't "inject" that third NMI
until the next VM-Exit, which could be a long time in the future.

> In case both bits are set, the NMI is dropped, that is no immediate exit is requested.
> 
> In this case, next VM entry should have no reason to not inject the NMI and then VM exit
> on the interrupt we raised, so there should not be a problem with forward progress.
> 
> There is an issue still, the NMI could also be masked if we are in SMM (I suggested
> setting the V_NMI_MASK manually in this case), thus in this case we won't have more
> that one pending NMI, but I guess this is not that big problem.
> 
> We can btw also in this case "open" the NMI window by waiting for RSM intercept.
> (that is just not inject the NMI, and on RSM inject it, I think that KVM already does this)
> 
> I think it should overal work, but no doubt I do expect issues and corner cases,
> 
> 
> > won't make forward progress to unmask NMIs.  This can also happen if there are
> > two pending NMIs and GIF=0, i.e. any time there are multiple pending NMIs and NMIs
> > are blocked.
> 
> GIF=0 can be dealt with though, if GIF is 0 when 2nd pending NMI arrives, we can
> delay its injection to the moment the STGI is executed and intercept STGI.
> 
> We I think already do something like that as well.

Yep, you're right, svm_enable_nmi_window() sets INTERCEPT_STGI if VGIF is enabled
and GIF=0 (and STGI exits unconditional if VGIF=0?).

So we have a poor man's NMI-window exiting.
