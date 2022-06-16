Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35AE354ED9F
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 00:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379199AbiFPWuD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 18:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379191AbiFPWuC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 18:50:02 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A7562A0C;
        Thu, 16 Jun 2022 15:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655419799; x=1686955799;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8qfN0cPOq5fEijOKk+8WWad/nYwTM5tZ5iX/bnB6v3k=;
  b=mRyZPEvVCP/xHg024K/nxg3mC6316o56a7KVxHYhSnuVRKIcjZsQcByw
   otYHrd5sa1xMdYCFEEVTsDUzF/PH3ozGNqGZgHiA8P+FvkMSZo+m9Ub0I
   /luy3Q3px7x+eCmcjpK0HLZ9gdQJMzVibTJkqKvmfkh1OMPHHbBcZl7MV
   ICLX2oxv0OoNmpe/4DN9RPIlcrlAI2qBXh8p3wcFlg70j8zpJ+CAAAd42
   4otSTx+8vOfjZ+5HynSB+ffHbrdaWMX8/1SL5McBfTcH1c5BheUsREuhT
   IfYJJCg1Hmm02qGlz72T1Z0VbV0ALrIZIyf0TNN5Mx5AIm9LJeCx8BOff
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="280083256"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="280083256"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 15:49:58 -0700
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="536618921"
Received: from krfox2-mobl.amr.corp.intel.com (HELO [10.209.46.80]) ([10.209.46.80])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 15:49:58 -0700
Message-ID: <a32831e7-5e01-db1a-ef89-cc5e1479299f@intel.com>
Date:   Thu, 16 Jun 2022 15:49:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 2/2] Documentation/x86: Explain guest XSTATE permission
 control
Content-Language: en-US
To:     "Chang S. Bae" <chang.seok.bae@intel.com>, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com
Cc:     corbet@lwn.net, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220616212210.3182-1-chang.seok.bae@intel.com>
 <20220616212210.3182-3-chang.seok.bae@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20220616212210.3182-3-chang.seok.bae@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/16/22 14:22, Chang S. Bae wrote:
> +In addition, a couple of extended options are provided for a VCPU thread.
> +The VCPU XSTATE permission is separately controlled.
> +
> +-ARCH_GET_XCOMP_GUEST_PERM
> +
> + arch_prctl(ARCH_GET_XCOMP_GUEST_PERM, &features);
> +
> + ARCH_GET_XCOMP_GUEST_PERM is a variant of ARCH_GET_XCOMP_PERM. So it
> + provides the same semantics and functionality but for VCPU.

This touches on the "what", but not the "why".  Could you explain in
here both why this is needed and why an app might want to use it?
