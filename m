Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8628526A9E4
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 18:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727737AbgIOQek (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 12:34:40 -0400
Received: from mga03.intel.com ([134.134.136.65]:15993 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727727AbgIOQec (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 12:34:32 -0400
IronPort-SDR: TKmHPQajpT9Aas5aPuMS31wIAAbfW9wZY/fi+1lUSx0g27l5f0UPe4HvoyOvfFrxt7WIJSy4NL
 RScx6uVKTIhQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9745"; a="159351555"
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="159351555"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 09:34:07 -0700
IronPort-SDR: HRL3h+nm8BNYN0J2iQPS6GJHto9b57Orq670MPfyXwsMVm/zPZVkbOSaPQTeCNWCS8CF7J1/Ev
 c0ncLkLc81RA==
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="288054955"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 09:34:07 -0700
Date:   Tue, 15 Sep 2020 09:34:05 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [RFC PATCH 26/35] KVM: SVM: Guest FPU state save/restore not
 needed for SEV-ES guest
Message-ID: <20200915163405.GD8420@sjchrist-ice>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
 <ac35a419e395d355d86f3b44ce219dc63864db00.1600114548.git.thomas.lendacky@amd.com>
 <20200914213917.GD7192@sjchrist-ice>
 <b37cd9e1-c610-bebb-936a-ab8f73766e63@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b37cd9e1-c610-bebb-936a-ab8f73766e63@amd.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 15, 2020 at 09:25:18AM -0500, Tom Lendacky wrote:
> On 9/14/20 4:39 PM, Sean Christopherson wrote:
> > On Mon, Sep 14, 2020 at 03:15:40PM -0500, Tom Lendacky wrote:
> >> From: Tom Lendacky <thomas.lendacky@amd.com>
> >>
> >> The guest FPU is automatically restored on VMRUN and saved on VMEXIT by
> >> the hardware, so there is no reason to do this in KVM.
> > 
> > I assume hardware has its own buffer?  If so, a better approach would be to
> > not allocate arch.guest_fpu in the first place, and then rework KVM to key
> > off !guest_fpu.
> 
> Yup, let me look into that.

Heh, it's on our todo list as well :-)
