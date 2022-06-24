Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1AC55A1AB
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 21:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbiFXS6e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 14:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231690AbiFXS6b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 14:58:31 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7AB2656;
        Fri, 24 Jun 2022 11:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656097084; x=1687633084;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XBbME1oeuKj97S6OdL7ubRRQgcB84W95SpJxy8wliwc=;
  b=TiStzioEB/eB1+jGTOshxx1N55DM0wOO8Bkv3eu3bRJ/PNGTkUS/5DGh
   MXIk0bHAJ5bDQ518qpZDx/V6FRoEQ0K6E4TzNvX1PY8TPoEK4dXP7kmiH
   6HXNgft+uow3V8y/FOakM/FQOA5uz4jjhyxGBsWau7gBOEzEuetuacFJh
   tT/kuGsoLGqmfXnnDPUtrvdFNMRp+tWt8FGhe66AGOIsgXtE4Yb7OQPnZ
   IyNFxt00aUexBSgIlJEeuNjPvl0yANJWuvJfvqAH2QJzfYUye9Sf8eNgJ
   Lq4zOORcmWJTwxrlHkN2+xLeFOukrBbq2Cri3AARccKNuZl1CqHFji4aM
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10388"; a="279830715"
X-IronPort-AV: E=Sophos;i="5.92,220,1650956400"; 
   d="scan'208";a="279830715"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 11:57:57 -0700
X-IronPort-AV: E=Sophos;i="5.92,220,1650956400"; 
   d="scan'208";a="731431403"
Received: from mdedeogl-mobl.amr.corp.intel.com (HELO [10.209.126.186]) ([10.209.126.186])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 11:57:55 -0700
Message-ID: <43a67bfe-9707-33e0-2574-1e6eca6aa24b@intel.com>
Date:   Fri, 24 Jun 2022 11:57:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v5 02/22] cc_platform: Add new attribute to prevent ACPI
 CPU hotplug
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-acpi@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, thomas.lendacky@amd.com,
        Tianyu.Lan@microsoft.com, rdunlap@infradead.org, Jason@zx2c4.com,
        juri.lelli@redhat.com, mark.rutland@arm.com, frederic@kernel.org,
        yuehaibing@huawei.com, dongli.zhang@oracle.com
References: <cover.1655894131.git.kai.huang@intel.com>
 <f4bff93d83814ea1f54494f51ce3e5d954cf0f5b.1655894131.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <f4bff93d83814ea1f54494f51ce3e5d954cf0f5b.1655894131.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/22/22 04:15, Kai Huang wrote:
> Platforms with confidential computing technology may not support ACPI
> CPU hotplug when such technology is enabled by the BIOS.  Examples
> include Intel platforms which support Intel Trust Domain Extensions
> (TDX).
> 
> If the kernel ever receives ACPI CPU hotplug event, it is likely a BIOS
> bug.  For ACPI CPU hot-add, the kernel should speak out this is a BIOS
> bug and reject the new CPU.  For hot-removal, for simplicity just assume
> the kernel cannot continue to work normally, and BUG().

So, the kernel is now declaring ACPI CPU hotplug and TDX to be
incompatible and even BUG()'ing if we see them together.  Has anyone
told the firmware guys about this?  Is this in a spec somewhere?  When
the kernel goes boom, are the firmware folks going to cry "Kernel bug!!"?

This doesn't seem like something the kernel should be doing unilaterally.
