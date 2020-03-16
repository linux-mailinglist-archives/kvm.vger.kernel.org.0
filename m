Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA97A18714D
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 18:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732023AbgCPRht (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 13:37:49 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:42370 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731717AbgCPRhr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Mar 2020 13:37:47 -0400
X-Greylist: delayed 710 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Mar 2020 13:37:46 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584380266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=msg6kUjRhvxAi8DnVd/GQrZEQ8stJK5YC+wnR0yoRxI=;
        b=SLsCS8I+R19NJslzj1b5ZqtPNDk42Ra+KuHkXCMs/2p5/mygJqP19KcdMr+zZ+k734K+TO
        zs0sTz0Y7fdX8R0KK6yNJTEdS2mDNbvgCtUE8WyUvGxFSZXEqDUk2eXxv2HVhsGRKNEkTj
        iNZQZV7YoG6naeGd0jtj9m2Tw5QHZac=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-RNprkJGONFC63U9Ydr7DQQ-1; Mon, 16 Mar 2020 13:27:27 -0400
X-MC-Unique: RNprkJGONFC63U9Ydr7DQQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 84060915510;
        Mon, 16 Mar 2020 17:10:29 +0000 (UTC)
Received: from [10.36.118.12] (ovpn-118-12.ams2.redhat.com [10.36.118.12])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E26CB9B900;
        Mon, 16 Mar 2020 17:10:25 +0000 (UTC)
Subject: Re: [PATCH v5 06/23] irqchip/gic-v4.1: Advertise support v4.1 to KVM
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Robert Richter <rrichter@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-7-maz@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <12d3a655-1caf-39c0-7d80-f43b0d90677c@redhat.com>
Date:   Mon, 16 Mar 2020 18:10:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200304203330.4967-7-maz@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 3/4/20 9:33 PM, Marc Zyngier wrote:
> Tell KVM that we support v4.1. Nothing uses this information so far.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
>  drivers/irqchip/irq-gic-v3-its.c       | 9 ++++++++-
>  drivers/irqchip/irq-gic-v3.c           | 2 ++
>  include/linux/irqchip/arm-gic-common.h | 2 ++
>  3 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index fc5788584df7..bcc1a0957cda 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -4870,6 +4870,7 @@ int __init its_init(struct fwnode_handle *handle, struct rdists *rdists,
>  	struct device_node *of_node;
>  	struct its_node *its;
>  	bool has_v4 = false;
> +	bool has_v4_1 = false;
>  	int err;
>  
>  	gic_rdists = rdists;
> @@ -4890,8 +4891,14 @@ int __init its_init(struct fwnode_handle *handle, struct rdists *rdists,
>  	if (err)
>  		return err;
>  
> -	list_for_each_entry(its, &its_nodes, entry)
> +	list_for_each_entry(its, &its_nodes, entry) {
>  		has_v4 |= is_v4(its);
> +		has_v4_1 |= is_v4_1(its);
> +	}
> +
> +	/* Don't bother with inconsistent systems */
> +	if (WARN_ON(!has_v4_1 && rdists->has_rvpeid))
> +		rdists->has_rvpeid = false;
>  
>  	if (has_v4 & rdists->has_vlpis) {
>  		if (its_init_vpe_domain() ||
> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
> index ba405becab53..03e4eadefb00 100644
> --- a/drivers/irqchip/irq-gic-v3.c
> +++ b/drivers/irqchip/irq-gic-v3.c
> @@ -1785,6 +1785,7 @@ static void __init gic_of_setup_kvm_info(struct device_node *node)
>  		gic_v3_kvm_info.vcpu = r;
>  
>  	gic_v3_kvm_info.has_v4 = gic_data.rdists.has_vlpis;
> +	gic_v3_kvm_info.has_v4_1 = gic_data.rdists.has_rvpeid;
>  	gic_set_kvm_info(&gic_v3_kvm_info);
>  }
>  
> @@ -2100,6 +2101,7 @@ static void __init gic_acpi_setup_kvm_info(void)
>  	}
>  
>  	gic_v3_kvm_info.has_v4 = gic_data.rdists.has_vlpis;
> +	gic_v3_kvm_info.has_v4_1 = gic_data.rdists.has_rvpeid;
>  	gic_set_kvm_info(&gic_v3_kvm_info);
>  }
>  
> diff --git a/include/linux/irqchip/arm-gic-common.h b/include/linux/irqchip/arm-gic-common.h
> index b9850f5f1906..fa8c0455c352 100644
> --- a/include/linux/irqchip/arm-gic-common.h
> +++ b/include/linux/irqchip/arm-gic-common.h
> @@ -32,6 +32,8 @@ struct gic_kvm_info {
>  	struct resource vctrl;
>  	/* vlpi support */
>  	bool		has_v4;
> +	/* rvpeid support */
> +	bool		has_v4_1;
>  };
>  
>  const struct gic_kvm_info *gic_get_kvm_info(void);
> 

