Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275DD3A3572
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 23:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbhFJVLR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 17:11:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230281AbhFJVLQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Jun 2021 17:11:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D00C6100A;
        Thu, 10 Jun 2021 21:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623359350;
        bh=3uaKX4KWu0Y7+XQgx32jwGfnVzT9DzauJXLAk/77HMY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=blEMPalfjEBPfhZPnkH5BgzoTabj85Ajnb0HACnx80mKy/nwDMJVwclzrSSJ+mamY
         KAg2/DZHZ7f6ykjRUkB+dhEvC1nsbaZpCbJrGels74TVComEKM8CuLFy8nzsRCGlvn
         bkCKZ+P94YHb5pT5FSjO9QuAfeHeE8G91zY1Jeus=
Date:   Thu, 10 Jun 2021 14:09:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, david@redhat.com,
        linux-mm@kvack.org, Nicholas Piggin <npiggin@gmail.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 1/2] mm/vmalloc: add vmalloc_no_huge
Message-Id: <20210610140909.781959d063608710e24e70c9@linux-foundation.org>
In-Reply-To: <20210610154220.529122-2-imbrenda@linux.ibm.com>
References: <20210610154220.529122-1-imbrenda@linux.ibm.com>
        <20210610154220.529122-2-imbrenda@linux.ibm.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 10 Jun 2021 17:42:19 +0200 Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:

> The recent patches to add support for hugepage vmalloc mappings added a
> flag for __vmalloc_node_range to allow to request small pages.
> This flag is not accessible when calling vmalloc, the only option is to
> call directly __vmalloc_node_range, which is not exported.

I can find no patch which adds such a flag to __vmalloc_node_range(). 
I assume you're referring to "mm/vmalloc: switch to bulk allocator in
__vmalloc_area_node()"?

Please be quite specific when identifying patches.  More specific than
"the recent patches"!

Also, it appears from the discussion at
https://lkml.kernel.org/r/YKUWKFyLdqTYliwu@infradead.org that we'll be
seeing a new version of "mm/vmalloc: switch to bulk allocator in
__vmalloc_area_node()".  Would it be better to build these s390 fixes into
the next version of that patch series rather than as a separate
followup thing?

