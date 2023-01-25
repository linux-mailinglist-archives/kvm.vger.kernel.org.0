Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5495467B3CA
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 15:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235451AbjAYOCZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 09:02:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234845AbjAYOCY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 09:02:24 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BCC746167
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 06:02:23 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id p24so17915932plw.11
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 06:02:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fZYFohxyhSAaeW4KtaLYOnXfDuTgewaTHnhHk7GpMuQ=;
        b=tlnRFbBMRswPjV7bhI3DJO9zWdwBzbEnLfQzhAGn5hsVjuG9CADcm5eA+/0ewSsqnb
         3SCPRuMxWASijEOXkVwkWGMWp1hB0jlNEpqbNPMQp/AANy3dBhuShMUP+o27oMzj88KF
         GoAMjTI3LAvNmo8TOKGmPpvDfpUC3rvKMtcskI8H0BiE/ksTZXcBO+zavTXgjpunyOUV
         oMwCa/kIdQtT6Grv8wS8m3TTihXAmXdqrhl94JW8LSTaJ3YYQ+RDjqA/lScUOrdW6Nfw
         duA4fG1moXI8GgopNnnH97ndWHBwjSJekGb7O+qs3dal4MXTEOLJ0mc1Hhh+LnUpyxyK
         lLpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fZYFohxyhSAaeW4KtaLYOnXfDuTgewaTHnhHk7GpMuQ=;
        b=0oKaVcJvbbFxG+MwSVSOFLbDj56Kb5WqAoP8hzz5LmURGk2TmKovpdOetkBkHU0oWz
         K9TTOcwjU3hg36qNLjkMVGJaCwnbiWdK8JQIoLf/vYyBH1ifQcTF37HNvMLuVohbGjo5
         CWvQ29UdVszvDCE1zvU+Suz7L+be98Z6CVRePhDEcUUwJK1LMMBGgMXY7FPwyF69QcCy
         pLO/l479E57d+NXmlZQ5j8PeBrLdARpVD+Zd9ccADopRG0TgK5/iYRo+nqZPoxyc0TMC
         O6UsHL7EGwEJSY5MBwf3tMoJcSDhGzL+GQNC/664f0EpSlEETZhWBYyLRhCv/rTvqogs
         xrVg==
X-Gm-Message-State: AO0yUKVSXKxje1dlAItxzR/QrSz5EstkjTe+XdhEHE3Q0cj1jLz9g3Hh
        mPGaPOG+9lz+Rewi65gaNlNpnQ==
X-Google-Smtp-Source: AK7set8RjeV/r3KqM2QRvgkRE2LtEAqqVKHe5yrHEuN+cBS7rAZx7qVCOKbR0frvnxDE7+V8WslrFQ==
X-Received: by 2002:a17:90a:eb06:b0:22c:952:ab22 with SMTP id j6-20020a17090aeb0600b0022c0952ab22mr219929pjz.1.1674655342744;
        Wed, 25 Jan 2023 06:02:22 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id mt21-20020a17090b231500b0022941908b80sm1661491pjb.47.2023.01.25.06.02.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 06:02:22 -0800 (PST)
Date:   Wed, 25 Jan 2023 06:02:18 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev,
        pbonzini@redhat.com, alexandru.elisei@arm.com,
        eric.auger@redhat.com, yuzenghui@huawei.com
Subject: Re: [PATCH 4/4] KVM: selftests: aarch64: Test read-only PT memory
 regions
Message-ID: <Y9E2atXyP/7Zzly6@google.com>
References: <20230110022432.330151-1-ricarkol@google.com>
 <20230110022432.330151-5-ricarkol@google.com>
 <Y88aFBBcsx7v/2qh@google.com>
 <Y9AGmn0CM/lNX6w/@google.com>
 <Y9A3kVCnVgl+x5UJ@thinky-boi>
 <864jsen6li.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <864jsen6li.wl-maz@kernel.org>
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

On Wed, Jan 25, 2023 at 12:26:01PM +0000, Marc Zyngier wrote:
> On Tue, 24 Jan 2023 19:54:57 +0000,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > On Tue, Jan 24, 2023 at 08:26:02AM -0800, Ricardo Koller wrote:
> > > On Mon, Jan 23, 2023 at 11:36:52PM +0000, Oliver Upton wrote:
> > > > On Tue, Jan 10, 2023 at 02:24:32AM +0000, Ricardo Koller wrote:
> > > > > Extend the read-only memslot tests in page_fault_test to test read-only PT
> > > > > (Page table) memslots. Note that this was not allowed before commit "KVM:
> > > > > arm64: Fix handling of S1PTW S2 fault on RO memslots" as all S1PTW faults
> > > > > were treated as writes which resulted in an (unrecoverable) exception
> > > > > inside the guest.
> > > > 
> > > > Do we need an additional test that the guest gets nuked if TCR_EL1.HA =
> > > > 0b1 and AF is clear in one of the stage-1 PTEs?
> > > > 
> > > 
> > > That should be easy to add. The only issue is whether that's also a case
> > > of checking for very specific KVM behavior that could change in the
> > > future.
> > 
> > From the perspective of the guest I believe this to match the
> > architecture. An external abort is appropriate if the hardware update to
> > a descriptor failed.
> > 
> > I believe that the current implementation of this in KVM is slightly
> > wrong, though. AFAICT, we encode the abort with an FSC of 0x10, which
> > indicates an SEA occurred outside of a table walk. The other nuance of
> > reporting SEAs due to a TTW is that the FSC encodes the level at which
> > the external abort occurred. Nonetheless, I think we can hide behind
> > R_BGPQR of DDI0487I.a and always encode a level of 0:
> > 
> > """
> >   If a synchronous External abort is generated due to a TLB or
> >   intermediate TLB caching structure, including parity or ECC errors,
> >   then all of the following are permitted:
> >    - If the PE cannot precisely determine the translation stage at which
> >      the error occurred, then it is reported and prioritized as a stage 1
> >      fault.
> >    - If the PE cannot precisely determine the lookup level at which the
> >      error occurred, then the lookup level is reported and prioritized
> >      as one of the following:
> >      - The lowest-numbered lookup level that could have caused the error.
> >      - If the PE cannot determine any information about the lookup level,
> >      then level 0.
> > """
> > 
> > Thoughts?
> 
> Indeed, the abort injection has always been on the dodgy side of
> things. I remember Christoffer and I writing this, saying that it was
> something we'd have to eventually fix. 10 years down the line, this
> code is, unsurprisingly, still dodgy.
> 
> My vote would be to slightly extend the API to take a set of
> KVM-specific flags to give context to the injection helpers (such as
> SEA during a TTW), and bring the KVM behaviour in line with the
> architecture.
> 
> Reporting 0 in the FSC is probably OK, but we should also be able to
> determine which level this fails at:
> 
> - Sample FAR_EL2[55] to derive which TTBR this translates from (n)
> - From TCR_EL1.{TnSZ,TGn}, you can determine the number of levels
> 
> There is a bunch of tables for this in the ARM ARM, and it is possible
> to come up with a decent formula that encompass all the possible
> combinations.
> 
> But as I said, 0 is probably fine... ;-)
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
> 

Thank you both.

So, what about the following? I can send a series after this that
includes a KVM fix to report level 0 in the FSC in this S1PTW case, and
an extra test that checks that the exception comes with some sane values
(like a sane level in the FSC). Then, getting the actual lookup level
can be added as an improvement (with less priority than the first fix).

Ricardo
