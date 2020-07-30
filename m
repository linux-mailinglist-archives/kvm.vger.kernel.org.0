Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4902337C4
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 19:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730279AbgG3Rf0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 13:35:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55095 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727080AbgG3Rf0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 13:35:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596130524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dyVNMCjLxqIEJGuRToSw0dnY5ogOKCOxAIk5KmTomak=;
        b=Ppc/59Bh9k/nw5+nfTZomQBecZu+X4JxZddRu/xmQMMnCnZI3Dg6CDBP+DuCAyO5lEBDZr
        j9JzpuE1q1Mc2WSfSd+dmZAeke9rDPnhnQxH7q6Z2/4n3sqwd6lF5Mjxxui2ryfWNk7/LE
        mJjRDS45Ta6RHaIodQPF7i8YMAXKL7A=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-7Lxw2slGNoGMpbbu7wmgdg-1; Thu, 30 Jul 2020 13:35:22 -0400
X-MC-Unique: 7Lxw2slGNoGMpbbu7wmgdg-1
Received: by mail-wr1-f69.google.com with SMTP id f14so8142351wrm.22
        for <kvm@vger.kernel.org>; Thu, 30 Jul 2020 10:35:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dyVNMCjLxqIEJGuRToSw0dnY5ogOKCOxAIk5KmTomak=;
        b=t9Gr/AP4tze5MkGCQ3wfbsqqPxur6/7Y5gR6JN1q3W+Eu7aAfyC0IhdyfrGtPKFe9N
         nxMNdOTom5BkhN2LWTlC9FTTx/VFun/Gg6kU+4AfnQTpn8em3Y9Kv8sEKS48dOC5DF5Y
         WO2hOhL/G/h834TKNyXAub9t6euKbcvQTAsXiyrqr0UCp/dihso0WXKwFy8kyzku/ghr
         GweveLheU6ebcD+NgnHx1nyMOpiSxz23SOavtrMuQdZNbXzz1BcoaieImW2750KdxO2F
         Q5ATjWm/fV/HQioyZJnzDixEaZoTxwtRtDNhKM5izbJE+hrh2KriM6mthcGVqLpZ46/0
         iqfg==
X-Gm-Message-State: AOAM531tJXdrfNYzmLBo8wS7uYzxIkKt/i5m1fKR/dQeQ36qiFUFYZPT
        8M5cm5dZx00w1wlpXXbFVyWGqrRbudFpEPxj74OgJhFTRHMRm6VRpDj2ysEbCAzNbnS8Y0D69D7
        FJQsswckvsChg
X-Received: by 2002:a05:6000:124c:: with SMTP id j12mr3826463wrx.83.1596130521145;
        Thu, 30 Jul 2020 10:35:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzsd5kKyh2dU1/ifRUp0dC7ZzkxLhMLQkeK99sQN+JxJE7C9HCtPfER9lDVJfGWL4XFGW3q+Q==
X-Received: by 2002:a05:6000:124c:: with SMTP id j12mr3826446wrx.83.1596130520922;
        Thu, 30 Jul 2020 10:35:20 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:310b:68e5:c01a:3778? ([2001:b07:6468:f312:310b:68e5:c01a:3778])
        by smtp.gmail.com with ESMTPSA id w2sm12613800wre.5.2020.07.30.10.35.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2020 10:35:20 -0700 (PDT)
Subject: Re: A new name for kvm-unit-tests ?
To:     Nadav Amit <namit@vmware.com>, Andrew Jones <drjones@redhat.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Thomas Huth <thuth@redhat.com>, KVM <kvm@vger.kernel.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Liran Alon <liran.alon@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <dc518389-945a-1887-7ad0-00ebaf9ae30e@redhat.com>
 <682fe35c-f4ea-2540-f692-f23a42c6d56b@de.ibm.com>
 <c8e83bff-1762-f719-924f-618bd29e7894@redhat.com>
 <CANRm+Czsb79JYAHcOm49tg=M2vHdOzh_XFaEcSS_RUPfX3dRuw@mail.gmail.com>
 <c92c6905-fcfb-ea5b-8c80-1025488adc98@redhat.com>
 <1B9660BF-6A81-475E-B80C-632C6D8F4BF9@vmware.com>
 <20200730113215.dakrrilcdz5p4z7e@kamzik.brq.redhat.com>
 <CA3B8C12-0421-489C-A135-3D97D58D9D5F@vmware.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2b07717e-3716-cc55-8f1b-8047a318c1f2@redhat.com>
Date:   Thu, 30 Jul 2020 19:35:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CA3B8C12-0421-489C-A135-3D97D58D9D5F@vmware.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/07/20 19:32, Nadav Amit wrote:
>> We can use compile-time or run-time logic that depends on the target to
>> decide whether a test should be a normal test (pass/fail) or an
>> xpass/xfail test.
> This is simple. When I find some time, I will send some patches for that.

Not too quick, let's first look at a design.

Paolo

