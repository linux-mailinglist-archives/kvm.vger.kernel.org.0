Return-Path: <kvm+bounces-69062-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id rYR7Jn8AdmnEKQEAu9opvQ
	(envelope-from <kvm+bounces-69062-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 12:37:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 18894805B1
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 12:37:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6F45130238EE
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 11:36:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3FB731A7F7;
	Sun, 25 Jan 2026 11:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="fvJ+EEyS"
X-Original-To: kvm@vger.kernel.org
Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF0842AA9;
	Sun, 25 Jan 2026 11:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769340971; cv=none; b=bDzjxm6YHR/TcD6HFpXSYEaSdKLdzTntGAfIn3/xEVNxBVtTCerHMvbpT0j0Zmst69N17H0uVvK3SynWwEgq/vIUKLgMEo994qEa6Ww9tPOYOyg1ksVlgjLFCiC8IiZpKzEMPTmV+DuoQTQNyj/xQOGGkfgZzEQU05QFhbHuiNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769340971; c=relaxed/simple;
	bh=tdtiBF4T91dfh0BQrU6+nIC8DtSKwATIf7f2cvsu8+4=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=c6Ov5GacRilqsudm+5qxVGIyZQXG0edk0ECK16B1LvCRyVi4akjbQbuv7zlBslBJQkP5480P4pMfBXHRpKj3D+LLI4J5z4TY2waCwubgQrM0Ymm+OGcoe8FNJPGwjdsErJF2VGVIMmsrSgEIT8+sbArTjECXLfSI6D7/HHzG4V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=fvJ+EEyS; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1769340967; x=1769945767; i=markus.elfring@web.de;
	bh=tdtiBF4T91dfh0BQrU6+nIC8DtSKwATIf7f2cvsu8+4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=fvJ+EEySZ/j3Apf9qlu2uvAkQ+Y7e+b5E2ga8eMHhMkRnO2WYX8gWgkuhzN1iwIu
	 xBIOXlxSP9FjaiMhyb2OUBfSZPfZBEpDu82kZrf0hryUb9FGheICgCxomCEeqAHuP
	 J5KADHibGIttXumIsyY6QS9u2Cl90eNNNHnFCKwDJrvJ1MYrwfOfGkK2mVwf1b74i
	 9O37cr21gBQWQJCcePyllAtuVuEjFRCCHxxoGmygFV9TwItFtG1PUu0JEmP0Y7xEI
	 5rDzBNrM6UJdTkz6wur3bBimUBQaMYmXdVoS7uLYiOA/TX9YcRUVs4ZQ+ZNcXTsuO
	 ORz0mx4Hv0C/1+PTSw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.242]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1N943B-1vnHbG02KN-00x6UE; Sun, 25
 Jan 2026 12:30:13 +0100
Message-ID: <9a818ca6-04fc-434c-b8eb-8380d5bb2293@web.de>
Date: Sun, 25 Jan 2026 12:30:08 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Jiakai Xu <xujiakai2025@iscas.ac.cn>, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Cc: Jiakai Xu <jiakaipeanut@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>
References: <20260125085157.2462296-1-xujiakai2025@iscas.ac.cn>
Subject: Re: [PATCH v2] RISC-V: KVM: Fix null pointer dereference in
 kvm_riscv_aia_imsic_has_attr
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20260125085157.2462296-1-xujiakai2025@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:vmKBZwfSFE7bkYKLyzwaV/BhZpt9Y51fIuVJ7ZJXaL0aq83Q8uF
 yhXWZMaOHqw11F92ojK2NTN/KlmKt7W3hRW/wxHKrdYq8+5U1in7C1oUUZVNVAMPtXe+wKO
 Kk6WHXkFHKeqDv1stOJEdij1INlFZmFW49etRBld3H1BfSNztrFbNOgIuwx6K6KxJNCpNp2
 Fg69XD2HPdrWoHnnrmBLQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:6isMi4krcLs=;0O1UqakaCW4S2IR45yz/u01dbAG
 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
 Xe7CnFZg=
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[web.de,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[web.de:s=s29768273];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69062-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_FROM(0.00)[web.de];
	RCPT_COUNT_TWELVE(0.00)[12];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,eecs.berkeley.edu,ghiti.fr,brainfault.org,linux.dev,dabbelt.com,kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Markus.Elfring@web.de,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[web.de:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 18894805B1
X-Rspamd-Action: no action

=E2=80=A6
> The fix adds a check to return -ENODEV if imsic_state is NULL, which
> is consistent with other error handling in the function and prevents
> the null pointer dereference.

How do you think about to move the assignment for the local variable =E2=
=80=9Cisel=E2=80=9D
behind this check by another update step?
https://elixir.bootlin.com/linux/v6.19-rc5/source/arch/riscv/kvm/aia_imsic=
.c#L982-L999


> v2: add Fixes tag and drop external link as suggested.

Please move a patch version description behind the marker line.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.19-rc6#n785


Would it be helpful to append parentheses to a function name also in the s=
ummary phrase?

Regards,
Markus

