Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0483C6684F8
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 22:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239946AbjALVFE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 16:05:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234131AbjALVDT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 16:03:19 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 621A5BC93
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 12:47:33 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id h184so217350iof.9
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 12:47:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Y33TCnC4aTVsOPz+eKs6ANS+v42Ifz3XrQ+jwhHqUTI=;
        b=ObYOd2UTQhbRFEokIARxDLMWIZ/pno5W+IFLwElvD2F6//NiJJoEpB18gOEPMVZNF2
         S95GWvK80yfBIIrvAcKrUJLPCmVFsFbymPwzQxMhXeY8/XflVzhYSqOFCD/bl+MQBhXF
         dv5CELBCQytLVbNtDkxivMNgdwcZGNpIiQwWqfdq7svmRjM03vxVLuRYt+/gZGm21dA2
         w8Xj3ZRntXkS7N9z83dzx9a5W1CNlosOWm3ckTaJLwfT85HwXa4xod5+TxMqzXjT5p/5
         vfJfVzS/FaLpK/iehVsVhdsNhAc5IQdCbUPkvGBjalKJp4tpoqR9NYP2JuflaVSWvOJ6
         de1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y33TCnC4aTVsOPz+eKs6ANS+v42Ifz3XrQ+jwhHqUTI=;
        b=6p+DUBKCptn4hDvx/663pEvac1ZjgujBlWqzVaM0AR1nNvzxlLS/F5lQ6vja4K/fqB
         ZYDjJ3n7p3OmT2nVolxlgjww/rniedroDAmV8HdOCjhZAlOuAKOT/PFXKlSlqmsEHAmN
         upi9f9E2U345zYcbsRRO4rsmv3s0TDf+h3zRGL4y2D63kWFWNcxz05NbIgzgiqDCAQms
         tN/GTEq82Ljgv7W/im6oGCoFNztkauPLUf29zAvE48N/++VSBmA4KOtjZXiStkMEYaCK
         LL5E3cXu8uPmASzH3zap96uH5BGiErCxopoHmSzrDlT1dQUnkcC7ZrpKcRJILDCsnTS1
         0TtQ==
X-Gm-Message-State: AFqh2koduC5Ku2BC0NJo0LD6v2PY8LC5bGBJ7A/rf7N30rqObqlbqo5j
        L6XsdKKkWGy86OqtR80BMFubzdJKU+3kvfaKEP3zcQ==
X-Google-Smtp-Source: AMrXdXuXcHHtAB+9TKlwl92wMAzc2QxA0XGfO5saf7T5G93StO021s1YFWnMHPVoFaiDG0eY3yPYnB6upaH+98os8S8=
X-Received: by 2002:a05:6638:388:b0:38a:89cc:20bc with SMTP id
 y8-20020a056638038800b0038a89cc20bcmr8097617jap.249.1673556452457; Thu, 12
 Jan 2023 12:47:32 -0800 (PST)
MIME-Version: 1.0
References: <20221214194056.161492-1-michael.roth@amd.com> <20221214194056.161492-30-michael.roth@amd.com>
In-Reply-To: <20221214194056.161492-30-michael.roth@amd.com>
From:   Alper Gun <alpergun@google.com>
Date:   Thu, 12 Jan 2023 12:47:21 -0800
Message-ID: <CABpDEum=-3_izZJYzQb4B2ef699f2R+SDWC-L2Ca-rPE5-ekpw@mail.gmail.com>
Subject: Re: [PATCH RFC v7 29/64] crypto: ccp: Handle the legacy SEV command
 when SNP is enabled
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, dgilbert@redhat.com,
        jarkko@kernel.org, ashish.kalra@amd.com, harald@profian.com,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 14, 2022 at 11:54 AM Michael Roth <michael.roth@amd.com> wrote:
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> The behavior of the SEV-legacy commands is altered when the SNP firmware
> is in the INIT state. When SNP is in INIT state, all the SEV-legacy
> commands that cause the firmware to write to memory must be in the
> firmware state before issuing the command..
>
> A command buffer may contains a system physical address that the firmware
> may write to. There are two cases that need to be handled:
>
> 1) system physical address points to a guest memory
> 2) system physical address points to a host memory
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
>  drivers/crypto/ccp/sev-dev.c | 370 ++++++++++++++++++++++++++++++++++-
>  drivers/crypto/ccp/sev-dev.h |  12 ++
>  2 files changed, 372 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 4c12e98a1219..5eb2e8f364d4 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -286,6 +286,30 @@ static int rmp_mark_pages_firmware(unsigned long paddr, unsigned int npages, boo
>         return rc;
>  }
>
> +static int rmp_mark_pages_shared(unsigned long paddr, unsigned int npages)
> +{
> +       /* Cbit maybe set in the paddr */
> +       unsigned long pfn = __sme_clr(paddr) >> PAGE_SHIFT;
> +       int rc, n = 0, i;
> +
> +       for (i = 0; i < npages; i++, pfn++, n++) {
> +               rc = rmp_make_shared(pfn, PG_LEVEL_4K);
> +               if (rc)
> +                       goto cleanup;
> +       }
> +
> +       return 0;
> +
> +cleanup:
> +       /*
> +        * If failed to change the page state to shared, then its not safe
> +        * to release the page back to the system, leak it.
> +        */
> +       snp_mark_pages_offline(pfn, npages - n);
> +
> +       return rc;
> +}
> +
>  static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order, bool locked)
>  {
>         unsigned long npages = 1ul << order, paddr;
> @@ -487,12 +511,295 @@ static int sev_write_init_ex_file_if_required(int cmd_id)
>         return sev_write_init_ex_file();
>  }
>
> +static int alloc_snp_host_map(struct sev_device *sev)
> +{
> +       struct page *page;
> +       int i;
> +
> +       for (i = 0; i < MAX_SNP_HOST_MAP_BUFS; i++) {
> +               struct snp_host_map *map = &sev->snp_host_map[i];
> +
> +               memset(map, 0, sizeof(*map));
> +
> +               page = alloc_pages(GFP_KERNEL_ACCOUNT, get_order(SEV_FW_BLOB_MAX_SIZE));
> +               if (!page)
> +                       return -ENOMEM;
> +
> +               map->host = page_address(page);
> +       }
> +
> +       return 0;
> +}
> +
> +static void free_snp_host_map(struct sev_device *sev)
> +{
> +       int i;
> +
> +       for (i = 0; i < MAX_SNP_HOST_MAP_BUFS; i++) {
> +               struct snp_host_map *map = &sev->snp_host_map[i];
> +
> +               if (map->host) {
> +                       __free_pages(virt_to_page(map->host), get_order(SEV_FW_BLOB_MAX_SIZE));
> +                       memset(map, 0, sizeof(*map));
> +               }
> +       }
> +}
> +
> +static int map_firmware_writeable(u64 *paddr, u32 len, bool guest, struct snp_host_map *map)
> +{
> +       unsigned int npages = PAGE_ALIGN(len) >> PAGE_SHIFT;
> +
> +       map->active = false;
> +
> +       if (!paddr || !len)
> +               return 0;
> +
> +       map->paddr = *paddr;
> +       map->len = len;
> +
> +       /* If paddr points to a guest memory then change the page state to firmwware. */
> +       if (guest) {
> +               if (rmp_mark_pages_firmware(*paddr, npages, true))
> +                       return -EFAULT;
> +
> +               goto done;
> +       }
> +
> +       if (!map->host)
> +               return -ENOMEM;
> +
> +       /* Check if the pre-allocated buffer can be used to fullfil the request. */
> +       if (len > SEV_FW_BLOB_MAX_SIZE)
> +               return -EINVAL;
> +
> +       /* Transition the pre-allocated buffer to the firmware state. */
> +       if (rmp_mark_pages_firmware(__pa(map->host), npages, true))
> +               return -EFAULT;
> +
> +       /* Set the paddr to use pre-allocated firmware buffer */
> +       *paddr = __psp_pa(map->host);
> +
> +done:
> +       map->active = true;
> +       return 0;
> +}
> +
> +static int unmap_firmware_writeable(u64 *paddr, u32 len, bool guest, struct snp_host_map *map)
> +{
> +       unsigned int npages = PAGE_ALIGN(len) >> PAGE_SHIFT;
> +
> +       if (!map->active)
> +               return 0;
> +
> +       /* If paddr points to a guest memory then restore the page state to hypervisor. */
> +       if (guest) {
> +               if (snp_reclaim_pages(*paddr, npages, true))
> +                       return -EFAULT;
> +
> +               goto done;
> +       }
> +
> +       /*
> +        * Transition the pre-allocated buffer to hypervisor state before the access.
> +        *
> +        * This is because while changing the page state to firmware, the kernel unmaps
> +        * the pages from the direct map, and to restore the direct map the pages must
> +        * be transitioned back to the shared state.
> +        */
> +       if (snp_reclaim_pages(__pa(map->host), npages, true))
> +               return -EFAULT;
> +
> +       /* Copy the response data firmware buffer to the callers buffer. */
> +       memcpy(__va(__sme_clr(map->paddr)), map->host, min_t(size_t, len, map->len));
> +       *paddr = map->paddr;
> +
> +done:
> +       map->active = false;
> +       return 0;
> +}
> +
> +static bool sev_legacy_cmd_buf_writable(int cmd)
> +{
> +       switch (cmd) {
> +       case SEV_CMD_PLATFORM_STATUS:
> +       case SEV_CMD_GUEST_STATUS:
> +       case SEV_CMD_LAUNCH_START:
> +       case SEV_CMD_RECEIVE_START:
> +       case SEV_CMD_LAUNCH_MEASURE:
> +       case SEV_CMD_SEND_START:
> +       case SEV_CMD_SEND_UPDATE_DATA:
> +       case SEV_CMD_SEND_UPDATE_VMSA:
> +       case SEV_CMD_PEK_CSR:
> +       case SEV_CMD_PDH_CERT_EXPORT:
> +       case SEV_CMD_GET_ID:
> +       case SEV_CMD_ATTESTATION_REPORT:
> +               return true;
> +       default:
> +               return false;
> +       }
> +}
> +
> +#define prep_buffer(name, addr, len, guest, map) \
> +       func(&((typeof(name *))cmd_buf)->addr, ((typeof(name *))cmd_buf)->len, guest, map)
> +
> +static int __snp_cmd_buf_copy(int cmd, void *cmd_buf, bool to_fw, int fw_err)
> +{
> +       int (*func)(u64 *paddr, u32 len, bool guest, struct snp_host_map *map);
> +       struct sev_device *sev = psp_master->sev_data;
> +       bool from_fw = !to_fw;
> +
> +       /*
> +        * After the command is completed, change the command buffer memory to
> +        * hypervisor state.
> +        *
> +        * The immutable bit is automatically cleared by the firmware, so
> +        * no not need to reclaim the page.
> +        */
> +       if (from_fw && sev_legacy_cmd_buf_writable(cmd)) {
> +               if (rmp_mark_pages_shared(__pa(cmd_buf), 1))
> +                       return -EFAULT;

If we return here, we will skip calling unmap_firmware_writeable and
we will leak some pages in firmware state.

> +
> +               /* No need to go further if firmware failed to execute command. */
> +               if (fw_err)
> +                       return 0;
> +       }
> +
> +       if (to_fw)
> +               func = map_firmware_writeable;
> +       else
> +               func = unmap_firmware_writeable;
> +
> +       /*
> +        * A command buffer may contains a system physical address. If the address
> +        * points to a host memory then use an intermediate firmware page otherwise
> +        * change the page state in the RMP table.
> +        */
> +       switch (cmd) {
> +       case SEV_CMD_PDH_CERT_EXPORT:
> +               if (prep_buffer(struct sev_data_pdh_cert_export, pdh_cert_address,
> +                               pdh_cert_len, false, &sev->snp_host_map[0]))
> +                       goto err;
> +               if (prep_buffer(struct sev_data_pdh_cert_export, cert_chain_address,
> +                               cert_chain_len, false, &sev->snp_host_map[1]))
> +                       goto err;
> +               break;
> +       case SEV_CMD_GET_ID:
> +               if (prep_buffer(struct sev_data_get_id, address, len,
> +                               false, &sev->snp_host_map[0]))
> +                       goto err;
> +               break;
> +       case SEV_CMD_PEK_CSR:
> +               if (prep_buffer(struct sev_data_pek_csr, address, len,
> +                               false, &sev->snp_host_map[0]))
> +                       goto err;
> +               break;
> +       case SEV_CMD_LAUNCH_UPDATE_DATA:
> +               if (prep_buffer(struct sev_data_launch_update_data, address, len,
> +                               true, &sev->snp_host_map[0]))
> +                       goto err;
> +               break;
> +       case SEV_CMD_LAUNCH_UPDATE_VMSA:
> +               if (prep_buffer(struct sev_data_launch_update_vmsa, address, len,
> +                               true, &sev->snp_host_map[0]))
> +                       goto err;
> +               break;
> +       case SEV_CMD_LAUNCH_MEASURE:
> +               if (prep_buffer(struct sev_data_launch_measure, address, len,
> +                               false, &sev->snp_host_map[0]))
> +                       goto err;
> +               break;
> +       case SEV_CMD_LAUNCH_UPDATE_SECRET:
> +               if (prep_buffer(struct sev_data_launch_secret, guest_address, guest_len,
> +                               true, &sev->snp_host_map[0]))
> +                       goto err;
> +               break;
> +       case SEV_CMD_DBG_DECRYPT:
> +               if (prep_buffer(struct sev_data_dbg, dst_addr, len, false,
> +                               &sev->snp_host_map[0]))
> +                       goto err;
> +               break;
> +       case SEV_CMD_DBG_ENCRYPT:
> +               if (prep_buffer(struct sev_data_dbg, dst_addr, len, true,
> +                               &sev->snp_host_map[0]))
> +                       goto err;
> +               break;
> +       case SEV_CMD_ATTESTATION_REPORT:
> +               if (prep_buffer(struct sev_data_attestation_report, address, len,
> +                               false, &sev->snp_host_map[0]))
> +                       goto err;
> +               break;
> +       case SEV_CMD_SEND_START:
> +               if (prep_buffer(struct sev_data_send_start, session_address,
> +                               session_len, false, &sev->snp_host_map[0]))
> +                       goto err;
> +               break;
> +       case SEV_CMD_SEND_UPDATE_DATA:
> +               if (prep_buffer(struct sev_data_send_update_data, hdr_address, hdr_len,
> +                               false, &sev->snp_host_map[0]))
> +                       goto err;
> +               if (prep_buffer(struct sev_data_send_update_data, trans_address,
> +                               trans_len, false, &sev->snp_host_map[1]))
> +                       goto err;
> +               break;
> +       case SEV_CMD_SEND_UPDATE_VMSA:
> +               if (prep_buffer(struct sev_data_send_update_vmsa, hdr_address, hdr_len,
> +                               false, &sev->snp_host_map[0]))
> +                       goto err;
> +               if (prep_buffer(struct sev_data_send_update_vmsa, trans_address,
> +                               trans_len, false, &sev->snp_host_map[1]))
> +                       goto err;
> +               break;
> +       case SEV_CMD_RECEIVE_UPDATE_DATA:
> +               if (prep_buffer(struct sev_data_receive_update_data, guest_address,
> +                               guest_len, true, &sev->snp_host_map[0]))
> +                       goto err;
> +               break;
> +       case SEV_CMD_RECEIVE_UPDATE_VMSA:
> +               if (prep_buffer(struct sev_data_receive_update_vmsa, guest_address,
> +                               guest_len, true, &sev->snp_host_map[0]))
> +                       goto err;
> +               break;
> +       default:
> +               break;
> +       }
> +
> +       /* The command buffer need to be in the firmware state. */
> +       if (to_fw && sev_legacy_cmd_buf_writable(cmd)) {
> +               if (rmp_mark_pages_firmware(__pa(cmd_buf), 1, true))
> +                       return -EFAULT;

This function moves two separate pages to firmware state. First
calling map_firmware_writeable and second calling
rmp_mark_pages_firmware for cmd_buf.
In case rmp_mark_pages_firmware fails for cmd_buf, the page which has
already moved to firmware state in map_firmware_writeable should be
reclaimed.
This is a problem especially if we leak a guest owned page in firmware
state. Since this is used only by legacy SEV VMs, these leaked pages
will never be reclaimed back when destroying these VMs.

>
> +       }
> +
> +       return 0;
> +
> +err:
> +       return -EINVAL;
> +}
> +
> +static inline bool need_firmware_copy(int cmd)
> +{
> +       struct sev_device *sev = psp_master->sev_data;
> +
> +       /* After SNP is INIT'ed, the behavior of legacy SEV command is changed. */
> +       return ((cmd < SEV_CMD_SNP_INIT) && sev->snp_initialized) ? true : false;
> +}
> +
> +static int snp_aware_copy_to_firmware(int cmd, void *data)
> +{
> +       return __snp_cmd_buf_copy(cmd, data, true, 0);
> +}
> +
> +static int snp_aware_copy_from_firmware(int cmd, void *data, int fw_err)
> +{
> +       return __snp_cmd_buf_copy(cmd, data, false, fw_err);
> +}
> +
>  static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>  {
>         struct psp_device *psp = psp_master;
>         struct sev_device *sev;
>         unsigned int phys_lsb, phys_msb;
>         unsigned int reg, ret = 0;
> +       void *cmd_buf;
>         int buf_len;
>
>         if (!psp || !psp->sev_data)
> @@ -512,12 +819,28 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>          * work for some memory, e.g. vmalloc'd addresses, and @data may not be
>          * physically contiguous.
>          */
> -       if (data)
> -               memcpy(sev->cmd_buf, data, buf_len);
> +       if (data) {
> +               if (sev->cmd_buf_active > 2)
> +                       return -EBUSY;
> +
> +               cmd_buf = sev->cmd_buf_active ? sev->cmd_buf_backup : sev->cmd_buf;
> +
> +               memcpy(cmd_buf, data, buf_len);
> +               sev->cmd_buf_active++;
> +
> +               /*
> +                * The behavior of the SEV-legacy commands is altered when the
> +                * SNP firmware is in the INIT state.
> +                */
> +               if (need_firmware_copy(cmd) && snp_aware_copy_to_firmware(cmd, sev->cmd_buf))
> +                       return -EFAULT;
> +       } else {
> +               cmd_buf = sev->cmd_buf;
> +       }
>
>         /* Get the physical address of the command buffer */
> -       phys_lsb = data ? lower_32_bits(__psp_pa(sev->cmd_buf)) : 0;
> -       phys_msb = data ? upper_32_bits(__psp_pa(sev->cmd_buf)) : 0;
> +       phys_lsb = data ? lower_32_bits(__psp_pa(cmd_buf)) : 0;
> +       phys_msb = data ? upper_32_bits(__psp_pa(cmd_buf)) : 0;
>
>         dev_dbg(sev->dev, "sev command id %#x buffer 0x%08x%08x timeout %us\n",
>                 cmd, phys_msb, phys_lsb, psp_timeout);
> @@ -560,15 +883,24 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>                 ret = sev_write_init_ex_file_if_required(cmd);
>         }
>
> -       print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
> -                            buf_len, false);
> -
>         /*
>          * Copy potential output from the PSP back to data.  Do this even on
>          * failure in case the caller wants to glean something from the error.
>          */
> -       if (data)
> -               memcpy(data, sev->cmd_buf, buf_len);
> +       if (data) {
> +               /*
> +                * Restore the page state after the command completes.
> +                */
> +               if (need_firmware_copy(cmd) &&
> +                   snp_aware_copy_from_firmware(cmd, cmd_buf, ret))
> +                       return -EFAULT;
> +
> +               memcpy(data, cmd_buf, buf_len);
> +               sev->cmd_buf_active--;
> +       }
> +
> +       print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
> +                            buf_len, false);
>
>         return ret;
>  }
> @@ -1579,10 +1911,12 @@ int sev_dev_init(struct psp_device *psp)
>         if (!sev)
>                 goto e_err;
>
> -       sev->cmd_buf = (void *)devm_get_free_pages(dev, GFP_KERNEL, 0);
> +       sev->cmd_buf = (void *)devm_get_free_pages(dev, GFP_KERNEL, 1);
>         if (!sev->cmd_buf)
>                 goto e_sev;
>
> +       sev->cmd_buf_backup = (uint8_t *)sev->cmd_buf + PAGE_SIZE;
> +
>         psp->sev_data = sev;
>
>         sev->dev = dev;
> @@ -1648,6 +1982,12 @@ static void sev_firmware_shutdown(struct sev_device *sev)
>                 snp_range_list = NULL;
>         }
>
> +       /*
> +        * The host map need to clear the immutable bit so it must be free'd before the
> +        * SNP firmware shutdown.
> +        */
> +       free_snp_host_map(sev);
> +
>         sev_snp_shutdown(&error);
>  }
>
> @@ -1722,6 +2062,14 @@ void sev_pci_init(void)
>                                 dev_err(sev->dev, "SEV-SNP: failed to INIT error %#x\n", error);
>                         }
>                 }
> +
> +               /*
> +                * Allocate the intermediate buffers used for the legacy command handling.
> +                */
> +               if (alloc_snp_host_map(sev)) {
> +                       dev_notice(sev->dev, "Failed to alloc host map (disabling legacy SEV)\n");
> +                       goto skip_legacy;
> +               }
>         }
>
>         /* Obtain the TMR memory area for SEV-ES use */
> @@ -1739,12 +2087,14 @@ void sev_pci_init(void)
>                 dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
>                         error, rc);
>
> +skip_legacy:
>         dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_initialized ?
>                 "-SNP" : "", sev->api_major, sev->api_minor, sev->build);
>
>         return;
>
>  err:
> +       free_snp_host_map(sev);
>         psp_master->sev_data = NULL;
>  }
>
> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
> index 34767657beb5..19d79f9d4212 100644
> --- a/drivers/crypto/ccp/sev-dev.h
> +++ b/drivers/crypto/ccp/sev-dev.h
> @@ -29,11 +29,20 @@
>  #define SEV_CMDRESP_CMD_SHIFT          16
>  #define SEV_CMDRESP_IOC                        BIT(0)
>
> +#define MAX_SNP_HOST_MAP_BUFS          2
> +
>  struct sev_misc_dev {
>         struct kref refcount;
>         struct miscdevice misc;
>  };
>
> +struct snp_host_map {
> +       u64 paddr;
> +       u32 len;
> +       void *host;
> +       bool active;
> +};
> +
>  struct sev_device {
>         struct device *dev;
>         struct psp_device *psp;
> @@ -52,8 +61,11 @@ struct sev_device {
>         u8 build;
>
>         void *cmd_buf;
> +       void *cmd_buf_backup;
> +       int cmd_buf_active;
>
>         bool snp_initialized;
> +       struct snp_host_map snp_host_map[MAX_SNP_HOST_MAP_BUFS];
>  };
>
>  int sev_dev_init(struct psp_device *psp);
> --
> 2.25.1
>
