Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86FA35E444
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 18:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbhDMQmo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 12:42:44 -0400
Received: from foss.arm.com ([217.140.110.172]:44928 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229714AbhDMQmm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 12:42:42 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 060F711B3;
        Tue, 13 Apr 2021 09:42:23 -0700 (PDT)
Received: from C02W217MHV2R.local (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 16C7F3F694;
        Tue, 13 Apr 2021 09:42:21 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests 7/8] chr-testdev: Silently fail init
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     alexandru.elisei@arm.com, andre.przywara@arm.com,
        eric.auger@redhat.com
References: <20210407185918.371983-1-drjones@redhat.com>
 <20210407185918.371983-8-drjones@redhat.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
Message-ID: <9963b86b-f32e-f1c4-e85b-5da8cd26c3db@arm.com>
Date:   Tue, 13 Apr 2021 17:42:20 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210407185918.371983-8-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/04/2021 19:59, Andrew Jones wrote:
> If there's no virtio-console / chr-testdev configured, then the user
> probably didn't want them. Just silently fail rather than stating
> the obvious.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

> ---
>   lib/chr-testdev.c | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/lib/chr-testdev.c b/lib/chr-testdev.c
> index 6890f63c8b29..b3c641a833fe 100644
> --- a/lib/chr-testdev.c
> +++ b/lib/chr-testdev.c
> @@ -54,11 +54,8 @@ void chr_testdev_init(void)
>   	int ret;
>   
>   	vcon = virtio_bind(VIRTIO_ID_CONSOLE);
> -	if (vcon == NULL) {
> -		printf("%s: %s: can't find a virtio-console\n",
> -				__func__, TESTDEV_NAME);
> +	if (vcon == NULL)
>   		return;
> -	}
>   
>   	ret = vcon->config->find_vqs(vcon, 2, vqs, NULL, io_names);
>   	if (ret < 0) {
> 
