Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 024802ACA9
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 02:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfE0AMx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 May 2019 20:12:53 -0400
Received: from mga05.intel.com ([192.55.52.43]:51181 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726015AbfE0AMx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 May 2019 20:12:53 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 May 2019 17:12:53 -0700
X-ExtLoop1: 1
Received: from khuang2-desk.gar.corp.intel.com ([10.254.22.77])
  by orsmga006.jf.intel.com with ESMTP; 26 May 2019 17:12:50 -0700
Message-ID: <1558915969.17622.8.camel@linux.intel.com>
Subject: Re: [PATCH 0/2] Fix reserved bits calculation errors caused by MKTME
From:   Kai Huang <kai.huang@linux.intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>
Cc:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "junaids@google.com" <junaids@google.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "guangrong.xiao@gmail.com" <guangrong.xiao@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>
Date:   Mon, 27 May 2019 12:12:49 +1200
In-Reply-To: <105F7BF4D0229846AF094488D65A098935788A80@PGSMSX112.gar.corp.intel.com>
References: <cover.1556877940.git.kai.huang@linux.intel.com>
         <105F7BF4D0229846AF094488D65A098935788A80@PGSMSX112.gar.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.24.6 (3.24.6-1.fc26) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Kindly ping.

Thanks,
-Kai

On Mon, 2019-05-13 at 03:31 +0000, Huang, Kai wrote:
> Hi Paolo/Radim,
> 
> Would you take a look?
> 
> Thanks,
> -Kai
> 
> 
> > -----Original Message-----
> > From: Kai Huang [mailto:kai.huang@linux.intel.com]
> > Sent: Friday, May 3, 2019 10:09 PM
> > To: kvm@vger.kernel.org; pbonzini@redhat.com; rkrcmar@redhat.com
> > Cc: Christopherson, Sean J <sean.j.christopherson@intel.com>;
> > junaids@google.com; thomas.lendacky@amd.com; brijesh.singh@amd.com;
> > guangrong.xiao@gmail.com; tglx@linutronix.de; bp@alien8.de;
> > hpa@zytor.com; Huang, Kai <kai.huang@intel.com>
> > Subject: [PATCH 0/2] Fix reserved bits calculation errors caused by MKTME
> > 
> > This series fix reserved bits related calculation errors caused by MKTME.
> > MKTME repurposes high bits of physical address bits as 'keyID' thus they are
> > not reserved bits, and to honor such HW behavior those reduced bits are
> > taken away from boot_cpu_data.x86_phys_bits when MKTME is detected
> > (exactly how many bits are taken away is configured by BIOS). Currently KVM
> > asssumes bits from boot_cpu_data.x86_phys_bits to 51 are reserved bits,
> > which is not true anymore with MKTME, and needs fix.
> > 
> > This series was splitted from the old patch I sent out around 2 weeks ago:
> > 
> > kvm: x86: Fix several SPTE mask calculation errors caused by MKTME
> > 
> > Changes to old patch:
> > 
> >   - splitted one patch into two patches. First patch is to move
> >     kvm_set_mmio_spte_mask() as prerequisite. It doesn't impact
> > functionality.
> >     Patch 2 does the real fix.
> > 
> >   - renamed shadow_first_rsvd_bits to shadow_phys_bits suggested by Sean.
> > 
> >   - refined comments and commit msg to be more concise.
> > 
> > Btw sorry that I will be out next week and won't be able to reply email.
> > 
> > Kai Huang (2):
> >   kvm: x86: Move kvm_set_mmio_spte_mask() from x86.c to mmu.c
> >   kvm: x86: Fix reserved bits related calculation errors caused by MKTME
> > 
> >  arch/x86/kvm/mmu.c | 61
> > ++++++++++++++++++++++++++++++++++++++++++++++++++----
> >  arch/x86/kvm/x86.c | 31 ---------------------------
> >  2 files changed, 57 insertions(+), 35 deletions(-)
> > 
> > --
> > 2.13.6
> 
> 
