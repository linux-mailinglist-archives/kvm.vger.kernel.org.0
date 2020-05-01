Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6964F1C114C
	for <lists+kvm@lfdr.de>; Fri,  1 May 2020 13:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728573AbgEALBC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 May 2020 07:01:02 -0400
Received: from mga18.intel.com ([134.134.136.126]:17502 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728480AbgEALBC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 May 2020 07:01:02 -0400
IronPort-SDR: BAAmdjLwB/3zBJWsQVSBKntfL0jO/7kp2/BYcjWSrYJq0UT10HNakLVlKVSyf3H+LBckqi6Zzn
 o3FRHM4EUXJw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2020 04:01:01 -0700
IronPort-SDR: 7thJX6Mk0VKlOqLk4+hB4Kpm2nsLgUTfJ8kc6DOkHWiWyxqjaCETOzZ1vx4VCCUY7rlBQXfXJV
 lNMlFXnL9Kqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,339,1583222400"; 
   d="scan'208";a="368415955"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 01 May 2020 04:00:58 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jUTPe-0003D5-8P; Fri, 01 May 2020 19:00:58 +0800
Date:   Fri, 1 May 2020 19:00:36 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com
Cc:     kbuild-all@lists.01.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 10/18] x86/paravirt: Add hypervisor specific hypercall
 for SEV live migration.
Message-ID: <202005011844.3MBRacmG%lkp@intel.com>
References: <d0e5e3227e24272ec5f277e6732c5e0a1276d4e1.1588234824.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0e5e3227e24272ec5f277e6732c5e0a1276d4e1.1588234824.git.ashish.kalra@amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ashish,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on v5.7-rc3]
[cannot apply to kvm/linux-next tip/x86/mm tip/x86/core next-20200501]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Ashish-Kalra/Add-AMD-SEV-guest-live-migration-support/20200430-202702
base:    6a8b55ed4056ea5559ebe4f6a4b247f627870d4c
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-191-gc51a0382-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag as appropriate
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> arch/x86/kernel/kvm.c:733:6: sparse: sparse: symbol 'kvm_sev_migration_hcall' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
