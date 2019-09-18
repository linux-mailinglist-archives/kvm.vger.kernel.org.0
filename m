Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82392B6A34
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 20:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387411AbfIRSFM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 14:05:12 -0400
Received: from mga04.intel.com ([192.55.52.120]:59253 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725899AbfIRSFM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 14:05:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Sep 2019 11:05:11 -0700
X-IronPort-AV: E=Sophos;i="5.64,521,1559545200"; 
   d="scan'208";a="338407459"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Sep 2019 11:05:10 -0700
Message-ID: <38429bdb416bdb33f3c7f740f903380af3129a36.camel@linux.intel.com>
Subject: Re: [PATCH v10 5/6] virtio-balloon: Pull page poisoning config out
 of free page hinting
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
        david@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, vbabka@suse.cz,
        akpm@linux-foundation.org, mgorman@techsingularity.net,
        linux-arm-kernel@lists.infradead.org, osalvador@suse.de,
        yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com
Date:   Wed, 18 Sep 2019 11:05:10 -0700
In-Reply-To: <20190918135833-mutt-send-email-mst@kernel.org>
References: <20190918175109.23474.67039.stgit@localhost.localdomain>
         <20190918175305.23474.34783.stgit@localhost.localdomain>
         <20190918135833-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2019-09-18 at 13:58 -0400, Michael S. Tsirkin wrote:
> On Wed, Sep 18, 2019 at 10:53:05AM -0700, Alexander Duyck wrote:
> > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > 
> > Currently the page poisoning setting wasn't being enabled unless free page
> > hinting was enabled. However we will need the page poisoning tracking logic
> > as well for unused page reporting. As such pull it out and make it a
> > separate bit of config in the probe function.
> > 
> > In addition we can actually wrap the code in a check for NO_SANITY. If we
> > don't care what is actually in the page we can just default to 0 and leave
> > it there.
> > 
> > Reviewed-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> I think this one can go in directly. Do you want me to merge it now?

That sounds good to me.

Do you know if you can also pull in QEMU 1/3 into QEMU as well since the
feature wasn't pulled into QEMU originally?
https://lore.kernel.org/lkml/20190918175342.23606.12400.stgit@localhost.localdomain/

Thanks.

- Alex


