Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E02C352E91
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 19:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235111AbhDBRju (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 13:39:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25289 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229722AbhDBRjt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Apr 2021 13:39:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617385187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EhGoi7o/FEIXRA03/3MsKXzIDXyfFQYEghHL1V/cvCg=;
        b=QYpMp0EoQUTEhXqQZH/jyoOuNfyXggHnYMtqYUTAsHI1onwbyVXpcyiPAU7UJRriGnMUt5
        ueTmXNLMTxs+hDqwfGVC8lmHaHPekQ6kEC4cbbAFuOHq+J1zpE0M2m97x/VNqaM10S8fqG
        Rd7iBKsKT3E8FxWLP5KXvOoE6sig2EA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-_Kr7suF0OVuDzvRhN0m0jg-1; Fri, 02 Apr 2021 13:39:46 -0400
X-MC-Unique: _Kr7suF0OVuDzvRhN0m0jg-1
Received: by mail-ed1-f70.google.com with SMTP id cq11so4846912edb.14
        for <kvm@vger.kernel.org>; Fri, 02 Apr 2021 10:39:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EhGoi7o/FEIXRA03/3MsKXzIDXyfFQYEghHL1V/cvCg=;
        b=qjNkHP0uUU0hMeNqSBAJc/5A0X64gmkJwgvywhAHA/UK9FJDjuFoGXwJOgoDvWWjkc
         mFT8ychb2A6tCT41YI3YfRdbrb11iI8qIF+gk9ea4qOXPVWH5+dBXJQV59IyPutdz/SZ
         MrZTHWFJCKiZ3WK2UoY1NurnLaHvTavVlFe+xPZWigA7oqDpTJwliJsqVuZA7RtgR6r/
         gJGhrNFEW879+phSLgpoI8j6xKXGTesLSgQHxTbqvtiGXLC8tvO7XSN1k/eofFvDN/c7
         w9y5q7o2xBJpQfTtjuumepXmbjzPjcmk6xnYkDfDJ921+qhucsS5UoyhxBh05feYWQ/g
         Vo5w==
X-Gm-Message-State: AOAM530z7inZwQAarBLDTdkfvDamFjgVflfsjGaq7gVwDu/nLnR7XcdC
        gfsAXWA2icHX915exkjuXQRn546Tx462BvHXKyRgtXGwLfxLTOPJfTxK8t+CoG9YmW+1eiInUjR
        y5mJfgS1oVNC/
X-Received: by 2002:a05:6402:1545:: with SMTP id p5mr16451597edx.155.1617385184839;
        Fri, 02 Apr 2021 10:39:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw2OklQ5cL3MZrViP7RnUbyEYp2G5aMIDp+wutkZdRBHtuYfAHpGbomUnxWtObRizncLmNMBQ==
X-Received: by 2002:a05:6402:1545:: with SMTP id p5mr16451579edx.155.1617385184647;
        Fri, 02 Apr 2021 10:39:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id cy5sm5798076edb.46.2021.04.02.10.39.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Apr 2021 10:39:43 -0700 (PDT)
Subject: Re: [PATCH 0/5 v6] KVM: nSVM: Check addresses of MSR bitmap and IO
 bitmap tables on vmrun of nested guests
To:     Sean Christopherson <seanjc@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, jmattson@google.com
References: <20210402004331.91658-1-krish.sadhukhan@oracle.com>
 <YGdWlrrrG2vmDLdb@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1e2b2de0-290d-bddc-a6ed-472c0fe8c72b@redhat.com>
Date:   Fri, 2 Apr 2021 19:39:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YGdWlrrrG2vmDLdb@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/04/21 19:38, Sean Christopherson wrote:
>> v5 -> v6:
>> 	Rebased all patches.
>
> Please rebase to kvm/queue, not kvm/master.
... or at least kvm/next.

Paolo

