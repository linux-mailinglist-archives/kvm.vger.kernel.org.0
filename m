Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA31E3B34D1
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 19:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbhFXReA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 13:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbhFXRd6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 13:33:58 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA77C061756
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 10:31:39 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id s14so4508845pfg.0
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 10:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NXamga020V8fjrq0TD0oEXX5F6d6dS3uFOlZ6LFMVgk=;
        b=aZifHySwD6uqla8CbsEA8UeI3E6CaFVu27HO+tY9wsjDTSz58+wBjYyT2qmY2igqRO
         P/+L8s8JSxztaIRiXP5K7COaLxoOODkvnk3Y/QwDhy/sV41HLoD+NIg6LjRU6z0XoYRa
         1esbz2gpJdzoIb8O4yqgP66KsMBFIytRIL56eSR8GXw2eXAvq/+qmpZ0KZ+dFubW+1hJ
         3B0a7hdU/lj2FsfDhSTa0AIVDPP+EhcFmeFWnVSXOHts9/+FlxDAo+QNrCa5qAAHXVxU
         /mOoTwXjEM4OgBy24EwpN6TtRwZA8Lwg12Pfc1YOPBMjBclFs1W8Jiia2vKB2v3rdITL
         JCmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NXamga020V8fjrq0TD0oEXX5F6d6dS3uFOlZ6LFMVgk=;
        b=QoweoyCgxwu3XXgG+/KJUl2o4ttiSyazf3YA76Uw/GBSLEGGQsVK/GgD/R2xIgaEoF
         qOKAjkdSXxKhpdQzsOkKXyuvjpknEj9r1Cf3IEJq9FPQpALRoScRfc1w+nbLDU0K6tw3
         JPXOPl2ecqUjCmznnXYCulTF8EPxVX8INrEmqXwW+T5c9HxbcnNWuj/brxFQXHGQCj4b
         VNgURfLgZ2K9QRYhfO9OdTh6ncFBXQFd0szDnl74dJddJl3D3FNf5TicorqEzl8v9jeQ
         W2Z8vPLkhbTdJvIAc/REFcv33mqtcw/BmUv2OpQ4aemOB5Wygr6KkV67Er3ipz+eBFnR
         luFg==
X-Gm-Message-State: AOAM530U16lD1BuFsR1VGxfUVB3WEJ8lulvD17aSQdcv3Svn2M60Y+Jn
        H5P/Jqqrq7buJMlpFGfuYpe64w==
X-Google-Smtp-Source: ABdhPJzZUXZwE3+5MgxJcPLiUKe38W/ONBPOJbcLxp4oI7xcGJlN2iewrx4qCOjx/mxGoBtq+RPMOQ==
X-Received: by 2002:a65:6914:: with SMTP id s20mr5641081pgq.420.1624555899193;
        Thu, 24 Jun 2021 10:31:39 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id oc9sm2714548pjb.43.2021.06.24.10.31.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 10:31:38 -0700 (PDT)
Date:   Thu, 24 Jun 2021 17:31:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH 0/7] KVM: x86: guest MAXPHYADDR and C-bit fixes
Message-ID: <YNTBdvWxwyx3T+Cs@google.com>
References: <20210623230552.4027702-1-seanjc@google.com>
 <324a95ee-b962-acdf-9bd7-b8b23b9fb991@amd.com>
 <c2d7a69a-386e-6f44-71c2-eb9a243c3a78@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2d7a69a-386e-6f44-71c2-eb9a243c3a78@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 24, 2021, Tom Lendacky wrote:
> > 
> > Here's an explanation of the physical address reduction for bare-metal and
> > guest.
> > 
> > With MSR 0xC001_0010[SMEE] = 0:
> >   No reduction in host or guest max physical address.
> > 
> > With MSR 0xC001_0010[SMEE] = 1:
> > - Reduction in the host is enumerated by CPUID 0x8000_001F_EBX[11:6],
> >   regardless of whether SME is enabled in the host or not. So, for example
> >   on EPYC generation 2 (Rome) you would see a reduction from 48 to 43.
> > - There is no reduction in physical address in a legacy guest (non-SEV
> >   guest), so the guest can use a 48-bit physical address

So the behavior I'm seeing is either a CPU bug or user error.  Can you verify
the unexpected #PF behavior to make sure I'm not doing something stupid?

Thanks!

> > - There is a reduction of only the encryption bit in an SEV guest, so
> >   the guest can use up to a 47-bit physical address. This is why the
> >   Qemu command line sev-guest option uses a value of 1 for the
> >   "reduced-phys-bits" parameter.
> > 
> 
> The guest statements all assume that NPT is enabled.
> 
> Thanks,
> Tom
