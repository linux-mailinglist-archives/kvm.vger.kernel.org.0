Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F843D2765
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 12:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbfJJKnR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Oct 2019 06:43:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57824 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726304AbfJJKnP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Oct 2019 06:43:15 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CCA7B9AE9C
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2019 10:43:14 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id z205so2425120wmb.7
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2019 03:43:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E85BCGQmqVsmCuJEJ/4DUXdYmnYWuqddkfV+jB9bC0I=;
        b=EKE0osT1Z3r2T5rlQSTaoT6seN/XCeKfNhV+cKZd7TOpNGhw7SIb2oHZCROJ+n7blO
         PRWzSP2LKGMEbCyNxs4O7qgSRgLnP4+B8+NhasaNZrT+S/FuZ8fN3CQI0tlnPDbVw6IR
         X1KSQ5AtaF27e3tnYI9blPhAuE2I62YnBa4Zk1J9wElUXNn20qerjhXkoWH6DQAZ8TOT
         SQJNYnBz6Qa2Vlf10JYQtEB9+po56sxbdJnXmtowni1Ihe5tIp4yaNGeEp0qhk2EQaN4
         Cn9XqZJ9fnhEg9e1cXRASF52JLyRodVZKYdqZOZwyU1IwZHnMzeFj/eZmSunuB1JTF85
         L9Dw==
X-Gm-Message-State: APjAAAUfNsIT5q70XKmLbkzhveKIq4fuoR0L+RNviR1Qzx0FqAb8LN2n
        CsuOP8XIFCZ/lMabAuRiFs+6v7fn//Re/y+SjbIb5mm3mbFkxvEiy+oZRYgLL8l879bEnYdrFj1
        Y79dTppQz6KSJ
X-Received: by 2002:adf:9e02:: with SMTP id u2mr8269572wre.329.1570704193457;
        Thu, 10 Oct 2019 03:43:13 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxj+cNEr44B5+Ya5hop2TN6bpLeUDycV9++bm0c33NmD+aE03zGdR7jC6/ouvh33i25Mt2QWQ==
X-Received: by 2002:adf:9e02:: with SMTP id u2mr8269546wre.329.1570704193084;
        Thu, 10 Oct 2019 03:43:13 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a204sm7425238wmh.21.2019.10.10.03.43.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Oct 2019 03:43:12 -0700 (PDT)
Subject: Re: [RFC v2 0/2] kvm: Use host timekeeping in guest.
To:     Suleiman Souhlal <suleiman@google.com>, rkrcmar@redhat.com,
        tglx@linutronix.de
Cc:     john.stultz@linaro.org, sboyd@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        ssouhlal@freebsd.org, tfiga@chromium.org, vkuznets@redhat.com
References: <20191010073055.183635-1-suleiman@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <3120662b-9ea6-d86c-dc04-5f06a6e60afc@redhat.com>
Date:   Thu, 10 Oct 2019 12:43:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191010073055.183635-1-suleiman@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/10/19 09:30, Suleiman Souhlal wrote:
> 
> Changes in v2:
> - Move out of kvmclock and into its own clocksource and file.
> - Remove timekeeping.c #ifdefs.
> - Fix i386 build.

This is now pretty clean, so my objections are more or less gone.  I
haven't put much thought into this, but are all fields of struct
timekeeping necessary?  Some of them are redundant with the existing
wallclock MSRs.  The handling of versioning probably varies depending on
the exact set of fields, too.

Paolo
