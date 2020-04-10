Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7D621A4BA4
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 23:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgDJVqp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 17:46:45 -0400
Received: from mga14.intel.com ([192.55.52.115]:1061 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbgDJVqp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 17:46:45 -0400
IronPort-SDR: MFj3otIwkIT6wF4+RX2pzIc/lrRJAcZ6nO1g6CPnClKPDwotubRkUJBuUUDsJU+8MbJG9ClxVc
 xmArp3V46/dg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2020 14:46:45 -0700
IronPort-SDR: XOwwXQ28PsYhUo6/7ervTyDE+kdD92wM0ZGvxLylqum3Zx2ytrDlKvaOLzutEpLKfKw7h6wz3n
 jKnojMs2AW0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,368,1580803200"; 
   d="scan'208";a="452515861"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 10 Apr 2020 14:46:45 -0700
Date:   Fri, 10 Apr 2020 14:46:45 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     "Kalra, Ashish" <Ashish.Kalra@amd.com>,
        Steve Rutherford <srutherford@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v6 12/14] KVM: x86: Introduce KVM_PAGE_ENC_BITMAP_RESET
 ioctl
Message-ID: <20200410214644.GL22482@linux.intel.com>
References: <65c09963-2027-22c1-e04d-4c8c3658b2c3@oracle.com>
 <CABayD+cf=Po-k7jqUQjq3AGopxk86d6bTcBhQxijnzpcUh90GA@mail.gmail.com>
 <20200408015221.GB27608@ashkalra_ubuntu_server>
 <CABayD+f0qdS5akac8JiB_HU_pWefHDsF=xRNhzSv42w-PTXnyg@mail.gmail.com>
 <20200410013418.GB19168@ashkalra_ubuntu_server>
 <CABayD+dDtjz7rJe1ujQ_sq88JRUzHaXXNP_hQVhD1vkXkPsXCw@mail.gmail.com>
 <CABayD+dwJeu+o+TG843XX1nWHWMz=iwW0uWBKPaG0uJEsxCYGw@mail.gmail.com>
 <CABayD+cuHv6chBT5wWHqaZWXSHaOtaOQyBrxgRj2Y=q_fOheuA@mail.gmail.com>
 <DM5PR12MB1386C01E72A71F3AB6EB1F068EDE0@DM5PR12MB1386.namprd12.prod.outlook.com>
 <4be6c1a8-de3f-1e83-23d4-e0213a1acd24@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4be6c1a8-de3f-1e83-23d4-e0213a1acd24@amd.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 10, 2020 at 04:42:29PM -0500, Brijesh Singh wrote:
> 
> On 4/10/20 3:55 PM, Kalra, Ashish wrote:
> > [AMD Official Use Only - Internal Distribution Only]

Can you please resend the original mail without the above header, so us
non-AMD folks can follow along?  :-)
