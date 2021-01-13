Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607F82F44C8
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 08:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbhAMHB2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 02:01:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49491 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725775AbhAMHB2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 02:01:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610521202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ixj4+yi0lETAF+ggllGxIF5hknlV3cJnCPByBZMlBGI=;
        b=PaApPGhxu1bJ1oAqMwT8EVEFIGB/WTz6ba9TB0Id+uU8UXb0ND+wM8bftWZ5QTJ1qCkanB
        HvNAd410sDCT98CX69aK4AxDC9elk3xEbrjdBWtX48oaHO/S5xNu3qoZsVZSmvBTmcuuMe
        +ch0Z8hLfYyvWtz761b1FL7AmVm4nT0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-vBKCDyURPLC2SeHZX_nPEQ-1; Wed, 13 Jan 2021 01:59:58 -0500
X-MC-Unique: vBKCDyURPLC2SeHZX_nPEQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA0048015D0;
        Wed, 13 Jan 2021 06:59:55 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-122.ams2.redhat.com [10.36.112.122])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 36D025C559;
        Wed, 13 Jan 2021 06:59:51 +0000 (UTC)
Subject: Re: [PATCH 2/9] configure: Add sys/timex.h to probe clk_adjtime
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>, qemu-devel@nongnu.org,
        QEMU Trivial <qemu-trivial@nongnu.org>
Cc:     Kevin Wolf <kwolf@redhat.com>, Fam Zheng <fam@euphon.net>,
        kvm@vger.kernel.org,
        Viktor Prutyanov <viktor.prutyanov@phystech.edu>,
        Laurent Vivier <lvivier@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        Greg Kurz <groug@kaod.org>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Max Reitz <mreitz@redhat.com>, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-block@nongnu.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        John Snow <jsnow@redhat.com>
References: <20201221005318.11866-1-jiaxun.yang@flygoat.com>
 <20201221005318.11866-3-jiaxun.yang@flygoat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <c4977db1-2f4e-22fd-9e40-1dcd11df7922@redhat.com>
Date:   Wed, 13 Jan 2021 07:59:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201221005318.11866-3-jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


In the subject:

s/clk_adjtime/clock_adjtime/

On 21/12/2020 01.53, Jiaxun Yang wrote:
> It is not a part of standard time.h. Glibc put it under
> time.h however musl treat it as a sys timex extension.
> 
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---
>   configure | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/configure b/configure
> index c228f7c21e..990f37e123 100755
> --- a/configure
> +++ b/configure
> @@ -4374,6 +4374,7 @@ fi
>   clock_adjtime=no
>   cat > $TMPC <<EOF
>   #include <time.h>
> +#include <sys/timex.h>
>   
>   int main(void)
>   {
> 

According to the man page:

  http://www.tin.org/bin/man.cgi?section=2&topic=clock_adjtime

sys/timex.h is indeed the right header here.

Reviewed-by: Thomas Huth <thuth@redhat.com>

