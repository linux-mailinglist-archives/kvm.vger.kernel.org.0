Return-Path: <kvm+bounces-72451-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CIr8DNknpmk+LQAAu9opvQ
	(envelope-from <kvm+bounces-72451-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:14:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 902651E703C
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:14:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 73AA8307BD8D
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 00:13:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6390719006B;
	Tue,  3 Mar 2026 00:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d1FM4SR0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948981684BE
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 00:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772496830; cv=none; b=kNPAyozs3B6QTaYE5RmCyaV5PkUOkFMQ4mBS4VB+WntHym2HB6efPky8ChH7k/Y1OMPkhqZrYKATyH2t+/mfygXwje6Rzzsvn+Oh+XYp9b9PRS338kKfQWeqTphVuN0VmFDjDi1rj99t927+/xSIae0TUsGXCKS5RUUSD/rs+3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772496830; c=relaxed/simple;
	bh=HNOa5RgHiVBaVdxq3bKSPqhDLvaP2Krs/Pv88l+yW9Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gRuF10/3MUr1E7C4YASotQ4TdzYfUFG+CI+X6KhcfqEkjim2QeZdE0rcRH6wYEjSkbtM1uaCFQ3DkaIsmxNbC2wo6AjH/5qbb57BhHPo6WEoRdRr0e8AahYnvCGXQBZ3sEqbVZLQ/CBd6YWIiSPFzo+4HPUSEypfJzYzot2NcUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d1FM4SR0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D813C2BCAF
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 00:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772496830;
	bh=HNOa5RgHiVBaVdxq3bKSPqhDLvaP2Krs/Pv88l+yW9Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=d1FM4SR0tfbfdwM35U48AepyvIBq03wg3cdNelqvHBJBEIHyivfXJeSJ05xSsC55o
	 shtlcNuM+7H2CRhVizOvh7ZwarnYLDhxTnIVZl2TTmCEVmx5OwnP0RFQB1/VRhtDqQ
	 Ds1N32Es0SKwSK6RwhcVMTfZb0mUBkkpc/dGnou8DaZ9u3FM7W3k6QpwVAa6Xf3u70
	 o2F0MYTzxW+ul02KaICNy7/XGvAYbLV4Lm2G6iXUab3WFTvwpBgSL7EpWWm+lz9yDv
	 gvUKLyuUOA2GKhaeR7PUoi3/l+EW3MYG7yNKAP4BU9tTimlEWhnuxzX1GwphZo4/oe
	 YVFz4UeN5LsKw==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b79f8f7ea43so819075566b.2
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 16:13:50 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWNfkz1FjGYLfQWQ+r5byzDTb3PZP4nmd8gYVm/8xbYTvPyGI8pCS0cTaJWfgpONFNA5xQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwstKRDIrnVHEnaeDsn8O7UVqMc1Wcd4+4qlRwM/YALMgg3Rs+M
	ipbs6ac+SOU+Hacfv51eJnHn1j7Z7a/IVulAPiuvdY37BfpXQrVC6q8FQHvHHpWVQtSLIbkd+M9
	zOg6Mi2x8/+jOPztLUj+FHL3tlJ0C0ZU=
X-Received: by 2002:a17:907:97c6:b0:b93:31d0:a865 with SMTP id
 a640c23a62f3a-b93765c781amr1062076066b.58.1772496829051; Mon, 02 Mar 2026
 16:13:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260224223405.3270433-1-yosry@kernel.org> <20260224223405.3270433-32-yosry@kernel.org>
In-Reply-To: <20260224223405.3270433-32-yosry@kernel.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 2 Mar 2026 16:13:37 -0800
X-Gmail-Original-Message-ID: <CAO9r8zMmOF_Tk=mL-WsPW1MoiVjqmhKZ9gfYL4ACuTOgE2s8Aw@mail.gmail.com>
X-Gm-Features: AaiRm50kzOLD-W7Ao0rXvKGk4TrTsFuFNjf0WkyVmtN1ZibSZ3xE99V2xZioemw
Message-ID: <CAO9r8zMmOF_Tk=mL-WsPW1MoiVjqmhKZ9gfYL4ACuTOgE2s8Aw@mail.gmail.com>
Subject: Re: [PATCH v6 31/31] KVM: selftest: Add a selftest for VMRUN/#VMEXIT
 with unmappable vmcb12
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 902651E703C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-72451-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Action: no action

> +++ b/tools/testing/selftests/kvm/x86/svm_nested_invalid_vmcb12_gpa.c
> @@ -0,0 +1,95 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2026, Google LLC.
> + */
> +#include "kvm_util.h"
> +#include "vmx.h"
> +#include "svm_util.h"
> +#include "kselftest.h"
> +
> +
> +#define L2_GUEST_STACK_SIZE 64
> +
> +#define SYNC_GP 101
> +#define SYNC_L2_STARTED 102
> +
> +extern char invalid_vmrun;
> +
> +static void guest_gp_handler(struct ex_regs *regs)
> +{
> +       GUEST_SYNC(SYNC_GP);
> +       regs->rip = (uintptr_t)&invalid_vmrun;

Instead of jumping after run_guest() and skipping the host restore
sequence, it's probably better to fixup RAX here and have a single
run_guest() call in l1_guest_code().

> +}
> +
> +static void l2_guest_code(void)
> +{
> +       GUEST_SYNC(SYNC_L2_STARTED);
> +       vmcall();
> +}
> +
> +static void l1_guest_code(struct svm_test_data *svm, u64 invalid_vmcb12_gpa)
> +{
> +       unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
> +
> +       generic_svm_setup(svm, l2_guest_code,
> +                         &l2_guest_stack[L2_GUEST_STACK_SIZE]);
> +
> +       run_guest(svm->vmcb, invalid_vmcb12_gpa); /* #GP */
> +
> +       /* GP handler should jump here */
> +       asm volatile ("invalid_vmrun:");
> +       run_guest(svm->vmcb, svm->vmcb_gpa);
> +       GUEST_ASSERT(svm->vmcb->control.exit_code == SVM_EXIT_VMMCALL);
> +       GUEST_DONE();
> +}

