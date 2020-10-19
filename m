Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D93EF292A20
	for <lists+kvm@lfdr.de>; Mon, 19 Oct 2020 17:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729879AbgJSPPf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Oct 2020 11:15:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31628 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729544AbgJSPPf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Oct 2020 11:15:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603120534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3GuCxEH6NC66WB/d5jeL09LL16+/33PIzDZ/FbKtTjQ=;
        b=DXF7BboKMvGSNoiXi3MpB08Ore3dHndmrX1pROyIKa9NSzsjcsTtKWRHfua5y5uDC3/azn
        yKGxTPjR+4/9NGCuIZc3i+kpOl/ybY4kkCJHbjYy/0zWek6+pmu7qQcTBNPrBbyMrmxosx
        Ipx5VtFyxC7pacZ8ZVFVUBO/BcnlqUo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-BDKra6W6MZWYNCFGjx0FgA-1; Mon, 19 Oct 2020 11:15:28 -0400
X-MC-Unique: BDKra6W6MZWYNCFGjx0FgA-1
Received: by mail-wm1-f72.google.com with SMTP id y83so51256wmc.8
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 08:15:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3GuCxEH6NC66WB/d5jeL09LL16+/33PIzDZ/FbKtTjQ=;
        b=W7492k3Fyj2c3iiHnuwfrj3i5pQYBRqp65tzm60mAc3corCxCTBAHF6oiLh0RQ5TKN
         qrAESIgB4PRZqvBftV7FsCdvtTgDR4mZkyeoHFsgK8mXDLte0yl0/hQkUgQ5pT2r6ZVh
         T5deBUl4PPAMM9mmtgRNYX/T3v2Zx1vKk99hJfGiCX0lhu15lwkab+x+zU+Z0uToGQcq
         YqYvNJwkQ6hwf1al3U2HprFMwaB3aYnyah413cwu6D5y9ZciyrZ2FN6BFLXtyKy/yU7d
         TtFcfs/NEORM/JBk6/+1PHQ4DoBPoP0okKnjqwu15see/fYOjPjQ+6+gK+1qKATIQ5YU
         hstQ==
X-Gm-Message-State: AOAM53105A2i3PVWMrpA6p1yaRjrZ/vRQfubxckaqb6feJkNBaW4FgAU
        Bavfxn3ldgOWl5S4hV51IfNTwfNF/u3NOwAqrzRCTIklivrN5lQtwILn25VdoERCN/KiWlg70SC
        j87H57KIuo+ai
X-Received: by 2002:a5d:4051:: with SMTP id w17mr58644wrp.24.1603120526986;
        Mon, 19 Oct 2020 08:15:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwpVeV5dOnyaTAsATZi7NALYUnUxRA3zEzxwvSpS88GeKSXlQK86A6gJGOVXXkmAJ/R0AoeYg==
X-Received: by 2002:a5d:4051:: with SMTP id w17mr58628wrp.24.1603120526816;
        Mon, 19 Oct 2020 08:15:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id t19sm426508wmi.26.2020.10.19.08.15.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2020 08:15:25 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] MAINTAINERS: Fix [An]drew's name
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
References: <20201001120224.72090-1-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7e337823-d267-e7ff-58cf-b073b08c9eaa@redhat.com>
Date:   Mon, 19 Oct 2020 17:15:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201001120224.72090-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/10/20 14:02, Andrew Jones wrote:
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 52a3eb6f764e..54124f6f1a5e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -61,7 +61,7 @@ Architecture Specific Code:
>  ---------------------------
>  
>  ARM
> -M: Drew Jones <drjones@redhat.com>
> +M: Andrew Jones <drjones@redhat.com>
>  L: kvm@vger.kernel.org
>  L: kvmarm@lists.cs.columbia.edu
>  F: arm/*
> 

Queued, thanks.

Paolo

