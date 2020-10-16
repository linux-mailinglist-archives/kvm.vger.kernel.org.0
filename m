Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C00290A2D
	for <lists+kvm@lfdr.de>; Fri, 16 Oct 2020 19:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409241AbgJPRDD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Oct 2020 13:03:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46752 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407132AbgJPRDD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 16 Oct 2020 13:03:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602867782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KA6VYCrlOjuGwfTx1E12BCl4NAIpsZaoveAyYg/HzeA=;
        b=QHIWdjMx7VscKz8UM6W9582rRdEWkJ0A4IjE1YkjkRFkkMuJ5HGpR0wfhJA8pWQj/AXFiy
        LdLHlmo3b3v00YO6APZvlEAnWsWOKT1V1RheFkk4DMPDWH1E2mjc6tfel2imY1UA9r1YMr
        ldrYOI2EvHrlBYn9m9gvcRRzPw5kvDA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-LYd9rcRZPmCrO5OYbd5Kmw-1; Fri, 16 Oct 2020 13:03:00 -0400
X-MC-Unique: LYd9rcRZPmCrO5OYbd5Kmw-1
Received: by mail-wm1-f72.google.com with SMTP id m14so922740wmi.0
        for <kvm@vger.kernel.org>; Fri, 16 Oct 2020 10:02:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KA6VYCrlOjuGwfTx1E12BCl4NAIpsZaoveAyYg/HzeA=;
        b=rQm6tzsHrPSBPug94n37lOMM0/xsa4D4V55ZV9z3todeVDS/LQFom+KyoIJhPRr5Ze
         9UnexAWZ5ORppS0Xc7WdbKlRge95HnZhXcuCHH1E51/TWaBaaXCXZ4zKW6rpX1a9RP42
         Nl5Ogc2XfvZ5lpH7+ettNKrFc8BdT5ggEHCfzpGHFY6NMJNeSvyafnPLNO9W+NGsSu23
         AlWXNY+J6rGA70LPUiZKE6wsDVueLtQecZi/2a7IT8+bMlSfbxHz/DLcHbZXgqQLsiHb
         H3a689nqOp6hxkVMnDNhw9rw2doS4adHlg2AlSR4VhaS4yG/7KVebEn8Gu2UOkLRkrY9
         HctA==
X-Gm-Message-State: AOAM533b9+B2oqtRVn+1O6xAHKt8a/cK0vFvBV+yubWq4U+huUJHj6Vd
        qEaWo4zugG3aZrd1BRtdgkpVQGyWun7zP2Uf2Bl4L7wJKdYfXt0/yieyhqSKuyGaFBNSwVg8J7o
        lkRyW6hbpqt//
X-Received: by 2002:a1c:f604:: with SMTP id w4mr4722618wmc.87.1602867778742;
        Fri, 16 Oct 2020 10:02:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFjeI2syYj1RQDG45kQvMv6V3VqAgcVsdLxj81tHO37cQoffpvcEkRPhYKU+R3AoqbGNRQsQ==
X-Received: by 2002:a1c:f604:: with SMTP id w4mr4722599wmc.87.1602867778518;
        Fri, 16 Oct 2020 10:02:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4e8a:ee8e:6ed5:4bc3? ([2001:b07:6468:f312:4e8a:ee8e:6ed5:4bc3])
        by smtp.gmail.com with ESMTPSA id s11sm4082381wrm.56.2020.10.16.10.02.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2020 10:02:57 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCHv2] unittests.cfg: Increase timeout for apic
 test
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Po-Hsu Lin <po-hsu.lin@canonical.com>, kvm@vger.kernel.org
References: <20201013091237.67132-1-po-hsu.lin@canonical.com>
 <87d01j5vk7.fsf@vitty.brq.redhat.com>
 <20201015163539.GA27813@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1b9e716f-fb13-9ea3-0895-0da0f9e9e163@redhat.com>
Date:   Fri, 16 Oct 2020 19:02:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201015163539.GA27813@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/10/20 18:35, Sean Christopherson wrote:
> The port80 test in particular is an absolute waste of time.
> 

True, OTOH it was meant as a benchmark.  I think we can just delete it
or move it to vmexit.

Paolo

