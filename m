Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4FA1AD328
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 01:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgDPX3b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 19:29:31 -0400
Received: from mga03.intel.com ([134.134.136.65]:16150 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725833AbgDPX3b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 19:29:31 -0400
IronPort-SDR: 7txCCBuvuW8+p5bFgWZYRK4RePDNbso6CsGYnz7UyjJJF11sfyC2LkWMJ49VL5coWeddJDwRii
 cIyqfJHCQ6vA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2020 16:29:31 -0700
IronPort-SDR: Ea1eIOqkHN1DKL+8H7YbF1NukC4yHgDIHJEDg7J4DhzTDCAZeJSEeGvYqWVW9rAYWeFRzkj7fo
 kYdamro87ubg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,392,1580803200"; 
   d="scan'208";a="289071141"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 16 Apr 2020 16:29:30 -0700
Date:   Thu, 16 Apr 2020 16:29:30 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ankit Amlani <ankit.amlani@intel.com>
Subject: Re: [PATCH] vfio/type1: Fix VA->PA translation for PFNMAP VMAs in
 vaddr_get_pfn()
Message-ID: <20200416232930.GF12170@linux.intel.com>
References: <20200416225057.8449-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200416225057.8449-1-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 16, 2020 at 03:50:57PM -0700, Sean Christopherson wrote:
> Fixes: 73fa0d10d077 ("vfio: Type1 IOMMU implementation")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Egad, I completely spaced, this should have:

Reported-by: Ankit Amlani <ankit.amlani@intel.com>
