Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8CC7B62EB
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 09:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbjJCH5e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 03:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbjJCH5c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 03:57:32 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D504EA1;
        Tue,  3 Oct 2023 00:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696319848; x=1727855848;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=Jaw97fwQTJRMgjyL+30NMvRWupub7HmLVrt/CGiEHHM=;
  b=ELtAYsqvFnsET2tin/9Bn7vJ3urxNmyQwhLCDXtDZsgTZIviOdrm5Knu
   pQr2lExssC5gQ326YNgM3NQdutu+fSMdHZMjYm/rQE4oPgJ977fdaFYTJ
   UbPAzjWD+z8WPQdJqvskKGFxFZZ3XcJ7diWzxKug/Bikr+oxjfgi1u36g
   RuhQb3inrsObFTy4O7qUeJ8KLGzVfqUXEeS0rc2EoXZOXx0DpPq5ASLuZ
   s9Gl9v8ShdGYckEhEISl+QflYDQfYEcAOIrzrYcrSm6/ld2alShGKDAPh
   61dx2tcxDQCjR4yL3VESHxHRjsDGPsn36sOQjzw8cl7AOj4akbjCMZ1dt
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10851"; a="446977348"
X-IronPort-AV: E=Sophos;i="6.03,196,1694761200"; 
   d="scan'208";a="446977348"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2023 00:57:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10851"; a="821142123"
X-IronPort-AV: E=Sophos;i="6.03,196,1694761200"; 
   d="scan'208";a="821142123"
Received: from tciutacu-mobl.ger.corp.intel.com ([10.252.40.114])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2023 00:57:15 -0700
Date:   Tue, 3 Oct 2023 10:57:10 +0300 (EEST)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Lukas Wunner <lukas@wunner.de>
cc:     Bjorn Helgaas <helgaas@kernel.org>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-pci@vger.kernel.org, linux-cxl@vger.kernel.org,
        linux-coco@lists.linux.dev, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linuxarm@huawei.com, David Box <david.e.box@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Li, Ming" <ming4.li@intel.com>, Zhi Wang <zhi.a.wang@intel.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Wilfred Mallawa <wilfred.mallawa@wdc.com>,
        Alexey Kardashevskiy <aik@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Alexander Graf <graf@amazon.com>
Subject: Re: [PATCH 01/12] X.509: Make certificate parser public
In-Reply-To: <e3d7c94d89e09a6985ac2bf0a6d192b007f454bf.1695921657.git.lukas@wunner.de>
Message-ID: <cdabed9d-72f5-c125-fdf2-b9a3cd6030cc@linux.intel.com>
References: <cover.1695921656.git.lukas@wunner.de> <e3d7c94d89e09a6985ac2bf0a6d192b007f454bf.1695921657.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1636035145-1696319842=:2030"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1636035145-1696319842=:2030
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Thu, 28 Sep 2023, Lukas Wunner wrote:

> The upcoming support for PCI device authentication with CMA-SPDM
> (PCIe r6.1 sec 6.31) requires validating the Subject Alternative Name
> in X.509 certificates.
> 
> High-level functions for X.509 parsing such as key_create_or_update()
> throw away the internal, low-level struct x509_certificate after
> extracting the struct public_key and public_key_signature from it.
> The Subject Alternative Name is thus inaccessible when using those
> functions.
> 
> Afford CMA-SPDM access to the Subject Alternative Name by making struct
> x509_certificate public, together with the functions for parsing an
> X.509 certificate into such a struct and freeing such a struct.
> 
> The private header file x509_parser.h previously included <linux/time.h>
> for the definition of time64_t.  That definition was since moved to
> <linux/time64.h> by commit 361a3bf00582 ("time64: Add time64.h header
> and define struct timespec64"), so adjust the #include directive as part
> of the move to the new public header file <keys/x509-parser.h>.
> 
> No functional change intended.
> 
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> ---
>  crypto/asymmetric_keys/x509_parser.h | 37 +----------------------
>  include/keys/x509-parser.h           | 44 ++++++++++++++++++++++++++++
>  2 files changed, 45 insertions(+), 36 deletions(-)
>  create mode 100644 include/keys/x509-parser.h
> 
> diff --git a/crypto/asymmetric_keys/x509_parser.h b/crypto/asymmetric_keys/x509_parser.h
> index a299c9c56f40..a7ef43c39002 100644
> --- a/crypto/asymmetric_keys/x509_parser.h
> +++ b/crypto/asymmetric_keys/x509_parser.h
> @@ -5,40 +5,7 @@
>   * Written by David Howells (dhowells@redhat.com)
>   */
>  
> -#include <linux/time.h>
> -#include <crypto/public_key.h>
> -#include <keys/asymmetric-type.h>
> -
> -struct x509_certificate {
> -	struct x509_certificate *next;
> -	struct x509_certificate *signer;	/* Certificate that signed this one */
> -	struct public_key *pub;			/* Public key details */
> -	struct public_key_signature *sig;	/* Signature parameters */
> -	char		*issuer;		/* Name of certificate issuer */
> -	char		*subject;		/* Name of certificate subject */
> -	struct asymmetric_key_id *id;		/* Issuer + Serial number */
> -	struct asymmetric_key_id *skid;		/* Subject + subjectKeyId (optional) */
> -	time64_t	valid_from;
> -	time64_t	valid_to;
> -	const void	*tbs;			/* Signed data */
> -	unsigned	tbs_size;		/* Size of signed data */
> -	unsigned	raw_sig_size;		/* Size of signature */
> -	const void	*raw_sig;		/* Signature data */
> -	const void	*raw_serial;		/* Raw serial number in ASN.1 */
> -	unsigned	raw_serial_size;
> -	unsigned	raw_issuer_size;
> -	const void	*raw_issuer;		/* Raw issuer name in ASN.1 */
> -	const void	*raw_subject;		/* Raw subject name in ASN.1 */
> -	unsigned	raw_subject_size;
> -	unsigned	raw_skid_size;
> -	const void	*raw_skid;		/* Raw subjectKeyId in ASN.1 */
> -	unsigned	index;
> -	bool		seen;			/* Infinite recursion prevention */
> -	bool		verified;
> -	bool		self_signed;		/* T if self-signed (check unsupported_sig too) */
> -	bool		unsupported_sig;	/* T if signature uses unsupported crypto */
> -	bool		blacklisted;
> -};
> +#include <keys/x509-parser.h>
>  
>  /*
>   * selftest.c
> @@ -52,8 +19,6 @@ static inline int fips_signature_selftest(void) { return 0; }
>  /*
>   * x509_cert_parser.c
>   */
> -extern void x509_free_certificate(struct x509_certificate *cert);
> -extern struct x509_certificate *x509_cert_parse(const void *data, size_t datalen);
>  extern int x509_decode_time(time64_t *_t,  size_t hdrlen,
>  			    unsigned char tag,
>  			    const unsigned char *value, size_t vlen);
> diff --git a/include/keys/x509-parser.h b/include/keys/x509-parser.h
> new file mode 100644
> index 000000000000..7c2ebc84791f
> --- /dev/null
> +++ b/include/keys/x509-parser.h
> @@ -0,0 +1,44 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/* X.509 certificate parser
> + *
> + * Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
> + * Written by David Howells (dhowells@redhat.com)
> + */

Please add the include guard #ifndef + #define.

Other than that, this looks okay,

Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

-- 
 i.


> +
> +#include <crypto/public_key.h>
> +#include <keys/asymmetric-type.h>
> +#include <linux/time64.h>
> +
> +struct x509_certificate {
> +	struct x509_certificate *next;
> +	struct x509_certificate *signer;	/* Certificate that signed this one */
> +	struct public_key *pub;			/* Public key details */
> +	struct public_key_signature *sig;	/* Signature parameters */
> +	char		*issuer;		/* Name of certificate issuer */
> +	char		*subject;		/* Name of certificate subject */
> +	struct asymmetric_key_id *id;		/* Issuer + Serial number */
> +	struct asymmetric_key_id *skid;		/* Subject + subjectKeyId (optional) */
> +	time64_t	valid_from;
> +	time64_t	valid_to;
> +	const void	*tbs;			/* Signed data */
> +	unsigned	tbs_size;		/* Size of signed data */
> +	unsigned	raw_sig_size;		/* Size of signature */
> +	const void	*raw_sig;		/* Signature data */
> +	const void	*raw_serial;		/* Raw serial number in ASN.1 */
> +	unsigned	raw_serial_size;
> +	unsigned	raw_issuer_size;
> +	const void	*raw_issuer;		/* Raw issuer name in ASN.1 */
> +	const void	*raw_subject;		/* Raw subject name in ASN.1 */
> +	unsigned	raw_subject_size;
> +	unsigned	raw_skid_size;
> +	const void	*raw_skid;		/* Raw subjectKeyId in ASN.1 */
> +	unsigned	index;
> +	bool		seen;			/* Infinite recursion prevention */
> +	bool		verified;
> +	bool		self_signed;		/* T if self-signed (check unsupported_sig too) */
> +	bool		unsupported_sig;	/* T if signature uses unsupported crypto */
> +	bool		blacklisted;
> +};
> +
> +struct x509_certificate *x509_cert_parse(const void *data, size_t datalen);
> +void x509_free_certificate(struct x509_certificate *cert);
--8323329-1636035145-1696319842=:2030--
