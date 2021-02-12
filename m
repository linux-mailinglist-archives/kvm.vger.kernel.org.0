Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33D731A70B
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 22:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbhBLVoZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 16:44:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35404 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229497AbhBLVoY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Feb 2021 16:44:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613166177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bowbrClOzbT1AwVlaFluVvAcIToBg9OjogYBiiiS/s0=;
        b=aYSGNhzUsu5YXXTE7kEMWDHNXTuGsft+EW8p0jQqT9b6vmu0nqKZKJYvJuJTF2oTxFZQ2v
        kPo+D0l2z14/jAP2B1BBjgwcguRUAhwrKQDzcxe7Uu0urfbKNOufDezDDxBKA07KVLnsU9
        Q1jL4j8Lo4FUfwPGh4h6oxf4DyjV6Ns=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-fM5ckNMJPwibzg1f4wA-HQ-1; Fri, 12 Feb 2021 16:42:55 -0500
X-MC-Unique: fM5ckNMJPwibzg1f4wA-HQ-1
Received: by mail-ed1-f70.google.com with SMTP id b1so831301edt.22
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 13:42:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bowbrClOzbT1AwVlaFluVvAcIToBg9OjogYBiiiS/s0=;
        b=bCC6wjoLTZagO81IS/OyHcGHfZKcfQ/W3ALycrbrSh4JzuZtedTIK3qNdEYRAX+/65
         Y4JNyJWfY1DsYRODstepNjmbhWN1Ua6FEM25g1rZ1wq3KvWU8PkT8ndW+2TkCm7j3JHG
         E8Iq/Mhg/q3vFS6/550iEnlLlwMTEEqtdUHjjAVxDQMvJ1NVPvqdTfDn+9i98aBtY2sc
         dOevBbB3L7TuBrrcG7hBa1TdWOG6c9gEpelyUZNM0YRy9QN5FYdzhE+0rqv/ilhvFvoe
         00FhU3WsIX2qGIzPCcLr4dD+RN2xIdaGbhdJb3VGQU/X/nl+QvoYp09OGblsKKlymM6R
         3LUQ==
X-Gm-Message-State: AOAM531ypmn8brwXdmkgln5ZoQS1WsGLWnBuPep582xRxS1P1EpQBdp4
        jQKXYaasyjr7SWMWGXuBKzEC0BL9djQCpCA+yxGLWYiTjcerfPAFlyo7XnTztf6Knn/IRviCzwq
        Nl96kvZqyGIqC
X-Received: by 2002:a17:907:10c1:: with SMTP id rv1mr5086487ejb.74.1613166174504;
        Fri, 12 Feb 2021 13:42:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwg0GsTXs0O9jl9pmd+h/E3zyCgO8JRcH8uqNpTyQRB/Jqo0C+586fCZLPSEJlUC6Dzem67dw==
X-Received: by 2002:a17:907:10c1:: with SMTP id rv1mr5086476ejb.74.1613166174363;
        Fri, 12 Feb 2021 13:42:54 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b6sm7145896ejb.8.2021.02.12.13.42.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 13:42:53 -0800 (PST)
Subject: Re: [PATCH 0/3] AMD invpcid exception fix
To:     Jim Mattson <jmattson@google.com>, Bandan Das <bsd@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, "Huang2, Wei" <wei.huang2@amd.com>,
        "Moger, Babu" <babu.moger@amd.com>
References: <20210211212241.3958897-1-bsd@redhat.com>
 <ac52c9b9-1561-21cd-6c8c-dad21e9356c6@redhat.com>
 <jpgo8gpbath.fsf@linux.bootlegged.copy>
 <CALMp9eQ370MQ1ZPtby4ezodCga9wDeXXGTcrqoXjj03WPJOEhQ@mail.gmail.com>
 <jpg35y1f9x8.fsf@linux.bootlegged.copy>
 <CALMp9eSk1Ar0UB0udM050sZpGaG_OGL3kOs4LbQ+bigUr_s8CA@mail.gmail.com>
 <jpgy2ft6sn5.fsf@linux.bootlegged.copy>
 <CALMp9eTC2YmG04WVVav-bgzq=6oZbu_5kd-6Dfog3SjkBJcHmg@mail.gmail.com>
 <jpglfbtyrn2.fsf@linux.bootlegged.copy>
 <CALMp9eSQW9OuFGXwJYmtGH9Of8xEwHUx-e-OBcxSFVKTFNF1dw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9ff537b7-b204-18fd-6c59-bdb712ed7e20@redhat.com>
Date:   Fri, 12 Feb 2021 22:42:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eSQW9OuFGXwJYmtGH9Of8xEwHUx-e-OBcxSFVKTFNF1dw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/02/21 21:56, Jim Mattson wrote:
>> Not all, we intercept GPs only under a specific condition - just as we
>> do for vmware_backdoor and for the recent amd errata. IMO, I think it's the right
>> tradeoff to make to get guest exceptions right.
> It sounds like I need to get you in my corner to help put a stop to
> all of the incorrect #UDs that kvm is going to be raising in lieu of
> #PF when narrow physical address width emulation is enabled!

Ahah :)  Apart from the question of when you've entered diminishing 
returns, one important thing to consider is what the code looks like. 
This series is not especially pretty, and that's not your fault.  The 
whole idea of special decoding for #GP is a necessary evil for the 
address-check errata, but is it worth extending it to the corner case of 
INVPCID for CPL>0?

Paolo

