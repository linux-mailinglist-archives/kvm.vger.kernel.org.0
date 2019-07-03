Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADF065E069
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 11:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbfGCJBT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 05:01:19 -0400
Received: from mga04.intel.com ([192.55.52.120]:15033 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726670AbfGCJBT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 05:01:19 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jul 2019 02:01:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,446,1557212400"; 
   d="scan'208";a="172061808"
Received: from unknown (HELO [10.239.13.7]) ([10.239.13.7])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Jul 2019 02:01:17 -0700
Message-ID: <5D1C7024.9000608@intel.com>
Date:   Wed, 03 Jul 2019 17:06:44 +0800
From:   Wei Wang <wei.w.wang@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.7.0
MIME-Version: 1.0
To:     Eric Hankland <ehankland@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v1] KVM: x86: PMU Whitelist
References: <CAOyeoRWfPNmaWY6Lifdkdj3KPPM654vzDO+s3oduEMCJP+Asow@mail.gmail.com> <5D036843.2010607@intel.com> <CAOyeoRXr4gmbBPq1RsStoPguiZB8Jxod-irYd3Dm_AGVcQRGSQ@mail.gmail.com> <5D11E58B.1060306@intel.com> <CAOyeoRUy6R0YzcMajRAhzss321p6G=LMrR63oPQCYFwaK6SMvA@mail.gmail.com>
In-Reply-To: <CAOyeoRUy6R0YzcMajRAhzss321p6G=LMrR63oPQCYFwaK6SMvA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/03/2019 01:46 AM, Eric Hankland wrote:
>
> Sounds good to me.
>
> If you don't have any more comments I'll send out the next version
> with all the requested changes.
>

No more so far. I'll see your new version.

Best,
Wei

