Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33EF210D98F
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2019 19:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbfK2SUb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Nov 2019 13:20:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42946 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726985AbfK2SUb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Nov 2019 13:20:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575051630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3RzJvSlB/rfjy8jfdIVuXjQ5PpaWo8u1a5rnrJhVFPI=;
        b=FiAk+xrF8gu8j+wscQzymOw72Koh4A72fdsRltsmVcV4JpaA8OeQRz7QZxGypKdo/4unWj
        obNqF18fscUlI4klKux+K17KwVSUp9Q9ceOuaXOm6ofHb00HAauecLPgv5IV5RKN0AyQdp
        2kgT1N3vAgR4eMD+5UEoU4kSPq9rKKo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-v_xOjLAdPSWR3RHHiIO-yg-1; Fri, 29 Nov 2019 13:20:29 -0500
Received: by mail-wm1-f69.google.com with SMTP id y14so4560902wmj.9
        for <kvm@vger.kernel.org>; Fri, 29 Nov 2019 10:20:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3RzJvSlB/rfjy8jfdIVuXjQ5PpaWo8u1a5rnrJhVFPI=;
        b=krM4GUCIueHVMlbAEv9biJmAPt8HJ10u/M6QGoIV5LYXf5uU2dpdiAHPqYCpfuWeYn
         9Ozbx0i78nOK/M4TEhSFqHqjBbWDd8YRxs7iX727R1m4SDl4ayrKOPKC4kqDWgad2tez
         wtI8k+Oakva2TdyiTBQNrwjszj7c3c0NhimUpR2YfOEvAX9dXygm2nhpzNSnC/ljuZ3O
         EJY3CIOVvV5iNAZEqc69MtI2PUcm8CEhvBoMKtsY/t0nbKP0B4GlgK0FZeWyx1zbWAz7
         OXn2ZWasoJvrNtvBrslJ9JlxsdoTAMSTmmoJmmX1mimtb5neNODyG36REXLSGWfI9zMj
         Obiw==
X-Gm-Message-State: APjAAAVPzK+bcGnvaCUxJZ1zVugVcGlifNff2gNHI/p3To/6Q5scMXC8
        hddGd8ZjQ99sWinqUvMd6ZEkiqTg9+IFpbMHJXYItH8kErjpeO32mRc+yxmM8F6Gz7V3gQjRK5Q
        fleGSZSU3Lhi4
X-Received: by 2002:a05:6000:12c9:: with SMTP id l9mr21563823wrx.304.1575051628226;
        Fri, 29 Nov 2019 10:20:28 -0800 (PST)
X-Google-Smtp-Source: APXvYqx8E3ISRX1T2z8HQmp+PdaIrBNIJ9SYct+UrLVrq0/rqXXkSpqXcyBLTRTYHsfQ5TzYkCty1A==
X-Received: by 2002:a05:6000:12c9:: with SMTP id l9mr21563796wrx.304.1575051627946;
        Fri, 29 Nov 2019 10:20:27 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:56e1:adff:fed9:caf0? ([2001:b07:6468:f312:56e1:adff:fed9:caf0])
        by smtp.gmail.com with ESMTPSA id x13sm13853120wmc.19.2019.11.29.10.20.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Nov 2019 10:20:27 -0800 (PST)
Subject: Re: [GIT PULL v2] Please pull my kvm-ppc-uvmem-5.5-2 tag
To:     Paul Mackerras <paulus@ozlabs.org>, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>
References: <20191126052455.GA2922@oak.ozlabs.ibm.com>
 <20191128232528.GA12171@oak.ozlabs.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <91f667ee-0464-35f2-31cd-0bc661bf9edc@redhat.com>
Date:   Fri, 29 Nov 2019 19:20:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191128232528.GA12171@oak.ozlabs.ibm.com>
Content-Language: en-US
X-MC-Unique: v_xOjLAdPSWR3RHHiIO-yg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/11/19 00:25, Paul Mackerras wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-uvmem-5.5-2

Pulled, thanks.

Paolo

