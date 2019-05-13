Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCBC1AF22
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 05:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbfEMDcF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 12 May 2019 23:32:05 -0400
Received: from mga18.intel.com ([134.134.136.126]:21992 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727278AbfEMDcE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 May 2019 23:32:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 May 2019 20:32:04 -0700
X-ExtLoop1: 1
Received: from kmsmsx154.gar.corp.intel.com ([172.21.73.14])
  by FMSMGA003.fm.intel.com with ESMTP; 12 May 2019 20:32:01 -0700
Received: from pgsmsx109.gar.corp.intel.com (10.221.44.109) by
 KMSMSX154.gar.corp.intel.com (172.21.73.14) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Mon, 13 May 2019 11:32:00 +0800
Received: from pgsmsx112.gar.corp.intel.com ([169.254.3.40]) by
 PGSMSX109.gar.corp.intel.com ([169.254.14.210]) with mapi id 14.03.0415.000;
 Mon, 13 May 2019 11:32:00 +0800
From:   "Huang, Kai" <kai.huang@intel.com>
To:     Kai Huang <kai.huang@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>
CC:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "junaids@google.com" <junaids@google.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "guangrong.xiao@gmail.com" <guangrong.xiao@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>
Subject: RE: [PATCH 0/2] Fix reserved bits calculation errors caused by MKTME
Thread-Topic: [PATCH 0/2] Fix reserved bits calculation errors caused by
 MKTME
Thread-Index: AQHVAZhHZBNVZIiMYUer4TaR56KU+qZodZDw
Date:   Mon, 13 May 2019 03:31:59 +0000
Message-ID: <105F7BF4D0229846AF094488D65A098935788A80@PGSMSX112.gar.corp.intel.com>
References: <cover.1556877940.git.kai.huang@linux.intel.com>
In-Reply-To: <cover.1556877940.git.kai.huang@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiM2JmMjAzNjAtMTUzNy00Njg0LTk5N2ItOWY5ZmYyMDM1ODkxIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoidzFYZEt1dkE0SWVOYk5pbEI0Mk5uVFhUa0llMGg0bFdRb1g1cG8zYWFQUEtMTlZBbzVydkZpN1JFdCtWbE43UCJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo/Radim,

Would you take a look?

Thanks,
-Kai


> -----Original Message-----
> From: Kai Huang [mailto:kai.huang@linux.intel.com]
> Sent: Friday, May 3, 2019 10:09 PM
> To: kvm@vger.kernel.org; pbonzini@redhat.com; rkrcmar@redhat.com
> Cc: Christopherson, Sean J <sean.j.christopherson@intel.com>;
> junaids@google.com; thomas.lendacky@amd.com; brijesh.singh@amd.com;
> guangrong.xiao@gmail.com; tglx@linutronix.de; bp@alien8.de;
> hpa@zytor.com; Huang, Kai <kai.huang@intel.com>
> Subject: [PATCH 0/2] Fix reserved bits calculation errors caused by MKTME
> 
> This series fix reserved bits related calculation errors caused by MKTME.
> MKTME repurposes high bits of physical address bits as 'keyID' thus they are
> not reserved bits, and to honor such HW behavior those reduced bits are
> taken away from boot_cpu_data.x86_phys_bits when MKTME is detected
> (exactly how many bits are taken away is configured by BIOS). Currently KVM
> asssumes bits from boot_cpu_data.x86_phys_bits to 51 are reserved bits,
> which is not true anymore with MKTME, and needs fix.
> 
> This series was splitted from the old patch I sent out around 2 weeks ago:
> 
> kvm: x86: Fix several SPTE mask calculation errors caused by MKTME
> 
> Changes to old patch:
> 
>   - splitted one patch into two patches. First patch is to move
>     kvm_set_mmio_spte_mask() as prerequisite. It doesn't impact
> functionality.
>     Patch 2 does the real fix.
> 
>   - renamed shadow_first_rsvd_bits to shadow_phys_bits suggested by Sean.
> 
>   - refined comments and commit msg to be more concise.
> 
> Btw sorry that I will be out next week and won't be able to reply email.
> 
> Kai Huang (2):
>   kvm: x86: Move kvm_set_mmio_spte_mask() from x86.c to mmu.c
>   kvm: x86: Fix reserved bits related calculation errors caused by MKTME
> 
>  arch/x86/kvm/mmu.c | 61
> ++++++++++++++++++++++++++++++++++++++++++++++++++----
>  arch/x86/kvm/x86.c | 31 ---------------------------
>  2 files changed, 57 insertions(+), 35 deletions(-)
> 
> --
> 2.13.6

