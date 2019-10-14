Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9A9D6745
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 18:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730067AbfJNQ06 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 12:26:58 -0400
Received: from mga14.intel.com ([192.55.52.115]:64088 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726637AbfJNQ06 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 12:26:58 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Oct 2019 09:26:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,296,1566889200"; 
   d="scan'208";a="396524626"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 14 Oct 2019 09:26:57 -0700
Date:   Mon, 14 Oct 2019 09:26:57 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Bill Wendling <morbo@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [kvm-unit-tests PATCH 1/2] Use a status enum for reporting
 pass/fail
Message-ID: <20191014162657.GB22962@linux.intel.com>
References: <20191012074454.208377-1-morbo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191012074454.208377-1-morbo@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 12, 2019 at 12:44:53AM -0700, Bill Wendling wrote:
> Some values passed into "report" as "pass/fail" are larger than the
> size of the parameter. Instead use a status enum so that the size of the
> argument no longer matters.
> 
> Signed-off-by: Bill Wendling <morbo@google.com>

The threading of these mails has me all kinds of confused.  What is the
relationship between all these patches?  Did you perhaps intend to send
some of these as v2?

  [kvm-unit-tests PATCH 1/2] Use a status enum for reporting pass/fail
  [kvm-unit-tests PATCH 2/2] Use a status enum for reporting pass/fail
  [kvm-unit-tests PATCH 1/1] x86: use pointer for end of exception table
  [kvm-unit-tests PATCH 2/2] x86: use pointer for end of exception table
