Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACF0F21BABF
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 18:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbgGJQWz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 12:22:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:45306 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726896AbgGJQWz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 12:22:55 -0400
IronPort-SDR: 630kz3R7Mdu711O0mZEXxHcdkOg95KiLNB/2EBCD2fNCNE4zcHJWVYKm8SzZKqNNtjbsO6ZlV8
 mJq7eGSfuMxg==
X-IronPort-AV: E=McAfee;i="6000,8403,9678"; a="149713789"
X-IronPort-AV: E=Sophos;i="5.75,336,1589266800"; 
   d="scan'208";a="149713789"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2020 09:22:54 -0700
IronPort-SDR: Itm8YZK2yEyphbxvHGwAapnbac7UFxrcKPcFy1HhAKV8QpYyd06n/caWRVn4ZG/I2DgJyUBizZ
 Hy5YSxFuvCvA==
X-IronPort-AV: E=Sophos;i="5.75,336,1589266800"; 
   d="scan'208";a="458327266"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314) ([10.237.222.51])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2020 09:22:51 -0700
Date:   Fri, 10 Jul 2020 17:22:44 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>, herbert@gondor.apana.org.au,
        cohuck@redhat.com, nhorman@redhat.com, vdronov@redhat.com,
        bhelgaas@google.com, mark.a.chambers@intel.com,
        gordon.mcfadden@intel.com, ahsan.atta@intel.com,
        qat-linux@intel.com, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] vfio/pci: add qat devices to blocklist
Message-ID: <20200710162244.GA411420@silpixa00400314>
References: <20200710153742.GA61966@bjorn-Precision-5520>
 <20200710154433.GA62583@bjorn-Precision-5520>
 <20200710101034.5a8c1be5@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200710101034.5a8c1be5@x1.home>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 10, 2020 at 10:10:34AM -0600, Alex Williamson wrote:
> On Fri, 10 Jul 2020 10:44:33 -0500
> Bjorn Helgaas <helgaas@kernel.org> wrote:
> 
> > On Fri, Jul 10, 2020 at 10:37:45AM -0500, Bjorn Helgaas wrote:
> > > On Fri, Jul 10, 2020 at 04:08:19PM +0100, Giovanni Cabiddu wrote:  
> > > > On Wed, Jul 01, 2020 at 04:28:12PM -0500, Bjorn Helgaas wrote:  
> > > > > On Wed, Jul 01, 2020 at 12:03:00PM +0100, Giovanni Cabiddu wrote:  
> > > > > > The current generation of Intel® QuickAssist Technology devices
> > > > > > are not designed to run in an untrusted environment because of the
> > > > > > following issues reported in the release notes in
> > > > > > https://01.org/intel-quickassist-technology:  
> > > > > 
> > > > > It would be nice if this link were directly clickable, e.g., if there
> > > > > were no trailing ":" or something.
> > > > > 
> > > > > And it would be even better if it went to a specific doc that
> > > > > described these issues.  I assume these are errata, and it's not easy
> > > > > to figure out which doc mentions them.  
> > > > Sure. I will fix the commit message in the next revision and point to the
> > > > actual document:
> > > > https://01.org/sites/default/files/downloads/336211-015-qatsoftwareforlinux-rn-hwv1.7-final.pdf  
> > > 
> > > Since URLs tend to go stale, please also include the Intel document
> > > number and title.  
> > 
> > Oh, and is "01.org" really the right place for that?  It looks like an
> > Intel document, so I'd expect it to be somewhere on intel.com.
> > 
> > I'm still a little confused.  That doc seems to be about *software*
> > and Linux software in particular.  But when you said these "devices
> > are not designed to run in an untrusted environment", I thought you
> > meant there was some *hardware* design issue that caused a problem.
Yes, the problem is in hardware.

> There seems to be a fair bit of hardware errata in the doc too, see:
> 
> 3.1.2 QATE-7495 - GEN - An incorrectly formatted request to Intel® QAT can
> hang the entire Intel® QAT Endpoint
> 
> 3.1.9 QATE-39220 - GEN - QAT API submissions with bad addresses that
> trigger DMA to invalid or unmapped addresses can cause a platform
> hang
> 
> 3.1.17 QATE-52389 - SR-IOV -Huge pages may not be compatible with QAT
> VF usage
> 
> 3.1.19 QATE-60953 - GEN – Intel® QAT API submissions with bad addresses
> that trigger DMA to invalid or unmapped addresses can impact QAT
> service availability
Correct, that document contains errata for both the QAT HW and the
current software.

Regards,

-- 
Giovanni
