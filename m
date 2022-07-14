Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 911CA574898
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 11:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238124AbiGNJWy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 05:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237834AbiGNJWf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 05:22:35 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B1C13D5D;
        Thu, 14 Jul 2022 02:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657790430; x=1689326430;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Hxg4gO6Jxz/Xms9zjmnevBwshVx92baqpiGUsry7Yz0=;
  b=kZZpCx0lIaIaM5yKJ7PSt7o8UXqJQKQtuyszEhfK7pjPofmsfo1So9lw
   w6V2kVShM3QbYpJKAkMRhsqVZxSy1SBQQvuCMuJhDf2rJvGUJBs4wsaC6
   +vh9GpBylNiMeFs1F5DzJz8yfohKs+pLLUC/6hZ+n13Ti90IBQtpYprnE
   0GaKJNGY8zfQ2rMk1Dkh8rp2WAFDfoIaLB39O0BlQUbDK+V2Dm4cWcjwX
   uQzyJjInG1F+UC+qure9MAGFJkdHLcD6b3Xd6V9ylbVHhXyHksrW7SBFV
   pfGpVehn872LDCNSxJdnOBqxITBkhAksu9ybqiRAADZEr3Tn80t04544B
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10407"; a="349429849"
X-IronPort-AV: E=Sophos;i="5.92,269,1650956400"; 
   d="scan'208";a="349429849"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 02:20:30 -0700
X-IronPort-AV: E=Sophos;i="5.92,269,1650956400"; 
   d="scan'208";a="593307408"
Received: from wmoyer-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.86.31])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 02:20:27 -0700
Message-ID: <2802b8c36ad3741701e04ec5f52d2e9b849a90e3.camel@intel.com>
Subject: Re: [PATCH v4 07/25] KVM: selftests: Add
 ENCLS_EXITING_BITMAP{,HIGH} VMCS fields
From:   Kai Huang <kai.huang@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 14 Jul 2022 21:20:25 +1200
In-Reply-To: <20220714091327.1085353-8-vkuznets@redhat.com>
References: <20220714091327.1085353-1-vkuznets@redhat.com>
         <20220714091327.1085353-8-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-07-14 at 11:13 +0200, Vitaly Kuznetsov wrote:
> The updated Enlightened VMCS definition has 'encls_exiting_bitmap'
> field which needs mapping to VMCS, add the missing encoding.
>=20
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  tools/testing/selftests/kvm/include/x86_64/vmx.h | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/tes=
ting/selftests/kvm/include/x86_64/vmx.h
> index cc3604f8f1d3..5292d30fb7f2 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
> @@ -208,6 +208,8 @@ enum vmcs_field {
>  	VMWRITE_BITMAP_HIGH		=3D 0x00002029,
>  	XSS_EXIT_BITMAP			=3D 0x0000202C,
>  	XSS_EXIT_BITMAP_HIGH		=3D 0x0000202D,
> +	ENCLS_EXITING_BITMAP		=3D 0x0000202E,
> +	ENCLS_EXITING_BITMAP_HIGH	=3D 0x0000202F,
>  	TSC_MULTIPLIER			=3D 0x00002032,
>  	TSC_MULTIPLIER_HIGH		=3D 0x00002033,
>  	GUEST_PHYSICAL_ADDRESS		=3D 0x00002400,

Reviewed-by: Kai Huang <kai.huang@intel.com>

--=20
Thanks,
-Kai


