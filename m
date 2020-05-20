Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8661DC061
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 22:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbgETUmR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 16:42:17 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:40089 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727041AbgETUmR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 May 2020 16:42:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590007335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o8obcu4RJyJ5SsFoPKEalBasJOWg/UMge1/Qyw2g7H4=;
        b=YjXyudE9MlSR0s+O6udRASvrie77Yofg97s3sFuVbPmklhIGrhyaZIEwZ9KVYhIgdLsU74
        2sMXhnC5H6lRIQE9e2Mmqp5F5vfeTylP4neFqoq4jIQFQVHYL607YiMt8sCzlnsaIFuIke
        LHE3mFiFfWXSrzG7qzyxi0jtzcE27nU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-inbqQl6LOzqh-zXL4i6fsw-1; Wed, 20 May 2020 16:42:14 -0400
X-MC-Unique: inbqQl6LOzqh-zXL4i6fsw-1
Received: by mail-ed1-f70.google.com with SMTP id t5so1796855edc.1
        for <kvm@vger.kernel.org>; Wed, 20 May 2020 13:42:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o8obcu4RJyJ5SsFoPKEalBasJOWg/UMge1/Qyw2g7H4=;
        b=ZcUZmrA5g+uctytj5oHEcIqGyeGx2nqwGhTpAcTN+pDl3snaNQGeGv4Q/uWmslMpds
         4LJ/1PLvYgbGeEETr1l01kVWX9b3rIEAnaVdpBOF9GOhiVD6TZXUErL4imP6WRiw2cOS
         3yzNM7AoO68azjiVJx7vDWygNTRF7eZDvmijCbqn4j+9s+ARtsNNWS438bwKky4lL99w
         t0e9re3ZWPpvcURN3YOwaodL2rPxI1LTPDR0TYMpYXYlBZYl/wARIa4ZftyCR6mEnnwV
         Yur0EGvspvRsPUSxEqKSnb0q1cqnYKuMDMD0pTik3gAP9uLCUqONWnHxNIfymxtSHQVI
         KqBQ==
X-Gm-Message-State: AOAM531ahSOFqIQ95pd3M+085diNdIIA6EZ8lrEuxJjKx1KWbp8zmv1l
        EOOjdICR1FYvPcfqddnNRJnby5MRM9wkrU8aE2vKGlBY6LNkem2iHudlXwUIlCqWR3YeZHNMII8
        DhsCbNOYW8quF
X-Received: by 2002:a50:ee15:: with SMTP id g21mr4962369eds.170.1590007333145;
        Wed, 20 May 2020 13:42:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxwelCdht1h/DJBFh9VXKA7BJoRU8H9J+/uLAg+4Euypi4HeaOVE1BVWG7K28wnyTkiFiv/gg==
X-Received: by 2002:a50:ee15:: with SMTP id g21mr4962360eds.170.1590007332892;
        Wed, 20 May 2020 13:42:12 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1c48:1dd8:fe63:e3da? ([2001:b07:6468:f312:1c48:1dd8:fe63:e3da])
        by smtp.gmail.com with ESMTPSA id qp13sm2900842ejb.8.2020.05.20.13.42.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2020 13:42:12 -0700 (PDT)
Subject: Re: [PATCH 00/24] KVM: nSVM: event fixes and migration support
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Joerg Roedel <jroedel@suse.de>
References: <20200520172145.23284-1-pbonzini@redhat.com>
 <6b8674fa647d3b80125477dc344581ba7adfb931.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cecf6c64-6828-5a3f-642a-11aac4cefa75@redhat.com>
Date:   Wed, 20 May 2020 22:42:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <6b8674fa647d3b80125477dc344581ba7adfb931.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/05/20 21:24, Maxim Levitsky wrote:
> Patch 24 doesn't apply cleanly on top of kvm/queue, I appplied it manually,
> due to missing KVM_STATE_NESTED_MTF_PENDING bit
> 
> Also patch 22 needes ALIGN_UP which is not on mainline.
> Probably in linux-next?

Just replace it with ALIGN.  (I tested it with memzero_user in
arch/x86/kvm/ for convenience, and the lib/ patch ended up out of sync
with the actual code).

> With these fixes, I don't see #DE exceptions on a nested guest I try to run
> however it still hangs, right around the time it tries to access PS/2 keyboard/mouse.

IIRC you said that the bug appeared with the vintr rework, and then went
from hang to #DE and now back to hang?  And the hang is reported by L2,
not L1?

In order to debug the hang, a good start would be to understand if it
also happens with vgif=0.  This is because with vgif=1 we use VINTR
intercepts even while GIF=0, so the whole thing is a bit more complicated.

Paolo

