Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF3A40B72B
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 20:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbhINSvF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 14:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232103AbhINSu6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 14:50:58 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D51C061762
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 11:49:40 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id me5-20020a17090b17c500b0019af76b7bb4so2273731pjb.2
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 11:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=561Sii/7Vnw9t2pBiBSueXkca1YF3r2gcFv6BNuZUlY=;
        b=CU3iuOhK9BrlY2sp64svAK319eSzl4i7OV0UM4XGwQGUtlXxAIdOw5MGZFb98qVQaC
         AgdKZO90Ph5BYBKt1POqky7wb5lJQg81Xb5aLjJ94nUeUy7YHNv29m/U1VbpdUsPf0vi
         4gtWz36S7QywD3t/xQW3YcrmLGz/LQp0QU9HLAl1fDE24BlR9L0ZQlBR6ks5tT60X08M
         NOQ6Q4vl8QobyEmb3AWoC9EtdZJlAAbfkcDSEGtR8kmsrm4nvjQaDR3t8Xjqs36djp4/
         nvBWFLZtNfEwHA58bTnFGm0W0etD9FZViZvn3nSyIk0W0ZilkekwtD4GfRVxq681wuw4
         cGDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=561Sii/7Vnw9t2pBiBSueXkca1YF3r2gcFv6BNuZUlY=;
        b=28p/6htjvK7LAfhA3VArrVtNt95GTOGcXD/n8UXQ55eLQtP6/5VbbYjzgiL263Kffp
         ZXFPnRC9IQWOakHgvu0IcmOlY4OC5OB5+tbcy+m0Onf7KYqR0Uw2Yn4awK6lWB7ecPvd
         6wR217GTN7g9g2+bWXPZgBiwS0duCcMKuWXAqkgFCELv0BF24W8l5XtQx3MEd6yTnYCR
         mMgMfIHrVT2kzrACy+L/j34Mi8HAq/Wi9LQCWKNIE6t1kHfoUBpcu/lnFVEYaIXcY9Oa
         7Nm5EnGQP+oO+QwwPZubzakOVeKmBQDkx+kCjd4WuAgpxRmGkPn7Bv/jL+IWKlcJKF28
         WJ/Q==
X-Gm-Message-State: AOAM532y7AgEt8eKXPWkbiO1XwOqLwwaHzXylcUF+Db0PC14uSm48Rg+
        StpguYK+9pNXdhQMeYb1gAHJqA==
X-Google-Smtp-Source: ABdhPJwxBVPIh/RHGq0S4bd1U+knOnT9PmKUjE9pFWhpavi7yhGEVSRkAvzte5tgrQfJI3J3wTLpnQ==
X-Received: by 2002:a17:90a:2:: with SMTP id 2mr3711554pja.77.1631645379434;
        Tue, 14 Sep 2021 11:49:39 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u15sm11739188pfl.14.2021.09.14.11.49.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 11:49:38 -0700 (PDT)
Date:   Tue, 14 Sep 2021 18:49:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Tempelman <natet@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: SEV: Disable KVM_CAP_VM_COPY_ENC_CONTEXT_FROM for
 SEV-ES
Message-ID: <YUDuv1aTauPz9aqo@google.com>
References: <20210914171551.3223715-1-pgonda@google.com>
 <YUDcvRB3/QOXSi8H@google.com>
 <CAMkAt6opZoFfW_DiyJUREBAtd8503C6j+ZbjS9YL3z+bhqHR8Q@mail.gmail.com>
 <YUDsy4W0/FeIEJDr@google.com>
 <CAMkAt6r9W=bTzLkojjAuc5VpwJnSzg7+JUp=rnK-jO88hSKmxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMkAt6r9W=bTzLkojjAuc5VpwJnSzg7+JUp=rnK-jO88hSKmxw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 14, 2021, Peter Gonda wrote:
> On Tue, Sep 14, 2021 at 12:41 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > -stable, for giggles
> >
> > On Tue, Sep 14, 2021, Peter Gonda wrote:
> > > On Tue, Sep 14, 2021 at 11:32 AM Sean Christopherson <seanjc@google.com> wrote:
> > > >
> > > > On Tue, Sep 14, 2021, Peter Gonda wrote:
> > > > > Copying an ASID into new vCPUs will not work for SEV-ES since the vCPUs
> > > > > VMSAs need to be setup and measured before SEV_LAUNCH_FINISH. Return an
> > > > > error if a users tries to KVM_CAP_VM_COPY_ENC_CONTEXT_FROM from an
> > > > > SEV-ES guest.
> > > >
> > > > What happens if userspace does KVM_CAP_VM_COPY_ENC_CONTEXT_FROM before the source
> > > > has created vCPUs, i.e. before it has done SEV_LAUNCH_FINISH?
> > >
> > > That's not enough. If you wanted to be able to mirror SEV-ES you'd
> > > also need to call LAUNCH_UPDATE_VMSA on the mirror's vCPUs before
> > > SEV_LAUNCH_FINISH. That is do-able but I was writing a small change to
> > > fix this bug. If mirroring of SEV-ES is wanted it's a much bigger
> > > change.
> >
> > Is it doable without KVM updates?  If so, then outright rejection may not be the
> > correct behavior.
> 
> I do not think so. You cannot call KVM_SEV_LAUNCH_UPDATE_VMSA on the mirror
> because svm_mem_enc_op() blocks calls from the mirror. So either you have to
> update vmsa from the mirror or have the original VM read through its mirror's
> vCPUs when calling KVM_SEV_LAUNCH_UPDATE_VMSA. Not sure which way is better
> but I don't see a way to do this without updating KVM.

Ah, right, I forgot all of the SEV ioctls are blocked on the mirror.  Put something
to that effect into the changelog to squash any argument about whether or not this
is the correct KVM behavior.

Thanks!
