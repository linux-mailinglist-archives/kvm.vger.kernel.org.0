Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15E1A27E0EF
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 08:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbgI3GTG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 02:19:06 -0400
Received: from mga03.intel.com ([134.134.136.65]:15866 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725320AbgI3GTF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 02:19:05 -0400
IronPort-SDR: Q4OSvQ0bJICIyPH+WJMhkeI2j+sCvGJ/1Zj76su/vHiSEgfrl/Hc/phqjEnKUOhrL8LvqaPBE8
 ai7TPF9ND5Jw==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="162434495"
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="162434495"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 23:19:05 -0700
IronPort-SDR: 7vMTJ182cEpmk1qq5tNKXQzvayC+hVdxonAEjJBVMjTITILRch7jigaZlbTIlhQsBCoynL1Itd
 SEiogSS9jnMQ==
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="514946016"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 23:19:04 -0700
Date:   Tue, 29 Sep 2020 23:19:03 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH 00/22] Introduce the TDP MMU
Message-ID: <20200930061903.GD29659@linux.intel.com>
References: <20200925212302.3979661-1-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925212302.3979661-1-bgardon@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In case Paolo is feeling trigger happy, I'm going to try and get through the
second half of this series tomorrow.
