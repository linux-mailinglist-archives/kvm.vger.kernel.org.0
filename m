Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAF741BDA0
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 21:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729202AbfEMTOn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 15:14:43 -0400
Received: from mga18.intel.com ([134.134.136.126]:60816 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726586AbfEMTOm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 15:14:42 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 May 2019 12:14:41 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga004.jf.intel.com with ESMTP; 13 May 2019 12:14:41 -0700
Date:   Mon, 13 May 2019 12:14:41 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: Re: [PATCH 2/3] KVM: LAPIC: Fix lapic_timer_advance_ns parameter
 overflow
Message-ID: <20190513191441.GK28561@linux.intel.com>
References: <1557401361-3828-1-git-send-email-wanpengli@tencent.com>
 <1557401361-3828-3-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1557401361-3828-3-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 09, 2019 at 07:29:20PM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> After commit c3941d9e0 (KVM: lapic: Allow user to disable adaptive tuning of 
> timer advancement), '-1' enables adaptive tuning starting from default 
> advancment of 1000ns. However, we should expose an int instead of an overflow 
> uint module parameter.
> 
> Before patch:
> 
> /sys/module/kvm/parameters/lapic_timer_advance_ns:4294967295
> 
> After patch:
> 
> /sys/module/kvm/parameters/lapic_timer_advance_ns:-1
> 
> Fixes: c3941d9e0 (KVM: lapic: Allow user to disable adaptive tuning of timer advancement)
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Liran Alon <liran.alon@oracle.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
