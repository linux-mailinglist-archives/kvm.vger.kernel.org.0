Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21E25192CAD
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 16:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbgCYPgA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 11:36:00 -0400
Received: from mga05.intel.com ([192.55.52.43]:4017 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727604AbgCYPgA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Mar 2020 11:36:00 -0400
IronPort-SDR: fk+ZHeEV5cWBD4+UwpTMnFpu4NPvRqTWKmHh5w1lq7zmnE9mmnd/G0kXQr4bdnSayc/RdJswWN
 rqCFa/Qw+wjg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2020 08:35:59 -0700
IronPort-SDR: vuQYDm0ODUHSPuLd7+kBuJiOB5nO9ZG8mTV3ht25YvS0FeyvN61G6OqRlVr2xn54r5ybzkto+S
 Hx90YYVMxawA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,304,1580803200"; 
   d="scan'208";a="270840220"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 25 Mar 2020 08:35:57 -0700
Date:   Wed, 25 Mar 2020 08:35:57 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM list <kvm@vger.kernel.org>
Subject: Re: status of kvm.git
Message-ID: <20200325153557.GD14294@linux.intel.com>
References: <ba6573bd-274e-3629-92f0-77eb5b82ac40@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba6573bd-274e-3629-92f0-77eb5b82ac40@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 24, 2020 at 12:53:11PM +0100, Paolo Bonzini wrote:
> For 5.8 I'd rather tone down the cleanups and focus on the new processor
> features (especially CET and SPP) and on nested AMD unit tests and bugfixes.

Roger that.  Reviewing the latest CET series is on my todo list.

Regarding SPP, I thought the plan was to wait until VMI landed before
taking SPP support?  Has that changed?
