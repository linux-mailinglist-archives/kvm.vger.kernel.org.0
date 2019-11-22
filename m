Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 358C41074BB
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 16:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfKVPVi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 10:21:38 -0500
Received: from mga05.intel.com ([192.55.52.43]:20354 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbfKVPVi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 10:21:38 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 07:21:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,230,1571727600"; 
   d="scan'208";a="290674266"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by orsmga001.jf.intel.com with ESMTP; 22 Nov 2019 07:21:36 -0800
Date:   Fri, 22 Nov 2019 23:23:31 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmattson@google.com,
        sean.j.christopherson@intel.com, yu.c.zhang@linux.intel.com,
        alazar@bitdefender.com, edwin.zhai@intel.com
Subject: Re: [PATCH v7 2/9] vmx: spp: Add control flags for Sub-Page
 Protection(SPP)
Message-ID: <20191122152331.GA9822@local-michael-cet-test>
References: <20191119084949.15471-1-weijiang.yang@intel.com>
 <20191119084949.15471-3-weijiang.yang@intel.com>
 <d6e71e7b-b708-211c-24b7-8ffe03a52842@redhat.com>
 <20191121153442.GH17169@local-michael-cet-test>
 <58b4b445-bd47-d357-9fdd-118043624215@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58b4b445-bd47-d357-9fdd-118043624215@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 21, 2019 at 05:02:42PM +0100, Paolo Bonzini wrote:
> On 21/11/19 16:34, Yang Weijiang wrote:
> > On Thu, Nov 21, 2019 at 11:04:51AM +0100, Paolo Bonzini wrote:
> >> On 19/11/19 09:49, Yang Weijiang wrote:
> >>> @@ -228,6 +228,7 @@
> >>>  #define X86_FEATURE_FLEXPRIORITY	( 8*32+ 2) /* Intel FlexPriority */
> >>>  #define X86_FEATURE_EPT			( 8*32+ 3) /* Intel Extended Page Table */
> >>>  #define X86_FEATURE_VPID		( 8*32+ 4) /* Intel Virtual Processor ID */
> >>> +#define X86_FEATURE_SPP			( 8*32+ 5) /* Intel EPT-based Sub-Page Write Protection */
> >>
> >> Please do not include X86_FEATURE_SPP.  In general I don't like the VMX
> >> features word, but apart from that SPP is not a feature that affects all
> >> VMs in the same way as EPT or FlexPriority.
> >>
> > So what's a friendly way to let a user check if SPP feature is there?
> 
> QEMU for example ships with a program called vmxcap (though it requires
> root).  We also could write a program to analyze the KVM capabilities
> and print them, and put it in tools/kvm.
>
OK, will update vmxcap to add SPP feature bit, thanks!
> Thanks,
> 
> Paolo
