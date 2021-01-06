Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF1862EC5D3
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 22:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbhAFVkz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 16:40:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:37237 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726225AbhAFVkz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 16:40:55 -0500
IronPort-SDR: m/Ma0OgRXfIiRzo6vXctVEQXPCbyDi5R4prasF49P+n/55ZgAJS4CHlLwfaVm/YU3qdx9H1DLM
 DscOFzaenx/Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9856"; a="195891242"
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="195891242"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 13:40:14 -0800
IronPort-SDR: UZKVZUZFR7iI153GpVLzx5YEXqcOPdjGGSsoa0zjyw+/OoRZvdUtFxAnY+fY9ASl4xZ6IHwsLS
 LcJJP9mgej5w==
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="379433054"
Received: from vastrong-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.230.243])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 13:40:11 -0800
Date:   Thu, 7 Jan 2021 10:40:09 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     <linux-sgx@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>, <seanjc@google.com>, <jarkko@kernel.org>,
        <luto@kernel.org>, <haitao.huang@intel.com>, <pbonzini@redhat.com>,
        <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>
Subject: Re: [RFC PATCH 02/23] x86/sgx: Add enum for SGX_CHILD_PRESENT error
 code
Message-Id: <20210107104009.8bee3e8c76dfc8da549f5e00@intel.com>
In-Reply-To: <05f6945b-418a-b4eb-406a-0f0a23cb939f@intel.com>
References: <cover.1609890536.git.kai.huang@intel.com>
        <2a41e15dfda722dd1e34feeda34ce864cd82361b.1609890536.git.kai.huang@intel.com>
        <05f6945b-418a-b4eb-406a-0f0a23cb939f@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 6 Jan 2021 10:28:55 -0800 Dave Hansen wrote:
> On 1/5/21 5:55 PM, Kai Huang wrote:
> > Add SGX_CHILD_PRESENT for use by SGX virtualization to assert EREMOVE
> > failures are expected, but only due to SGX_CHILD_PRESENT.
> 
> This dances around the fact that this is an architectural error-code.
> Could that be explicit?  Maybe the subject should be:
> 
> 	Add SGX_CHILD_PRESENT hardware error code

Sure. I'll do that.
