Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94D023D5A97
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 15:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234368AbhGZNCa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 09:02:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45905 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234359AbhGZNCC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Jul 2021 09:02:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627306950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DbUVtvqYLIV2IExPgkbfEc3dRpkF1ai0qjs2lZ3kNnE=;
        b=XxT+eThnIsT2vAcPTRRP3rwn2IXdcRneeMwKwbJEnMhLeDQ6QFd7bQGKK5dIW05cQVXEVj
        XJ7k4NWTjs80+ninQped+T2zfIl4y8HWlNEnn9oyLEm2GJvweWDls+6qgtaThvY36mDSKW
        TRHjgnMYdcVODCzoWEZx2uh35vZR1t8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-2ljmw5joOeyjejhQbzZldw-1; Mon, 26 Jul 2021 09:42:27 -0400
X-MC-Unique: 2ljmw5joOeyjejhQbzZldw-1
Received: by mail-ed1-f69.google.com with SMTP id d12-20020a50fe8c0000b02903a4b519b413so4756670edt.9
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 06:42:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DbUVtvqYLIV2IExPgkbfEc3dRpkF1ai0qjs2lZ3kNnE=;
        b=ixvDDdrLP/iqt23QGHh1Kgxg5FuMvjH7uFZI+poF6B6xifgbpWMm3M7MTjHKQ1LzGr
         iUbxEhY2MM3xkGc/Dn8rjAYOQhSXKZRdGSuMH/pygtim7laYFNhHjQcWrDZ8mujN8x3N
         mGTI1J7WJoFjWp+HSrXizM7KZllreqqFQAijVMByiwIBafd+5uz2RP813WqXlQZz7T8i
         c9gKSj8MXvt62/2uznV1r4BIjertoJ6R1IBfnOzDsIQI6nw2Gmu9Uul8TD3lQ56Svy1C
         fAVfNGnNuVCCvTgexYHFPpEvz1LdhOoWPnkLK4ac2m/bQSZfDG63Nu5Y/oGUi+i6yH4o
         Nyag==
X-Gm-Message-State: AOAM530t9KQFp44FpBur6misWWvT3FIGpqsPdRaVw5OqZL8RNfcFiZTT
        J4lg/7aN9zj9l/Prd72qaviwwmr7cPLe6ZbMRkU/9I88VYQPTkE/WuA+PPHYL2AkIFA8xBQhp2v
        nnBdNh60CRgZz
X-Received: by 2002:a05:6402:31a4:: with SMTP id dj4mr10088527edb.350.1627306946113;
        Mon, 26 Jul 2021 06:42:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzaPhxnXEkX5ZgOuE+meod+XZ3vfb4y3Q1rF5NA9yq0QtYo6bz/rfrexS5Pw1vje0rYXFomiQ==
X-Received: by 2002:a05:6402:31a4:: with SMTP id dj4mr10088510edb.350.1627306945972;
        Mon, 26 Jul 2021 06:42:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id k21sm18837408edo.41.2021.07.26.06.42.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 06:42:25 -0700 (PDT)
Subject: Re: [PATCH v2 2/9] KVM: Introduce kvm_get_kvm_safe()
To:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20210625153214.43106-1-peterx@redhat.com>
 <20210625153214.43106-3-peterx@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <35d133ab-5f21-7693-51ae-1a6ae81e76f4@redhat.com>
Date:   Mon, 26 Jul 2021 15:42:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210625153214.43106-3-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/06/21 17:32, Peter Xu wrote:
> -	/* The debugfs files are a reference to the kvm struct which
> -	 * is still valid when kvm_destroy_vm is called.
> -	 * To avoid the race between open and the removal of the debugfs
> -	 * directory we test against the users count.
> -	 */
> -	if (!refcount_inc_not_zero(&stat_data->kvm

Better keep the comment here (but nothing to do on your part).

Paolo

