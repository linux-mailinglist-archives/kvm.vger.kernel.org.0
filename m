Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52B855063F8
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 07:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348660AbiDSFqX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 01:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbiDSFqW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 01:46:22 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B05E220EB;
        Mon, 18 Apr 2022 22:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650347021; x=1681883021;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wL0mWb5EUPM1GhSsvIU5cWAq5FjA0Desn4tLJo1cmZc=;
  b=hMHwFy2/CoOiGNeMGnB9gq7Vuv03PXf482rLkOjGSZbgHuqY3UxmpYzv
   Ietqqrp58MqtYYFqHFZKOODGjeLItAczqrVpFA+hneSYLoKaxQNQwxT7G
   EZbnOXpdsb5GrcqfaCZeoAVeBr8zJH+zHGIoG2ssiKDN3+60AqovEPOgE
   Hbu9FTST9x4rBdglDskpJxq2IMRAKnrpsGqe5QM28VytazTLnXzuRLjJ1
   Ymv2l9zhMgXXPbx8zaWeE7KrxwZa1Si9dqVuUt2HaT4dQbN3KC91npRdY
   hS2Fh70ZR3neyFCYGMc6Ega1RLWzRU3pZxq7FKmAFTJ5p7S2aKKY7Muoy
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10321"; a="263856482"
X-IronPort-AV: E=Sophos;i="5.90,271,1643702400"; 
   d="scan'208";a="263856482"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2022 22:42:14 -0700
X-IronPort-AV: E=Sophos;i="5.90,271,1643702400"; 
   d="scan'208";a="657511655"
Received: from chferrer-mobl.amr.corp.intel.com (HELO [10.209.37.31]) ([10.209.37.31])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2022 22:42:12 -0700
Message-ID: <abfb95df-4f34-1663-42e8-b9d06bab3b58@linux.intel.com>
Date:   Mon, 18 Apr 2022 22:42:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH v3 02/21] x86/virt/tdx: Detect TDX private KeyIDs
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com, isaku.yamahata@intel.com
References: <cover.1649219184.git.kai.huang@intel.com>
 <2fb62e93734163d2f367fd44e3335cd8a2bf2995.1649219184.git.kai.huang@intel.com>
From:   Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <2fb62e93734163d2f367fd44e3335cd8a2bf2995.1649219184.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/5/22 9:49 PM, Kai Huang wrote:
>   	detect_seam(c);
> +	detect_tdx_keyids(c);

Do you want to add some return value to detect_seam() and not
proceed if it fails?

In case if this function is going to be extended by future
patch set, maybe do the same for detect_tdx_keyids()?

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
