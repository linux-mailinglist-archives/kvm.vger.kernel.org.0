Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A304E6F3E6A
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 09:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233398AbjEBHc1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 03:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233652AbjEBHcW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 03:32:22 -0400
Received: from out-2.mta0.migadu.com (out-2.mta0.migadu.com [IPv6:2001:41d0:1004:224b::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3941949D0
        for <kvm@vger.kernel.org>; Tue,  2 May 2023 00:32:15 -0700 (PDT)
Date:   Tue, 2 May 2023 09:32:10 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683012732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DUC0eNJ3ae0BAslitkvQiFYs9s97U5e1wi8Pz0VDdKA=;
        b=Tzji5qVimYActW+/ubHkTOD6NlmJSlNcdwG8YHWpJacBP2gkwGbr61dNsvrmxBdpU4Y/r1
        5owUqSuSySMzP2GKMHQaoMNyDxfbNpVaUolik6fHZzsTWRGmx4XXHpjqfhCnENx5PeXPZX
        m/LN3AwWCm8EoQvg+vsw7J+MPOHebOo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
        alexandru.elisei@arm.com, ricarkol@google.com, seanjc@google.com,
        Shaoqin Huang <shahuang@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v5 00/29] EFI and ACPI support for arm64
Message-ID: <20230502-7c550b68838ce47572260bd1@orel>
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
 <20230429-6da987552a8d15281f8444c9@orel>
 <20230429-342c8a26e5db45474631a307@orel>
 <6857da77-8d1e-ebcb-1571-6419d463fa53@arm.com>
 <20230501-85b5dca6ed2d86d8bb0e55b6@orel>
 <658590ba-1c73-87cd-b1b1-bcbf3e556f29@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <658590ba-1c73-87cd-b1b1-bcbf3e556f29@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 01, 2023 at 11:27:23PM +0100, Nikos Nikoleris wrote:
> On 01/05/2023 12:21, Andrew Jones wrote:
...
> > > https://github.com/relokin/kvm-unit-tests/pull/new/target-efi-upstream-v5
> > 
> > Thanks for the quick fixes. Can you update your tree and make an MR? I
> > no longer use github.com/rhdrjones/kvm-unit-tests. I use
> > 
> > https://gitlab.com/jones-drew/kvm-unit-tests.git
> > 
> 
> You mean a MR into your repo and to the branch arm/queue, don't you? I've
> tried doing that but I get an error: "Target branch "arm/queue" does not
> exist", but it allows me to create a MR into other repos. Am I doing
> something wrong?

I'm not sure what's happening unless it's looking for the arm/queue branch
on the main gitlab kvm-unit-tests repo instead of mine.

> 
> My branch on gitlab:
> 
> https://gitlab.com/nnikoleris/kvm-unit-tests/-/tree/target-efi-upstream-v6-pre

Thanks. I grabbed the patches and applied to arm/queue,
https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/arm/queue

> Do you want me to add your patch as well? Or are you going to add it
> afterwards?

We can do the additional runtime stuff on top. I have a couple other
script changes too and I think Shaoqin is looking at how to better cope
with migration tests.

> Meanwhile, I've tried adding support for booting using a fdt. I
> think it's not too hard, but I wouldn't mind merging this series first and
> looking at the patches for the fdt support later.

I'm also anxious to get this merged, but I'm a little reluctant to
take it without DT, since we may find other issues once we boot the
tests with DT. I also know how it's easy, at least for me, to let
stuff get dropped when their priorities reduce. If you have time now,
how about we poke at it until the end of the week? With some luck,
it'll be sorted out and we'll also have the x86 ack, which I'd like
to get, by then.

Thanks,
drew
