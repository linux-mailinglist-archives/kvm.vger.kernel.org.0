Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96DBE132EF8
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 20:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbgAGTFX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 14:05:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:50144 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728358AbgAGTFX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 14:05:23 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jan 2020 11:05:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,406,1571727600"; 
   d="scan'208";a="211273575"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 07 Jan 2020 11:05:22 -0800
Date:   Tue, 7 Jan 2020 11:05:22 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Barret Rhoden <brho@google.com>
Cc:     Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        linux-nvdimm@lists.01.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jason.zeng@intel.com
Subject: Re: [PATCH v5 2/2] kvm: Use huge pages for DAX-backed files
Message-ID: <20200107190522.GA16987@linux.intel.com>
References: <20191212182238.46535-1-brho@google.com>
 <20191212182238.46535-3-brho@google.com>
 <06108004-1720-41EB-BCAB-BFA8FEBF4772@oracle.com>
 <ED482280-CB47-4AB6-9E7E-EEE7848E0F8B@oracle.com>
 <f8e948ff-6a2a-a6d6-9d8e-92b93003354a@google.com>
 <65FB6CC1-3AD2-4D6F-9481-500BD7037203@oracle.com>
 <20191213171950.GA31552@linux.intel.com>
 <e012696f-f13e-5af1-2b14-084607d69bfa@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e012696f-f13e-5af1-2b14-084607d69bfa@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 16, 2019 at 11:05:26AM -0500, Barret Rhoden wrote:
> On 12/13/19 12:19 PM, Sean Christopherson wrote:
> >Teaching thp_adjust() how to handle 1GB wouldn't be a bad thing.  It's
> >unlikely THP itself will support 1GB pages any time soon, but having the
> >logic there wouldn't hurt anything.
> >
> 
> Cool.  This was my main concern - I didn't want to break THP.
> 
> I'll rework the series based on all of your comments.

Hopefully you haven't put too much effort into the rework, because I want
to commandeer the proposed changes and use them as the basis for a more
aggressive overhaul of KVM's hugepage handling.  Ironically, there's a bug
in KVM's THP handling that I _think_ can be avoided by using the DAX
approach of walking the host PTEs.

I'm in the process of testing, hopefully I'll get a series sent out later
today.  If not, I should at least be able to provide an update.
