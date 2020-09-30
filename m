Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542EE27F169
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 20:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729143AbgI3Sgk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 14:36:40 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:58694 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI3Sgk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 14:36:40 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601490997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PR+4u0iF2BLBMfq+3fHnkGcyOOKUutVuuT2qZHGZ98Q=;
        b=4E1HTTViAIJcas2IXgwEtiQjb5QUMX6yZzDEQnTGQpLRPCtsGHo2JH0jc8NtW/faZgXYFJ
        l1K5xbs+pstgpUAVR+qsodkhg5Dw5MOMTqb93VWjIBTZcam99GjW5nehr/QuYx/1hgsPf3
        pYNcXggeNMmztZnivOJkGbA1jF0Yf63xd54y37f9kHSMzhXqqzTgIJgIRXrfe8UWdAujNX
        8OHcdG6vrX935YSJvHaan5hpacNmK+7JmafpTES4uOM959cGWnYaeQvpSIbuPaFlaUpjnh
        G2XKqvFX1WZpbF2A6++wU5Iyb4hkcpuetq8rRrbjejDBWu2/psVwRVfVkCdThQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601490997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PR+4u0iF2BLBMfq+3fHnkGcyOOKUutVuuT2qZHGZ98Q=;
        b=V/Rq6jQQobnS61rz3apq21GL3NbMdiFlEOU8ltngRKU8W6KZt1g6vzXXvYzsZlaMuoJVR3
        fXv7Tjm5G7p0X3AA==
To:     Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        megha.dey@intel.com, maz@kernel.org, bhelgaas@google.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, jgg@mellanox.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        jgg@mellanox.com, rafael@kernel.org, netanelg@mellanox.com,
        shahafs@mellanox.com, yan.y.zhao@linux.intel.com,
        pbonzini@redhat.com, samuel.ortiz@intel.com, mona.hossain@intel.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 04/18] dmaengine: idxd: add interrupt handle request support
In-Reply-To: <160021248280.67751.12525558281536923518.stgit@djiang5-desk3.ch.intel.com>
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com> <160021248280.67751.12525558281536923518.stgit@djiang5-desk3.ch.intel.com>
Date:   Wed, 30 Sep 2020 20:36:37 +0200
Message-ID: <87v9fvglhm.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 15 2020 at 16:28, Dave Jiang wrote:
>  
> +#define INT_HANDLE_IMS_TABLE	0x10000
> +int idxd_device_request_int_handle(struct idxd_device *idxd, int idx,
> +				   int *handle, enum idxd_interrupt_type irq_type)

New lines exist for a reason and this glued together define and function
definition is unreadable garbage.

Also is that magic bit a software flag or defined by hardware? If the
latter then you want to move it to the other hardware defines.

Thanks,

        tglx
 
