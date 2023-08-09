Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8FC57765A9
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 18:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbjHIQym (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 12:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjHIQyl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 12:54:41 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04DA1FCC;
        Wed,  9 Aug 2023 09:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691600080; x=1723136080;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=cWd+WJtraePHa8yoIsytNwHvyearb/8mHjcRzWKS4Cw=;
  b=ITuPxZkKcJ45A3mH1pQkDyE7xXVsK/qm699VtHwJlmgQHsZVofx9nNgG
   Yg6WhDS3PVELvr7dOnFb7fLNQT68gWJuMm6HxK/w3ls7xwrdO5SU0L0tx
   hShZFU9CDt3dOtuKYF8fQQdmi/bk43xLrV3ZVl+yskG6YqZB2ADeFIIbx
   IlsOzjWX4Y9v5xBbqXUter5tftS50EbWUcN9X75kTq8qpU9Uw4eFAgYMa
   QsfKOOt/SG0TyHd3LCuL3sr01XJzg8T5fbaNW3zKuYACCCuhPHSMfhMuy
   rm4L8CmR03f77b4mHXy2B86OcuQrhV0exL6JZKIwc0ZchuRooBwm/afqO
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="435065794"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="435065794"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2023 09:54:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="681752880"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="681752880"
Received: from sakkired-mobl1.amr.corp.intel.com (HELO [10.212.9.77]) ([10.212.9.77])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2023 09:54:38 -0700
Message-ID: <f66ef6d0-18f7-ebef-0297-ad2f2d578aff@linux.intel.com>
Date:   Wed, 9 Aug 2023 09:54:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 2/2] x86: move gds_ucode_mitigated() declaration to header
Content-Language: en-US
To:     Arnd Bergmann <arnd@kernel.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Michal Luczaj <mhal@rbox.co>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20230809130530.1913368-1-arnd@kernel.org>
 <20230809130530.1913368-2-arnd@kernel.org>
From:   Daniel Sneddon <daniel.sneddon@linux.intel.com>
In-Reply-To: <20230809130530.1913368-2-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

HI Arnd,

On 8/9/23 06:05, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The declaration got placed in the .c file of the caller, but that
> causes a warning for the definition:
> 
> arch/x86/kernel/cpu/bugs.c:682:6: error: no previous prototype for 'gds_ucode_mitigated' [-Werror=missing-prototypes]

When I build with gcc 9.4 and the x86_64_defconfig I don't see this warning even
without this patch. I'm curious why you're seeing it and I'm not. Any ideas?

Thanks,
Dan

