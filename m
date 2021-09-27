Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81552418FAA
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 09:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233204AbhI0HHN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 03:07:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28142 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233140AbhI0HHM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Sep 2021 03:07:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632726335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BVQ6zu4QY47K6PthGpGHBmifKAlYmIBnBfu6H5FHpXg=;
        b=KYNqhSOyB27xTtgTT66kpTR9H/uRQtoUNTNPHOjv0tLjWCRKlcJ+fikxPSeVpEWxN6Y+Vj
        nju3zCMwMZ0vc44fUMZV84dam6fXLGW/KpzQSS1PbdlQ3X97o4mwsJwmEalsW2STDL49AN
        F9+d8xdI8DWplxwzPc0+F26vvzFlqjg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-02_sXtzpPHOksEw68bguyg-1; Mon, 27 Sep 2021 03:05:33 -0400
X-MC-Unique: 02_sXtzpPHOksEw68bguyg-1
Received: by mail-wr1-f72.google.com with SMTP id f11-20020adfc98b000000b0015fedc2a8d4so13580428wrh.0
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 00:05:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BVQ6zu4QY47K6PthGpGHBmifKAlYmIBnBfu6H5FHpXg=;
        b=Q/wSP1P+XuiWu/oY9M1eLxWI685zzUbjerdDyPheAA6Cs7SOQEVpbi+er3Vpz6ynhf
         nI5uyFER9g4IzlRH9cDsrcc4UOkb5kF/zQpA/gPfLsnwCv23hROOV0/btA3cFpAJ/uxv
         7voL2H5kK0LBOzLtQBrepJgIE1Dv5RnzqzHOBCa8N123aleEclwM4neC/ySKyNFBiSQN
         7TJVgFoGQn/zVAQeeHa8TV8N8mxmxNlz6Nj7mPVnmjRauVSRt6r2NEEAwaQ35gv+APSl
         OcWh2Q/ni8qTnCMJlu3mMUifTwCz0iNR/cx3e+md2ATFBC0wlwcjNrdo4MzS8oHxKlTm
         A88g==
X-Gm-Message-State: AOAM530Pb+VYdqaSNwl3IAvOPjWQm8cwtv3Q35W7BkTT9Uc3IZivutx+
        KOyuxCJKQbITdc64AkJNrd2s6s/UzO6HNAwtntE2NWO7RupWeGfwy+o8vi3D5YgZIYEZgZDAgEY
        Xs+bvtbmf4pN5
X-Received: by 2002:a7b:cb49:: with SMTP id v9mr13856805wmj.76.1632726332440;
        Mon, 27 Sep 2021 00:05:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxCckzjnZQn338laSkd0/RD3tlR3GueyXlRVWs97GgEPQtXWIgqVx7BctqXe5P1nPjbXeQcCw==
X-Received: by 2002:a7b:cb49:: with SMTP id v9mr13856783wmj.76.1632726332222;
        Mon, 27 Sep 2021 00:05:32 -0700 (PDT)
Received: from thuth.remote.csb (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id k22sm16486957wrd.59.2021.09.27.00.05.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 00:05:31 -0700 (PDT)
Subject: Re: [PATCH v15] qapi: introduce 'query-x86-cpuid' QMP command.
To:     Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        Valeriy Vdovin <valery.vdovin.s@gmail.com>,
        qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Denis Lunev <den@openvz.org>,
        Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
References: <20210816145132.9636-1-valery.vdovin.s@gmail.com>
 <24143eb0-9ab4-bcf7-94e7-32037ad49b2e@virtuozzo.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <02ca90a5-9f2f-4385-d5ae-8bd023b367fc@redhat.com>
Date:   Mon, 27 Sep 2021 09:05:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <24143eb0-9ab4-bcf7-94e7-32037ad49b2e@virtuozzo.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/09/2021 09.41, Vladimir Sementsov-Ogievskiy wrote:
> Ping.
> 
> Hi! Any chance for this to land?

Sorry if I missed the outcome of the discussion - but what about the idea to 
introduce this with a "x-" prefix first, since there was no 100% certainty 
that we really fully want to support this command in the current fashion?

  Thomas


