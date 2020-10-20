Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E55293C28
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 14:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406605AbgJTMrd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 08:47:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:17337 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406408AbgJTMrb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 08:47:31 -0400
IronPort-SDR: 2YY5ZbnXLKYCSld7mxX7xrs2nTSMTDbpr2OlFN4FqdA2HhfguVMJ1r4EIYiPkPwdoNapzjyaJe
 gukk96k7jxKQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9779"; a="167319105"
X-IronPort-AV: E=Sophos;i="5.77,397,1596524400"; 
   d="scan'208";a="167319105"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 05:47:30 -0700
IronPort-SDR: kAVLCB4RupND9uUWmn26k6SJRCJbLtbuRawIljFVd+ITvyLkXt7FId8CXkbZUW3SCaYDueHK8G
 a8n3G2bJKIOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,397,1596524400"; 
   d="scan'208";a="332244362"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga002.jf.intel.com with ESMTP; 20 Oct 2020 05:47:25 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id BB5B9376; Tue, 20 Oct 2020 15:47:24 +0300 (EEST)
Date:   Tue, 20 Oct 2020 15:47:24 +0300
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Kirill A. Shutemov" <kirill@shutemov.name>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFCv2 05/16] x86/kvm: Make VirtIO use DMA API in KVM guest
Message-ID: <20201020124724.mk66h5ulm3xwdksc@black.fi.intel.com>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
 <20201020061859.18385-6-kirill.shutemov@linux.intel.com>
 <20201020080658.GA21238@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020080658.GA21238@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 20, 2020 at 09:06:58AM +0100, Christoph Hellwig wrote:
> NAK.  Any virtio implementation that needs special DMA OPS treatment
> needs to set the VIRTIO_F_ACCESS_PLATFORM bit.  The only reason the
> Xen hack existst is because it slipped in a long time ago and we can't
> fix that any more.

Thanks. Will fix.

-- 
 Kirill A. Shutemov
