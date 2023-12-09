Return-Path: <kvm+bounces-3986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28AF980B517
	for <lists+kvm@lfdr.de>; Sat,  9 Dec 2023 16:38:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 75194B20BAC
	for <lists+kvm@lfdr.de>; Sat,  9 Dec 2023 15:38:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCE1C168D2;
	Sat,  9 Dec 2023 15:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="lTtGvOEb"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6FD6A2;
	Sat,  9 Dec 2023 07:37:48 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8775340E00CC;
	Sat,  9 Dec 2023 15:37:45 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id TPP-M6g1rhSd; Sat,  9 Dec 2023 15:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1702136262; bh=HywvnxVu89INX/LatlIuwdPIGgckcuUtL9N1XjdzJ38=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lTtGvOEbZFFvp3ZsOpbV+zc8TGFDB3kMG/8DNXjpEXlnfL3BvkyqykYe5DthDl5h+
	 7wBW07E8StqzasbMEhoND1yJjRPqpxS8rzLyJ2PBY23MSXIMCsuZ3xgcuKCuEy44Pn
	 7aEGpFv1KnK9u+he1szmMCaNwtIta9GDehjv89B0PYjyd1Wdl4HEqLpf1l4Rlhfqqp
	 TjDBiHR83f1CpTFAuCtwJPgBE5fGhXiVBOVDFN7+5XWPCli1KS/YB6Rjv8SqKLRT7p
	 0T0C/OYH4qunmooiLoTh4uc3+yyowi3Pxh3TEAnqxzGvCBHF/qOVhUEsEz/Bx/mra0
	 3TfNd5SEwLfDUZPK+Q6/58CPRI6l6EAYdniDg9hLhffYRTclGre6r6yqCuZGck9PO4
	 1k8o+RpXyW6vxnBuPNI+gq/h22237co+rv3v9CjuiXjomHnaBmaXXQp8qGgLmuVaIX
	 f0DzAoyQWkYKfwcxmvYoowvmFMksMZZz3+pnbRyLByhhcXVyCJ45+qg30MIJl4/xEy
	 mzA0Jr7wFWNNwJYYXFXYqIGAezVEeuk7+cuCZeoZhDHryOJGRfz9eyd8hDqlrDayI3
	 ffTY8OkDq7rIPkJg4FnS9w67ONLBkNM3vhQNGLqaesVdJ4FLaSohrD5FjHcDhblbhR
	 D92CxP761a51/RdSm6GFat74=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2D9B740E00C5;
	Sat,  9 Dec 2023 15:37:02 +0000 (UTC)
Date: Sat, 9 Dec 2023 16:36:56 +0100
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
Subject: Re: [PATCH v10 18/50] crypto: ccp: Handle the legacy SEV command
 when SNP is enabled
Message-ID: <20231209153656.GGZXSJmNAyMUT+qIpQ@fat_crate.local>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-19-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231016132819.1002933-19-michael.roth@amd.com>

On Mon, Oct 16, 2023 at 08:27:47AM -0500, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The behavior of the SEV-legacy commands is altered when the SNP firmware
> is in the INIT state. When SNP is in INIT state, all the SEV-legacy
> commands that cause the firmware to write to memory must be in the
> firmware state before issuing the command..

I think this is trying to say that the *memory* must be in firmware
state before the command. Needs massaging.

> A command buffer may contains a system physical address that the firmware

"contain"

> may write to. There are two cases that need to be handled:
> 
> 1) system physical address points to a guest memory
> 2) system physical address points to a host memory

s/a //g
> 
> To handle the case #1, change the page state to the firmware in the RMP
> table before issuing the command and restore the state to shared after the
> command completes.
> 
> For the case #2, use a bounce buffer to complete the request.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 346 ++++++++++++++++++++++++++++++++++-
>  drivers/crypto/ccp/sev-dev.h |  12 ++
>  2 files changed, 348 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index ea21307a2b34..b574b0ef2b1f 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -462,12 +462,295 @@ static int sev_write_init_ex_file_if_required(int cmd_id)
>  	return sev_write_init_ex_file();
>  }
>  
> +static int alloc_snp_host_map(struct sev_device *sev)

If this is allocating intermediary bounce buffers, then call the
function that it does exactly that. Or what "host_map" is the name
referring to?

> +{
> +	struct page *page;
> +	int i;
> +
> +	for (i = 0; i < MAX_SNP_HOST_MAP_BUFS; i++) {
> +		struct snp_host_map *map = &sev->snp_host_map[i];
> +
> +		memset(map, 0, sizeof(*map));
> +
> +		page = alloc_pages(GFP_KERNEL_ACCOUNT, get_order(SEV_FW_BLOB_MAX_SIZE));
> +		if (!page)
> +			return -ENOMEM;

If the second allocation fails, you just leaked the first one.

> +		map->host = page_address(page);
> +	}
> +
> +	return 0;
> +}
> +
> +static void free_snp_host_map(struct sev_device *sev)
> +{
> +	int i;
> +
> +	for (i = 0; i < MAX_SNP_HOST_MAP_BUFS; i++) {
> +		struct snp_host_map *map = &sev->snp_host_map[i];
> +
> +		if (map->host) {
> +			__free_pages(virt_to_page(map->host), get_order(SEV_FW_BLOB_MAX_SIZE));
> +			memset(map, 0, sizeof(*map));
> +		}
> +	}
> +}
> +
> +static int map_firmware_writeable(u64 *paddr, u32 len, bool guest, struct snp_host_map *map)

Why is paddr a pointer? You simply pass a "unsigned long paddr" like the
rest of the gazillion functions dealing with addresses.

And then you do the ERR_PTR, PTR_ERR thing for the return value of this
function, see include/linux/err.h.

> +{
> +	unsigned int npages = PAGE_ALIGN(len) >> PAGE_SHIFT;
> +
> +	map->active = false;

This toggling of active on function entry and exit is silly.

The usual way to do those things is to mark it as active as the last
step of the map function, when everything has succeeded and to mark it
as inactive (active == false) as the first step in the unmap function.

> +
> +	if (!paddr || !len)
> +		return 0;
> +
> +	map->paddr = *paddr;
> +	map->len = len;
> +
> +	/* If paddr points to a guest memory then change the page state to firmwware. */
> +	if (guest) {
> +		if (rmp_mark_pages_firmware(*paddr, npages, true))
> +			return -EFAULT;
> +
> +		goto done;
> +	}

This is where it tells you that this function wants splitting:

map_guest_firmware_pages
map_host_firmware_pages

or so.

And then you lose the @guest argument too and you call the different
functions depending on the SEV cmd.

> +
> +	if (!map->host)

What in the hell is ->host?! SPA is host memory?

Comments please.

> +		return -ENOMEM;
> +
> +	/* Check if the pre-allocated buffer can be used to fullfil the request. */

"fulfill"

> +	if (len > SEV_FW_BLOB_MAX_SIZE)
> +		return -EINVAL;
> +
> +	/* Transition the pre-allocated buffer to the firmware state. */
> +	if (rmp_mark_pages_firmware(__pa(map->host), npages, true))
> +		return -EFAULT;
> +
> +	/* Set the paddr to use pre-allocated firmware buffer */
> +	*paddr = __psp_pa(map->host);
> +
> +done:
> +	map->active = true;
> +	return 0;
> +}


> +
> +static int unmap_firmware_writeable(u64 *paddr, u32 len, bool guest, struct snp_host_map *map)
> +{
> +	unsigned int npages = PAGE_ALIGN(len) >> PAGE_SHIFT;
> +
> +	if (!map->active)

Same comments as above for that one.

> +		return 0;
> +
> +	/* If paddr points to a guest memory then restore the page state to hypervisor. */
> +	if (guest) {
> +		if (snp_reclaim_pages(*paddr, npages, true))
> +			return -EFAULT;
> +
> +		goto done;
> +	}
> +
> +	/*
> +	 * Transition the pre-allocated buffer to hypervisor state before the access.
> +	 *
> +	 * This is because while changing the page state to firmware, the kernel unmaps
> +	 * the pages from the direct map, and to restore the direct map the pages must
> +	 * be transitioned back to the shared state.
> +	 */
> +	if (snp_reclaim_pages(__pa(map->host), npages, true))
> +		return -EFAULT;
> +
> +	/* Copy the response data firmware buffer to the callers buffer. */
> +	memcpy(__va(__sme_clr(map->paddr)), map->host, min_t(size_t, len, map->len));

This is not testing whether map->host is NULL as the above counterpart.

> +	*paddr = map->paddr;
> +
> +done:
> +	map->active = false;
> +	return 0;
> +}
> +
> +static bool sev_legacy_cmd_buf_writable(int cmd)
> +{
> +	switch (cmd) {
> +	case SEV_CMD_PLATFORM_STATUS:
> +	case SEV_CMD_GUEST_STATUS:
> +	case SEV_CMD_LAUNCH_START:
> +	case SEV_CMD_RECEIVE_START:
> +	case SEV_CMD_LAUNCH_MEASURE:
> +	case SEV_CMD_SEND_START:
> +	case SEV_CMD_SEND_UPDATE_DATA:
> +	case SEV_CMD_SEND_UPDATE_VMSA:
> +	case SEV_CMD_PEK_CSR:
> +	case SEV_CMD_PDH_CERT_EXPORT:
> +	case SEV_CMD_GET_ID:
> +	case SEV_CMD_ATTESTATION_REPORT:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
> +#define prep_buffer(name, addr, len, guest, map) \
> +	func(&((typeof(name *))cmd_buf)->addr, ((typeof(name *))cmd_buf)->len, guest, map)
> +
> +static int __snp_cmd_buf_copy(int cmd, void *cmd_buf, bool to_fw, int fw_err)
> +{
> +	int (*func)(u64 *paddr, u32 len, bool guest, struct snp_host_map *map);
> +	struct sev_device *sev = psp_master->sev_data;
> +	bool from_fw = !to_fw;
> +
> +	/*
> +	 * After the command is completed, change the command buffer memory to
> +	 * hypervisor state.
> +	 *
> +	 * The immutable bit is automatically cleared by the firmware, so
> +	 * no not need to reclaim the page.
> +	 */
> +	if (from_fw && sev_legacy_cmd_buf_writable(cmd)) {
> +		if (snp_reclaim_pages(__pa(cmd_buf), 1, true))
> +			return -EFAULT;
> +
> +		/* No need to go further if firmware failed to execute command. */
> +		if (fw_err)
> +			return 0;
> +	}
> +
> +	if (to_fw)
> +		func = map_firmware_writeable;
> +	else
> +		func = unmap_firmware_writeable;

Eww, ugly and with the macro above even worse. And completely
unnecessary.

Define prep_buffer() as a normal function which selects which @func to
call and then does it. Not like this.

...

> +static inline bool need_firmware_copy(int cmd)
> +{
> +	struct sev_device *sev = psp_master->sev_data;
> +
> +	/* After SNP is INIT'ed, the behavior of legacy SEV command is changed. */

"initialized"

> +	return ((cmd < SEV_CMD_SNP_INIT) && sev->snp_initialized) ? true : false;

redundant ternary conditional:

	return cmd < SEV_CMD_SNP_INIT && sev->snp_initialized;

> +}
> +
> +static int snp_aware_copy_to_firmware(int cmd, void *data)

What does "SNP aware" even mean?

> +{
> +	return __snp_cmd_buf_copy(cmd, data, true, 0);
> +}
> +
> +static int snp_aware_copy_from_firmware(int cmd, void *data, int fw_err)
> +{
> +	return __snp_cmd_buf_copy(cmd, data, false, fw_err);
> +}
> +
>  static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>  {
>  	struct psp_device *psp = psp_master;
>  	struct sev_device *sev;
>  	unsigned int phys_lsb, phys_msb;
>  	unsigned int reg, ret = 0;
> +	void *cmd_buf;
>  	int buf_len;
>  
>  	if (!psp || !psp->sev_data)
> @@ -487,12 +770,28 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>  	 * work for some memory, e.g. vmalloc'd addresses, and @data may not be
>  	 * physically contiguous.
>  	 */
> -	if (data)
> -		memcpy(sev->cmd_buf, data, buf_len);
> +	if (data) {
> +		if (sev->cmd_buf_active > 2)

What is that silly counter supposed to mean?

Nested SNP commands?

> +			return -EBUSY;
> +
> +		cmd_buf = sev->cmd_buf_active ? sev->cmd_buf_backup : sev->cmd_buf;
> +
> +		memcpy(cmd_buf, data, buf_len);
> +		sev->cmd_buf_active++;
> +
> +		/*
> +		 * The behavior of the SEV-legacy commands is altered when the
> +		 * SNP firmware is in the INIT state.
> +		 */
> +		if (need_firmware_copy(cmd) && snp_aware_copy_to_firmware(cmd, cmd_buf))

Move that need_firmware_copy() check inside snp_aware_copy_to_firmware()
and the other one.

> +			return -EFAULT;
> +	} else {
> +		cmd_buf = sev->cmd_buf;
> +	}
>  
>  	/* Get the physical address of the command buffer */
> -	phys_lsb = data ? lower_32_bits(__psp_pa(sev->cmd_buf)) : 0;
> -	phys_msb = data ? upper_32_bits(__psp_pa(sev->cmd_buf)) : 0;
> +	phys_lsb = data ? lower_32_bits(__psp_pa(cmd_buf)) : 0;
> +	phys_msb = data ? upper_32_bits(__psp_pa(cmd_buf)) : 0;
>  
>  	dev_dbg(sev->dev, "sev command id %#x buffer 0x%08x%08x timeout %us\n",
>  		cmd, phys_msb, phys_lsb, psp_timeout);

...

> @@ -639,6 +947,14 @@ static int ___sev_platform_init_locked(int *error, bool probe)
>  	if (probe && !psp_init_on_probe)
>  		return 0;
>  
> +	/*
> +	 * Allocate the intermediate buffers used for the legacy command handling.
> +	 */
> +	if (rc != -ENODEV && alloc_snp_host_map(sev)) {

Why isn't this

	if (!rc && ...)

> +		dev_notice(sev->dev, "Failed to alloc host map (disabling legacy SEV)\n");
> +		goto skip_legacy;

No need for that skip_legacy silly label. Just "return 0" here.

...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

