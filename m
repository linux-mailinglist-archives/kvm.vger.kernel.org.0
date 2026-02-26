Return-Path: <kvm+bounces-72020-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OE1xNudxoGk7jwQAu9opvQ
	(envelope-from <kvm+bounces-72020-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:16:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id BD5101A9E7D
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:16:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8933D31840B2
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:05:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28BF443DA3E;
	Thu, 26 Feb 2026 15:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="busjz29t"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679D443E9C5
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 15:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772121481; cv=none; b=Ij8fypXZgmMfoOOb3hn7ASDewd9YC5Izgnce27NDV+1t6RvqBSspX8QfMMudezlnDhAAapCfcie+2ZCyQDTj/uS1cR0xlQK51H+swdSByPNV6SX/EHv/7c3oV8RwmUfriEAhWDARloIfoxaO1UgreBQhF/CycXgAC5THHty3oe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772121481; c=relaxed/simple;
	bh=pFENtf1PLuTlptv7aTYc9wD6eepcLaVhZA0dSQ3FgDg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kjugUpNpBlVWy6rVn9Psfp5oLawB4rYACcDa6KHVF5931rTzyUWJ2XbJkKhF1pFQ1b1hipY4x0bMZPqwm8QCLxNaNX6Undj3yBLvcNbJTHpTayVeSha79SmPcth9XJeVNu+Puz+kwUCytjIUtkEH8eOsjOPN33MTjOP6RCaDCrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=busjz29t; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6071EC19424;
	Thu, 26 Feb 2026 15:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121480;
	bh=pFENtf1PLuTlptv7aTYc9wD6eepcLaVhZA0dSQ3FgDg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=busjz29t3dJvMFnpJC8bSIEDhV6k6BlSzlQe6gdQgjYd3dIi48A+K+CpJcPN+Ezl8
	 TDdMYAnQosH7H5UB/EAN0uKVAlMZQS+4U/N634zloMARaSrn57SWWvGWBoMFrMPYKg
	 6XncwfRf2K8lIi5Im+NJoCejKReEHTKI1RTJIk7sA6NcipRx0LMg5oyhG8PwfGXJ9e
	 FtZfd+BUZrZ7mrXd87GS1mRvfxP5ONQ3tF50wDePdgtYufYngdWbvBBknw5NArAjnD
	 Ia9l6lOjQwrtwhe8pa7IFpCJhrs1JCgp8R5qoWazPhG5U4B04nWksW5nV/vOFEgqc6
	 5BQi09VEO2I+A==
Message-ID: <a00dfa12-e10d-45c6-956a-fd0acc8f82b9@kernel.org>
Date: Thu, 26 Feb 2026 16:57:54 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/15] virtio-mem: use warn_report_err_once()
To: marcandre.lureau@redhat.com, qemu-devel@nongnu.org
Cc: Ben Chaney <bchaney@akamai.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Alex Williamson <alex@shazbot.org>,
 Fabiano Rosas <farosas@suse.de>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
 Mark Kanda <mark.kanda@oracle.com>
References: <20260226140001.3622334-1-marcandre.lureau@redhat.com>
 <20260226140001.3622334-4-marcandre.lureau@redhat.com>
From: David Hildenbrand <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20260226140001.3622334-4-marcandre.lureau@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72020-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[david@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BD5101A9E7D
X-Rspamd-Action: no action

On 2/26/26 14:59, marcandre.lureau@redhat.com wrote:
> From: Marc-André Lureau <marcandre.lureau@redhat.com>
> 
> Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
> Reviewed-by: Cédric Le Goater <clg@redhat.com>
> ---
>  hw/virtio/virtio-mem.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
> 
> diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
> index 251d1d50aaa..a4b71974a1c 100644
> --- a/hw/virtio/virtio-mem.c
> +++ b/hw/virtio/virtio-mem.c
> @@ -594,18 +594,7 @@ static int virtio_mem_set_block_state(VirtIOMEM *vmem, uint64_t start_gpa,
>          Error *local_err = NULL;
>  
>          if (!qemu_prealloc_mem(fd, area, size, 1, NULL, false, &local_err)) {
> -            static bool warned;
> -
> -            /*
> -             * Warn only once, we don't want to fill the log with these
> -             * warnings.
> -             */
> -            if (!warned) {
> -                warn_report_err(local_err);
> -                warned = true;
> -            } else {
> -                error_free(local_err);
> -            }
> +            warn_report_err_once(local_err);
>              ret = -EBUSY;
>          }
>      }

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David


