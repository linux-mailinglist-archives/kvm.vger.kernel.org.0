Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1ED847DAE
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 10:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfFQI4p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 04:56:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35406 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbfFQI4o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 04:56:44 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B4498C05681F;
        Mon, 17 Jun 2019 08:56:44 +0000 (UTC)
Received: from [10.72.12.67] (ovpn-12-67.pek2.redhat.com [10.72.12.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23B7168434;
        Mon, 17 Jun 2019 08:56:40 +0000 (UTC)
Subject: Re: [PATCH] vhost_net: remove wrong 'unlikely' check
To:     huhai <huhai@kylinos.cn>, mst@redhat.com
Cc:     kvm@vger.kernel.org
References: <20190617085029.21730-1-huhai@kylinos.cn>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <47ef7f12-7152-6eb5-5bd1-320525af0fde@redhat.com>
Date:   Mon, 17 Jun 2019 16:56:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190617085029.21730-1-huhai@kylinos.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Mon, 17 Jun 2019 08:56:44 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019/6/17 下午4:50, huhai wrote:
> Since commit f9611c43ab0d ("vhost-net: enable zerocopy tx by default")
> experimental_zcopytx is set to true by default, so remove the unlikely check.
>
> Signed-off-by: huhai <huhai@kylinos.cn>
> ---
>   drivers/vhost/net.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 2d9df786a9d3..8c1dfd02372b 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -342,7 +342,7 @@ static bool vhost_net_tx_select_zcopy(struct vhost_net *net)
>   
>   static bool vhost_sock_zcopy(struct socket *sock)
>   {
> -	return unlikely(experimental_zcopytx) &&
> +	return experimental_zcopytx &&
>   		sock_flag(sock->sk, SOCK_ZEROCOPY);
>   }
>   


Thanks for the patch, actually I plan to disable zerocopy by default for 
various reasons. Let me post a patch and let's then decide.

