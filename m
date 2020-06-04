Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC821EEE53
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 01:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726021AbgFDXl6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 19:41:58 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42818 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725863AbgFDXl6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Jun 2020 19:41:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591314116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vpa3rdEl1kUDdltKQcUehXACewT1llC22lmT+PzPyCI=;
        b=MwlsRGG8/E1MXmeyJyliUA8LdiFqKwvZxH2awzD4bqtr9colgnI+11Y6XtrUg+fCl3N5rH
        ZcaZXT6xoGrjg6ggus8qMnZNdlCBpzFuXk538titIihu5gDWhzXCUVE697U8vbfAv7dgIw
        A9STlp4pP4x+7qwYy1lj0P4Gi/1mgnU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-1eIm1XsyM0CJsLW_U6b2wg-1; Thu, 04 Jun 2020 19:41:55 -0400
X-MC-Unique: 1eIm1XsyM0CJsLW_U6b2wg-1
Received: by mail-wr1-f70.google.com with SMTP id w16so2974646wru.18
        for <kvm@vger.kernel.org>; Thu, 04 Jun 2020 16:41:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vpa3rdEl1kUDdltKQcUehXACewT1llC22lmT+PzPyCI=;
        b=Fy1RLga9MR0h+r9ljeh73ol565RHKhLGdcS5LCOLHEckfGO35Zj9nPZFotExS7otDs
         PxETjr8dn9HPesJqllKs7byC0wZHbErS7AaK77wXsjCXgG7NABUVv2UPIeQEy54RBr83
         zBFBkuzxVhsfF42Ac54abRstT6vGyGkRhzepixO3WsUVqH0AwGGtkH/GtmTvcWxExmj4
         gJSZvK7a9Pou0sy/YXnCcP4PJMxv8FnUzEDHsqQT7n8T4tSSK46UdieQU0FNqbkt8RI7
         9pP8+34E8gVy2lDWYmaIGWeCNrAXJQSus3XMrFjoxgVBZq5YdUz+dTFZXq4Sx4HFPIeV
         vnHA==
X-Gm-Message-State: AOAM5339ljDQDkzo1f5KIpQQ/IvkfhyINKKH2UMEBoGVJKRZnLZL/+L9
        BCslfMKuEKYwIMX310MrAUnuhjUx4oTP4yw7d2jWIM8opmfGAb7L63y7/aCtqbKtZ4xvfwn9bVH
        UJFS856b5gNXO
X-Received: by 2002:a05:600c:1008:: with SMTP id c8mr6222949wmc.95.1591314114169;
        Thu, 04 Jun 2020 16:41:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwLrJvH75jnQuFHmpOkg3OVlW3wojHKXC9xIcNeA3IoZAQHKOlH224rVHBykXMwxm4dw1PI2A==
X-Received: by 2002:a05:600c:1008:: with SMTP id c8mr6222927wmc.95.1591314113925;
        Thu, 04 Jun 2020 16:41:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:a0c0:5d2e:1d35:17bb? ([2001:b07:6468:f312:a0c0:5d2e:1d35:17bb])
        by smtp.gmail.com with ESMTPSA id k16sm9745196wrp.66.2020.06.04.16.41.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 16:41:53 -0700 (PDT)
Subject: Re: [RFC v2 00/18] Refactor configuration of guest memory protection
To:     Thiago Jung Bauermann <bauerman@linux.ibm.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>, qemu-ppc@nongnu.org,
        qemu-devel@nongnu.org, brijesh.singh@amd.com,
        frankja@linux.ibm.com, dgilbert@redhat.com, pair@us.ibm.com,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <rth@twiddle.net>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <87tuzr5ts5.fsf@morokweng.localdomain>
 <20200604062124.GG228651@umbus.fritz.box>
 <87r1uu1opr.fsf@morokweng.localdomain>
 <dc56f533-f095-c0c0-0fc6-d4c5af5e51a7@redhat.com>
 <87pnae1k99.fsf@morokweng.localdomain>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ec71a816-b9e6-6f06-def6-73eb5164b0cc@redhat.com>
Date:   Fri, 5 Jun 2020 01:41:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87pnae1k99.fsf@morokweng.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/06/20 01:30, Thiago Jung Bauermann wrote:
> Paolo Bonzini <pbonzini@redhat.com> writes:
>> On 04/06/20 23:54, Thiago Jung Bauermann wrote:
>>> QEMU could always create a PEF object, and if the command line defines
>>> one, it will correspond to it. And if the command line doesn't define one,
>>> then it would also work because the PEF object is already there.
>>
>> How would you start a non-protected VM?
>> Currently it's the "-machine"
>> property that decides that, and the argument requires an id
>> corresponding to "-object".
> 
> If there's only one object, there's no need to specify its id.

This answers my question.  However, the property is defined for all
machines (it's in the "machine" class), so if it takes the id for one
machine it does so for all of them.

Paolo

