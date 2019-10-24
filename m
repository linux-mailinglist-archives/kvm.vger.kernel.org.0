Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE932E3A1E
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 19:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503828AbfJXRcM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 13:32:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:51520 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729458AbfJXRcM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 13:32:12 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 10:32:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,225,1569308400"; 
   d="scan'208";a="201545428"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 24 Oct 2019 10:32:12 -0700
Date:   Thu, 24 Oct 2019 10:32:12 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Derek Yerger <derek@djy.llc>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        "Bonzini, Paolo" <pbonzini@redhat.com>
Subject: Re: PROBLEM: Regression of MMU causing guest VM application errors
Message-ID: <20191024173212.GC20633@linux.intel.com>
References: <1e525b08-6204-3238-5d56-513f82f1d7fb@djy.llc>
 <20191016112857.293a197d@x1.home>
 <20191016174943.GG5866@linux.intel.com>
 <53f506b3-e864-b3ca-f18f-f8e9a1612072@djy.llc>
 <20191022202847.GO2343@linux.intel.com>
 <4af8cbac-39b1-1a20-8e26-54a37189fe32@djy.llc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4af8cbac-39b1-1a20-8e26-54a37189fe32@djy.llc>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 24, 2019 at 11:18:59AM -0400, Derek Yerger wrote:
> On 10/22/19 4:28 PM, Sean Christopherson wrote:
> >On Thu, Oct 17, 2019 at 07:57:35PM -0400, Derek Yerger wrote:
> >Heh, should've checked from the get go...  It's definitely not the memslot
> >issue, because the memslot bug is in 5.1.16 as well.  :-)
> I didn't pick up on that, nice catch. The memslot thread was the closest
> thing I could find to an educated guess.
> >>I'm stuck on 5.1.x for now, maybe I'll give up and get a dedicated windows
> >>machine /s
> >What hardware are you running on?  I was thinking this was AMD specific,
> >but then realized you said "AMD Radeon 540 GPU" and not "AMD CPU".
> Intel(R) Core(TM) i7-6700K CPU @ 4.00GHz
> 
> 07:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI]
> Lexa PRO [Radeon 540/540X/550/550X / RX 540X/550/550X] (rev c7)
>         Subsystem: Gigabyte Technology Co., Ltd Device 22fe
>         Kernel driver in use: vfio-pci
>         Kernel modules: amdgpu
> (plus related audio device)
> 
> I can't think of any other data points that would be helpful to solving
> system instability in a guest OS.

Can you bisect starting from v5.2?  Identifying which commit in the kernel
introduced the regression would help immensely.

> But given my troubleshooting before, it
> looks like presence/absence of a PCI passthrough device is inconsequential
> to whether the problem is occurring.
> 
> I may have to try out other VMs or a fresh windows guest.
