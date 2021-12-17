Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F38247880D
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 10:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234147AbhLQJsk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 04:48:40 -0500
Received: from mga05.intel.com ([192.55.52.43]:19949 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233096AbhLQJsj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 04:48:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639734519; x=1671270519;
  h=to:cc:from:subject:message-id:date:mime-version:
   content-transfer-encoding;
  bh=pmQGdwTEQmU04w91tsawa6Fg0wFYFFUuoqMSq/MrTzQ=;
  b=N/7n7oLkdlHLsje7HliS7HMwROgHyaT5tTJBPg14uXr5xLFfINdyDAV6
   J1jZA0d8NCwqHNod3rUKAW8jOwBdFuICJ5I1uciahPF14ZQv2p1fRqlz8
   Cj3DduOr7ZdbR5nZCJNg9kfKCM9WdNwoNqBJ8e1XYlxzNdw9iFQQfH4cm
   VwUD6ecGQkOoUnDv5eIVBzV4A/vBHdQfXni44lSszRPa0J6QmY4IG321Y
   5QAmzg674xBdQgaqbDxBwvfjTjA8f1AVkrFDXF5t73w/OfCpwW0nTd6BD
   dNfsiTBnW0Eeexn2NNIm/xEqQCaMQn81XGE1hSu147R4Hjr6IPmsN3THK
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="326010045"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="326010045"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 01:48:39 -0800
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="506705446"
Received: from zhengmia-mobl.ccr.corp.intel.com (HELO [10.255.31.240]) ([10.255.31.240])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 01:48:37 -0800
To:     jmattson@google.com
Cc:     ehankland@google.com, kvm@vger.kernel.org, pbonzini@redhat.com,
        Philip Li <philip.li@intel.com>
From:   Ma Xinjian <xinjianx.ma@intel.com>
Subject: Re: [kvm-unit-tests PATCH] x86/pmu: Test PMU virtualization on
 emulated instructions
Message-ID: <a2cc8bd6-df74-95a7-f3a2-6ff6407a5543@intel.com>
Date:   Fri, 17 Dec 2021 17:47:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Jim

I am from Intel LKP team, we noticed that pmu_emulation was new added 
recently by you.

We tested it and finished with 2 unexpected failures

```

timeout -k 1s --foreground 90s /usr/bin/qemu-system-x86_64 --no-reboot 
-nodefaults -device pc-testdev -device 
isa-debug-exit,iobase=0xf4,iosize=0x4 -vnc none -serial stdio -device 
pci-testdev -machine accel=kvm -kernel x86/pmu.flat -smp 1 -cpu max 
-append emulation # -initrd /tmp/tmp.Y0jCDA5Jlw
enabling apic
paging enabled
cr0 = 80010011
cr3 = 1007000
cr4 = 20
PMU version:         2
GP counters:         4
GP counter width:    48
Mask length:         7
Fixed counters:      3
Fixed counter width: 48
PASS: emulated instruction: instruction count
PASS: emulated instruction: branch count
FAIL: emulated instruction: instruction counter overflow
FAIL: emulated instruction: branch counter overflow
SUMMARY: 4 tests, 2 unexpected failures

```

we have tried on kernel v5.15 v5.16-rc5

on 2 different machine

machine 1:

```

model: Haswell
cpu: 8
memory: 16G
brand: Intel(R) Core(TM) i7-4790T CPU @ 2.70GH

```

machine2:

```

model: Ice Lake
cpu: 96
memory: 256G
kernel_cmdline_hw: acpi_rsdp=0x667fd014
rootfs_partition: 
/dev/disk/by-id/ata-INTEL_SSDSC2BB800G4_PHWL4204005K800RGN-part3

```

If you confirm and fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


Thanks

Ma Xinjian

