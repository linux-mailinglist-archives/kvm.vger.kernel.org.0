Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE1EB13D086
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 00:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730919AbgAOXIq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 18:08:46 -0500
Received: from mga18.intel.com ([134.134.136.126]:13350 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729369AbgAOXIq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 18:08:46 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Jan 2020 15:08:45 -0800
X-IronPort-AV: E=Sophos;i="5.70,323,1574150400"; 
   d="scan'208";a="218316397"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Jan 2020 15:08:45 -0800
Message-ID: <cc71a016de155310f7593bfe3091eea094d400b4.camel@linux.intel.com>
Subject: Re: [PATCH v16 0/9] mm / virtio: Provide support for free page
 reporting
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>, kvm@vger.kernel.org,
        mst@redhat.com, linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        mgorman@techsingularity.net, vbabka@suse.cz
Cc:     yang.zhang.wz@gmail.com, nitesh@redhat.com, konrad.wilk@oracle.com,
        david@redhat.com, pagupta@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, dave.hansen@intel.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, osalvador@suse.de
Date:   Wed, 15 Jan 2020 15:08:45 -0800
In-Reply-To: <20200103210509.29237.18426.stgit@localhost.localdomain>
References: <20200103210509.29237.18426.stgit@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2020-01-03 at 13:16 -0800, Alexander Duyck wrote:
> This series provides an asynchronous means of reporting free guest pages
> to a hypervisor so that the memory associated with those pages can be
> dropped and reused by other processes and/or guests on the host. Using
> this it is possible to avoid unnecessary I/O to disk and greatly improve
> performance in the case of memory overcommit on the host.

<snip>

> 
> Changes from v15:
> https://lore.kernel.org/lkml/20191205161928.19548.41654.stgit@localhost.localdomain/
> Rebased on linux-next-20191219
> Split out patches for budget and moving head to last page processed
>   Updated budget code to reduce how much memory is reported per pass
>   Added logic to also rotate the list if we exit due a page isolation failure
> Added migratetype as argument in __putback_isolated_page

It's been about a week and a half since I posted the set and haven't
really gotten much feedback other than a suggestion of a slight tweak to
the titles for patches 7 & 8 to mention page_reporting. I'm mainly looking
for input on patches 3, 4, 7 and 8 since those are the ones that contain
most of the changes based on recent feedback.

I'm wondering if there is any remaining concerns or if these patches are
in a state where they are ready to be pulled into the MM tree?

Thanks.

- Alex

