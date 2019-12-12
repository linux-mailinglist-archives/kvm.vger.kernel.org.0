Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C90D111DA32
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 00:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731383AbfLLXrT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 18:47:19 -0500
Received: from mga05.intel.com ([192.55.52.43]:18520 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726427AbfLLXrT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 18:47:19 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Dec 2019 15:47:19 -0800
X-IronPort-AV: E=Sophos;i="5.69,307,1571727600"; 
   d="scan'208";a="216278692"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Dec 2019 15:47:18 -0800
Message-ID: <d85d5ca1ae621ad3f4c80d0dcd146a50bd7409fd.camel@linux.intel.com>
Subject: Re: [PATCH v15 0/7] mm / virtio: Provide support for free page
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
Date:   Thu, 12 Dec 2019 15:47:18 -0800
In-Reply-To: <20191205161928.19548.41654.stgit@localhost.localdomain>
References: <20191205161928.19548.41654.stgit@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2019-12-05 at 08:22 -0800, Alexander Duyck wrote:
> This series provides an asynchronous means of reporting free guest pages
> to a hypervisor so that the memory associated with those pages can be
> dropped and reused by other processes and/or guests on the host. Using
> this it is possible to avoid unnecessary I/O to disk and greatly improve
> performance in the case of memory overcommit on the host.

<snip>

> Changes from v14:
> https://lore.kernel.org/lkml/20191119214454.24996.66289.stgit@localhost.localdomain/
> Renamed "unused page reporting" to "free page reporting"
>   Updated code, kconfig, and patch descriptions
> Split out patch for __free_isolated_page
>   Renamed function to __putback_isolated_page
> Rewrote core reporting functionality
>   Added logic to reschedule worker in 2 seconds instead of run to completion
>   Removed reported_pages statistics
>   Removed REPORTING_REQUESTED bit used in zone flags
>   Replaced page_reporting_dev_info refcount with state variable
>   Removed scatterlist from page_reporting_dev_info
>   Removed capacity from page reporting device
>   Added dynamic scatterlist allocation/free at start/end of reporting process
>   Updated __free_one_page so that reported pages are not always added to tail
>   Added logic to handle error from report function
> Updated virtio-balloon patch that adds support for page reporting
>   Updated patch description to try and highlight differences in approaches
>   Updated logic to reflect that we cannot limit the scatterlist from device
>   Added logic to return error from report function
> Moved documentation patch to end of patch set

It has been about a week since I posted v15 and haven't heard anything.
Consider this a gentle ping.

I'm looking for input on patches 3 and 4 in this set as I updated them to
address most of the concerns Mel had. Just wondering if the set needs
additional work or if we are good with this as a starting point for this
feature?

Thanks.

- Alex

