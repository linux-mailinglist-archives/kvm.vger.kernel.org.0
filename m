Return-Path: <kvm+bounces-70716-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kOG7Doj1imn2OwAAu9opvQ
	(envelope-from <kvm+bounces-70716-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 10:08:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id C85A6118918
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 10:08:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 391EC30067B3
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 09:08:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A18A433F381;
	Tue, 10 Feb 2026 09:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="MIBVqdQj"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B168E33EAE7;
	Tue, 10 Feb 2026 09:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770714500; cv=none; b=VZs54YOMGePMHQ5+UEwg//IRZ180w0ql+f9DOgcy54xbGzkFJI8JOj4DZHxwZAEoEzUfTCCoREZ6ZYDaffjZbhI36nGLpldwG5iKZqk4SFVntBZKlfGgIUqZDLzYueT/X0x9lXjay7LdbZjLhvkG2QnK3xuZ6+r6d9ZNhkIMBbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770714500; c=relaxed/simple;
	bh=fLRmnf7jELy9HHxsyjhyxIVd4SKZwGTVVUMLws9z7hM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pe0fp6vNVCkUa+L+5RHn5CpgW938mDGTXlBHAlJbeRrPjSKYrVDbZzHHKWl8+o4bc/SGi/nPXLhlN2aiWRnxIRrK6GIgZBBH4iQFPDN0vH8Ix0ffP1DbLsyV0tFbn1bQYhhGvFR0q3mORKM/+fHYGWlytFHQ1OZnpUkhsX3iC7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=MIBVqdQj; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=n7FavI3o1qy0cR4OoymUaQMagZ3mOBpUji+X9N1Ze5I=;
	b=MIBVqdQjNDxB5wXpXXl32ivlSVJGDV7Ka/HxUtqJT+p1R+q08MfCqz3y80KNnc
	PvR8AjqwMG1Xjvpv8qut3hvdewHwKIQz7JXSrTANuMYGj2i5+l334c9gwnRjgUbX
	VzGy2fv6Sg2ycjvF4B1UneiSpDNVDKqvyZJMusGtdowhg=
Received: from [10.0.2.15] (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgA3IvJo9YppI5giNw--.5281S2;
	Tue, 10 Feb 2026 17:07:53 +0800 (CST)
Message-ID: <fd761420-e2ef-435e-9c6b-4b0b742a62a8@163.com>
Date: Tue, 10 Feb 2026 17:07:16 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND 4/5] KVM: x86: selftests: Allow the PMU event
 filter test for Hygon
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, shuah@kernel.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhiquan_li@163.com
References: <20260209041305.64906-1-zhiquan_li@163.com>
 <20260209041305.64906-5-zhiquan_li@163.com> <aYoNg4dUNluaQgVJ@google.com>
From: Zhiquan Li <zhiquan_li@163.com>
Content-Language: en-US
In-Reply-To: <aYoNg4dUNluaQgVJ@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:PCgvCgA3IvJo9YppI5giNw--.5281S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKw1kKw43tF1rGrWxAw1DJrb_yoW3WwbEyr
	4SyF9rArs0vFy0yF4rtw4qkFW7Ga1fJws0qr9Yqry3Gr40yay5GFsY9ryqk34fWrWfKa42
	vF4qk3Waya18ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7VUjsNV5UUUUU==
X-CM-SenderInfo: 52kl13xdqbzxi6rwjhhfrp/xtbCwQqUfWmK9WrYaQAA3v
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[163.com,none];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_FROM(0.00)[163.com];
	TAGGED_FROM(0.00)[bounces-70716-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[163.com:+];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zhiquan_li@163.com,kvm@vger.kernel.org];
	FREEMAIL_CC(0.00)[redhat.com,kernel.org,vger.kernel.org,163.com];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C85A6118918
X-Rspamd-Action: no action


On 2/10/26 00:38, Sean Christopherson wrote:
> Manually handling every check is rather silly, just do:
> 
> diff --git a/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c b/tools/
> testing/selftests/kvm/x86/pmu_event_filter_test.c
> index 1c5b7611db24..93b61c077991 100644
> --- a/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
> +++ b/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
> @@ -361,7 +361,8 @@ static bool use_intel_pmu(void)
>   */
>  static bool use_amd_pmu(void)
>  {
> - return host_cpu_is_amd && kvm_cpu_family() >= 0x17;
> + return (host_cpu_is_amd && kvm_cpu_family() >= 0x17) ||
> + host_cpu_is_hygon;
>  }
>  
>  /*

No problem, let me simplify it in V2 patch. Thanks!

Best Regards,
Zhiquan




