Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D3E1C7154
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 15:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgEFNEz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 09:04:55 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:52349 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728045AbgEFNEz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 09:04:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588770294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qngOHlKG0cnQDiLSs5wsibCsLTj9uySHU/5JGB/4wiA=;
        b=A5wQumCdHQGM4LlSbnUUh2InFEdGF0+1bPBzw/hDH5Pao0+SkYlbTQna4YSMP6EBXN6d2T
        PLHTzOKEv4eK5qm7JhswNEZ0gaC3t6l8Gsbbd5Axi9OcNlKpteLBaSV+qErstOcMAROX97
        wqMwJz3ZUHRZveUnv5AczpYQL5pjDgE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73-jpJpxofYPACpRjQmi_qF6g-1; Wed, 06 May 2020 09:04:50 -0400
X-MC-Unique: jpJpxofYPACpRjQmi_qF6g-1
Received: by mail-wm1-f72.google.com with SMTP id q5so1177916wmc.9
        for <kvm@vger.kernel.org>; Wed, 06 May 2020 06:04:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qngOHlKG0cnQDiLSs5wsibCsLTj9uySHU/5JGB/4wiA=;
        b=iAi/dxoqUKnTEFyY9/soKpLqiUKmHC7qwndBUSsrTVFd93Wer1+mGW1/gWMfZ0DhQW
         vYagKoy5a3a5nn/p0SIbIss8P0Cb0K2Ef6lft3KD1ZMTyN4lvtmynEaTIZDRip0/3vTM
         yX487ZfHfDD4b3P6hiBbZBHcMEkBfgR2Yu90u6j6c/qfmoJ1bjfcEXfDLC+cz0XFPuNF
         Hu07Bz224pe6FTupPzVDhlJsQiY3Q9Gd4uuIdntgBxVBtY9mVMjR2zR553yYrxPJHhXA
         u9hqENjuba6/3l4COvjA4BjsdBD1BJrJhVzQoyhi9XgyldSHuanmEIH1SMDrCKXlCfKJ
         /FbA==
X-Gm-Message-State: AGi0PuaM88Zpza/MWEpTftGPBhjY4RoedqpJwYVoAayrnlXaeOcsQPps
        snS3msmYDwmBExUKii+GUliPbCHU6INvnMS69P00IpCfmz4ljlo/O/xrthjZkvEcVYEdo7nNMwI
        hCizqfPnGUj1O
X-Received: by 2002:a1c:2846:: with SMTP id o67mr4192906wmo.23.1588770288984;
        Wed, 06 May 2020 06:04:48 -0700 (PDT)
X-Google-Smtp-Source: APiQypLpHYsL4kRRYUylssszdAU2HcysGtXfgO5aMEiVFHzhVLuD6kQ0UrRY5lp6KyvMbKEZ2dBdow==
X-Received: by 2002:a1c:2846:: with SMTP id o67mr4192863wmo.23.1588770288659;
        Wed, 06 May 2020 06:04:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:11d7:2f21:f38b:17e? ([2001:b07:6468:f312:11d7:2f21:f38b:17e])
        by smtp.gmail.com with ESMTPSA id h6sm2981118wmf.31.2020.05.06.06.04.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2020 06:04:47 -0700 (PDT)
Subject: Re: [GIT PULL 1/1] KVM: s390: Remove false WARN_ON_ONCE for the PQAP
 instruction
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Qian Cai <cailca@icloud.com>
References: <20200506115945.13132-1-borntraeger@de.ibm.com>
 <20200506115945.13132-2-borntraeger@de.ibm.com>
 <bcd98cbd-1e28-47a2-6cbd-668da4ddb9f5@redhat.com>
 <fe991071-25d0-3842-73cc-23cb365850f3@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a8688ff1-edc6-fdd8-9575-adbf726f9f06@redhat.com>
Date:   Wed, 6 May 2020 15:04:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <fe991071-25d0-3842-73cc-23cb365850f3@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/05/20 14:23, Christian Borntraeger wrote:
> 
> the problem is that z/VM seems to have disabled that bit. The interpretion
> only works when all layers have this bit set. (Its called an effective bit). 
> So we have
> LPAR -> ECA_APIE = 1
> Z/VM -> ECA_APIE = 0
> KVM  -> ECA_APIE = 1
> nested KVM guest --> does during boot in ap_instructions_available PQAP with
> FC==0 to test if crypto is available.
> 
> As the nested guest is in fact a shadow guest of z/VM
> this will now intercept to z/VM, which will forward that to KVM.

Right, and I'd understand, that since KVM has set ECA_APIE=1, z/VM
should either:

* not forward the intercept to KVM unless FC==3

* toggle ECA_APIE back to 1 while running the KVM nested guest.

Of course I have no idea if either of these choices is impossible, or
too expensive, but this is how we'd try to handle it for x86 features.

So it would be a z/VM bug, because it's not virtualizing ECA_APIE=1
correctly.  The next question is, if removing the WARN_ON is okay for
you, should KVM not bother setting ECA_APIE=1 so that you don't trigger
the z/VM bug at all?

Thanks,

Paolo

> 
> As PQAP with FC==0 DOES work in the KVM, KVM believes that we have crypto
> support and we will enable it for our guests. So all the early checks in
> handle_pqap will succeed until we run in the check for fc!=3.
> 
> In the end this is obviously a case how this warning can trigger. So we better
> remove it and rely on the error path to clean up.

