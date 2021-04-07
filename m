Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636B0356FDB
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 17:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235077AbhDGPKu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 11:10:50 -0400
Received: from mga17.intel.com ([192.55.52.151]:11223 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234763AbhDGPKt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 11:10:49 -0400
IronPort-SDR: vKTmazzJS8E0aS/6k/HuYd8lIT8k+SjLRkQwG/MMcrc6SJzqORTxVcwUc3BDPqtivhniaBmFOo
 spaTL0kfsIxA==
X-IronPort-AV: E=McAfee;i="6000,8403,9947"; a="173406785"
X-IronPort-AV: E=Sophos;i="5.82,203,1613462400"; 
   d="scan'208";a="173406785"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2021 08:10:40 -0700
IronPort-SDR: Nh2sXErIvHnCufsdheEBQ6UWLhutJYLYv3s41okOLzye7V6PJUrqWrrsYr6rigFmkyppdLuIet
 kqmSSIH5M6BA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,203,1613462400"; 
   d="scan'208";a="530238532"
Received: from tassilo.jf.intel.com (HELO tassilo.localdomain) ([10.54.74.11])
  by orsmga004.jf.intel.com with ESMTP; 07 Apr 2021 08:10:40 -0700
Received: by tassilo.localdomain (Postfix, from userid 1000)
        id 0F76030027C; Wed,  7 Apr 2021 08:10:40 -0700 (PDT)
From:   Andi Kleen <ak@linux.intel.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     "Kirill A. Shutemov" <kirill@shutemov.name>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>,
        "Edgecombe\, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen\, Andi" <andi.kleen@intel.com>,
        "Yamahata\, Isaku" <isaku.yamahata@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Oscar Salvador <osalvador@suse.de>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: [RFCv1 7/7] KVM: unmap guest memory using poisoned pages
References: <20210402152645.26680-1-kirill.shutemov@linux.intel.com>
        <20210402152645.26680-8-kirill.shutemov@linux.intel.com>
        <5e934d94-414c-90de-c58e-34456e4ab1cf@redhat.com>
Date:   Wed, 07 Apr 2021 08:10:40 -0700
In-Reply-To: <5e934d94-414c-90de-c58e-34456e4ab1cf@redhat.com> (David
        Hildenbrand's message of "Wed, 7 Apr 2021 16:55:54 +0200")
Message-ID: <87v98yuo3z.fsf@linux.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

David Hildenbrand <david@redhat.com> writes:

> I have no idea how expensive would be bouncing writes (and reads?)
> through the kernel. Did you ever experiment with that/evaluate that?

I would expect it to be quite expensive, as in virtio IO performance
tanking.

-Andi
