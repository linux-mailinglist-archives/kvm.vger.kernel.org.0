Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292813E8ACB
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 09:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235109AbhHKHKO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 03:10:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22281 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234855AbhHKHKL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Aug 2021 03:10:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628665787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hoS/qp7odMiW1j0/xTIU4hbReBtSD40PKHL686RTz8k=;
        b=M5e/PEelLwpxkJyBAEOL0ZJ6yqVODd5iA9fmMSSLO1cZNhLnZ14WaNmjIcks0Wh65RHeOr
        F3Js2PPdP4LEx/d+PGnTH2fayA4oXCovKaHjqdlmOb3vjaaSlTtSoieMJKZFnHy5G/WJMk
        8gm6xAD7Dg595FXa0dEgHv2Uuwp/2pE=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-mcD3uf-YMJy6VzcExIkDcA-1; Wed, 11 Aug 2021 03:09:46 -0400
X-MC-Unique: mcD3uf-YMJy6VzcExIkDcA-1
Received: by mail-ed1-f69.google.com with SMTP id v11-20020a056402348bb02903be68e116adso748886edc.14
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 00:09:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hoS/qp7odMiW1j0/xTIU4hbReBtSD40PKHL686RTz8k=;
        b=BwbVTzy37uMbyPODJbWQr9f2gSbVlQWFDPeewhQwAyAFvIlo71im7j9M2uGjD2cfZm
         c2lSbPhRpaTTN+3JRYjDqrX9QhNvXEcekGGxlwQf5UP9hoiJM4rwtfrCB8SswuyoXnjC
         BLoLr0j9K9x8agUl/nCYwZWtJoGvCbbtxISE9gq2FpjriVQCqLF8VlIYQj+R21azHyqp
         yo+5Uta9bq7vYGUh6S8zKozD9X/N+cX/4oPhvxhUjP99TQB4wLj2fV0yFHsTDAp5GCto
         artirmaAJ3kZwR5JRPOog2cKY63zM+YxwJOf1Z+i2h69dP8wZ1wChTk+WAyUjeMDFFis
         HQjw==
X-Gm-Message-State: AOAM531YiJv63nQfR8QIzsB45KsXdx722E+Wkab/Kna+KjHGpw+441GB
        eyae0TryutbH9IJA7ZY2PO9SsCYoJZBwQNKuTpxy8NpDiFfkaFHzL7SEu45udU77jI6tPIXMOeH
        vUyZM+YzJlxNnJa6cFqDpoVvZMUVe8mZSQjr/O+ZWuRXCM1Sc1tZuhKcc3HVKpaYu
X-Received: by 2002:aa7:dcc2:: with SMTP id w2mr3607580edu.192.1628665784349;
        Wed, 11 Aug 2021 00:09:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzoI5/iQErvAAcBl2s9X9EI5NBkB9g2qn2e86IdzETHQDygFAyZP9ZbrnM9YYyPV3YqWlljvQ==
X-Received: by 2002:aa7:dcc2:: with SMTP id w2mr3607565edu.192.1628665784180;
        Wed, 11 Aug 2021 00:09:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id m21sm10569136edc.5.2021.08.11.00.09.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 00:09:43 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 1/2] x86: access: Fix timeout failure by
 limiting number of flag combinations
To:     Babu Moger <babu.moger@amd.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     thuth@redhat.com, drjones@redhat.com, kvm@vger.kernel.org
References: <162826604263.32391.7580736822527851972.stgit@bmoger-ubuntu>
 <162826611747.32391.16149996928851353357.stgit@bmoger-ubuntu>
 <YQ1pA9nN6DP0veQ1@google.com> <1f30bd0f-da1b-2aa0-e0c8-76d3b5410bcd@amd.com>
 <7d0aa9b1-2eb7-8c89-9c2b-7712c5031aed@amd.com>
 <4af3323d-90e9-38a0-f11a-f4e89d0c0b50@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b348c0f6-70fa-053f-86fa-8284b7bc33a4@redhat.com>
Date:   Wed, 11 Aug 2021 09:09:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <4af3323d-90e9-38a0-f11a-f4e89d0c0b50@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/08/21 01:38, Babu Moger wrote:
> No. This will not work. The PKU feature flag is bit 30. That is 2^30
> iterations to cover the tests for this feature. Looks like I need to split
> the tests into PKU and non PKU tests. For PKU tests I may need to change
> the bump frequency (in ac_test_bump_one) to much higher value. Right now,
> it is 1. Let me try that,

The simplest way to cut on tests, which is actually similar to this 
patch, would be:

- do not try all combinations of PTE access bits when reserved bits are set

- do not try combinations with more than one reserved bit set

Paolo

