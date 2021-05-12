Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0264837CBE4
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 19:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236751AbhELQiv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 12:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238544AbhELQaZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 12:30:25 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116DFC08EACA
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 09:03:09 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id t21so12755619plo.2
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 09:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aVmYs+apRTUqz4G5EyhD9SbyJQ4D0L1K0aWCoYWQfJ4=;
        b=s5qzg3DgtagxZgqEuCvBBT9OJVOYAC90VkRdOaYWhLb/+zDfsksL1iYK1XGsNDvdKS
         t6BB+PVuYZW91u4G+0W2cD57E41ffaMQlDL+kkRggWgcTQDISSVFfRAOFir9rLHowdR6
         aI2zTQB2pncjxwwjlgPG4omBnQRJ4NMd9slrMqnVnlmdry/svKybNOtRvq9f8e6dy2m3
         axJIU4o1dZvAxanU/HnpK6skIvd1XRLHcU+cRlaHLhCIIzAzrggk5I7QtDmksB6RQ2r2
         2nBp/Cywyl9r1xuiS7q4aGDQKvhVTQfVp7KKRiJAqBeDtreSkdI4WzC8cRmWVrdFuXPn
         mWcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aVmYs+apRTUqz4G5EyhD9SbyJQ4D0L1K0aWCoYWQfJ4=;
        b=kWkyR7eHLgR5BwrUoRw6/6tUbXzCs280YaMDj+IendYM/PF1qYTSBgpF8Lw29RK5tD
         cC9v5hD868mj0uuePz66uXx0Z9vNVxHAbUv+MIzasBqsAsrIaCHl6TPWaTHzrnlgrG1d
         eBvIu0hR6fwgntcsdh5uQcRvtgE2wO/M85KjKzofKyVG8FOoOxXVZRSQCO3Gs7wn2U4h
         Wk9gQW+1ZdBDbhR8BCxAcGxIIDuXQkIqtQnMFdxw8kih5GZj+SNtSCMfcVZ3GZAztyrH
         hr7vIiZ72TYYkwRvfb09EqpgBLDjz1yPpPZZOLPn2+/nTKrDWLy7v5qQ+VFVs3vSjbmN
         ZjkQ==
X-Gm-Message-State: AOAM531UPKvqasJvcCjM4JwZ3FiNigBEyUvRIRRp9K210XB0EqZml87Q
        0n4AaYRfyJWCVE1BlLrAu6hedA==
X-Google-Smtp-Source: ABdhPJy7Ar45AwH9wnKOlmuIMHWU46FfLre/sapwc88FmtcyWz+BGSUr9GP3erEG+vu+s1aHbuf/6w==
X-Received: by 2002:a17:902:e84c:b029:ee:d129:3b1c with SMTP id t12-20020a170902e84cb02900eed1293b1cmr35466669plg.73.1620835385927;
        Wed, 12 May 2021 09:03:05 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id j7sm223478pfd.129.2021.05.12.09.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 09:03:05 -0700 (PDT)
Date:   Wed, 12 May 2021 09:03:01 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Zenghui Yu <yuzenghui@huawei.com>,
        Auger Eric <eric.auger@redhat.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com,
        drjones@redhat.com, alexandru.elisei@arm.com
Subject: Re: [PATCH v2 4/5] KVM: selftests: Add exception handling support
 for aarch64
Message-ID: <YJv8NUtKilXPDYpY@google.com>
References: <20210430232408.2707420-1-ricarkol@google.com>
 <20210430232408.2707420-5-ricarkol@google.com>
 <87a6pcumyg.wl-maz@kernel.org>
 <YJBLFVoRmsehRJ1N@google.com>
 <20915a2f-d07c-2e61-3cce-ff385e98e796@redhat.com>
 <4f7f81f9-8da0-b4ef-49e2-7d87b5c23b15@huawei.com>
 <a5ad32abf4ff6f80764ee31f16a5e3fc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5ad32abf4ff6f80764ee31f16a5e3fc@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 12, 2021 at 02:43:28PM +0100, Marc Zyngier wrote:
> On 2021-05-12 13:59, Zenghui Yu wrote:
> > Hi Eric,
> > 
> > On 2021/5/6 20:30, Auger Eric wrote:
> > > running the test on 5.12 I get
> > > 
> > > ==== Test Assertion Failure ====
> > >   aarch64/debug-exceptions.c:232: false
> > >   pid=6477 tid=6477 errno=4 - Interrupted system call
> > >      1	0x000000000040147b: main at debug-exceptions.c:230
> > >      2	0x000003ff8aa60de3: ?? ??:0
> > >      3	0x0000000000401517: _start at :?
> > >   Failed guest assert: hw_bp_addr == PC(hw_bp) at
> > > aarch64/debug-exceptions.c:105
> > > 	values: 0, 0x401794
> > 
> > FYI I can also reproduce it on my VHE box. And Drew's suggestion [*]
> > seemed to work for me. Is the ISB a requirement of architecture?
> 
> Very much so. Given that there is no context synchronisation (such as
> ERET or an interrupt) in this code, the CPU is perfectly allowed to
> delay the system register effect as long as it can.
> 
>         M.
> -- 
> Jazz is not dead. It just smells funny...

Thank you very much Eric, Zenghui, Marc, and Andrew (for the ISB
suggestion)!

As per Zenghui test, will send a V3 that includes the missing ISBs.
Hopefully that will fix the issue for Eric as well. It's very
interesting that the CPU seems to _always_ reorder those instructions.

Thanks!
Ricardo
