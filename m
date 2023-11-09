Return-Path: <kvm+bounces-1389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EE67B7E7527
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 00:29:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29CFC1C20CB1
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 23:29:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBBD138FAC;
	Thu,  9 Nov 2023 23:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LaPGzsrt"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31CA238DCA
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 23:29:07 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C26420F;
	Thu,  9 Nov 2023 15:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699572546; x=1731108546;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to;
  bh=JPjZQMbec4yk3cmmYlBiwG89f7tqlr990Mxr1BtMikU=;
  b=LaPGzsrtpC00l7IgL5OLBbjWFs2Ko080COu62Zs5+Qe7cNWcf249VsN5
   tkB0nefsSMFIpJ35wwkLHV4lE7Z0rk1z/F9Ck35N/mSY4uRaorDTE9nCC
   5MB6poRk+sKkZpZXpgFESo8PDWpbUoM4lYZ+GwWbeHHYUXx1RoPGAjBGf
   y5LcwR3UGijbg2OWfqbWnD1cfTbrzA50WIcKKHr0f5ekgQIbV2SsSSr09
   2kdYcR+qhDIpDiQ4hSJwTJBJINtXEvU0aIiwotWFpr1t3dK2kU/0o7/p3
   qznc0wt7ivLgFKgLwtAIRw15BJaPvZRCCnnkvKBLMLv6lClsHY4uEqSlL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10889"; a="387255865"
X-IronPort-AV: E=Sophos;i="6.03,290,1694761200"; 
   d="scan'208";a="387255865"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 15:29:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,290,1694761200"; 
   d="scan'208";a="4689399"
Received: from tiwariv-mobl.amr.corp.intel.com (HELO [10.212.165.194]) ([10.212.165.194])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 15:29:05 -0800
Content-Type: multipart/mixed; boundary="------------SgAPAoO5SU24KmWQvT1ZtW1K"
Message-ID: <96b0d0b4-4563-4012-8147-4318b096a435@intel.com>
Date: Thu, 9 Nov 2023 15:29:05 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 09/23] x86/virt/tdx: Get module global metadata for
 module initialization
Content-Language: en-US
To: Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: x86@kernel.org, kirill.shutemov@linux.intel.com, peterz@infradead.org,
 tony.luck@intel.com, tglx@linutronix.de, bp@alien8.de, mingo@redhat.com,
 hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com, rafael@kernel.org,
 david@redhat.com, dan.j.williams@intel.com, len.brown@intel.com,
 ak@linux.intel.com, isaku.yamahata@intel.com, ying.huang@intel.com,
 chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 nik.borisov@suse.com, bagasdotme@gmail.com, sagis@google.com,
 imammedo@redhat.com
References: <cover.1699527082.git.kai.huang@intel.com>
 <30906e3cf94fe48d713de21a04ffd260bd1a7268.1699527082.git.kai.huang@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <30906e3cf94fe48d713de21a04ffd260bd1a7268.1699527082.git.kai.huang@intel.com>

This is a multi-part message in MIME format.
--------------SgAPAoO5SU24KmWQvT1ZtW1K
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/9/23 03:55, Kai Huang wrote:
...> +	ret = read_sys_metadata_field16(MD_FIELD_ID_MAX_TDMRS,
> +			&tdmr_sysinfo->max_tdmrs);
> +	if (ret)
> +		return ret;
> +
> +	ret = read_sys_metadata_field16(MD_FIELD_ID_MAX_RESERVED_PER_TDMR,
> +			&tdmr_sysinfo->max_reserved_per_tdmr);
> +	if (ret)
> +		return ret;
> +
> +	ret = read_sys_metadata_field16(MD_FIELD_ID_PAMT_4K_ENTRY_SIZE,
> +			&tdmr_sysinfo->pamt_entry_size[TDX_PS_4K]);
> +	if (ret)
> +		return ret;
> +
> +	ret = read_sys_metadata_field16(MD_FIELD_ID_PAMT_2M_ENTRY_SIZE,
> +			&tdmr_sysinfo->pamt_entry_size[TDX_PS_2M]);
> +	if (ret)
> +		return ret;
> +
> +	return read_sys_metadata_field16(MD_FIELD_ID_PAMT_1G_ENTRY_SIZE,
> +			&tdmr_sysinfo->pamt_entry_size[TDX_PS_1G]);
> +}

I kinda despise how this looks.  It's impossible to read.

I'd much rather do something like the attached where you just map the
field number to a structure member.  Note that this kind of structure
could also be converted to leverage the bulk metadata query in the future.

Any objections to doing something more like the attached completely
untested patch?
--------------SgAPAoO5SU24KmWQvT1ZtW1K
Content-Type: text/x-patch; charset=UTF-8; name="cleaner-tdx-metadata-0.patch"
Content-Disposition: attachment; filename="cleaner-tdx-metadata-0.patch"
Content-Transfer-Encoding: base64

CgotLS0KCiBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYyB8ICAgNTkgKysrKysrKysr
KysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMzQg
aW5zZXJ0aW9ucygrKSwgMjUgZGVsZXRpb25zKC0pCgpkaWZmIC1wdU4gYXJjaC94ODYvdmly
dC92bXgvdGR4L3RkeC5jfmNsZWFuZXItdGR4LW1ldGFkYXRhLTAgYXJjaC94ODYvdmlydC92
bXgvdGR4L3RkeC5jCi0tLSBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguY35jbGVhbmVy
LXRkeC1tZXRhZGF0YS0wCTIwMjMtMTEtMDkgMTQ6NTg6MDYuNTA0NTMxODg0IC0wODAwCisr
KyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYwkyMDIzLTExLTA5IDE1OjIyOjQ2Ljg5
NTk0MTkwOCAtMDgwMApAQCAtMjU2LDUwICsyNTYsNTkgQEAgc3RhdGljIGludCByZWFkX3N5
c19tZXRhZGF0YV9maWVsZCh1NjQgZgogCXJldHVybiAwOwogfQogCi1zdGF0aWMgaW50IHJl
YWRfc3lzX21ldGFkYXRhX2ZpZWxkMTYodTY0IGZpZWxkX2lkLCB1MTYgKmRhdGEpCitzdGF0
aWMgaW50IHJlYWRfc3lzX21ldGFkYXRhX2ZpZWxkMTYodTY0IGZpZWxkX2lkLAorCQkJCSAg
ICAgaW50IG9mZnNldCwKKwkJCQkgICAgIHN0cnVjdCB0ZHhfdGRtcl9zeXNpbmZvICp0cykK
IHsKLQl1NjQgX2RhdGE7CisJdTE2ICp0c19tZW1iZXIgPSAoKHZvaWQgKil0cykgKyBvZmZz
ZXQ7CisJdTY0IHRtcDsKIAlpbnQgcmV0OwogCiAJaWYgKFdBUk5fT05fT05DRShNRF9GSUVM
RF9JRF9FTEVfU0laRV9DT0RFKGZpZWxkX2lkKSAhPQogCQkJTURfRklFTERfSURfRUxFX1NJ
WkVfMTZCSVQpKQogCQlyZXR1cm4gLUVJTlZBTDsKIAotCXJldCA9IHJlYWRfc3lzX21ldGFk
YXRhX2ZpZWxkKGZpZWxkX2lkLCAmX2RhdGEpOworCXJldCA9IHJlYWRfc3lzX21ldGFkYXRh
X2ZpZWxkKGZpZWxkX2lkLCAmdG1wKTsKIAlpZiAocmV0KQogCQlyZXR1cm4gcmV0OwogCi0J
KmRhdGEgPSAodTE2KV9kYXRhOworCSp0c19tZW1iZXIgPSB0bXA7CiAKIAlyZXR1cm4gMDsK
IH0KIAorc3RydWN0IGZpZWxkX21hcHBpbmcKK3sKKwl1NjQgZmllbGRfaWQ7CisJaW50IG9m
ZnNldDsKK307CisKKyNkZWZpbmUgVERfU1lTSU5GT19NQVAoX2ZpZWxkX2lkLCBfb2Zmc2V0
KSBcCisJeyAuZmllbGRfaWQgPSBNRF9GSUVMRF9JRF8jI19maWVsZF9pZCwJICAgXAorCSAg
Lm9mZnNldCAgID0gb2Zmc2V0b2Yoc3RydWN0IHRkeF90ZG1yX3N5c2luZm8sX29mZnNldCkg
fQorCitzdHJ1Y3QgZmllbGRfbWFwcGluZyBmaWVsZHNbXSA9IHsKKwlURF9TWVNJTkZPX01B
UChNQVhfVERNUlMsCSAgICAgIG1heF90ZG1ycyksCisJVERfU1lTSU5GT19NQVAoTUFYX1JF
U0VSVkVEX1BFUl9URE1SLCBtYXhfcmVzZXJ2ZWRfcGVyX3RkbXIpLAorCVREX1NZU0lORk9f
TUFQKFBBTVRfNEtfRU5UUllfU0laRSwgICAgcGFtdF9lbnRyeV9zaXplW1REWF9QU180S10p
LAorCVREX1NZU0lORk9fTUFQKFBBTVRfMk1fRU5UUllfU0laRSwgICAgcGFtdF9lbnRyeV9z
aXplW1REWF9QU18yTV0pLAorCVREX1NZU0lORk9fTUFQKFBBTVRfMUdfRU5UUllfU0laRSwg
ICAgcGFtdF9lbnRyeV9zaXplW1REWF9QU18xR10pLAorfTsKKwogc3RhdGljIGludCBnZXRf
dGR4X3RkbXJfc3lzaW5mbyhzdHJ1Y3QgdGR4X3RkbXJfc3lzaW5mbyAqdGRtcl9zeXNpbmZv
KQogewogCWludCByZXQ7CisJaW50IGk7CiAKLQlyZXQgPSByZWFkX3N5c19tZXRhZGF0YV9m
aWVsZDE2KE1EX0ZJRUxEX0lEX01BWF9URE1SUywKLQkJCSZ0ZG1yX3N5c2luZm8tPm1heF90
ZG1ycyk7Ci0JaWYgKHJldCkKLQkJcmV0dXJuIHJldDsKLQotCXJldCA9IHJlYWRfc3lzX21l
dGFkYXRhX2ZpZWxkMTYoTURfRklFTERfSURfTUFYX1JFU0VSVkVEX1BFUl9URE1SLAotCQkJ
JnRkbXJfc3lzaW5mby0+bWF4X3Jlc2VydmVkX3Blcl90ZG1yKTsKLQlpZiAocmV0KQotCQly
ZXR1cm4gcmV0OwotCi0JcmV0ID0gcmVhZF9zeXNfbWV0YWRhdGFfZmllbGQxNihNRF9GSUVM
RF9JRF9QQU1UXzRLX0VOVFJZX1NJWkUsCi0JCQkmdGRtcl9zeXNpbmZvLT5wYW10X2VudHJ5
X3NpemVbVERYX1BTXzRLXSk7Ci0JaWYgKHJldCkKLQkJcmV0dXJuIHJldDsKKwlmb3IgKGkg
PSAwOyBpIDwgQVJSQVlfU0laRShmaWVsZHMpOyBpKyspIHsKKwkJcmV0ID0gcmVhZF9zeXNf
bWV0YWRhdGFfZmllbGQxNihmaWVsZHNbaV0uZmllbGRfaWQsCisJCQkJCQlmaWVsZHNbaV0u
b2Zmc2V0LAorCQkJCQkJdGRtcl9zeXNpbmZvKTsKKwkJaWYgKHJldCkKKwkJCXJldHVybiBy
ZXQ7CisJfQogCi0JcmV0ID0gcmVhZF9zeXNfbWV0YWRhdGFfZmllbGQxNihNRF9GSUVMRF9J
RF9QQU1UXzJNX0VOVFJZX1NJWkUsCi0JCQkmdGRtcl9zeXNpbmZvLT5wYW10X2VudHJ5X3Np
emVbVERYX1BTXzJNXSk7Ci0JaWYgKHJldCkKLQkJcmV0dXJuIHJldDsKLQotCXJldHVybiBy
ZWFkX3N5c19tZXRhZGF0YV9maWVsZDE2KE1EX0ZJRUxEX0lEX1BBTVRfMUdfRU5UUllfU0la
RSwKLQkJCSZ0ZG1yX3N5c2luZm8tPnBhbXRfZW50cnlfc2l6ZVtURFhfUFNfMUddKTsKKwly
ZXR1cm4gMDsKIH0KIAogc3RhdGljIGludCBpbml0X3RkeF9tb2R1bGUodm9pZCkKXwo=

--------------SgAPAoO5SU24KmWQvT1ZtW1K--

