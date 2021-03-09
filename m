Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85DD9332DDB
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 19:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbhCISI6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 13:08:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:32469 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229691AbhCISI0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 13:08:26 -0500
IronPort-SDR: EQA/y7d2+ZGXty8uRwddQ0hbMn+FrW3NXZKRU3Q/I/qm1P+7bX3ltCUJbxP22Ky2E7XkK8BpPv
 IFG7Jk0vVc7A==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="188395941"
X-IronPort-AV: E=Sophos;i="5.81,236,1610438400"; 
   d="scan'208";a="188395941"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2021 10:08:22 -0800
IronPort-SDR: 20GELUBpTBCAyjRitRaEEf2u0/w3WWcCgFpSSYmo4fiujBJPTDDu3iMMDGXjXUTkadkkRrv6p/
 MG2fAgxxQC4w==
X-IronPort-AV: E=Sophos;i="5.81,236,1610438400"; 
   d="scan'208";a="403326250"
Received: from kvolpe-mobl1.amr.corp.intel.com ([10.251.3.165])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2021 10:08:16 -0800
Message-ID: <b6b93b11e9b5383c613d402806678fa77b7df7e8.camel@intel.com>
Subject: Re: [PATCH v2 00/25] KVM SGX virtualization support
From:   Kai Huang <kai.huang@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, jethro@fortanix.com,
        b.thiel@posteo.de, jmattson@google.com, joro@8bytes.org,
        vkuznets@redhat.com, wanpengli@tencent.com, corbet@lwn.net
Date:   Wed, 10 Mar 2021 07:08:14 +1300
In-Reply-To: <20210309093037.GA699@zn.tnic>
References: <cover.1615250634.git.kai.huang@intel.com>
         <20210309093037.GA699@zn.tnic>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-03-09 at 10:30 +0100, Borislav Petkov wrote:
> On Tue, Mar 09, 2021 at 02:38:49PM +1300, Kai Huang wrote:
> > This series adds KVM SGX virtualization support. The first 14 patches starting
> > with x86/sgx or x86/cpu.. are necessary changes to x86 and SGX core/driver to
> > support KVM SGX virtualization, while the rest are patches to KVM subsystem.
> 
> Ok, I guess I'll queue 1-14 once Sean doesn't find anything
> objectionable then give Paolo an immutable commit to base the KVM stuff
> ontop.
> 
> Unless folks have better suggestions, ofc.
> 
> Thx.
> 
Thanks Boris!

Hi Sean, Paolo,

Could you take a look? Thanks.

