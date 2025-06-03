Return-Path: <kvm+bounces-48320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 729A4ACCB5D
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 18:35:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FF5F16C18B
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 16:35:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B052019DF5F;
	Tue,  3 Jun 2025 16:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="YU5sBwUz"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC47434545;
	Tue,  3 Jun 2025 16:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748968521; cv=none; b=FgbImmidFWocfdkQ4tiFDh/dk2LxRbrdn9SMKdjqVBxNU94EtahaZr6cMr73qgnAOAz82/beBF1otiMBk45FtwvkQvMzfA326dLhv8XwGbS8eSQ4Mr9uL4wJz04rZNRaV16LEwh6Xd9cNxq1wVADbaFGipNkA9hNGOPJ8qbUu7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748968521; c=relaxed/simple;
	bh=nxaCfdWauzjNiTIgCxophxKa0Ige88EfFoo8WmagOwk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mIOJu5WerhNuLDzT1V8v+hVJ1OTvAql8sCOFyuJjhPkRB1b2t4wVX/jJ5cTfEokjBow2rIkRIG10MjaF693a9LY+DgXvkbCjlIL4DBW8jFFjX3grzn+fKMrul+6j7RV8hcTxq3DJctJq655VJOJxzd8acMRzbf/Xc72j9jBTxGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=YU5sBwUz; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 553GYR2v3906763
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 3 Jun 2025 09:34:28 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 553GYR2v3906763
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025052101; t=1748968479;
	bh=B4whhvRWBFRCoJ6hVF+KD7HMcx0awQWFQvakW3OGf4s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YU5sBwUzJA0fHvoPTdDw7FhsWEYRZK4g72VOSHCcdCFCiV150jNxjEO3uz+G6o7an
	 voHH+OdGZvMTqANn6sJHxVJ7RaSCdxfDEdXJSj06CHtfk7zu7T6LiAg12rawuZ1Ap5
	 DW7SJGAKuGccnPD980W1wh9jcmFdWaUKJW5FHnZD5u1CJtqZjiKH0yzo/Xxh5V58Pi
	 V2p2Y4K+UYvNEDovZ9cZ4+mKmFYAps9lHtuwSx7aOZZjDyrDpAAiE3QrQTLI56hsCR
	 Wvl7zYm1rM/j8OpZwidt/pnU6Mc/A5rGE6BMzFcjbl0Ru2EgRYUSO/jZ7zeWHA4XSW
	 HAT7481f5BVWg==
Message-ID: <9950dc5a-05ab-4a7c-a4e8-34012ef98549@zytor.com>
Date: Tue, 3 Jun 2025 09:34:27 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/9] x86/nmi: Assign and register NMI-source vectors
To: Sohil Mehta <sohil.mehta@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        Zhang Rui <rui.zhang@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Jacob Pan <jacob.pan@linux.microsoft.com>,
        Andi Kleen <ak@linux.intel.com>, Kai Huang <kai.huang@intel.com>,
        Sandipan Das <sandipan.das@amd.com>, linux-perf-users@vger.kernel.org,
        linux-edac@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-trace-kernel@vger.kernel.org
References: <20250513203803.2636561-1-sohil.mehta@intel.com>
 <20250513203803.2636561-5-sohil.mehta@intel.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <20250513203803.2636561-5-sohil.mehta@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/13/2025 1:37 PM, Sohil Mehta wrote:
> Prior to NMI-source support, the vector information was ignored by the
> hardware while delivering NMIs. With NMI-source, the architecture
> currently supports a 16-bit source bitmap to identify the source of the
> NMI. Upon receiving an NMI, this bitmap is delivered as part of the FRED
> event delivery mechanism to the kernel.
> 
> Assign a vector space of 0-15 that is specific to NMI-source and
> independent of the IDT vector space of 0-255. Being a bitmap, the
> NMI-source vectors do not have any inherent priority associated with
> them. The order of executing the NMI handlers is up to the kernel.

I'm thinking should we mention that the bitmap could be extended more
than 16 bits in future?  Or we just don't emphasize 16-bit or 0~15?


> 
> Existing NMI handling already has a priority mechanism for the NMI
> handlers, with CPU-specific (NMI_LOCAL) handlers executed first,
> followed by platform NMI handlers and unknown NMI (NMI_UNKNOWN) handlers
> being last. Within each of these NMI types, the handlers registered with
> NMI_FLAG_FIRST are given priority.
> 
> NMI-source follows the same priority scheme to avoid unnecessary
> complexity. Therefore, the NMI-source vectors are assigned arbitrarily,
> except for vectors 0 and 2.
> 
> Vector 0 is set by the hardware whenever a source vector was not used
> while generating an NMI or the originator could not be reliably
> identified. Do not assign it to any handler.
> 
> Vector 2 is reserved for external NMIs corresponding to Local APIC -
> LINT1. Some third-party chipsets may send NMI messages with a hardcoded
> vector of 2, which would result in vector 2 being set in the NMI-source
> bitmap. To avoid confusion, do not assign vector 2 to any handler.
> 
> NMI-source vectors are only assigned for NMI_LOCAL type handlers.
> Platform NMI handlers have a single handler registered per type. They
> don't need additional source information to differentiate among them.
> 
> Use the assigned vectors to register the respective NMI handlers. Warn
> if the vector values are unexpected.
> 
> A couple of NMI handlers, such as the microcode rendezvous and the crash
> reboot, do not use the typical NMI registration interface. Leave them
> as-is for now.
> 
> Originally-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>

Reviewed-by: Xin Li (Intel) <xin@zytor.com>

