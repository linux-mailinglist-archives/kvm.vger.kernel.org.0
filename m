Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDE46723537
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 04:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbjFFCWi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 22:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbjFFCWh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 22:22:37 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400CA11B;
        Mon,  5 Jun 2023 19:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686018155; x=1717554155;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IdkdpR7EoP154U8ZZwXd/sR65SvJg9WNNDYxTJ39amM=;
  b=at8xLMyJQppApK1wZMSC2bfmoCaFSMtY2WljwOkyqWjv8d/GUk9nBfkL
   UJ88Z2knhJfCurA/c+hjkqu70BiRGpCavATDB3FZb4ebWGJ2YVZubVP+G
   OSQqN6gimCJT3f06u9HqVmYfBvwI2H9Rkup/2SZsSiK+7NRFccleB7u8N
   zMgLM8WlW5yU40y9gblFIbFmcUF3y6lMYTkQOMZoTUY5uaMxoJOWZ7EIU
   RVEjb2JQ+f9ul7loF5nMqjEyTSNGFVTD8rXU3rj/De7njpupnslhalidD
   OTXVgn10uLf84chGqJqEQRYkdnPwpdPkWOiQVc9Jb6TtnsQYnSJhIRJWi
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="442919160"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="442919160"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 19:22:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="659337915"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="659337915"
Received: from zengguan-mobl1.ccr.corp.intel.com (HELO [10.249.170.218]) ([10.249.170.218])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 19:22:30 -0700
Message-ID: <77d1b6d5-d27f-f9e3-83c3-fa29acbb421e@intel.com>
Date:   Tue, 6 Jun 2023 10:22:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v1 0/6] LASS KVM virtualization support
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230601142309.6307-1-guang.zeng@intel.com>
 <ZHk5SRi6bFcHRyxV@google.com>
Content-Language: en-US
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <ZHk5SRi6bFcHRyxV@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/2/2023 8:35 AM, Sean Christopherson wrote:
> On Thu, Jun 01, 2023, Zeng Guang wrote:
>> v0->v1
> Heh, the kernel process is a bit of a heathen and starts counting patch versions
> at '1', not '0'.  I.e. this should be v2, not v1.  No need to resend, just an FYI
> for the future.

Got it !
Thanks.

