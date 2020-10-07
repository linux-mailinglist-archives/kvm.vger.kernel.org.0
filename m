Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB24128663A
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 19:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728528AbgJGRu2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 13:50:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39476 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728489AbgJGRu2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Oct 2020 13:50:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602093026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a54dLyoHfWLvYVfrDW9YKtGjscMrE+CPCU7zwIofNGM=;
        b=E0J8m/dYLOQCirsOIFSVXV4P133ueCE5kT3BalU1uZnAcDnRN5MeD0M265QU4UXT8R5FOw
        7QLKbxQ1qyB2M5NXSXTvlzGv9RXooldTOv+iNki9kGroa7qPo+dXJFzLSVvxJFzV4RiTaq
        mJBWZ3+hSuBF+9qkq+OUeAKqtRNp93Q=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-iNZny7KlOFq3uw2k1U50XA-1; Wed, 07 Oct 2020 13:50:24 -0400
X-MC-Unique: iNZny7KlOFq3uw2k1U50XA-1
Received: by mail-wm1-f70.google.com with SMTP id p17so1206210wmi.7
        for <kvm@vger.kernel.org>; Wed, 07 Oct 2020 10:50:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a54dLyoHfWLvYVfrDW9YKtGjscMrE+CPCU7zwIofNGM=;
        b=l6GtiYtJgF0g1P0JF8bsowKCMwqPuKiqUHrkiIgJtkpPWMEPl6bO4mj4fjfyX3JUls
         lcYNoCbpOVqLG/C5+bOx/pcIf5tZjc9Yk9BqFsSht5rwrMdnZqJeIhHGHAG2bD0PHsA9
         m2+p3HYQdi/bG0AZVyaZb4Bzoi2YK9r39/bwN6HIgZMJhv1sPwPt0Let42XAGIDwvndh
         8ZjUab905CuRM8/sSRHedJxLRKa6Ez1ZhPSUk4ULkUtkIw1jtnOcs4ceYhu5k0BlPEKH
         2woaof4zlF/0Z9RXqdJaGnX9bHQvQtgk1UK7ERNMF2kIV2Dl3abMomNDujsJF9S5dMlc
         8K8g==
X-Gm-Message-State: AOAM530JhD2s3xZog0c8+/Q5adtM0yOwMduqJwEP3JSqC/yz1pZDVgnG
        XaVnLN5aSN5wQdoFWo/9Xk+vNxNNc+NDTZo9hB2Oa9x2laZTHc6ChDtejOTJGVU7/LB8C1hr1ge
        zqYNkNmV60kob
X-Received: by 2002:a5d:6a85:: with SMTP id s5mr5068986wru.90.1602093022769;
        Wed, 07 Oct 2020 10:50:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw+KNtLI6Q/fyWROjeJM0mDYXTnMD0R+iAiJ5XgupNU6bUZjaCv9qjZyVDsi8DSRg0AvSX5+w==
X-Received: by 2002:a5d:6a85:: with SMTP id s5mr5068965wru.90.1602093022533;
        Wed, 07 Oct 2020 10:50:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d2f4:5943:190c:39ff? ([2001:b07:6468:f312:d2f4:5943:190c:39ff])
        by smtp.gmail.com with ESMTPSA id d30sm4079023wrc.19.2020.10.07.10.50.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2020 10:50:21 -0700 (PDT)
Subject: Re: KVM call for agenda for 2020-10-06
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     John Snow <jsnow@redhat.com>, qemu-devel <qemu-devel@nongnu.org>,
        kvm-devel <kvm@vger.kernel.org>,
        Markus Armbruster <armbru@redhat.com>,
        Daniel Berrange <berrange@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>
References: <874kndm1t3.fsf@secure.mitica>
 <20201005144615.GE5029@stefanha-x1.localdomain>
 <CAJSP0QVZcEQueXG1gjwuLszdUtXWi1tgB5muLL6QHJjNTOmyfQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8fce8f99-56bd-6a87-9789-325d6ffff54d@redhat.com>
Date:   Wed, 7 Oct 2020 19:50:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CAJSP0QVZcEQueXG1gjwuLszdUtXWi1tgB5muLL6QHJjNTOmyfQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/10/20 20:21, Stefan Hajnoczi wrote:
>     * Does command-line order matter?
>         * Two options: allow any order OR left-to-right ordering
>         * Andrea Bolognani: Most users expect left-to-right ordering,
> why allow any order?
>         * Eduardo Habkost: Can we enforce left-to-right ordering or do
> we need to follow the deprecation process?
>         * Daniel Berrange: Solve compability by introducing new
> binaries without the burden of backwards compability

I think "new binaries" shouldn't even have a command line; all
configuration should happen through QMP commands.  Those are naturally
time-ordered, which is equivalent to left-to-right, and therefore the
question is sidestepped.  Perhaps even having a command line in
qemu-storage-daemon was a mistake.

For "old binaries" we are not adding too many options, so apart from the
nasty distinction between early and late objects we're at least not
making it worse.

The big question to me is whether the configuration should be
QAPI-based, that is based on QAPI structs, or QMP-based.  If the latter,
"object-add" (and to a lesser extent "device-add") are fine mechanisms
for configuration.  There is still need for better QOM introspection,
but it would be much simpler than doing QOM object creation via QAPI
struct, if at all possible.						

Paolo

