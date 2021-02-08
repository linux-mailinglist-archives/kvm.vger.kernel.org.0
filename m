Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C360E313567
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 15:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbhBHOlR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 09:41:17 -0500
Received: from mga11.intel.com ([192.55.52.93]:61192 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232439AbhBHOkm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 09:40:42 -0500
IronPort-SDR: tNyJIgIVR+VX18xjHdx73puT6Iygm8Zx10VWMoXsyjAqcA5w7YgsItSzcPP3dzK50bN0w3nUiH
 xOqYVd+/pDpQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9888"; a="178211757"
X-IronPort-AV: E=Sophos;i="5.81,162,1610438400"; 
   d="scan'208";a="178211757"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 06:39:53 -0800
IronPort-SDR: ZrKZBrXOxcSWHxEj0VJJfEupBu4xA/gOxpJLJ61VTg4gGKAkus1ehiBwHFjRcR6Q7lfqVBWbYT
 2GiLvT/hqZdw==
X-IronPort-AV: E=Sophos;i="5.81,162,1610438400"; 
   d="scan'208";a="377796548"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.254.208.110]) ([10.254.208.110])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 06:39:48 -0800
Subject: Re: [RFC PATCH v4 15/26] KVM: VMX: Convert vcpu_vmx.exit_reason to a
 union
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com, isaku.yamahata@intel.com
References: <cover.1612777752.git.kai.huang@intel.com>
 <0daea2891388cd30097cc62a7a5644b321ae80a5.1612777752.git.kai.huang@intel.com>
 <20210209001132.426f38085622c7e3684dbb8d@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <5ea4ba08-b4e7-d502-13b3-ce520013f8a9@intel.com>
Date:   Mon, 8 Feb 2021 22:39:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210209001132.426f38085622c7e3684dbb8d@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/8/2021 7:11 PM, Kai Huang wrote:
> Hi Paolo,
> 
> Although this series was sent as RFC, would you consider reviewing and merging
> this patch from Sean? Intel TDX support (already sent by Isaku as RFC) has
> conflict with this one, and I am expecting other features might also conflict
> with it too.
> 

I see this patch is already queued with Bus Lock VM exit series.

