Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B519F366E0
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2019 23:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbfFEVfv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jun 2019 17:35:51 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:39584 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbfFEVfv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jun 2019 17:35:51 -0400
Received: by mail-ed1-f65.google.com with SMTP id m10so43244edv.6
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2019 14:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3HJ2goV4jEKftWqAv0Grr7eo423VwLhYIaDyaqlSbT0=;
        b=nsvN7fZVAZ/h1eN5//77QOSHPdr3k1bT5mfH1g86/hqP1vblB/IlFq4rujjhkWszCV
         pehShCeBBH0GLDociLASh/YfXF5t7XGoBtqjTOm/8eh0S8MFJg6l98bYSZQ4TQE8g2P8
         h4mw2fwvTybozUZfNz160UxsUzVjYtCNKYgkxngdLIKEjmTwB6QMGb9cG1WwqItMbOc8
         S/CzDA1Uhqns2ue+7irTn55kE/WXwowEf/l2ls/EZWxiQO/UQ3GwsCxoWqn2LnB7OpCb
         nlEq6h9AtwkDWKNkZuvo0dhxaaLTRRCaaMZXfhAmFDeSuOYsdsDEhIThCA3wmR5qINPL
         3S6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3HJ2goV4jEKftWqAv0Grr7eo423VwLhYIaDyaqlSbT0=;
        b=JEDx4MrYGY9IMYKPrwPh3iAH2s/hyOFxQzSH8m23l5QWnEXtg54CKlnsxpXcaHoJjt
         sx3siaukSnAX8SUSlvT+VoQiLt+D0VpIi8IAhZL5VcvT0UncFC4Q87QpYL7jXHOLcVrB
         ufPTDOCmU2YDq4FLT6rK0FJaGNS7R74uUBkTw8aOROu2oHW4YU2kOswOqn/EnCS/rBpx
         3IIdcRxZWYgn5oh8hSRC8Rlz3AZXe+tIt0+c4g7KQy/l7x2Br812NArtWeWAjPAS+U6Y
         Pq91BpCfkisJTartIFHJl8NIclZutXisnCpsmQTU7lw7b84Fbpy0AC7PFQ6QFVfPnx8o
         KKvA==
X-Gm-Message-State: APjAAAWQSxL5MjHILND62M6yuaUPnJiLLk/GSYkuf2Gpvj3YfiW1TOPg
        xEKQ947RDpnGgpNKPjNSaATlxz5GLAT+C3MzI9xFZg==
X-Google-Smtp-Source: APXvYqyI5s0DX+4NUfu7c8ufRlIffx4Teze+/1Iqz/aV8rvaoU1qwpKV5uc6DbyfJmmlULXetjS8FUUK5RacZZvgKsU=
X-Received: by 2002:a50:f389:: with SMTP id g9mr45647001edm.130.1559770549632;
 Wed, 05 Jun 2019 14:35:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAOyeoRWfPNmaWY6Lifdkdj3KPPM654vzDO+s3oduEMCJP+Asow@mail.gmail.com>
 <5CEC9667.30100@intel.com> <CAOyeoRWhfyuuYdguE6Wrzd7GOdow9qRE4MZ4OKkMc5cdhDT53g@mail.gmail.com>
 <5CEE3AC4.3020904@intel.com> <CAOyeoRW85jV=TW_xwSj0ZYwPj_L+G9wu+QPGEF3nBmPbWGX4_g@mail.gmail.com>
 <5CF07D37.9090805@intel.com> <CAOyeoRXWQaVYZSVL_LTTdAwJOEr+eCzhp1=_JcOX3i6_CJiD_g@mail.gmail.com>
 <5CF2599B.3030001@intel.com> <CAOyeoRWuHyhoy6NB=O+ekQMhBFngozKoanWzArxgBk4DH2hdtg@mail.gmail.com>
 <5CF5F6AE.90706@intel.com> <CAOyeoRW5wx0F=9B24h29KkhUrbaORXVSoJufb4d-XzKiAsz+NQ@mail.gmail.com>
 <CAEU=KTHsVmrAHXUKdHu_OwcrZoy-hgV7pk4UymtchGE5bGdUGA@mail.gmail.com>
In-Reply-To: <CAEU=KTHsVmrAHXUKdHu_OwcrZoy-hgV7pk4UymtchGE5bGdUGA@mail.gmail.com>
From:   Eric Hankland <ehankland@google.com>
Date:   Wed, 5 Jun 2019 14:35:37 -0700
Message-ID: <CAOyeoRXFAQNNWRiHNtK3n17V0owBVNyKdv75xjt08Q_pC+XOXg@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: x86: PMU Whitelist
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     Cfir Cohen <cfir@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
        rkrcmar@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>> Right - I'm aware there are other ways of detecting this - it's still
>> a class of events that some people don't want to surface. I'll ask if
>> there are any better examples.

I asked and it sounds like we are treating all events as potentially
insecure until they've been reviewed. If Intel were to publish
official (reasonably substantiated) guidance stating that the PMU is
secure, then I think we'd be happy without such a safeguard in place,
but short of that I think we want to err on the side of caution.

Eric
