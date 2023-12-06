Return-Path: <kvm+bounces-3766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DB5080794C
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 21:22:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BCB011C20AF8
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 20:22:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1814F6F62A;
	Wed,  6 Dec 2023 20:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="UbDOGqzh"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EAD8181;
	Wed,  6 Dec 2023 12:22:21 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 105A740E00C9;
	Wed,  6 Dec 2023 20:22:18 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id vf3DdiCh_Bav; Wed,  6 Dec 2023 20:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1701894135; bh=ryopeQNWNsQaqPkdyPy2Qh1IoKrpD4SJ99n33evI0kE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UbDOGqzhT8SuBANzPSeO7uZMrzZFS6G5Yh2HNhk2HegKohiJfxIDQN77Ma2zi4cUh
	 FkIKDvOSSC3jQ0U/kVDh16WgxcjVd+GDAWbR7aLgoJJxK/lIb23uuOsk0/urT1veO6
	 aPwUE1J/6EHR72e15S9tRf+2oD47a3Sycw2f/+pKXLky53sRg01SW6BQgfdY5JCw6d
	 CTyfmKlwGZR8+hba3NmOfB6QRBYWt4wjmKrIcMU+rQuY5aMzaYQ/qH3WR00MBpHEmF
	 HhZQ4ZrSrz29MDvd5tRfM51JL5c6GmGYC2kWd4yKRqaidORAJPlC11sPNMWJ7n7N4A
	 cMT2XvefsFMF296xYANuCsgQ1luRRjgyRMfijw3Crvwa9GT7q2ffOUoRLv18sS0MTH
	 exmaXvh9oKovzvQrlLRmaXsqLecG5b1YIhJhs3eZy+RPkV3FvGKT4RUIW3HnRD5Ir4
	 o8N/9LRffc/q2IKWxEKyQG6h0tEtX8BRohVbxCVamkUl+gWbtHjK7w7hcdp/hMEfsP
	 U9bjUsjj0Oy//hj4Yn2veXG5QPHc+s7bJN6BWrXiPK+zqfGdEttztXevAmSiEYuf0S
	 PynQAgjQmGgPj099UA8jHKCDQ+SgO5bzwGgRzv4K2PZeMRyGxsSwEfMNsf00kmBhbf
	 CEERiDwlaIi1VkTFDTYrwphs=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BAD8640E00C6;
	Wed,  6 Dec 2023 20:21:34 +0000 (UTC)
Date: Wed, 6 Dec 2023 21:21:28 +0100
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
Subject: Re: [PATCH v10 15/50] crypto: ccp: Provide API to issue SEV and SNP
 commands
Message-ID: <20231206202128.GDZXDXyIjW4eKEFyvB@fat_crate.local>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-16-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231016132819.1002933-16-michael.roth@amd.com>

On Mon, Oct 16, 2023 at 08:27:44AM -0500, Michael Roth wrote:

> Subject: Re: [PATCH v10 15/50] crypto: ccp: Provide API to issue SEV and SNP commands

"...: Export sev_do_cmd() as a generic API..."

> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> Make sev_do_cmd() a generic API interface for the hypervisor
> to issue commands to manage an SEV and SNP guest. The commands
> for SEV and SNP are defined in the SEV and SEV-SNP firmware
> specifications.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---

...

> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index a7f92e74564d..61bb5849ebf2 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -883,6 +883,20 @@ int sev_guest_df_flush(int *error);
>   */
>  int sev_guest_decommission(struct sev_data_decommission *data, int *error);
>  
> +/**

See below for the output of

./scripts/kernel-doc -none include/linux/psp-sev.h

I understand that you want to kernel-doc stuff but you should do it
right.

> + * sev_do_cmd - perform SEV command

"Issue an SEV or an SEV-SNP command"

> + *
> + * @error: SEV command return code

That must be @psp_ret.

And to quote the abovementioned script:

include/linux/psp-sev.h:898: warning: Function parameter or member 'cmd' not described in 'sev_do_cmd'
include/linux/psp-sev.h:898: warning: Function parameter or member 'data' not described in 'sev_do_cmd'
include/linux/psp-sev.h:898: warning: Function parameter or member 'psp_ret' not described in 'sev_do_cmd'
include/linux/psp-sev.h:898: warning: Excess function parameter 'error' description in 'sev_do_cmd'

> + *
> + * Returns:
> + * 0 if the SEV successfully processed the command

"the SEV"?

You mean the "SEV device"?

> + * -%ENODEV    if the SEV device is not available
> + * -%ENOTSUPP  if the SEV does not support SEV
> + * -%ETIMEDOUT if the SEV command timed out
> + * -%EIO       if the SEV returned a non-zero return code
> + */
> +int sev_do_cmd(int cmd, void *data, int *psp_ret);
> +
>  void *psp_copy_user_blob(u64 uaddr, u32 len);
>  
>  #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
> @@ -898,6 +912,9 @@ sev_guest_deactivate(struct sev_data_deactivate *data, int *error) { return -ENO
>  static inline int
>  sev_guest_decommission(struct sev_data_decommission *data, int *error) { return -ENODEV; }
>  
> +static inline int
> +sev_do_cmd(int cmd, void *data, int *psp_ret) { return -ENODEV; }
> +
>  static inline int
>  sev_guest_activate(struct sev_data_activate *data, int *error) { return -ENODEV; }
>  

include/linux/psp-sev.h:20: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * SEV platform state
include/linux/psp-sev.h:31: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * SEV platform and guest management commands
include/linux/psp-sev.h:126: warning: Function parameter or member 'reserved' not described in 'sev_data_init'
include/linux/psp-sev.h:146: warning: Function parameter or member 'reserved' not described in 'sev_data_init_ex'
include/linux/psp-sev.h:175: warning: expecting prototype for struct sev_data_cert_import. Prototype was for struct sev_data_pek_cert_import instead
include/linux/psp-sev.h:212: warning: Function parameter or member 'pdh_cert_address' not described in 'sev_data_pdh_cert_export'
include/linux/psp-sev.h:212: warning: Function parameter or member 'pdh_cert_len' not described in 'sev_data_pdh_cert_export'
include/linux/psp-sev.h:212: warning: Function parameter or member 'reserved' not described in 'sev_data_pdh_cert_export'
include/linux/psp-sev.h:276: warning: Function parameter or member 'reserved' not described in 'sev_data_launch_start'
include/linux/psp-sev.h:290: warning: Function parameter or member 'reserved' not described in 'sev_data_launch_update_data'
include/linux/psp-sev.h:304: warning: Function parameter or member 'reserved' not described in 'sev_data_launch_update_vmsa'
include/linux/psp-sev.h:318: warning: Function parameter or member 'reserved' not described in 'sev_data_launch_measure'
include/linux/psp-sev.h:342: warning: Function parameter or member 'reserved1' not described in 'sev_data_launch_secret'
include/linux/psp-sev.h:342: warning: Function parameter or member 'reserved2' not described in 'sev_data_launch_secret'
include/linux/psp-sev.h:342: warning: Function parameter or member 'reserved3' not described in 'sev_data_launch_secret'
include/linux/psp-sev.h:381: warning: Function parameter or member 'reserved1' not described in 'sev_data_send_start'
include/linux/psp-sev.h:381: warning: Function parameter or member 'reserved2' not described in 'sev_data_send_start'
include/linux/psp-sev.h:381: warning: Function parameter or member 'reserved3' not described in 'sev_data_send_start'
include/linux/psp-sev.h:405: warning: expecting prototype for struct sev_data_send_update. Prototype was for struct sev_data_send_update_data instead
include/linux/psp-sev.h:428: warning: expecting prototype for struct sev_data_send_update. Prototype was for struct sev_data_send_update_vmsa instead
include/linux/psp-sev.h:465: warning: Function parameter or member 'policy' not described in 'sev_data_receive_start'
include/linux/psp-sev.h:465: warning: Function parameter or member 'reserved1' not described in 'sev_data_receive_start'
include/linux/psp-sev.h:489: warning: Function parameter or member 'reserved1' not described in 'sev_data_receive_update_data'
include/linux/psp-sev.h:489: warning: Function parameter or member 'reserved2' not described in 'sev_data_receive_update_data'
include/linux/psp-sev.h:489: warning: Function parameter or member 'reserved3' not described in 'sev_data_receive_update_data'
include/linux/psp-sev.h:513: warning: Function parameter or member 'reserved1' not described in 'sev_data_receive_update_vmsa'
include/linux/psp-sev.h:513: warning: Function parameter or member 'reserved2' not described in 'sev_data_receive_update_vmsa'
include/linux/psp-sev.h:513: warning: Function parameter or member 'reserved3' not described in 'sev_data_receive_update_vmsa'
include/linux/psp-sev.h:538: warning: Function parameter or member 'reserved' not described in 'sev_data_dbg'
include/linux/psp-sev.h:554: warning: Function parameter or member 'reserved' not described in 'sev_data_attestation_report'
include/linux/psp-sev.h:585: warning: Function parameter or member 'gctx_paddr' not described in 'sev_data_snp_addr'
include/linux/psp-sev.h:605: warning: Function parameter or member 'gctx_paddr' not described in 'sev_data_snp_launch_start'
include/linux/psp-sev.h:605: warning: Function parameter or member 'ma_gctx_paddr' not described in 'sev_data_snp_launch_start'
include/linux/psp-sev.h:605: warning: Function parameter or member 'rsvd' not described in 'sev_data_snp_launch_start'
include/linux/psp-sev.h:605: warning: Function parameter or member 'gosvw' not described in 'sev_data_snp_launch_start'
include/linux/psp-sev.h:644: warning: Function parameter or member 'gctx_paddr' not described in 'sev_data_snp_launch_update'
include/linux/psp-sev.h:644: warning: Function parameter or member 'rsvd' not described in 'sev_data_snp_launch_update'
include/linux/psp-sev.h:644: warning: Function parameter or member 'rsvd2' not described in 'sev_data_snp_launch_update'
include/linux/psp-sev.h:644: warning: Function parameter or member 'rsvd3' not described in 'sev_data_snp_launch_update'
include/linux/psp-sev.h:644: warning: Function parameter or member 'rsvd4' not described in 'sev_data_snp_launch_update'
include/linux/psp-sev.h:659: warning: Function parameter or member 'gctx_paddr' not described in 'sev_data_snp_launch_finish'
include/linux/psp-sev.h:659: warning: Function parameter or member 'id_block_paddr' not described in 'sev_data_snp_launch_finish'
include/linux/psp-sev.h:659: warning: Function parameter or member 'id_auth_paddr' not described in 'sev_data_snp_launch_finish'
include/linux/psp-sev.h:659: warning: Function parameter or member 'id_block_en' not described in 'sev_data_snp_launch_finish'
include/linux/psp-sev.h:659: warning: Function parameter or member 'auth_key_en' not described in 'sev_data_snp_launch_finish'
include/linux/psp-sev.h:659: warning: Function parameter or member 'rsvd' not described in 'sev_data_snp_launch_finish'
include/linux/psp-sev.h:659: warning: Function parameter or member 'host_data' not described in 'sev_data_snp_launch_finish'
include/linux/psp-sev.h:705: warning: expecting prototype for struct sev_data_dbg. Prototype was for struct sev_data_snp_dbg instead
include/linux/psp-sev.h:718: warning: expecting prototype for struct sev_snp_guest_request. Prototype was for struct sev_data_snp_guest_request instead
include/linux/psp-sev.h:734: warning: expecting prototype for struct sev_data_snp_init. Prototype was for struct sev_data_snp_init_ex instead
include/linux/psp-sev.h:746: warning: Function parameter or member 'rsvd' not described in 'sev_data_range'
include/linux/psp-sev.h:758: warning: Function parameter or member 'rsvd' not described in 'sev_data_range_list'
include/linux/psp-sev.h:770: warning: Function parameter or member 'rsvd1' not described in 'sev_data_snp_shutdown_ex'
include/linux/psp-sev.h:825: warning: Function parameter or member 'filep' not described in 'sev_issue_cmd_external_user'
include/linux/psp-sev.h:825: warning: Function parameter or member 'id' not described in 'sev_issue_cmd_external_user'
include/linux/psp-sev.h:825: warning: Function parameter or member 'data' not described in 'sev_issue_cmd_external_user'
include/linux/psp-sev.h:840: warning: Function parameter or member 'data' not described in 'sev_guest_deactivate'
include/linux/psp-sev.h:840: warning: Function parameter or member 'error' not described in 'sev_guest_deactivate'
include/linux/psp-sev.h:840: warning: Excess function parameter 'deactivate' description in 'sev_guest_deactivate'
include/linux/psp-sev.h:840: warning: Excess function parameter 'sev_ret' description in 'sev_guest_deactivate'
include/linux/psp-sev.h:855: warning: Function parameter or member 'data' not described in 'sev_guest_activate'
include/linux/psp-sev.h:855: warning: Function parameter or member 'error' not described in 'sev_guest_activate'
include/linux/psp-sev.h:855: warning: Excess function parameter 'activate' description in 'sev_guest_activate'
include/linux/psp-sev.h:855: warning: Excess function parameter 'sev_ret' description in 'sev_guest_activate'
include/linux/psp-sev.h:869: warning: Function parameter or member 'error' not described in 'sev_guest_df_flush'
include/linux/psp-sev.h:869: warning: Excess function parameter 'sev_ret' description in 'sev_guest_df_flush'
include/linux/psp-sev.h:884: warning: Function parameter or member 'data' not described in 'sev_guest_decommission'
include/linux/psp-sev.h:884: warning: Function parameter or member 'error' not described in 'sev_guest_decommission'
include/linux/psp-sev.h:884: warning: Excess function parameter 'decommission' description in 'sev_guest_decommission'
include/linux/psp-sev.h:884: warning: Excess function parameter 'sev_ret' description in 'sev_guest_decommission'
include/linux/psp-sev.h:898: warning: Function parameter or member 'cmd' not described in 'sev_do_cmd'
include/linux/psp-sev.h:898: warning: Function parameter or member 'data' not described in 'sev_do_cmd'
include/linux/psp-sev.h:898: warning: Function parameter or member 'psp_ret' not described in 'sev_do_cmd'
include/linux/psp-sev.h:898: warning: Excess function parameter 'error' description in 'sev_do_cmd'

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

