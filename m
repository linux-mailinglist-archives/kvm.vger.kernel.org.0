Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04D77A892B
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 18:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235579AbjITQCb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 12:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234593AbjITQCa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 12:02:30 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4101B9;
        Wed, 20 Sep 2023 09:02:24 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE28C433C8;
        Wed, 20 Sep 2023 16:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695225744;
        bh=PxmmE/dltr7gzuxv2mKuIj54FWPkVjlQN4tKctLDHqw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tcitaC/q97qOL5pWea96xn8J8vy43RrqUrBMskWb6DeaJ6qgI+Xhx0LrkTboKjikd
         99uLEw63TTE+WD+0PyDWBtB0hLEnt7w6wBmidZqCWOO9LyRJsW7GwzwHdXDwnQ40DL
         8by4TMuh7R/BRNVxliSDXrHNfyRhY9Zs+ISXe7no=
Date:   Wed, 20 Sep 2023 09:02:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     <ankita@nvidia.com>
Cc:     <jgg@nvidia.com>, <alex.williamson@redhat.com>,
        <tony.luck@intel.com>, <bp@alien8.de>, <naoya.horiguchi@nec.com>,
        <linmiaohe@huawei.com>, <aniketa@nvidia.com>, <cjia@nvidia.com>,
        <kwankhede@nvidia.com>, <targupta@nvidia.com>, <vsethi@nvidia.com>,
        <acurrid@nvidia.com>, <anuaggarwal@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-edac@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v1 0/4] mm: Implement ECC handling for pfn with no
 struct page
Message-Id: <20230920090222.580f2b3ca43f21f752c10e0a@linux-foundation.org>
In-Reply-To: <20230920140210.12663-1-ankita@nvidia.com>
References: <20230920140210.12663-1-ankita@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 Sep 2023 19:32:06 +0530 <ankita@nvidia.com> wrote:

> The kernel MM currently handles ECC errors / poison only on memory page
> backed by struct page. As part of [1], the nvgrace-gpu-vfio-pci module
> maps the device memory to user VA (Qemu) using remap_pfn_range without
> being added to the kernel. These pages are not backed by struct page.

Are you able to identify any other drivers which can (or will) use
this?  Or is it likely that this feature will only ever be for
nvgrace-gpu-vfio-pci?
