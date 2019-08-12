Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 874298A598
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2019 20:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfHLSX0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Aug 2019 14:23:26 -0400
Received: from mga17.intel.com ([192.55.52.151]:36716 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726185AbfHLSXZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Aug 2019 14:23:25 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Aug 2019 11:23:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,378,1559545200"; 
   d="scan'208";a="170141279"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga008.jf.intel.com with ESMTP; 12 Aug 2019 11:23:25 -0700
Date:   Mon, 12 Aug 2019 11:23:25 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Adalbert =?utf-8?B?TGF6xINy?= <alazar@bitdefender.com>
Cc:     kvm@vger.kernel.org, linux-mm@kvack.org,
        virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        Samuel =?iso-8859-1?Q?Laur=E9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        Mihai =?utf-8?B?RG9uyJt1?= <mdontu@bitdefender.com>
Subject: Re: [RFC PATCH v6 00/92] VM introspection
Message-ID: <20190812182324.GA1437@linux.intel.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 09, 2019 at 06:59:15PM +0300, Adalbert Lazăr wrote:
>  virt/kvm/kvm_main.c                      |   70 +-
>  virt/kvm/kvmi.c                          | 2054 ++++++++++++++++++++++
>  virt/kvm/kvmi_int.h                      |  311 ++++
>  virt/kvm/kvmi_mem.c                      |  324 ++++
>  virt/kvm/kvmi_mem_guest.c                |  651 +++++++
>  virt/kvm/kvmi_msg.c                      | 1236 +++++++++++++

That's a lot of code.  An 'introspection' sub-directory might be warranted.
