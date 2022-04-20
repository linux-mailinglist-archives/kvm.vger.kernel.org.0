Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E0C5092C7
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 00:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354750AbiDTW36 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 18:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234341AbiDTW3z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 18:29:55 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F078D4161D;
        Wed, 20 Apr 2022 15:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650493627; x=1682029627;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=A2O1YZNwDXPeLR8zRSvDExA92v55HoV7LJ+7XASFh1o=;
  b=XrnmN1MIymHkcZ/8l8F7n8/OmLIN7Y++FLwnxa0o53KZOZ5dJxbfLsTQ
   8bE2zSwi3koowr+mi8qqUV+KNzccfDofciPT8in+rOdG48Pv2VVoAvbAx
   ZknaP+dL5t3htWNXzN6jDUEOy1bwZg4bZQQYZRereAT9YP/poxryVBxQd
   EurJ8gergZ6H6tmj59WfSHewcByj1UQJyVX1DGuiyVnwVoeaizubK8KkB
   qeEYF3vPutbhhmnqO70Em+IPmYlObVswkyikQqxnxroL2oxISQos8Z5d1
   1Hc+HCMEUgCSchLENbUduMlx08VKF1PYgY5UzpfiZ4XJeeNS0Q1wVs28J
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="244750953"
X-IronPort-AV: E=Sophos;i="5.90,276,1643702400"; 
   d="scan'208";a="244750953"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 15:27:07 -0700
X-IronPort-AV: E=Sophos;i="5.90,276,1643702400"; 
   d="scan'208";a="593364937"
Received: from dmertma-mobl4.amr.corp.intel.com (HELO [10.209.83.57]) ([10.209.83.57])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 15:27:06 -0700
Message-ID: <1597240f-af03-66c7-a25f-872b2601554e@linux.intel.com>
Date:   Wed, 20 Apr 2022 15:27:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH v3 07/21] x86/virt/tdx: Do TDX module global
 initialization
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com, isaku.yamahata@intel.com
References: <cover.1649219184.git.kai.huang@intel.com>
 <66e6aa1dc1bade544b81120d7976cb0601f0528b.1649219184.git.kai.huang@intel.com>
From:   Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <66e6aa1dc1bade544b81120d7976cb0601f0528b.1649219184.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/5/22 9:49 PM, Kai Huang wrote:
> Do the TDX module global initialization which requires calling
> TDH.SYS.INIT once on any logical cpu.

IMO, you could add some more background details to this commit log. Like
why you are doing it and what it does?. I know that you already 
explained some background in previous patches. But including brief
details here will help to review the commit without checking the
previous commits.

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
