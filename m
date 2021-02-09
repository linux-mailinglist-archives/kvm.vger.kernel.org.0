Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65479314499
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 01:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbhBIAJ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 19:09:59 -0500
Received: from mga18.intel.com ([134.134.136.126]:19244 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229637AbhBIAJ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 19:09:59 -0500
IronPort-SDR: dvM88OxdR560nLNRoGBtRGdMoZ5HEkKdOHDgm0FtUUuIaP9BOAla7IGXDh5j1McNvPPkEhXXuw
 K6mzHR39filA==
X-IronPort-AV: E=McAfee;i="6000,8403,9889"; a="169485155"
X-IronPort-AV: E=Sophos;i="5.81,163,1610438400"; 
   d="scan'208";a="169485155"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 16:09:17 -0800
IronPort-SDR: DxmZJd3WvpCp1IpeDsJEehGON5dKRux4IX9XSWira0BioUIYxBZB+RYfJkUbtV0V/9pHKAoXrA
 vUc837QsE74w==
X-IronPort-AV: E=Sophos;i="5.81,163,1610438400"; 
   d="scan'208";a="358977203"
Received: from tunterlu-mobl.amr.corp.intel.com ([10.252.132.117])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 16:09:13 -0800
Message-ID: <ae10f5f7314f4d77200f2866c03adda04f232d5f.camel@intel.com>
Subject: Re: [RFC PATCH v4 15/26] KVM: VMX: Convert vcpu_vmx.exit_reason to
 a union
From:   Kai Huang <kai.huang@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com, isaku.yamahata@intel.com
Date:   Tue, 09 Feb 2021 13:09:11 +1300
In-Reply-To: <5ea4ba08-b4e7-d502-13b3-ce520013f8a9@intel.com>
References: <cover.1612777752.git.kai.huang@intel.com>
         <0daea2891388cd30097cc62a7a5644b321ae80a5.1612777752.git.kai.huang@intel.com>
         <20210209001132.426f38085622c7e3684dbb8d@intel.com>
         <5ea4ba08-b4e7-d502-13b3-ce520013f8a9@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-02-08 at 22:39 +0800, Xiaoyao Li wrote:
> On 2/8/2021 7:11 PM, Kai Huang wrote:
> > Hi Paolo,
> > 
> > Although this series was sent as RFC, would you consider reviewing and merging
> > this patch from Sean? Intel TDX support (already sent by Isaku as RFC) has
> > conflict with this one, and I am expecting other features might also conflict
> > with it too.
> > 
> 
> I see this patch is already queued with Bus Lock VM exit series.
> 

Great. :)

