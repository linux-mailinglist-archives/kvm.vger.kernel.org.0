Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D95839B5DB
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 11:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbhFDJX5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 05:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbhFDJX4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 05:23:56 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365CDC06174A
        for <kvm@vger.kernel.org>; Fri,  4 Jun 2021 02:22:10 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id n12so7347304pgs.13
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 02:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pcVIrrrWEUuSA+N6NdZCH+jzIyXyj1HQeo01ZwpdXxY=;
        b=T6vUk/4jMaY1sFB+ktO56Tu+hSYK1wiZBd79Qpkt7cR3wdk6RgqpEA+MqmoApExn4u
         Ki+XTdzY1lKdvlx+de9gaG+wdCW5+FLPTTH3w22d8er65zizi+PUDGgUHvaCEEPTouoT
         LUIBuV5Az0wlga/c+czm/LVkend9CKDw/kZwQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pcVIrrrWEUuSA+N6NdZCH+jzIyXyj1HQeo01ZwpdXxY=;
        b=aPHGXFcq1k2BYhihKRtiBEQGQFFKl03sTB6FlQPsdvbvqvZWSVYTANxP2jle74qqdj
         UQ0bFvO9AynGpbCIVNZs0dK+SKbOtCF2AGAx2c5FU0STAs37YxaeDG+HTRdLqxxFSPuN
         raiTDMgC8pfUJWvoAks/Ua0dYRu2PyJDSKYcZtT5y9LNDft87NLtOpo2mQMeRVS3K79c
         mXBIZVTB9rLhjcw+0j5ouYbywzXb4yP9dicOUl/oeR2zq7v7zZxt2v3TsYcY0UkmAPcb
         udQFI/bH5qASaeeDhzng7/AmVLTxii3i6+0R2rwMKCgU/f/bcWcvXVYi3nsnZykVRhA9
         +h0A==
X-Gm-Message-State: AOAM530ksqVGHqZK7xOPLsnBFQJgJFsDkC/HvDJBr3WdaVSTPJwO1al1
        yjcIxh57qmwiXJmr/rWiLewobw==
X-Google-Smtp-Source: ABdhPJyN+y7mCRzpjZlapAyCgZr6LbpUALEaLKem6t6vFwqQAQV8qZmVYl6DOYQnER784of3HxKE+Q==
X-Received: by 2002:aa7:82cb:0:b029:2e6:f397:d248 with SMTP id f11-20020aa782cb0000b02902e6f397d248mr3647517pfn.52.1622798529641;
        Fri, 04 Jun 2021 02:22:09 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:36b:f5b6:c380:9ccf])
        by smtp.gmail.com with ESMTPSA id d15sm4208168pjr.47.2021.06.04.02.22.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 02:22:09 -0700 (PDT)
Date:   Fri, 4 Jun 2021 18:22:02 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Suleiman Souhlal <suleiman@google.com>, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [RFC][PATCH] kvm: add suspend pm-notifier
Message-ID: <YLnwum6AtcURNlRL@google.com>
References: <20210603164315.682994-1-senozhatsky@chromium.org>
 <87a6o614dn.fsf@vitty.brq.redhat.com>
 <e4b4e872-4b22-82b7-57fc-65a7d10482c0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4b4e872-4b22-82b7-57fc-65a7d10482c0@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On (21/06/04 09:24), Paolo Bonzini wrote:
> On 04/06/21 09:21, Vitaly Kuznetsov wrote:
> > >   	preempt_notifier_inc();
> > > +	kvm_init_pm_notifier(kvm);
> > You've probably thought it through and I didn't but wouldn't it be
> > easier to have one global pm_notifier call for KVM which would go
> > through the list of VMs instead of registering/deregistering a
> > pm_notifier call for every created/destroyed VM?
> 
> That raises questions on the locking, i.e. if we can we take the kvm_lock
> safely from the notifier.

Right, I wanted to take the VM lock, rather than subsystem lock
(kvm_lock).
