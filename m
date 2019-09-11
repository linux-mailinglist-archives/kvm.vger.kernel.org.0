Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21A3BB0475
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 21:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730268AbfIKTL3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 15:11:29 -0400
Received: from mga07.intel.com ([134.134.136.100]:60534 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728415AbfIKTL3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 15:11:29 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Sep 2019 12:11:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,494,1559545200"; 
   d="scan'208";a="214785799"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga002.fm.intel.com with ESMTP; 11 Sep 2019 12:11:27 -0700
Date:   Wed, 11 Sep 2019 12:11:27 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Bill Wendling <morbo@google.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] x86: emulator: use "q" operand modifier
Message-ID: <20190911191127.GH1045@linux.intel.com>
References: <CAGG=3QV-0hPrWx8dFptjqbKMNfne+iTfq2e-KL89ebecO8Ta1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGG=3QV-0hPrWx8dFptjqbKMNfne+iTfq2e-KL89ebecO8Ta1w@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 09, 2019 at 02:28:22PM -0700, Bill Wendling wrote:
> The extended assembly documentation list only "q" as an operand modifier
> for DImode registers. The "d" seems to be an AMD-ism, which appears to
> be only begrudgingly supported by gcc.
> 
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
