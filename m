Return-Path: <kvm+bounces-73305-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AKnrJLvYrmmKJQIAu9opvQ
	(envelope-from <kvm+bounces-73305-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 15:27:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EDC7A23A81D
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 15:27:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C4B433064DA3
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 14:24:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0C2D38BF90;
	Mon,  9 Mar 2026 14:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UqXMVbWu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E747439E176
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 14:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773066262; cv=none; b=GT8l/RBIoQSvjx8+SIaGUcWKRcErfhxAz0BjXyrgvbET22I5T1G7Wl1s96pUuWyMVDkgkkY0yjXQDJzp7e5t7qi92+8feSkjluY17r9TC2FRwSlybSYLxjNA7Rs3RoUhVPHxtUT3IGIqaYIvqotlOTmJdAd6ABAQtW1LvJ6d6X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773066262; c=relaxed/simple;
	bh=oa4RRj1MEmah1cQS47aOJoe0nWsaTGjlqRdSOhg0FW8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nNscGAgBVjfCjX6OmKegrfOT+GCztsF8iQSeqF4IFgiUaZn+QH8KLPK8MRiIWzZ4PIc5gTvaD9w2PHLpiDYnMyGI4yDMqS3mHUy2DIias1QiQp+ek9/M4yq+PdA4W60/GOYOR+kl55z4Gn9j7/fJr8dYwZvQAzXZyisjeQI3zu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UqXMVbWu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23E4C4CEF7;
	Mon,  9 Mar 2026 14:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773066261;
	bh=oa4RRj1MEmah1cQS47aOJoe0nWsaTGjlqRdSOhg0FW8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UqXMVbWuyO1mKN8QmPOeNP9hOTaqcAM60IFp9IDeplVsfMyDVjK+ypTiw204BDvc1
	 wrEQhKDpTA407OK+JUGl47yuBAcfWuonoe8eOqOmjYbebinWXYH/zPFmT8fwPM+pwg
	 orLj52+gU8HOgwSC4EbRNQgF62R03ZlXx00hKBm6gbdnx2YjUJrMKHDPsskFWB056P
	 9HZJtjXiyNllbvDDZRatOa62Aw9M3jx3oE3kxW2gy3zMdWzDaHDzxDHVVZOQTJB13D
	 n3QHiUfuN99wRtlghHyu4+JMhqAZJlidbitxIQtk86S0oFdf4vEpnXhx9rsez+lTMS
	 1zQ+DOrVQ/hjA==
Message-ID: <ef8732cc-ba6b-4577-a1c0-c99234e6aebe@kernel.org>
Date: Mon, 9 Mar 2026 15:24:15 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] drivers/vfio_pci_core: Change PXD_ORDER check from
 switch case to if/else block
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>, linux-mm@kvack.org,
 kvm@vger.kernel.org, Alex Williamson <alex@shazbot.org>,
 Peter Xu <peterx@redhat.com>
References: <b155e19993ee1f5584c72050192eb468b31c5029.1773058761.git.ritesh.list@gmail.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <b155e19993ee1f5584c72050192eb468b31c5029.1773058761.git.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EDC7A23A81D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73305-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com,lists.ozlabs.org];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-0.971];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chleroy@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,outlook.com:url]
X-Rspamd-Action: no action



Le 09/03/2026 à 13:38, Ritesh Harjani (IBM) a écrit :
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

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

> ---
> v1 -> v2:
> 1. addressed review comments from Christophe [1]
> [1]: https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Flinuxppc-dev%2F0b8fce7a61561640634317a5e287cdb4794715fd.1772170860.git.ritesh.list%40gmail.com%2F&data=05%7C02%7Cchristophe.leroy%40csgroup.eu%7C2525bc52e4e645e2fb0208de7dd8d236%7C8b87af7d86474dc78df45f69a2011bb5%7C0%7C0%7C639086567353080039%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=DZuZX3hss7yYqBwYz61VgEY6J%2F7OuLViaTMYP43VoBY%3D&reserved=0
> 
>   drivers/vfio/pci/vfio_pci_core.c | 19 +++++++------------
>   1 file changed, 7 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index d43745fe4c84..0967307235b8 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1670,21 +1670,16 @@ vm_fault_t vfio_pci_vmf_insert_pfn(struct vfio_pci_core_device *vdev,
>   	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev))
>   		return VM_FAULT_SIGBUS;
> 
> -	switch (order) {
> -	case 0:
> +	if (!order)
>   		return vmf_insert_pfn(vmf->vma, vmf->address, pfn);
> -#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
> -	case PMD_ORDER:
> +
> +	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP) && order == PMD_ORDER)
>   		return vmf_insert_pfn_pmd(vmf, pfn, false);
> -#endif
> -#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
> -	case PUD_ORDER:
> +
> +	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) && order == PUD_ORDER)
>   		return vmf_insert_pfn_pud(vmf, pfn, false);
> -		break;
> -#endif
> -	default:
> -		return VM_FAULT_FALLBACK;
> -	}
> +
> +	return VM_FAULT_FALLBACK;
>   }
>   EXPORT_SYMBOL_GPL(vfio_pci_vmf_insert_pfn);
> 
> --
> 2.39.5
> 


