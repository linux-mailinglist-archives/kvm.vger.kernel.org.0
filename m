Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02491E9F4C
	for <lists+kvm@lfdr.de>; Mon,  1 Jun 2020 09:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgFAHbK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 03:31:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52928 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725972AbgFAHbJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 03:31:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590996667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6G1DaJ08L5P/lyjnG8cNJ/5oUXkDX01HRarXVwG8K34=;
        b=Ka9tP6NKbNlEanIS5BlEPIwxhcfK4fPjlvdjyu8VjKqPNcuq6/Jk4xPLvVxNVTk+H/xifS
        dAE9OtSsQZvieh7OrctpjErFaIw0xw9wr7N/BreJzztnhNFlhZj8eTvOueTG0gPlG1r2Xt
        Tv82OqQJTes7EW1YpeNeUPDOSDjapSI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-FgIICt9KN0Slr62kCXyT8Q-1; Mon, 01 Jun 2020 03:31:06 -0400
X-MC-Unique: FgIICt9KN0Slr62kCXyT8Q-1
Received: by mail-wm1-f72.google.com with SMTP id l26so2349066wmh.3
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 00:31:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6G1DaJ08L5P/lyjnG8cNJ/5oUXkDX01HRarXVwG8K34=;
        b=P/DhtFcW57FeQG26VkrsrPy3cU7C5x8GGU+5EyGhIQIVe2iyOeko88VwbNtrRU+r+Q
         yhGzDms0aLyx2z3yzpbyKBXNqqjcy+6P5VQoLFgkkmF4FUVRJpBiQ1Gdy7x5QPehOfB/
         b/b8X5GPDzfoGq7cPiCBFs0zdBjIg4eGsXrXf3YUcv2ygZTxLlJ+WpzjyFiKThspYEaf
         K4bLZ6pqJCBRELXc1eGfg45yI0H3q4xmBgkdm0eYPnU1q9sdA7Ml3zQp8P+RFVxfiPFK
         LUp3B9D6fHh0+ipvJKvANLosUzzgFrd7W3N6qCDMSp82le5o5+ApbvVLYUQST7T2Qkzi
         5MbA==
X-Gm-Message-State: AOAM532fRsB8UcU4gC2wxVeYx+WgH87RtkEQKuGo4q8mxr4NA6b6WC+9
        Onr+cWicPE/pQWL4aCjsKDQsie/GE4pEYTUtw/OtSK88+OpQiHgYmvMqi7LpgCtfOKlv44jg7YR
        QbKZV4cbb2y2W
X-Received: by 2002:adf:e588:: with SMTP id l8mr22077540wrm.255.1590996664495;
        Mon, 01 Jun 2020 00:31:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw9CiuurbEGUM+sKXjGsTYbH5kwYWrk7YkA8nOXpNCb3aK4jjTRYLRwZENXDds++uDCWmIvUA==
X-Received: by 2002:adf:e588:: with SMTP id l8mr22075970wrm.255.1590996642714;
        Mon, 01 Jun 2020 00:30:42 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e044:3d2:1991:920c? ([2001:b07:6468:f312:e044:3d2:1991:920c])
        by smtp.gmail.com with ESMTPSA id m129sm10521268wmf.2.2020.06.01.00.30.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 00:30:42 -0700 (PDT)
Subject: Re: [PATCH 20/30] KVM: SVM: preserve VGIF across VMCB switch
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20200529153934.11694-1-pbonzini@redhat.com>
 <20200529153934.11694-21-pbonzini@redhat.com>
 <db95e255-3f1d-4c19-028c-f23c7737e178@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <18f371ca-462b-79c7-edbe-7f8576892ded@redhat.com>
Date:   Mon, 1 Jun 2020 09:30:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <db95e255-3f1d-4c19-028c-f23c7737e178@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/06/20 01:11, Krish Sadhukhan wrote:
>>
>> +    svm->vmcb->control.int_ctl             =
>> +        (svm->nested.ctl.int_ctl & ~mask) |
>> +        (svm->nested.hsave->control.int_ctl & mask);
> 
> 
> If this is the very first VMRUN, do we have any int_ctl saved in hsave ?

Yes, copy_vmcb_control_area(hsave, vmcb) is called before
enter_svm_guest_mode (which calls nested_prepare_vmcb_control).

Paolo

