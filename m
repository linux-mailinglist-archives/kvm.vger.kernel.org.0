Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E2D263685
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 21:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbgIITRw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 15:17:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:64267 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726414AbgIITRu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Sep 2020 15:17:50 -0400
IronPort-SDR: g8mvhMCjocOfacWzCuvTLgU+eWm+Qn1KH7/1Qoe3v6YwS+XiBE8w3x0eu8lbYEd/YfAQVT1hwt
 0C6Bo3491ajw==
X-IronPort-AV: E=McAfee;i="6000,8403,9739"; a="159362347"
X-IronPort-AV: E=Sophos;i="5.76,409,1592895600"; 
   d="scan'208";a="159362347"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2020 12:17:49 -0700
IronPort-SDR: Lt3l6ZJ1kTzbzFkFp+lUdGcY+Blww2nB+pPkOLGJDzjV4RvMuZU5OABfj3ToJz2YrLDGXAx73K
 uBv0YprecSSw==
X-IronPort-AV: E=Sophos;i="5.76,409,1592895600"; 
   d="scan'208";a="480584109"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2020 12:17:49 -0700
Date:   Wed, 9 Sep 2020 12:17:48 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     stsp <stsp2@yandex.ru>
Cc:     kvm@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: Re: KVM_SET_SREGS & cr4.VMXE problems
Message-ID: <20200909191748.GA11909@sjchrist-ice>
References: <8f0d9048-c935-bccf-f7bd-58ba61759a54@yandex.ru>
 <20200909163023.GA11727@sjchrist-ice>
 <fdeb1ecb-abee-2197-4449-88d33480c5fe@yandex.ru>
 <4b019c3e-e880-1409-c907-0dc2a3742813@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4b019c3e-e880-1409-c907-0dc2a3742813@yandex.ru>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 09, 2020 at 09:37:08PM +0300, stsp wrote:
> A bit of update.
> 
> 09.09.2020 21:04, stsp пишет:
> > As for the original problem: there are at least
> > 2 problems.
> > 
> > On OLD intel:
> > - KVM fails with invalid guest state unless
> > you set VMXE in guest's cr4, and do it from
> > the very first attempt!
> 
> This happens only on nested execution!
> Under qemu/kvm.

Ah, that makes a lot more sense.  So is QEMU+KVM your L0, and dosemu2 is
L1, and the DOS guest is L2?  And assuming that's the case, you observe
the weird behavior in L1, i.e. when doing KVM_SET_SREGS from dosemu2?
