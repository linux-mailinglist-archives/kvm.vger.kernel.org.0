Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9D986AB54
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 17:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387860AbfGPPEv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 11:04:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55298 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728513AbfGPPEv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 11:04:51 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4AC22C1EB1E4;
        Tue, 16 Jul 2019 15:04:51 +0000 (UTC)
Received: from redhat.com (ovpn-122-108.rdu2.redhat.com [10.10.122.108])
        by smtp.corp.redhat.com (Postfix) with SMTP id 82A916013C;
        Tue, 16 Jul 2019 15:04:30 +0000 (UTC)
Date:   Tue, 16 Jul 2019 11:04:27 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>, nitesh@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com
Subject: Re: [PATCH v1 6/6] virtio-balloon: Add support for aerating memory
 via hinting
Message-ID: <20190716110357-mutt-send-email-mst@kernel.org>
References: <20190619222922.1231.27432.stgit@localhost.localdomain>
 <20190619223338.1231.52537.stgit@localhost.localdomain>
 <20190716055017-mutt-send-email-mst@kernel.org>
 <cad839c0-bbe6-b065-ac32-f32c117cf07e@intel.com>
 <3f8b2a76-b2ce-fb73-13d4-22a33fc1eb17@redhat.com>
 <e565859c-d41a-e3b8-fd50-4537b50b95fb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e565859c-d41a-e3b8-fd50-4537b50b95fb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 16 Jul 2019 15:04:51 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 16, 2019 at 04:17:13PM +0200, David Hildenbrand wrote:
> On 16.07.19 16:12, David Hildenbrand wrote:
> > On 16.07.19 16:00, Dave Hansen wrote:
> >> On 7/16/19 2:55 AM, Michael S. Tsirkin wrote:
> >>> The approach here is very close to what on-demand hinting that is
> >>> already upstream does.
> >>
> >> Are you referring to the s390 (and powerpc) stuff that is hidden behind
> >> arch_free_page()?
> >>
> > 
> > I assume Michael meant "free page reporting".
> > 
> 
> (https://lwn.net/Articles/759413/)


Yes - VIRTIO_BALLOON_F_FREE_PAGE_HINT.

> -- 
> 
> Thanks,
> 
> David / dhildenb
