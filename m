Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 339C9BDD06
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 13:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404543AbfIYLYR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 07:24:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53034 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389351AbfIYLYR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 07:24:17 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1AE728667D
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 11:24:17 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id 124so2546585wmz.1
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 04:24:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EFzOYLFm23RLu5W6Pgg+BUBRqwrz9rDREkbz/EyIZck=;
        b=hfwIGNCpNcLr/lJRhqyD7SIHUOPJQsvbwtZRGI0TBdNdkQ1VnTxJ+UxwqlZ5hVsHB3
         MrZQ8DQUhQn5vZTLXUGGvfOoRtk+yXlK37plkOdZ3sELQDALIFnCOuLhGdzuec+VotYs
         kkk/BMDVwThbKY4lO1zltiQ+AHEH+6Qvac454KAF6M/YX57uJMwBnfau8z5QGm4V3yjv
         +dQxYZhJxf/k2ssVm9TiswK/Dl7y/Q2xyctZTWo153xhtR45dmqmsIOGIR/KN3NMhA2i
         yrBXjkUTpp3qBE9L1sCI+wsl4iTsNpkL1ekIYBF9mWlKPEMZmgbXpv9LOHZ9VVUC2ags
         2sBw==
X-Gm-Message-State: APjAAAXy0cHPawJtNYf1iJoM4SuzCMzHEfeZ7E6EwZ3FaIqW9nw/qRZ0
        M426M2DDS+IGa7Pg2eoKrU+tq9J/DPgfuLTwRIkbyTuy0ZAjtqk22V1sWHTOeHFsC2PX6V2chix
        ZPsgbB02CPiZt
X-Received: by 2002:a7b:c188:: with SMTP id y8mr2178402wmi.51.1569410655753;
        Wed, 25 Sep 2019 04:24:15 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxmN9AV3evZVaNfej7ONIgDXC2fA+KDsddI3UJgfoVry3IOiWQY9NdXjHJUop8WPaGT2RVV4A==
X-Received: by 2002:a7b:c188:: with SMTP id y8mr2178369wmi.51.1569410655526;
        Wed, 25 Sep 2019 04:24:15 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id y5sm3904753wma.14.2019.09.25.04.24.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2019 04:24:15 -0700 (PDT)
Subject: Re: when to use virtio (was Re: [PATCH v4 0/8] Introduce the microvm
 machine type)
To:     David Hildenbrand <david@redhat.com>, Sergio Lopez <slp@redhat.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, imammedo@redhat.com,
        marcel.apfelbaum@gmail.com, rth@twiddle.net, ehabkost@redhat.com,
        philmd@redhat.com, lersek@redhat.com, kraxel@redhat.com,
        mtosatti@redhat.com, kvm@vger.kernel.org,
        Pankaj Gupta <pagupta@redhat.com>
References: <20190924124433.96810-1-slp@redhat.com>
 <c689e275-1a05-7d08-756b-0be914ed24ca@redhat.com> <87h850ssnb.fsf@redhat.com>
 <b361be48-d490-ac6a-4b54-d977c20539c0@redhat.com>
 <231f9f20-ae88-c46b-44da-20b610420e0c@redhat.com>
 <77a157c4-5f43-5c70-981c-20e5a31a4dd1@redhat.com>
 <a7001a14-3a50-b45e-a3fb-bee4c3b363db@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <92063179-559b-6dd9-9ec6-2b4e3d924e66@redhat.com>
Date:   Wed, 25 Sep 2019 13:24:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <a7001a14-3a50-b45e-a3fb-bee4c3b363db@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/09/19 12:50, David Hildenbrand wrote:
> Can't tell if there might be extensions (if virtio-mem ever comes to
> life ;) ) that might make use of asynchronous communication. Especially,
> there might be asynchronous/multiple guest->host requests at some point
> (e.g., "I'm nearly out of memory, please send help").

Okay, this makes sense.  I'm almost sold on it. :)

Config space also makes sense, though what you really need is the config
space interrupt, rather than config space per se.

Paolo

> So yes, currently we could live without the ring buffer. But the config
> space and the virtqueue are real life-savers for me right now :)

