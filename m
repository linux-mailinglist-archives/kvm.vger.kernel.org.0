Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6470244E3E8
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 10:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234763AbhKLJjB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 04:39:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46177 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234730AbhKLJjA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Nov 2021 04:39:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636709770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3RS0GDdXEcb4iOfoVt7xdPZJYdb+hs05OLDjMHPHMII=;
        b=dilwaif43SwodWPdvxgGMFp8JcaHDo0jYIDzPPJ1ajqvEReZXUEc30ayxRf/YQD9NZJWWb
        aCaEaDDTz4fs60UVzTG+q9Fjdj2qF0yOJY4DC2SArc/NgTWg6Uu0hzT+TOJ5z0hHPucTBD
        pR4OD3SFnGYdEmyyxT9gKgDcrq3CZ8U=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-Qq9FzujMMVutlg3P4wsIXg-1; Fri, 12 Nov 2021 04:36:08 -0500
X-MC-Unique: Qq9FzujMMVutlg3P4wsIXg-1
Received: by mail-lf1-f69.google.com with SMTP id w2-20020a0565120b0200b004036bc9597eso3542574lfu.14
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 01:36:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3RS0GDdXEcb4iOfoVt7xdPZJYdb+hs05OLDjMHPHMII=;
        b=ePG/AHLmfTnPrPs9rGriC/SEHPnV7/1bFj4immIDL9QO7cQE/+H+DN4ZugmKaZBPP1
         DiTnsC6IXbH67wUc7GiNJAoENGPffSc7nvhVZQiGOg5+OCoFCb28b1dBYA3MnoD2xV+d
         VGEsdPdOghNReOkR5+bcWNzkUkWOnwshvhDPTBggH/5ppoZUc+uCtHia7OqkFX8fzxOG
         QmD928idh4hZPOJi2pyHYSi6t9n5RNmU1Nh1JqGQjC2pzXZRSW5dsdZhLGIb5Un8W/Hi
         Z89YyYiCkAj1xsE/pyBF+wkwxxndOC3+s1gI8099JsbyB8KmvgPZg4Df7NmjtSHF20Wh
         RQWA==
X-Gm-Message-State: AOAM533E6cJiwNxhVjhUjxVppULUUv4LN8iXkpxzGQDsBeszVU+AkwCj
        863BPbRKaIcxDzbOmGpgan7NaaJH/0TA2hHesrFgWoFD3V4luYISXkdJHBWTHCRjnHgN4Z7H3tc
        E5nLwGI0UoDD8DQjf+BfyVQjLZf8J
X-Received: by 2002:a2e:b88c:: with SMTP id r12mr10592838ljp.294.1636709766790;
        Fri, 12 Nov 2021 01:36:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJywvQLolUByNPBH2qOskivToNkP9OLC11Nnm+CW99rjkulOvlghOU/pbqG3fNXJml7WfM1mC6TAPlLWpCU4myk=
X-Received: by 2002:a2e:b88c:: with SMTP id r12mr10592820ljp.294.1636709766635;
 Fri, 12 Nov 2021 01:36:06 -0800 (PST)
MIME-Version: 1.0
References: <20211110203322.1374925-1-farman@linux.ibm.com>
 <20211110203322.1374925-3-farman@linux.ibm.com> <dd8a8b49-da6d-0ab8-dc47-b24f5604767f@redhat.com>
 <ab82e68051674ea771e2cb5371ca2a204effab40.camel@linux.ibm.com>
 <32836eb5-532f-962d-161a-faa2213a0691@linux.ibm.com> <b116e738d8f9b185867ab28395012aaddd58af31.camel@linux.ibm.com>
 <85ba9fa3-ca25-b598-aecd-5e0c6a0308f2@redhat.com> <19a2543b24015873db736bddb14d0e4d97712086.camel@linux.ibm.com>
 <ff344676-0c37-610b-eafb-b1477db0f6a1@redhat.com> <006980fd7d0344b0258aa87128891fcd81c005b7.camel@linux.ibm.com>
 <CADFyXm7XM96yUEU_5Xf-nT8D5E0+sji2AwfKCvr_yvx6fZrf2g@mail.gmail.com>
In-Reply-To: <CADFyXm7XM96yUEU_5Xf-nT8D5E0+sji2AwfKCvr_yvx6fZrf2g@mail.gmail.com>
From:   David Hildenbrand <david@redhat.com>
Date:   Fri, 12 Nov 2021 10:35:55 +0100
Message-ID: <CADFyXm5erJL4XBPDy2Xv94JNH1z88_etEer-UtJC_TTD1T-yEA@mail.gmail.com>
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

>
> #1: SIGP INITIAL CPU RESET #2
> #1: SIGP SENSE #2
>
> As the SIGP INITIAL CPU RESET is processed fully asynchronous.

I meant to say "fully synchronous".

