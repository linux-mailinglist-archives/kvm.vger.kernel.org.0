Return-Path: <kvm+bounces-1696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D843B7EB6FA
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 20:41:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 73E121F2586C
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 19:41:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2365926ADC;
	Tue, 14 Nov 2023 19:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YoGJ91uX"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7E726AC2
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 19:41:15 +0000 (UTC)
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C2C107;
	Tue, 14 Nov 2023 11:41:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=y2B2n6o5s66GYrU/6AX0x5LJjn5iab4+r1wbNLKGJjY=; b=YoGJ91uXtsqo8U8+OXPAkv2Npm
	3ZXQhG6dF55DNdRW8PFBg61JFf6biewmuldFciGlX5sjN1t1RnUVXBeGWFTQgqjiA9Jvn4Z9VqPeC
	W29NJEX1T9oSnux71BmIcNf+nReGgiqk0B5QcaQSZFhA0sN1M7QlepXeSY8PckJLJHbgfVqknwatF
	xWSjujNHqcYDX7KRiICFmGO8OrS1JfoIPFHVU+yF9WpgfY21FTO3Lx9CmpXnfNHGhIiML7HtWNgeV
	WzZ/bqDmo48ITwgsWrfsDKtbvl+Mae4D4cw8ancrHlbl5JQ4w8ECEwB7Gc2Q3F+61hpSsOlZo980r
	maeMV6Fw==;
Received: from [12.186.190.2] (helo=[127.0.0.1])
	by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1r2zHY-002g7X-38;
	Tue, 14 Nov 2023 19:41:09 +0000
Date: Tue, 14 Nov 2023 14:41:03 -0500
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>,
 Dongli Zhang <dongli.zhang@oracle.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_KVM=3A_x86=3A_Don=27t_unnecessarily?= =?US-ASCII?Q?_force_masterclock_update_on_vCPU_hotplug?=
User-Agent: K-9 Mail for Android
In-Reply-To: <ZVPM-8MKW56hHCuw@google.com>
References: <20231018195638.1898375-1-seanjc@google.com> <e8002e94-33c5-617c-e951-42cd76666fad@oracle.com> <0e27a686-43f9-5120-5097-3fd99982df62@oracle.com> <ZVPM-8MKW56hHCuw@google.com>
Message-ID: <380C83F0-5F0D-4B30-9E5C-F0DB9FDED44B@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

On 14 November 2023 14:39:39 GMT-05:00, Sean Christopherson <seanjc@google=
=2Ecom> wrote:
> timing doesn't really matter in the end=2E

No pun intended?=20


