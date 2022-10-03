Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 766435F382A
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 23:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiJCV40 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 17:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiJCV4Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 17:56:25 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2BB2A427
        for <kvm@vger.kernel.org>; Mon,  3 Oct 2022 14:56:24 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id v10-20020a17090a634a00b00205e48cf845so16482435pjs.4
        for <kvm@vger.kernel.org>; Mon, 03 Oct 2022 14:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=kqWJbx66Q8JEGGCURz3AIH6X76E7BfONd/VL7G+Httk=;
        b=DibS6WbaGABetfJM/m0bxEK+A/RjXznMzrS2A+SglhSQHL/UBu2tJWq5PJxamgSooN
         /etuBoUfxwo3j5ANzvN1+X9sjzJqVik0rtOgO705JTsQ9QkMAmZk4WgPUR3IA2GC8AeP
         wxcGxb0vHxkni3riUTP0HXuHWVdUa7+UjprYUk+lG09RFFL14fcCcOovGimpRiGufCfi
         5Px4ipx2vSPJvkzNQxPt9JFOSE8ZVxzfy3FfE6wOQsq0T5bPXFI73KVcUwH0IbgvSqh8
         Po8B/OsoC4kIV5MhWMF+wp7mPXUpcFdDVc+jAKxnpIoBlgqPNGy+S8sHWoRM7Mu/LeDE
         EBfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=kqWJbx66Q8JEGGCURz3AIH6X76E7BfONd/VL7G+Httk=;
        b=N/yXkuEzwflOWOQkA5HsTghBAG5s23uWj4EYpCssXMoThgXwleJoNYqD3AwfxWbOQW
         b9t3Jt6kkFAbHRpTIvmYFy0Gn3hfckqmHRPsVjyDfh7IZcxHHAM8f5fMCmS1U90EdP/h
         AL8gkJ299HzOqcAeqmHpA8ZxytpcugJPMbe2MEmhh5IV5pCa7rYqlX5FjJVmXfpEIDmB
         c7NGZ4w6fkcrlxoieLLtCWbzY2fd9PMKm93/yPAVPP8TimIvzUM40HklC+5uI77FlF5g
         5+jbGZO0Zv/qBY8xDWWJt9NWDorsQ9/sxmaxpvNoWNnbeGNyRYaQjOFIhqCd4FFiZJ8N
         aadw==
X-Gm-Message-State: ACrzQf0ouXIySEwWj4gv5Z7akcY7JKnu0Xp6OP9gyh7vsCkBlBRY4fI+
        tr+Xd9HQDiKhOzwUBqBRBz4=
X-Google-Smtp-Source: AMsMyM5foj2QQme9Ri4FO7/4MtVz1XYYfcGP6WgLb931A6G0xEga5tnn6yaxG8jzBKzfkY3rZqv+bQ==
X-Received: by 2002:a17:902:c949:b0:178:323f:6184 with SMTP id i9-20020a170902c94900b00178323f6184mr24805661pla.130.1664834184072;
        Mon, 03 Oct 2022 14:56:24 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id k3-20020a170902c40300b0017ba371b0a9sm2128949plk.167.2022.10.03.14.56.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 14:56:23 -0700 (PDT)
Date:   Mon, 3 Oct 2022 14:56:21 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v3 01/10] KVM: x86/mmu: Change tdp_mmu to a read-only
 parameter
Message-ID: <20221003215621.GI2414580@ls.amr.corp.intel.com>
References: <20220921173546.2674386-1-dmatlack@google.com>
 <20220921173546.2674386-2-dmatlack@google.com>
 <1c5a14aa61d31178071565896c4f394018e83aaa.camel@intel.com>
 <CALzav=d1wheG3bCKvjZ--HRipaehtaGPqJsDz031aohFjpcmjA@mail.gmail.com>
 <fde43a93b5139137c4783d1efe03a1c50311abc1.camel@intel.com>
 <20221003185834.GA2414580@ls.amr.corp.intel.com>
 <Yzs/4rqWFroUNyFU@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yzs/4rqWFroUNyFU@google.com>
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 03, 2022 at 01:02:42PM -0700,
David Matlack <dmatlack@google.com> wrote:

> On Mon, Oct 03, 2022 at 11:58:34AM -0700, Isaku Yamahata wrote:
> > On Tue, Sep 27, 2022 at 09:10:43PM +0000, "Huang, Kai" <kai.huang@intel.com> wrote:
> > > On Tue, 2022-09-27 at 09:14 -0700, David Matlack wrote:
> > > > On Tue, Sep 27, 2022 at 2:19 AM Huang, Kai <kai.huang@intel.com> wrote:
> > > > > 
> > > > > Sorry last time I didn't review deeply, but I am wondering why do we need
> > > > > 'tdp_mmu_allowed' at all?  The purpose of having 'allow_mmio_caching' is because
> > > > > kvm_mmu_set_mmio_spte_mask() is called twice, and 'enable_mmio_caching' can be
> > > > > disabled in the first call, so it can be against user's desire in the second
> > > > > call.  However it appears for 'tdp_mmu_enabled' we don't need 'tdp_mmu_allowed',
> > > > > as kvm_configure_mmu() is only called once by VMX or SVM, if I read correctly.
> > > > 
> > > > tdp_mmu_allowed is needed because kvm_intel and kvm_amd are separate
> > > > modules from kvm. So kvm_configure_mmu() can be called multiple times
> > > > (each time kvm_intel or kvm_amd is loaded).
> > > > 
> > > > 
> > > 
> > > Indeed. :)
> > > 
> > > Reviewed-by: Kai Huang <kai.huang@intel.com>
> > 
> > kvm_arch_init() which is called early during the module initialization before
> > kvm_configure_mmu() via kvm_arch_hardware_setup() checks if the vendor module
> > (kvm_intel or kvm_amd) was already loaded.  If yes, it results in -EEXIST.
> > 
> > So kvm_configure_mmu() won't be called twice.
> 
> kvm_configure_mmu() can be called multiple times if the vendor module is
> unloaded without unloading the kvm module. For example:
> 
>  $ modprobe kvm
>  $ modprobe kvm_intel ept=Y  # kvm_configure_mmu(true, ...)
>  $ modprobe -r kvm_intel
>  $ modprobe kvm_intel ept=N  # kvm_configure_mmu(false, ...)

Oh, yes, you're right.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
