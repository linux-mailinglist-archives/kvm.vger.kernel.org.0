Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC70C1C40AE
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 19:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729692AbgEDRCf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 13:02:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34746 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729459AbgEDRCe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 13:02:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588611753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DsuiJ3Bl4DYlwcJ0OMVfbSTOPgPDHtHw1erBIpHZk74=;
        b=ZmA84onEXF1RVLzshkZF8wEUEU5PxO4BoTZkqC1K2YEzBD/9Nn+T8291vqPOyOxQuQRQrA
        QtcqBolgfCzG+JENkqvtwdtmRgBl2dVyz1VcxNiF+pV1p5G+YobkFRGF2aBYgLYpWeEB4e
        IZw5mz6ZivI1ie8TsPLXD8tmQpNOpxk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-YZJ84WC8N16bJSTLf9ZbHw-1; Mon, 04 May 2020 13:02:31 -0400
X-MC-Unique: YZJ84WC8N16bJSTLf9ZbHw-1
Received: by mail-wm1-f72.google.com with SMTP id f17so121801wmm.5
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 10:02:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DsuiJ3Bl4DYlwcJ0OMVfbSTOPgPDHtHw1erBIpHZk74=;
        b=rYCFbO/OwklVBWaGOXPONwCJbklYVbKRzcwK/7tumZPGebWNRpbJ9BKEnE4pNPmd7c
         V4jdKm/EDVdRXFTFAnh7aq81iiRcEq+id0FYKBYcdZ7IMT8VCdwRCbj/bD3d7qkScfdi
         eIj/Q/RdPw8Pmr1nY/6rmqHnl2xb9gg4IDHqw2eCT2c8+a1PZuuSl6VrkNGznFXPSYwa
         dMbDyQYe5+IaJ8bgVpcO+0At4G33IUs9MpHlUEAIUa/eZ0n4JniNCqoM/8XS8jkImJ3V
         0AgPDNw8hO8deI336oSC5WlY7Ud/gsEVOHbN9WZekNk/hlbHNjQN2VAtE4aJeN1BgiQs
         s8nw==
X-Gm-Message-State: AGi0Pubm5m3wmeClqJbGxFDWUtKjRtilYwBZjZBDdr4n0zs6I0DFJwqD
        m94/NKHdNMOGqhUF98ZKjlFpVcqQWCu8GOT4b8M3NetdLmnBNsfRklwwCROVtC9hiu4N7dyPjIZ
        cTTjviORdF5nx
X-Received: by 2002:a5d:628e:: with SMTP id k14mr270957wru.390.1588611750792;
        Mon, 04 May 2020 10:02:30 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ/Yx8kOwELdCr6LNcodfCIoQBcpJd3XJQs7+YRpB/STWPwshDBcVODsO4ViVUHu2CMySHdIQ==
X-Received: by 2002:a5d:628e:: with SMTP id k14mr270926wru.390.1588611750534;
        Mon, 04 May 2020 10:02:30 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id h137sm1233255wme.0.2020.05.04.10.02.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 10:02:30 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm fixes for 5.7, take #2
To:     Will Deacon <will@kernel.org>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        Fangrui Song <maskray@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <20200501101204.364798-1-maz@kernel.org>
 <20200504113051.GB1326@willie-the-truck>
 <df78d984-6ce3-f887-52a9-a3e9164a6dee@redhat.com>
 <20200504165132.GA1833@willie-the-truck>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7e715659-112d-febd-91c8-385e272d2425@redhat.com>
Date:   Mon, 4 May 2020 19:02:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200504165132.GA1833@willie-the-truck>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/05/20 18:51, Will Deacon wrote:
>> 10 days is one week during which I could hardly work and the two
>> adjacent weekends.  So this is basically really bad timing in Marc's
>> first pull request, that he couldn't have anticipated.
> 
> Understood, and thanks for the quick reply. If possible, please just let us
> know in future as we can probably figure something out rather than having
> things sit in limbo.

Indeed, it was my fault.  I got stuck in a "1: tomorrow should be
better" / "no it was actually worse" / "goto 1b" loop.

Paolo

