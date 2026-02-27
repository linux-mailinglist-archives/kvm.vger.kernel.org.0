Return-Path: <kvm+bounces-72129-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cGLwCsY8oWnsrQQAu9opvQ
	(envelope-from <kvm+bounces-72129-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 07:42:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id C41111B358E
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 07:42:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2C64F303CEDC
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 06:42:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 715BE364952;
	Fri, 27 Feb 2026 06:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vKNKd87k"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89DE3603C5
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 06:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772174528; cv=none; b=qfU5mBypnQbkgckUyZ+1Pumg/F7wmPV3eK4zohGRWyrajLENVrcTduPCL7VvrCDs5mZ/HEkEXIIGAP4GHb8/UY85Qf8/3P0wlPhB1gbsUOP6xsrsT5TNcwK4losrOMHNVFpj6dMypMQlGsFFFCfZGa7yAYcFena9te9qtwnxpC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772174528; c=relaxed/simple;
	bh=l7o5vW4EQFZ93oUhFFbp3DYvB6UsG9r2GGJLzb9y3sc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SfjjFps4Gc0QiPoKjtzI6FphPQk+HAgyDunQuqYp8V8M8Wy+AS2GY8ej8Djwkn1nM81FKkjR4VwfnA6Og1TrwCva6w3UDxzkqkO4aAg/wxdtpTYwE+XGFbH3i5llaYc51oWs9LXf738SVNpyOy8C5R2hv65h+ivc6hMv776iXP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vKNKd87k; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E06DC116C6;
	Fri, 27 Feb 2026 06:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772174528;
	bh=l7o5vW4EQFZ93oUhFFbp3DYvB6UsG9r2GGJLzb9y3sc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vKNKd87k7g9018XjH0D3CkmNwOrKrNd6r7LM1V3s25Qm6Tpromm2h2AyabbuUj4i+
	 Hf/1bvJMM3gmHKUoF1a+3iudR/eskf1QQ9m0hTdphlmbMJZxMJutEnkQdrcqWOqFna
	 mxGhRAdy3nt3hBGmVydrDWS+Yc8IUU0TCL5KUJ3fSU6/5o64tXlJA1R2q+0TbaWZye
	 FEzshG1TBa/UdwaEZK4WZmFr5QWtnGi9k/+qfNkjzMmI8zbuCiGdRDfp++hgB60BzW
	 Wn7Q1zMkDebyVCNaAb3LOtiB8IV/fW6CRHRt75z59MiuV9aYiI13fsIe/TGfNWiq64
	 YvooidiS5oG3w==
Message-ID: <a864b2ed-1a77-4aac-b0e8-d97b4bf8be47@kernel.org>
Date: Fri, 27 Feb 2026 07:42:03 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1 1/2] drivers/vfio_pci_core: Change PXD_ORDER check from
 switch case to if/else block
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org, kvm@vger.kernel.org,
 Alex Williamson <alex@shazbot.org>, Peter Xu <peterx@redhat.com>
References: <0b8fce7a61561640634317a5e287cdb4794715fd.1772170860.git.ritesh.list@gmail.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <0b8fce7a61561640634317a5e287cdb4794715fd.1772170860.git.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72129-lists,kvm=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com,lists.ozlabs.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chleroy@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C41111B358E
X-Rspamd-Action: no action



Le 27/02/2026 à 07:16, Ritesh Harjani (IBM) a écrit :
> Architectures like PowerPC uses runtime defined values for
> PMD_ORDER/PUD_ORDER. This is because it can use either RADIX or HASH MMU
> at runtime using kernel cmdline. So the pXd_index_size is not known at
> compile time. Without this fix, when we add huge pfn support on powerpc
> in the next patch, vfio_pci_core driver compilation can fail with the
> following errors.
> 
>    CC [M]  drivers/vfio/vfio_main.o
>    CC [M]  drivers/vfio/group.o
>    CC [M]  drivers/vfio/container.o
>    CC [M]  drivers/vfio/virqfd.o
>    CC [M]  drivers/vfio/vfio_iommu_spapr_tce.o
>    CC [M]  drivers/vfio/pci/vfio_pci_core.o
>    CC [M]  drivers/vfio/pci/vfio_pci_intrs.o
>    CC [M]  drivers/vfio/pci/vfio_pci_rdwr.o
>    CC [M]  drivers/vfio/pci/vfio_pci_config.o
>    CC [M]  drivers/vfio/pci/vfio_pci.o
>    AR      kernel/built-in.a
> ../drivers/vfio/pci/vfio_pci_core.c: In function ‘vfio_pci_vmf_insert_pfn’:
> ../drivers/vfio/pci/vfio_pci_core.c:1678:9: error: case label does not reduce to an integer constant
>   1678 |         case PMD_ORDER:
>        |         ^~~~
> ../drivers/vfio/pci/vfio_pci_core.c:1682:9: error: case label does not reduce to an integer constant
>   1682 |         case PUD_ORDER:
>        |         ^~~~
> make[6]: *** [../scripts/Makefile.build:289: drivers/vfio/pci/vfio_pci_core.o] Error 1
> make[6]: *** Waiting for unfinished jobs....
> make[5]: *** [../scripts/Makefile.build:546: drivers/vfio/pci] Error 2
> make[5]: *** Waiting for unfinished jobs....
> make[4]: *** [../scripts/Makefile.build:546: drivers/vfio] Error 2
> make[3]: *** [../scripts/Makefile.build:546: drivers] Error 2
> 
> Fixes: f9e54c3a2f5b7 ("vfio/pci: implement huge_fault support")
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> ---
>   drivers/vfio/pci/vfio_pci_core.c | 15 +++++++--------
>   1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index d43745fe4c84..5395a6f30904 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1670,21 +1670,20 @@ vm_fault_t vfio_pci_vmf_insert_pfn(struct vfio_pci_core_device *vdev,
>   	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev))
>   		return VM_FAULT_SIGBUS;
> 
> -	switch (order) {
> -	case 0:
> +	if (order == 0) {
>   		return vmf_insert_pfn(vmf->vma, vmf->address, pfn);
> +	}

Those braces are unneeded as all legs of the if/else are single lines

>   #ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP

ifdef could be replaced by IS_ENABLED() because PxD_ORDER and 
vmf_insert_pfn_xxx() are declared all the time

> -	case PMD_ORDER:
> +	 else if (order == PMD_ORDER) {

'else' is not needed because every 'if' leads to a return statement

>   		return vmf_insert_pfn_pmd(vmf, pfn, false);
> +	 }
>   #endif
>   #ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
> -	case PUD_ORDER:
> +	 else if (order == PUD_ORDER) {
>   		return vmf_insert_pfn_pud(vmf, pfn, false);
> -		break;
> +	 }
>   #endif
> -	default:
> -		return VM_FAULT_FALLBACK;
> -	}
> +	return VM_FAULT_FALLBACK;

So at the end we should get something like:

	if (!order)
		return vmf_insert_pfn(vmf->vma, vmf->address, pfn);

	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP) && order == PMD_ORDER)
		return vmf_insert_pfn_pmd(vmf, pfn, false);

	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) && order == PMD_ORDER)
		return vmf_insert_pfn_pud(vmf, pfn, false);

	return VM_FAULT_FALLBACK;


>   }
>   EXPORT_SYMBOL_GPL(vfio_pci_vmf_insert_pfn);
> 
> --
> 2.53.0
> 
> 


