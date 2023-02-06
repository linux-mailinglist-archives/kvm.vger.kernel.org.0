Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF2068C376
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 17:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbjBFQgC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 11:36:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbjBFQf7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 11:35:59 -0500
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B22982448F
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 08:35:56 -0800 (PST)
Received: by mail-qk1-x72b.google.com with SMTP id r187so5531465qkf.10
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 08:35:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pJSM6kqcjnSPjdSGT0HvLgqZqIrYtsqkRhyhi3guF6Y=;
        b=M8+isMLu4lCdK/uvwHfbX/fOotVlr1yruayEoQUgKnNaOGMLDziT9zDXJpoVntYJut
         fQ6DA2ivKUK+tizCdVMVyFHkU43S+tObzACC8H6Ck3D8SxJpp/LDxVJCnY8zxwN2ioTI
         OtVRmCVpmsqRloSdebgZ5Jp5A4s9zXmS3Gngx3PxOl0sqsr43y54olC3X6I3b0bllfbY
         ouDtBIzfDhxy7y8LSYgYAzBfPmgwW8WwUZoQGQap18dHdLdULV9DKSGUtabZSYHhXWRl
         yL/2NEnAg2yP8LwaDvFngm0hpLeyFyV12IsZEvE5inx1HWUE8iAUxaow5syqzRgCwfO7
         rlLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pJSM6kqcjnSPjdSGT0HvLgqZqIrYtsqkRhyhi3guF6Y=;
        b=fNoMix4b+THtWNqjlIyoj1J3l8bBDsx5qI/ZvSBnmhgU75gLIFftJFI1zIwx39IVWb
         FgwDz3Yq5ImP0yFTncXtLYEf6m1bPd5GrlMCUjVMHkOhGygTBpmHGuGDgeDktwjP6ygk
         g3nI2yHRzipz4OrgzVMYFgrrwOM8MasrGO2q/uNiMV6KbYvbN+tNlsheReTAonlWO20Z
         wG7T+wFYM+0j5teDyseRWFYsCi013hqzfySRfJ5yQ9XNR4YhnamOh+1YMDmYFNe8+U/D
         w21THXxVAvz1AzHanZD+bps7wBtZt1cErocL/BwZyM3PTb1kPuw+TfDPxi5HDHT5peFe
         o47A==
X-Gm-Message-State: AO0yUKWhl6HDxzSI328vAjkEQqx/ip8xLKHHWsUn6kquDqNNG7P8suVS
        z/iKmMKje9om9H8UXZ+AT/LcxeI8N7gYX1zOVQ+fGg==
X-Google-Smtp-Source: AK7set+s81reoHeglIfhP5y+W2Szu/NtmUcpv6g11YSkDaoDhJKIr+ZuCmsC1PlOUu+GJvolTPPl29WIZKJgLEb07bA=
X-Received: by 2002:a05:620a:4483:b0:72b:ada6:1295 with SMTP id
 x3-20020a05620a448300b0072bada61295mr1064250qkp.211.1675701355731; Mon, 06
 Feb 2023 08:35:55 -0800 (PST)
MIME-Version: 1.0
References: <20230113035000.480021-1-ricarkol@google.com> <20230113035000.480021-7-ricarkol@google.com>
 <Y9BfdgL+JSYCirvm@thinky-boi> <CAOHnOrysMhp_8Kdv=Pe-O8ZGDbhN5HiHWVhBv795_E6+4RAzPw@mail.gmail.com>
 <86v8ktkqfx.wl-maz@kernel.org> <CAOHnOrx-vvuZ9n8xDRmJTBCZNiqvcqURVyrEt2tDpw5bWT0qew@mail.gmail.com>
 <86h6w70zhc.wl-maz@kernel.org>
In-Reply-To: <86h6w70zhc.wl-maz@kernel.org>
From:   Ricardo Koller <ricarkol@google.com>
Date:   Mon, 6 Feb 2023 08:35:44 -0800
Message-ID: <CAOHnOrzQz14MHtnL3_vdbKxhjM66AEBXL4ujMGn_nwfRg3D1cg@mail.gmail.com>
Subject: Re: [PATCH 6/9] KVM: arm64: Split huge pages when dirty logging is enabled
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>, pbonzini@redhat.com,
        oupton@google.com, yuzenghui@huawei.com, dmatlack@google.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com
Content-Type: text/plain; charset="UTF-8"
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

Hi Marc,

On Tue, Jan 31, 2023 at 2:28 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 27 Jan 2023 15:45:15 +0000,
> Ricardo Koller <ricarkol@google.com> wrote:
> >
> > > The one thing that would convince me to make it an option is the
> > > amount of memory this thing consumes. 512+ pages is a huge amount, and
> > > I'm not overly happy about that. Why can't this be a userspace visible
> > > option, selectable on a per VM (or memslot) basis?
> > >
> >
> > It should be possible.  I am exploring a couple of ideas that could
> > help when the hugepages are not 1G (e.g., 2M).  However, they add
> > complexity and I'm not sure they help much.
> >
> > (will be using PAGE_SIZE=4K to make things simpler)
> >
> > This feature pre-allocates 513 pages before splitting every 1G range.
> > For example, it converts 1G block PTEs into trees made of 513 pages.
> > When not using this feature, the same 513 pages would be allocated,
> > but lazily over a longer period of time.
>
> This is an important difference. It avoids the upfront allocation
> "thermal shock", giving time to the kernel to reclaim memory from
> somewhere else. Doing it upfront means you *must* have 2MB+ of
> immediately available memory for each GB of RAM you guest uses.
>
> >
> > Eager-splitting pre-allocates those pages in order to split huge-pages
> > into fully populated trees.  Which is needed in order to use FEAT_BBM
> > and skipping the expensive TLBI broadcasts.  513 is just the number of
> > pages needed to break a 1G huge-page.
>
> I understand that. But it also clear that 1GB huge pages are unlikely
> to be THPs, and I wonder if we should treat the two differently. Using
> HugeTLBFS pages is significant here.
>
> >
> > We could optimize for smaller huge-pages, like 2M by splitting 1
> > huge-page at a time: only preallocate one 4K page at a time.  The
> > trick is how to know that we are splitting 2M huge-pages.  We could
> > either get the vma pagesize or use hints from userspace.  I'm not sure
> > that this is worth it though.  The user will most likely want to split
> > big ranges of memory (>1G), so optimizing for smaller huge-pages only
> > converts the left into the right:
> >
> > alloc 1 page            |    |  alloc 512 pages
> > split 2M huge-page      |    |  split 2M huge-page
> > alloc 1 page            |    |  split 2M huge-page
> > split 2M huge-page      | => |  split 2M huge-page
> >                         ...
> > alloc 1 page            |    |  split 2M huge-page
> > split 2M huge-page      |    |  split 2M huge-page
> >
> > Still thinking of what else to do.
>
> I think the 1G case fits your own use case, but I doubt this covers
> the majority of the users. Most people rely on the kernel ability to
> use THPs, which are capped at the first level of block mapping.
>
> 2MB (and 32MB for 16kB base pages) are the most likely mappings in my
> experience (512MB with 64kB pages are vanishingly rare).
>
> Having to pay an upfront cost for HugeTLBFS doesn't shock me, and it
> fits the model. For THPs, where everything is opportunistic and the
> user not involved, this is a lot more debatable.
>
> This is why I'd like this behaviour to be a buy-in, either directly (a
> first class userspace API) or indirectly (the provenance of the
> memory).

This all makes sense, thanks for the explanation. I decided to implement
something for both cases: small caches (~1 page) where the PUDs are
split one PMD at a time, and bigger caches (>513) where the PUDs can
be split with a single replacement. The user specifies the size of the cache
via a capability, and size of 0 implies no eager splitting (the feature is off).

Thanks,
Ricardo

>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
