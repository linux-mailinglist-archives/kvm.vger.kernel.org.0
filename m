Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 687A36D5ED
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 22:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbfGRUnJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 16:43:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36988 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727685AbfGRUnI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 16:43:08 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 71EB881F0C;
        Thu, 18 Jul 2019 20:43:08 +0000 (UTC)
Received: from redhat.com (ovpn-120-147.rdu2.redhat.com [10.10.120.147])
        by smtp.corp.redhat.com (Postfix) with SMTP id C0FFA607B0;
        Thu, 18 Jul 2019 20:42:51 +0000 (UTC)
Date:   Thu, 18 Jul 2019 16:42:50 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Wei Wang <wei.w.wang@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        xdeguillard@vmware.com, namit@vmware.com, pagupta@redhat.com,
        riel@surriel.com, dave.hansen@intel.com, david@redhat.com,
        konrad.wilk@oracle.com, yang.zhang.wz@gmail.com, nitesh@redhat.com,
        lcapitulino@redhat.com, aarcange@redhat.com, pbonzini@redhat.com,
        alexander.h.duyck@linux.intel.com, dan.j.williams@intel.com
Subject: Re: [PATCH v2] mm/balloon_compaction: avoid duplicate page removal
Message-ID: <20190718164152-mutt-send-email-mst@kernel.org>
References: <1563442040-13510-1-git-send-email-wei.w.wang@intel.com>
 <20190718082535-mutt-send-email-mst@kernel.org>
 <20190718133626.e30bec8fc506689b3daf48ee@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718133626.e30bec8fc506689b3daf48ee@linux-foundation.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 18 Jul 2019 20:43:08 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 18, 2019 at 01:36:26PM -0700, Andrew Morton wrote:
> On Thu, 18 Jul 2019 08:26:11 -0400 "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > On Thu, Jul 18, 2019 at 05:27:20PM +0800, Wei Wang wrote:
> > > Fixes: 418a3ab1e778 (mm/balloon_compaction: List interfaces)
> > > 
> > > A #GP is reported in the guest when requesting balloon inflation via
> > > virtio-balloon. The reason is that the virtio-balloon driver has
> > > removed the page from its internal page list (via balloon_page_pop),
> > > but balloon_page_enqueue_one also calls "list_del"  to do the removal.
> > > This is necessary when it's used from balloon_page_enqueue_list, but
> > > not from balloon_page_enqueue_one.
> > > 
> > > So remove the list_del balloon_page_enqueue_one, and update some
> > > comments as a reminder.
> > > 
> > > Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> > 
> > 
> > ok I posted v3 with typo fixes. 1/2 is this patch with comment changes. Pls take a look.
> 
> I really have no idea what you're talking about here :(.  Some other
> discussion and patch thread, I suppose.
> 
> You're OK with this patch?

Not exactly. I will send v5 soon, you will be CC'd.

> Should this patch have cc:stable?

Yes. Sorry.
