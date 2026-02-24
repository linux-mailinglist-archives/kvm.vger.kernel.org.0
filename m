Return-Path: <kvm+bounces-71606-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OBtwAGd6nWmAQAQAu9opvQ
	(envelope-from <kvm+bounces-71606-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 11:16:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6079A1852FB
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 11:16:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 562F930A4CD0
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 10:16:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3F7937757A;
	Tue, 24 Feb 2026 10:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="lteHn4Kh"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA3737754C;
	Tue, 24 Feb 2026 10:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771928161; cv=none; b=B/9n7B7T8duWJfEkUqOkZbBAJ4fNdKHhyPAqQqL/0S2YUqbNiJMfvQPvY0o7/3LKngr1aweMUzWynFSL812zhiN2tYAL+ndsg8K7OGohdAF62uCOxpk9+jvJRgMHi3s9a/c+AVxMQInjjLgTISyEa9/mnIylG8EId1EbP2VG6kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771928161; c=relaxed/simple;
	bh=5B5cAzdDcjLLpVYza5TDGpe1UXwE3kCTyLiwb2CY1oM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ta0N6OaU+Wdg8TePncAmBIDQ6lczmolkOt5SEV/X5xGzXxmdzomNLuiOd0mOzrwmNPpgBBr0/YYpghREajXzEfcJ/4e8RAIvC5HkYpU7QFuN9HcxMgZSgmrP+tbguxbg+S+8mZnF5uxb6KjRjvftYg5CPjwypQVlFRm0aSmhz+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=lteHn4Kh; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=+y6mpXkhpbtYLeqbNljk7F9iKBKEFPBV8KPGNECdZ50=;
	b=lteHn4KhorCsEwXQBa93Oc/jks7LbvF3bYClSeIFeb2JquQbnPMP3UEScgGRQx
	MGjJkGOD9EKcpMBcgdIbp+gHXsHXJdyfe/jeyIA6tFB24mryudNmTbsdqq81c8J/
	zGmziDx6k1OGF0WXSHlpwdbbO5OOrbS9abDyG8nIzqWL4=
Received: from [10.0.2.15] (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wDnT786ep1pPJVVMQ--.54843S2;
	Tue, 24 Feb 2026 18:15:24 +0800 (CST)
Message-ID: <4d17f847-0269-4a97-aa28-d3350faaf9c0@163.com>
Date: Tue, 24 Feb 2026 18:15:12 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] KVM: x86: selftests: Add Hygon CPUs support and
 fix failures
To: seanjc@google.com, pbonzini@redhat.com, shuah@kernel.org
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260212103841.171459-1-zhiquan_li@163.com>
From: Zhiquan Li <zhiquan_li@163.com>
Content-Language: en-US
In-Reply-To: <20260212103841.171459-1-zhiquan_li@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wDnT786ep1pPJVVMQ--.54843S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJw47XF1ruF1fZw45KF1DAwb_yoW5Jw1xpa
	4Fvan0kFsrJ3WIka4xtr1kXr1Iyrs3CFWUtr1Ut347Aw15Aa4xtw4Ska1UZ3Z3Cr4rZ3y5
	Aa4DtF43Ga1UAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U7CzNUUUUU=
X-CM-SenderInfo: 52kl13xdqbzxi6rwjhhfrp/xtbCwh1vWGmdej1v4AAA3U
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[163.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-71606-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[163.com];
	DKIM_TRACE(0.00)[163.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zhiquan_li@163.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6079A1852FB
X-Rspamd-Action: no action


On 2/12/26 18:38, Zhiquan Li wrote:
> This series to add support for Hygon CPUs and fix 11 KVM selftest failures
> on Hygon architecture.
> 
> Patch 1 add CPU vendor detection for Hygon and add a global variable
> "host_cpu_is_hygon" to identify if the test is running on a Hygon CPU.
> It is the prerequisite for the following fixes.
> 
> Patch 2 add a flag to identify AMD compatible CPU and figure out the
> compatible cases, so that Hygon CPUs can re-use them.
> Following test failures on Hygon platform can be fixed by this patch:
> - access_tracking_perf_test
> - demand_paging_test
> - dirty_log_perf_test
> - dirty_log_test
> - kvm_page_table_test
> - memslot_modification_stress_test
> - pre_fault_memory_test
> - x86/dirty_log_page_splitting_test
> - x86/fix_hypercall_test
> 
> Patch 3 fix x86/pmu_event_filter_test failure by allowing the tests for
> Hygon CPUs.
> 
> Patch 4 fix x86/msrs_test failure while writing the MSR_TSC_AUX reserved
> bits without RDPID support.
> Sean has made a perfect solution for the issue and provided the patch.
> It has been verified on Intel, AMD and Hygon platforms, no regression.
> 

Kindly ping for any review on these.

Best Regards,
Zhiquan

> ---
> 
> V1: https://lore.kernel.org/kvm/20260209041305.64906-1-zhiquan_li@163.com/T/#t
> 
> Changes since V1:
> - Rebased to kvm-x86/next.
> - Followed Sean's suggestion, added a flag to identify AMD compatible test
>   cases, then v1/patch 2 and v1/patch 3 can be combined to v2/patch 2.
> - Followed Sean's suggestion, simplified patch 4, that is v2/patch 3 now.
> - Sean provided the v2/patch 4 for the issue reported by v1/patch5, I
>   replaced my SoB with "Reported-by" tag.
> 
> ---
> 
> Sean Christopherson (1):
>   KVM: selftests: Fix reserved value WRMSR testcase for multi-feature
>     MSRs
> 
> Zhiquan Li (3):
>   KVM: x86: selftests: Add CPU vendor detection for Hygon
>   KVM: x86: selftests: Add a flag to identify AMD compatible test cases
>   KVM: x86: selftests: Allow the PMU event filter test for Hygon
> 
>  .../testing/selftests/kvm/include/x86/processor.h |  7 +++++++
>  tools/testing/selftests/kvm/lib/x86/processor.c   | 15 +++++++++++----
>  .../selftests/kvm/x86/fix_hypercall_test.c        |  2 +-
>  tools/testing/selftests/kvm/x86/msrs_test.c       |  4 ++--
>  .../selftests/kvm/x86/pmu_event_filter_test.c     |  3 ++-
>  .../testing/selftests/kvm/x86/xapic_state_test.c  |  2 +-
>  6 files changed, 24 insertions(+), 9 deletions(-)
> 
> 
> base-commit: e944fe2c09f405a2e2d147145c9b470084bc4c9a


