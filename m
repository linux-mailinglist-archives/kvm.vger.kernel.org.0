Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617481C5DD3
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 18:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730203AbgEEQsg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 12:48:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34941 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729119AbgEEQsf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 12:48:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588697314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wsAfx93wcTmhJebE4LKwGW8tJ+5r/WrcCaw1CtXAElg=;
        b=cdU20gmEcEb56TS3OFnZKlY/M2sB2VLoS6MC0WlKe/vqz8t0rqeSnlkvanuOMOA/jE8Wju
        r7yjDLRKavYeEPnCjbMZx9Ld8rL3N9HPY321mLN9GkbhDRPAIufTiEH7cIvjAmFtYID43x
        vTDLSS5rQ35mljanz8uTTeqMVzR0zL8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-V9DuzRgePgWJLpmy6R2NMg-1; Tue, 05 May 2020 12:48:32 -0400
X-MC-Unique: V9DuzRgePgWJLpmy6R2NMg-1
Received: by mail-wr1-f72.google.com with SMTP id 30so1485617wrp.22
        for <kvm@vger.kernel.org>; Tue, 05 May 2020 09:48:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wsAfx93wcTmhJebE4LKwGW8tJ+5r/WrcCaw1CtXAElg=;
        b=osg3I0vKqj7ugYxFuQpMPewyMZbO7xZRCeS9dwCsp52zDKgG4bFJb80l6Apz+yIxCo
         n361QHkfbg+YZGtQauN2bcKsIWbMJGrvtp1qHIo5aLZkAzyi86i4AuIT7zos41M7tij5
         8IBtm31GDoYGXiDE2OepBenMPRKD159hNLqxK+0TcvanKi/S7Z3mekBihoDPXAvlzPzM
         NluSqRM2vggk9bEUgeLNq91cMLeOnszjFDNjL2P3oZXLNtLVbU/laR/l0t61a7auiPcf
         PCbrta8sYFKX2A6ljRtyCG/8Irj7R0ZYDte8lBRkoIK9U9YgcXK0Hd2LLIOiGHkfUMNE
         vTnQ==
X-Gm-Message-State: AGi0Pub7oRR0tEND9h2eavNKPKnNNZEpAfEO6dWRxUzxwQo2/q6Ngu9H
        kSBHpv641xrh2MWz/7e+f6/ERK1hPv0Pu7Oqr81cVpGUF/28Jb0HftCFu+1Zjl6tKNlQn7PRgHP
        EdiYrLKpE4oTf
X-Received: by 2002:adf:fa06:: with SMTP id m6mr4532320wrr.290.1588697311326;
        Tue, 05 May 2020 09:48:31 -0700 (PDT)
X-Google-Smtp-Source: APiQypIzXaMPe8m07FpUYjstwV84erP0MUPDvnxh4ZyS6V44jsO5iKO1FbVaEgbEM+kd0DupJwAyPA==
X-Received: by 2002:adf:fa06:: with SMTP id m6mr4532286wrr.290.1588697311153;
        Tue, 05 May 2020 09:48:31 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id x13sm4918012wmc.5.2020.05.05.09.48.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2020 09:48:30 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] KVM: VMX: add test for NMI delivery during
 HLT
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>
References: <20200505160512.22845-1-pbonzini@redhat.com>
 <EE739374-65DD-4DA0-85F4-DC060E8C22E4@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4d62be2d-ce60-e9f6-abcf-3c69b3e59d21@redhat.com>
Date:   Tue, 5 May 2020 18:48:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <EE739374-65DD-4DA0-85F4-DC060E8C22E4@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/05/20 18:16, Nadav Amit wrote:
>> On May 5, 2020, at 9:05 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> From: Cathy Avery <cavery@redhat.com>
> 
> Paolo,
> 
> Not related directly to this patch: can you please push from time to time
> the kvm-unit-tests? You tend to forget…

Done - it's usually not forgetting, rather not having enough confidence
in the tests I've done to the changes, or in the corresponding KVM
changes.  But sometimes I do just forget. :)

Paolo

