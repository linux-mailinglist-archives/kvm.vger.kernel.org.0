Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40E842482F
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 22:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbhJFUrY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 16:47:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43011 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230047AbhJFUrX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 16:47:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633553130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7e83BovDmV4FWEAygs/8iu96+bCd8fAgvepcOkCpC4A=;
        b=Oo4mwIl47nuNHJATu4h34oej3M17kgrIL9WzZiqwn+931ndGJnFjIRovGWS1vNCNGzTD2L
        dIEQvU0c4DG/9vVKKNeeziWsMP557rA2bk3XFxkpR9FWaOPpyXQ2MfpFFPRAnUmnpShqze
        l2qpa2BWmvhHJcHxnTL4eZdbmcoD4dA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-B0NPXGUAMTWUyd7OBwPISg-1; Wed, 06 Oct 2021 16:45:29 -0400
X-MC-Unique: B0NPXGUAMTWUyd7OBwPISg-1
Received: by mail-wr1-f70.google.com with SMTP id r16-20020adfbb10000000b00160958ed8acso2970756wrg.16
        for <kvm@vger.kernel.org>; Wed, 06 Oct 2021 13:45:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7e83BovDmV4FWEAygs/8iu96+bCd8fAgvepcOkCpC4A=;
        b=OwdOh4qGmMH1waEupKwPlVqRHrxoCApW3bszWtXu34A5Vm8MfANw2Nqt/INOIjR0Av
         tIFisN+JDjex8kigIcBXSnfsV5gz9xvpzqW7kjXZVMKEBxLOyF6I7UjAH1tvB/tA+C6Z
         082j5t5XzOEDAv+BAHHOwMu2XqeayNCg3go4Qy2Jx9KUVrXEuxB6KqJo7lHuOmMfyLSq
         6g/IsHSnqnEljSTaK8YKCh85BXxlpMuBsnQtPkihegXuE3ghLdRKVl1BGFtqJIQDgKUp
         qse56ihiHMIbJ6OlqjXSiNtFw64DSnpNoE8Vv0xoMkqmzrZMsmivb8Rqg4cVhyq+tsJM
         SMRA==
X-Gm-Message-State: AOAM530tl4ZMnsmAB7Q/xUB1BrfqocUoCVgTd8jizvp+B5lLr2KheEhv
        2Z6mFEvJJBhmcIgOcs6R5S9HNfnoaBC4wes45jNhjRWVa4fkAN/S+gJ2kt+78jeNMM6Ef0AvtcH
        e5JOSbJvicD0D
X-Received: by 2002:a5d:6c67:: with SMTP id r7mr335239wrz.29.1633553128308;
        Wed, 06 Oct 2021 13:45:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzTtObekwMqUOWYKeA/QxlvvVqbtBBCPF4LfmN4YsrbE1kp4rcMK3+wFfLt2ssE4xuxPV/Aew==
X-Received: by 2002:a5d:6c67:: with SMTP id r7mr335225wrz.29.1633553128198;
        Wed, 06 Oct 2021 13:45:28 -0700 (PDT)
Received: from [192.168.1.36] (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id w7sm9937454wrm.54.2021.10.06.13.45.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 13:45:27 -0700 (PDT)
Message-ID: <3f2c527f-fa01-7994-00ef-026ac6e63471@redhat.com>
Date:   Wed, 6 Oct 2021 22:45:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 14/22] target/i386/sev: Move
 qmp_query_sev_attestation_report() to sev.c
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org
Cc:     Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org,
        Sergio Lopez <slp@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>
References: <20211002125317.3418648-1-philmd@redhat.com>
 <20211002125317.3418648-15-philmd@redhat.com>
 <86b19b44-a8e2-af97-2b96-8cc21ed1be34@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
In-Reply-To: <86b19b44-a8e2-af97-2b96-8cc21ed1be34@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/4/21 10:23, Paolo Bonzini wrote:
> On 02/10/21 14:53, Philippe Mathieu-Daudé wrote:
>> Move qmp_query_sev_attestation_report() from monitor.c to sev.c
>> and make sev_get_attestation_report() static. We don't need the
>> stub anymore, remove it.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> 
> This was done on purpose, but I have no objection to changing it this
> way.  We might in fact remove the indirection for SGX as well, and/or
> even move the implementation of the monitor commands from target/i386 to
> hw/i386 (the monitor is sysemu-specific).

OK about SGX, but in another series, this one is already painful enough.

Not sure about moving monitor to hw/, some commands expose hw info (like
info pic) but some others expose architectural features (like info sev).

> 
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> Thanks,
> 
> Paolo

