Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58FFD10B0C9
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 15:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfK0OBI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 09:01:08 -0500
Received: from outbound-smtp31.blacknight.com ([81.17.249.62]:54100 "EHLO
        outbound-smtp31.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726937AbfK0OBH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Nov 2019 09:01:07 -0500
Received: from mail.blacknight.com (unknown [81.17.254.26])
        by outbound-smtp31.blacknight.com (Postfix) with ESMTPS id 51660D0366
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2019 13:52:54 +0000 (GMT)
Received: (qmail 16528 invoked from network); 27 Nov 2019 13:52:54 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.18.57])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 27 Nov 2019 13:52:54 -0000
Date:   Wed, 27 Nov 2019 13:52:51 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, vbabka@suse.cz, yang.zhang.wz@gmail.com,
        nitesh@redhat.com, konrad.wilk@oracle.com, david@redhat.com,
        pagupta@redhat.com, riel@surriel.com, lcapitulino@redhat.com,
        dave.hansen@intel.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        alexander.h.duyck@linux.intel.com, osalvador@suse.de
Subject: Re: [PATCH v14 1/6] mm: Adjust shuffle code to allow for future
 coalescing
Message-ID: <20191127135251.GC3016@techsingularity.net>
References: <20191119214454.24996.66289.stgit@localhost.localdomain>
 <20191119214618.24996.30818.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20191119214618.24996.30818.stgit@localhost.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 19, 2019 at 01:46:18PM -0800, Alexander Duyck wrote:
> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> Move the head/tail adding logic out of the shuffle code and into the
> __free_one_page function since ultimately that is where it is really
> needed anyway. By doing this we should be able to reduce the overhead
> and can consolidate all of the list addition bits in one spot.
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Acked-by: Mel Gorman <mgorman@techsingularity.net>

-- 
Mel Gorman
SUSE Labs
