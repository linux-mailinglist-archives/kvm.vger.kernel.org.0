Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8090D39253A
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 05:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234421AbhE0DJZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 23:09:25 -0400
Received: from mga03.intel.com ([134.134.136.65]:61216 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232725AbhE0DJY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 23:09:24 -0400
IronPort-SDR: RpR4kgUGsNKc36Mb101THhMHJig94eh2ncZ+KkYdcOvERqXZQdCB+YFNV/nNW+Veo+uEyHOCTb
 tnWdRNgbaNsA==
X-IronPort-AV: E=McAfee;i="6200,9189,9996"; a="202670650"
X-IronPort-AV: E=Sophos;i="5.82,333,1613462400"; 
   d="scan'208";a="202670650"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 20:07:50 -0700
IronPort-SDR: AITx/xKyIRYiWp3ViftoHT6HhB7da14kz2E3t6JcsCM0h5a/FBXlJHtYjxuZIX+fXHvZ+SlQqP
 awMr7SZJFmBA==
X-IronPort-AV: E=Sophos;i="5.82,333,1613462400"; 
   d="scan'208";a="444401399"
Received: from shao2-debian.sh.intel.com (HELO localhost) ([10.239.13.11])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 20:07:48 -0700
Date:   Thu, 27 May 2021 11:06:33 +0800
From:   kernel test robot <rong.a.chen@intel.com>
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Steve Rutherford <srutherford@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [kvm:master 125/130] Warning: Kernel ABI header at
 'tools/include/uapi/linux/kvm.h' differs from latest version at
 'include/uapi/linux/kvm.h': 1086> #define KVM_CAP_EXIT_HYPERCALL 199
Message-ID: <20210527030633.GW2687475@shao2-debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git master
head:   f7d7a93c553f6242b1732b64edc8120c7a061b78
commit: 824d9fb23eb5f359c4da99023c1a2ced05b5911c [125/130] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce:
cd tools/perf && ./check-headers.sh

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


perfheadercheck warnings: (new ones prefixed by >>)
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1082> #define KVM_CAP_SET_GUEST_DEBUG2 195
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1083> #define KVM_CAP_SGX_ATTRIBUTE 196
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1084> #define KVM_CAP_VM_COPY_ENC_CONTEXT_FROM 197
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1085> #define KVM_CAP_PTP_KVM 198
>> Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1086> #define KVM_CAP_EXIT_HYPERCALL 199
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1680> 	/* Guest Migration Extension */
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1681> 	KVM_SEV_SEND_CANCEL,
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1738> };
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1739> 
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1740> struct kvm_sev_send_start {
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1741> 	__u32 policy;
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1742> 	__u64 pdh_cert_uaddr;
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1743> 	__u32 pdh_cert_len;
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1744> 	__u64 plat_certs_uaddr;
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1745> 	__u32 plat_certs_len;
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1746> 	__u64 amd_certs_uaddr;
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1747> 	__u32 amd_certs_len;
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1748> 	__u64 session_uaddr;
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1749> 	__u32 session_len;
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1750> };
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1751> 
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1752> struct kvm_sev_send_update_data {
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1753> 	__u64 hdr_uaddr;
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1754> 	__u32 hdr_len;
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1755> 	__u64 guest_uaddr;
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1756> 	__u32 guest_len;
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1757> 	__u64 trans_uaddr;
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1758> 	__u32 trans_len;
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1759> };
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1760> 
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1761> struct kvm_sev_receive_start {
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1762> 	__u32 handle;
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1763> 	__u32 policy;
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1764> 	__u64 pdh_uaddr;
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1765> 	__u32 pdh_len;
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1766> 	__u64 session_uaddr;
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1767> 	__u32 session_len;
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1768> };
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1769> 
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1770> struct kvm_sev_receive_update_data {
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1771> 	__u64 hdr_uaddr;
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1772> 	__u32 hdr_len;
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1773> 	__u64 guest_uaddr;
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1774> 	__u32 guest_len;
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1775> 	__u64 trans_uaddr;
   Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h': 1776> 	__u32 trans_len;

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
