Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE0217237A2
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 08:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235355AbjFFG0l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 02:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232123AbjFFG0L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 02:26:11 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4404A19B2
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 23:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686032700; x=1717568700;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+spEbOLcJtxUPtov4wbg1Cs7CfTC2WHgW/7bfN0HU60=;
  b=EJQwz4TX/R/XdVSpWxeHFG/UzHT81D1LM75ELQS5bOy7WboK+K0IP8jO
   LhJ5kOIlK1Kzy969VcBJJC3KNVTA5uNz6YdeAvNge6Oqrt73i1WaYMkUo
   YyH3ZV3GD3nN2tV06clRv+3J6PIEOHfnR/CmVxc1BlAlk7rYQ03rhAJNb
   aPXsaqQzMEgm6nRAWu/oyuU9O4NcyBIaFt0iyB1kZfyaUKKqnA7euxb18
   hmX8D53UzulekRFz0JJ7A79GsIVu1cepzsDvNxMoWvvfjhQzRgh1ND3eL
   waGpX5DawywviVdg77vz/2qTdCbXlaj3Igh/vp0dt+g3liFDUpd+HTHZb
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="336936210"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="336936210"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 23:24:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="778856293"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="778856293"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmsmga004.fm.intel.com with ESMTP; 05 Jun 2023 23:24:18 -0700
Date:   Tue, 6 Jun 2023 22:23:44 +0800
From:   Xu Yilun <yilun.xu@intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com
Subject: Re: [PATCH v2 1/3] KVM: Fix comment for KVM_ENABLE_CAP
Message-ID: <ZH9BcFnv9yile92+@yilunxu-OptiPlex-7050>
References: <20230518091339.1102-1-binbin.wu@linux.intel.com>
 <20230518091339.1102-2-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230518091339.1102-2-binbin.wu@linux.intel.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-05-18 at 17:13:37 +0800, Binbin Wu wrote:
> Fix comment for vcpu ioctl version of KVM_ENABLE_CAP.
> 
> KVM provides ioctl KVM_ENABLE_CAP to allow userspace to enable an
> extension which is not enabled by default. For vcpu ioctl version,
> it is available with the capability KVM_CAP_ENABLE_CAP. For vm ioctl
> version, it is available with the capability KVM_CAP_ENABLE_CAP_VM.
> 
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> ---
>  include/uapi/linux/kvm.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 737318b1c1d9..bddf2871db8f 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h

tools/include/uapi/linux/kvm.h also needs the change?

Thanks,
Yilun

> @@ -1613,7 +1613,7 @@ struct kvm_s390_ucas_mapping {
>  #define KVM_GET_DEBUGREGS         _IOR(KVMIO,  0xa1, struct kvm_debugregs)
>  #define KVM_SET_DEBUGREGS         _IOW(KVMIO,  0xa2, struct kvm_debugregs)
>  /*
> - * vcpu version available with KVM_ENABLE_CAP
> + * vcpu version available with KVM_CAP_ENABLE_CAP
>   * vm version available with KVM_CAP_ENABLE_CAP_VM
>   */
>  #define KVM_ENABLE_CAP            _IOW(KVMIO,  0xa3, struct kvm_enable_cap)
> -- 
> 2.25.1
> 
