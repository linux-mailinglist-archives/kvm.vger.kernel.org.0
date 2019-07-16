Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC33A6AC8C
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 18:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728608AbfGPQNL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 12:13:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45230 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728004AbfGPQNL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 12:13:11 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 98E3481F31;
        Tue, 16 Jul 2019 16:13:10 +0000 (UTC)
Received: from redhat.com (ovpn-122-108.rdu2.redhat.com [10.10.122.108])
        by smtp.corp.redhat.com (Postfix) with SMTP id 8E7D86012C;
        Tue, 16 Jul 2019 16:12:57 +0000 (UTC)
Date:   Tue, 16 Jul 2019 12:12:56 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Wang, Wei W" <wei.w.wang@intel.com>
Cc:     "Hansen, Dave" <dave.hansen@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        "nitesh@redhat.com" <nitesh@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "yang.zhang.wz@gmail.com" <yang.zhang.wz@gmail.com>,
        "pagupta@redhat.com" <pagupta@redhat.com>,
        "riel@surriel.com" <riel@surriel.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "lcapitulino@redhat.com" <lcapitulino@redhat.com>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "alexander.h.duyck@linux.intel.com" 
        <alexander.h.duyck@linux.intel.com>
Subject: Re: [PATCH v1 6/6] virtio-balloon: Add support for aerating memory
 via hinting
Message-ID: <20190716120839-mutt-send-email-mst@kernel.org>
References: <20190619222922.1231.27432.stgit@localhost.localdomain>
 <20190619223338.1231.52537.stgit@localhost.localdomain>
 <20190716055017-mutt-send-email-mst@kernel.org>
 <cad839c0-bbe6-b065-ac32-f32c117cf07e@intel.com>
 <3f8b2a76-b2ce-fb73-13d4-22a33fc1eb17@redhat.com>
 <bdb9564d-640d-138f-6695-3fa2c084fcc7@intel.com>
 <286AC319A985734F985F78AFA26841F73E16AB21@shsmsx102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <286AC319A985734F985F78AFA26841F73E16AB21@shsmsx102.ccr.corp.intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Tue, 16 Jul 2019 16:13:11 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 16, 2019 at 03:01:52PM +0000, Wang, Wei W wrote:
> On Tuesday, July 16, 2019 10:41 PM, Hansen, Dave wrote:
> > Where is the page allocator integration?  The set you linked to has 5 patches,
> > but only 4 were merged.  This one is missing:
> > 
> > 	https://lore.kernel.org/patchwork/patch/961038/
> 
> For some reason, we used the regular page allocation to get pages
> from the free list at that stage.


This is what Linus suggested, that is why:

https://lkml.org/lkml/2018/6/27/461

and

https://lkml.org/lkml/2018/7/11/795


See also

https://lkml.org/lkml/2018/7/10/1157

for some failed attempts to upstream mm core changes
related to this.

> This part could be improved by Alex
> or Nitesh's approach.
> 
> The page address transmission from the balloon driver to the host
> device could reuse what's upstreamed there. I think you could add a
> new VIRTIO_BALLOON_CMD_xx for your usages.
> 
> Best,
> Wei
