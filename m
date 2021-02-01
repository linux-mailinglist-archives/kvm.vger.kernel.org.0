Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977CA309FA3
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 01:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbhBAAI4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Jan 2021 19:08:56 -0500
Received: from mga03.intel.com ([134.134.136.65]:30928 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229677AbhBAAIy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Jan 2021 19:08:54 -0500
IronPort-SDR: 8qvvcBmteURxZ/uO7pqMo2iB6ABWrdgZX/GC+o9vy0zZ6dQDY1hO6ZtvVUxBaNe6TijUR92tJb
 oGNcQn1cSQVQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9881"; a="180691719"
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="180691719"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2021 16:08:12 -0800
IronPort-SDR: N6XKCKKPUMQ6F6nFwGomBDT/PU8tpHKJxrbhC8v3UDo2QPzxcaRnoaS3w6R4ytwvi6IbtjL7yK
 LgL+9INuUh2g==
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="358411177"
Received: from kpeng-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.130.129])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2021 16:08:09 -0800
Date:   Mon, 1 Feb 2021 13:08:07 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 02/27] x86/cpufeatures: Make SGX_LC feature bit
 depend on SGX bit
Message-Id: <20210201130807.edc7c5e99fa6d7c9b46ac279@intel.com>
In-Reply-To: <YBVdqXYphsGWg1Lk@kernel.org>
References: <cover.1611634586.git.kai.huang@intel.com>
        <bdca25f260a895fcc39b2fb59e1155102a210aa0.1611634586.git.kai.huang@intel.com>
        <YBVdqXYphsGWg1Lk@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 30 Jan 2021 15:22:49 +0200 Jarkko Sakkinen wrote:
> On Tue, Jan 26, 2021 at 10:30:17PM +1300, Kai Huang wrote:
> > Move SGX_LC feature bit to CPUID dependency table as well, along with
> > new added SGX1 and SGX2 bit, to make clearing all SGX feature bits
> > easier. Also remove clear_sgx_caps() since it is just a wrapper of
> > setup_clear_cpu_cap(X86_FEATURE_SGX) now.
> > 
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> 
> Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> So could this be an improvement to the existing code? If so, then
> this should be the first patch. Also, I think that then this can
> be merged independently from rest of the patch set.

W/o SGX1/SGX2, I don't know whether it is worth to put SGX_LC into cpuid
dependency table, and kill clear_sgx_caps(). And since both you and Dave
already provided Acked-by, I am a little bit reluctant to switch the order
(because obviously both patches will be different).

Let me know if you still want me to switch patch order.
