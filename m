Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864D34065F8
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 05:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhIJDTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 23:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhIJDTW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 23:19:22 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3313AC061574
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 20:18:12 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id c19-20020a9d6153000000b0051829acbfc7so433612otk.9
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 20:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qCAr61hpoK6IKG40PpJaKVqIxCQSvqZ6i3qbQqvhygc=;
        b=XjDL0OYY74Mq3fMUE3D498DEIpvbWZvfPnUKICeBvPjA69xmSRNlHfBckOLkxZJMwq
         NPjAT1OcacqQuwHsHeUU7ksBviqq06IGCsnQK/0uiY1weBqIzL9NRvGWjgPKazFjFdLg
         NiS2ExZJlPA2Y6/tj9EvzDAmNW5u/fu7OcEhvZvtiOe1TtV2dY4lYCrVBIZsrefEiRN2
         h+jRjJA7x//dnjRmX5Xf2vwKNo7wwAqcXO5R2gLkEeyggnEclaNduCo3n8zLy+3An3HZ
         ZkGrwHWqoKQt7DpLVZc5jOU3SJa6n07Cmmlw0Ez1N0kU8AvFREm9u372nF2GzPUyRtcC
         /Yyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qCAr61hpoK6IKG40PpJaKVqIxCQSvqZ6i3qbQqvhygc=;
        b=BxBntUO3GpXNxZ48+/0PQz3tdUqKsJOLI1Kn6R4+EG/3JqP8v+XxNVoZyNTVALSl2I
         CBW8o4gvIo/x6PKX159dLRxu64gv8vXghkAofLZ9+83EycpVBhI9O9Bwi5ocjtCJMgWe
         q4bJNQp7ZawYU7pGTDU+IjTUkxqEcVY9SmM/rMT6nJafwmctjdRz3654fPWaS4fRuyhJ
         0QD7JmDt7wopnt7FgrboTnO6xldMEt6PO+DsNpQrD1apacwdmrwG2PzkWHplj7bM5BfB
         pXixW8epYvzIWRZ4lfgNEhKlt6K3Z1HPScmXkZBIYARknNJbPeBjE8QNJItM6nyyiFWW
         WAsw==
X-Gm-Message-State: AOAM5314FiCuMOhbntvT9WeYOBMl5Djmq3PwCMZfzT20zpNLMwvoH1Ej
        ngq6vUvYbJv/MSxfliIsyfdoozMxB1cD+2M6qqEdyQ==
X-Google-Smtp-Source: ABdhPJw96FbxjX9u29XaMK2DOTr9bF2gLcfjjJ3BYuB3Zi4eDiySYJk3VPNwLngCcJjsKH98YgYHoDG9VCw9IhvKbPA=
X-Received: by 2002:a05:6830:349c:: with SMTP id c28mr2849513otu.35.1631243891225;
 Thu, 09 Sep 2021 20:18:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210820155918.7518-1-brijesh.singh@amd.com> <20210820155918.7518-17-brijesh.singh@amd.com>
In-Reply-To: <20210820155918.7518-17-brijesh.singh@amd.com>
From:   Marc Orr <marcorr@google.com>
Date:   Thu, 9 Sep 2021 20:18:00 -0700
Message-ID: <CAA03e5EGXiw2dZ-c1-Vugor1d=vZPwrP81K0LmpUxTrLCbc+Xg@mail.gmail.com>
Subject: Re: [PATCH Part2 v5 16/45] crypto: ccp: Add the SNP_PLATFORM_STATUS command
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 20, 2021 at 9:00 AM Brijesh Singh <brijesh.singh@amd.com> wrote:
>
> The command can be used by the userspace to query the SNP platform status
> report. See the SEV-SNP spec for more details.
>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  Documentation/virt/coco/sevguest.rst | 27 +++++++++++++++++
>  drivers/crypto/ccp/sev-dev.c         | 45 ++++++++++++++++++++++++++++
>  include/uapi/linux/psp-sev.h         |  1 +
>  3 files changed, 73 insertions(+)
>
> diff --git a/Documentation/virt/coco/sevguest.rst b/Documentation/virt/coco/sevguest.rst
> index 7acb8696fca4..7c51da010039 100644
> --- a/Documentation/virt/coco/sevguest.rst
> +++ b/Documentation/virt/coco/sevguest.rst
> @@ -52,6 +52,22 @@ to execute due to the firmware error, then fw_err code will be set.
>                  __u64 fw_err;
>          };
>
> +The host ioctl should be called to /dev/sev device. The ioctl accepts command
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
> @@ -107,3 +123,14 @@ length of the blob is lesser than expected then snp_ext_report_req.certs_len wil
>  be updated with the expected value.
>
>  See GHCB specification for further detail on how to parse the certificate blob.
> +
> +2.3 SNP_PLATFORM_STATUS
> +-----------------------
> +:Technology: sev-snp
> +:Type: hypervisor ioctl cmd
> +:Parameters (in): struct sev_data_snp_platform_status
> +:Returns (out): 0 on success, -negative on error
> +
> +The SNP_PLATFORM_STATUS command is used to query the SNP platform status. The
> +status includes API major, minor version and more. See the SEV-SNP
> +specification for further details.
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 4cd7d803a624..16c6df5d412c 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1394,6 +1394,48 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>         return ret;
>  }
>
> +static int sev_ioctl_snp_platform_status(struct sev_issue_cmd *argp)
> +{
> +       struct sev_device *sev = psp_master->sev_data;
> +       struct sev_data_snp_platform_status_buf buf;
> +       struct page *status_page;
> +       void *data;
> +       int ret;
> +
> +       if (!sev->snp_inited || !argp->data)
> +               return -EINVAL;
> +
> +       status_page = alloc_page(GFP_KERNEL_ACCOUNT);
> +       if (!status_page)
> +               return -ENOMEM;
> +
> +       data = page_address(status_page);
> +       if (snp_set_rmp_state(__pa(data), 1, true, true, false)) {
> +               __free_pages(status_page, 0);
> +               return -EFAULT;
> +       }
> +
> +       buf.status_paddr = __psp_pa(data);
> +       ret = __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf, &argp->error);
> +
> +       /* Change the page state before accessing it */
> +       if (snp_set_rmp_state(__pa(data), 1, false, true, true)) {
> +               snp_leak_pages(__pa(data) >> PAGE_SHIFT, 1);

Calling `snp_leak_pages()` here seems wrong, because
`snp_set_rmp_state()` calls `snp_leak_pages()` when it returns an
error.

> +               return -EFAULT;
> +       }
> +
> +       if (ret)
> +               goto cleanup;
> +
> +       if (copy_to_user((void __user *)argp->data, data,
> +                        sizeof(struct sev_user_data_snp_status)))
> +               ret = -EFAULT;
> +
> +cleanup:
> +       __free_pages(status_page, 0);
> +       return ret;
> +}
> +
>  static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>  {
>         void __user *argp = (void __user *)arg;
> @@ -1445,6 +1487,9 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>         case SEV_GET_ID2:
>                 ret = sev_ioctl_do_get_id2(&input);
>                 break;
> +       case SNP_PLATFORM_STATUS:
> +               ret = sev_ioctl_snp_platform_status(&input);
> +               break;
>         default:
>                 ret = -EINVAL;
>                 goto out;
> diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
> index bed65a891223..ffd60e8b0a31 100644
> --- a/include/uapi/linux/psp-sev.h
> +++ b/include/uapi/linux/psp-sev.h
> @@ -28,6 +28,7 @@ enum {
>         SEV_PEK_CERT_IMPORT,
>         SEV_GET_ID,     /* This command is deprecated, use SEV_GET_ID2 */
>         SEV_GET_ID2,
> +       SNP_PLATFORM_STATUS,
>
>         SEV_MAX,
>  };
> --
> 2.17.1
>
>
