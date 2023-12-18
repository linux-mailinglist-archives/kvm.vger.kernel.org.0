Return-Path: <kvm+bounces-4731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9337817526
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 16:23:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B6B231C242C8
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 15:23:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 185313A1C0;
	Mon, 18 Dec 2023 15:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U0hE3qoP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2985915485
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 15:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1d3c55e0b46so3522505ad.0
        for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 07:23:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702912983; x=1703517783; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W+33zayrrCk6yQKuaXs0YXV3ZiqQHIE8+ciGlx4N9CU=;
        b=U0hE3qoP5+UpPhvrcQszOHiFYnJwzZKcR5tX7XncyOAXgl+9cP8LfrcX2QXVcWtCi4
         3nnJOkT/kkp2D/AltB/Is/6N4c4wJ/a7HGZtll4GYXpfn5YSrh0xio56bDcMmbwn3iuL
         OrV5hQGngvO5TAEMwj1TFl7LDOape/+WeBXV5rUNSjHFvMI3z5/gZTZUa1sgP3I5yEuz
         N5z4ep2UzpUQuAI13LZ2tIfXEFvIp+2gmeRFER9Jyrq3VX50Uti3IU+uXN2ZxE0c7u11
         bYNrOuAQTdOQdTSxKmqTvuhmxxFNQvhMgdFkxELAARS/D/+scVvA28mEy8Jsd3gcvcmN
         tVcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702912983; x=1703517783;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W+33zayrrCk6yQKuaXs0YXV3ZiqQHIE8+ciGlx4N9CU=;
        b=v3VKXRsIOnLMEhCVd5vAWbg6JFvrJC1PVikar5OZikzFG/rE37RrhIFxW72pEPvyOS
         QR6qBekBjPXUDLThQrvVsiShqnbnNXJlaPUGvG9JG239y/2ow7GH6FDCWCems937InPE
         nhjBJrkkvp5CAXRuaAsWlcMsaELpkzNIo0CDf7ARpIuprB/3r81F43ja++kH7JsHrG30
         xJaP5V4f+9BFwqPCYmj7FzZasijcpugSvRVxjKsztyUg10WhWN7/FMbQgPnfDsls42UE
         czdQ+VlcOxF2+MveQ6QG1hu71gyW6z6e3T15YqwPcA0yC9qppXc0fOFTMQXYRcDKyCGU
         liCQ==
X-Gm-Message-State: AOJu0Yy8LoDQ7cVDrT2Byuvb6/lKHx46KutcdbV13UDEO3ISjxRfUcBJ
	IlzdbSJhBke4xDXL4UYi7H6ggxkjchQ=
X-Google-Smtp-Source: AGHT+IGUDhmg6ZvTXgSmfuWCyl2yw8P8dMMVSTskKk/DZiQVNF952BgCVdFxjmOusqNv7LuAFA6jzJJEDo4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e74e:b0:1d3:aba6:82b9 with SMTP id
 p14-20020a170902e74e00b001d3aba682b9mr16711plf.12.1702912983337; Mon, 18 Dec
 2023 07:23:03 -0800 (PST)
Date: Mon, 18 Dec 2023 07:23:01 -0800
In-Reply-To: <20231218140543.870234-3-tao1.su@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231218140543.870234-1-tao1.su@linux.intel.com> <20231218140543.870234-3-tao1.su@linux.intel.com>
Message-ID: <ZYBj1SSFgj-9cCeV@google.com>
Subject: Re: [PATCH 2/2] x86: KVM: Emulate instruction when GPA can't be
 translated by EPT
From: Sean Christopherson <seanjc@google.com>
To: Tao Su <tao1.su@linux.intel.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, eddie.dong@intel.com, 
	chao.gao@intel.com, xiaoyao.li@intel.com, yuan.yao@linux.intel.com, 
	yi1.lai@intel.com, xudong.hao@intel.com, chao.p.peng@intel.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Dec 18, 2023, Tao Su wrote:
> With 4-level EPT, bits 51:48 of the guest physical address must all
> be zero; otherwise, an EPT violation always occurs, which is an unexpected
> VM exit in KVM currently.
> 
> Even though KVM advertises the max physical bits to guest, guest may
> ignore MAXPHYADDR in CPUID and set a bigger physical bits to KVM.
> Rejecting invalid guest physical bits on KVM side is a choice, but it will
> break current KVM ABI, e.g., current QEMU ignores the physical bits
> advertised by KVM and uses host physical bits as guest physical bits by
> default when using '-cpu host', although we would like to send a patch to
> QEMU, it will still cause backward compatibility issues.
> 
> For GPA that can't be translated by EPT but within host.MAXPHYADDR,
> emulation should be the best choice since KVM will inject #PF for the
> invalid GPA in guest's perspective and try to emulate the instructions
> which minimizes the impact on guests as much as possible.

NAK.  allow_smaller_maxphyaddr is a bit of a mess and in IMO was a mistake, but
at least there was reasonable motivation for trying to support guests with a small
MAXPHYADDR.  Fudging around a QEMU bug is not good enough justification, especially
since the odds of a hack in KVM fully working are slim to none.

