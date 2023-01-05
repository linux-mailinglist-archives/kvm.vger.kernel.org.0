Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECEBA65F6D2
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 23:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236041AbjAEWcX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 17:32:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236065AbjAEWcB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 17:32:01 -0500
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39431140CB
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 14:31:59 -0800 (PST)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-142b72a728fso44508418fac.9
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 14:31:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bzW/w/1hM8B3dAJhNRkp0Jphokn3JFk7Z5V07SJ3Qvg=;
        b=irhVthMkbXMEX15iArMrcDY5gNuF5eBvK4eo1OtUylhsmE3IG9S+mrhZxQOiqFOCIp
         B0NdfYGQgplol+qXFg23OWfulPwvSU6W3PDU1vto6PpvE0VAeFfNIFN4a8ZuHbQY9yux
         PXeSKyeq3An9rFPoa3fVNGzGEqqWpmTNW/IhDMPZHTEGo5GXlC3tHCL+PpUMhytJ91mi
         VnE7MFoMeikcgMvkL5CbthLdijfrodW+nJq5InxHQqUSFW5SY7wrPzcsnCf8IgP9ADVl
         OSDDZsGxvXwBgux7z61kSSUwbOnmCiTQmx5XrBl1LtTxgEFPc4Tdi1LcRhBuf47g7+EW
         8CKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bzW/w/1hM8B3dAJhNRkp0Jphokn3JFk7Z5V07SJ3Qvg=;
        b=hbDDMIM2u43whI2PHUuIw27KT2nc9f8EtFjNoWZ2M67+4lzSx0vgXgjEytfSL25xIW
         mgD9G0AfHXr7lSQqQIz5/mf+pxqVt88XXUOKjwVlMZ2TcWhGGWZ9xK6/a0sdtDzvKud+
         uY3me0nyxGY3gLAvddHvOS0vsCbGTZqIRSZj/r9ncWnJ2xCwt0xYKRXx1qaOIqvCCssP
         gLNVKw4TBUHCikEhKSWY8RfzrLtd5HBjJCXsoR2NypjDW92XHf2u/BfGqIFEAbuFUc3g
         K22rCH/cSytd3UnnkWCsgwx9BfId1IHnaw8Cec9loAwneJZ0KtBPP7qnSS55u0yMsKJl
         rvkw==
X-Gm-Message-State: AFqh2kqD5YzAH/FI7wwMncvvBPutyxeET3hjg/ZrrFk9bG/gmkfCBmBn
        WCiCaMXQW+lUBnrAfFusoUH8anBieWw3bL4sPXp36Q==
X-Google-Smtp-Source: AMrXdXuhK0FyKkeqVW5l22eKW+0UG+HL1l0rnz8gKZ4dAVgXGahu6I04Z2YvHkfHXjMPojl5mAzlig7pu90phEAYxnc=
X-Received: by 2002:a05:6870:b020:b0:14f:9d87:3d58 with SMTP id
 y32-20020a056870b02000b0014f9d873d58mr4259851oae.108.1672957918361; Thu, 05
 Jan 2023 14:31:58 -0800 (PST)
MIME-Version: 1.0
References: <cover.1655761627.git.ashish.kalra@amd.com> <243778c282cd55a554af9c11d2ecd3ff9ea6820f.1655761627.git.ashish.kalra@amd.com>
 <YuFvbm/Zck9Tr5pq@zn.tnic> <20221219150026.bltiyk72pmdc2ic3@amd.com>
 <Y6DEv4QuvIfwWlCW@zn.tnic> <ab96e918-c8b7-67d5-1dfd-320264858cec@amd.com>
 <CAA03e5GKCcevo7goyyRqWrgk3KeFPTddb-E2pRmgDmyPSNxDvA@mail.gmail.com> <993e0896-cda6-5033-ad0e-e21508a58077@amd.com>
In-Reply-To: <993e0896-cda6-5033-ad0e-e21508a58077@amd.com>
From:   Marc Orr <marcorr@google.com>
Date:   Thu, 5 Jan 2023 14:31:47 -0800
Message-ID: <CAA03e5EZtTqNHOuKAPKpw0xJ_tSa4DYCAf-nSDqsjaSxbJZVkg@mail.gmail.com>
Subject: Re: [PATCH Part2 v6 07/49] x86/sev: Invalid pages from direct map
 when adding it to RMP table
To:     "Kalra, Ashish" <ashish.kalra@amd.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        alpergun@google.com, dgilbert@redhat.com, jarkko@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-14.3 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 5, 2023 at 2:27 PM Kalra, Ashish <ashish.kalra@amd.com> wrote:
>
> Hello Marc,
>
> On 1/5/2023 4:08 PM, Marc Orr wrote:
> > On Tue, Dec 27, 2022 at 1:49 PM Kalra, Ashish <ashish.kalra@amd.com> wrote:
> >>
> >> Hello Boris,
> >>
> >> On 12/19/2022 2:08 PM, Borislav Petkov wrote:
> >>> On Mon, Dec 19, 2022 at 09:00:26AM -0600, Michael Roth wrote:
> >>>> We implemented this approach for v7, but it causes a fairly significant
> >>>> performance regression, particularly for the case for npages > 1 which
> >>>> this change was meant to optimize.
> >>>>
> >>>> I still need to dig in a big but I'm guessing it's related to flushing
> >>>> behavior.
> >>>
> >>> Well, AFAICT, change_page_attr_set_clr() flushes once at the end.
> >>>
> >>> Don't you need to flush when you modify the direct map?
> >>>
> >>
> >> Milan onward, there is H/W support for coherency between mappings of the
> >> same physical page with different encryption keys, so AFAIK, there
> >> should be no need to flush during page state transitions, where we
> >> invoke these direct map interface functions for re-mapping/invalidating
> >> pages.
> >>
> >> I don't know if there is any other reason to flush after modifying
> >> the direct map ?
> >
> > Isn't the Milan coherence feature (SME_COHERENT?) about the caches --
> > not the TLBs? And isn't the flushing being discussed here about the
> > TLBs?
>
> Actually, the flush does both cache and TLB flushing.
>
> Both cpa_flush() and cpa_flush_all() will also do cache flushing if
> cache argument is not NULL. As in this case, no page caching attributes
> are being changed so there is no need to do cache flushing.
>
> But TLB flushing (as PTE is updated) is still required and will be done.

Ah, got it now. Thanks for explaining. (I should've looked at the code
a bit closer.)

> > Also, I thought that Mingwei Zhang <mizhang@google.com> found that the
> > Milan SEV coherence feature was basically unusable in Linux because it
> > only works across CPUs. It does not extend to IO (e.g., CPU caches
> > need to be flushed prior to free'ing a SEV VM's private address and
> > reallocating that location to a device driver to be used for IO). My
> > understanding of this feature and its limitations may be too coarse.
> > But I think we should be very careful about relying on this feature as
> > it is implemented in Milan.
> >
> > That being said, I guess I could see an argument to rely on the
> > feature here, since we're not deallocating the memory and reallocating
> > it to a device. But again, I thought the feature was about cache
> > coherence -- not TLB coherence.
>
> Yes, this is just invalidating or re-mapping into the kernel direct map,
> so we can rely on this feature for the use case here.

SGTM and that does make sense then. Thanks for confirming.
