Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 272D521859A
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 13:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbgGHLJb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 07:09:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41025 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728700AbgGHLJa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 07:09:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594206569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bkp2vvF47JADWAniwd4t8Rm/0+rP5emrFqHByZTUt54=;
        b=StYjhirtsLQqlhFVdZ8GkMH9aodhE1n6ilCXos6pSGyNAyrMMOJBrHKbOo8STWOxDZ/h18
        P6i1ebEDlE9BGrTVjQhCRD+73PYdq6wsL8rgXjQpHB0NgijmqjZNH1DKs8SCZrTXCIYgur
        bZo8nJmgExJ5K9veGzGbqqMuEcOa1Ws=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-T8T6vPfHMJyk5MLv_jq1xQ-1; Wed, 08 Jul 2020 07:09:25 -0400
X-MC-Unique: T8T6vPfHMJyk5MLv_jq1xQ-1
Received: by mail-wm1-f72.google.com with SMTP id c124so2553793wme.0
        for <kvm@vger.kernel.org>; Wed, 08 Jul 2020 04:09:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bkp2vvF47JADWAniwd4t8Rm/0+rP5emrFqHByZTUt54=;
        b=UwiLu89mYmH5IGHUtIdnsBF6KB7b7oSXJ5OSlV3pSXs+0H/qnTnOnxyF4vzvnxtMTf
         fZbBhWFzGTG0SLhj2PJ4kgEV4TLzAzaK48vNY+9h2WmSfCz96r6wn5ZbREoUF3cnis1f
         n4It9rE4DRDoYf58db/A3f3JDwKFIX3VE1VWZgPBK5iYIHifWuvmzH8RfyIfV4d0Ar9m
         SpwPM253oyRD+30QriZAvplObneTd+YOcqxKwJzFvyTTt4tZZyEvVaT4ZgJAwAwxWs3G
         T5L/ANCKWFbXZtFnizqlTau4pm+jmA/8YhkdhTvdZrNAnW2CWopo2S1d3jWV9vZeFXAN
         0OnQ==
X-Gm-Message-State: AOAM532EQiYFlhqJAJNWNvKimLzVvpyxHzqNHedkWq0zrPhYSrPDieQZ
        e4mk4uKMcv/KW2WwG/KLslSy0y50fJCbI4UDRN02ZIkwHcVoFyOBXBW42xdyD5w+mONdfS+mFhW
        oj96Q8rPUKIl0
X-Received: by 2002:a7b:c3c7:: with SMTP id t7mr8321925wmj.97.1594206564111;
        Wed, 08 Jul 2020 04:09:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxEEcsBpZcVOq/4PfVzjw7iAbK1Fw0+BulW9EE6scukH0TtmplhsJ9rA4gyk4IoPTBaC2Dx+g==
X-Received: by 2002:a7b:c3c7:: with SMTP id t7mr8321904wmj.97.1594206563845;
        Wed, 08 Jul 2020 04:09:23 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id f15sm5181481wmj.44.2020.07.08.04.09.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 04:09:23 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: limit the maximum number of vPMU fixed counters
 to 3
To:     like.xu@intel.com, Like Xu <like.xu@linux.intel.com>,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
References: <20200624015928.118614-1-like.xu@linux.intel.com>
 <8de3f450-7efd-96ab-fdf8-169b3327e5ac@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9b50db05-759e-c95c-35b2-99fba50e6997@redhat.com>
Date:   Wed, 8 Jul 2020 13:09:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <8de3f450-7efd-96ab-fdf8-169b3327e5ac@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/07/20 09:51, Xu, Like wrote:
> Kindly ping.
> 
> I think we may need this patch, as we limit the maximum vPMU version to 2:
>     eax.split.version_id = min(cap.version, 2);

I don't think this is a problem.  Are you planning to add support for
the fourth counter?

Paolo

