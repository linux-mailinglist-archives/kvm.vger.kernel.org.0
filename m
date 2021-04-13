Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1DA435E87F
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 23:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346785AbhDMVrs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 17:47:48 -0400
Received: from mga06.intel.com ([134.134.136.31]:32108 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344381AbhDMVro (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 17:47:44 -0400
IronPort-SDR: PbFT9HorFWjQuLYoP7972bEmzUWxnwNTSXPD5t1mmpNPRCnDuYSDUjigVq6A/Gvn+A+J5a2qHI
 xIb1nmOraPfQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9953"; a="255824464"
X-IronPort-AV: E=Sophos;i="5.82,220,1613462400"; 
   d="scan'208";a="255824464"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2021 14:47:17 -0700
IronPort-SDR: mrWMdXsmnXIHUGdiCpm4ZokDyzwi8JsB/QuReg4s726ca82N4IpATBa0Ep5ccWkoCHCGoVlvzw
 liqHFGgjb25Q==
X-IronPort-AV: E=Sophos;i="5.82,220,1613462400"; 
   d="scan'208";a="418024805"
Received: from spmishra-mobl.amr.corp.intel.com ([10.209.34.28])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2021 14:47:13 -0700
Message-ID: <811afa1d379d8665eee698d85ce76861d04af3a6.camel@intel.com>
Subject: Re: [PATCH v5 00/11] KVM SGX virtualization support (KVM part)
From:   Kai Huang <kai.huang@intel.com>
To:     Borislav Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org, seanjc@google.com,
        jarkko@kernel.org, dave.hansen@intel.com, luto@kernel.org,
        rick.p.edgecombe@intel.com, haitao.huang@intel.com
Date:   Wed, 14 Apr 2021 09:47:09 +1200
In-Reply-To: <20210413150134.GH16519@zn.tnic>
References: <cover.1618196135.git.kai.huang@intel.com>
         <af16a973-29cd-3df0-55c6-260be5db8b12@redhat.com>
         <20210413150134.GH16519@zn.tnic>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-04-13 at 17:01 +0200, Borislav Petkov wrote:
> On Tue, Apr 13, 2021 at 04:51:50PM +0200, Paolo Bonzini wrote:
> > Boris, can you confirm that tip/x86/sgx has stable commit hashes?
> 
> Yap, you can go ahead and merge it.
> 
> Thx.
> 
Thank you Boris, Paolo!

