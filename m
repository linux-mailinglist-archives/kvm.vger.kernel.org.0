Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C640D38E4D
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 17:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729419AbfFGPCC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 11:02:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:21368 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728446AbfFGPCC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 11:02:02 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jun 2019 08:02:01 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Jun 2019 08:02:01 -0700
Date:   Fri, 7 Jun 2019 08:02:00 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Eugene Korenevsky <ekorenevsky@gmail.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v5 3/3] kvm: vmx: handle_vmwrite: avoid checking for
 compatibility mode
Message-ID: <20190607150200.GD9083@linux.intel.com>
References: <20190607060404.GA29127@dnote>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190607060404.GA29127@dnote>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 07, 2019 at 09:04:04AM +0300, Eugene Korenevsky wrote:
> handle_vmwrite() should use is_long_mode() instead of is_64_bit_mode()
> because VMWRITE opcode is invalid in compatibility mode and there is no
> reason for extra checking CS.L.
> 
> Signed-off-by: Eugene Korenevsky <ekorenevsky@gmail.com>

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
