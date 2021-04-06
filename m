Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53450355455
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 14:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243414AbhDFM50 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 08:57:26 -0400
Received: from one.firstfloor.org ([193.170.194.197]:34792 "EHLO
        one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243376AbhDFM5Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 08:57:25 -0400
X-Greylist: delayed 569 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Apr 2021 08:57:25 EDT
Received: by one.firstfloor.org (Postfix, from userid 503)
        id 601D386865; Tue,  6 Apr 2021 14:47:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=firstfloor.org;
        s=mail; t=1617713266;
        bh=CdYNa370bBquGEl1acV0SOuET0FhQiugpUMFUDq/8Ak=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GOraf4mR/gXfvs/VBHQsFUEZnaM8iuBw4UzY/eyJH+56+SIskc03wbHCmg7yLQS8w
         ldf+UIi14OhEcXzGmj+rI8YhLe7/ZLhZa4kU6W4ks11WvPVUErFg5XZzNiXJHU/Hs9
         tXQ2g6ceLwxhLC+mzel9W0HVnMbTe08LF7GSOPJo=
Date:   Tue, 6 Apr 2021 05:47:46 -0700
From:   Andi Kleen <andi@firstfloor.org>
To:     "Liuxiangdong (Aven, Cloud Infrastructure Service Product Dept.)" 
        <liuxiangdong5@huawei.com>
Cc:     like.xu@linux.intel.com, andi@firstfloor.org,
        "Fangyi (Eric)" <eric.fangyi@huawei.com>,
        Xiexiangyou <xiexiangyou@huawei.com>, kan.liang@linux.intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        wei.w.wang@intel.com, x86@kernel.org
Subject: Re: [PATCH v4 01/16] perf/x86/intel: Add x86_pmu.pebs_vmx for Ice
 Lake Servers
Message-ID: <20210406124746.ji5iqladdlh73mok@two.firstfloor.org>
References: <20210329054137.120994-2-like.xu@linux.intel.com>
 <606BD46F.7050903@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <606BD46F.7050903@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> AFAIK， Icelake supports adaptive PEBS and extended PEBS which Skylake
> doesn't.
> But we can still use IA32_PEBS_ENABLE MSR to indicate general-purpose
> counter in Skylake.
> Is there anything else that only Icelake supports in this patches set?

Only Icelake server has the support for recovering from a EPT violation
on the PEBS data structures. To use it on Skylake server you would
need to pin the whole guest, but that is currently not done.

> Besides, we have tried this patches set in Icelake.  We can use pebs(eg:
> "perf record -e cycles:pp")
> when guest is kernel-5.11, but can't when kernel-4.18.  Is there a minimum
> guest kernel version requirement?

You would need a guest kernel that supports Icelake server PEBS. 4.18
would need backports for tht.


-Andi
