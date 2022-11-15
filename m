Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B07166298BE
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 13:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238338AbiKOMXL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 07:23:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238072AbiKOMWy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 07:22:54 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D2E28734
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 04:22:25 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id x21so9351672qkj.0
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 04:22:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PhJS8hGnS2Eii/k2XrXlRq8n5CmfHH4mNYz371VtBD0=;
        b=dk6eyK82AphZctL7I56ME9lPsVOM/w4gKGWuvNNkze+N6/UwHqDeB0oalIljTX0Iqc
         YC/GBLgjf6HAMY99CG8zfpXzS1TWf6rCY1efPsDKeB8agUEdmAJ5boxsj//oIg9/1xMC
         f9lmOuW3Xd1pzp+vU6rV69ym2E7dontNYTwJNBRn2RUytZn50/EqJLEmlqP9rIWdeI2P
         CX956kLxm2vIhUbeB9btBrqU+DGSASkb8z6f5gzkx+L1Qq0d8qBXiwVekBmRWMOIT75l
         mVrmpq7e6P0PhEhgrNHsSjOZqF9iLhERcs413eyO7C3S9ao1W9A1YmYQwKwK+nIuZ4dO
         Ao4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PhJS8hGnS2Eii/k2XrXlRq8n5CmfHH4mNYz371VtBD0=;
        b=R284VF0Oc/ZpqewrBc15Y/PCrVL/VDPEUaeYgKfc9cuH1uGUN9NAK8zoFjXRodrqxO
         SVyg2gCNv16Kk25nmAQFiPCyWOe4f0FvTwXqrAjkUtUK/BrVvHJWwK9EslQXidBPEEgy
         olIg3hDysicMMcQQy+IBF1ZvBo/XJ6he3sbvNVsZOUmeU3c8tk15tqzbsjRVxtro00xq
         6jh9DKMJFcwSe/BiaaaY1MzPI/K3OzQqbmEjlGaJpgyL9GRxeFkqEbjtko/nqkSumEdm
         XqSP4XavaFoCGK40RIWeOPhPw2IHOs6WQ/r/o4SqRCtQQKLUriQ7UyjQ99VV755UxPsS
         tWJw==
X-Gm-Message-State: ANoB5pny6hrYRrDZVhnjw2d8Yl8eYZHYx6PhqAGYXj0AawuXi299Rdn1
        Jb/XIfhyTxsdMvtJkUvaGXXPf4subdtMptp/qkGwqGjRq0jAhw==
X-Google-Smtp-Source: AA0mqf6zCFRw93HZd6q6aVSXvkZ55ikvdeGGjcg0MlkF/DDi9JM4lfgZALyaJztxsR4f93c8fT7TDtIlgw42X2ueLvk=
X-Received: by 2002:a05:620a:4806:b0:6fa:da64:4879 with SMTP id
 eb6-20020a05620a480600b006fada644879mr14623726qkb.312.1668514944745; Tue, 15
 Nov 2022 04:22:24 -0800 (PST)
MIME-Version: 1.0
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <99e5fcf2a7127347816982355fd4141ee1038a54.1667110240.git.isaku.yamahata@intel.com>
 <0feaa13fa5bf45258f2ebb8407eaefadf5c48976.camel@intel.com> <20221114231835.GA2350331@ls.amr.corp.intel.com>
In-Reply-To: <20221114231835.GA2350331@ls.amr.corp.intel.com>
From:   Erdem Aktas <erdemaktas@google.com>
Date:   Tue, 15 Nov 2022 04:22:13 -0800
Message-ID: <CAAYXXYzM4=X5euL_cMx=YnPR7=8k9V_VY2ZyLs-RKz76DB2DcA@mail.gmail.com>
Subject: Re: [PATCH v10 005/108] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Mon, Nov 14, 2022 at 3:18 PM Isaku Yamahata <isaku.yamahata@gmail.com> wrote:
> > I think you should explain why MOVDIR64B is required, otherwise this just comes
> > out of blue.
> >
> > Btw, is this absolutely required?  TDX also supports Li-mode, which doesn't have
> > integrity check.  So theoretically with Li-mode, normal zeroing is also OK but
> > doesn't need to use MOVDIR64B.
> >
> > That being said, do we have a way to tell whether TDX works in Ci or Li mode?
>
> As long as I don't know.  When clearing page, we can use
> if (featuremovdir64b) movdir64b else memset(0).

-- sorry for resending the same email, for some reason my previous
email was not in plain text mode--
As far as I know, Li mode and Ci mode both are working very similarly
and require movdir64b to clear any poison bit previously set. Why
would movdir64b is not supported in a tdx capable cpu?

> --
> Isaku Yamahata <isaku.yamahata@gmail.com>
