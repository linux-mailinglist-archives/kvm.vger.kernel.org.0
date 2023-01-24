Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13FFB679FC9
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 18:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234641AbjAXRId (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 12:08:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234525AbjAXRIL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 12:08:11 -0500
Received: from out-90.mta0.migadu.com (out-90.mta0.migadu.com [IPv6:2001:41d0:1004:224b::5a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B4A4FAED
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 09:07:12 -0800 (PST)
Date:   Tue, 24 Jan 2023 17:07:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674580027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VZdc+CjlDbqIwSaItHfVfQKULFa++Rc+n7xQkR7HMLI=;
        b=JBKMJvg5y+WwAbOGso2cySv6b9CEtpy6vf6AG7O3kM8tN/n/CCMbnWpJzNE/XQZJlYtHcF
        D19eOGLTvhe77B9SWzhOaQB4NDRxu0tY+LLzHiM60fDBWeEuu9amb4M/tB1XaORSGxjfCb
        vODsw5bUwrflwHM3JD63rN+8J+cwAUg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     Ben Gardon <bgardon@google.com>, pbonzini@redhat.com,
        maz@kernel.org, yuzenghui@huawei.com, dmatlack@google.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, ricarkol@gmail.com
Subject: Re: [PATCH 2/9] KVM: arm64: Add helper for creating removed stage2
 subtrees
Message-ID: <Y9AQNk7Uh9h6r93N@google.com>
References: <20230113035000.480021-1-ricarkol@google.com>
 <20230113035000.480021-3-ricarkol@google.com>
 <CANgfPd-KSX=NOhjyoAQRrLyHArQ=Sw3uMjmdh5J0yrogUN8mbg@mail.gmail.com>
 <Y9AI3FWEeIaw9kRN@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9AI3FWEeIaw9kRN@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 24, 2023 at 08:35:40AM -0800, Ricardo Koller wrote:
> On Mon, Jan 23, 2023 at 04:55:40PM -0800, Ben Gardon wrote:

[...]

> > > +/**
> > > + * kvm_pgtable_stage2_free_removed() - Create a removed stage-2 paging structure.
> > > + * @pgt:       Page-table structure initialised by kvm_pgtable_stage2_init*().
> > > + * @new:       Unlinked stage-2 paging structure to be created.
> > 
> > Oh, I see so the "removed" page table is actually a new page table
> > that has never been part of the paging structure. In that case I would
> > find it much more intuitive to call it "unlinked" or similar.
> >
> 
> Sounds good, I like "unlinked".
> 
> Oliver, are you OK if I rename free_removed() as well? just to keep them
> symmetric.

Fine by me, and sorry for the silly naming :)

--
Thanks,
Oliver
