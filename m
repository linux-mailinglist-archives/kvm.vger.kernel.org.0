Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 972D836DCA2
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 18:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbhD1QEp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 12:04:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56307 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229891AbhD1QEo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Apr 2021 12:04:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619625839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VWzv79dhOfCvbQC5r24ANwFDN3FblWj9S+W4LOJP8aI=;
        b=AH0atEHN9RLYYW31H/+XOzi+f7mVc13bfyYmpTdFcqIRLCxaC8Kx2owtN7tSpAcDQzeF2t
        B8fKBI3vkH7tcWTtPofsopk2hunOP4nmN2nQft8piHpti2zu2dEkeZ49pReLk/KNTVj7FM
        8+wgHiBolxSG41nctPe2471PKy+VCaY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-twlKZOmxPieAYBHyNY03Sg-1; Wed, 28 Apr 2021 12:03:57 -0400
X-MC-Unique: twlKZOmxPieAYBHyNY03Sg-1
Received: by mail-wr1-f69.google.com with SMTP id l2-20020adf9f020000b029010d6bb7f1cbso1766555wrf.7
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 09:03:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VWzv79dhOfCvbQC5r24ANwFDN3FblWj9S+W4LOJP8aI=;
        b=lmcEV8e8xJ/ofMIG0f6ZaD14IalMFPjcYHF8eorWqlvDovNpggRQNL0P0GXCDSLyMM
         SEUb0XgisR7v3BW3b6Vaqg7Wh9ox8OtWjXCX09nt5BV46lf736D6rtMM5G+ph5wdDT8T
         zQ57onzdd2QRuLD6nXjuRfA74FMMiHlokiG/IdIiU4gk8rl2QmEKPBZfam7UW3ahAH7i
         sA/WT+PmTnhonu9lOM6SEnbGZa0T5Mn4pQjnYkxbeqhj8vjvAbKV3l6BKqm5aNgTnZJ+
         oPbl14yfI4w5VCvX9H4X2d1c2m18avaWBIlN2KkRBtIGKXEnRuXY6zEv5tK061N0yOz4
         voDQ==
X-Gm-Message-State: AOAM533D34TLolCQdHS5x2rzAFDZQZ+2mlUGH1NQEI9Y1XWP6g24SloY
        /Cbir6cwzG0dh7RSsWIVJe9IgWxHDIKi1IW6r6lQhVzAOEHe0CYDd/VnIu1Ia7XtDDZj/Oq6ZDk
        LVrdTVXjzZ0dnAHLAyWYZPRgs8IoXW7fSxzmGImT3OVe69GNKpLfUUZo7PciOYA==
X-Received: by 2002:adf:cd89:: with SMTP id q9mr10555920wrj.147.1619625836319;
        Wed, 28 Apr 2021 09:03:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw72dT/vsBEmhvsKrpp4jzv5dcu3oWBRWtHufZX4h+LqPGakBcS3KpBll1myBCN/rVv9xbJPA==
X-Received: by 2002:adf:cd89:: with SMTP id q9mr10555887wrj.147.1619625836111;
        Wed, 28 Apr 2021 09:03:56 -0700 (PDT)
Received: from [192.168.1.36] (39.red-81-40-121.staticip.rima-tde.net. [81.40.121.39])
        by smtp.gmail.com with ESMTPSA id x64sm107562wmg.46.2021.04.28.09.03.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 09:03:55 -0700 (PDT)
Subject: Re: [PATCH] accel: kvm: clarify that extra exit data is hexadecimal
To:     David Edmondson <david.edmondson@oracle.com>, qemu-devel@nongnu.org
Cc:     qemu-trivial@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org
References: <20210428142431.266879-1-david.edmondson@oracle.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <5fbad3c6-0219-9dad-2a04-98198dacb01f@redhat.com>
Date:   Wed, 28 Apr 2021 18:03:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210428142431.266879-1-david.edmondson@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/28/21 4:24 PM, David Edmondson wrote:
> When dumping the extra exit data provided by KVM, make it clear that
> the data is hexadecimal.
> 
> At the same time, zero-pad the output.
> 
> Signed-off-by: David Edmondson <david.edmondson@oracle.com>
> ---
>  accel/kvm/kvm-all.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>

