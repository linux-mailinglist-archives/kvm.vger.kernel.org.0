Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA47305D24
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 14:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313531AbhAZWgF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:36:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46903 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390654AbhAZRUA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 12:20:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611681501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nof8IdLrTxVaL/tx6R5htDiAQ8WfOqafWYYKwtoUQQk=;
        b=bZKIg+I8eBVWQXBtjMyuHy/sSF/X4uesALkfza3MyBjiHPAXXUDPfxpaR/ipW91edieckp
        ANZdUjSI60Gthg0F/dGzIA5Qat34KT6avY6U4Nmaskd842/KoaaP7vEjuJeAHg7bbE2BKp
        hsOo/GrA9aHYzdhe6SViX9A3mHXDQ98=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-530-l_yoZIHqOC-WVChzy03g9g-1; Tue, 26 Jan 2021 12:18:18 -0500
X-MC-Unique: l_yoZIHqOC-WVChzy03g9g-1
Received: by mail-ej1-f71.google.com with SMTP id ox17so5204298ejb.2
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 09:18:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nof8IdLrTxVaL/tx6R5htDiAQ8WfOqafWYYKwtoUQQk=;
        b=fC2K5x+J3I+ozzPwhv7H3NFp1Nq5wylI0VwbaRgFNGzRGlsQqlYoljsm+YFc3a3zFr
         n5kthn8Z458NoMnA6cfqD6HKURLLO5fFwQLKwDan+DBKr0vTMTIy/ogf6TAj180oXeh+
         DbMvIi9AWj5Zd0oyMZm8RS71Ca7MRyYEx85bFGCitB23YDo9XCnA8F91DXw/w/N50Vke
         yBlTscAlXM/tJn56MyNLYzMUuVxFzMv7kYWMPOh2s5XGIxWlQF7p6kQdouKzpn+LgDaJ
         iB5zoHMh5AfK+KlhRnCUfhZ7bFGC/mxkUdk0eE66sv8y6iblfVEUh6UzqpUo6vMQ6BU4
         Aulw==
X-Gm-Message-State: AOAM532tKN6fhlHqSWZ2f08PY6doPQX8VWavr/GDkpKONpfXY3ZaoIUZ
        cAlWuYQxLD7kW1OgCmOppJN3PY5kVUNUrMHmzl5FFMxYwIsCi2hUsVik15Cxw1kIRgaeevYr+KU
        lZrrs5TTcwLBX
X-Received: by 2002:a17:906:99c5:: with SMTP id s5mr4173023ejn.236.1611681497261;
        Tue, 26 Jan 2021 09:18:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxsIt0ePa151I+zh8Rc0nKVJkyzzkW03zZ9EAgjxV6dKtJcTYrF5+uTQAXpFuZFMCPy9hY9zg==
X-Received: by 2002:a17:906:99c5:: with SMTP id s5mr4173007ejn.236.1611681497082;
        Tue, 26 Jan 2021 09:18:17 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z20sm12790614edx.15.2021.01.26.09.18.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 09:18:16 -0800 (PST)
Subject: Re: [PATCH v4 0/6] Qemu SEV-ES guest support
To:     Tom Lendacky <thomas.lendacky@amd.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <cover.1601060620.git.thomas.lendacky@amd.com>
 <30164d98-3d8c-64bf-500b-f98a7f12d3c3@redhat.com>
 <b0c14997-22c2-2bfc-c570-a1c39280696b@amd.com>
 <946ac9e2-a363-6460-87a0-9575429d3b49@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <137ad1f2-8411-c0cd-4621-611d7f5d72d2@redhat.com>
Date:   Tue, 26 Jan 2021 18:18:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <946ac9e2-a363-6460-87a0-9575429d3b49@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/01/21 18:13, Tom Lendacky wrote:
> Also, the new version will have a prereq against another patch series that
> has not been accepted yet:
> 
>    [PATCH v2 0/2] sev: enable secret injection to a self described area in OVMF
> 
>    https://lore.kernel.org/qemu-devel/20201214154429.11023-1-jejb@linux.ibm.com/

David reviewed it today, so even if a v3 will be needed that shouldn't 
be a problem for SEV-ES itself.

Paolo

