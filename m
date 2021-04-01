Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A84233512A9
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 11:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbhDAJpj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 05:45:39 -0400
Received: from mga05.intel.com ([192.55.52.43]:16502 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233852AbhDAJpb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 05:45:31 -0400
IronPort-SDR: L9P/PWLPD921TjlKKesixATkX+qwTKL3NVun37Yw4Ybgybw/Zd4zM9CNEWyFT1L6MQN0hUWefH
 cJIBpOA7tqXA==
X-IronPort-AV: E=McAfee;i="6000,8403,9940"; a="277394217"
X-IronPort-AV: E=Sophos;i="5.81,296,1610438400"; 
   d="scan'208";a="277394217"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2021 02:45:30 -0700
IronPort-SDR: blAQuc4E3rWTURQ0eEQXFFV0+ZBWAGQGoqNBDIhYSlOdhkdsiBOd6dP5nPkf5LUZw0KAYDU+Hf
 C2qb5BPCe2yg==
X-IronPort-AV: E=Sophos;i="5.81,296,1610438400"; 
   d="scan'208";a="517276254"
Received: from aemorris-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.67.39])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2021 02:45:26 -0700
Date:   Thu, 1 Apr 2021 22:45:24 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Boris Petkov <bp@alien8.de>, <seanjc@google.com>,
        <kvm@vger.kernel.org>, <x86@kernel.org>,
        <linux-sgx@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jarkko@kernel.org>, <luto@kernel.org>, <dave.hansen@intel.com>,
        <rick.p.edgecombe@intel.com>, <haitao.huang@intel.com>,
        <pbonzini@redhat.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>
Subject: Re: [PATCH v3 05/25] x86/sgx: Introduce virtual EPC for use by KVM
 guests
Message-Id: <20210401224524.629afce712a1f012316b6dfc@intel.com>
In-Reply-To: <20210331215345.cad098cfcfcaabf489243807@intel.com>
References: <cover.1616136307.git.kai.huang@intel.com>
        <0c38ced8c8e5a69872db4d6a1c0dabd01e07cad7.1616136308.git.kai.huang@intel.com>
        <20210326150320.GF25229@zn.tnic>
        <20210331141032.db59586da8ba2cccf7b46f77@intel.com>
        <D4ECF8D3-C483-4E75-AD41-2CEFDF56B12D@alien8.de>
        <20210331195138.2af97ec1bb4b5e4202f2600d@intel.com>
        <3889C4C6-48E2-4C97-A074-180EB18BDA29@alien8.de>
        <20210331215345.cad098cfcfcaabf489243807@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 31 Mar 2021 21:53:45 +1300 Kai Huang wrote:
> On Wed, 31 Mar 2021 09:44:39 +0200 Boris Petkov wrote:
> > On March 31, 2021 8:51:38 AM GMT+02:00, Kai Huang <kai.huang@intel.com> wrote:
> > >How about adding explanation to Documentation/x86/sgx.rst?
> > 
> > Sure, and then we should point users at it. The thing is also indexed by search engines so hopefully people will find it.
> 
> Thanks. Will do and send out new patch for review.
> 

Hi Boris,

I have sent out the updated patch, with documentation added. I also added
changelog in the patch. please help to take a look. Thanks!
