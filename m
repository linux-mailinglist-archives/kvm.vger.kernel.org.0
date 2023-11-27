Return-Path: <kvm+bounces-2534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BBA207FAC38
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 22:06:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5E379B213D4
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 21:06:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A71ED446B6;
	Mon, 27 Nov 2023 21:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bDxuXEUj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4386191;
	Mon, 27 Nov 2023 13:06:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701119175; x=1732655175;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to;
  bh=4n1yDLJtP711vsPZEFcMsExwQVwTZZH0PXUUX5LbydM=;
  b=bDxuXEUjGndciDnDQ3zd9uvuQSH9aVlLz9/lGF9eIyr9hWtc3QLr6HQu
   GcyaNc5nJr+3HWEXPfDwD4DBJ7KZvlQMYP1gmXcGXYLqg3PSXvrq5TWDK
   tqBTpGDY21OxggC/T7v+j2Lbr5ueJdlu69ctHGHuCy7MpIDnc0NwFsx0z
   utqltQTIsB7OY4qo67d2UVKgZPWksFW0Ys120ynAbj5H9mXufga6zFAwc
   6XML/WdM7LhcfNd1PRmxM3I/fY+F/asMDqJnk5uwbmtKAo1VTnBDOMcNq
   wjF5KHHm8P76vJ0KPo45MkXRwN2wCAgDe2jsLUoJFIpPkZm1US35OvwMw
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="377821109"
X-IronPort-AV: E=Sophos;i="6.04,231,1695711600"; 
   d="scan'208";a="377821109"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 13:06:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,231,1695711600"; 
   d="scan'208";a="9903684"
Received: from jdmart2-mobl1.amr.corp.intel.com (HELO [10.212.214.63]) ([10.212.214.63])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 13:06:13 -0800
Content-Type: multipart/mixed; boundary="------------5f0unhrBacraNETDx1LSn9t4"
Message-ID: <20266111-2f25-49c1-8cda-69eac40ad9f0@intel.com>
Date: Mon, 27 Nov 2023 13:06:12 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 17/23] x86/kexec: Flush cache of TDX private memory
Content-Language: en-US
To: "Huang, Kai" <kai.huang@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "Luck, Tony" <tony.luck@intel.com>,
 "david@redhat.com" <david@redhat.com>,
 "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
 "ak@linux.intel.com" <ak@linux.intel.com>,
 "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
 "mingo@redhat.com" <mingo@redhat.com>, "seanjc@google.com"
 <seanjc@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "nik.borisov@suse.com" <nik.borisov@suse.com>, "hpa@zytor.com"
 <hpa@zytor.com>, "sagis@google.com" <sagis@google.com>,
 "imammedo@redhat.com" <imammedo@redhat.com>,
 "peterz@infradead.org" <peterz@infradead.org>, "bp@alien8.de"
 <bp@alien8.de>, "Brown, Len" <len.brown@intel.com>,
 "sathyanarayanan.kuppuswamy@linux.intel.com"
 <sathyanarayanan.kuppuswamy@linux.intel.com>,
 "Huang, Ying" <ying.huang@intel.com>, "rafael@kernel.org"
 <rafael@kernel.org>, "Gao, Chao" <chao.gao@intel.com>
References: <cover.1699527082.git.kai.huang@intel.com>
 <2151c68079c1cb837d07bd8015e4ff1f662e1a6e.1699527082.git.kai.huang@intel.com>
 <cfea7192-4b29-46f9-a500-149121f493c8@intel.com>
 <e8fd4bff8244e9e709c997da309e73a932567959.camel@intel.com>
 <4ca2f6c1-97a7-4992-b01f-60341f6749ff@intel.com>
 <f74375b44d86f11843901a909e60bed228809677.camel@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <f74375b44d86f11843901a909e60bed228809677.camel@intel.com>

This is a multi-part message in MIME format.
--------------5f0unhrBacraNETDx1LSn9t4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/27/23 12:52, Huang, Kai wrote:
> --- a/arch/x86/kernel/machine_kexec_64.c
> +++ b/arch/x86/kernel/machine_kexec_64.c
> @@ -377,7 +377,8 @@ void machine_kexec(struct kimage *image)
>                                        (unsigned long)page_list,
>                                        image->start,
>                                        image->preserve_context,
> -
> cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT));
> +                                      cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT)
> ||
> +                                      platform_tdx_enabled());

Well, something more like the attached would be preferable, but you've
got the right idea logically.
--------------5f0unhrBacraNETDx1LSn9t4
Content-Type: text/x-patch; charset=UTF-8; name="cc-host-mem-incoherent.patch"
Content-Disposition: attachment; filename="cc-host-mem-incoherent.patch"
Content-Transfer-Encoding: base64

CgotLS0KCiBiL2FyY2gveDg2L2NvY28vY29yZS5jICAgICAgICAgICAgICAgfCAgICAxICsK
IGIvYXJjaC94ODYva2VybmVsL21hY2hpbmVfa2V4ZWNfNjQuYyB8ICAgIDIgKy0KIGIvaW5j
bHVkZS9saW51eC9jY19wbGF0Zm9ybS5oICAgICAgICB8ICAgMTYgKysrKysrKysrKysrKysr
KwogMyBmaWxlcyBjaGFuZ2VkLCAxOCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpk
aWZmIC1wdU4gaW5jbHVkZS9saW51eC9jY19wbGF0Zm9ybS5ofmNjLWhvc3QtbWVtLWluY29o
ZXJlbnQgaW5jbHVkZS9saW51eC9jY19wbGF0Zm9ybS5oCi0tLSBhL2luY2x1ZGUvbGludXgv
Y2NfcGxhdGZvcm0uaH5jYy1ob3N0LW1lbS1pbmNvaGVyZW50CTIwMjMtMTEtMjcgMTI6MjA6
NDQuMjE3MzgxMDA4IC0wODAwCisrKyBiL2luY2x1ZGUvbGludXgvY2NfcGxhdGZvcm0uaAky
MDIzLTExLTI3IDEyOjI1OjA1Ljc3MTA3MzE5MyAtMDgwMApAQCAtNDMsNiArNDMsMjIgQEAg
ZW51bSBjY19hdHRyIHsKIAlDQ19BVFRSX0hPU1RfTUVNX0VOQ1JZUFQsCiAKIAkvKioKKwkg
KiBAQ0NfQVRUUl9IT1NUX01FTV9JTkNPSEVSRU5UOiBIb3N0IG1lbW9yeSBlbmNyeXB0aW9u
IGNhbiBiZQorCSAqIGluY29oZXJlbnQKKwkgKgorCSAqIFRoZSBwbGF0Zm9ybS9PUyBpcyBy
dW5uaW5nIGFzIGEgYmFyZS1tZXRhbCBzeXN0ZW0gb3IgYSBoeXBlcnZpc29yLgorCSAqIFRo
ZSBtZW1vcnkgZW5jcnlwdGlvbiBlbmdpbmUgbWlnaHQgaGF2ZSBsZWZ0IG5vbi1jYWNoZS1j
b2hlcmVudAorCSAqIGRhdGEgaW4gdGhlIGNhY2hlcyB0aGF0IG5lZWRzIHRvIGJlIGZsdXNo
ZWQuCisJICoKKwkgKiBVc2UgdGhpcyBpbiBwbGFjZXMgd2hlcmUgdGhlIGNhY2hlIGNvaGVy
ZW5jeSBvZiB0aGUgbWVtb3J5IG1hdHRlcnMKKwkgKiBidXQgdGhlIGVuY3J5cHRpb24gc3Rh
dHVzIGRvZXMgbm90LgorCSAqCisJICogSW5jbHVkZXMgYWxsIHN5c3RlbXMgdGhhdCBzZXQg
Q0NfQVRUUl9IT1NUX01FTV9FTkNSWVBULCBidXQKKwkgKiBhZGl0aW9uYWxseSBhZGRzIFRE
WCBob3N0cy4KKwkgKi8KKwlDQ19BVFRSX0hPU1RfTUVNX0lOQ09IRVJFTlQsCisKKwkvKioK
IAkgKiBAQ0NfQVRUUl9HVUVTVF9NRU1fRU5DUllQVDogR3Vlc3QgbWVtb3J5IGVuY3J5cHRp
b24gaXMgYWN0aXZlCiAJICoKIAkgKiBUaGUgcGxhdGZvcm0vT1MgaXMgcnVubmluZyBhcyBh
IGd1ZXN0L3ZpcnR1YWwgbWFjaGluZSBhbmQgYWN0aXZlbHkKZGlmZiAtcHVOIGFyY2gveDg2
L2tlcm5lbC9tYWNoaW5lX2tleGVjXzY0LmN+Y2MtaG9zdC1tZW0taW5jb2hlcmVudCBhcmNo
L3g4Ni9rZXJuZWwvbWFjaGluZV9rZXhlY182NC5jCi0tLSBhL2FyY2gveDg2L2tlcm5lbC9t
YWNoaW5lX2tleGVjXzY0LmN+Y2MtaG9zdC1tZW0taW5jb2hlcmVudAkyMDIzLTExLTI3IDEy
OjI1OjEzLjUyNzExNTI2MCAtMDgwMAorKysgYi9hcmNoL3g4Ni9rZXJuZWwvbWFjaGluZV9r
ZXhlY182NC5jCTIwMjMtMTEtMjcgMTM6MDQ6MTkuNzMyOTU5MDAxIC0wODAwCkBAIC0zNjEs
NyArMzYxLDcgQEAgdm9pZCBtYWNoaW5lX2tleGVjKHN0cnVjdCBraW1hZ2UgKmltYWdlKQog
CQkJCSAgICAgICAodW5zaWduZWQgbG9uZylwYWdlX2xpc3QsCiAJCQkJICAgICAgIGltYWdl
LT5zdGFydCwKIAkJCQkgICAgICAgaW1hZ2UtPnByZXNlcnZlX2NvbnRleHQsCi0JCQkJICAg
ICAgIGNjX3BsYXRmb3JtX2hhcyhDQ19BVFRSX0hPU1RfTUVNX0VOQ1JZUFQpKTsKKwkJCQkg
ICAgICAgY2NfcGxhdGZvcm1faGFzKENDX0FUVFJfSE9TVF9NRU1fSU5DT0hFUkVOVCkpOwog
CiAjaWZkZWYgQ09ORklHX0tFWEVDX0pVTVAKIAlpZiAoaW1hZ2UtPnByZXNlcnZlX2NvbnRl
eHQpCmRpZmYgLXB1TiBhcmNoL3g4Ni9jb2NvL2NvcmUuY35jYy1ob3N0LW1lbS1pbmNvaGVy
ZW50IGFyY2gveDg2L2NvY28vY29yZS5jCi0tLSBhL2FyY2gveDg2L2NvY28vY29yZS5jfmNj
LWhvc3QtbWVtLWluY29oZXJlbnQJMjAyMy0xMS0yNyAxMjoyNjowMi41MzUzNzIzNzcgLTA4
MDAKKysrIGIvYXJjaC94ODYvY29jby9jb3JlLmMJMjAyMy0xMS0yNyAxMjoyNjoxMi4zNzE0
MjIyNDEgLTA4MDAKQEAgLTcwLDYgKzcwLDcgQEAgc3RhdGljIGJvb2wgbm9pbnN0ciBhbWRf
Y2NfcGxhdGZvcm1faGFzKAogCQlyZXR1cm4gc21lX21lX21hc2s7CiAKIAljYXNlIENDX0FU
VFJfSE9TVF9NRU1fRU5DUllQVDoKKwljYXNlIENDX0FUVFJfSE9TVF9NRU1fSU5DT0hFUkVO
VDoKIAkJcmV0dXJuIHNtZV9tZV9tYXNrICYmICEoc2V2X3N0YXR1cyAmIE1TUl9BTUQ2NF9T
RVZfRU5BQkxFRCk7CiAKIAljYXNlIENDX0FUVFJfR1VFU1RfTUVNX0VOQ1JZUFQ6Cl8K

--------------5f0unhrBacraNETDx1LSn9t4--

