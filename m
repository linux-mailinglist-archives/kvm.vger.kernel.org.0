Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A38981EE721
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 16:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbgFDO7g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 10:59:36 -0400
Received: from mga17.intel.com ([192.55.52.151]:10498 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729082AbgFDO7e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 10:59:34 -0400
IronPort-SDR: Rxic9d6J17TQzhVOv3tuCH4XFnNGOtIhMPZ21FvhRT7AqCFpMQyuwDXi/4fJRugc4b6jg9Rkvg
 VlwEClcd6VRQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2020 07:59:33 -0700
IronPort-SDR: f8xpR6ftA8jWoGpYXfb75vNCZkc5KvD3ZQyaQg8TnxPYhjeRCt/F0z1Qf9QReeDzqvAytAOHpH
 64ZoJYMs7T6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,472,1583222400"; 
   d="scan'208";a="287397621"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga002.jf.intel.com with ESMTP; 04 Jun 2020 07:59:33 -0700
Date:   Thu, 4 Jun 2020 07:59:33 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Joerg Roedel <jroedel@suse.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 25/75] x86/sev-es: Add support for handling IOIO
 exceptions
Message-ID: <20200604145932.GB30223@linux.intel.com>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-26-joro@8bytes.org>
 <20200520062055.GA17090@linux.intel.com>
 <20200603142325.GB23071@8bytes.org>
 <20200603230716.GD25606@linux.intel.com>
 <20200604101502.GA20739@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604101502.GA20739@8bytes.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 04, 2020 at 12:15:02PM +0200, Joerg Roedel wrote:
> On Wed, Jun 03, 2020 at 04:07:16PM -0700, Sean Christopherson wrote:
> > On Wed, Jun 03, 2020 at 04:23:25PM +0200, Joerg Roedel wrote:
> > > User-space can also cause IOIO #VC exceptions, and user-space can be
> > > 32-bit legacy code with segments, so es_base has to be taken into
> > > account.
> > 
> > Is there actually a use case for this?  Exposing port IO to userspace
> > doesn't exactly improve security.
> 
> Might be true, but Linux supports it and this patch-set is not the place
> to challenge this feature.

But SEV already broke it, no?
