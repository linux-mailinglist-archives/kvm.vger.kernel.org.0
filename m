Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1E9232A6DB
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1577841AbhCBPyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 10:54:03 -0500
Received: from mga18.intel.com ([134.134.136.126]:19875 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237645AbhCBBRZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 20:17:25 -0500
IronPort-SDR: 71UU4vsaZLPZFjC581KPk6FYuqKLoaIeWqiDz3oduINd7DXzsveChITbD2hzbLcZ3O6DCl3GEG
 z2RNwThxM7vg==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="174279297"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="174279297"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 17:16:26 -0800
IronPort-SDR: xWLVgGYS1gW6P71aEfavYprovsA8+NABlMKdndDJlKep54DW0uc2FfZjgylXVQcinB2UNVhih9
 u99fkxh3Kx6w==
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="406481481"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 17:16:25 -0800
Subject: Re: Processor to run Intel PT in a Guest VM
To:     Aditya Basu <aditya.basu@psu.edu>
Cc:     "Jaeger, Trent Ray" <trj1@psu.edu>, kvm <kvm@vger.kernel.org>
References: <CAPn5F5zvmfpo3tdbfVDYC+rTBmVzQ8aGYG+7FrcbeRsnZKPs-w@mail.gmail.com>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <0f76acb4-48ee-1e20-f3f1-de4efa276620@intel.com>
Date:   Tue, 2 Mar 2021 09:16:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CAPn5F5zvmfpo3tdbfVDYC+rTBmVzQ8aGYG+7FrcbeRsnZKPs-w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/3/2 2:48, Aditya Basu wrote:
> Hi all,
> I am a PhD student at the Pennsylvania State University. For my
> current project, I am trying to run Intel Processor Trace (PT) inside
> a Guest VM. Specifically, I want to run KVM in the "Host-Guest mode"
> as stated in the following bug:
> https://bugzilla.kernel.org/show_bug.cgi?id=201565
>
> However, I *cannot* find an Intel processor that supports this mode. I
> have tried using Intel's i7-7700 and i7-9700k processors. Based on my
> findings, the problem seems to be that bit 24 (PT_USE_GPA) of
> MSR_IA32_VMX_PROCBASED_CTLS2 (high) is reported as 0 by the processor.
> Hence, KVM seems to force pt_mode to 0 (or PT_MODE_HOST).

You may try the Intel Atom® Processor P* Series.

https://ark.intel.com/content/www/us/en/ark/products/series/29035/intel-atom-processor.html?wapkw=Atom#@Server

>
> I would appreciate any pointers that someone might have regarding the
> above. Specifically, I want to find an Intel processor that supports
> running Intel PT in "Host-Guest mode".
>
> Regards,
>
> Aditya Basu
> PhD Student in CSE
> Pennsylvania State University
> https://www.adityabasu.me/

