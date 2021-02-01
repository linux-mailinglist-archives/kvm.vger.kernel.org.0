Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B06D0309FA4
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 01:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhBAAMF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Jan 2021 19:12:05 -0500
Received: from mga07.intel.com ([134.134.136.100]:5866 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229495AbhBAAMA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Jan 2021 19:12:00 -0500
IronPort-SDR: ggEyl7CuvcEZAoyv4E419qNo/fl+IxQW5BCnS/z9rYrNKPgM4DckaEO/z/s2qRu/0LkIaYD4qo
 MG1Db7wpy5IA==
X-IronPort-AV: E=McAfee;i="6000,8403,9881"; a="244699372"
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="244699372"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2021 16:11:16 -0800
IronPort-SDR: XdK+T1rX5uykI8XzOqpKn9IA12iCjHerhjhOqtPwzpRcU3QEYMhwgP4tKEWyH/9jZ0v6/UJDHR
 CXsxytfKV2uQ==
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="405399025"
Received: from kpeng-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.130.129])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2021 16:11:12 -0800
Date:   Mon, 1 Feb 2021 13:11:10 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, <linux-sgx@vger.kernel.org>,
        <kvm@vger.kernel.org>, <x86@kernel.org>, <seanjc@google.com>,
        <jarkko@kernel.org>, <luto@kernel.org>, <haitao.huang@intel.com>,
        <pbonzini@redhat.com>, <bp@alien8.de>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <hpa@zytor.com>
Subject: Re: [RFC PATCH v3 03/27] x86/sgx: Remove a warn from
 sgx_free_epc_page()
Message-Id: <20210201131110.d1425c4d0db46fb895bde10f@intel.com>
In-Reply-To: <20210127142652.b9d181813b10f8660d0df664@intel.com>
References: <cover.1611634586.git.kai.huang@intel.com>
        <36e999dce8a1a4efb8ca69c9a6fbe3fa63305e08.1611634586.git.kai.huang@intel.com>
        <d09b8b34-6e8c-5323-e155-f45da5abb48b@intel.com>
        <6e859dc6610d317f09663a4ce76b7e13fc0c0f8e.camel@intel.com>
        <15dda40e-5875-aaa9-acbb-7d868a13f982@intel.com>
        <20210127142652.b9d181813b10f8660d0df664@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 27 Jan 2021 14:26:52 +1300 Kai Huang wrote:
> On Tue, 26 Jan 2021 17:12:12 -0800 Dave Hansen wrote:
> > On 1/26/21 5:08 PM, Kai Huang wrote:
> > > I don't have deep understanding of SGX driver. Would you help to answer?
> > 
> > Kai, as the patch submitter, you are expected to be able to at least
> > minimally explain what the patch is doing.  Please endeavor to obtain
> > this understanding before sending patches in the future.
> 
> I see. Thanks.

Hi Jarkko,

I think I'll remove this patch in next version, since it is not related to KVM
SGX. And I'll rebase your second patch based on current tip/x86/sgx. You may
send out this patch independently. Let me know if you have comment.
