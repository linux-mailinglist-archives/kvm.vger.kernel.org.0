Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2C64EB2F5
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 19:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240368AbiC2Ry2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Mar 2022 13:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240351AbiC2RyV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Mar 2022 13:54:21 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81FC11ED05D;
        Tue, 29 Mar 2022 10:52:37 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id p4-20020a17090ad30400b001c7ca87c05bso2508586pju.1;
        Tue, 29 Mar 2022 10:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pQtwmQnPApqxl6a1qQafAVmNSaeDO1TUxN8vDTFvE9o=;
        b=kcAhcgdBWZB/5xNlBMsZ8SeU1XU7vhJRw5PdIqWOGc/QGZezZM+p0Ev0+T1+4lz9um
         vVfPWqcOQT16tsjVm4NHi4g88OJHtxIRg6SbbUU2wTyIFlZW3kErv1o9kN1osamqxZMd
         18omSGkrGcViPmFtc+Ztyw8WevNcOFhnEShRcxOIAvHd4fFLQpY6xIqAORoB7/H0ZWx8
         +O49D87VS33nHHSLgfGb6169Ua/ovkJoBltcgoC2Ggc9bgNObvH70KbYUfWK/j4vcNua
         2Bk5PfNECfwoCPt85yOti6qg0fCctJAoGoftKkRDvboxXLKMJn6FQYki7s/Nj5Np3t4q
         8pGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pQtwmQnPApqxl6a1qQafAVmNSaeDO1TUxN8vDTFvE9o=;
        b=Ra1cX6vTKkr9l8y5c6VusjkJcOlNuYfeTqlmZLvmIjbSOzeBoqS/XJtCxWmOKjekL0
         Ff4pw/ctKTdR65d8Me0GdduMmkjm7PMV3mtOfwrU95ovi6T/Mvwdk6XTYmsvxDpuoNQW
         YC5czLvvaSYl9JEM0cG+m3VabRavKeHmWtUlDOMVAebjpeVZYU58QWZp/olsVZPCx6jv
         XURVf2OLCz4Ncg+I5y9kf4BqzSSp8WpjyNrpKa0xPWNK+CPC4jnv0QwvpuELreulz5/n
         wk+1E2ztSgi9R4H5buLUMUc+wSuu4mMUmVtM3v2G0+kCgero3eoB5mjlsrNEylmgPFoe
         nFXQ==
X-Gm-Message-State: AOAM532FI15FZK45VXbgjMIkMqPq5ixkD44R1X2sW4kSC+Uv3BOM4wbM
        KKIOr/BZ17M2z87vIYeIIak=
X-Google-Smtp-Source: ABdhPJwYGa5KMAEW7uS9gBKnxEtSXxrla89FTrBVEJvRlifU/5KAvcPBT73SyAy/Hje6IOTbvvCwAw==
X-Received: by 2002:a17:903:186:b0:154:3606:7a73 with SMTP id z6-20020a170903018600b0015436067a73mr31930870plg.89.1648576356704;
        Tue, 29 Mar 2022 10:52:36 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id 132-20020a62168a000000b004f40e8b3133sm21624407pfw.188.2022.03.29.10.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 10:52:36 -0700 (PDT)
Date:   Tue, 29 Mar 2022 10:52:34 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        isaku.yamahata@gmail.com
Subject: Re: [PATCH v2 01/21] x86/virt/tdx: Detect SEAM
Message-ID: <20220329175234.GA1915371@ls.amr.corp.intel.com>
References: <cover.1647167475.git.kai.huang@intel.com>
 <a258224c26b6a08400d9a8678f5d88f749afe51e.1647167475.git.kai.huang@intel.com>
 <BN9PR11MB527657C2AA8B9ACD94C9D5468C189@BN9PR11MB5276.namprd11.prod.outlook.com>
 <51982ec477e43c686c5c64731715fee528750d85.camel@intel.com>
 <BN9PR11MB52765EE37C00F0FFA01447968C1D9@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52765EE37C00F0FFA01447968C1D9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 28, 2022 at 08:10:47AM +0000,
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Huang, Kai <kai.huang@intel.com>
> > Sent: Monday, March 28, 2022 11:55 AM
> >
> > SEAMRR and TDX KeyIDs are configured by BIOS and they are static during
> > machine's runtime.  On the other hand, TDX module can be updated and
> > reinitialized at runtime (not supported in this series but will be supported in
> > the future).  Theoretically, even P-SEAMLDR can be updated at runtime
> > (although
> > I think unlikely to be supported in Linux).  Therefore I think detecting
> > SEAMRR
> > and TDX KeyIDs at boot fits better.
> 
> If those info are static it's perfectly fine to detect them until they are
> required... and following are not solid cases (e.g. just exposing SEAM
> alone doesn't tell the availability of TDX) but let's also hear the opinions
> from others.

One use case is cloud use case.  If TDX module is initialized dynamically at
runtime, cloud management system wants to know if the physical machine is
capable of TDX in addition to if TDX module is initialized.  Also how many TDs
can be run on the machine even when TDX module is not initialized yet.  The
management system will schedule TDs based on those information.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
