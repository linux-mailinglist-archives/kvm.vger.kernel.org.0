Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5421C6B03C
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 22:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388677AbfGPUHv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 16:07:51 -0400
Received: from mga06.intel.com ([134.134.136.31]:42087 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728366AbfGPUHv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 16:07:51 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jul 2019 13:07:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,271,1559545200"; 
   d="scan'208";a="366331915"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by fmsmga005.fm.intel.com with ESMTP; 16 Jul 2019 13:07:50 -0700
Date:   Tue, 16 Jul 2019 13:07:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Singh, Brijesh" <brijesh.singh@amd.com>
Cc:     Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH 1/2] KVM: SVM: Fix workaround for AMD Errata 1096
Message-ID: <20190716200749.GC28096@linux.intel.com>
References: <CF48BCA4-4BC8-4AC8-8B48-85FA29E16719@oracle.com>
 <f6c78d65-70fc-4a79-44db-6abb0434db73@amd.com>
 <F2442A5C-702A-433D-9156-056E1844F378@oracle.com>
 <20190716164151.GC1987@linux.intel.com>
 <60D01C4B-EC2E-453E-B5F6-BBE8FA94E31D@oracle.com>
 <ce1284de-6088-afd7-ead4-6ef70b89f365@redhat.com>
 <DD44D29C-36C4-42E7-905E-7300F92F3BE6@oracle.com>
 <015b03bc-8518-2066-c916-f5e12dd2d506@amd.com>
 <174F27B9-2C6B-4B9F-8091-56FA85B32BB2@oracle.com>
 <31926848-2cf3-caca-335d-5f3e32a25cd3@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31926848-2cf3-caca-335d-5f3e32a25cd3@amd.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 16, 2019 at 08:02:43PM +0000, Singh, Brijesh wrote:
> 
> On 7/16/19 2:34 PM, Liran Alon wrote:
> > Why CPU needs to be at CPL3?
> > The requirement for SMAP should be that this page is user-accessible in guest page-tables.
> > Think on a case where guest have CR4.SMAP=1 and CR4.SMEP=0.
> > 
> 
> We are discussing reserved NPF so we need to be at CPL3.

For my own education, why does reserved NPF require CPL3?  I.e. what
happens if a reserved bit is encountered at CPL<3 (or do they simply not
exist)?
