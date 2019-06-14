Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF12463FC
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 18:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbfFNQZk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 12:25:40 -0400
Received: from mga04.intel.com ([192.55.52.120]:18718 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbfFNQZk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 12:25:40 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jun 2019 09:25:39 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga005.fm.intel.com with ESMTP; 14 Jun 2019 09:25:39 -0700
Date:   Fri, 14 Jun 2019 09:25:39 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com
Subject: Re: [PATCH 21/43] KVM: nVMX: Don't reread VMCS-agnostic state when
 switching VMCS
Message-ID: <20190614162532.GG12191@linux.intel.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
 <1560445409-17363-22-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560445409-17363-22-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 13, 2019 at 07:03:07PM +0200, Paolo Bonzini wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> When switching between vmcs01 and vmcs02, there is no need to update
> state tracking for values that aren't tied to any particular VMCS as
> the per-vCPU values are already up-to-date (vmx_switch_vmcs() can only
> be called when the vCPU is loaded).
> 
> Avoiding the update eliminates a RDMSR, and potentially a RDPKRU and
> posted-interrupt updated (cmpxchg64() and more).

Another typo, s/updated/update.

> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
