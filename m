Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDA6356EB9
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 16:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352962AbhDGOcj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 10:32:39 -0400
Received: from one.firstfloor.org ([193.170.194.197]:41738 "EHLO
        one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbhDGOcj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 10:32:39 -0400
Received: by one.firstfloor.org (Postfix, from userid 503)
        id CB1BB868A0; Wed,  7 Apr 2021 16:32:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=firstfloor.org;
        s=mail; t=1617805947;
        bh=q6WRy7x4P3q8OvJPkyTv7aaqP4ZecObHQcJpWRuSaXU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DTtoVhBsKIspmBxu7dkw8S16LQBCS8+J6AkmqBNkDvH+aw4jz6H7SKefo2yR6FOLy
         hQHyzAbNHqY9YKLXZku+UWOr5JFqvmzILXKJ1EHmIwqRdoRHsjKJtI9MKobmx6s0j0
         Ct5R9SdhhEfIuwHVSiKKv8qWzsjGllUFZPBOMzII=
Date:   Wed, 7 Apr 2021 07:32:27 -0700
From:   Andi Kleen <andi@firstfloor.org>
To:     "Liuxiangdong (Aven, Cloud Infrastructure Service Product Dept.)" 
        <liuxiangdong5@huawei.com>
Cc:     Andi Kleen <andi@firstfloor.org>, like.xu@linux.intel.com,
        "Fangyi (Eric)" <eric.fangyi@huawei.com>,
        Xiexiangyou <xiexiangyou@huawei.com>, kan.liang@linux.intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        wei.w.wang@intel.com, x86@kernel.org
Subject: Re: [PATCH v4 01/16] perf/x86/intel: Add x86_pmu.pebs_vmx for Ice
 Lake Servers
Message-ID: <20210407143227.xoue623sigpx57c3@two.firstfloor.org>
References: <20210329054137.120994-2-like.xu@linux.intel.com>
 <606BD46F.7050903@huawei.com>
 <20210406124746.ji5iqladdlh73mok@two.firstfloor.org>
 <606D2170.6020203@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <606D2170.6020203@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 07, 2021 at 11:05:20AM +0800, Liuxiangdong (Aven, Cloud Infrastructure Service Product Dept.) wrote:
> 
> 
> On 2021/4/6 20:47, Andi Kleen wrote:
> > > AFAIK， Icelake supports adaptive PEBS and extended PEBS which Skylake
> > > doesn't.
> > > But we can still use IA32_PEBS_ENABLE MSR to indicate general-purpose
> > > counter in Skylake.
> > > Is there anything else that only Icelake supports in this patches set?
> > Only Icelake server has the support for recovering from a EPT violation
> > on the PEBS data structures. To use it on Skylake server you would
> > need to pin the whole guest, but that is currently not done.
> Sorry. Some questions about "Pin the whole guest". Do you mean VmPin equals
> VmSize
> in "/proc/$(pidof qemu-kvm)/status"? Or just VmLck equals VmSize? Or
> something else?

Either would be sufficient. All that matters is that the EPT pages don't get
unmapped ever while PEBS is active.

-Andi
