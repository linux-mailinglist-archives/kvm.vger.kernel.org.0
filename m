Return-Path: <kvm+bounces-70423-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4INIA4+thWkRFAQAu9opvQ
	(envelope-from <kvm+bounces-70423-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 09:59:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AB411FBBD4
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 09:59:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F11CE3046078
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 08:57:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B830534EF12;
	Fri,  6 Feb 2026 08:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sony.com header.i=@sony.com header.b="uEMIYC1R"
X-Original-To: kvm@vger.kernel.org
Received: from jpms-ob02.noc.sony.co.jp (jpms-ob02.noc.sony.co.jp [211.125.140.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D55834EEF8;
	Fri,  6 Feb 2026 08:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.125.140.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770368260; cv=none; b=ku+SgHw8SvUBUa4KIwwhwgF4NONEW4hfnLkvks4KVi7nbwP7bsM/JiRwgE5/q0ikE9qt9T7vkPeE2BjM0ogmuYg457CoTJvmxBtOMpBnkP4/8Y3sveXxwW6vLWDua2I2GZ8BxJoeC0kU8vexy5t6mNaEdaDzoKYMN5t4e3KZpSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770368260; c=relaxed/simple;
	bh=vrOFC/HRC3Ie5qc3U5lHi8XBQUfAXuurChWS05yIt2s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dXo2BkPkqhoM0FymUR5N7ImJ1M5B/k0nBoqUrsaf06VC5eQhQFFl1cn8QkwNB/dXEUxg37LhgyACKZCL3ngJ27HFWwd1yMIuu8giPX8/hIrqHlKYEJtmRCTcjEwumWF5wsfUvPR9k5gHTTfHWcaAivpH6ND9VLDyNoXZxJgnCKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sony.com; spf=pass smtp.mailfrom=sony.com; dkim=pass (2048-bit key) header.d=sony.com header.i=@sony.com header.b=uEMIYC1R; arc=none smtp.client-ip=211.125.140.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sony.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sony.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=sony.com; s=s1jp; t=1770368259; x=1801904259;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pC/nHVWjvFbxMPwxtThf4k2nFuf59ielNHdSV23cY9U=;
  b=uEMIYC1RfNigzWhXRFhPYZ4U07jE2eVeQPcHfoJSWvtbspbiospcwrKQ
   JPlk2uOI+a3kC742ugj6KzpdL4U0YKVX4nRBaN7Jbg/GSuju5t+oJ/TT5
   v1fqEkEbvzr++PJJAaQHy3DF+ofqKUlpmEZY/sMQHWQmTkUiqS45ouLfA
   YuPBAjHprVcfR0bMOvdMRJijy4KQRs7DcSv430CjXS0UAG6ifeJYVmLDN
   Q8YXHAbKO7GdjSSZCqiFALa0FX1gr23Oc6uiWncE8njpnPN6+blYjZvLo
   t7UQFnAeaIM3O7fpQ/m5wzgCtWINfIhmuUyV1gHwkBaZGEmlmrnOuwjeW
   w==;
Received: from unknown (HELO jpmta-ob02.noc.sony.co.jp) ([IPv6:2001:cf8:0:6e7::7])
  by jpms-ob02.noc.sony.co.jp with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 17:57:37 +0900
X-IronPort-AV: E=Sophos;i="6.21,276,1763391600"; 
   d="scan'208";a="578880254"
Received: from unknown (HELO JPC00244420) ([IPv6:2001:cf8:1:573:0:dddd:6b3e:119e])
  by jpmta-ob02.noc.sony.co.jp with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 17:57:36 +0900
Date: Fri, 6 Feb 2026 17:57:31 +0900
From: Shashank Balaji <shashank.mahadasyam@sony.com>
To: Sohil Mehta <sohil.mehta@intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
	jailhouse-dev@googlegroups.com, kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org, Rahul Bukte <rahul.bukte@sony.com>,
	Daniel Palmer <daniel.palmer@sony.com>,
	Tim Bird <tim.bird@sony.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] x86/x2apic: disable x2apic on resume if the kernel
 expects so
Message-ID: <aYWs-wvDuS53BHMe@JPC00244420>
References: <20260202-x2apic-fix-v1-0-71c8f488a88b@sony.com>
 <20260202-x2apic-fix-v1-1-71c8f488a88b@sony.com>
 <0149c37d-7065-4c72-ab56-4cea1a6c15d0@intel.com>
 <aYMOqXTYMJ_IlEFA@JPC00244420>
 <722b53a7-7560-4a1b-ab26-73eeed3dffa5@intel.com>
 <aYQzhRN83rJx6DSb@JPC00244420>
 <e5ac3272-795b-488c-b767-290fd50f2105@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5ac3272-795b-488c-b767-290fd50f2105@intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[sony.com,none];
	R_DKIM_ALLOW(-0.20)[sony.com:s=s1jp];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70423-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[32];
	DKIM_TRACE(0.00)[sony.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[shashank.mahadasyam@sony.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sony.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,uefi.org:url]
X-Rspamd-Queue-Id: AB411FBBD4
X-Rspamd-Action: no action

On Thu, Feb 05, 2026 at 03:18:58PM -0800, Sohil Mehta wrote:
> On 2/4/2026 10:07 PM, Shashank Balaji wrote:
> > On Wed, Feb 04, 2026 at 10:53:28AM -0800, Sohil Mehta wrote:
> 
> >> It's a bit odd then that the firmware chooses to enable x2apic without
> >> the OS requesting it.
> > 
> > Well, the firmware has a setting saying "Enable x2apic", which was
> > enabled. So it did what the setting says
> > 
> 
> The expectation would be that firmware would restore to the same state
> before lapic_suspend().

I'm a bit out of my depth here, but I went looking around, and this is from the
latest ACPI spec (v6.6) [1]:

	When executing from the power-on reset vector as a result of waking
	from an S2 or S3 sleep state, the platform firmware performs only the
	hardware initialization required to restore the system to either the
	state the platform was in prior to the initial operating system boot,
	or to the pre-sleep configuration state. In multiprocessor systems,
	non-boot processors should be placed in the same state as prior to the
	initial operating system boot.

	(further ahead)

	 If this is an S2 or S3 wake, then the platform runtime firmware
	 restores minimum context of the system before jumping to the waking
	 vector. This includes:

	 	CPU configuration. Platform runtime firmware restores the
		pre-sleep configuration or initial boot configuration of each
		CPU (MSR, MTRR, firmware update, SMBase, and so on). Interrupts
		must be disabled (for IA-32 processors, disabled by CLI
		instruction).

		(and other things)

I suppose, in my case, the firmware is restoring initial boot
configuration on S3 resume. And initial boot configuration of x2apic is
set from the firmware's UI "Enable x2apic".

> Maybe a warning would be useful to encourage firmware to fix this going
> forward. I don't have a strong preference on the wording, but how about?
> 
> pr_warn_once("x2apic unexpectedly re-enabled by the firmware during
> resume.\n");

At least as per the spec, it's not something the firmware needs to fix,
and it's not unexpected re-enablement.

Am I missing something?

But it _is_ surprising that this bug went unnoticed for so long :)

[1] https://uefi.org/specs/ACPI/6.6/16_Waking_and_Sleeping.html#initialization

