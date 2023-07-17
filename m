Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4F347565E7
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 16:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbjGQOKf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 10:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbjGQOKd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 10:10:33 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9074CD1;
        Mon, 17 Jul 2023 07:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689603033; x=1721139033;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ti07ofyFnq/jvTkfIYFP/CvClpWzzL9NTgrba78Sbjo=;
  b=VwZkoy88VdbY7gGHsOw1UmueWViEOGXiv7mzKsi24Ia9/sKcZbi/RBSL
   J2FpPZuPpzS8hni2RF1Xg9ehKPXetGUkNhXjU+v3zuXh1m+TglO9Jisut
   puaQTduXENBkM+zAv4c6p0xzbVyc9bEqS4piaZQg3Jn1gG6EEQ34+6LkO
   zEk1+T/zrH+lik4qcqJ6d/31fjb7Gdw5hOuhT4elT055V9FzcOvNGzlNf
   50raS3Vox9PKiST7TbsaR6wNilQbeLmvDKpVpJIEAzmakKcKZan9f2M35
   8TyKG4pN0Ttjhb5DT4gDMXE0EA290vkFNZ2biLQorTo3X8plnDYVhmqoF
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10774"; a="432109744"
X-IronPort-AV: E=Sophos;i="6.01,211,1684825200"; 
   d="scan'208";a="432109744"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2023 07:07:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10774"; a="1053919805"
X-IronPort-AV: E=Sophos;i="6.01,211,1684825200"; 
   d="scan'208";a="1053919805"
Received: from alexkiru-mobl.amr.corp.intel.com (HELO [10.209.118.243]) ([10.209.118.243])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2023 07:07:16 -0700
Message-ID: <747dca0b-7e79-738a-c622-3e2df61849ca@linux.intel.com>
Date:   Mon, 17 Jul 2023 07:07:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 3/4] intel_idle: Add support for using intel_idle in a VM
 guest using just hlt
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>, linux-pm@vger.kernel.org
Cc:     artem.bityutskiy@linux.intel.com, rafael@kernel.org,
        kvm <kvm@vger.kernel.org>, Dan Wu <dan1.wu@intel.com>
References: <20230605154716.840930-1-arjan@linux.intel.com>
 <20230605154716.840930-4-arjan@linux.intel.com>
 <5c7de6d5-7706-c4a5-7c41-146db1269aff@intel.com>
From:   Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <5c7de6d5-7706-c4a5-7c41-146db1269aff@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> It leads to below MSR access error on SPR.
yeah I have a fix for this but Peter instead wants to delete the whole thing...
... so I'm sort of stuck in two worlds. I'll send the fix today but Rafael will need to
chose if he wants to revert or not


