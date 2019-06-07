Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0762338CB6
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 16:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729576AbfFGOTC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 10:19:02 -0400
Received: from mga01.intel.com ([192.55.52.88]:50073 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729571AbfFGOTB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 10:19:01 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jun 2019 07:18:48 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga002.jf.intel.com with ESMTP; 07 Jun 2019 07:18:47 -0700
Date:   Fri, 7 Jun 2019 07:18:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Rename prepare_vmcs02_*_full to
 prepare_vmcs02_*_extra
Message-ID: <20190607141847.GA9083@linux.intel.com>
References: <1559834652-105872-1-git-send-email-pbonzini@redhat.com>
 <20190606184117.GJ23169@linux.intel.com>
 <8382fd94-aed1-51b4-007e-7579a0f35ece@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8382fd94-aed1-51b4-007e-7579a0f35ece@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 07, 2019 at 02:19:20PM +0200, Paolo Bonzini wrote:
> On 06/06/19 20:41, Sean Christopherson wrote:
> >> +static void prepare_vmcs02_early_extra(struct vcpu_vmx *vmx,
> > Or maybe 'uncommon', 'rare' or 'ext'?  I don't I particularly love any of
> > the names, but they're all better than 'full'.
> 
> I thought 'ext' was short for 'extra'? :)

Ha, I (obviously) didn't make that connection.  ext == extended in my mind.
