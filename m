Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF817352A43
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 13:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235120AbhDBLi3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 07:38:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:61316 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234628AbhDBLi2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Apr 2021 07:38:28 -0400
IronPort-SDR: T56X7hD4/EBh8tjdmJ2VzyC7F1rsUIyNc01AYewbDLNj8s/RUf0ubVG6KOUWGS2t3sBgSUzzyr
 fJY9FMXkvL7A==
X-IronPort-AV: E=McAfee;i="6000,8403,9941"; a="212727542"
X-IronPort-AV: E=Sophos;i="5.81,299,1610438400"; 
   d="scan'208";a="212727542"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2021 04:38:27 -0700
IronPort-SDR: X/oDQjq4eGTRoOXfZKwOKN6cyELDkFn/GokNNXOzMFgIXwnumWPRiFMvUN1vHzQGlhUi9cwwx7
 nQdr/I1y5pHQ==
X-IronPort-AV: E=Sophos;i="5.81,299,1610438400"; 
   d="scan'208";a="456403839"
Received: from nnafsin-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.231.190])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2021 04:38:23 -0700
Date:   Sat, 3 Apr 2021 00:38:21 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 07/25] x86/sgx: Initialize virtual EPC driver even
 when SGX driver is disabled
Message-Id: <20210403003821.b4a8df9332b9e4c11ec7f254@intel.com>
In-Reply-To: <20210402112235.GF28499@zn.tnic>
References: <cover.1616136307.git.kai.huang@intel.com>
        <d35d17a02bbf8feef83a536cec8b43746d4ea557.1616136308.git.kai.huang@intel.com>
        <20210402094816.GC28499@zn.tnic>
        <20210403000810.93638fb4b468ab28faaf11fd@intel.com>
        <20210402112235.GF28499@zn.tnic>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2 Apr 2021 13:22:35 +0200 Borislav Petkov wrote:
> On Sat, Apr 03, 2021 at 12:08:10AM +1300, Kai Huang wrote:
> > Do you want me to send updated patch?
> 
> No need. If I do, I'll ask kindly, otherwise you don't have to do
> anything.
> 
I see. Thanks.
