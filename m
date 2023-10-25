Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3602E7D64A4
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 10:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233757AbjJYILo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 04:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233865AbjJYILm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 04:11:42 -0400
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 25 Oct 2023 01:11:39 PDT
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E430A18E
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 01:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698221500; x=1729757500;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=AhaeKMDNwHqScAHYtVYxZLMzslvCZAv2P4CFwMLMaJ8=;
  b=nSvk8wVw+NUtAS69ldayeDv/q3ZP0Jpe4E4WtkGa2KJGDDTwnymR9Qy3
   pfrqcOToFCht69GePI4Q2wkCyfqypx3Fo+aUxD1I8D950wgep7DtcpBnn
   5DbmJ50cY/TY0KuIvWQYFOxg2LNKzrABgeoWF7eeUpYkAtUurxe9w0J4/
   /Kg68uJxaJjUFi9o0WkxeVwLx7kPNt3fDFhLZkCCi/4E0CBs+e+jzGVm5
   ZKM33LrbbhVWljFqH45KSTdcuyiOZMACAi6fKsuaLxGZL6TcEgvQOFff2
   e2GPCeyM+WtQggYz0QZCDB8kXhFCgqPXXkHQ8jrtHiQcBQjYJJ9nwyd7k
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="18211"
X-IronPort-AV: E=Sophos;i="6.03,250,1694761200"; 
   d="scan'208";a="18211"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 01:10:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="882376636"
X-IronPort-AV: E=Sophos;i="6.03,250,1694761200"; 
   d="scan'208";a="882376636"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orsmga004.jf.intel.com with ESMTP; 25 Oct 2023 01:10:28 -0700
Date:   Wed, 25 Oct 2023 16:22:07 +0800
From:   Zhao Liu <zhao1.liu@linux.intel.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Zhenyu Wang <zhenyu.z.wang@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Babu Moger <babu.moger@amd.com>,
        Yongwei Ma <yongwei.ma@intel.com>,
        Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v5 02/20] tests: Rename test-x86-cpuid.c to
 test-x86-topo.c
Message-ID: <ZTjQLxBjJOiV1Wt2@intel.com>
References: <20231024090323.1859210-1-zhao1.liu@linux.intel.com>
 <20231024090323.1859210-3-zhao1.liu@linux.intel.com>
 <88dce00d-20ed-4219-8b4b-1ac0dd30a514@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <88dce00d-20ed-4219-8b4b-1ac0dd30a514@redhat.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 24, 2023 at 11:09:34AM +0200, Thomas Huth wrote:
> Date: Tue, 24 Oct 2023 11:09:34 +0200
> From: Thomas Huth <thuth@redhat.com>
> Subject: Re: [PATCH v5 02/20] tests: Rename test-x86-cpuid.c to
>  test-x86-topo.c
> 
> On 24/10/2023 11.03, Zhao Liu wrote:
> > From: Zhao Liu <zhao1.liu@intel.com>
> > 
> > The tests in this file actually test the APIC ID combinations.
> > Rename to test-x86-topo.c to make its name more in line with its
> > actual content.
> > 
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> > Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> > Tested-by: Babu Moger <babu.moger@amd.com>
> > Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> > Acked-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> 
> Reviewed-by: Thomas Huth <thuth@redhat.com> 

Thanks!

-Zhao
