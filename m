Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28602190CCA
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 12:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbgCXLxU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 07:53:20 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:30732 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727066AbgCXLxU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 07:53:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585050799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=wfFMmvog0HwQoQQXWKqcxADUt2iyOQbn+yPURpof0w0=;
        b=S7cXRxcCwZG2hIhlbZG8U75qb1k8fL/jEyNPbUViFspDIKUYIaNoNVocnjn7Wl+5sJg3QD
        3RaTB2YNEgGmk02UfAXV+ji3kYOnxT5V7ZRpMV166KhKxWsQH2drKQ56VFjESdGxoR+5hD
        NEvICflFg+eJn4514M4x7VSu3EIv3Ks=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-isKqPkc5MhGekSUBqXsOSQ-1; Tue, 24 Mar 2020 07:53:15 -0400
X-MC-Unique: isKqPkc5MhGekSUBqXsOSQ-1
Received: by mail-wr1-f72.google.com with SMTP id e10so7348194wru.6
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 04:53:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=wfFMmvog0HwQoQQXWKqcxADUt2iyOQbn+yPURpof0w0=;
        b=YeVYpz0EdZy5UvPZNJhAEk8gOig7oENbQGw7AJstjFRSoJgTjXkiiaCEB/WCizyDbI
         /78jixDjBVMnwqaOznavoicMUS8ke6V6ZX2wjSkP0M3ugetEcXsevs9+hR6dA8srNmaD
         Il+lSM7vSiq8P3/Z1g0c/YtHpAqP5MdOi/OCczYKiFcTeCzEwhGJX2sJjxCKTaiqT9pa
         lxkhrRF00G0o4zm3R0hutY81M+9ihCr4zHM2tr23p07DTOwJUkjDGBofiEVmR5ilt9Zg
         Quy9Z3VHinaalL9xNRouC/dQhtD0rkl0h9TdLI6NgTILaeYEEH9fDO540Kze3sENIX3I
         14jg==
X-Gm-Message-State: ANhLgQ2Yqp2MpW9Iej85Zl5M0a+qnwiJyQT+16YhCIGlXhsDVB3fXpWR
        f+cKcANxx5+8te4sGr0Veeq1gLxkRQKoDnQmWjxadd+tn+wQh6dpbHzs89cABEQQ6C1ccBN0GQo
        ir7r2TnnIfFbY
X-Received: by 2002:adf:f309:: with SMTP id i9mr38814190wro.0.1585050793797;
        Tue, 24 Mar 2020 04:53:13 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtbB7Ugfql3p5+QzK87p6dDRyvlSmOgljKcGW0XgFEN92K++Jp1PvoDq//jYA7E/CjK51908A==
X-Received: by 2002:adf:f309:: with SMTP id i9mr38814152wro.0.1585050793574;
        Tue, 24 Mar 2020 04:53:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7848:99b4:482a:e888? ([2001:b07:6468:f312:7848:99b4:482a:e888])
        by smtp.gmail.com with ESMTPSA id b5sm27672105wrj.1.2020.03.24.04.53.12
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2020 04:53:13 -0700 (PDT)
To:     KVM list <kvm@vger.kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: status of kvm.git
Message-ID: <ba6573bd-274e-3629-92f0-77eb5b82ac40@redhat.com>
Date:   Tue, 24 Mar 2020 12:53:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I queued pretty much everything I planned to have in 5.7.  I'll need to
run a lot of tests, so it may take a few days before everything gets in
kvm/next.  (I'm also working part time-ish right now, fortunately tests
can run while I'm not attending).  I have a few kvm-unit-tests patches
to apply, those are independent of this and I'll get to them soon.

Pull requests for other architectures are always welcome of course.

For 5.8 I'd rather tone down the cleanups and focus on the new processor
features (especially CET and SPP) and on nested AMD unit tests and bugfixes.

Paolo

