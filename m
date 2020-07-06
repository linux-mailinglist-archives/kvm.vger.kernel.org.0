Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB44215C96
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 19:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729521AbgGFRFl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 13:05:41 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:30927 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729495AbgGFRFk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Jul 2020 13:05:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594055138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xHW+rYY0Q8vu0hEfh8n5Hoh1YU5C8a7qUY2OrcJ3VUA=;
        b=bzJBCpacc243oxbCTI97GGVTudpaYA09jptRWWTBdpS0+WqSbO8ApkV/4Avkp1wEwNZ6v/
        HYleEAg1Azngglet8r/y3+0wuVFd/7Yg4GpqcrbLZB4elzcIl9UV71R1PZhJNChCdx5F6I
        0Gmie7vqqWBXzhRPJy2P7g5fUJ820uw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-uNpf8KcaNGa0sH9LFlhG3Q-1; Mon, 06 Jul 2020 13:05:34 -0400
X-MC-Unique: uNpf8KcaNGa0sH9LFlhG3Q-1
Received: by mail-wm1-f70.google.com with SMTP id 65so28414684wmd.8
        for <kvm@vger.kernel.org>; Mon, 06 Jul 2020 10:05:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xHW+rYY0Q8vu0hEfh8n5Hoh1YU5C8a7qUY2OrcJ3VUA=;
        b=McD95ojV0CT7HJ5gyHT1sP3kUcuJYNpTLtbK5VYpuiNa0l0eISpvUournkb6OJZAYl
         sKFO+QqPEkfKhip3uGLyPrkipWk3n8ZaeMNXX6OLRixR9DIkWToW9HmbVUKFcd3AnRvj
         6sLNLcEqj2OMF41r9ctmDmwRa08j3dW9IY8fBzMzV+Xy2Ft0tVZVKDstG98ZsoIGtAXs
         1IsEXrB3ZMB7pg75fD1l5G5uLgIfwbHARmyLOO43ZnlPOKBrFcI23Fhlhod5Ln5X18V8
         NdCReZq/LZCWNcyF0ijkgnX3/Gaou8Pwngtwkii2G8eAVjs+WBZu3N6274jpVAyeukS0
         zNdQ==
X-Gm-Message-State: AOAM533lkNDVPlfLa79ureA4xlNTl2DrtqUd+/Rsgp3+TmyIpKNRvRA3
        Y60uJXIpa2BfKcxGwge9laWLPf1uRIGsFXv/5vQdWk7R5PpD7pgQj6XzUIz5lDHqMVmKr7lXaL9
        n9uChM4q2mfU4
X-Received: by 2002:adf:8091:: with SMTP id 17mr37366090wrl.13.1594055132905;
        Mon, 06 Jul 2020 10:05:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxG4sDAwM7tZdeCLE5A4njYJEWbejVQHYTjYvOGEQWWlAiFhhT95RnAPUF4/X/qRguticHxFw==
X-Received: by 2002:adf:8091:: with SMTP id 17mr37366071wrl.13.1594055132726;
        Mon, 06 Jul 2020 10:05:32 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3181:5745:c591:c33e? ([2001:b07:6468:f312:3181:5745:c591:c33e])
        by smtp.gmail.com with ESMTPSA id z6sm86817wmf.33.2020.07.06.10.05.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2020 10:05:32 -0700 (PDT)
Subject: Re: [PATCH 0/2] KVM/arm64 fixes for 5.8, take #3
To:     Marc Zyngier <maz@kernel.org>
Cc:     Andrew Scull <ascull@google.com>,
        Andrew Murray <amurray@thegoodpenguin.co.uk>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
References: <20200706110521.1615794-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <aa4d3a7f-3b16-c113-0bed-a6fc4017ce0d@redhat.com>
Date:   Mon, 6 Jul 2020 19:05:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200706110521.1615794-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/07/20 13:05, Marc Zyngier wrote:
> git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.8-3

Pulled, thanks.

Paolo

