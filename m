Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B744275C70
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 17:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgIWPya (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 11:54:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49347 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726178AbgIWPya (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Sep 2020 11:54:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600876468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v9stDi2hr/7sfKKmAdxuRlayYOTzicJLKsNAlKvWPIM=;
        b=fSvDPS1s9e0EVZZhVvxT80hlj1czSExaG9CoivZ+TTkXLYGElcWkmT+yu54zYRURiDeKeQ
        PEnm86wQ7/doJzQgdXosd+hQU5pyNExDI1W+Ri5pZiyBOaJHAk1iZGvX+WJMlcyclOFwIo
        FQ4aTen3LaF1edvA7/2lTyjbVCg5xms=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-CK_y-7ZjMyKF5iU_5gmbbg-1; Wed, 23 Sep 2020 11:54:25 -0400
X-MC-Unique: CK_y-7ZjMyKF5iU_5gmbbg-1
Received: by mail-wm1-f71.google.com with SMTP id c200so80710wmd.5
        for <kvm@vger.kernel.org>; Wed, 23 Sep 2020 08:54:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v9stDi2hr/7sfKKmAdxuRlayYOTzicJLKsNAlKvWPIM=;
        b=Nsm6n+3Izf9AgF8opeQRNzBQ2pXjelzYdUTsueEVSYLQloT9b/sbSKzVA11oH98SGd
         eSoTCdXvWh104XXKVayzx/Dk6IW36r8m32GYeWR1fgW+Rz6CvaIdMjBwXg4fxA8+7A8D
         t+KJ2oi06Q9AH3U726IHmXPUEvNuDO9c7ASntPAjA+MQs0lZF7HL5ut2jiq+SVH0uCbU
         3g6top64uVp/qbktW1S2aD77OrFauNz1jTetq1DM4uyVado2m9SExakrKlqet3A6A0Z/
         zBJJb0s7J27SLyirBzw+3wz5pZPFHt2BSq4X2+/1abcOEo9UcXJLHPifcDf+T6AcOjQz
         hJIA==
X-Gm-Message-State: AOAM531L30o5mlCexOwQOZf3evzavjz9wv/T/scHS0RA3HkSYS7Z63mU
        hVJVON6AusuvF1/DE5wCHFU23d7/iVb758BDITVqlXATt+kA3k4taZTK6VCoQzBeX8akpF5He+3
        RB0xHz2lLv06l
X-Received: by 2002:adf:e8c3:: with SMTP id k3mr344700wrn.228.1600876464298;
        Wed, 23 Sep 2020 08:54:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz8RdCKJhaMPye/5nB1iIQ29VWmH2nO7IoDScNV2PrrGY2io1e5Ttd/wQ7hx5RzcfMulFlUKA==
X-Received: by 2002:adf:e8c3:: with SMTP id k3mr344681wrn.228.1600876464107;
        Wed, 23 Sep 2020 08:54:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:15f1:648d:7de6:bad9? ([2001:b07:6468:f312:15f1:648d:7de6:bad9])
        by smtp.gmail.com with ESMTPSA id d13sm224742wrp.44.2020.09.23.08.54.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 08:54:23 -0700 (PDT)
Subject: Re: [PATCH 0/3] KVM: nSVM: Add checks for CR3 and CR4 reserved bits
 to svm_set_nested_state() and test CR3 non-MBZ reserved bits
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com
References: <20200829004824.4577-1-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7482db27-047c-afdd-8440-5f0f051ff8b7@redhat.com>
Date:   Wed, 23 Sep 2020 17:54:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200829004824.4577-1-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/08/20 02:48, Krish Sadhukhan wrote:
> Patch# 1: Fixes the MBZ mask for CR3
> Patch# 2: Adds checks for the reserved bits for CR3 and CR4 to
> 	  svm_set_nested_state() since these bits need to be checked before
> 	  VMRUN of the nested guest on the destination.
> Patch# 3: Adds a test for the non-MBZ reserved bits in CR3 in long mode.
> 
> 
> [PATCH 1/3] KVM: nSVM: CR3 MBZ bits are only 63:52
> [PATCH 2/3] KVM: nSVM: Add check for CR3 and CR4 reserved bits to
> [PATCH 3/3] nSVM: Test non-MBZ reserved bits in CR3 in long mode
> 
>  arch/x86/kvm/svm/nested.c | 51 +++++++++++++++++++++++++++--------------------
>  arch/x86/kvm/svm/svm.h    |  2 +-
>  2 files changed, 30 insertions(+), 23 deletions(-)
> 
> Krish Sadhukhan (2):
>       KVM: nSVM: CR3 MBZ bits are only 63:52
>       KVM: nSVM: Add check for CR3 and CR4 reserved bits to svm_set_nested_state()
> 
>  x86/svm.h       |  3 ++-
>  x86/svm_tests.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++-------
>  2 files changed, 49 insertions(+), 8 deletions(-)
> 
> Krish Sadhukhan (1):
>       KVM: nSVM: Test non-MBZ reserved bits in CR3 in long mode
> 

The patches does not apply anymore, please resend on top of kvm/queue.

Paolo

