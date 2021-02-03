Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27CD230E6D8
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 00:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbhBCXLp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 18:11:45 -0500
Received: from mga04.intel.com ([192.55.52.120]:38359 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233704AbhBCXKI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 18:10:08 -0500
IronPort-SDR: J+oKVYuBKMYdqkRVgHArdEIcM/2vhmAIdIiBjhCXir/joHpHJY6YvgHyA6ckvGO/sCUkEgVE+u
 Q/qntBE5XGVA==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="178573542"
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="178573542"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 15:09:42 -0800
IronPort-SDR: jS1BfyMwvQAv/LMWd4e+ehU1gcsAlJxctbsJIKBRDze2O2+c7Ea9VBeknKvkSza2fK9f6TvbK/
 6/cVGKOfzY9g==
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="576070334"
Received: from rvchebia-mobl.amr.corp.intel.com ([10.251.7.104])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 15:09:37 -0800
Message-ID: <d044ccde68171dc319d77917c8ab9f83e9a98645.camel@intel.com>
Subject: Re: [RFC PATCH v3 00/27] KVM SGX virtualization support
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "luto@kernel.org" <luto@kernel.org>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "b.thiel@posteo.de" <b.thiel@posteo.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "Huang, Haitao" <haitao.huang@intel.com>
Date:   Thu, 04 Feb 2021 12:09:35 +1300
In-Reply-To: <c827fed1-d7af-a94a-b69e-114d4a2ec988@intel.com>
References: <cover.1611634586.git.kai.huang@intel.com>
         <4b4b9ed1d7756e8bccf548fc41d05c7dd8367b33.camel@intel.com>
         <YBnTPmbPCAUS6XNl@google.com>
         <99135352-8e10-fe81-f0dc-8d552d73e3d3@intel.com>
         <YBnmow4e8WUkRl2H@google.com>
         <f50ac476-71f2-60d4-5008-672365f4d554@intel.com>
         <YBrfF0XQvzQf9PhR@google.com>
         <475c5f8b-efb7-629d-b8d2-2916ee150e4f@redhat.com>
         <c827fed1-d7af-a94a-b69e-114d4a2ec988@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-02-03 at 09:46 -0800, Dave Hansen wrote:
> On 2/3/21 9:43 AM, Paolo Bonzini wrote:
> > On 03/02/21 18:36, Sean Christopherson wrote:
> > > I'm not at all opposed to preventing KVM from accessing EPC, but I
> > > really don't want to add a special check in KVM to avoid reading EPC.
> > > KVM generally isn't aware of physical backings, and the relevant KVM
> > > code is shared between all architectures.
> > 
> > Yeah, special casing KVM is almost always the wrong thing to do.
> > Anything that KVM can do, other subsystems will do as well.
> 
> Agreed.  Thwarting ioremap itself seems like the right way to go.

This sounds irrelevant to KVM SGX, thus I won't include it to KVM SGX series.

