Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 789C556B03C
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 03:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235956AbiGHBxy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 21:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiGHBxx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 21:53:53 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0683B72EFD;
        Thu,  7 Jul 2022 18:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657245233; x=1688781233;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=uTGZ96H/Vcyezi1QcFNAgzqip6ZdDz289/RtCx8IjWQ=;
  b=J3zUVe0xBTioYG+PcBp0SH21Bc9nzDf6pjqGJ26Jx4c7/Qs48DaFCCqV
   McWWsVYwkdB/Z8o6hsDbsysEjux9IDwyDBks7zgdNmPfGBG+7HVa3AQe/
   3MQltKPvEsy8Jx7xLLFolJkH2x/E6MUuwn4uUkW7HvknqPd0sDmmzAsz8
   NDCMXu0DoQJA1l78CsoVb9io80mie9goQxuOmRHiqirlryc5Hc66QUmSx
   lCpWLzektH2HmkiEnVDT1zMF4NexJAZexv8qgKan7x6WZksLpbucS7eBe
   06PVHsO4KC9VjFA8xVFX13RpP8CVaKaJMRH3ktxFKKvCx+EiXpWB7fKP7
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10401"; a="285292629"
X-IronPort-AV: E=Sophos;i="5.92,254,1650956400"; 
   d="scan'208";a="285292629"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 18:53:52 -0700
X-IronPort-AV: E=Sophos;i="5.92,254,1650956400"; 
   d="scan'208";a="840136748"
Received: from pantones-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.54.208])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 18:53:50 -0700
Message-ID: <873d12c1ebe3a64e3f11133308df064f2b581d8e.camel@intel.com>
Subject: Re: [PATCH v7 032/102] KVM: x86/mmu: introduce config for PRIVATE
 KVM MMU
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>
Date:   Fri, 08 Jul 2022 13:53:48 +1200
In-Reply-To: <fa5a472216f0394fab06e2fee29d42fdc1ed33af.1656366338.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <fa5a472216f0394fab06e2fee29d42fdc1ed33af.1656366338.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>=20
> To Keep the case of non TDX intact, introduce a new config option for
> private KVM MMU support.  At the moment, this is synonym for
> CONFIG_INTEL_TDX_HOST && CONFIG_KVM_INTEL.  The new flag make it clear
> that the config is only for x86 KVM MMU.

What is the "new flag"?

>=20
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/Kconfig | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index e3cbd7706136..5a59abc83179 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -129,4 +129,8 @@ config KVM_XEN
>  config KVM_EXTERNAL_WRITE_TRACKING
>  	bool
> =20
> +config KVM_MMU_PRIVATE
> +	def_bool y
> +	depends on INTEL_TDX_HOST && KVM_INTEL
> +
>  endif # VIRTUALIZATION

