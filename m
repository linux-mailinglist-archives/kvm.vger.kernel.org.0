Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61AED21B91D
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 17:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgGJPIc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 11:08:32 -0400
Received: from mga18.intel.com ([134.134.136.126]:55695 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726820AbgGJPIb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 11:08:31 -0400
IronPort-SDR: ksmHbg8/zo1NVsusScuhPmNzpPnTNLgfLqHyHyuykhQ7UDZBExU3oO39skk+R2Gp99ssDlP5EZ
 H0LVO3AU0DsQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9678"; a="135681424"
X-IronPort-AV: E=Sophos;i="5.75,336,1589266800"; 
   d="scan'208";a="135681424"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2020 08:08:30 -0700
IronPort-SDR: xkMc2PrqbaCHlbLNF6MsrwSJ4wwVWBDytoob7EgX7TXV+TedX7dsq5a4HkWDLYmDR+m8zyj+DG
 lh9MO8d05ALQ==
X-IronPort-AV: E=Sophos;i="5.75,336,1589266800"; 
   d="scan'208";a="458308290"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314) ([10.237.222.51])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2020 08:08:27 -0700
Date:   Fri, 10 Jul 2020 16:08:19 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     alex.williamson@redhat.com, herbert@gondor.apana.org.au,
        cohuck@redhat.com, nhorman@redhat.com, vdronov@redhat.com,
        bhelgaas@google.com, mark.a.chambers@intel.com,
        gordon.mcfadden@intel.com, ahsan.atta@intel.com,
        qat-linux@intel.com, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] vfio/pci: add qat devices to blocklist
Message-ID: <20200710150819.GA410874@silpixa00400314>
References: <20200701110302.75199-4-giovanni.cabiddu@intel.com>
 <20200701212812.GA3661715@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200701212812.GA3661715@bjorn-Precision-5520>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 01, 2020 at 04:28:12PM -0500, Bjorn Helgaas wrote:
> On Wed, Jul 01, 2020 at 12:03:00PM +0100, Giovanni Cabiddu wrote:
> > The current generation of Intel® QuickAssist Technology devices
> > are not designed to run in an untrusted environment because of the
> > following issues reported in the release notes in
> > https://01.org/intel-quickassist-technology:
> 
> It would be nice if this link were directly clickable, e.g., if there
> were no trailing ":" or something.
> 
> And it would be even better if it went to a specific doc that
> described these issues.  I assume these are errata, and it's not easy
> to figure out which doc mentions them.
Sure. I will fix the commit message in the next revision and point to the
actual document:
https://01.org/sites/default/files/downloads/336211-015-qatsoftwareforlinux-rn-hwv1.7-final.pdf

Regards,

-- 
Giovanni
