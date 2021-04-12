Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D65735C9CB
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 17:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242858AbhDLPZh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 11:25:37 -0400
Received: from one.firstfloor.org ([193.170.194.197]:45758 "EHLO
        one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242755AbhDLPZd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 11:25:33 -0400
Received: by one.firstfloor.org (Postfix, from userid 503)
        id 1343086BFB; Mon, 12 Apr 2021 17:25:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=firstfloor.org;
        s=mail; t=1618241113;
        bh=xUt6fto8lahvrjxdR5wc/WBuC4njw9UvLYhRUh/F7vk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Tq20uzkBH5OB7bq3S6TcwCJtRtjrWOnBdObDzdrBHsZXkpI8wgupelktONUR5eOYn
         G2VB/9Jok/plWseR3LtKoA5ovNvPKnHfsWmiLyhGOneZmRwf9fgq00zJ/2oA/wJEVY
         a1M7K3NLz4zkPcxk7SPLXWKbBmOuoiFEJJ5bmUcQ=
Date:   Mon, 12 Apr 2021 08:25:12 -0700
From:   Andi Kleen <andi@firstfloor.org>
To:     "Liuxiangdong (Aven, Cloud Infrastructure Service Product Dept.)" 
        <liuxiangdong5@huawei.com>
Cc:     Like Xu <like.xu@linux.intel.com>, andi@firstfloor.org,
        "Fangyi (Eric)" <eric.fangyi@huawei.com>,
        Xiexiangyou <xiexiangyou@huawei.com>, kan.liang@linux.intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        wei.w.wang@intel.com, x86@kernel.org,
        "Xu, Like" <like.xu@intel.com>
Subject: Re: [PATCH v4 01/16] perf/x86/intel: Add x86_pmu.pebs_vmx for Ice
 Lake Servers
Message-ID: <20210412152511.igvdfilnuv6ed6hi@two.firstfloor.org>
References: <20210329054137.120994-2-like.xu@linux.intel.com>
 <606BD46F.7050903@huawei.com>
 <18597e2b-3719-8d0d-9043-e9dbe39496a2@intel.com>
 <60701165.3060000@huawei.com>
 <1ba15937-ee3d-157a-e891-981fed8b414d@linux.intel.com>
 <60742E82.5010607@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60742E82.5010607@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> The reason why soft lockup happens may be the unmapped EPT pages. So, do we
> have a way to map all gpa
> before we use pebs on Skylake?

Can you configure a VT-d device, that will implicitly pin all pages for the
IOMMU. I *think* that should be enough for testing.

-Andi
