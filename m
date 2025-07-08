Return-Path: <kvm+bounces-51723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C95EAFC189
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 05:41:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 02B33189854C
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 03:41:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6569023D2A0;
	Tue,  8 Jul 2025 03:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b="qS/gOdDt"
X-Original-To: kvm@vger.kernel.org
Received: from sg-3-16.ptr.tlmpb.com (sg-3-16.ptr.tlmpb.com [101.45.255.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6077821B8F2
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 03:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751946093; cv=none; b=RVPATbrRfRuhmlFZ+/caQFxkKzzj8bI9fLLrF6ZyBEb/5Bl6qIzUPQ+sK/8YEc4s4bDVv5yZ4FkZA/griBpu/HXNlxajb3ybMR1xkXSk/4teiK5ojQdPAiforKZrTdrDZge9/kWdaSfPjwAFeCTAH1OAo2bk68mkY/YoZc85448=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751946093; c=relaxed/simple;
	bh=ELbn6HSTysOmlExJ2FWdeFqiEisNHyxTYOXRQyGs7zU=;
	h=Cc:Message-Id:In-Reply-To:Content-Type:References:To:Subject:Date:
	 From:Mime-Version; b=XcHTPnR9WFGHXEuLJcWq4gCBYBezvvtmTbM5UqtfJGgSb00V1sTKW3FsCQJZO5vvB9mtZOFi+BKAeL+MBcvRpS/4K7z+pyWElfMCNnKFToQfhs8harQZxqggxBjkGr212S6SMOR/MbkdW/mmtDHpwr8eRX4tNk5doiQl5RhQuPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com; spf=pass smtp.mailfrom=lanxincomputing.com; dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b=qS/gOdDt; arc=none smtp.client-ip=101.45.255.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lanxincomputing.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=lanxincomputing-com.20200927.dkim.feishu.cn; t=1751946083;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=JIChZwtf7KFp0wUJEQAWGYcy6kZOQ3nX77/WhXlHmLk=;
 b=qS/gOdDtwms6MeuigxcdrMAhexKDt63xsVN66NCZu4lBk/5Hmx2IT77ogeTHKmNa0oSnwV
 7AnzSYt61yRvXTMvSxz75bA05URXRqWgRMhh/qA5GMlhJ+23+xfC4vs5q9NsZhFx+U78XH
 ueUhxOC8RwojtzqXKAKqcZsoUvXXPhtIFwaZnEbVjyMifyWZqIGsLBzg0VCTKoWfWUkid3
 pKj/qfYoRN+FwuS9mLY7+75PsePxfKF8x6K5Te7eYLI70jgfYlctAMpLDkSOXi2KYqgmPi
 3Dfhs4hTl1jLYNRsf1Y7mVtqjwHlHSNIXpqhNrGeSTzAsz8fDey3l2B09dsEew==
Cc: <alexandru.elisei@arm.com>, <cleger@rivosinc.com>, <jesse@rivosinc.com>, 
	<jamestiotio@gmail.com>, "Atish Patra" <atishp@rivosinc.com>
Message-Id: <2ccbb58b-1993-450e-b9c5-4b7fcb9c80a2@lanxincomputing.com>
In-Reply-To: <20250704151254.100351-5-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
X-Lms-Return-Path: <lba+2686c9361+753e19+vger.kernel.org+liujingqi@lanxincomputing.com>
References: <20250704151254.100351-4-andrew.jones@linux.dev> <20250704151254.100351-5-andrew.jones@linux.dev>
To: "Andrew Jones" <andrew.jones@linux.dev>, <kvm@vger.kernel.org>, 
	<kvmarm@lists.linux.dev>, <kvm-riscv@lists.infradead.org>
Subject: Re: [kvm-unit-tests PATCH 1/2] arm/arm64: Ensure proper host arch with kvmtool
Date: Tue, 8 Jul 2025 11:41:18 +0800
Received: from [127.0.0.1] ([116.237.111.137]) by smtp.feishu.cn with ESMTPS; Tue, 08 Jul 2025 11:41:20 +0800
User-Agent: Mozilla Thunderbird
X-Original-From: Nutty Liu <liujingqi@lanxincomputing.com>
Content-Transfer-Encoding: 7bit
From: "Nutty Liu" <liujingqi@lanxincomputing.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0

On 7/4/2025 11:12 PM, Andrew Jones wrote:
> When running on non-arm (e.g. an x86 machine) if the framework is
> configured to use kvmtool then, unlike with QEMU, it can't work.
>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Nutty Liu <liujingqi@lanxincomputing.com>

Thanks,
Nutty
> ---
>   arm/run | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/arm/run b/arm/run
> index 9ee795ae424c..858333fce465 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -97,6 +97,11 @@ function arch_run_kvmtool()
>   {
>   	local command
>   
> +	if [ "$HOST" != "arm" ] && [ "$HOST" != "aarch64" ]; then
> +		echo "kvmtool requires KVM but the host ('$HOST') is not arm" >&2
> +		exit 2
> +	fi
> +
>   	kvmtool=$(search_kvmtool_binary) ||
>   		exit $?

