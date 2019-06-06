Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5F8536D5A
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 09:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbfFFHbP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 03:31:15 -0400
Received: from mga05.intel.com ([192.55.52.43]:48979 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726014AbfFFHbP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 03:31:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 00:31:09 -0700
X-ExtLoop1: 1
Received: from unknown (HELO [10.239.13.7]) ([10.239.13.7])
  by fmsmga007.fm.intel.com with ESMTP; 06 Jun 2019 00:31:08 -0700
Message-ID: <5CF8C272.7050808@intel.com>
Date:   Thu, 06 Jun 2019 15:36:18 +0800
From:   Wei Wang <wei.w.wang@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.7.0
MIME-Version: 1.0
To:     Eric Hankland <ehankland@google.com>
CC:     Cfir Cohen <cfir@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
        rkrcmar@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v1] KVM: x86: PMU Whitelist
References: <CAOyeoRWfPNmaWY6Lifdkdj3KPPM654vzDO+s3oduEMCJP+Asow@mail.gmail.com> <5CEC9667.30100@intel.com> <CAOyeoRWhfyuuYdguE6Wrzd7GOdow9qRE4MZ4OKkMc5cdhDT53g@mail.gmail.com> <5CEE3AC4.3020904@intel.com> <CAOyeoRW85jV=TW_xwSj0ZYwPj_L+G9wu+QPGEF3nBmPbWGX4_g@mail.gmail.com> <5CF07D37.9090805@intel.com> <CAOyeoRXWQaVYZSVL_LTTdAwJOEr+eCzhp1=_JcOX3i6_CJiD_g@mail.gmail.com> <5CF2599B.3030001@intel.com> <CAOyeoRWuHyhoy6NB=O+ekQMhBFngozKoanWzArxgBk4DH2hdtg@mail.gmail.com> <5CF5F6AE.90706@intel.com> <CAOyeoRW5wx0F=9B24h29KkhUrbaORXVSoJufb4d-XzKiAsz+NQ@mail.gmail.com> <CAEU=KTHsVmrAHXUKdHu_OwcrZoy-hgV7pk4UymtchGE5bGdUGA@mail.gmail.com> <CAOyeoRXFAQNNWRiHNtK3n17V0owBVNyKdv75xjt08Q_pC+XOXg@mail.gmail.com>
In-Reply-To: <CAOyeoRXFAQNNWRiHNtK3n17V0owBVNyKdv75xjt08Q_pC+XOXg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/06/2019 05:35 AM, Eric Hankland wrote:
>>> Right - I'm aware there are other ways of detecting this - it's still
>>> a class of events that some people don't want to surface. I'll ask if
>>> there are any better examples.
> I asked and it sounds like we are treating all events as potentially
> insecure until they've been reviewed. If Intel were to publish
> official (reasonably substantiated) guidance stating that the PMU is
> secure, then I think we'd be happy without such a safeguard in place,
> but short of that I think we want to err on the side of caution.
>

I'm not aware of any vendors who'd published statements like that.

Anyway, are you ready to share your QEMU patches or the events you want 
to be on the whitelists?


Best,
Wei
