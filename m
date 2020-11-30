Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860982C8F37
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 21:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388502AbgK3Uaf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 15:30:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38867 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728687AbgK3Uae (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 15:30:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606768147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dEMeF3AMNMcYI65aSQplkoFbo+sAWz3Tjmr7jvdlwP0=;
        b=QUCbwcOhQXqqFINSTELUhxXduDK9UrBhN6UxFJByEmQgIJwGxDKhvMadorz1AT1edjQhnH
        FSqP/dHfeySKzb2lEIc3KBF1tkbtknwou7xrDN/0QaU2iUVd0m0YQhige7RwB8lwJR+sdH
        3zBGUGbXKT849AFEJQWukZvJVNCqKxc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-115-DMSrmn35MvGXpVVMc6SBRg-1; Mon, 30 Nov 2020 15:29:05 -0500
X-MC-Unique: DMSrmn35MvGXpVVMc6SBRg-1
Received: by mail-ed1-f70.google.com with SMTP id g1so7357728edk.0
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 12:29:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dEMeF3AMNMcYI65aSQplkoFbo+sAWz3Tjmr7jvdlwP0=;
        b=aUa1xDpr6Suj/rL0OCSM5Kjbpl+mcsQz1lM79kcIni1fbcIueK9xBQNGCbqcoIXZXp
         oczz/hWduCG+FKTX8OYcltwksgYQwbIo0+VbU/t9YELSMYfa1nRcDPwREXTNQizQbrXc
         GGXUDpvr4TloTjdBflRl0BdCrDd+KvXJeinB5/XXPicI0pB4/lHyCUPHJ6Nsyf/FMjME
         PNuDI0URE3HVeVRF+B6DoTWBRn332whtD1kPQfur7PmKPCzMoedoejie1G0pJqrORxiy
         yyN7817pf+yzMv8CjAWjQNR9ufsyQW4Zrb0uLez4t1wOX1jvIBjckGMwreSHGPLOY+DH
         +JcQ==
X-Gm-Message-State: AOAM533Im/Q32fhTuPYpp7sKResKdMhAeQcQRxBfIuy17Cj997E9CnFF
        mBnGBw5pLGQhV7TCUDySPhKP6dX28CDfMoInSTR5CqOyfjtx9uKegF+mCYm6KIoVArYAxe09EB3
        J9BfMFkJqluLS
X-Received: by 2002:a05:6402:2070:: with SMTP id bd16mr11170003edb.107.1606768144692;
        Mon, 30 Nov 2020 12:29:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxg9IglFIMQ0ZSm6k1KLj+p3mu5WZxF5QG0J+89nlaTxpR4umWpnoGsGHhv67ElcSjdL8GU8g==
X-Received: by 2002:a05:6402:2070:: with SMTP id bd16mr11169987edb.107.1606768144486;
        Mon, 30 Nov 2020 12:29:04 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id a13sm2400959edb.76.2020.11.30.12.29.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 12:29:03 -0800 (PST)
Subject: Re: [PATCH AUTOSEL 5.9 22/33] vhost scsi: add lun parser helper
To:     Mike Christie <michael.christie@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
References: <20201125153550.810101-1-sashal@kernel.org>
 <20201125153550.810101-22-sashal@kernel.org>
 <25cd0d64-bffc-9506-c148-11583fed897c@redhat.com>
 <20201125180102.GL643756@sasha-vm>
 <9670064e-793f-561e-b032-75b1ab5c9096@redhat.com>
 <20201129041314.GO643756@sasha-vm>
 <7a4c3d84-8ff7-abd9-7340-3a6d7c65cfa7@redhat.com>
 <20201129210650.GP643756@sasha-vm>
 <e499986d-ade5-23bd-7a04-fa5eb3f15a56@redhat.com>
 <20201130173832.GR643756@sasha-vm>
 <238cbdd1-dabc-d1c1-cff8-c9604a0c9b95@redhat.com>
 <9ec7dff6-d679-ce19-5e77-f7bcb5a63442@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4c1b2bc7-cf50-4dcd-bfd4-be07e515de2a@redhat.com>
Date:   Mon, 30 Nov 2020 21:29:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <9ec7dff6-d679-ce19-5e77-f7bcb5a63442@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/11/20 20:44, Mike Christie wrote:
> I have never seen a public/open-source vhost-scsi testsuite.
> 
> For patch 23 (the one that adds the lun reset support which is built on
> patch 22), we can't add it to stable right now if you wanted to, because
> it has a bug in it. Michael T, sent the fix:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/commit/?h=linux-next&id=b4fffc177fad3c99ee049611a508ca9561bb6871
> 
> to Linus today.

Ok, so at least it was only a close call and anyway not for something 
that most people would be running on their machines.  But it still seems 
to me that the state of CI in Linux is abysmal compared to what is 
needed to arbitrarily(*) pick up patches and commit them to "stable" trees.

Paolo

(*) A ML bot is an arbitrary choice as far as we are concerned since we 
cannot know how it makes a decision.

