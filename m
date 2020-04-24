Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 179391B783A
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 16:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgDXOVU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 10:21:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:51365 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727015AbgDXOVT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 10:21:19 -0400
IronPort-SDR: EGUADPmuQpoAJeAE70gnWNAz84OOrGkcyAwBgKkoll4mFBBeeLbS1K6inQfFaDKNkH5b7erCXY
 +zhWcHdX+8EA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2020 07:21:18 -0700
IronPort-SDR: T4Dh+fjk2m2SVbIGw5lcG37MzigVUM71dhtRiCFQq4RsVNQyWYTuqKrw8ecxdH71vMwvzqV1b+
 bOLsTjqosHjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,311,1583222400"; 
   d="scan'208";a="403313438"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by orsmga004.jf.intel.com with ESMTP; 24 Apr 2020 07:21:15 -0700
Date:   Fri, 24 Apr 2020 22:23:17 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v11 9/9] KVM: X86: Set CET feature bits for CPUID
 enumeration
Message-ID: <20200424142317.GG24039@local-michael-cet-test>
References: <20200326081847.5870-1-weijiang.yang@intel.com>
 <20200326081847.5870-10-weijiang.yang@intel.com>
 <20200423165812.GC25564@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423165812.GC25564@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 23, 2020 at 09:58:12AM -0700, Sean Christopherson wrote:
> For the shortlog, use something like
> 
>   KVM: x86: Enable CET virtualization and advertise CET to userspace
> 
> It took me a while to find the patch that actually allowed setting CR4.CET
> because I was only scanning the shortlogs :-)
I always feel it's hard for me to get a good shortlog, sorry for
the inconvenience :-(
