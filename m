Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6D8274241
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 14:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgIVMnU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 08:43:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45067 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726563AbgIVMnU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 08:43:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600778598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hdDfIPkszB+oq8MEipfhVAGs4Jc9SzPikPPG+rOa0Eg=;
        b=JSkgx9PphkqpgyA6nmMrh2I+SHoSyrqb//Y97wHARQ0kdfLzzHyjOhcjyl8hnPxcLxlYbf
        uoIbmlZkLULQNHhl5WDvBd6tUrTiaRpMzAFHe2Q1xCZFOvbwcg7dXLPaAGXmtRBnCSuiqi
        ibbL49RonzGG+oxqdQbccj9IY8eACBc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-523-GUxj34YjMROzR4BSqGCkZg-1; Tue, 22 Sep 2020 08:43:17 -0400
X-MC-Unique: GUxj34YjMROzR4BSqGCkZg-1
Received: by mail-wm1-f69.google.com with SMTP id x81so857136wmg.8
        for <kvm@vger.kernel.org>; Tue, 22 Sep 2020 05:43:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hdDfIPkszB+oq8MEipfhVAGs4Jc9SzPikPPG+rOa0Eg=;
        b=DP8p56XgRQWuK/3DMYfFuVwfoFulCPqwKDB7sH2SEROXpYiD3RCUi+6US18f3Bg8Th
         sSxcSP2vlgzwB9yObOHfhwGC4R8V/yxZhvSCvCNaJ1x4qwUWu9Xwkxc2tolJZAKjvwSN
         9thQogCsn5c3OUvfrK/UzIIOrgiQn4bz0YrEoOvzyHk1ROwPCYdfhwVf6gbKw9oSC99Y
         HgTu/KF65zkuYIl6pB6s1VEShwt2DikmatjSBG3UKU2H0YBRbhVgmaKaDYcqNf5oqwq9
         wBnBmLSShPjLF6fiF4kR89AAwdI/bvNx4JBfJfUVQ3bqrv5uiH6QvVWeOKVWDc8sLYHf
         0ntg==
X-Gm-Message-State: AOAM532CNes5dLgNl9GuEph1TPCx5OCYW134nEe6030oKO7t6oox0cfj
        4KvIWa248N08SzgbOeCb9OjAlRxvYAmZCH6p3dkqWT+IJqkSwTqu4Lyou6QQ/B6ddGjDV6zJ6mh
        /UTZjUqkS8DAI
X-Received: by 2002:adf:ec4f:: with SMTP id w15mr4927382wrn.333.1600778596280;
        Tue, 22 Sep 2020 05:43:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwlYpb5HC1ZqinjgF1NmxdlGBvhDHuzFIdafVpb14tXR6I0O/+xA+GfB5yFf3c1E139RD3CTA==
X-Received: by 2002:adf:ec4f:: with SMTP id w15mr4927371wrn.333.1600778596103;
        Tue, 22 Sep 2020 05:43:16 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec2c:90a9:1236:ebc6? ([2001:b07:6468:f312:ec2c:90a9:1236:ebc6])
        by smtp.gmail.com with ESMTPSA id u2sm4411155wre.7.2020.09.22.05.43.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 05:43:15 -0700 (PDT)
Subject: Re: [PATCH] KVM: use struct_size() and flex_array_size() helpers in
 kvm_io_bus_unregister_dev()
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Rustam Kovhaev <rkovhaev@gmail.com>
Cc:     vkuznets@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
References: <20200918120500.954436-1-rkovhaev@gmail.com>
 <20200919000925.GA23967@embeddedor>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <65ab660e-fc93-bca5-d320-83b80a8dee59@redhat.com>
Date:   Tue, 22 Sep 2020 14:43:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200919000925.GA23967@embeddedor>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/09/20 02:09, Gustavo A. R. Silva wrote:
> Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Queued, without stable.  Thanks.

Paolo

