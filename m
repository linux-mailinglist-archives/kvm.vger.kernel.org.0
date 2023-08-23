Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0EEF7860D5
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 21:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238355AbjHWTlq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 15:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238369AbjHWTlR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 15:41:17 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1BE10D1
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 12:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692819675; x=1724355675;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=P59MjrtYNEHf8YGIJC1rp3m+pnMyDANkBTYFwlk6olQ=;
  b=iGH4j9sllm1oTKjvSEk59Hg5ZT/p/fREEL8CKYwTXnbA3IW/ep5XMvsG
   Zr+wFekOrSBDYcUiCTvAct+y/6wZI8dqyNyCboB3zswuVx5w0rRJ7jkWE
   VSLcKEQ5CfKy2ns7UpZfk6JEbz7WBBQJwEuEzF+Yn3Wuv0U7zVTLdOgOf
   +s+2xLLXnsgQ8lYl/XAvrs4L1xQ0ZEZqcWcmOesqVK/kCs2iirIPQuv+r
   ynmDiRb8ZjrJPPlVCarp0V5H1rtEUWcniJgQb9hdvH/6BhbBOlvV7CvAN
   WnA39gqHose2XztKjo/Q7cPuXNbxyj8Amwzbg3e+IRJOWmhEltDZhQZce
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="373141345"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="373141345"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2023 12:41:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="713702594"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="713702594"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2023 12:41:14 -0700
Date:   Wed, 23 Aug 2023 12:41:14 -0700
From:   Isaku Yamahata <isaku.yamahata@linux.intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com, Chenyi Qiang <chenyi.qiang@intel.com>,
        isaku.yamahata@linux.intel.com, isaku.yamahata@intel.com
Subject: Re: [PATCH v2 33/58] headers: Add definitions from UEFI spec for
 volumes, resources, etc...
Message-ID: <20230823194114.GE3642077@ls.amr.corp.intel.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-34-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230818095041.1973309-34-xiaoyao.li@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 18, 2023 at 05:50:16AM -0400,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> Add UEFI definitions for literals, enums, structs, GUIDs, etc... that
> will be used by TDX to build the UEFI Hand-Off Block (HOB) that is passed
> to the Trusted Domain Virtual Firmware (TDVF).
> 
> All values come from the UEFI specification and TDVF design guide. [1]
> 
> Note, EFI_RESOURCE_MEMORY_UNACCEPTED will be added in future UEFI spec.
> 
> [1] https://software.intel.com/content/dam/develop/external/us/en/documents/tdx-virtual-firmware-design-guide-rev-1.pdf

Nitpick: The specs [1] [2] include unaccepted memory.

[1] UEFI Specification Version 2.10 (released August 2022)
[2] UEFI Platform Initialization Distribution Packaging Specification Version 1.1)
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>
