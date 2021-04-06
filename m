Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 143BB355040
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 11:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232709AbhDFJmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 05:42:07 -0400
Received: from mga04.intel.com ([192.55.52.120]:60904 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230405AbhDFJmF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 05:42:05 -0400
IronPort-SDR: mBtyG2M3sFz/8L7p6lNChQA6RQsHpgHc1F4gh8CHs1WBoVTWy8EVDPx3jHStufGFuvz7IBLKjb
 z3HPFhrl/3cg==
X-IronPort-AV: E=McAfee;i="6000,8403,9945"; a="190860694"
X-IronPort-AV: E=Sophos;i="5.81,309,1610438400"; 
   d="scan'208";a="190860694"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 02:41:58 -0700
IronPort-SDR: l7THF7Il50AQ8XMNfmB3optAXr14fimztOEikmoB4sMfHhCQ0iNhVwUq4ZzxyIGhtkvR8gYyvy
 lU1bZGF4bVaA==
X-IronPort-AV: E=Sophos;i="5.81,309,1610438400"; 
   d="scan'208";a="414699011"
Received: from nkanakap-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.6.197])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 02:41:54 -0700
Date:   Tue, 6 Apr 2021 21:41:52 +1200
From:   Kai Huang <kai.huang@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 13/25] x86/sgx: Add helpers to expose ECREATE and
 EINIT to KVM
Message-Id: <20210406214152.8c4d40679bd6a5e9b632637f@intel.com>
In-Reply-To: <20210406093211.GI17806@zn.tnic>
References: <cover.1616136307.git.kai.huang@intel.com>
        <20e09daf559aa5e9e680a0b4b5fba940f1bad86e.1616136308.git.kai.huang@intel.com>
        <20210405090759.GB19485@zn.tnic>
        <20210406094421.4fdfbb6c4c11e7ee64c3b0a3@intel.com>
        <20210406073917.GA17806@zn.tnic>
        <20210406205958.084147e365d04d066e4357c1@intel.com>
        <20210406090901.GH17806@zn.tnic>
        <20210406212424.86d6d4533b144d4621ecb385@intel.com>
        <20210406093211.GI17806@zn.tnic>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 6 Apr 2021 11:32:11 +0200 Borislav Petkov wrote:
> On Tue, Apr 06, 2021 at 09:24:24PM +1200, Kai Huang wrote:
> > Such invalid input has already been handled in handle_encls_xx() before calling
> > the two helpers in this patch. KVM returns to Qemu and let it decide whether to
> > kill or not. The access_ok()s here are trying to catch KVM bug.
> 
> Whatever they try to do, you cannot continue creating an enclave using
> invalid input, no matter whether you've warned or not. People do not
> stare at dmesg all the time.
> 
> > If so we'd better inject an exception to guest (and return 1) in KVM so guest
> > can continue to run. Otherwise basically KVM will return to Qemu and let it
> > decide (and basically it will kill guest).
> >
> > I think killing guest is also OK. KVM part patches needs to be updated, though,
> > anyway.
> 
> Ok, I'll make the changes and you can redo the KVM rest ontop.
> 

Thank you!
