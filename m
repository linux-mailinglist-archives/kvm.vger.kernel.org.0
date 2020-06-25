Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED1B020A2E6
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 18:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406116AbgFYQ23 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 12:28:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:58771 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406106AbgFYQ23 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 12:28:29 -0400
IronPort-SDR: +y3+eP53OBW//CdDrRJi9DgQXNHGemXYpkySa8H1ofAMDiIh+3utXDhDvPHRfpPmaNhTJkZLzO
 jzCDwUBK+gPg==
X-IronPort-AV: E=McAfee;i="6000,8403,9663"; a="143201227"
X-IronPort-AV: E=Sophos;i="5.75,279,1589266800"; 
   d="scan'208";a="143201227"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2020 09:28:29 -0700
IronPort-SDR: eTSVGgqQpkWsmjHSjFziy+kG2/pnMG0Wf8YnuEp2DQVPL6rwVTO80QKA2r9whJhCjhvqaooG0f
 Oxh0mDPMM28w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,279,1589266800"; 
   d="scan'208";a="302048236"
Received: from tassilo.jf.intel.com (HELO tassilo.localdomain) ([10.7.201.21])
  by fmsmga004.fm.intel.com with ESMTP; 25 Jun 2020 09:28:28 -0700
Received: by tassilo.localdomain (Postfix, from userid 1000)
        id 91C84301B9F; Thu, 25 Jun 2020 09:28:28 -0700 (PDT)
Date:   Thu, 25 Jun 2020 09:28:28 -0700
From:   Andi Kleen <ak@linux.intel.com>
To:     Kevin Locke <kevin@kevinlocke.name>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Christian Ehrhardt <christian.ehrhardt@canonical.com>
Subject: Re: qemu polling KVM_IRQ_LINE_STATUS when stopped
Message-ID: <20200625162828.GE818054@tassilo.jf.intel.com>
References: <87a80pihlz.fsf@linux.intel.com>
 <20171018174946.GU5109@tassilo.jf.intel.com>
 <3d37ef15-932a-1492-3068-9ef0b8cd5794@redhat.com>
 <20171020003449.GG5109@tassilo.jf.intel.com>
 <22d62b58-725b-9065-1f6d-081972ca32c3@redhat.com>
 <20171020140917.GH5109@tassilo.jf.intel.com>
 <2db78631-3c63-5e93-0ce8-f52b313593e1@redhat.com>
 <20171020205026.GI5109@tassilo.jf.intel.com>
 <1560363269.13828538.1508539882580.JavaMail.zimbra@redhat.com>
 <20200625142651.GA154525@kevinolos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625142651.GA154525@kevinolos>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From the discussion in https://bugs.launchpad.net/bugs/1851062 it
> appears that the issue does not occur for all Windows 10 VMs.  Does
> that fit the theory it is caused by RTC periodic timer ticks?  In my
> VM, clockres reports

These days I just kill -STOP/-CONT the qemu of the VMs when pausing/resuming
to work around this.

I also haven't noticed any clock drift in the Windows VM (which is Windows 8,
so quite old for Windows standards)

So whatever the Windows drift problem was it's likely long fixed,
and we're just burning CPU time for no good reason on modern Windows.

-Andi
