Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAEC1A8FBC
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 02:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392393AbgDOAcb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 20:32:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:40752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731654AbgDOAc2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 20:32:28 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91C5A20737;
        Wed, 15 Apr 2020 00:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586910748;
        bh=HvJc20wttgkQ6cXIPl8+VzaV7/yOLVniYB4h4rOwlRo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H6IMOM6bmdu7agO4W0V7CUpAfzne/1y61nYags75iWcd61bH7yg8z0lHlOWc8EKCl
         l/9jq1xRAa92gfLuE7N4J66kpqxHS6Jws+slcBuGV1k7KXIpgAq9/UYSwedtpmB0pN
         wnOEO6HJ7ceu3knFv+NeFo7BV+JXcPHfPZ/Bmn7w=
Date:   Tue, 14 Apr 2020 17:32:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Michal Hocko <mhocko@suse.com>,
        Juergen Gross <jgross@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Pavel Tatashin <pavel.tatashin@microsoft.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Anthony Yznaga <anthony.yznaga@oracle.com>,
        Oscar Salvador <osalvador@suse.de>,
        Mel Gorman <mgorman@techsingularity.net>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Qian Cai <cai@lca.pw>, Pingfan Liu <kernelfans@gmail.com>
Subject: Re: [PATCH v2 05/10] mm: Allow to offline unmovable PageOffline()
 pages via MEM_GOING_OFFLINE
Message-Id: <20200414173227.ac71566702c0561f42baa83f@linux-foundation.org>
In-Reply-To: <20200414123334-mutt-send-email-mst@kernel.org>
References: <20200311171422.10484-1-david@redhat.com>
        <20200311171422.10484-6-david@redhat.com>
        <20200414123334-mutt-send-email-mst@kernel.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 Apr 2020 12:34:26 -0400 "Michael S. Tsirkin" <mst@redhat.com> wrote:

> Andrew, could you please ack merging this through the vhost tree
> together with the rest of the patches?

Acked-by: Andrew Morton <akpm@linux-foundation.org>

