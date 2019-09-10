Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A681AF255
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 22:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbfIJUht (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 16:37:49 -0400
Received: from mga12.intel.com ([192.55.52.136]:57487 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbfIJUhs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 16:37:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Sep 2019 13:37:48 -0700
X-IronPort-AV: E=Sophos;i="5.64,490,1559545200"; 
   d="scan'208";a="175432349"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Sep 2019 13:37:48 -0700
Message-ID: <9b1c34e8b846e2d9ede6879bce47c7d704c89bd3.camel@linux.intel.com>
Subject: Re: [PATCH v9 0/8] stg mail -e --version=v9 \
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Michal Hocko <mhocko@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     virtio-dev@lists.oasis-open.org, kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Oscar Salvador <osalvador@suse.de>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Pankaj Gupta <pagupta@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Rik van Riel <riel@surriel.com>, lcapitulino@redhat.com,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, ying.huang@intel.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date:   Tue, 10 Sep 2019 13:37:47 -0700
In-Reply-To: <20190910180026.GE4023@dhcp22.suse.cz>
References: <20190907172225.10910.34302.stgit@localhost.localdomain>
         <20190910124209.GY2063@dhcp22.suse.cz>
         <CAKgT0Udr6nYQFTRzxLbXk41SiJ-pcT_bmN1j1YR4deCwdTOaUQ@mail.gmail.com>
         <20190910144713.GF2063@dhcp22.suse.cz>
         <CAKgT0UdB4qp3vFGrYEs=FwSXKpBEQ7zo7DV55nJRO2C-KCEOrw@mail.gmail.com>
         <20190910175213.GD4023@dhcp22.suse.cz>
         <20190910180026.GE4023@dhcp22.suse.cz>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2019-09-10 at 20:00 +0200, Michal Hocko wrote:
> On Tue 10-09-19 19:52:13, Michal Hocko wrote:
> > On Tue 10-09-19 09:05:43, Alexander Duyck wrote:
> [...]
> > > All this is providing is just a report and it is optional if the
> > > hypervisor will act on it or not. If the hypervisor takes some sort of
> > > action on the page, then the expectation is that the hypervisor will
> > > use some sort of mechanism such as a page fault to discover when the
> > > page is used again.
> > 
> > OK so the baloon driver is in charge of this metadata and the allocator
> > has to live with that. Isn't that a layer violation?
> 
> Another thing that is not clear to me is how these marked pages are
> different from any other free pages. All of them are unused and you are
> losing your metadata as soon as the page gets allocated because the page
> changes its owner and the struct page belongs to it.

Really they aren't any different then other free pages other than they are
marked. Us losing the metadata as soon as the page is allocated is fine as
we will need to re-report it when it is returned so we no longer need the
metadata once it is allocated.

