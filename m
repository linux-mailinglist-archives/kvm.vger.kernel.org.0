Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFA06D70D6
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 01:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbjDDXnG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 19:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbjDDXnF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 19:43:05 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5161107
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 16:43:04 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id d34-20020a630e22000000b005039e28b68cso10042120pgl.13
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 16:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680651784;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v/hRlOBMceOpM1Na6lkpCBQgW/QRw2RWjlJOEYLque4=;
        b=f4mYhVf0fT2FDbRlQISafml4YivcBBIcqklnUn4KNccUmmWGQF26fJIdA8i6Hs5GdK
         bOv65QGNWIhQLGkggbC56d56KdhT3qvsg0odGZFz3LB7mRVOPPq0dTbqVX4VEfn6tp2L
         aEc3Fmia0Lt7diDpiZnF4PA2wgi1Ka/XITc95huVJFMDCikiPG+1hjeU57KeJaIEcnzD
         OXe+pABvPIoauweheSOMfDj97mx1S2RHluNN7+0pdfJjaLuaV3Fg1v6Z4D9AkwBnXPCa
         mSt23JMgNORUKT2JLlDHT3SkhGvMg5t+VYbvBZoQMr1TX9XGGKQ2Bj9TlOVrSeRgfT6N
         qsTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680651784;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v/hRlOBMceOpM1Na6lkpCBQgW/QRw2RWjlJOEYLque4=;
        b=7/eo8gq1mjCU2e7VKoK1KnzbUy1tA6kIBfNMEdNy500xCc6jZx7XVo7EtgJGj6LE7g
         XKvkp9UMID8Ag5TrMYPdDXnNTr9S83WFsZnB+HtBcWfPgjQnGigQfgUkfMkR6prRPWBX
         gUORaJ+svdYnZvG3QBzUPqw4Zfjb3LQ4b1UaWnqHJKILf4St79yVoCymFAxqT+oEhVsu
         DglndbwZVLrZ1HOCcNxcGgoVdWOcDbJzPZoqvjhkgIkDrtXH9b1YICb0Q7oBUhYadNLg
         akqpIwUpKYBRGwu62Ta7uVUikof0zYWO1YI/evkDtPeB4LBUIauhLvASOiiUpbBAmhH5
         kTHA==
X-Gm-Message-State: AAQBX9c+ryGhmQXpOwSMDy9csNy23ipONHb/wMjB2qEjSLo4lT662vOl
        640boFXchkJ+vkmmUtleUbeRWIMLlK8=
X-Google-Smtp-Source: AKy350bKxhGh2Sokv2uoQm0cectCSUDbfrJYct8SpPwkvEs7mHO093sOK0E4F5Ouw8Msu5dNE4ZJ2gr4YTo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:6c65:b0:23f:a26e:daa3 with SMTP id
 x92-20020a17090a6c6500b0023fa26edaa3mr1518437pjj.9.1680651784298; Tue, 04 Apr
 2023 16:43:04 -0700 (PDT)
Date:   Tue, 4 Apr 2023 16:43:02 -0700
In-Reply-To: <ZCxxIj0Go5XA6LPU@google.com>
Mime-Version: 1.0
References: <20230404165341.163500-1-seanjc@google.com> <20230404165341.163500-6-seanjc@google.com>
 <ZCxxIj0Go5XA6LPU@google.com>
Message-ID: <ZCy2BogzCGX1qNpg@google.com>
Subject: Re: [kvm-unit-tests PATCH v4 5/9] x86/access: Add forced emulation support
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 04, 2023, Sean Christopherson wrote:
> On Tue, Apr 04, 2023, Sean Christopherson wrote:
> > diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> > index f324e32d..6194e0ea 100644
> > --- a/x86/unittests.cfg
> > +++ b/x86/unittests.cfg
> > @@ -143,6 +143,12 @@ file = access_test.flat
> >  arch = x86_64
> >  extra_params = -cpu max
> >  
> > +[access_fep]
> > +file = access_test.flat
> > +arch = x86_64
> > +extra_params = -cpu max -append force_emulation
> > +groups = nodefault
> 
> Argh, this needs to override the timeout.  Ditto for the vmx_pf_exception_test_fep
> variant.  If there are no other issues or objections in the series, I'll set the
> timeouts to 240 when applying.

FYI Mathias, Paolo grabbed these already but missed my mea culpas.  Posted fixes
for the configs: https://lore.kernel.org/all/20230404234112.367850-1-seanjc@google.com
