Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAEF65A15FB
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 17:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242812AbiHYPoX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 11:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237660AbiHYPoW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 11:44:22 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D7B5A895C;
        Thu, 25 Aug 2022 08:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661442261; x=1692978261;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mD/SXcX1eKcumkkkppJMFFQVef9qXaiaDolZPsdaysM=;
  b=fzrgzys6E0Drksen76pwRlpQH51wRmVx6H39wn45Qa22laWy3Dp/YcrH
   X235qS3zrziZ6vgQobJdE45F0EjfRJWz2jM0TKlJsj2A4g6dyDUCHOe+Q
   ZzJSjS3la4ZLDrFOIEQts9W8dkxHJhxs9ooIfsvjkn8gm79gNGiT4auOF
   YHDnwal67AjDWFjczvVzL8JN4Z+k/Qsr48KkrxP3GhD8HjHGE72z/T+x6
   +jXCnMt9LmyVODAY8J0VpAqAovoQoqaKOdpO1dl4Et9Kl3Ngykiku6mrU
   jRsygsLf37Rr7QnLMJ4PGSZb2jBeBd5jlOPyDAbv0u1HCGEtnQMpvNgiG
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10450"; a="295551020"
X-IronPort-AV: E=Sophos;i="5.93,263,1654585200"; 
   d="scan'208";a="295551020"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 08:44:21 -0700
X-IronPort-AV: E=Sophos;i="5.93,263,1654585200"; 
   d="scan'208";a="752529341"
Received: from manjeets-mobl.amr.corp.intel.com (HELO [10.212.220.1]) ([10.212.220.1])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 08:44:20 -0700
Message-ID: <236e5130-ec29-e99d-a368-3323a5f6f741@intel.com>
Date:   Thu, 25 Aug 2022 08:44:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] x86/sgx: Allow exposing EDECCSSA user leaf function to
 KVM guest
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Kai Huang <kai.huang@intel.com>, dave.hansen@linux.intel.com,
        linux-sgx@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        haitao.huang@linux.intel.com
References: <20220818023829.1250080-1-kai.huang@intel.com>
 <YwbrywL9S+XlPzaX@kernel.org> <YweS9QRqaOgH7pNW@google.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <YweS9QRqaOgH7pNW@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/25/22 08:19, Sean Christopherson wrote:
>>> This patch, along with your patch to expose AEX-notify attribute bit to
>>> guest, have been tested that both AEX-notify and EDECCSSA work in the VM.
>>> Feel free to merge this patch.
> Dave, any objection to taking this through the KVM tree?

This specific patch?  Or are you talking about the couple of AEX-notify
patches in their entirety?
