Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5FB331CF7
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 03:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhCICZj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 21:25:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31413 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230454AbhCICZV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 21:25:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615256720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lc5h0GfyvI7xx+Arv3sOyw+PpmTx52yrKALPXb2J8vk=;
        b=Dvu6NNyWoL3aAb4f2W5VplLHKFlL4vzH0Ao1ieEAJwHmxHuvi2+U/vZDyYiUjzARh5EHix
        I660RKzxTr9TBd34snQnsbN2xAcVBbK1fYU4RE2kqp5JkvtzYHqwNkW9wmR+6liqzEromE
        vsDBsfWqlHrsY7k4b5ewwiq++28McYs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-Wqq1xv3cNcOZ67RLXc7g1g-1; Mon, 08 Mar 2021 21:25:19 -0500
X-MC-Unique: Wqq1xv3cNcOZ67RLXc7g1g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6F0387504F;
        Tue,  9 Mar 2021 02:25:17 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-202.pek2.redhat.com [10.72.13.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8BF8B5D9D3;
        Tue,  9 Mar 2021 02:25:12 +0000 (UTC)
Subject: Re: [PATCH V2 4/4] vDPA/ifcvf: remove the version number string
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        lulu@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210308083525.382514-1-lingshan.zhu@intel.com>
 <20210308083525.382514-5-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <cdd01cc0-4741-cf6e-2f7d-7294bf03a7ff@redhat.com>
Date:   Tue, 9 Mar 2021 10:25:10 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210308083525.382514-5-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/3/8 4:35 下午, Zhu Lingshan wrote:
> This commit removes the version number string, using kernel
> version is enough.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---


Acked-by: Jason Wang <jasowang@redhat.com>


>   drivers/vdpa/ifcvf/ifcvf_main.c | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index fd5befc5cbcc..c34e1eec6b6c 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -14,7 +14,6 @@
>   #include <linux/sysfs.h>
>   #include "ifcvf_base.h"
>   
> -#define VERSION_STRING  "0.1"
>   #define DRIVER_AUTHOR   "Intel Corporation"
>   #define IFCVF_DRIVER_NAME       "ifcvf"
>   
> @@ -503,4 +502,3 @@ static struct pci_driver ifcvf_driver = {
>   module_pci_driver(ifcvf_driver);
>   
>   MODULE_LICENSE("GPL v2");
> -MODULE_VERSION(VERSION_STRING);

