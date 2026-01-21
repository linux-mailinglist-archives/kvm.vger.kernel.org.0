Return-Path: <kvm+bounces-68675-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AABBCnhAcGnXXAAAu9opvQ
	(envelope-from <kvm+bounces-68675-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 03:56:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A17A501AB
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 03:56:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DF00CBC83D6
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 02:55:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FAB4355055;
	Wed, 21 Jan 2026 02:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A428TEJc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927F9271A9A;
	Wed, 21 Jan 2026 02:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768964080; cv=none; b=W2+Ba1AU1IGCKPX1R9em1ef+pz1mwnUYJ69L1C/Wbz5qFa3ZERe7Lwzb+RagWBpyU8KlYG9q3FVKNfeGbbnLb131qiA1P2OvRgVrn8Yr3mz/zxCHWKMrqKyudmNiRTtUVUW5vl3thXsxtPEvb98ND4um3K42x0PaiH7UfH5frBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768964080; c=relaxed/simple;
	bh=TIlXfufaQqj6LTdjbzk1q92qYzxDMCtuVIRH+l5iFZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j7UVwGsHXDB2pN4zuK+aetoWhaLFqRM3HwYW7OC+yc0Zwnj6hJdzAXrihDp53TKz/VyrJV2RW+qzH+WsU+mzel/hCkDE33urYlFugQPbmnt4XFUTRo2S10mgfOvFwAvNQzOeA3EZHphgUPn1pxKlwPgP3KJdgoNpPHtMWGUnOQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A428TEJc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF009C16AAE;
	Wed, 21 Jan 2026 02:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768964080;
	bh=TIlXfufaQqj6LTdjbzk1q92qYzxDMCtuVIRH+l5iFZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A428TEJchUatkmEAey+yhDf1jtpU4cdJjHdKGMhIAMKPgPczAikb2496oVHVtixNq
	 5iCGnH0TChP9PGq1SGnf4vkogSdrJK1DyHqbIH5uBuRIpNSbue+7VCD/irIUe00IqC
	 lP0FpIcaDi6okYKNJWGvGWapp53FH6FKN65tmR9G1YojFkO/MpYQGQ1dBautXNGgk1
	 6prR/osTet9ZnIEtXDqGKQixNnTSE0e/8V3BA9S5ibOTpsgL4ExX4sXc7rYafN960W
	 kdFJ3aH+iZnMqKThqiCQ7muWPGGEodVgqkofKNr801+Io0kYKM6fSLdASctjCcq7BC
	 +Lf8jZDjia2EQ==
From: Jakub Kicinski <kuba@kernel.org>
To: bobbyeshleman@gmail.com
Cc: Jakub Kicinski <kuba@kernel.org>,
	sgarzare@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mst@redhat.com,
	horms@kernel.org,
	bobbyeshleman@meta.com,
	corbet@lwn.net,
	xuanzhuo@linux.alibaba.com,
	haiyangz@microsoft.com,
	jasowang@redhat.com,
	linux-hyperv@vger.kernel.org,
	pabeni@redhat.com,
	kys@microsoft.com,
	vishnu.dasa@broadcom.com,
	longli@microsoft.com,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	netdev@vger.kernel.org,
	stefanha@redhat.com,
	berrange@redhat.com,
	decui@microsoft.com,
	bryan-bt.tan@broadcom.com,
	eperezma@redhat.com,
	wei.liu@kernel.org,
	davem@davemloft.net,
	shuah@kernel.org,
	bcm-kernel-feedback-list@broadcom.com,
	edumazet@google.com,
	virtualization@lists.linux.dev,
	sargun@sargun.me
Subject: Re: [net-next,v15,06/12] selftests/vsock: prepare vm management helpers for namespaces
Date: Tue, 20 Jan 2026 18:54:21 -0800
Message-ID: <20260121025420.1999992-2-kuba@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260116-vsock-vmtest-v15-6-bbfd1a668548@meta.com>
References: <20260116-vsock-vmtest-v15-6-bbfd1a668548@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.46 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68675-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[32];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	DMARC_POLICY_ALLOW(0.00)[kernel.org,quarantine];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kuba@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:url,dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 8A17A501AB
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

In case you need to respin..

This is an AI-generated review of your patch.
For local reproduction steps see https://netdev-ai.bots.linux.dev/ai-local.html
---
selftests/vsock: prepare vm management helpers for namespaces

This commit adds namespace support to VM management helpers and wrapper
functions, requiring callers to explicitly pass "init_ns" for the init
namespace. The commit message states "No functional changes for existing
tests. All have been updated to pass 'init_ns' explicitly."

> diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
> index c2bdc293b94c..1d03acb62347 100755
> --- a/tools/testing/selftests/vsock/vmtest.sh
> +++ b/tools/testing/selftests/vsock/vmtest.sh
> @@ -135,7 +135,18 @@ del_namespaces() {
>  }
>
>  vm_ssh() {
> -	ssh -q -o UserKnownHostsFile=/dev/null -p ${SSH_HOST_PORT} localhost "$@"
> +	local ns_exec
> +
> +	if [[ "${1}" == init_ns ]]; then
> +		ns_exec=""
> +	else
> +		ns_exec="ip netns exec ${1}"
> +	fi
> +
> +	shift
> +
> +	${ns_exec} ssh -q -o UserKnownHostsFile=/dev/null -p "${SSH_HOST_PORT}" localhost "$@"
> +
>  	return $?
>  }

The vm_ssh() function now expects a namespace as its first argument, but
run_shared_vm_test() still calls vm_ssh without this parameter:

    vm_oops_cnt_before=$(vm_ssh -- dmesg | grep -c -i 'Oops')
    vm_warn_cnt_before=$(vm_ssh -- dmesg --level=warn | grep -c -i 'vsock')
    vm_oops_cnt_after=$(vm_ssh -- dmesg | grep -i 'Oops' | wc -l)
    vm_warn_cnt_after=$(vm_ssh -- dmesg --level=warn | grep -c -i 'vsock')

When called as "vm_ssh -- dmesg", the "--" is interpreted as the namespace
argument. Since "--" does not equal "init_ns", the function sets
ns_exec="ip netns exec --" which is invalid. The shift then consumes "--"
and the command becomes "ip netns exec -- ssh ... dmesg" which will fail.

Interestingly, the v9 version of this patch on lore correctly updated these
calls to pass "init_ns", but this change appears to have been lost between
v9 and v15. The fix for this regression is present later in the series in
commit 3ae984505e00 ("selftests/vsock: add vm_dmesg_{warn,oops}_count()
helpers").

[ ... ]

