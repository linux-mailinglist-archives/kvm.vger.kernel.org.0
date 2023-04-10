Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB5CA6DCB31
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 20:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjDJSwy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 14:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjDJSwx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 14:52:53 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A0B1BFF;
        Mon, 10 Apr 2023 11:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681152744; x=1712688744;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vU/YCKsxNE2mJ0exzu9WvsNy+JT3AJiWU5eBJo0Ul3I=;
  b=WkHRVye81hutpPvSZ1hq/nDCAtqzqG/QekP8GZjkkfIefxXxoGprGUWB
   XArwxRqMJokctY+zWPQijo2SNgWspa8sqsDVQ/shwBS30efUstQAu3vWa
   y4bd+whfESXDq5b4+7tw9yHZUziQYqw6RmpuHyAOUF57IVLr0kiosHTt0
   /DZKeoFpkJFKSigv9sE4LS8PPShV0eyns0hQ8z0lWF7nSGv8czOv5/kJz
   NHVpwZwbHBreg/obrcqijBq7ltQfyl/8ThKBn6M/oN4l6t0cEeSxUpDkf
   Ve4OOuvVf+yUNCxg7aRuu4LdLRgA1rwAJOa3E2RO7E8qq3s55rDP5cqka
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="346094870"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="346094870"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 11:49:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="934449301"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="934449301"
Received: from arsetion-mobl.amr.corp.intel.com (HELO [10.209.122.228]) ([10.209.122.228])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 11:49:44 -0700
Message-ID: <f4967a86-d575-7e82-3e60-183cfd7adf0a@intel.com>
Date:   Mon, 10 Apr 2023 11:49:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v8 00/33] x86: enable FRED for x86-64
Content-Language: en-US
To:     Xin Li <xin3.li@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com, jiangshanlai@gmail.com,
        shan.kang@intel.com, Andy Lutomirski <luto@kernel.org>
References: <20230410081438.1750-1-xin3.li@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230410081438.1750-1-xin3.li@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Oh, and one other nit.  We do have a specific maintainer for the entry code:

> X86 ENTRY CODE
> M:      Andy Lutomirski <luto@kernel.org>
> L:      linux-kernel@vger.kernel.org
> S:      Maintained
> T:      git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/asm
> F:      arch/x86/entry/

Please make sure to cc Andy on FRED going forward.

This is probably also a good cue to go and make sure you didn't miss any
other folks that need to see this series.
