Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4502C611446
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 16:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiJ1OQY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 10:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbiJ1OQJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 10:16:09 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4C973913;
        Fri, 28 Oct 2022 07:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666966566; x=1698502566;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=aEMuLa1b6x1jF2K/A81DVuq/EYef369Hcj1YRFD+GDo=;
  b=ACSNVS4d/aOCAboULd0ol/FFktMFHtiRk42S06lE5cpFe+ZPFb5AuFWg
   etJ9Lx+SKE0Jz+FeTBQnRdC28aOtL6e8ngHbCJ/bK0Py568a0PSkVGTmQ
   hm6X+gsJ8VSL716Fcn5/yOF8ojjau4kcD7aBEjauEaUVcOZ9u4qb6vy9w
   y6dphtB31wZeJjFuYX5r3/lTU+pquyv8tucSrgekPtzMOvC3xdOid9zOp
   9ofHCrLfPRJrzbGIpdoipg4YERpXfkCYmruAGtKuIW4D3SAzXa4CyNxxg
   daBq0Lxn1YS4uVcCLS5Z9WItsRbGEws9gC6dUQ0OBk4QzyyaHLQ0EP0Ly
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="308489815"
X-IronPort-AV: E=Sophos;i="5.95,221,1661842800"; 
   d="scan'208";a="308489815"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 07:16:05 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="696230408"
X-IronPort-AV: E=Sophos;i="5.95,221,1661842800"; 
   d="scan'208";a="696230408"
Received: from jbandiax-mobl.amr.corp.intel.com (HELO [10.209.126.71]) ([10.209.126.71])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 07:16:04 -0700
Message-ID: <c2145924-2448-4606-3de5-65df8da017ce@intel.com>
Date:   Fri, 28 Oct 2022 07:16:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v6 21/21] Documentation/x86: Add documentation for TDX
 host support
Content-Language: en-US
To:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, peterz@infradead.org,
        ak@linux.intel.com, isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, sagis@google.com,
        imammedo@redhat.com
References: <cover.1666824663.git.kai.huang@intel.com>
 <a3783eb87c0b3e652938dfd8714ed2fe93989c76.1666824663.git.kai.huang@intel.com>
 <Y1vQd+HGhfxkHQrz@debian.me>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <Y1vQd+HGhfxkHQrz@debian.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/28/22 05:52, Bagas Sanjaya wrote:
> -architecture doesn't require the BIOS to load the TDX module, but the
> -kernel assumes it is loaded by the BIOS.
> +architecture doesn't require the BIOS to load the TDX module, however the
> +kernel assumes that it is loaded by the BIOS.

Hi Bagas,

I just read the first hunk of your suggestions.  What Kai had was fine.
There's no reason to change "but" to "however".  Both are, to my eye,
perfectly fine.

I appreciate that these suggestions are trying to improve things.  But,
I don't think they're an appreciable improvement.

OK, I lied.  I went and read one more random hunk:

> -Currently the kernel doesn't handle hot-removal of convertible memory but
> -depends on the BIOS to behave correctly.
> +Currently the kernel that hot-removal but assumes that BIOS behaves
> +correctly.

This turns a perfectly good sentence into gibberish.  It makes Kai's
documentation demonstrably worse.  To make matters worse, it's mixed in
with those arbitrary changes like but->however to make it harder to find.

Please stop sending these patches.  They're not helping.  In fact, they
are consuming reviewer and contributor time, so they're actually making
the situation _worse_.
