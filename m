Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 594991E872A
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 21:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbgE2TEt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 15:04:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34364 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726549AbgE2TEp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 15:04:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590779084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4OeTMYt6ooRGykihY8xeTFwVI+iDEW21APbq0fnA8RY=;
        b=YOIB9wIfem9/El29z9coyvhJrsAZn2tu9hQlZ4WNjXfikFreefBasbSIxW6/r/N/wicXKe
        SrrTaluP1jMRVSxBRkYN+rQJNfWgIhf3wqnOYCk1wKHFy7gw+tvb0E46GdcASfVvJwejAx
        MUr33qtcJ/gKekWTS6Hxign0dVuCPYU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-whmTF9vbMC6cuDFjHUvr-g-1; Fri, 29 May 2020 15:04:42 -0400
X-MC-Unique: whmTF9vbMC6cuDFjHUvr-g-1
Received: by mail-wr1-f72.google.com with SMTP id c14so1400703wrw.11
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 12:04:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4OeTMYt6ooRGykihY8xeTFwVI+iDEW21APbq0fnA8RY=;
        b=GFK+gVK1mXbIyPpGFfC05oRRfdYgYuvmaok2Wc5loF8SuAwMFnHgXLHTQJBxe12SkE
         iBmxWztTuizzVTET8ZsTMDaHbg3/Rj48dwHySjuOPgs2flEK7DmD7Sg9xqU8DNrqGivD
         L+KlSWGWOU1qonBCKBpZfv1UnbXBBRTcsIzL4qvyAmxHLh3wFf7v8Y2e2KWi5F6i0QwL
         c+TyWH3Br4zz2XCtNghtaMrvixpUDpyukwMnGsHypJv9PtHdkkxc5EBk9WYA9rxJfXcu
         6y5ur/ZWpm+1myaPFf4xevH1Q1LfX/wD/3HPkcx+Xet64pfCqpAqSR+rlrf+GzEMEEyW
         BIcw==
X-Gm-Message-State: AOAM5309XE9HRpkHdgd85ml9wKOHOtxPQEDs2bFY2QTGX8bi/RMbbyth
        C3/HJBsy9KZu/yv6u8Pd7xor2gA+J22eHEBehPDjHpEd2/veC9R8ne6hJdM++1lrm3At4pT3JO0
        dyi5qWWFPgS/Y
X-Received: by 2002:a5d:558a:: with SMTP id i10mr10606866wrv.207.1590779081006;
        Fri, 29 May 2020 12:04:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxHdmQQkz93toiXqZdPVAnmv6hSnFkVo4RzDmNklVZHcwM5g9a4XgHHpwpiB3KDSDJPzUHZ/A==
X-Received: by 2002:a5d:558a:: with SMTP id i10mr10606850wrv.207.1590779080699;
        Fri, 29 May 2020 12:04:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3c1c:ffba:c624:29b8? ([2001:b07:6468:f312:3c1c:ffba:c624:29b8])
        by smtp.gmail.com with ESMTPSA id b185sm1033474wmd.3.2020.05.29.12.04.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 12:04:40 -0700 (PDT)
Subject: Re: [PATCH 08/30] KVM: nSVM: move map argument out of
 enter_svm_guest_mode
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20200529153934.11694-1-pbonzini@redhat.com>
 <20200529153934.11694-9-pbonzini@redhat.com>
 <f7946509-ff69-03e3-ec43-90a04714afe3@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5fa0a52e-3b67-b545-d74a-7e4050e64559@redhat.com>
Date:   Fri, 29 May 2020 21:04:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <f7946509-ff69-03e3-ec43-90a04714afe3@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/05/20 20:10, Krish Sadhukhan wrote:
>> Unmapping the nested VMCB in enter_svm_guest_mode is a bit of a wart,
>> since the map is not used elsewhere in the function.  There are
>> just two calls, so move it there.
> 
> The last sentence sounds bit incomplete.

Good point---more precisely, "calls" should be "callers".  "It" refers
to "unmapping".

> Also, does it make sense to mention the reason why unmapping is not
> required before we enter guest mode ?

Unmapping is a host operation and is not visible by the guest; is this
what you mean?

Paolo

