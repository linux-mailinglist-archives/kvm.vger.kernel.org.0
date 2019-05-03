Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D02A113234
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 18:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbfECQa6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 12:30:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:32490 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726444AbfECQa6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 12:30:58 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 May 2019 09:30:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,426,1549958400"; 
   d="scan'208";a="170317069"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by fmsmga001.fm.intel.com with ESMTP; 03 May 2019 09:30:57 -0700
Date:   Fri, 3 May 2019 09:30:57 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        marcorr@google.com, kvm@vger.kernel.org,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH] tests: kvm: Add tests to .gitignore
Message-ID: <20190503163057.GA32628@linux.intel.com>
References: <20190502183150.259633-1-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502183150.259633-1-aaronlewis@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 02, 2019 at 11:31:50AM -0700, Aaron Lewis wrote:
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> ---
>  tools/testing/selftests/kvm/.gitignore | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 2689d1ea6d7a..391a19231618 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -6,4 +6,7 @@
>  /x86_64/vmx_close_while_nested_test
>  /x86_64/vmx_tsc_adjust_test
>  /x86_64/state_test
> +/x86_64/hyperv_cpuid
> +/x86_64/smm_test
> +/clear_dirty_log_test
>  /dirty_log_test

Super nit: would you want to organize these alphabetically?  Only the last
two entries (x86_64/state_test and dirty_log_test) would need to be moved.

Wish we didn't have to play whack-a-mole with ignoring tests, but a quick
glance at the selftest build system doesn't reveal an easy way to provide
and ignore an output directory :(

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
