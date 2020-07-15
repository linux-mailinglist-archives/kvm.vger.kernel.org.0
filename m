Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A419C220167
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 02:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgGOAkf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 20:40:35 -0400
Received: from mga17.intel.com ([192.55.52.151]:63267 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726458AbgGOAkf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 20:40:35 -0400
IronPort-SDR: 3ZPeNrTGHZvCqucyFIEdaDq5U2dpspwnOCZ30uqtIBEUUAGAppM6Ui4DlFHsI6qjzeM6+kari2
 nJ6B09dR/mmA==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="129142399"
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="129142399"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 17:40:35 -0700
IronPort-SDR: boOPCVnFb4xBQo9PjccozOnSHmMPmV1/UuxGnTjA5xi0CHudSa/4acyBJSsbYiUmPDcTdy80Z7
 8HrGN6Nfa5CA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="485543720"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by fmsmga006.fm.intel.com with ESMTP; 14 Jul 2020 17:40:33 -0700
Date:   Wed, 15 Jul 2020 08:40:09 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v13 00/11] Introduce support for guest CET feature
Message-ID: <20200715004009.GA1271@local-michael-cet-test>
References: <20200701080411.5802-1-weijiang.yang@intel.com>
 <20200713181326.GC29725@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713181326.GC29725@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 13, 2020 at 11:13:26AM -0700, Sean Christopherson wrote:
> On Wed, Jul 01, 2020 at 04:04:00PM +0800, Yang Weijiang wrote:
> > Control-flow Enforcement Technology (CET) provides protection against
> > Return/Jump-Oriented Programming (ROP/JOP) attack. There're two CET
> > sub-features: Shadow Stack (SHSTK) and Indirect Branch Tracking (IBT).
> > SHSTK is to prevent ROP programming and IBT is to prevent JOP programming.
> > 
> > Several parts in KVM have been updated to provide VM CET support, including:
> > CPUID/XSAVES config, MSR pass-through, user space MSR access interface, 
> > vmentry/vmexit config, nested VM etc. These patches have dependency on CET
> > kernel patches for xsaves support and CET definitions, e.g., MSR and related
> > feature flags.
> > 
> > CET kernel patches are here:
> > https://lkml.kernel.org/r/20200429220732.31602-1-yu-cheng.yu@intel.com
> > 
> > v13:
> > - Added CET definitions as a separate patch to facilitate KVM test.
> > - Disabled CET support in KVM if unrestricted_guest is turned off since
> >   in this case CET related instructions/infrastructure cannot be emulated
> >   well.
> 
> This needs to be rebased, I can't get it to apply on any kvm branch nor on
> any 5.8 rc.  And when you send series, especially large series that touch
> lots of code, please explicitly state what commit the series is based on to
> make it easy for reviewers to apply the patches, even if the series needs a
> rebase.
Sorry for the inconvenience, I'll rebase and resend this series.
