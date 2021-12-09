Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7041146E14F
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 04:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhLIDht (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 22:37:49 -0500
Received: from mga07.intel.com ([134.134.136.100]:13062 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229601AbhLIDhs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 22:37:48 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10192"; a="301391462"
X-IronPort-AV: E=Sophos;i="5.88,191,1635231600"; 
   d="scan'208";a="301391462"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2021 19:34:05 -0800
X-IronPort-AV: E=Sophos;i="5.88,191,1635231600"; 
   d="scan'208";a="503328522"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.29.184]) ([10.255.29.184])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2021 19:34:01 -0800
Message-ID: <76f582f3-c130-70cd-05bc-9d5e38cfffdb@intel.com>
Date:   Thu, 9 Dec 2021 11:33:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.3.2
Subject: Re: [RFC PATCH v2 07/44] i386/kvm: Squash getting/putting guest state
 for TDX VMs
Content-Language: en-US
To:     Gerd Hoffmann <kraxel@redhat.com>, isaku.yamahata@gmail.com
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, seanjc@google.com,
        erdemaktas@google.com, kvm@vger.kernel.org,
        isaku.yamahata@intel.com
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <7194a76cfb8541d4f7a5b6a04fb3496bc14eab15.1625704980.git.isaku.yamahata@intel.com>
 <20210826102421.bwslsyeafmullmky@sirius.home.kraxel.org>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20210826102421.bwslsyeafmullmky@sirius.home.kraxel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/26/2021 6:24 PM, Gerd Hoffmann wrote:
> On Wed, Jul 07, 2021 at 05:54:37PM -0700, isaku.yamahata@gmail.com wrote:
>> From: Sean Christopherson <sean.j.christopherson@intel.com>
>>
>> Ignore get/put state of TDX VMs as accessing/mutating guest state of
>> producation TDs is not supported.
> 
> Why silently ignore instead of returning an error?

The error is returned to upper caller in QEMU, right? There deems to be 
somewhere in QEMU to not call the IOCTLs to get guest states of TD VM.

Let's reword it to "Don't". Is it OK?


