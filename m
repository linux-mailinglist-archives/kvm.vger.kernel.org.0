Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D58D7344F9E
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 20:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhCVTHf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 15:07:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26623 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229854AbhCVTHT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Mar 2021 15:07:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616440039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DZ4BgoNHDF4DNRdw42FBTI53CQmbSaUIseHPHTab7kY=;
        b=GtYdOoya5MpqNIlMqR890d+7t7OzhjkNUXlRSfjEc0d8jkMJ8yIk+coUxrAKvTT1hYjrKg
        T6AnxLVidT9jV4Gf2Do541bQGs2Djwa4MW5DobFiCv+/LjXmKrx984ZnZ2k69RioLywoC5
        jUnY1gjMJWc9mA08Xe6/8TiKuA0C6qY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-NqGoPecUOJajmRYt8ffETA-1; Mon, 22 Mar 2021 15:07:15 -0400
X-MC-Unique: NqGoPecUOJajmRYt8ffETA-1
Received: by mail-wr1-f69.google.com with SMTP id h21so26355809wrc.19
        for <kvm@vger.kernel.org>; Mon, 22 Mar 2021 12:07:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DZ4BgoNHDF4DNRdw42FBTI53CQmbSaUIseHPHTab7kY=;
        b=sLjTqJG4rQ6imtcM+m2opfPX+rTp3tn7pYUB/L9rHHTPm1PZLuVW3WLL5Ncdk6vVTL
         9kbZ+KISIHmDhgFLkahX4jiwNrbVRTYngznwENt4ttalBF70V+7leu6K58K9ubVFoCrq
         zkNFv2BgAhGE9t/j4rPm40V3MrGZEKy2xwPc6z/lSORpKXvtpEFEW3rNymB+zXtdd7pD
         0qGhdubZMnuhEZcnp4bG4t/w+qprhdsq4dFiHx/Spscg6diCuuxzS7nfZuRp3t6EQOv/
         8hTX0YdRgd6rIxvlU0gN2b6xunswKvCA8LzunRPgJ1fsyoTPLNmRJNseBKUEPnmhtDWF
         +KZQ==
X-Gm-Message-State: AOAM533BJh/btw2ZGFpPAY8HpGrRqXBgjbjCy3r10mRYLRRS1IFi9fMB
        7TQ7F1oVKshXoXJK206Cn8f3Yk7DbxsxIdh3ZKdo/0aiRybPbQauFLIfpTZnectLinOy4Ask+6X
        rSpRe7OfHMQim
X-Received: by 2002:a05:600c:2f08:: with SMTP id r8mr25750wmn.95.1616440034156;
        Mon, 22 Mar 2021 12:07:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxaiv/gaT55niJwu0VhrtJykoNKbamFWukE3fC99LthY9zw2VRj9vKa022bIS6k2Cf4LA6I3w==
X-Received: by 2002:a05:600c:2f08:: with SMTP id r8mr25741wmn.95.1616440033983;
        Mon, 22 Mar 2021 12:07:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j14sm20822661wrw.69.2021.03.22.12.07.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 12:07:13 -0700 (PDT)
Subject: Re: [PATCH 3/4 v4] nSVM: Add assembly label to VMRUN instruction
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com
References: <20210322181007.71519-1-krish.sadhukhan@oracle.com>
 <20210322181007.71519-4-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <407a2de7-6a28-77f7-2dac-182b1a3a6cc6@redhat.com>
Date:   Mon, 22 Mar 2021 20:07:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210322181007.71519-4-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/03/21 19:10, Krish Sadhukhan wrote:
> +extern void *vmrun_rip;

This is not a void*, it can be (for example) an uint8_t.

Paolo

