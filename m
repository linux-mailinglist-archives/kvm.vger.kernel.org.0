Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 422295B22C2
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 17:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbiIHPrL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 11:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbiIHPrK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 11:47:10 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E36F9F9C
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 08:47:09 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id t6-20020a17090a950600b0020063f8f964so3715232pjo.0
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 08:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=1DW9ekK7ZfIRVmBX3XkaRqMimxAEoQNBzvR51+1a3FQ=;
        b=nn0ODGGAWW5nPDKY7tJYp7RjSK5EDaHJjuf2+RNvW4a16Pk0bmwb1CaWodfhtP9bK3
         vk0Ech87OWvpZ5c9u35GKXzUsr9UWt9YsSlNoP7ikH0D87JMTbTCsa4f8OCIl1Y7vsTT
         4IFmieQ1bWWANg7jDDHm8UpXfN9PDecMT2c7b3ffc4hz9xdl1wSOxwiWwMAEYBMkqzK5
         kcNR+gaEfZPXov7sodRy9iIhkKcDWQqO6fzvAgniW4IAtkChws7L2uvnqO3OFEMyNhR9
         fmT8i46SOniTShnKvDLTJN1DfGi0mWA/VeRK2UAg2YbyJsZG6fpcPP5r6MPi/TCLVHLm
         Ah9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=1DW9ekK7ZfIRVmBX3XkaRqMimxAEoQNBzvR51+1a3FQ=;
        b=W5S+7WKwAlmahBZPEQV4/y/jajay5Nr0JqWF8vdNoDqA1LwngDmP/TkdNzR/1kKOj4
         CfmcRybfqad6Mz6DAPxORtvXHowCpVJhE72DjHFMKLBJpKBF4GdQzsVAqtXVHf8ANeCt
         wolgf3Da8LHd5ekH83idU9+bXuWMgg2uPlm1J03+KcjMA/Fpk46IKxjx6/cm/V/bONa0
         5R9RX1I8CuSO0UcPgB4Kj/qErQ255TA4bjXDog+DwOMsL1gcPt9wuPRA4ccSiI8/epa8
         FSvOF9sBCaB+blvT6T0a89kpJvW8qgVvSppnmb0PiJlqo0Snk0ZWJOWGDjAwGt7pW9Wl
         cKug==
X-Gm-Message-State: ACgBeo3RkZrWK6AgX2YUMu2DNevdnDJXh5BvR4Ef2pLunUkmIBRnD51w
        iHJk5Jr5Ru3d+W7G8evYD75a8w==
X-Google-Smtp-Source: AA6agR5KEkAr3jSfrOhdR/TmiilUO3HfMGMD4NoQAhMxEXOZYTpbPj4Tad/bT/bqwm3FdE/zWuQ8dw==
X-Received: by 2002:a17:90a:588c:b0:1fd:a1bc:ff71 with SMTP id j12-20020a17090a588c00b001fda1bcff71mr4738335pji.134.1662652028483;
        Thu, 08 Sep 2022 08:47:08 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id e1-20020aa798c1000000b0053eec4bb1b1sm2334707pfm.64.2022.09.08.08.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 08:47:08 -0700 (PDT)
Date:   Thu, 8 Sep 2022 15:47:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Wang, Wei W" <wei.w.wang@intel.com>
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] KVM/VMX: Do not declare vmread_error asmlinkage
Message-ID: <YxoOeGzI9sht/Afy@google.com>
References: <20220817144045.3206-1-ubizjak@gmail.com>
 <Yv0QFZUdePurfjKh@google.com>
 <CAFULd4bVQ73Cur85Oj=oXHiMRvfrxkAVy=V4TfHcbtNWbqOQzw@mail.gmail.com>
 <YxDRquTx2piSX66J@google.com>
 <CY5PR11MB636505ECC6D27486065E5CE0DC7E9@CY5PR11MB6365.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY5PR11MB636505ECC6D27486065E5CE0DC7E9@CY5PR11MB6365.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 06, 2022, Wang, Wei W wrote:
> On Thursday, September 1, 2022 11:37 PM, Sean Christopherson wrote:
> > > > And vmread_error() isn't the only case where asmlinkage appears to be a
> > burden, e.g.
> > > > schedule_tail_wrapper() => schedule_tail() seems to exist purely to
> > > > deal with the side affect of asmlinkage generating -regparm=0 on 32-bit
> > kernels.
> > >
> > > schedule_tail is external to the x86 arch directory, and for some
> > > reason marked asmlinkage. So, the call from asm must follow asmlinkage
> > > ABI.
> > 
> > Ahhh, it's a common helper that's called from assembly on other architectures.
> > That makes sense.
> 
> I still doubt the necessity. The compilation is architecture specific, and we don't
> build one architecture-agnostic kernel binary to run on different architectures,
> right?

Right, it's not strictly necessary, e.g. wrapping schedule_tail()'s asmlinkage in
"#ifndef CONFIG_X86" would allow for the removal of schedule_tail_wrapper().  But
that's arguably worse than forcing i386 to use a wrapper given that the few extra
instructions are unlikely to add meaningful overhead, and since i386 is a rather
uncommon configuration these days.
