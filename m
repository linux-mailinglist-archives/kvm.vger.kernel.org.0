Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCDCF44E3E4
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 10:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234696AbhKLJhn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 04:37:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37412 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234763AbhKLJhm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Nov 2021 04:37:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636709692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zxpcSnWKWAX26f0exTrc0C5AcatqZuzCnik5e/vhTMg=;
        b=QzIQ5+ctWOuJUWZJvlStQpPY4MpMTeZhDONJcFfAV+4+UZneYIA/d6KYi40qblxvlmYCNy
        s3L+OhUFpdDlxIX186bHfbXC4ffMln7rzWkuXSJeOKKQ410lyss1rMySLXGyIErHgc0/eO
        NXGovXB3EmCo32j+lxLdoYmA5NrAhyY=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-L_npPkeLPHiXrcJXANOBtw-1; Fri, 12 Nov 2021 04:34:50 -0500
X-MC-Unique: L_npPkeLPHiXrcJXANOBtw-1
Received: by mail-lf1-f71.google.com with SMTP id n18-20020a0565120ad200b004036c43a0ddso3565779lfu.2
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 01:34:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zxpcSnWKWAX26f0exTrc0C5AcatqZuzCnik5e/vhTMg=;
        b=DR5sqIw/kTP2roHFMYmXltqJYtM28TimTJP5KAjMBxADhHLXAxqEYZ1yMTF1rtoKGe
         wNVQtiZ+/MGkGHXx8V5gmffRlwZ31XtZda0zDqZAEn6TiuQw49EluA39EpIlra5lUC/o
         OZmOlDIUO2j0fVoUz0Dd4XmO5qKvyJLrVG8RGHCXeF07zo1B8XAXxwSnXQpBEcpW9AE8
         N/zdbnGZfZLe1T6izrgOTe4iLcT70hZWN/YVwKGbiQf7DxP3yE5staZc4bEAc3yEo7S+
         Ie2Pcf/JFK5yTg3XWcqdVhngeMl5OdZ58cbNeZh8BinS0mReFhXAYv2Fvyt0/FZyq7yZ
         fEzg==
X-Gm-Message-State: AOAM531Pbs331ywisrrgrn+LkawIdGBG+PLA2pGe1HIfx/IPvEgTDLl+
        3ZPCTipBZHar4DSLXlET8m2vAb9h9PkNGyDrl85Lgjdvey/ltBmCXzbXtxkpKPkn34dCgAHAxOw
        xqRU6EzUyiXpViZpL4q2hF123GbF1
X-Received: by 2002:a05:651c:54d:: with SMTP id q13mr14095540ljp.498.1636709689306;
        Fri, 12 Nov 2021 01:34:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxPq5eZKYTUIJgtGo89zamrAE9TJk8OW8ctgHJM8VP8te70PDsioJzwZiAwfBx7HdIOawV5hHvaEzsGybltG8Y=
X-Received: by 2002:a05:651c:54d:: with SMTP id q13mr14095517ljp.498.1636709689060;
 Fri, 12 Nov 2021 01:34:49 -0800 (PST)
MIME-Version: 1.0
References: <20211110203322.1374925-1-farman@linux.ibm.com>
 <20211110203322.1374925-3-farman@linux.ibm.com> <dd8a8b49-da6d-0ab8-dc47-b24f5604767f@redhat.com>
 <ab82e68051674ea771e2cb5371ca2a204effab40.camel@linux.ibm.com>
 <32836eb5-532f-962d-161a-faa2213a0691@linux.ibm.com> <b116e738d8f9b185867ab28395012aaddd58af31.camel@linux.ibm.com>
 <85ba9fa3-ca25-b598-aecd-5e0c6a0308f2@redhat.com> <19a2543b24015873db736bddb14d0e4d97712086.camel@linux.ibm.com>
 <ff344676-0c37-610b-eafb-b1477db0f6a1@redhat.com> <006980fd7d0344b0258aa87128891fcd81c005b7.camel@linux.ibm.com>
In-Reply-To: <006980fd7d0344b0258aa87128891fcd81c005b7.camel@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Date:   Fri, 12 Nov 2021 10:34:37 +0100
Message-ID: <CADFyXm7XM96yUEU_5Xf-nT8D5E0+sji2AwfKCvr_yvx6fZrf2g@mail.gmail.com>
Subject: Re: [RFC PATCH v3 2/2] KVM: s390: Extend the USER_SIGP capability
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, KVM <kvm@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > Right, that's exactly what I had at one point. I thought it was too
> > > cumbersome, but maybe not. Will dust it off, pending my question to
> > > Janosch about 0-vs-1 IOCTLs.
> >
> > As we really only care about the SIGP STOP case,
>
> Is that really true? SIGP RESTART does an inject back to KVM, ditto the
> (INITIAL) CPU RESET orders. It's true that SIGP SENSE is getting
> tripped up on whether a vcpu is actually stopped or not, but I believe
> that SIGP SENSE saying "everything's fine" when a vcpu is still busy processing an order isn't great either.

The general rule is "if the guest can detect that it violates the
spec, it needs fixing".

That is true right now when a single VCPU does:

#1: SIGP STOP AND STORE #2
#1: SIGP SENSE #2

Because according to the spec, the SIGP SENSE has to return either
BUSY or indicated STOPPED. And if it indicates STOPPED, the STORE has
to be fully processed.


Can you construct something similar with SIGP INITIAL CPU RESET and
e.g., SIGP SENSE? From a single CPU not:

#1: SIGP INITIAL CPU RESET #2
#1: SIGP SENSE #2

As the SIGP INITIAL CPU RESET is processed fully asynchronous.

Can you come up with an example where using another VCPU we could
reliably detect a difference between

#1: SIGP INITIAL CPU RESET #2
#3: SIGP SENSE #2

and

#3: SIGP SENSE #2
#1: SIGP INITIAL CPU RESET #2

and

#3: SIGP SENSE #2 [and concurrent] #1: SIGP INITIAL CPU RESET #2

If yes, it needs fixing, if not, we can happily ignore it.

