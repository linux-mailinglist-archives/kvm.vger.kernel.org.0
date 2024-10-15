Return-Path: <kvm+bounces-28905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4511699F131
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 17:30:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8E3CBB21B1A
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 15:30:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04B161D5177;
	Tue, 15 Oct 2024 15:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PrRaK8Ye"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9421B394D;
	Tue, 15 Oct 2024 15:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729006206; cv=none; b=tzNC1CEMfB6PIZTRG52P+k90JX6frCOpetO5n2vSTC+94uNQ4dsHRdFP0Cc67tHEpXNciRkTJPpmfsNrW6D82mXJ0Dhgs942biHSK80KcqOhehuB3JipUEZ0HEyOUev08Xyx444NYnrGi5jvZNroPJQp63RiIjIekLAO9VnWsaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729006206; c=relaxed/simple;
	bh=R9yKuB5ETyGTsXnCd+oZ2bAx4usPweIEciAg+bJ9wSU=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=fgiAnzOwR/fvLHsAc1W2Ezrm1fC8YWE1azb1WJ8mdQfWctYONx5QykAEvUaiTbdKSyM/bkxrxG9IOzqlpaEkbgQcpwTOHA+0kNK6w7DbC/RGJH6eRll4EikstByN1FXcvkKXMOD2wq7von6ef0sYHdovk0FXRaoAHJPF7oNPAok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PrRaK8Ye; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729006204; x=1760542204;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to;
  bh=R9yKuB5ETyGTsXnCd+oZ2bAx4usPweIEciAg+bJ9wSU=;
  b=PrRaK8Ye4o0RBB6qRyadRDFy5iQcNcPPAPNHepwPqenp83Cyxj/2jYtt
   PB6KyXk3lGXjhvBpnJHbYVW5B1nDN0I1G8b6ZQUndxi8GgaB1e44zGlkQ
   1DzBtx2bjIwTrvVhOZfRcK+f9ZHirdVusrBgSaiEnWmEGOSx5xtsXEaEK
   Sd1aRmOaLPW+jUERrg+E6MFeiSk+G+8h4QhXkZmwXsIBhYySmjY2TdEjG
   WNyx6NVqH5HsxpjTWJQFy9DcHO8OTZ4C2RVW3yXAqRXavwwTwLzOQYHOi
   yz8OLZQbpXwTwmYKTeVsR4Tp3QKK/2G86TY0SCzPOKmzjx5Z8aiI+LEi2
   g==;
X-CSE-ConnectionGUID: 16x5W1r8Rz2Th6f+qJaKrw==
X-CSE-MsgGUID: zPgscTnmSEGetrXhApKBBQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="28296897"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="c'?py'?scan'208";a="28296897"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2024 08:30:03 -0700
X-CSE-ConnectionGUID: Rxaw60SkT2apw8sCPV/9Xg==
X-CSE-MsgGUID: CqcMeBkKSH6YlRM3mf4jiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,205,1725346800"; 
   d="c'?py'?scan'208";a="101262640"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO [10.124.221.110]) ([10.124.221.110])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2024 08:30:02 -0700
Content-Type: multipart/mixed; boundary="------------NpMzy77HcnTmUx9NaO1L10pD"
Message-ID: <f25673ea-08c5-474b-a841-095656820b67@intel.com>
Date: Tue, 15 Oct 2024 08:30:01 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/8] TDX host: metadata reading tweaks, bug fix and
 info dump
To: Kai Huang <kai.huang@intel.com>, kirill.shutemov@linux.intel.com,
 tglx@linutronix.de, bp@alien8.de, peterz@infradead.org, mingo@redhat.com,
 hpa@zytor.com, dan.j.williams@intel.com, seanjc@google.com,
 pbonzini@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, isaku.yamahata@intel.com,
 adrian.hunter@intel.com, nik.borisov@suse.com
References: <cover.1728903647.git.kai.huang@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <cover.1728903647.git.kai.huang@intel.com>

This is a multi-part message in MIME format.
--------------NpMzy77HcnTmUx9NaO1L10pD
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

I'm having one of those "I hate this all" moments.  Look at what we say
in the code:

>   * See the "global_metadata.json" in the "TDX 1.5 ABI definitions".

Basically step one in verifying that this is all right is: Hey, humans,
please go parse a machine-readable format.  That's insanity.  If Intel
wants to publish JSON as the canonical source of truth, that's fine.
It's great, actually.  But let's stop playing human JSON parser and make
the computers do it for us, OK?

Let's just generate the code.  Basically, as long as the generated C is
marginally readable, I'm OK with it.  The most important things are:

 1. Adding a field is dirt simple
 2. Using the generated C is simple

In 99% of the cases, nobody ends up having to ever look at the generated
code.

Take a look at the attached python program and generated C file.  I
think they qualify.  We can check the script into tools/scripts/ and it
can get re-run when new json comes out or when a new field is needed.
You'd could call the generated code like this:

#include <generated.h>

	read_gunk(&tgm);

and use it like this:

	foo = tgm.BUILD_NUM;
	bar = tgm.BUILD_DATE;

Any field you want to add is a single addition to the python list and
re-running the script.  There's not even any need to do:

#define TDX_FOO_BAR_BUILD_DATE 0x8800000200000001

because it's unnecessary when you have:

	ret |= read_...(0x8800000200000001, &tgm.BUILD_DATE);

that links the magic number and the "BUILD_DATE" so closely together
anyway.  We also don't need type safety *here* at the "read" because
it's machine generated in the first place.  If there's a type mismatch
between "0x8800000200000001" and "tgm.BUILD_DATE" we have bigger
problems on our hands.

All the type checking comes when the code consumes tgm.BUILD_DATE (or
whatever).
--------------NpMzy77HcnTmUx9NaO1L10pD
Content-Type: text/x-python; charset=UTF-8; name="tdx.py"
Content-Disposition: attachment; filename="tdx.py"
Content-Transfer-Encoding: base64

IyEvdXNyL2Jpbi9weXRob24zCmltcG9ydCBqc29uCmltcG9ydCBzeXMKCmZpbGVmZCA9IG9w
ZW4oc3lzLmFyZ3ZbMV0pCmpzb25zdHIgPSBmaWxlZmQucmVhZCgpCmZpbGVmZC5jbG9zZSgp
CgpqID0ganNvbi5sb2Fkcyhqc29uc3RyKQoKcHJpbnQoInN0YXRpYyBzdHJ1Y3QgdGR4X2ds
b2JhbF9tZXRhZGF0YSB0Z20iKQpwcmludCgieyIpCgpkZWYgZmluZF9maWVsZChuYW1lKToK
CWZvciBmIGluIGpbJ0ZpZWxkcyddOgoJCWlmIGZbJ0ZpZWxkIE5hbWUnXSA9PSBuYW1lOgoJ
CQlyZXR1cm4gZgoJcmV0dXJuIE5vbmUKCmZpZWxkcyA9ICIiIgpURFhfRkVBVFVSRVMwCkJV
SUxEX0RBVEUKQlVJTERfTlVNCk1JTk9SX1ZFUlNJT04KIiIiLnN0cmlwKCkuc3BsaXQoIlxu
IikKCmZvciBmbiBpbiBmaWVsZHM6CglmID0gZmluZF9maWVsZChmbikKCW5hbWUgPSBmWydG
aWVsZCBOYW1lJ10KCWVsZW1lbnRfYnl0ZXMgPSBpbnQoZlsnRWxlbWVudCBTaXplIChCeXRl
cyknXSkKCWVsZW1lbnRfYml0cyA9IGVsZW1lbnRfYnl0ZXMgKiA4CglwcmludCgiXHR1JWQg
JXM7IiAlIChlbGVtZW50X2JpdHMsIG5hbWUpKQoKcHJpbnQoIn0iKQoKCnByaW50KCJzdGF0
aWMgdm9pZCByZWFkX2d1bmsoKSIpCnByaW50KCJ7IikKcHJpbnQoIlx0aW50IHJldCA9IDA7
IikKcHJpbnQoIiIpCmZvciBmbiBpbiBmaWVsZHM6CglmID0gZmluZF9maWVsZChmbikKCXBy
aW50KCJcdHJldCB8PSByZWFkX3N5c19tZXRhZGF0YV9maWVsZCglcywgJnRnbS4lcyk7IiAl
CgkJCShmWydCYXNlIEZJRUxEX0lEIChIZXgpJ10sCgkJCSBmWydGaWVsZCBOYW1lJ10pKQpw
cmludCgiIikKcHJpbnQoIlx0cmV0dXJuIHJldDsiKQpwcmludCgifSIpCg==
--------------NpMzy77HcnTmUx9NaO1L10pD
Content-Type: text/x-csrc; charset=UTF-8; name="tdxm.c"
Content-Disposition: attachment; filename="tdxm.c"
Content-Transfer-Encoding: base64

c3RhdGljIHN0cnVjdCB0ZHhfZ2xvYmFsX21ldGFkYXRhIHRnbQp7Cgl1NjQgVERYX0ZFQVRV
UkVTMDsKCXUzMiBCVUlMRF9EQVRFOwoJdTE2IEJVSUxEX05VTTsKCXUxNiBNSU5PUl9WRVJT
SU9OOwp9CnN0YXRpYyB2b2lkIHJlYWRfZ3VuaygpCnsKCWludCByZXQgPSAwOwoKCXJldCB8
PSByZWFkX3N5c19tZXRhZGF0YV9maWVsZCgweDBBMDAwMDAzMDAwMDAwMDgsICZ0Z20uVERY
X0ZFQVRVUkVTMCk7CglyZXQgfD0gcmVhZF9zeXNfbWV0YWRhdGFfZmllbGQoMHg4ODAwMDAw
MjAwMDAwMDAxLCAmdGdtLkJVSUxEX0RBVEUpOwoJcmV0IHw9IHJlYWRfc3lzX21ldGFkYXRh
X2ZpZWxkKDB4ODgwMDAwMDEwMDAwMDAwMiwgJnRnbS5CVUlMRF9OVU0pOwoJcmV0IHw9IHJl
YWRfc3lzX21ldGFkYXRhX2ZpZWxkKDB4MDgwMDAwMDEwMDAwMDAwMywgJnRnbS5NSU5PUl9W
RVJTSU9OKTsKCglyZXR1cm4gcmV0Owp9Cg==

--------------NpMzy77HcnTmUx9NaO1L10pD--

