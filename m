Return-Path: <kvm+bounces-72491-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QEN2FUJIpmlyNQAAu9opvQ
	(envelope-from <kvm+bounces-72491-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 03:32:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A94671E81A9
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 03:32:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5FDAC30FE8F5
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 02:30:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAD85375F63;
	Tue,  3 Mar 2026 02:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="EgAYVsr1"
X-Original-To: kvm@vger.kernel.org
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022482D592C;
	Tue,  3 Mar 2026 02:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772504999; cv=none; b=tILfuDG3VcpC3ZyqCndkgy+Wc5e9KxWlHhrKFRCokZra2EEAgu06ivueF1AMSyovABOHHM6NpttLdxhGR/d2FTUmKdQY1varUVO7EmbFbuW2uIaL6sbEfczBxO0X2JM/RCSLnyq/JTXLwsZj3qJi6Q7TqoyqWpUKbkRbthYD1Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772504999; c=relaxed/simple;
	bh=/tOQ2HuDjD7aN17fOyiiEDTO0lYnSLoDEoLqiVEPaAg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JvnjoV2XvpfUPO2R2xQpMCQf0n1qIG9ENJiZVTS/i64DdSizCJrZgkOYds9R95jHlRbnkcWEZUkuLzqfVWWOULs/6XEuNdlfaSxN6/x7Uj/tTBU5X6tqe72YNuKCL30gNAPnCo6stH8G+O4eWoz9UmnWZqyQQ7bG1fn+gosfUI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=EgAYVsr1; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772504993; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=2erKEFBrqxpDhMmgJXq5L29fCKJE3QHK/tr2GnFKmvU=;
	b=EgAYVsr1wVksMX4t9MJoe60CsWhsfxihUt6YtKqrZjX+Fp5RKjrSzmQuTz99577sK0/1rxmegD/B6g6+8e/Apfq7fl8oouNflkfiICeD+NSUOLx56mwz0Vw7VAbaCcz+UXsYqYH7JuyckZBSnmFmKYvKjT0SXUeEOxv0xipnxYk=
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0X-8D.fI_1772504992 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 03 Mar 2026 10:29:52 +0800
Date: Tue, 3 Mar 2026 10:29:51 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Kai Huang <kai.huang@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, shuah@kernel.org, 
	shivankg@amd.com, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Yi Lai <yi1.lai@intel.com>
Subject: Re: [PATCH v2] KVM: selftests: Increase 'maxnode' for guest_memfd
 tests
Message-ID: <m3f3qqqo5dtpiawv777umnkpsdg2edtf7jaioi5by7cq3hjutn@7zvlyamjfu7t>
References: <20260302205158.178058-1-kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302205158.178058-1-kai.huang@intel.com>
X-Rspamd-Queue-Id: A94671E81A9
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-8.66 / 15.00];
	WHITELIST_DMARC(-7.00)[alibaba.com:D:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.alibaba.com,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[linux.alibaba.com:s=default];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72491-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linux.alibaba.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yaoyuan@linux.alibaba.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.995];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[9];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[alibaba.com:email,linux.alibaba.com:dkim,intel.com:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, Mar 03, 2026 at 09:51:58AM +0800, Kai Huang wrote:
> Increase 'maxnode' when using 'get_mempolicy' syscall in guest_memfd
> mmap and NUMA policy tests to fix a failure on one Intel GNR platform.
>
> On a CXL-capable platform, the memory affinity of CXL memory regions may
> not be covered by the SRAT.  Since each CXL memory region is enumerated
> via a CFMWS table, at early boot the kernel parses all CFMWS tables to
> detect all CXL memory regions and assigns a 'faked' NUMA node for each
> of them, starting from the highest NUMA node ID enumerated via the SRAT.
>
> This increases the 'nr_node_ids'.  E.g., on the aforementioned Intel GNR
> platform which has 4 NUMA nodes and 18 CFMWS tables, it increases to 22.
>
> This results in the 'get_mempolicy' syscall failure on that platform,
> because currently 'maxnode' is hard-coded to 8 but the 'get_mempolicy'
> syscall requires the 'maxnode' to be not smaller than the 'nr_node_ids'.
>
> Increase the 'maxnode' to the number of bits of 'nodemask', which is
> 'unsigned long', to fix this.
>
> This may not cover all systems.  Perhaps a better way is to always set
> the 'nodemask' and 'maxnode' based on the actual maximum NUMA node ID on
> the system, but for now just do the simple way.

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

>
> Reported-by: Yi Lai <yi1.lai@intel.com>
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221014
> Closes: https://lore.kernel.org/all/bug-221014-28872@https.bugzilla.kernel.org%2F
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>
> v1 -> v2:
>  - Add 'Reported-by' and 'Closes" tags.  - Sean
>  - Use BITS_PER_TYPE().  - Sean
>  - Slightly simplify changelog to simply say "increase 'maxnode' to bits
>    of 'nodemask'" to reflect the code better.
>
> ---
>  tools/testing/selftests/kvm/guest_memfd_test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> index 618c937f3c90..cc329b57ce2e 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -80,7 +80,7 @@ static void test_mbind(int fd, size_t total_size)
>  {
>  	const unsigned long nodemask_0 = 1; /* nid: 0 */
>  	unsigned long nodemask = 0;
> -	unsigned long maxnode = 8;
> +	unsigned long maxnode = BITS_PER_TYPE(nodemask);
>  	int policy;
>  	char *mem;
>  	int ret;
>
> base-commit: a91cc48246605af9aeef1edd32232976d74d9502
> --
> 2.53.0
>

