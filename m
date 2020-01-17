Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 400BB140405
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2020 07:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbgAQGb1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jan 2020 01:31:27 -0500
Received: from mga06.intel.com ([134.134.136.31]:20367 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbgAQGb1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jan 2020 01:31:27 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jan 2020 22:31:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,329,1574150400"; 
   d="scan'208";a="425856119"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga006.fm.intel.com with ESMTP; 16 Jan 2020 22:31:01 -0800
Date:   Thu, 16 Jan 2020 22:31:00 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Liran Alon <liran.alon@oracle.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Roman Kagan <rkagan@virtuozzo.com>
Subject: Re: [PATCH RFC 2/3] x86/kvm/hyper-v: move VMX controls sanitization
 out of nested_enable_evmcs()
Message-ID: <20200117063100.GA6282@linux.intel.com>
References: <20200115171014.56405-1-vkuznets@redhat.com>
 <20200115171014.56405-3-vkuznets@redhat.com>
 <20200115232738.GB18268@linux.intel.com>
 <C6C4003E-0ADD-42A5-A580-09E06806E160@oracle.com>
 <877e1riy1o.fsf@vitty.brq.redhat.com>
 <20200116161928.GC20561@linux.intel.com>
 <87o8v3gwzo.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o8v3gwzo.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 16, 2020 at 05:57:31PM +0100, Vitaly Kuznetsov wrote:
> I accuse you of not reading my PATCH0 :-)

I read it, I just didn't click the link :-D

> https://lists.nongnu.org/archive/html/qemu-devel/2020-01/msg00123.html
> does exactly this :-) 
> 
> P.S. I expect Paolo to comment on which hack he hates less :-)
> 
> -- 
> Vitaly
> 
