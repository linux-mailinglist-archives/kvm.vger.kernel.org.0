Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 372EE5AC85C
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 02:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234039AbiIEA6R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Sep 2022 20:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232085AbiIEA6H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Sep 2022 20:58:07 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B85725E85
        for <kvm@vger.kernel.org>; Sun,  4 Sep 2022 17:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662339486; x=1693875486;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=YzhiMcnNvEkzR0+JM0yNBiJ87xB0TW2FYyKCzuVLNCQ=;
  b=ag3kHR69QfofBW6dksCyRwRTjwbZpKPhcv1lF8yy6oq5H1xeCO+UTY7A
   qFnnxRdkUVZHMwtTU/4tzoS1soDqUIz5F8uTSOY73cvc9mKfe9vmOY6tx
   Cd+ENMlSlzpnTq0PJ8P0+Kv5lbEpKj3D8TrdC+MWwbbumGh0GxBTRvF9s
   oQcedLZOGpXOFtcnx1mOaarPa7XTadfJ9PeLZo30meXsGqFe8bZVgkDYN
   D0eDXvV5ITGy/ZQoveeaRcUdzhfT4s+zcMOEUJqTV8f1loUohj8AY1gxB
   yFoCTC5YyZvN+rGMC3Ebz1Gd+68b7mUUCYIyIq1vCm6Ou82GptU/+LnAW
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10460"; a="279297554"
X-IronPort-AV: E=Sophos;i="5.93,290,1654585200"; 
   d="scan'208";a="279297554"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2022 17:58:06 -0700
X-IronPort-AV: E=Sophos;i="5.93,290,1654585200"; 
   d="scan'208";a="590722460"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.175.200]) ([10.249.175.200])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2022 17:58:05 -0700
Message-ID: <0752e387-187d-2edb-2feb-56bdec37d0ce@intel.com>
Date:   Mon, 5 Sep 2022 08:58:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.13.0
Subject: Re: [PATCH v1 00/40] TDX QEMU support
Content-Language: en-US
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <20220802074750.2581308-1-xiaoyao.li@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220802074750.2581308-1-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Gerd

On 8/2/2022 3:47 PM, Xiaoyao Li wrote:
..
> == Change history ==
> Changes from RFC v4:
> [RFC v4] https://lore.kernel.org/qemu-devel/20220512031803.3315890-1-xiaoyao.li@intel.com/
> 
> - Add 3 more patches(9, 10, 11) to improve the tdx_get_supported_cpuid();

Patch 8-11 are the only left ones that don't get your Acked-by. Do you 
have any comment on them?
