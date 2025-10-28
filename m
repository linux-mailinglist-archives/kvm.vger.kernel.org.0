Return-Path: <kvm+bounces-61285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FD87C138EC
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 09:34:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7AA411A666EA
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 08:35:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 745EB2D8370;
	Tue, 28 Oct 2025 08:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KjIo+bWh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976EA1DDA24
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 08:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761640478; cv=none; b=LLLXI3M/Bmdn+OMLhrNA4UzvCLvPfiQ+vPlnZhUq925H3XE/+x6wDzqjjNw93JW+bK7TXiTJpTlkOu+bJDm9+q5PlxrbqJtM2epGXJ0Jf1EWJewd3cwFeIHKaL4NNR9GTDUDJ/goRezqkvKsqsbjoSNGHQAsExbqob5IE6FtT3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761640478; c=relaxed/simple;
	bh=xL96dJ4I/mlgu1R+jfkDTz13nvLRhE07my2zJy3mP5w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B4rk1rxSxFT3QCkRG2e5nJsWd8qPNj9DibUx5YTwT+26bnUG22/tJPIatw/Kz8vPY3k7KnUBeHf5YDBBxW+ht0jyLPpvOVIOte5tciMlKvXDeZo7uLyHX1UqZDrdoDntzE96V6eSkPh6NmUuGXFC17ZeK71nErk73gc4nkqx6S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KjIo+bWh; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761640476; x=1793176476;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xL96dJ4I/mlgu1R+jfkDTz13nvLRhE07my2zJy3mP5w=;
  b=KjIo+bWhYrJu7F1nLd6FvAyJwKhE57wibkcu1xe/qmvEQ+xrGAEQBfsG
   Kk+pAzx7DT/tudZ6JeZ8tfyo+KMsxo7ErgYpVg/gaBsRsk1iQA/4nseFr
   sYn8/A161ySRu5BKgee2AfK+EUfHXytW4I0FM+vU68flunAVTpyrZ76UD
   UBQ9exlwATGSOF8owzUYrqdxXQ8IZ2wzRzJxgUPAt8r76igkm+yP99bD5
   CdxYBv+G5SYqYPnIOH+g7Kyw7pit7uhnsgzhyP8u61T9ctZYusuMwz8hY
   ngWuJqrnlX6wtPK47r5CA1b8MsuEqusrrUIyTON5sY7jnZff5HKWxFAF0
   w==;
X-CSE-ConnectionGUID: waNZYsU7Ts+FNqSafWNpAA==
X-CSE-MsgGUID: dtWLPO55SJuoCHmJ9Q0nZg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74335407"
X-IronPort-AV: E=Sophos;i="6.19,261,1754982000"; 
   d="scan'208";a="74335407"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 01:34:35 -0700
X-CSE-ConnectionGUID: o+PgGZf3Rgaub7iOs990hA==
X-CSE-MsgGUID: /BoTglJbR4OS9bEvTgp36A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,261,1754982000"; 
   d="scan'208";a="189341872"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 01:34:32 -0700
Message-ID: <449e5c7e-8df4-4925-ae38-cb7e144b0572@intel.com>
Date: Tue, 28 Oct 2025 16:34:27 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 18/20] i386/cpu: Enable cet-ss & cet-ibt for supported
 CPU models
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, Chao Gao
 <chao.gao@intel.com>, John Allen <john.allen@amd.com>,
 Babu Moger <babu.moger@amd.com>, Mathias Krause <minipli@grsecurity.net>,
 Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>, Farrah Chen <farrah.chen@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-19-zhao1.liu@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20251024065632.1448606-19-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/2025 2:56 PM, Zhao Liu wrote:
> Add new versioned CPU models for Sapphire Rapids, Sierra Forest, Granite
> Rapids and Clearwater Forest, to enable shadow stack and indirect branch
> tracking.
> 
> Tested-by: Farrah Chen <farrah.chen@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   target/i386/cpu.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 44 insertions(+)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 9a1001c47891..73026d5bce91 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -5161,6 +5161,17 @@ static const X86CPUDefinition builtin_x86_defs[] = {
>                       { /* end of list */ },
>                   }
>               },
> +            {
> +                .version = 5,
> +                .note = "with cet-ss and cet-ibt",
> +                .props = (PropValue[]) {
> +                    { "cet-ss", "on" },
> +                    { "cet-ibt", "on" },
> +                    { "vmx-exit-save-cet", "on" },
> +                    { "vmx-entry-load-cet", "on" },
> +                    { /* end of list */ },
> +                }
> +            },
>               { /* end of list */ }
>           }
>       },
> @@ -5323,6 +5334,17 @@ static const X86CPUDefinition builtin_x86_defs[] = {
>                       { /* end of list */ },
>                   }
>               },
> +            {
> +                .version = 4,
> +                .note = "with cet-ss and cet-ibt",
> +                .props = (PropValue[]) {
> +                    { "cet-ss", "on" },
> +                    { "cet-ibt", "on" },
> +                    { "vmx-exit-save-cet", "on" },
> +                    { "vmx-entry-load-cet", "on" },
> +                    { /* end of list */ },
> +                }
> +            },
>               { /* end of list */ },
>           },
>       },
> @@ -5477,6 +5499,17 @@ static const X86CPUDefinition builtin_x86_defs[] = {
>                       { /* end of list */ },
>                   }
>               },
> +            {
> +                .version = 4,
> +                .note = "with cet-ss and cet-ibt",
> +                .props = (PropValue[]) {
> +                    { "cet-ss", "on" },
> +                    { "cet-ibt", "on" },
> +                    { "vmx-exit-save-cet", "on" },
> +                    { "vmx-entry-load-cet", "on" },
> +                    { /* end of list */ },
> +                }
> +            },
>               { /* end of list */ },
>           },
>       },
> @@ -5612,6 +5645,17 @@ static const X86CPUDefinition builtin_x86_defs[] = {
>           .model_id = "Intel Xeon Processor (ClearwaterForest)",
>           .versions = (X86CPUVersionDefinition[]) {
>               { .version = 1 },
> +            {
> +                .version = 2,
> +                .note = "with cet-ss and cet-ibt",
> +                .props = (PropValue[]) {
> +                    { "cet-ss", "on" },
> +                    { "cet-ibt", "on" },
> +                    { "vmx-exit-save-cet", "on" },
> +                    { "vmx-entry-load-cet", "on" },
> +                    { /* end of list */ },
> +                }
> +            },
>               { /* end of list */ },
>           },
>       },


