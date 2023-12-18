Return-Path: <kvm+bounces-4742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3ABC817828
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 18:07:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FA44284B42
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 17:07:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2541B5A857;
	Mon, 18 Dec 2023 17:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BMvYL4dJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DB05BF86
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 17:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5e46cbc3d34so34295597b3.3
        for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 09:07:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702919223; x=1703524023; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rvjqc4EDZ9TpTxZAQcIhZwHGo146B0MzTSnqxkHQUnQ=;
        b=BMvYL4dJjA4FUjz5ebqhfWvTqNs0WAckoUXYepC2lTlvb83V8U8DCLPQXbkYwYNfuQ
         Bwl25DBZ7idOTULzqTxTybO1LthgI6pz9dwCA9orDCqt1ytIUgJ0N5rULGJKze7cCmYo
         KtlkqxptmIiDXwRVo181WTeIYNutDdqHHlBEPJk3bJGIEphYlF1yXkXA0BpoJwP6A5Ov
         RZ8kKlBXiYHMosFmI9Cp0AL/UuvfzW/DKy8XfyANmqVqN1rKsUeErC/A/fxsvilP/+HV
         Z8c5QmOe8HtTZBuQTcnOi9bE4yXH4mLSV44mZDk5CZXAJvtoupWCWJSjBY4t6HzKBSPM
         trKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702919223; x=1703524023;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rvjqc4EDZ9TpTxZAQcIhZwHGo146B0MzTSnqxkHQUnQ=;
        b=X+12NfZEhwH/iOvYp+24GclEV67UossOKvpH/r5YT+Lq9jlL5XFz5iYCsOLDqy5zKW
         qRQMC8M/CBwl0q+LDyVDer3miKIDwyUTyvoPeeGW0Azd00iAlld9UaheSudvA96BjEuP
         OH8/3UNQc4avrpiOhP5VJ5Uuug1ACvN8chrzIl5Q63DHqBu2wJeibP2Oj9ITfqbfssq1
         veK9eL4xTy32Vfe2lWe52WS41AKzuK4EIv+f+n8BhoMMYTXMV0BV//jmy4cqY236NwAZ
         kyQl2hyUkQrv2O+nWwV5q0thAXgsvqSKGvWpWs+CFD1ROvi65DXDaxWSyE/Z+0hWRx1I
         a/9g==
X-Gm-Message-State: AOJu0YzFe32LZwNLI4jsdBlwaJqpHYzk+6S/wvrQ9+m4hLRcYDe9JHI8
	oVtSFuAF7g3XatX+MjjBOOXEUzun46Y=
X-Google-Smtp-Source: AGHT+IH8ENj6IkJWajt1tWoXxCRQVrBdOCRdXBE3aSi8LAqU8mtsiq/WatuiCdvu+SfCCEUVz8i5vu3/G4Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:fc2:b0:5e6:bcea:df7a with SMTP id
 dg2-20020a05690c0fc200b005e6bceadf7amr610050ywb.5.1702919222886; Mon, 18 Dec
 2023 09:07:02 -0800 (PST)
Date: Mon, 18 Dec 2023 09:07:01 -0800
In-Reply-To: <bug-218259-28872-UltznLAvHS@https.bugzilla.kernel.org/>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <bug-218259-28872@https.bugzilla.kernel.org/> <bug-218259-28872-UltznLAvHS@https.bugzilla.kernel.org/>
Message-ID: <ZYB8NdYscuQfkt7K@google.com>
Subject: Re: [Bug 218259] High latency in KVM guests
From: Sean Christopherson <seanjc@google.com>
To: bugzilla-daemon@kernel.org
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Dec 14, 2023, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=218259
> 
> --- Comment #2 from Joern Heissler (kernelbugs2012@joern-heissler.de) ---
> Hi,
> 
> 1. KSM is already disabled. Didn't try to enable it.
> 2. NUMA autobalancing was enabled on the host (value 1), not in the guest. When
> disabled, I can't see the issue anymore.

This is likely/hopefully the same thing Yan encountered[1].  If you are able to
test patches, the proposed fix[2] applies cleanly on v6.6 (note, I need to post a
refreshed version of the series regardless), any feedback you can provide would
be much appreciated.

KVM changes aside, I highly recommend evaluating whether or not NUMA
autobalancing is a net positive for your environment.  The interactions between
autobalancing and KVM are often less than stellar, and disabling autobalancing
is sometimes a completely legitimate option/solution.

[1] https://lore.kernel.org/all/ZNnPF4W26ZbAyGto@yzhao56-desk.sh.intel.com
[2] https://lore.kernel.org/all/20230825020733.2849862-1-seanjc@google.com

> 3. tdp_mmu was "Y", disabling it seems to make no difference.

Hrm, that's odd.  The commit blamed by bisection was purely a TDP MMU change.
Did you relaunch VMs after disabling the module params?  While the module param
is writable, it's effectively snapshotted by each VM during creation, i.e. toggling
it won't affect running VMs.

> So might be related to NUMA. On older kernels, the flag is 1 as well.
> 
> There's one difference in the kernel messages that I hadn't noticed before. The
> newer one prints "pci_bus 0000:7f: Unknown NUMA node; performance will be
> reduced" (same with ff again). The older ones don't. No idea what this means,
> if it's important, and can't find info on the web regarding it.

That was a new message added by commit ad5086108b9f ("PCI: Warn if no host bridge
NUMA node info"), which was first released in v5.5.  AFAICT, that warning is only
complaning about the driver code for PCI devices possibly running on the wrong
node.

However, if you are seeing that error on v6.1 or v6.6, but not v5.17, i.e. if the
message started showing up well after the printk was added, then it might be a
symptom of an underlying problem, e.g. maybe the kernel is botching parsing of
ACPI tables?

> I think the kernel is preemptible:

Ya, not fully preemptible (voluntary only), but the important part is that KVM
will drop mmu_lock if there is contention (which is a "requirement" for the bug
that Yan encountered).

