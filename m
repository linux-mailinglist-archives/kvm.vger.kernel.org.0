Return-Path: <kvm+bounces-53504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A6CEEB129F4
	for <lists+kvm@lfdr.de>; Sat, 26 Jul 2025 11:41:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C47E31C82197
	for <lists+kvm@lfdr.de>; Sat, 26 Jul 2025 09:41:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADD69227563;
	Sat, 26 Jul 2025 09:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=misterjones.org header.i=@misterjones.org header.b="ZK0kwYO5"
X-Original-To: kvm@vger.kernel.org
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [217.182.43.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628EB155326;
	Sat, 26 Jul 2025 09:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.182.43.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753522876; cv=none; b=GUP3j3FjSkqb/1Uaw0v/QU8DFKftuv0U6vdS94NKqfVpH4jbtpBafyQgOWyk2echmj4yGerJKDzyLlRFItN2QGRP7Iat3KEV/aMSwqsQW0U4TxEme/gHX0hq9zvbQyUMcgA07Z2FyMhwVo+hR7rPN8V5fA28J4MkdCCsuknel9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753522876; c=relaxed/simple;
	bh=iTeOoXqz6aZjo7q4ywLa9JVRykRGRnni71TCrYjwnQ8=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=pQWShrr75BkwpfWMBBU9rHGb2nurZFJuA1M57JR1t76TyODtKmxSHHI3fgOG58N55NQmjMexnmcYzAPkxHA8Gas0UBiID+1sS0ZXZ6PfWezknBW1DZMJiRmD7xJ+iIvLmdEfBJFw1aGFfNsCWj4MGbwcdg0RIg6FrND4P/xF1hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=misterjones.org; spf=pass smtp.mailfrom=misterjones.org; dkim=pass (2048-bit key) header.d=misterjones.org header.i=@misterjones.org header.b=ZK0kwYO5; arc=none smtp.client-ip=217.182.43.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=misterjones.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=misterjones.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=misterjones.org; s=dkim20211231; h=Content-Transfer-Encoding:Content-Type:
	Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=JysWCa0Hqsy7znjssgRaZ1cn+vL8ibKOc18iND2JFrY=; b=ZK0kwYO5YY4YLDT0BwT1S875gy
	NRuXlWr7xpkliYRfvBMdYaeDsQtOIDE5aXbaxadaK/FfbuLXaUNh2FoH7Sumll3cS/B6H0LTRFzMa
	PDPOAioxVIFzXAVbt/SokYiOC3N9IMfx8ZExs4rgrVCbZHhPXYnmQL8xB2bEzPHJuaOGro6Nra1AH
	iJxMP9oOETrmtVEkrpXdDIoLptgCJLotjKC4oXihdeayNnT7AJ4AYA1dh2yta+WHDy58LbsDV47PM
	jbAiB5OSUeRw7AclawwiAG9L/vpGGAixfJ3owwxHGdkvaOFhlLdmzNtD9MMqOqRTohRgms/iIZ5kV
	RokT0oIg==;
Received: from disco-boy.misterjones.org ([217.182.43.188] helo=www.loen.fr)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@misterjones.org>)
	id 1ufb33-001a9E-LL;
	Sat, 26 Jul 2025 10:18:33 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sat, 26 Jul 2025 10:18:33 +0100
From: Marc Zyngier <maz@misterjones.org>
To: Jiaqi Yan <jiaqiyan@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org
Subject: Re: [Bug Report] external_aborts failure related to efa1368ba9f4
 ("KVM: arm64: Commit exceptions from KVM_SET_VCPU_EVENTS immediately")
In-Reply-To: <CACw3F50O9Z=hPFNzeatzr2k+1cKX_nnqdzKJOMEdmjmfy3LoUg@mail.gmail.com>
References: <CACw3F53VTDQeUbj3C75pkjz=iehbFCqbrTjYbUC3ViUbQJAhsg@mail.gmail.com>
 <CACw3F50O9Z=hPFNzeatzr2k+1cKX_nnqdzKJOMEdmjmfy3LoUg@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.15
Message-ID: <18df01493fee0547d8b5902b986a2334@misterjones.org>
X-Sender: maz@misterjones.org
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 217.182.43.188
X-SA-Exim-Rcpt-To: jiaqiyan@google.com, oliver.upton@linux.dev, kvmarm@lists.linux.dev, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On 2025-07-25 23:38, Jiaqi Yan wrote:
> On Mon, Jul 21, 2025 at 7:00 AM Jiaqi Yan <jiaqiyan@google.com> wrote:
>> 
>> Hi Oliver,
>> 
>> I was doing some SEA injection dev work and found
>> tools/testing/selftests/kvm/arm64/external_aborts.c is failing at the
>> head of my locally-tracked kvmarm/next, commit 811ec70dcf9cc ("Merge
>> branch 'kvm-arm64/config-masks' into kvmarm/next"):
>> 
>> vobeb33:/export/hda3/tmp/yjq# ./external_aborts
>> Random seed: 0x6b8b4567
>> test_mmio_abort <= fail
>> ==== Test Assertion Failure ====
>>   arm64/external_aborts.c:19: regs->pc == expected_abort_pc
>>   pid=25675 tid=25675 errno=4 - Interrupted system call
>>   (stack trace empty)
>>   0x0 != 0x21ed20 (regs->pc != expected_abort_pc)
>> vobeb33:/export/hda3/tmp/yjq#
>> vobeb33:/export/hda3/tmp/yjq#
>> vobeb33:/export/hda3/tmp/yjq# ./external_aborts
>> Random seed: 0x6b8b4567
>> test_mmio_nisv       <= pass
>> test_mmio_nisv_abort <=fail
>> ==== Test Assertion Failure ====
>>   arm64/external_aborts.c:19: regs->pc == expected_abort_pc
>>   pid=26153 tid=26153 errno=4 - Interrupted system call
>>   (stack trace empty)
>>   0x0 != 0x21eb18 (regs->pc != expected_abort_pc)
>> 
>> It looks like the PC in the guest register is lost / polluted. I only
>> tested test_mmio_abort (fail), test_mmio_nisv (pass), and
>> test_mmio_nisv_abort (fail), but from reading the code of
>> test_mmio_nisv vs test_mmio_nisv_abort, I guess test failure is
>> probably due to some bug in the code kvm injects SEA into guest.
>> 
>> If I revert a single commit efa1368ba9f4 ("KVM: arm64: Commit
>> exceptions from KVM_SET_VCPU_EVENTS immediately"), all tests in
>> tools/testing/selftests/kvm/arm64/external_aborts.c pass. I have not
>> yet figured out the bug tho. Want to report since you are the author
>> maybe you can (or already) spot something.
> 
> Friendly ping ;)

Please check this:

https://web.git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/commit/?h=next&id=c6e35dff58d348c1a9489e9b3b62b3721e62631d

         M.
-- 
Who you jivin' with that Cosmik Debris?

