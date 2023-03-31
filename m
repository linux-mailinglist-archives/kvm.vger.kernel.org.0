Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12A3D6D17E5
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 08:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbjCaG72 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 02:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjCaG70 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 02:59:26 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E296EA5C8;
        Thu, 30 Mar 2023 23:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680245965; x=1711781965;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=B14wSSeuy/BQ80OZrpBUeZ0EHeHcF77aIQAwlArz8sg=;
  b=Q+N6kksvXhC3yMVIJ3i+4Z02vXGEux/8CWZri2F5zCJzk+yCK+kP7o8B
   fvGIY1UEuG3j3VatB+hds8gZ/cSDg0h1gmCmgib6YQ/YeuRJoFGsMrqR1
   Ym44Ibj0JYeCPTdMREL8t1KtUo69jQrjeUWqehdm7gvDtv+SIvfkzg/GQ
   WMUmHgwZaDF3MG0D2AeCRzlsZsRASy3W2+b1G2egK2n0XVqIzLyqevpE6
   KJzWG37Sso44HnO5TwQVPzMjaXzVgBYIHIQ98gt34zRVKfHEQDPe9pC/H
   25lw2E/5aG7nm9Jw8ghNfJ1EZzqW4XaqxYlyLMF/Oe+3OLIflr4CEScre
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="321031999"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="321031999"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 23:59:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="754308888"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="754308888"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.173.97]) ([10.249.173.97])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 23:59:21 -0700
Message-ID: <fc642000-7db8-9944-e57e-db54f0d1336d@intel.com>
Date:   Fri, 31 Mar 2023 14:59:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH v13 016/113] KVM: TDX: x86: Add ioctl to get TDX
 systemwide parameters
Content-Language: en-US
To:     Zhi Wang <zhi.wang.linux@gmail.com>, isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
 <cb0ae8b4941aaa45e1e5856dde644f9b2f53d9a6.1678643052.git.isaku.yamahata@intel.com>
 <20230325104306.00004585@gmail.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20230325104306.00004585@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/25/2023 4:43 PM, Zhi Wang wrote:
> On Sun, 12 Mar 2023 10:55:40 -0700
> isaku.yamahata@intel.com  wrote:
> 
> Does this have to be a new generic ioctl with a dedicated new x86_ops? SNP
> does not use it at all and all the system-scoped ioctl of SNP going through
> the CCP driver. So getting system-scope information of TDX/SNP will end up
> differently.
> 
> Any thought, Sean? Moving getting SNP system-wide information to
> KVM dev ioctl seems not ideal and TDX does not have a dedicated driver like
> CCP. Maybe make this ioctl TDX-specific? KVM_TDX_DEV_OP?

What's the real different of it? For me, it's just renaming 
KVM_MEMORY_ENCRYPT_OP to KVM_TDX_DEV_OP and maybe add some error message 
if the IOCTL is issued for AMD plaform.

