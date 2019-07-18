Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B58CB6D5DA
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 22:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbfGRUg2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 16:36:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:43900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727685AbfGRUg2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 16:36:28 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D45A21019;
        Thu, 18 Jul 2019 20:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563482187;
        bh=n33RnYgEWXmqJNz9rAt/hhFEfid9BuR/+DJfKxYaK0U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lUOwsJeO09VcivQzELIEb1xspaeMrv8igfqpVje7IjB8d0vzktO7JZSGLFIM+EfTr
         h/bHRCTZ3vQJKeX3CNOxKC0fE0T4geSoEIcdsi2HhD4Y4RNcoErz93W0ItzQFE/qdX
         vMDMu7ZP5PtAPbBp6eeXNJtHCfHbt5jrTeJLUhF0=
Date:   Thu, 18 Jul 2019 13:36:26 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Wei Wang <wei.w.wang@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        xdeguillard@vmware.com, namit@vmware.com, pagupta@redhat.com,
        riel@surriel.com, dave.hansen@intel.com, david@redhat.com,
        konrad.wilk@oracle.com, yang.zhang.wz@gmail.com, nitesh@redhat.com,
        lcapitulino@redhat.com, aarcange@redhat.com, pbonzini@redhat.com,
        alexander.h.duyck@linux.intel.com, dan.j.williams@intel.com
Subject: Re: [PATCH v2] mm/balloon_compaction: avoid duplicate page removal
Message-Id: <20190718133626.e30bec8fc506689b3daf48ee@linux-foundation.org>
In-Reply-To: <20190718082535-mutt-send-email-mst@kernel.org>
References: <1563442040-13510-1-git-send-email-wei.w.wang@intel.com>
        <20190718082535-mutt-send-email-mst@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 18 Jul 2019 08:26:11 -0400 "Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Thu, Jul 18, 2019 at 05:27:20PM +0800, Wei Wang wrote:
> > Fixes: 418a3ab1e778 (mm/balloon_compaction: List interfaces)
> > 
> > A #GP is reported in the guest when requesting balloon inflation via
> > virtio-balloon. The reason is that the virtio-balloon driver has
> > removed the page from its internal page list (via balloon_page_pop),
> > but balloon_page_enqueue_one also calls "list_del"  to do the removal.
> > This is necessary when it's used from balloon_page_enqueue_list, but
> > not from balloon_page_enqueue_one.
> > 
> > So remove the list_del balloon_page_enqueue_one, and update some
> > comments as a reminder.
> > 
> > Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> 
> 
> ok I posted v3 with typo fixes. 1/2 is this patch with comment changes. Pls take a look.

I really have no idea what you're talking about here :(.  Some other
discussion and patch thread, I suppose.

You're OK with this patch?

Should this patch have cc:stable?
