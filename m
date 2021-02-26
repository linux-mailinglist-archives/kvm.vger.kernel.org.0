Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99A732666C
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 18:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhBZRpd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 12:45:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhBZRp3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 12:45:29 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52942C061574
        for <kvm@vger.kernel.org>; Fri, 26 Feb 2021 09:44:49 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id t25so6648092pga.2
        for <kvm@vger.kernel.org>; Fri, 26 Feb 2021 09:44:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CoeO2iZ8xxu68vAL8jtiT4/h7hy4METDWBDneXDpQxo=;
        b=ouVOwFpkPYNO37bwVrVblcq6bdqnNueRnAoPvaIRj9dTVaF2y3M8Go2waK15V1HwD5
         rfvm5PYKw3zdHnlmTCCgYI1KKjMioBR9fhCV/fdHJHGZS6WHTbEFy9SE1PpSGAQdrMkz
         1+e15FpWoykh7n9vfrtbUetWHQ5iMElXOe29lKFufFsCTYK2GH+o3YR+loynpTyglkvu
         2rTGt6LX8RvzGNkbq0+lhfnTAUFZARik9n9xhd3h/409mpd/wAfgWMZbwJ/UJqXcUuMF
         4CUVQTaRSjAHLHyzPVUy1epDPYvOid6DrzuCXkvIm8iNNAYV0VDB/d/1ZFFap/kla1Hb
         bcvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CoeO2iZ8xxu68vAL8jtiT4/h7hy4METDWBDneXDpQxo=;
        b=oj555JurAm60S8BE06XN/CBEhell53ouO68GuLtbPaFWHesDJGsvsxJCHou+9aHDaS
         yB5IQeVz3O8vUNflareFpMSC52pcUSxu8uspdR8wujYzc/KRPEgzRcAJKrj5U0ybnF73
         WeShrXmq223ipInEdJVKvh0oHVAGix6oktnBZ9hFwlq35WsLLOLW+aljIm3af+Pe+t3V
         j2ROAgJkG+Ule40Eu1BnxMsl9h/6FsAnqeSdS/Xu0Dp664lhYGeNYJrMPgiP7oBjgV7J
         iy8CN5IYENNijJyabiQobXY5h2059bdSPdumvBL7zKvleuejQfyrdgw8OFxXKymHfNyH
         xBsA==
X-Gm-Message-State: AOAM530yL8oWkBP4/sK506KDmdo3krwG/Wk7NirzsLOGTVCxR7pgLLsw
        CyKuEpT5iCN/fFDKACWcMvFDFg==
X-Google-Smtp-Source: ABdhPJwjWOEc7YomYdRhrCUuSr7CR6m145f91kjNCg5blLJKeSXZqiBSwHAQuofeiHLWAwbe6oLYJQ==
X-Received: by 2002:a63:4753:: with SMTP id w19mr3792496pgk.394.1614361488694;
        Fri, 26 Feb 2021 09:44:48 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e190:bf4c:e355:6c55])
        by smtp.gmail.com with ESMTPSA id p29sm9214572pgm.64.2021.02.26.09.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 09:44:48 -0800 (PST)
Date:   Fri, 26 Feb 2021 09:44:41 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     Steve Rutherford <srutherford@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "venu.busireddy@oracle.com" <venu.busireddy@oracle.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v10 10/16] KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIST
 ioctl
Message-ID: <YDkzibkC7tAYbfFQ@google.com>
References: <cover.1612398155.git.ashish.kalra@amd.com>
 <7266edd714add8ec9d7f63eddfc9bbd4d789c213.1612398155.git.ashish.kalra@amd.com>
 <YCxrV4u98ZQtInOE@google.com>
 <SN6PR12MB27672FF8358D122EDD8CC0188E859@SN6PR12MB2767.namprd12.prod.outlook.com>
 <20210224175122.GA19661@ashkalra_ubuntu_server>
 <YDaZacLqNQ4nK/Ex@google.com>
 <20210225202008.GA5208@ashkalra_ubuntu_server>
 <CABayD+cn5e3PR6NtSWLeM_qxs6hKWtjEx=aeKpy=WC2dzPdRLw@mail.gmail.com>
 <20210226140432.GB5950@ashkalra_ubuntu_server>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210226140432.GB5950@ashkalra_ubuntu_server>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Will and Quentin (arm64)

Moving the non-KVM x86 folks to bcc, I don't they care about KVM details at this
point.

On Fri, Feb 26, 2021, Ashish Kalra wrote:
> On Thu, Feb 25, 2021 at 02:59:27PM -0800, Steve Rutherford wrote:
> > On Thu, Feb 25, 2021 at 12:20 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> > Thanks for grabbing the data!
> > 
> > I am fine with both paths. Sean has stated an explicit desire for
> > hypercall exiting, so I think that would be the current consensus.

Yep, though it'd be good to get Paolo's input, too.

> > If we want to do hypercall exiting, this should be in a follow-up
> > series where we implement something more generic, e.g. a hypercall
> > exiting bitmap or hypercall exit list. If we are taking the hypercall
> > exit route, we can drop the kvm side of the hypercall.

I don't think this is a good candidate for arbitrary hypercall interception.  Or
rather, I think hypercall interception should be an orthogonal implementation.

The guest, including guest firmware, needs to be aware that the hypercall is
supported, and the ABI needs to be well-defined.  Relying on userspace VMMs to
implement a common ABI is an unnecessary risk.

We could make KVM's default behavior be a nop, i.e. have KVM enforce the ABI but
require further VMM intervention.  But, I just don't see the point, it would
save only a few lines of code.  It would also limit what KVM could do in the
future, e.g. if KVM wanted to do its own bookkeeping _and_ exit to userspace,
then mandatory interception would essentially make it impossible for KVM to do
bookkeeping while still honoring the interception request.

However, I do think it would make sense to have the userspace exit be a generic
exit type.  But hey, we already have the necessary ABI defined for that!  It's
just not used anywhere.

	/* KVM_EXIT_HYPERCALL */
	struct {
		__u64 nr;
		__u64 args[6];
		__u64 ret;
		__u32 longmode;
		__u32 pad;
	} hypercall;


> > Userspace could also handle the MSR using MSR filters (would need to
> > confirm that).  Then userspace could also be in control of the cpuid bit.

An MSR is not a great fit; it's x86 specific and limited to 64 bits of data.
The data limitation could be fudged by shoving data into non-standard GPRs, but
that will result in truly heinous guest code, and extensibility issues.

The data limitation is a moot point, because the x86-only thing is a deal
breaker.  arm64's pKVM work has a near-identical use case for a guest to share
memory with a host.  I can't think of a clever way to avoid having to support
TDX's and SNP's hypervisor-agnostic variants, but we can at least not have
multiple KVM variants.

> > Essentially, I think you could drop most of the host kernel work if
> > there were generic support for hypercall exiting. Then userspace would
> > be responsible for all of that. Thoughts on this?

> So if i understand it correctly, i will submitting v11 of this patch-set
> with in-kernel support for page encryption status hypercalls and shared
> pages list and the userspace control of SEV live migration feature
> support and fixes for MSR handling.

At this point, I'd say hold off on putting more effort into an implementation
until we have consensus.

> In subsequent follow-up patches we will add generic support for hypercall 
> exiting and then drop kvm side of hypercall and also add userspace
> support for MSR handling.
> 
> Thanks,
> Ashish
