Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE5B25B76D
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 01:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgIBXw6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Sep 2020 19:52:58 -0400
Received: from gateway34.websitewelcome.com ([192.185.148.222]:43541 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726526AbgIBXw6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Sep 2020 19:52:58 -0400
X-Greylist: delayed 1495 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Sep 2020 19:52:57 EDT
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id F339511886D
        for <kvm@vger.kernel.org>; Wed,  2 Sep 2020 18:27:57 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id DcAXkbtz4OIGpDcAXk7ZgS; Wed, 02 Sep 2020 18:27:57 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:Subject:From:References:Cc:To:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=EW4k99M30Q/VptgdhFNBNYLBmFfFhol9OJvKWzARbcQ=; b=kZTxuF5A91oIy3nOmIxYCErVO6
        GOmTFy7yqzcQm8GjxP7Y1LqBk1lcfpM8Axtug2qgfO+TsZphRj7839DScU5kgG7Ibk/wWJ5eKhL4f
        0v//jR8VABQoI249k1A7wJ/QbhkroUKjpVqA7uXSCevWAij2IheBMV94lmcRii4lvmZSMFXIdZW2d
        T/K0bymLL0fhqSumNPFuBRJ8YFreStwUJyevji/587MYQ/d53v/5v5ka3J096zGo5nQCy+dG8ttwq
        jgQB1jiKeBTuRmvyxValGgAlu8J6yaLNsrvbAh0BGlgbk8HSkSkHdY6CAw9WmzfhhjTUOkaX5hZnv
        8HyJzaMw==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:57632 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <gustavo@embeddedor.com>)
        id 1kDcAX-003TtA-LT; Wed, 02 Sep 2020 18:27:57 -0500
To:     Rustam Kovhaev <rkovhaev@gmail.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
References: <20200902225718.675314-1-rkovhaev@gmail.com>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Autocrypt: addr=gustavo@embeddedor.com; keydata=
 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
 AP7RWS474w==
Subject: Re: [PATCH v2] KVM: fix memory leak in kvm_io_bus_unregister_dev()
Message-ID: <c5990c86-ab01-d748-5505-375f50a4ed7d@embeddedor.com>
Date:   Wed, 2 Sep 2020 18:34:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200902225718.675314-1-rkovhaev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1kDcAX-003TtA-LT
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:57632
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 4
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 9/2/20 17:57, Rustam Kovhaev wrote:
> when kmalloc() fails in kvm_io_bus_unregister_dev(), before removing
> the bus, we should iterate over all other devices linked to it and call
> kvm_iodevice_destructor() for them
> 
> Reported-and-tested-by: syzbot+f196caa45793d6374707@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=f196caa45793d6374707
> Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

I think it's worthwhile to add a Fixes tag for this, too.

Please, see more comments below...

> ---
> v2:
> - remove redundant whitespace
> - remove goto statement and use if/else
> ---
>  virt/kvm/kvm_main.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 67cd0b88a6b6..cf88233b819a 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4332,7 +4332,7 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
>  void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
>  			       struct kvm_io_device *dev)
>  {
> -	int i;
> +	int i, j;
>  	struct kvm_io_bus *new_bus, *bus;
>  
>  	bus = kvm_get_bus(kvm, bus_idx);
> @@ -4349,17 +4349,20 @@ void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
>  
>  	new_bus = kmalloc(struct_size(bus, range, bus->dev_count - 1),
>  			  GFP_KERNEL_ACCOUNT);
> -	if (!new_bus)  {
> +	if (new_bus) {
> +		memcpy(new_bus, bus, sizeof(*bus) + i * sizeof(struct kvm_io_range));

				    ^^^
It seems that you can use struct_size() here (see the allocation code above)...

> +		new_bus->dev_count--;
> +		memcpy(new_bus->range + i, bus->range + i + 1,
> +		       (new_bus->dev_count - i) * sizeof(struct kvm_io_range));

					   ^^^
...and, if possible, you can also use flex_array_size() here.

Thanks
--
Gustavo

> +	} else {
>  		pr_err("kvm: failed to shrink bus, removing it completely\n");
> -		goto broken;
> +		for (j = 0; j < bus->dev_count; j++) {
> +			if (j == i)
> +				continue;
> +			kvm_iodevice_destructor(bus->range[j].dev);
> +		}
>  	}
>  
> -	memcpy(new_bus, bus, sizeof(*bus) + i * sizeof(struct kvm_io_range));
> -	new_bus->dev_count--;
> -	memcpy(new_bus->range + i, bus->range + i + 1,
> -	       (new_bus->dev_count - i) * sizeof(struct kvm_io_range));
> -
> -broken:
>  	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
>  	synchronize_srcu_expedited(&kvm->srcu);
>  	kfree(bus);
> 
