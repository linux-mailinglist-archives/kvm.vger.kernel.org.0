Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4D234C90
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 17:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbfFDPrV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 11:47:21 -0400
Received: from mga07.intel.com ([134.134.136.100]:16173 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728019AbfFDPrV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 11:47:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 08:47:20 -0700
X-ExtLoop1: 1
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by fmsmga004.fm.intel.com with ESMTP; 04 Jun 2019 08:47:19 -0700
Date:   Tue, 4 Jun 2019 08:50:24 -0700
From:   Jacob Pan <jacob.jun.pan@linux.intel.com>
To:     Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Robin Murphy <Robin.Murphy@arm.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "ashok.raj@intel.com" <ashok.raj@intel.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        Vincent Stehle <Vincent.Stehle@arm.com>,
        jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH v8 05/29] iommu: Add a timeout parameter for PRQ
 response
Message-ID: <20190604085024.596696c3@jacob-builder>
In-Reply-To: <13428eef-9b95-0f79-bebf-317a2205673a@arm.com>
References: <20190526161004.25232-1-eric.auger@redhat.com>
        <20190526161004.25232-6-eric.auger@redhat.com>
        <20190603163214.483884a7@x1.home>
        <13428eef-9b95-0f79-bebf-317a2205673a@arm.com>
Organization: OTC
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 4 Jun 2019 11:52:18 +0100
Jean-Philippe Brucker <jean-philippe.brucker@arm.com> wrote:

> On 03/06/2019 23:32, Alex Williamson wrote:
> > It doesn't seem to make much sense to include this patch without
> > also including "iommu: handle page response timeout".  Was that one
> > lost? Dropped?  Lives elsewhere?  
> 
> The first 7 patches come from my sva/api branch, where I had forgotten
> to add the "handle page response timeout" patch. I added it back,
> probably after Eric sent this version. But I don't think the patch is
> ready for upstream, as we still haven't decided how to proceed with
> timeouts. Patches 6 and 7 are for debugging, I don't know if they
> should go upstream.
Yeah, we can wait until we all agree on timeouts. It was introduced for
a basic safeguard against unresponsive guests.
