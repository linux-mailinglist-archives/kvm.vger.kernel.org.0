Return-Path: <kvm+bounces-4213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7836280F380
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 17:47:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1893BB20E55
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 16:47:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DFAF7B3A0;
	Tue, 12 Dec 2023 16:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="NdJgmgVe"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [IPv6:2a01:4f9:3051:3f93::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F0FCA;
	Tue, 12 Dec 2023 08:46:50 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A109740E00C9;
	Tue, 12 Dec 2023 16:46:47 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id qnttpbrXiaDF; Tue, 12 Dec 2023 16:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1702399604; bh=JgaP6s6ZQuPIIwAkFk4kUIsSkyeDb3qfZ2ZyjHtolEA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NdJgmgVeKvU8liYp3/47c6y/Ybc/cJYAHEezxdSbKUy6ElqCAo0iAf+oTOaEkIWft
	 MORuUbw0LS6WxLJAP+oW178zvH39uVgrKeitaYSimp4ZniVoTFpm4tplzCCZWa+dCF
	 nEK2W1q3AoHQk1XKuCwkU5XPtGmfItfQWKgJfwV/4mvbaY3yJbFF9BUGLyMI0CcHUc
	 cBK3rk8wxsuFTR9FfXLr1jImBJhajECjn9BSjh0F/Z6DDxFNKOMil3DGEnt0kbP4wA
	 Z7x5Hm31FpBcvuPU7I6ux5hmD8T1HOaDY5ZCc4T47RFgdcn99YAasSeHzjW4xrzMXo
	 AtmJG6LEHjWmQVNT5Xf0dmtkdYdmNhMhjl4rJtYX6BcTREH+PiN/ikFmDN1Ggl7TPz
	 ebN+Ni/9+86QlgNuLLfDJR6SF3ipr/QyNW+GOYvuhELllDxQrLvk0ofkoviLv5qs1f
	 umIQ6gwYHIr4jTQkbitmZ9oDHSxatGyqh6fh++IljKplFsClYZ3bYiB9j9rKiL7+9z
	 FrBmchtvqeczG949ntc5+H7NqfhaZz0vvt0Zu4abrbLmVrq81OmiSXtAI/vaaV2I5R
	 sFyHV7PrUD+sDS+qKZS+F72iKoizGDLyCvxq0YKw0dCRZVMGGs+mRiQUv44yGVUcYA
	 F6EulFumsy6QWxmrT/0qgJ4U=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3500E40E00CB;
	Tue, 12 Dec 2023 16:46:04 +0000 (UTC)
Date: Tue, 12 Dec 2023 17:45:57 +0100
From: Borislav Petkov <bp@alien8.de>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
	ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
	tony.luck@intel.com, marcorr@google.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v10 19/50] crypto: ccp: Add the SNP_PLATFORM_STATUS
 command
Message-ID: <20231212164557.GKZXiORUQjE8pCQBFk@fat_crate.local>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-20-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231016132819.1002933-20-michael.roth@amd.com>

On Mon, Oct 16, 2023 at 08:27:48AM -0500, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The command can be used by the userspace to query the SNP platform status

s/by the userspace //

> report. See the SEV-SNP spec for more details.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

Mike, this doesn't have your SOB at the end. The whole set should have
it if you're sending it. Please go through the whole thing.

> ---
>  Documentation/virt/coco/sev-guest.rst | 27 ++++++++++++++++
>  drivers/crypto/ccp/sev-dev.c          | 45 +++++++++++++++++++++++++++
>  include/uapi/linux/psp-sev.h          |  1 +
>  3 files changed, 73 insertions(+)
> 
> diff --git a/Documentation/virt/coco/sev-guest.rst b/Documentation/virt/coco/sev-guest.rst
> index 68b0d2363af8..e828c5326936 100644
> --- a/Documentation/virt/coco/sev-guest.rst
> +++ b/Documentation/virt/coco/sev-guest.rst
> @@ -67,6 +67,22 @@ counter (e.g. counter overflow), then -EIO will be returned.
>                  };
>          };
>  
> +The host ioctl should be called to /dev/sev device. The ioctl accepts commanda

"... should be sent to the... "

> +id and command input structure.
> +
> +::
> +        struct sev_issue_cmd {
> +                /* Command ID */
> +                __u32 cmd;
> +
> +                /* Command request structure */
> +                __u64 data;
> +
> +                /* firmware error code on failure (see psp-sev.h) */
> +                __u32 error;
> +        };
> +
> +
>  2.1 SNP_GET_REPORT
>  ------------------
>  
> @@ -124,6 +140,17 @@ be updated with the expected value.
>  
>  See GHCB specification for further detail on how to parse the certificate blob.
>  
> +2.4 SNP_PLATFORM_STATUS
> +-----------------------
> +:Technology: sev-snp
> +:Type: hypervisor ioctl cmd
> +:Parameters (in): struct sev_data_snp_platform_status
> +:Returns (out): 0 on success, -negative on error
> +
> +The SNP_PLATFORM_STATUS command is used to query the SNP platform status. The
> +status includes API major, minor version and more. See the SEV-SNP
> +specification for further details.
> +
>  3. SEV-SNP CPUID Enforcement
>  ============================
>  
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index b574b0ef2b1f..679b8d6fc09a 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1772,6 +1772,48 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  	return ret;
>  }
>  
> +static int sev_ioctl_snp_platform_status(struct sev_issue_cmd *argp)

sev_ioctl_do_snp_platform_status like the others.

> +{
> +	struct sev_device *sev = psp_master->sev_data;
> +	struct sev_data_snp_addr buf;
> +	struct page *status_page;
> +	void *data;
> +	int ret;
> +
> +	if (!sev->snp_initialized || !argp->data)
> +		return -EINVAL;
> +
> +	status_page = alloc_page(GFP_KERNEL_ACCOUNT);
> +	if (!status_page)
> +		return -ENOMEM;
> +
> +	data = page_address(status_page);
> +	if (rmp_mark_pages_firmware(__pa(data), 1, true)) {
> +		__free_pages(status_page, 0);
> +		return -EFAULT;

		ret = -EFAULT;
		goto cleanup;

instead.

...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

