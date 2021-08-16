Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35F9A3ED9F2
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 17:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234372AbhHPPfw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 11:35:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37083 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233006AbhHPPfu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Aug 2021 11:35:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629128118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=noFeB24OdQiLhD5SCxuDOZthRsY3LsTrzo8+2vblPZ0=;
        b=dbiuBEAmymvwPOf5xXkresm6ws6Y1k1BBZpkZBjn9BEJR5tx5Nbb87Nxydsv5nq90EzQOU
        rhDGz1NuBJ7fE0GtE0qnZDdWrgs8N2KWnUVPU+6YUcm/N4m696BN9t7OenKclG3SUnkCC5
        uzz64BY23wjs+QIkQwNzMJ5h4dyguNQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-S-MPV6UUM5abqqgywkAvCw-1; Mon, 16 Aug 2021 11:35:17 -0400
X-MC-Unique: S-MPV6UUM5abqqgywkAvCw-1
Received: by mail-ed1-f72.google.com with SMTP id u4-20020a50eac40000b02903bddc52675eso9032087edp.4
        for <kvm@vger.kernel.org>; Mon, 16 Aug 2021 08:35:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=noFeB24OdQiLhD5SCxuDOZthRsY3LsTrzo8+2vblPZ0=;
        b=nRDOFfRJ5zjFTkElk5UBzEWAvyDAv38vqH3H27EPyqU6391IyoystO+kMqT8IkJEi3
         ryH+47e1k6cOfe2+7PPwafm+7SSlhP/QamnhiYzHiXMZy0RR31tewmsFVnvePGTyHMTm
         CvGhkqu3+VpBWPfgKcb9/hvFTXfgzTjvD0Orxa9iCHM1/YBa2fDFswffeLXeW5ZrurWP
         U3a+JGuzUbaZmTx8Mo0ONvd/FNgH4QbEB7CYS9ppcIlaZtN4VFziP31GrawXVt5ecVAF
         TqeyMnQfEmUXQCmFLy86yJSpbpMAxUKuw5QvsJnitP1qz51SmJee0mxaXnF0XsigxwvY
         DOdw==
X-Gm-Message-State: AOAM532k9mIMbHqikuuuIjVj9WSpi+rDzBLhHXAp5CI81W0ctKYMAzdX
        5z1TS94uT/nnh8QQDe7ab+SYgd1NLJrP8togX3CIKkU+cU+Gi0da4JscRv1EWREkojpTEKLOHUj
        2Eah78jjmwEUi
X-Received: by 2002:aa7:df98:: with SMTP id b24mr21095276edy.103.1629128116380;
        Mon, 16 Aug 2021 08:35:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxOyfspOGcV1f2KU/9SJ5AVADgXkpl2jWly+8p4N7XIoqaJ//SrbNXe/+DlpMcOJ6yVbwZCCA==
X-Received: by 2002:aa7:df98:: with SMTP id b24mr21095256edy.103.1629128116189;
        Mon, 16 Aug 2021 08:35:16 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id b5sm3820101ejq.56.2021.08.16.08.35.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 08:35:15 -0700 (PDT)
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     thomas.lendacky@amd.com, Ashish Kalra <Ashish.Kalra@amd.com>,
        brijesh.singh@amd.com, ehabkost@redhat.com, kvm@vger.kernel.org,
        mst@redhat.com, richard.henderson@linaro.org, jejb@linux.ibm.com,
        tobin@ibm.com, qemu-devel@nongnu.org, dgilbert@redhat.com,
        frankeh@us.ibm.com, dovmurik@linux.vnet.ibm.com
References: <cover.1629118207.git.ashish.kalra@amd.com>
 <fb737cf0-3d96-173f-333b-876dfd59d32b@redhat.com>
 <YRp09sXRaNPefs2g@redhat.com>
 <b77dfd8f-94e7-084f-b633-105dc5fdb645@redhat.com>
 <YRqBTiv8AgTMBcrw@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <182429f4-d5be-58d0-edb1-dacb63db278c@redhat.com>
Date:   Mon, 16 Aug 2021 17:35:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YRqBTiv8AgTMBcrw@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/08/21 17:16, Daniel P. Berrangé wrote:
> I woudn't be needed to create migration threads at startup - we should
> just think about how we would identify and control them when created
> at runtime. The complexity here is a trust issue - once guest code has
> been run, we can't trust what QMP tells us - so I'm not sure how we
> would learn what PIDs are associated with the transiently created
> migration threads, in order to set their properties.

That would apply anyway to any kind of thread though.  It doesn't matter 
whether the migration thread runs host or (mostly) guest code.

Paolo

