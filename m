Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1DED76DBA9
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 01:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbjHBXgP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 19:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbjHBXgO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 19:36:14 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E8F2D4B
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 16:36:12 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-58440eb872aso2945547b3.3
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 16:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691019372; x=1691624172;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JLJZGGChmwgNECG5B92/paJ//T4VwugbEM4LTKjjkEI=;
        b=IfgOn5L28DOKx2CxEwNAwL53Pb5rVRldcU0FSXIJwNT2esht+pMPHYoV/KbaGfL+5O
         HPmv8/J8MSLzK5iYcmsbRPuu+RAptfj5ZSTZIJ9/R+q5DEEm3wXHEumvikodKGQMmEGk
         BXwWw+2LUbeooMDdXS3rk5WWRyLMIh2bAiG64FfY0Dy1hxdMjwAFg3OhtRjrUmV01pUS
         demn9boMbxhU00piz9CRA5Chf6aG/NlXBsoGMoX3Nanmyb8Ndk9ApCx9qUcv9WOI75+b
         EvAeVhLmnP6pTuqqn5ySUOULqHo3BG4UwrNlwJD7QePdiY6Kwx26mDP5L5WTJHRw0l32
         9p/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691019372; x=1691624172;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JLJZGGChmwgNECG5B92/paJ//T4VwugbEM4LTKjjkEI=;
        b=TnnVMD/3/Joi4d6J1PV2DOgHdbOaf07Cj5cyAGYC4v8S1hb2oRokPS+4cf5aYGFx7M
         a9mj4fi1Z2Uh8jMq+ODvnou4UYmnoNJ3q3s/XRnix+0XgUbAS7yDo0UNe82uM7zNEMdc
         pWKQxmLn4IAvP6ziKYEED43yoOURFOk71n6TfVG2Q6JhdE1p/x6wBNUOGnLNgPtTA9Sl
         DV2R5pRL5gD99F4MVAYLkrm4860+JSU2lkbtvPyN9wu6qkCaY9MjJ8pvIP2XS9/EzLuH
         ButsUjKrST1paBc28o1e2AEtiz6KFujtuJZ4BSTnFimsUGXTZXsa188L7CBT321+sHZd
         040Q==
X-Gm-Message-State: ABy/qLbn44SSNJsQaSbejONik81meNerVFftbXvL2t9Gn/oZ3eJk0kRM
        4s8yDuflrQR+K7+uHXY2EI6c/wh6cds=
X-Google-Smtp-Source: APBJJlF1AcC9oVjYW4JuQ/vs6R4exCKdnWbmbtAwzRv6GP0aLCrbRyC9LI2OJBYqZRNWawGGUzhyN+P2JdA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:721:b0:573:8316:8d04 with SMTP id
 bt1-20020a05690c072100b0057383168d04mr175453ywb.4.1691019371897; Wed, 02 Aug
 2023 16:36:11 -0700 (PDT)
Date:   Wed, 2 Aug 2023 16:36:10 -0700
In-Reply-To: <20230802022954.193843-1-tao1.su@linux.intel.com>
Mime-Version: 1.0
References: <20230802022954.193843-1-tao1.su@linux.intel.com>
Message-ID: <ZMroatylDm1b5+WJ@google.com>
Subject: Re: [PATCH] KVM: x86: Advertise AMX-COMPLEX CPUID to userspace
From:   Sean Christopherson <seanjc@google.com>
To:     Tao Su <tao1.su@linux.intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, xiaoyao.li@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 02, 2023, Tao Su wrote:
> Latest Intel platform GraniteRapids-D introduces AMX-COMPLEX, which adds
> two instructions to perform matrix multiplication of two tiles containing
> complex elements and accumulate the results into a packed single precision
> tile.
> 
> AMX-COMPLEX is enumerated via CPUID.(EAX=7,ECX=1):EDX[bit 8]
> 
> Since there are no new VMX controls or additional host enabling required
> for guests to use this feature, advertise the CPUID to userspace.

Nit, I would rather justify this (last paragraph) with something like:

  Advertise AMX_COMPLEX if it's supported in hardware.  There are no VMX
  controls for the feature, i.e. the instructions can't be interecepted, and
  KVM advertises base AMX in CPUID if AMX is supported in hardware, even if
  KVM doesn't advertise AMX as being supported in XCR0, e.g. because the
  process didn't opt-in to allocating tile data.

If the above is accurate and there are no objections, I'll fixup the changelog
when applying.

Side topic, this does make me wonder if advertising AMX when XTILE_DATA isn't
permitted is a bad idea.  But no one has complained, and chasing down all the
dependent AMX features would get annoying, so I'm inclined to keep the status quo.
