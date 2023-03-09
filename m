Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C46D6B1AA8
	for <lists+kvm@lfdr.de>; Thu,  9 Mar 2023 06:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjCIFSV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 00:18:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjCIFST (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 00:18:19 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FAA434318
        for <kvm@vger.kernel.org>; Wed,  8 Mar 2023 21:18:16 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id bo22so1045907pjb.4
        for <kvm@vger.kernel.org>; Wed, 08 Mar 2023 21:18:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678339096;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=d7NmRbnOpMKZ9/VW9/POAunQQIMGvt6ilad4QXpo07k=;
        b=BQHYo6oOshr1q8v1UcTa1lX5HoLMyGOm0sNk4kYogyNVfBKADGQXYZhkAkjeZSf+FN
         FaSjpDKZtBw0tlwtpuF+cSFu7vS68qsm9K3K5lihwSbiQzJFoIvqSIaheJ+6Qocuecc2
         WO0ad0s/xyOYE/N8BuSirCLgEXJVy+SbjOF/pVDEpvWsB+Y9e6hyJ5eBXfseCFq/FmA9
         VBHNBzQVzqjO3EO8kjXjAtfhLioBHZsoSP0T4bW/fEi1GX9WYD6NKRBSbc8rzcckcZaI
         3P5Ib77CwAGzaU2OIlwlLx8VjNfS2kfN7C8DJbsu/DqxS0kxadeY6pKGp6M+BAJmbBei
         YDVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678339096;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d7NmRbnOpMKZ9/VW9/POAunQQIMGvt6ilad4QXpo07k=;
        b=AH0uI5Fi2DhfOXHxEL2xw313UVEXMNTzVccjEbQa771Fn94vJSrjXpYkUWm+EJSfAe
         beuxGCJx79rZ7bNwQd166usvOBLXn/+bCz7lnKXFYU85GmqALihVuBN3Y21Mwmvjyyir
         wpTyAkTA7t/Z8oxyDNAXPYz9xc+NVStv80SXWhkjtUHMWymQwMDTFNI3WrV+iw3nGVgP
         gyCx1Yd8fbltQfCMbheJYYwXfxFoyAA4iNBh43+DCU/sEatNR7qPQsGM0qP52hitUqWm
         bEjBiXk1tbw910oyRL4yvy0NtT7o9uxFFd92/q7HRkunZCyDFyubOTiLUg20Vjtaezx4
         eNkQ==
X-Gm-Message-State: AO0yUKWaQ6rcAsvdWJbeBMR8226Jb2029RwKSITMDyO4l4kyzzSGXmVX
        XOC4RzgBxLEDjLJnumKWtYkrOg==
X-Google-Smtp-Source: AK7set9HKs3hbvPy6qiZFByeTcF2y768wncnZy6L+FK9NKtEBpVdzZN3s2bQC8AAS3ydC5FGgh1S3Q==
X-Received: by 2002:a17:90a:6485:b0:237:461c:b44d with SMTP id h5-20020a17090a648500b00237461cb44dmr21061669pjj.46.1678339095527;
        Wed, 08 Mar 2023 21:18:15 -0800 (PST)
Received: from google.com (77.62.105.34.bc.googleusercontent.com. [34.105.62.77])
        by smtp.gmail.com with ESMTPSA id g3-20020a635203000000b005035f5e1f9csm10033068pgb.2.2023.03.08.21.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 21:18:15 -0800 (PST)
Date:   Thu, 9 Mar 2023 05:18:11 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     Zhi Wang <zhi.wang.linux@gmail.com>, seanjc@google.com,
        pbonzini@redhat.com, bgardon@google.com, dmatlack@google.com,
        jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v4 03/18] KVM: x86/mmu: Track count of pages in KVM MMU
 page caches globally
Message-ID: <ZAlsE0dei9I1MfpW@google.com>
References: <20230306224127.1689967-1-vipinsh@google.com>
 <20230306224127.1689967-4-vipinsh@google.com>
 <20230308223331.00000234@gmail.com>
 <CAHVum0cMAwyQamr5yxCB56DSy7QHuCvTG06qRrJCGiZWQV+ZTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHVum0cMAwyQamr5yxCB56DSy7QHuCvTG06qRrJCGiZWQV+ZTw@mail.gmail.com>
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

> >
> > 1) Previously mmu_topup_memory_caches() works fine without a lock.
> > 2) IMHO I was suspecting if this lock seems affects the parallelization
> > of the TDP MMU fault handling.
> >
> > TDP MMU fault handling is intend to be optimized for parallelization fault
> > handling by taking a read lock and operating the page table via atomic
> > operations. Multiple fault handling can enter the TDP MMU fault path
> > because of read_lock(&vcpu->kvm->mmu_lock) below.
> >
> > W/ this lock, it seems the part of benefit of parallelization is gone
> > because the lock can contend earlier above. Will this cause performance
> > regression?
> 
> This is a per vCPU lock, with this lock each vCPU will still be able
> to perform parallel fault handling without contending for lock.
> 

I am curious how effective it is by trying to accquiring this per vCPU
lock? If a vcpu thread should stay within the (host) kernel (vmx
root/non-root) for the vast majority of the time, isn't the shrinker
always fail to make any progress?
