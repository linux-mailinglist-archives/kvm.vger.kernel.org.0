Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4371B8182
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 23:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgDXVFl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 17:05:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:46573 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726027AbgDXVFl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 17:05:41 -0400
IronPort-SDR: w/rTwhOgOMxKJpO2lBvmgH5RyDPDH+DRzfQLojfms8UseVUUOeJ82BvXVm1VVN2y+M6vnxDi/8
 8L044v+c2g4Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2020 14:05:40 -0700
IronPort-SDR: 8GQNswSYuBZBPJ7gvgw0E/EGM17dpTPr15NjXmTjPyZR3rnXFIRo/QKtduKbjaX74ls3riOVm0
 bwoGDjvzHAGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,313,1583222400"; 
   d="scan'208";a="457510764"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 24 Apr 2020 14:05:40 -0700
Date:   Fri, 24 Apr 2020 14:05:39 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Oliver Upton <oupton@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, wei.huang2@amd.com, cavery@redhat.com,
        vkuznets@redhat.com, Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 00/22] KVM: Event fixes and cleanup
Message-ID: <20200424210539.GH30013@linux.intel.com>
References: <20200424172416.243870-1-pbonzini@redhat.com>
 <20200424210242.GA80882@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424210242.GA80882@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 24, 2020 at 09:02:42PM +0000, Oliver Upton wrote:
> Paolo,
> 
> I've only received patches 1-9 for this series, could you resend? :)

Same here, I was hoping they would magically show up.
