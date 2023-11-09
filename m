Return-Path: <kvm+bounces-1353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2519E7E6E55
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 17:13:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 52BCA1C20A61
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 16:13:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FD0C219FE;
	Thu,  9 Nov 2023 16:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="djNpsXe8"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE26208DF;
	Thu,  9 Nov 2023 16:13:26 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A35F324A;
	Thu,  9 Nov 2023 08:13:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699546406; x=1731082406;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=wkcdUOlLnNqbWAZ91naJupSPlaSKQ6M7kF1m44fwB6I=;
  b=djNpsXe89Z19CRNwFzWcz69rmXYUwF+Whr16ef7lQKlQNhfhB2faz/3K
   z3FWIvdwo4si4LTnySeDNek/zJpmwcYAGV0Qpx44GTakVP70/p1Wgclcr
   YGW4I2EDBMNsBN7VTdHhg4AQuASk+IlUX88On16FE6v4ODZqe6A82zZt9
   yc/8/Eedh00RBuP/j48VzIhGrLe09jKHk4ZuTypO8OLvNOLw4RMpK29XR
   iF8ASkB67ItTZB9kfBUR/eiA3rAoYtoDfBwbctOK9t5Ll9/VU6PLl1X4o
   MhAqNOFv3cgc+QCR1IiLvgB6XiQzgs0iDkNLxiNEChJrzpajScLOaAQbB
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10889"; a="11562146"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="11562146"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 08:13:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10889"; a="887052432"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="887052432"
Received: from lkp-server01.sh.intel.com (HELO 17d9e85e5079) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 09 Nov 2023 08:13:17 -0800
Received: from kbuild by 17d9e85e5079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1r17ed-0008u2-0E;
	Thu, 09 Nov 2023 16:13:15 +0000
Date: Fri, 10 Nov 2023 00:12:35 +0800
From: kernel test robot <lkp@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	Robert Hu <robert.hu@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Danmei Wei <danmei.wei@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Michael Roth <michael.roth@amd.com>, linux-doc@vger.kernel.org
Subject: [kvm:guestmemfd 27/48] htmldocs:
 Documentation/filesystems/api-summary:74: ./fs/anon_inodes.c:167: WARNING:
 Unexpected indentation.
Message-ID: <202311092342.YM1LxaXz-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git guestmemfd
head:   796edd062c7aeaf9aa58a13f914446cc2282e5a8
commit: 392201e2d6669b4cb2db021c990797ac3f4663c7 [27/48] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing memory
reproduce: (https://download.01.org/0day-ci/archive/20231109/202311092342.YM1LxaXz-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202311092342.YM1LxaXz-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Documentation/filesystems/api-summary:74: ./fs/anon_inodes.c:167: WARNING: Unexpected indentation.
>> Documentation/filesystems/api-summary:74: ./fs/anon_inodes.c:168: WARNING: Block quote ends without a blank line; unexpected unindent.

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

