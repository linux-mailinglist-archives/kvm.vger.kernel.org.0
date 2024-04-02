Return-Path: <kvm+bounces-13387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FC67895A4F
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 18:59:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF0DF281811
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 16:59:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DBB515990C;
	Tue,  2 Apr 2024 16:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mHojgZnN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7512AD1E
	for <kvm@vger.kernel.org>; Tue,  2 Apr 2024 16:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712077172; cv=none; b=MqRV0OcKmhnWlAn6I1RIMiqIdP5LnsaU/G7UK5rptW+RCgYLxk5sb4hIWDV6pojW4PzkvBOyASCZRVtzFlyhSJdI4sxFqERTMdaVdUmnw5gfx/ICgZTMyPIaBW2nt2X7S08MMvnBlcvgHkJccHbPoBHdH4bLy9JGjScA8/+bQao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712077172; c=relaxed/simple;
	bh=drIyaZ0Ajd0hKvt7CddRZ21cDMISnXuJGMX9AT9buZo=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=ha0W4Giq0u5nSo8AxuUJ1RJWRXcpeLNPZQTiQ/w/7Ru06Gs1z/dPprRs6X5SWr6d0l8qpLpXdvjyyP9XH8Mz1k+H7PnVkQNwt2ljfm9kmCcI5Vd9dTOaZWbL6MTS5ekeLgJuxcc02AH1A0HES+6MmtQuvdk7aV4Enye8/1GvH5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mHojgZnN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D8EC433C7;
	Tue,  2 Apr 2024 16:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712077171;
	bh=drIyaZ0Ajd0hKvt7CddRZ21cDMISnXuJGMX9AT9buZo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mHojgZnNcMlTSDEafUDbjzP3O5ZRXTKxm6/0E93gh2Wgr1IRz0VXFN2uhqT8AR0r9
	 oot5ZDyRm3Qy7oX9QUN10zrEk5nUEAmkb9f/pATqV8hfGeKqfEkjSy51wTe8ThzKj/
	 5eKtpDKmdSGf77gAG6+Wt+x3FgdWQI+LitrWHj9UySnKoiH9khCE1/ZRKYmaxfPaRW
	 DH23GEkZat8EwjS2QvD7CqOlDadCMpyWCE6fAfSlaTn2m163+Va8ofnOKiAU1rkgJe
	 hyE2ZE2hDYfIUUhpuZ7uVZ3y94lB+vZXwtNmmNxKF1QyaRHYOolMJmUpINJDfLd6Mo
	 jIyP60phzuGsQ==
Received: from disco-boy.misterjones.org ([217.182.43.188] helo=www.loen.fr)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rrhTt-000nor-4X;
	Tue, 02 Apr 2024 17:59:29 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 02 Apr 2024 17:59:28 +0100
From: Marc Zyngier <maz@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, Oliver Upton
 <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao
 <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman
 <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, Christian
 Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank
 <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean
 Christopherson <seanjc@google.com>
Subject: Re: [PATCH] KVM: Aggressively drop and reacquire mmu_lock during
 CLEAR_DIRTY_LOG
In-Reply-To: <CALzav=dBj3y2P4BvEO4j8_Bzb8NMd7kmJd4O9XF-N9CffNiFdQ@mail.gmail.com>
References: <20231205181645.482037-1-dmatlack@google.com>
 <CALzav=d0w=u3n4CcSWVOv=A-9v+x54aP+KVGBOrZ0=F+R5Yy-A@mail.gmail.com>
 <CALzav=dBj3y2P4BvEO4j8_Bzb8NMd7kmJd4O9XF-N9CffNiFdQ@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.15
Message-ID: <def2b19c581f891626dab51cb93be939@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 217.182.43.188
X-SA-Exim-Rcpt-To: dmatlack@google.com, pbonzini@redhat.com, kvm@vger.kernel.org, oliver.upton@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, seanjc@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On 2024-04-02 17:42, David Matlack wrote:
> On Thu, Jan 11, 2024 at 8:55 AM David Matlack <dmatlack@google.com> 
> wrote:
>> 
>> On Tue, Dec 5, 2023 at 10:16 AM David Matlack <dmatlack@google.com> 
>> wrote:
>> >
>> > Aggressively drop and reacquire mmu_lock during CLEAR_DIRTY_LOG to avoid
>> > blocking other threads (e.g. vCPUs taking page faults) for too long.
>> 
>> Ping.
>> 
>> KVM architecture maintainers: Do you have any concerns about the
>> correctness of this patch? I'm confident dropping the lock is correct
>> on x86 and it should be on other architectures as well, but
>> confirmation would be helpful.
>> 
>> Thanks.
> 
> Ping again. This patch has been sitting since December 5th. Is there
> anything I can do to help get it merged?

Please send a rebased version as a V2. With the number of MMU patches
flying around without much coordination, it is hard to keep track.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...

