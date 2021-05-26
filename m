Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24A1391556
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 12:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234202AbhEZKuy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 06:50:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48627 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234197AbhEZKut (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 06:50:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622026157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=irqMPhUSvy2ILxtVtEb7WKBccyA8xYtf3GSVWQVHR58=;
        b=GuDC+h4bvxsw1ZSLNpxX6Vxrtn6/K6GfzkP9vRG9v+J0Y3AKWZt/+Sr/Jn1V+nZvCzeKbd
        ivZqLTsmrswoIU39r94v9V0bjuZOyFOGw7/ly6qvx2EXhaacDxIoPPwJwkeoc+kuEkQX9x
        G31WOBcH+uNPjglz2VYLHWWQTCHDmHQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-569-MaRvV_keOOaW2_H6Hw1iFA-1; Wed, 26 May 2021 06:49:15 -0400
X-MC-Unique: MaRvV_keOOaW2_H6Hw1iFA-1
Received: by mail-ed1-f70.google.com with SMTP id x3-20020a50ba830000b029038caed0dd2eso328617ede.7
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 03:49:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=irqMPhUSvy2ILxtVtEb7WKBccyA8xYtf3GSVWQVHR58=;
        b=jESvJzYUVyAJUfK8/597Hk65FBvRmq0WRsSYBMlTNOx5+KvtltaAILSmV3cvYHKvSC
         WVu5laRw0xVjrBfdOLNK+4PdZI3boz6XkXLXA31KnAcejYDRsVBYOl6NOghFyJHWpBup
         78rX2jN6GeVljRJ9ZvFXKFQCC4QB7NB5TDvlkC/VKto32t2RGTfVtr7lJuG1RPhfaa9D
         CpvAVBrLNHGFAYJPS9PEZBL2U8EKyPizO4HgUYKlT5UvHnY0m1IlLUdcyAkKJzGaKROv
         D+JBE/gHsnmwyr7TQQdgKr1ZRDLArp07R+pVOovfo1rz30c6EUDwdYCtxYEc5QX/g5Le
         fO1w==
X-Gm-Message-State: AOAM530DMAidVuLYmjnULkEOfPdggG8YeTSV0ctLKjjNPxXvB4RercF/
        xvnqgdJtZcFh8Ji23QwLBiLJiee8kiTrp/1WAUDJLiOpOE42E95fzBgFCEeDfIr7F6QNjNE9Hb6
        eRMpEJVCOve7USRLNsPQzzwtCrAzvwBIU0+nnU+BdnhpFI+zKx/Vo7JWFvtuTa2bD
X-Received: by 2002:a17:906:a945:: with SMTP id hh5mr1092584ejb.227.1622026153761;
        Wed, 26 May 2021 03:49:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyRtG7hFeTjm7QRnbQ9ciLTc/XgAsTCAxGlvoiCi3XsLctD/kUx6aIlNrCo60BUJXhNPya+Hg==
X-Received: by 2002:a17:906:a945:: with SMTP id hh5mr1092559ejb.227.1622026153517;
        Wed, 26 May 2021 03:49:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n13sm10266934ejk.97.2021.05.26.03.49.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 03:49:12 -0700 (PDT)
Subject: Re: Writable module parameters in KVM
To:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        Peter Xu <peterx@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
References: <CANgfPd_Pq2MkRUZiJynh7zkNuKE5oFGRjKeCjmgYP4vwvfMc1g@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <35fe7a86-d808-00e9-a6aa-e77b731bd4bf@redhat.com>
Date:   Wed, 26 May 2021 12:49:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CANgfPd_Pq2MkRUZiJynh7zkNuKE5oFGRjKeCjmgYP4vwvfMc1g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/05/21 01:45, Ben Gardon wrote:
> 
> At Google we have an informal practice of adding sysctls to control some 
> KVM features. Usually these just act as simple "chicken bits" which 
> allow us to turn off a feature without having to stall a kernel rollout 
> if some feature causes problems. (Sysctls were used for reasons specific 
> to Google infrastructure, not because they're necessarily better.)
> 
> We'd like to get rid of this divergence with upstream by converting the 
> sysctls to writable module parameters, but I'm not sure what the general 
> guidance is on writable module parameters. Looking through KVM, it seems 
> like we have several writable parameters, but they're mostly read-only.

Sure, making them writable is okay.  Most KVM parameters are read-only 
because it's much simpler (the usecase for introducing them was simply 
"test what would happen on old processors").  What are these features 
that you'd like to control?

> I also don't see central documentation of the module parameters. They're 
> mentioned in the documentation for other features, but don't have their 
> own section / file. Should they?

They probably should, yes.

Paolo

