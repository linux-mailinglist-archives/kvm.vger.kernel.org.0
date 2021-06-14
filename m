Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41BB23A69FC
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 17:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbhFNPYP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 11:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233387AbhFNPYP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 11:24:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC43C061574;
        Mon, 14 Jun 2021 08:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=j1qkA0UBRXmvTXxhVjG/l5z+lefptA704EV3PoN5jFk=; b=IFif+/oeJCeFESO9YTRGsltVL2
        i3QUP5oCRIxlWMygISDjFMuE7BECa725GGCbCMX2+ArTR+SbiNGEX3Fd3KXX+/FEvGSynNSlnUZWi
        UAtIWYj5vLgnhfCCf39nZn8Fz4X1MI5JTGJ/5RsHGA3k33v3w7y9+rmUpJGYFlzknIjntDhrT26Bt
        WUx0rCPE4MyDFJaC+CoeX1cSkFkLfRQYbsBWLucbgEL2UAmouFyaffB0/ueYb2AtEZKX6aV9hR8aD
        /5V3sdwAWzxIsTUjLw1XJh6Ofwdp8r1jnrETyXKkqlwToPgIloSXHB4/tPU6yMG5PW9Rt+u3wJ9fz
        LANxu78g==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lsoP5-005YXM-9W; Mon, 14 Jun 2021 15:21:45 +0000
Date:   Mon, 14 Jun 2021 16:21:31 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, david@redhat.com,
        linux-mm@kvack.org, Uladzislau Rezki <urezki@gmail.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4 1/2] mm/vmalloc: add vmalloc_no_huge
Message-ID: <YMdz+xnsUsf3iLeB@infradead.org>
References: <20210614132357.10202-1-imbrenda@linux.ibm.com>
 <20210614132357.10202-2-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210614132357.10202-2-imbrenda@linux.ibm.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 14, 2021 at 03:23:56PM +0200, Claudio Imbrenda wrote:
> +void *vmalloc_no_huge(unsigned long size)
> +{
> +	return __vmalloc_node_range(size, 1, VMALLOC_START, VMALLOC_END, GFP_KERNEL, PAGE_KERNEL,
> +				    VM_NO_HUGE_VMAP, NUMA_NO_NODE, __builtin_return_address(0));

Please avoid the overly long lines in favor of something actually
human-readable like:

	return __vmalloc_node_range(size, 1, VMALLOC_START, VMALLOC_END,
			GFP_KERNEL, PAGE_KERNEL, VM_NO_HUGE_VMAP,
			NUMA_NO_NODE, __builtin_return_address(0));
