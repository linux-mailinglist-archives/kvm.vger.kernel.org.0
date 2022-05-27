Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4534053576A
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 03:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233358AbiE0Bzz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 21:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233163AbiE0Bzy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 21:55:54 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1B3E2777;
        Thu, 26 May 2022 18:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653616553; x=1685152553;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4L9nxHFmH9oqt+vCvoDGP6r7G7H9tIQDSf9b5cZbxqE=;
  b=HxgWM/SjpX40NTTPRLy8LZ+JbNsdb0vWOSkorBql3T74CfreNEPqTn1E
   YO/rFFxYFs/V1bA8UG8oXu9U4dozB1YX1c5FqWhzrhrVLsftUK18kSXpl
   p6KfxZzO2J3iR2TotN13YiyZjDK6+0I8JGEgcgLDAeIM9Dz/OibEc15Y3
   wew9c2L4XlLAHujFX33DvomtXfiCy92rA/qgZdnOvSvclgrlC3n50UUt9
   eS9C5KAM5+Hf0HvVpYtVYPEL8iyPSQlBjcwFzMvtigF4eKJ2zlx9fDYL2
   T0HygirJYu6rHVgpTpMKwjIhbqVNMp+SRgkA/JuftwCWPa6/UsfCPKsH4
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10359"; a="274356482"
X-IronPort-AV: E=Sophos;i="5.91,254,1647327600"; 
   d="scan'208";a="274356482"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2022 18:55:51 -0700
X-IronPort-AV: E=Sophos;i="5.91,254,1647327600"; 
   d="scan'208";a="704879564"
Received: from leiwang7-mobl.ccr.corp.intel.com (HELO [10.254.211.236]) ([10.254.211.236])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2022 18:55:49 -0700
Message-ID: <be0d476a-b309-5177-2e98-d0a683785d4a@intel.com>
Date:   Fri, 27 May 2022 09:55:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.1
Subject: Re: [PATCH v7 1/8] KVM: VMX: Introduce PKS VMCS fields
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, chenyi.qiang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220424101557.134102-1-lei4.wang@intel.com>
 <20220424101557.134102-2-lei4.wang@intel.com> <Yo1GW/7OuRooi3nT@google.com>
From:   "Wang, Lei" <lei4.wang@intel.com>
In-Reply-To: <Yo1GW/7OuRooi3nT@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/25/2022 4:55 AM, Sean Christopherson wrote:
> Uber nit, PKRS isn't saved if VMX doesn't support the entry control.
>    Every VM exit saves PKRS into guest-state area if VM_ENTRY_LOAD_IA32_PKRS
>    is supported by the CPU.
>
> With that tweak,

Make sense, will fix it.

