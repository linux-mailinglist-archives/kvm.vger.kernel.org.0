Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00963D416A
	for <lists+kvm@lfdr.de>; Fri, 23 Jul 2021 22:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbhGWTjD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jul 2021 15:39:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:58986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229461AbhGWTjC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jul 2021 15:39:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A189A60ED7;
        Fri, 23 Jul 2021 20:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627071574;
        bh=0BAO7UovvvSbaYafDUDdTwXZEq2gIph4eDBcdB5yieQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d6DCfyTB0esEzQbIWFCeaUvfgjwA4lX8+8wNkEy2usvctfv4WVW3j2w1Uyd50o/a+
         8T1BPd2lB2f+833Rx9YjdKx+35W+Qg6L13oYLc0tpGhUBn/V+tuNEbAhsK7ZclSndD
         F9V2ely94T/BSrRzewRhufSwvzowyvkdPyYwdcVI=
Date:   Fri, 23 Jul 2021 13:19:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     "Huang, Ying" <ying.huang@intel.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Yang Shi <shy828301@gmail.com>, Zi Yan <ziy@nvidia.com>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mel Gorman <mgorman@suse.de>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Michal Hocko <mhocko@suse.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH] mm,do_huge_pmd_numa_page: remove unnecessary TLB
 flushing code
Message-Id: <20210723131932.aa889158e9c8cd3ac089e8e5@linux-foundation.org>
In-Reply-To: <878s1xaobl.fsf@yhuang6-desk2.ccr.corp.intel.com>
References: <20210720065529.716031-1-ying.huang@intel.com>
        <eadff602-3824-f69d-e110-466b37535c99@de.ibm.com>
        <CAHbLzkp6LDLUK9TLM+geQM6+X6+toxAGi53UBd49Zm5xgc5aWQ@mail.gmail.com>
        <0D75A92F-E2AA-480C-9E9A-0B6EE7897757@nvidia.com>
        <CAHbLzkqZZEic7+H0ky9u+aKO5o_cF0N5xQ=JO2tMpc8jg8RcnQ@mail.gmail.com>
        <YPhAEcHOCZ5yII/T@google.com>
        <87lf5z9osl.fsf@yhuang6-desk2.ccr.corp.intel.com>
        <572f1ddd-9ac6-fb09-9a24-1c667dbd1d03@de.ibm.com>
        <878s1xaobl.fsf@yhuang6-desk2.ccr.corp.intel.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 23 Jul 2021 08:03:42 +0800 "Huang, Ying" <ying.huang@intel.com> wrote:

> Can you help to add the following text to the end of the original patch
> description?
> 
> "
> The mmu_notifier_invalidate_range() in do_huge_pmd_numa_page() is
> deleted too.  Because migrate_pages() takes care of that too when CPU
> TLB is flushed.
> "

Done.
