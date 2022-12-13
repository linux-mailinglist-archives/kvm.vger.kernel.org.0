Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA66464AC01
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 01:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233959AbiLMALZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 19:11:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiLMALW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 19:11:22 -0500
Received: from mail-vk1-xa2c.google.com (mail-vk1-xa2c.google.com [IPv6:2607:f8b0:4864:20::a2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3101010FCC
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 16:11:21 -0800 (PST)
Received: by mail-vk1-xa2c.google.com with SMTP id b81so816011vkf.1
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 16:11:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FjtGS6gb/sf5LFwlRNXdasPLWdxzzo3qokxnkCoJ1pM=;
        b=XNjIWhRiM82qJhDoroUi6ddgk60VJBgW0VmnnB37IakfIPkgI72OHb7NOtHhQbwiFy
         SLTGcu8a4I9fI1pRrQLQ+nyIglBbTyHhYU6W3wktdI+zEw1szr6EYEOiBMD7yGjMtGo7
         OYJ5XG3JKvW/FsYqhz/hC+KdfabA+Vz8eL/vB34dcn0qZDuAc/EtXXNIH1+vqFt6/Vyp
         YdAf7xBZxHX6H8AZvSgNFyzaqIUG/xmJhe0BNh1FdD5u3iDYOEoyc9TwgKAUY+JQ+tLI
         NkO6VVpDsgmZB8MEa/d4e2HZDIJ7z0l8r85N/7j0tfQ70chXmNy7xjoFuEFrS0GpFeZs
         LfvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FjtGS6gb/sf5LFwlRNXdasPLWdxzzo3qokxnkCoJ1pM=;
        b=6g2IXeCrODswW8Ps67MUTRTfzLugCj2qii2MHhRcCSdjyjwBSOFfy5ABJzagOGeBnb
         0YcuhgsMSAQv4Kbi4fEdEhF+86POy0bMj6c9v7EArF/q4YWFha5cqXGMRq5Wvg4YsQtw
         VKKf3wvFkBqLG4+4haQeZnz25QXKcFQ7318CVPd4+kNIbko12mBQGOr/0TsZGKCG6AEG
         QwcLYBkK4uIiqCLsaks0EwiOwVbgk8l1mm0ZKBZ9Jlwif5KtLI4CdxeTBHYgodzqYuc/
         bOq9sarbuXseqHTLEfPQxizwh+WSzNvvGHa2R5hYa0oyNyXmF9Tv0w3dCjcdNeSdzHYT
         Vs/A==
X-Gm-Message-State: ANoB5plaCWT3YVb8tknBjsCJOg2uF7KOFP9haR5FbSkuI12725FYaSEn
        F7zBtz7P7fhkKogKo5PwO7vzoGqIPLHCo07M
X-Google-Smtp-Source: AA0mqf48U7VK9LJnzncrZ/VbUalMBsr3njYQQGIgoM9SC2myHcKgIV6hkYAUvAxLA2oUQ9zfU9W35A==
X-Received: by 2002:a05:6122:793:b0:3be:1989:a84 with SMTP id k19-20020a056122079300b003be19890a84mr7009497vkr.7.1670890280287;
        Mon, 12 Dec 2022 16:11:20 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-50-193.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.50.193])
        by smtp.gmail.com with ESMTPSA id bl14-20020a05620a1a8e00b006faa2c0100bsm6809965qkb.110.2022.12.12.16.11.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 16:11:19 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1p4stD-009HUb-5S;
        Mon, 12 Dec 2022 20:11:19 -0400
Date:   Mon, 12 Dec 2022 20:11:19 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Steven Sistare <steven.sistare@oracle.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] vfio/type1: Cleanup remaining vaddr removal/update
 fragments
Message-ID: <Y5fDJ6KkkAYj7tCQ@ziepe.ca>
References: <20221209140120.667cb658.alex.williamson@redhat.com>
 <6914b4eb-cd82-0c3e-6637-c7922092ef11@oracle.com>
 <Y5cqAk1/6ayzmTjg@ziepe.ca>
 <20221212085823.5d760656.alex.williamson@redhat.com>
 <8f29aad0-7378-ef7a-9ac5-f98b3054d5eb@oracle.com>
 <20221212142651.263dd6ae.alex.williamson@redhat.com>
 <Y5e0icoO89Qnlc/z@ziepe.ca>
 <20221212162948.4c7a4586.alex.williamson@redhat.com>
 <Y5e6zB3tW2D/ULlQ@ziepe.ca>
 <20221212170424.204bdb9a.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212170424.204bdb9a.alex.williamson@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 12, 2022 at 05:04:24PM -0700, Alex Williamson wrote:
> > > The decision to revert was based on the current interface being buggy,
> > > abandoned, and re-implemented.  It doesn't seem that there's much future
> > > for the current interface, but Steve has stepped up to restrict the
> > > current implementation to non-mdev devices, which resolves your concern
> > > regarding unlimited user blocking of kernel threads afaict, and we'll
> > > see what he does with locked memory.    
> > 
> > Except nobody has seen this yet, and it can't go into 6.2 at this
> > point (see Linus's rather harsh remarks on late work for v6.2)
> 
> We already outlined earlier in this thread the criteria that prompted
> us to tag the revert for stable, which was Steve's primary objection in
> the short term.

I still don't understand this, everyone running a distro deals with
the stuff. Even if you do blindly pull from a -stable branch instead
of cherry picking you only have to do the revert-revert once. Git is
good at this stuff.

Plus I have a doubt after all the backporting required to get vfio to
the required state that -stable patches are even going to work
anyhow..

> I can't in good faith push forward with a revert, including stable,
> if Steve is working on a proposal to resolve the issues prompting us
> to accelerate the code removal.  Depending on the scope of Steve's
> proposal, I think we might be able to still consider this a fix for
> v6.2.  Thanks,

Well, IMHO, you are better to send it for v6.2-rc1 than try to squeeze
it into this merge window and risk Linus's wrath

Jason
