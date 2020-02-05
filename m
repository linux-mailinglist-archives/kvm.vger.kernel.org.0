Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC7B31532DF
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 15:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgBEOaM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 09:30:12 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:39740 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbgBEOaM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 09:30:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580913011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RcBQTT6GLODG/bayLzSATYtu3RyNvIBwuV6XGUJB/88=;
        b=ZhJ8EG6tlK3+x7USJaSlwA0z/h+Np7Fjr8cgg1dnSiJNco3cW6yZHN/wlAc4DpwElDPATU
        BeF1uGg5LwYZa9RwiOY6MlxQ0r+Jrbj8UXpvWnXdzRa1U9gJhqO1yHuNuz4HGzw7xRNdQE
        PgHERMiVDPRVMVakQ8Rh7MUKLv4zp6k=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-EK1nGXprPeqA3kLiaMRv7w-1; Wed, 05 Feb 2020 09:30:09 -0500
X-MC-Unique: EK1nGXprPeqA3kLiaMRv7w-1
Received: by mail-wr1-f69.google.com with SMTP id n23so1255137wra.20
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 06:30:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RcBQTT6GLODG/bayLzSATYtu3RyNvIBwuV6XGUJB/88=;
        b=nkYQpXTFr1X3cWLXMmAbn7NEutqVvmxtJGrUzGgV+DR3ekU14fJgQTaFkeFI6q6Niv
         Kt9AuWF/k5N22ogJsvqGYyJAwjbZtVIP214wwZPqCNuMt579cVfUi8WG2B+N2cMwiMeX
         2ZZe5Jhpq+St4u+L7KojeXhPG1jhmJfY8D/YU/Kuicz6MuvhZ5qDZyWZTJeAQjFBIcC6
         FI4ua8jjkTe3NdXw4b1TnJlX0KDJcY5fXysbp/GKRrPgWgEaE8s+naRdbDgeW29NiA2x
         HZJ2wH7p36g6iLbZQpeyIuiL+t7KfmxhAJMZQQ27ZfNixRwcczbWzYpcvX36KEn9ENP0
         hG/w==
X-Gm-Message-State: APjAAAUiLYzmS3Xub8jY1rTGJ4dPM5NRu1yBlglz5ozecDe4+GUBrpgI
        uMc/GwJpcq1nJfremep3+ojV6OW0mjRlGKTYFwey/RdcfbMPrEfmwUvugIa/HgElCd5xlNzFGpf
        4IqE7RevlVRrb
X-Received: by 2002:a5d:6a88:: with SMTP id s8mr28458457wru.173.1580913007778;
        Wed, 05 Feb 2020 06:30:07 -0800 (PST)
X-Google-Smtp-Source: APXvYqyPyNlBB+QY4QitNu3rZNQx8P+4lrTaxsMdCLh9PQg7zNm4xD+igmbXS51wFovwRHZ40ooAKQ==
X-Received: by 2002:a5d:6a88:: with SMTP id s8mr28458439wru.173.1580913007609;
        Wed, 05 Feb 2020 06:30:07 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a9f0:cbc3:a8a6:fc56? ([2001:b07:6468:f312:a9f0:cbc3:a8a6:fc56])
        by smtp.gmail.com with ESMTPSA id v14sm16285wrm.28.2020.02.05.06.30.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2020 06:30:07 -0800 (PST)
Subject: Re: [PATCH 0/2] KVM: MIPS: Bug fix and cleanup
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
References: <20200203184200.23585-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2b35c83d-07ed-00da-9fcf-d0d5594a1310@redhat.com>
Date:   Wed, 5 Feb 2020 15:30:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200203184200.23585-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/20 19:41, Sean Christopherson wrote:
> Fix for a compilation error introduced by the vCPU create refactoring, and
> a patch on top to cleanup some ugliness in the relocated code.
> 
> Untested, really need to setup a cross-compiling environment...
> 
> Sean Christopherson (2):
>   KVM: MIPS: Fix a build error due to referencing not-yet-defined
>     function
>   KVM: MIPS: Fold comparecount_func() into comparecount_wakeup()
> 
>  arch/mips/kvm/mips.c | 37 ++++++++++++++++---------------------
>  1 file changed, 16 insertions(+), 21 deletions(-)
> 

Queued, thanks.

Paolo

