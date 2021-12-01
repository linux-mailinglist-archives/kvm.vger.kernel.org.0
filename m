Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0376465229
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 16:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351195AbhLAP6F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 10:58:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350990AbhLAP6D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 10:58:03 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EEC5C061574
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 07:54:42 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id t26so64052867lfk.9
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 07:54:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mvTtuysyQCI1n/oqJGGYBcob/YefOLkNXx9pXmlLQOU=;
        b=gGZyz8AEbKWulwrqym0HTU3OkuaPPJtecaG0GD22vJz5yqjmk8O1rH6zvW9beeVKOS
         racMMC7dIuXCxv7ctrnhYX6h+lRWfi+zDnT1T+zc9pFunu9oVEZW2EvCIK8H4iOsdvDH
         Up+O5jipF4CbMTV17o6prZM33ewJ5Da0tMnb+1u21UqzmPOykb8Ek8rNtthP+ni6G4iT
         e40mET9MAfIhL79MFv6X40Z349akKQz9uBLx6qQuUZyPqhNtUd+xiGefq1ga3xBQ+Tuc
         w3v3imPwF9oiyOvx+pMTU33nL4lngBOouZ5j25Uotf9wGWyuosDB5MfY37NVezmODNGj
         ujXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mvTtuysyQCI1n/oqJGGYBcob/YefOLkNXx9pXmlLQOU=;
        b=YHAyjzgy505pLPOtU6QH/jbOlLRTldhx/CE8Q/VQlpNcJUwPZSb1umVGeHmzNDJVlm
         0jN14kppun4lprxScJ3U7SDFBrUIxkaaQHyfXTB+9TxGNdXJl1umD67LCW/QVDo+EQlZ
         FsFOqpNYasTgYxx5RyX0HZFq4u3zkXkwZf/oQwv2v9sCu7x8fCxpLbT80Z27GeUhr0u9
         ugU76yiTPBp7+WG2eRERWXrC4oXWYAIl7lnz7xQa6G/WJ98lRvuz74e7kycwYIqc5Cze
         DkdIfFyUhm5INQRthuwgRsYzhisBxSGMMXjvbrtNUstjb3TEC9Nti+933xsriS/Lyjc8
         kVJQ==
X-Gm-Message-State: AOAM530VEpjUQFMzeZKDNg7QmI5rEnIfNIH4R3//gvMWznwGdX1dddDQ
        NX+Bc9ZLleFVTt9jvsEds1zTWSARr5Vo5J8/X3DGYg==
X-Google-Smtp-Source: ABdhPJy9YLJEVJOb1DOptKyECwI0us301AsNtFEhmcHCSxbXMpdayiHW+iyIukMr7Ch0XyJto2ma0t12zErJ9jQ32ps=
X-Received: by 2002:ac2:4ad9:: with SMTP id m25mr6757568lfp.193.1638374080289;
 Wed, 01 Dec 2021 07:54:40 -0800 (PST)
MIME-Version: 1.0
References: <20211123005036.2954379-1-pbonzini@redhat.com> <20211123005036.2954379-3-pbonzini@redhat.com>
In-Reply-To: <20211123005036.2954379-3-pbonzini@redhat.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Wed, 1 Dec 2021 08:54:28 -0700
Message-ID: <CAMkAt6p_9YR05T3TQH4abzAKXX3y_H46R60JZ2Qb_9idV5m1qg@mail.gmail.com>
Subject: Re: [PATCH 02/12] selftests: sev_migrate_tests: free all VMs
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 22, 2021 at 5:50 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Ensure that the ASID are freed promptly, which becomes more important
> when more tests are added to this file.
>
> Cc: Peter Gonda <pgonda@google.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Peter Gonda <pgonda@google.com>
