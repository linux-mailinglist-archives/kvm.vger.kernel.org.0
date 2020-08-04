Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81AFC23BB58
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 15:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgHDNq3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 09:46:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:51222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725826AbgHDNq3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 09:46:29 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EE162075D;
        Tue,  4 Aug 2020 13:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596548788;
        bh=roMCFNmPPkY9aOtB8mbdYYu8t78Z3ZS0O3Rhws1u9uE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ebOiwiw6ObunrZDT7PrvjzIBqiWke7wA41Iayk6OkmK6KmXuDxquLSr6joJ6RQz6D
         9zdmERHtU5Z+zeY4147ZiponZGJgLvcc98Y+Nzaargz1rPGaZMCR1UrttQMh1Jun8c
         aDQFAOYaJRFhnGNldBQbEEjc2jAiqKKBlbxvNxZk=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k2xGs-00HOpC-P7; Tue, 04 Aug 2020 14:46:26 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 04 Aug 2020 14:46:26 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com
Subject: Re: [PATCH  v1 3/3] kernel/configs: don't include PCI_QUIRKS in KVM
 guest configs
In-Reply-To: <20200804124417.27102-4-alex.bennee@linaro.org>
References: <20200804124417.27102-1-alex.bennee@linaro.org>
 <20200804124417.27102-4-alex.bennee@linaro.org>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <f80cfa932a650d8f7e8fc02a1656b4c2@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alex.bennee@linaro.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-08-04 13:44, Alex Bennée wrote:
> The VIRTIO_PCI support is an idealised PCI bus, we don't need a bunch
> of bloat for real world hardware for a VirtIO guest.

Who says this guest will only have virtio devices?

Or even, virtio devices without bugs? Given that said device can
come from any VMM, I'm not sure this is the right thing to do.

Thanks,

         M.

> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>  kernel/configs/kvm_guest.config | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/configs/kvm_guest.config 
> b/kernel/configs/kvm_guest.config
> index 208481d91090..672863a2fdf1 100644
> --- a/kernel/configs/kvm_guest.config
> +++ b/kernel/configs/kvm_guest.config
> @@ -13,6 +13,7 @@ CONFIG_IP_PNP_DHCP=y
>  CONFIG_BINFMT_ELF=y
>  CONFIG_PCI=y
>  CONFIG_PCI_MSI=y
> +CONFIG_PCI_QUIRKS=n
>  CONFIG_DEBUG_KERNEL=y
>  CONFIG_VIRTUALIZATION=y
>  CONFIG_HYPERVISOR_GUEST=y

-- 
Jazz is not dead. It just smells funny...
